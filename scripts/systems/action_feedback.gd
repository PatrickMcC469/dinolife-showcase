extends RefCounted

const STATS = {"health": "Health", "hunger": "Food", "pack_bond": "Bond",
	"strength": "Strength", "speed": "Speed", "defense": "Defense", "type_stat": "Technique"}
static var _serial: int = 0


static func snapshot() -> Dictionary:
	var state: Dictionary = {}
	for key in STATS:
		state[key] = float(GameState.get(key))
	state["wins"] = GameState.fights_won
	state["kills"] = GameState.kills
	state["mate"] = GameState.has_mate
	state["journey_finished"] = GameState.journey_state.get("phase", -1) == 3
	state["injury_turns"] = 0
	for injury in GameState.injuries:
		state["injury_turns"] += int(injury.get("turns_remaining", 0))
	state["companions"] = {}
	state["pairs"] = {}
	state["children"] = GameState.family_state.get("children", {}).duplicate(true)
	state["nesting_score"] = GameState.nesting_score
	state["offspring_bond"] = GameState.offspring_bond
	for pair in GameState.pack_relations.get("pairs", []):
		state["pairs"][JSON.stringify([pair["a"], pair["b"]])] = {"a": pair["a"], "b": pair["b"], "score": float(pair["score"])}
	for member in GameState.companions:
		state["companions"][member["name"]] = {"trust": float(member.get("trust", 0.0)), "active": member.get("active", false)}
	return state


static func attach(result: Dictionary, before: Dictionary) -> void:
	var after := snapshot()
	var gains: Array[String] = []
	var costs: Array[String] = []
	var milestones: Array[String] = []
	for key in STATS:
		var points := roundi((float(after[key]) - float(before[key])) * 100.0)
		if points == 0:
			continue
		var label: String = STATS[key]
		if key == "type_stat":
			label = str(SpeciesDB.get_species(GameState.species_id).get("type_stat_name", "technique")).replace("_", " ").capitalize()
		var change := "%s %s%d%%" % [label, "+" if points > 0 else "−", absi(points)]
		if points > 0: gains.append(change)
		else: costs.append(change)
	for name in after["companions"]:
		if not before["companions"].has(name):
			continue
		var old: Dictionary = before["companions"][name]
		var current: Dictionary = after["companions"][name]
		if old["active"] and not current["active"]:
			costs.append("%s left the group" % name)
		elif old["active"] and current["active"]:
			var trust_change: float = current["trust"] - old["trust"]
			if trust_change >= 0.005: gains.append("%s trusts you more" % name)
			elif trust_change <= -0.005: costs.append("%s trusts you less" % name)
	for key in after["pairs"]:
		if not before.get("pairs", {}).has(key): continue
		var pair: Dictionary = after["pairs"][key]
		var points := roundi((float(pair["score"]) - float(before["pairs"][key]["score"])) * 50)
		if points == 0: continue
		var change := "%s & %s bond %s%d%%" % [pair["a"], pair["b"], "+" if points > 0 else "−", absi(points)]
		if points > 0: gains.append(change)
		else: costs.append(change)
	if after["wins"] > before["wins"]: milestones.append("Fight won")
	for key in ["nesting_score", "offspring_bond"]:
		var points := roundi((float(after[key]) - float(before.get(key, after[key]))) * 100)
		if points > 0: gains.append(("Nesting care" if key == "nesting_score" else "Young bond") + " +%d%%" % points)
	for name in after["children"]:
		for skill in preload("res://scripts/systems/family_legacy.gd").SKILLS:
			var level := int(after["children"][name]["skills"][skill])
			if level > int(before.get("children", {}).get(name, {}).get("skills", {}).get(skill, 0)):
				milestones.append("%s: %s (%s)" % [name, preload("res://scripts/systems/family_legacy.gd").SKILLS[skill]["name"], "learned" if level == 2 else "learning"])
	if after["kills"] > before["kills"]: milestones.append("Successful hunt")
	if after["mate"] and not before["mate"]: milestones.append("Mate bonded")
	if after["injury_turns"] < before["injury_turns"]: gains.append("Injuries easing")
	if not before["journey_finished"] and after["journey_finished"] and float(GameState.journey_state.get("reward", 0.0)) > 0.0:
		milestones.append("Migration complete" if GameState.journey_state.get("kind") == "migration" else "Range secured")
	if gains.is_empty() and costs.is_empty() and milestones.is_empty():
		return
	_serial += 1
	result["feedback"] = {"serial": _serial, "gains": gains, "costs": costs, "milestones": milestones,
		"tone": "mixed" if not costs.is_empty() and (not gains.is_empty() or not milestones.is_empty()) else ("setback" if not costs.is_empty() else "reward")}
	if str(result.get("flavor", "")).is_empty():
		result["flavor"] = "Your condition has changed."


static func milestone(message: String) -> Dictionary:
	_serial += 1
	return {"serial": _serial, "gains": [], "costs": [], "milestones": [message], "tone": "reward"}
