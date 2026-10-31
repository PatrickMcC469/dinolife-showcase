extends RefCounted

const LIFE_STORY = preload("res://scripts/systems/life_story.gd")
const CONDITIONS = {
	"drought": {"title": "Drought", "detail": "Dry ground makes grazing and finding water harder. Each season uses 3% extra food.",
		"flavor": "The drought carries into another season. Cracked banks mark where the water used to reach.", "graze": -0.05, "water": -0.06},
	"flood": {"title": "Flooded lowlands", "detail": "Floodwater makes hunting, water searches and territory claims harder. Fresh growth improves grazing.",
		"flavor": "Floodwater still covers the low trails. New shoots rise on the banks above it.", "hunt": -0.04, "water": -0.04, "territory": -0.04, "graze": 0.04},
	"shortage": {"title": "Food shortage", "detail": "Thin prey and stripped feeding grounds make hunting, grazing and foraging harder.",
		"flavor": "Tracks lead away from the feeding grounds. The food shortage has outlasted the first lean season.", "hunt": -0.05, "graze": -0.05, "scavenge": -0.05},
	"rivals": {"title": "Rival pressure", "detail": "Other groups crowd the feeding grounds. Hunting, grazing and territory claims are harder.",
		"flavor": "Fresh calls and unfamiliar tracks cross your range. The rival groups are still here.", "hunt": -0.03, "graze": -0.03, "territory": -0.06},
}


static func restore(value: Variant) -> Dictionary:
	if not value is Dictionary:
		return {}
	var state: Dictionary = {}
	state["kind"] = value.get("kind", "") if value.get("kind", "") in CONDITIONS or value.get("kind", "") == "" else ""
	for key in ["until", "cooldown", "last_tick"]:
		var number = value.get(key, -1)
		state[key] = int(number) if number is int or number is float else -1
	return state


static func kind() -> String:
	if GameState.life_stage == 0 or GameState.seasons_elapsed >= int(GameState.world_state.get("until", -1)):
		return ""
	return str(GameState.world_state.get("kind", ""))


static func begin(condition: String) -> void:
	if condition not in CONDITIONS:
		return
	GameState.world_state = {"kind": condition, "until": GameState.seasons_elapsed + 3,
		"cooldown": GameState.seasons_elapsed + 5, "last_tick": GameState.seasons_elapsed}
	LIFE_STORY.remember("world_%s_%d" % [condition, GameState.seasons_elapsed],
		"%s changed the range for three seasons." % CONDITIONS[condition]["title"], 5)


static func tick() -> void:
	var season := GameState.seasons_elapsed
	if int(GameState.world_state.get("last_tick", -1)) == season:
		return
	GameState.world_state["last_tick"] = season
	if GameState.life_stage == 0:
		return
	var previous := str(GameState.world_state.get("kind", ""))
	if not previous.is_empty():
		if season < int(GameState.world_state.get("until", -1)):
			return
		GameState.world_state["kind"] = ""
		LIFE_STORY.remember("world_cleared_%d" % season, "%s eased; the range opened again." % CONDITIONS[previous]["title"], 4)
	if season < int(GameState.world_state.get("cooldown", 2)) or randf() >= 0.25:
		return
	var pool: Array = [["flood", "rivals"], ["drought", "shortage"], ["rivals", "shortage"], ["shortage", "rivals"]][GameState.current_season]
	begin(pool.pick_random())


static func modifier(action: String) -> float:
	var amount := float(CONDITIONS.get(kind(), {}).get(action, 0.0))
	amount += preload("res://scripts/systems/habitat_conditions.gd").modifier(action)
	var story: Dictionary = GameState.journey_state
	if GameState.seasons_elapsed < int(story.get("reward_until", -1)):
		if action in ["hunt", "graze", "scavenge"]:
			amount += float(story.get("reward", 0.0))
		elif action == "territory" and story.get("kind") == "territory":
			amount += float(story.get("reward", 0.0))
	return amount + preload("res://scripts/systems/discoveries.gd").modifier(action) + preload("res://scripts/systems/living_world.gd").modifier(action) + preload("res://scripts/systems/perks.gd").modifier(action)


static func extra_hunger() -> float:
	return (0.03 if kind() == "drought" else 0.0) + preload("res://scripts/systems/living_world.gd").cold_cost()


static func summary() -> String:
	var condition := kind()
	if condition.is_empty():
		return "The range is settled."
	var remaining := int(GameState.world_state["until"]) - GameState.seasons_elapsed
	return "%s · %d season%s remaining" % [CONDITIONS[condition]["title"], remaining, "" if remaining == 1 else "s"]


static func detail() -> String:
	return str(CONDITIONS.get(kind(), {}).get("detail", "No lasting world condition is affecting your actions."))


static func flavor() -> String:
	return str(CONDITIONS.get(kind(), {}).get("flavor", ""))
