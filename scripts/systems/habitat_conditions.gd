extends RefCounted

const SITES = ["ridge", "river", "grove"]


static func restore(value: Variant) -> Dictionary:
	if not value is Dictionary: return {}
	var state := {"sites": {}, "last_tick": -1, "scouted": "", "scout_season": -1}
	for key in ["last_tick", "scout_season"]:
		state[key] = clampi(int(_number(value.get(key), -1)), -1, GameState.seasons_elapsed)
	state["scouted"] = value.get("scouted", "") if value.get("scouted", "") in SITES else ""
	var sites = value.get("sites", {})
	if sites is Dictionary:
		for site in SITES:
			if sites.get(site) is Dictionary:
				state["sites"][site] = {"food": clampi(int(_number(sites[site].get("food"), 2)), 0, 4), "pressure": clampi(int(_number(sites[site].get("pressure"), 0)), 0, 2)}
	return state


static func _number(value: Variant, fallback: float) -> float:
	return float(value) if (value is float or value is int) and is_finite(float(value)) else fallback


static func at(site: String) -> Dictionary:
	return GameState.habitat_state.get("sites", {}).get(site, {"food": 2, "pressure": 0})


static func tick() -> void:
	if GameState.life_stage < 1 or GameState.health <= 0 or int(GameState.habitat_state.get("last_tick", -1)) == GameState.seasons_elapsed: return
	var home := str(GameState.living_state.get("site", ""))
	var sites: Dictionary = GameState.habitat_state.get("sites", {})
	var weather := str(GameState.world_state.get("kind", "")) if GameState.seasons_elapsed < int(GameState.world_state.get("until", -1)) else ""
	for index in SITES.size():
		var site: String = SITES[index]
		var local := at(site).duplicate()
		local["food"] = clampi(int(local["food"]) + (-1 if site == home or weather in ["drought", "shortage"] else 1), 0, 4)
		# A three-season local cycle makes pressure move between places without rerolling on reads.
		local["pressure"] = (int(GameState.seasons_elapsed / 3) + index) % 3
		sites[site] = local
	GameState.habitat_state["sites"] = sites
	GameState.habitat_state["last_tick"] = GameState.seasons_elapsed


static func pressure(site: String) -> int:
	var amount := int(at(site)["pressure"])
	if GameState.habitat_state.get("scouted") == site and int(GameState.habitat_state.get("scout_season", -1)) == GameState.seasons_elapsed: amount = maxi(0, amount - 1)
	return amount


static func feeding(site: String) -> float:
	return (int(at(site)["food"]) - 2) * 0.01 - pressure(site) * 0.01


static func modifier(action: String) -> float:
	var site := str(GameState.living_state.get("site", ""))
	if site not in SITES or GameState.life_stage < 1: return 0.0
	if action in ["hunt", "graze", "scavenge"]: return feeding(site)
	if action == "territory": return -pressure(site) * 0.01
	return 0.0


static func detail(site: String) -> String:
	var stock: int = at(site)["food"]
	var danger := pressure(site)
	var text := "%s · %s\nLocal effect: %+.0f points to feeding chance; −%d to range claims. Adds to location and weather effects." % [["Stripped ground", "Thin food", "Steady food", "Recovering food", "Abundant food"][stock], ["Quiet trails", "Fresh predator tracks", "Predators nearby"][danger], feeding(site) * 100, danger]
	if GameState.habitat_state.get("scouted") == site and int(GameState.habitat_state.get("scout_season", -1)) == GameState.seasons_elapsed: text += "\nYour scouting avoids one level of danger this season."
	text += "\nFood recovers away from your home, except during drought or shortage. Local predator activity shifts every three seasons."
	return text


static func rest_ground(site: String) -> void:
	if site not in SITES: return
	var local := at(site).duplicate()
	local["food"] = mini(4, int(local["food"]) + 2)
	if not GameState.habitat_state.has("sites"): GameState.habitat_state["sites"] = {}
	GameState.habitat_state["sites"][site] = local


static func scout() -> Dictionary:
	var site := str(GameState.living_state.get("site", ""))
	if not load("res://scripts/systems/group_habitat.gd").can_manage():
		return {"type": "result", "flavor": "Your alpha manages the group's home and its approaches.", "choices": []}
	if site not in SITES or GameState.health <= 0 or GameState.life_stage < 1 or GameState.get_action_uses("home_duty") > 0 or GameState.hunger < 0.04:
		return {"type": "result", "flavor": "Scouting needs a home, 4% food and your range decision for this season.", "choices": []}
	GameState.hunger -= 0.04
	GameState.record_action_use("home_duty")
	GameState.habitat_state.merge({"scouted": site, "scout_season": GameState.seasons_elapsed}, true)
	load("res://scripts/systems/group_habitat.gd").record_player_decision()
	var text := "You follow the fresh tracks until you know which approaches to avoid. " + ("Predator pressure falls by one level at home for this season." if int(at(site)["pressure"]) > 0 else "The trails are quiet. There is no predator penalty to remove this season.")
	load("res://scripts/systems/life_story.gd").remember("habitat_scout_%d" % GameState.seasons_elapsed, text, 6)
	GameState.save_run()
	TurnManager.stat_changed.emit()
	return {"type": "result", "flavor": text, "choices": []}
