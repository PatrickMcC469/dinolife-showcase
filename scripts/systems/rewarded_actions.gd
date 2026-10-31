extends RefCounted

const FEEDBACK = preload("res://scripts/systems/action_feedback.gd")
const BOOSTS = {"ad_health": "health", "ad_hunger": "hunger", "ad_bond": "pack_bond"}
const LABELS = {"health": "Health", "hunger": "Food", "pack_bond": "Bond"}
const BOOST_LIMIT := 3


static func available(action: String) -> bool:
	if GameState.health <= 0.0 or GameState.life_stage < 1:
		return false
	if action in BOOSTS:
		if action == "ad_bond" and (not SpeciesDB.get_species(GameState.species_id).get("pack_species", false) or GameState.pack_bond <= 0.0):
			return false
		return float(GameState.get(BOOSTS[action])) < 1.0 and GameState.get_action_uses(action) < BOOST_LIMIT
	if action == "ad_training":
		return not GameState.ad_bonus_training_used and GameState.get_action_uses("sharpen") > 0
	if action == "ad_heal":
		return GameState.injuries.any(func(injury): return not injury.get("permanent", false) and int(injury.get("turns_remaining", 0)) > 0)
	return false


static func notice(title: String, text: String) -> Dictionary:
	return {"type": "info", "title": title, "flavor": text, "instant_text": true, "choices": []}


static func grant(action: String) -> Dictionary:
	if not available(action):
		return notice("Reward could not be applied", "This benefit is no longer needed or available this season. Your stats have not changed.")
	var before := FEEDBACK.snapshot()
	var text := ""
	if action in BOOSTS:
		var stat: String = BOOSTS[action]
		var old := float(GameState.get(stat))
		var current := minf(old + 0.08, 1.0)
		GameState.set(stat, current)
		GameState.record_action_use(action)
		text = "%s: %s%% → %s%%" % [LABELS[stat], _percent(old), _percent(current)]
	elif action == "ad_training":
		GameState.ad_bonus_training_used = true
		GameState.action_uses["sharpen"] = GameState.get_action_uses("sharpen") - 1
		var button := "Harden Defenses" if SpeciesDB.get_species(GameState.species_id).get("tree") == "herbivore" else "Refine Technique"
		text = "One extra training session is ready this season.\n\nTap %s to choose a stat. Your stats change after training, and the usual food cost still applies." % button
	elif action == "ad_heal":
		var injuries := GameState.injuries.duplicate(true)
		GameState.shorten_injuries(2)
		var lines: Array[String] = []
		for injury in injuries:
			if injury.get("permanent", false) or int(injury.get("turns_remaining", 0)) <= 0: continue
			var old := int(injury["turns_remaining"])
			var remaining := maxi(old - 2, 0)
			lines.append("%s: healed" % injury.get("name", "Injury") if remaining == 0 else "%s: %d → %d season%s remaining" % [injury.get("name", "Injury"), old, remaining, "s" if remaining != 1 else ""])
		if injuries.any(func(injury): return injury.get("permanent", false)):
			lines.append("Permanent injuries remain.")
		text = "\n".join(lines)
	var result := notice("Reward received", text)
	FEEDBACK.attach(result, before)
	if action == "ad_training": result["feedback"] = FEEDBACK.milestone("+1 training session")
	GameState.save_run()
	return result


static func _percent(value: float) -> String:
	return ("%.1f" % (value * 100.0)).trim_suffix(".0")
