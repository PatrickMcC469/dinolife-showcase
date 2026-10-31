extends RefCounted

const COMPANIONS = preload("res://scripts/systems/companions.gd")
const MEMORIES = preload("res://scripts/systems/life_story.gd")
const COUNCIL = preload("res://scripts/systems/pack_council.gd")


static func available() -> bool:
	return COMPANIONS.supported() and GameState.pack_bond > 0.0 and GameState.health > 0.0


static func leader() -> Dictionary:
	COMPANIONS.ensure_cast()
	if not available():
		GameState.pack_alpha_name = ""
		return {}
	var cast := COMPANIONS.active_cast()
	if cast.is_empty():
		return {}
	for member in cast:
		if member["name"] == GameState.pack_alpha_name:
			return member
	# Legacy saves keep their relationships; the existing challenger becomes alpha.
	var chosen: Dictionary = cast[0]
	for member in cast:
		if member["role"] == "challenger":
			chosen = member
			break
	GameState.pack_alpha_name = str(chosen["name"])
	return chosen


static func is_leader(member: Dictionary) -> bool:
	var alpha := leader()
	return not GameState.is_alpha and not alpha.is_empty() and member["name"] == alpha["name"]


static func cede() -> void:
	GameState.is_alpha = false
	GameState.pack_alpha_name = ""
	leader()
	PackManager.alpha_status_changed.emit(false)


static func challenge_ready() -> bool:
	return available() and not GameState.is_alpha and GameState.life_stage >= GameState.get_min_mate_stage() and GameState.get_action_uses("alpha_challenge") == 0


static func duty_ready() -> bool:
	return available() and GameState.is_alpha and GameState.get_action_uses("alpha_duty") == 0


static func menu() -> Dictionary:
	var alpha := leader()
	if not available() or alpha.is_empty():
		return _result("You need a living pack or herd before you can lead one.")
	if GameState.is_alpha:
		if not duty_ready():
			return _result("You have already led the group this season. Your next leadership choice opens next season.")
		var herb := COMPANIONS.group_name() == "herd"
		var strained: Dictionary = preload("res://scripts/systems/pack_relationships.gd").most_strained()
		var mediation := "6% food · rebuild trust" + (" · eases %s & %s" % [strained["a"], strained["b"]] if not strained.is_empty() else " · no strained peer bond right now")
		return {"type": "info", "title": "Your season as alpha", "next_context": "leadership",
			"flavor": "The %s waits for your signal. You can take one leadership action each season. Choose what the group needs most." % COMPANIONS.group_name(),
			"choices": [
				{"action": "council", "icon": "bond", "label": "Hear the group's concerns", "sublabel": "A real disagreement · your decision uses this season's duty"},
				{"action": "provision", "icon": "graze" if herb else "hunt", "label": "Lead to fresh browse" if herb else "Lead a coordinated hunt", "sublabel": "Spend 8% food · trusted allies improve the meal"},
				{"action": "patrol", "icon": "shield", "label": "Organize the watch", "sublabel": "Spend 8% food · +6% defense this season · build trust"},
				{"action": "mediate", "icon": "bond", "label": "Settle a dispute", "sublabel": mediation},
				{"action": "back", "label": "Decide later", "sublabel": "Keep this season's leadership action"}]}
	var feeling := COMPANIONS.relationship(alpha).to_lower()
	var text := "%s leads the %s. They are %s toward you. Your choices with them change that relationship." % [alpha["name"], COMPANIONS.group_name(), feeling]
	var allies := COMPANIONS.supporters()
	allies.erase(str(alpha["name"]))
	var peer_effect: float = preload("res://scripts/systems/pack_story_events.gd").alpha_modifier(allies, str(alpha["name"]))
	text += "\n\n" + ("Ready to support you: %s. Their bonds with %s change your challenge chance by %+.0f points." % [MEMORIES.names_text(allies), alpha["name"], peer_effect * 100] if not allies.is_empty() else "No trusted companion has unused support this season.")
	text += "\nEach supporter's rivalry with the alpha adds 2 points; friendship removes 2. Total peer effect is capped at 4 points either way."
	var choices: Array = [{"action": "back", "label": "Keep your place", "sublabel": "Build relationships before you challenge"}]
	if challenge_ready():
		choices.push_front({"action": "challenge", "icon": "attack", "label": "Challenge " + str(alpha["name"]), "sublabel": "Spend 8% food · risk wounds or exile · once per season"})
	else:
		text += "\n\n" + ("You must grow to %s before challenging." % GameState.STAGE_NAMES[GameState.get_min_mate_stage()] if GameState.life_stage < GameState.get_min_mate_stage() else "You have already challenged this season.")
	return {"type": "info", "title": "A place in the %s" % COMPANIONS.group_name(), "flavor": text, "choices": choices, "next_context": "leadership"}


static func resolve(choice: String) -> Dictionary:
	if choice.is_empty():
		return menu()
	if choice == "council":
		return COUNCIL.menu()
	if choice.begins_with("council_"):
		return COUNCIL.resolve(choice)
	if choice == "back":
		return {"flavor": "", "choices": []}
	if not available():
		return _result("The group has parted. There is no leadership decision to make.")
	if choice == "challenge":
		if not challenge_ready():
			return _result("You cannot challenge for leadership again right now.")
		if GameState.hunger < 0.08:
			return _need_food()
		GameState.hunger -= 0.08
		var result: Dictionary = PackManager.resolve_alpha_fight()
		GameState.save_run()
		return _result(str(result["flavor"]))
	if choice not in ["provision", "patrol", "mediate"] or not duty_ready():
		return _result("Only the current alpha can take an unused leadership action this season.")
	var cost := 0.06 if choice == "mediate" else 0.08
	if GameState.hunger < cost:
		return _need_food()
	GameState.hunger -= cost
	GameState.record_action_use("alpha_duty")
	var flavor := ""
	match choice:
		"provision":
			var helpers := COMPANIONS.take_support("when you led the group to food")
			var gain := 0.10 + mini(helpers.size(), 2) * 0.04
			GameState.hunger = minf(1.0, GameState.hunger + gain)
			COMPANIONS.group_response(0.10, "You led the group to food and made room for everyone.")
			PackManager.modify_bond(0.04)
			flavor = "You slow the %s until everyone finds their place. %s By the time you feed, no one has been left waiting at the edge." % [COMPANIONS.group_name(), "The hunters bring down a small meal together." if COMPANIONS.group_name() == "pack" else "You find fresh browse along a sheltered bank."]
			if not helpers.is_empty():
				flavor += " %s helped you bring the group together." % MEMORIES.names_text(helpers)
		"patrol":
			GameState.apply_temp_buff("defense", 0.06, 1, "Alpha watch")
			COMPANIONS.group_response(0.08, "You took the exposed watch so the others could rest.")
			PackManager.modify_bond(0.06)
			flavor = "You check the exposed approaches, then settle the watchers where they can see one another. The group rests more easily with your calls on the wind. Your defense is stronger for the rest of this season."
		"mediate":
			var cast := COMPANIONS.active_cast()
			cast.sort_custom(func(a: Dictionary, b: Dictionary): return float(a["trust"]) < float(b["trust"]))
			var target: Dictionary = cast[0]
			COMPANIONS._change(target, 0.22, "You made space for them instead of forcing them behind the others.")
			for member in cast.slice(1):
				COMPANIONS._change(member, 0.05, "You settled a dispute without driving anyone away.")
			PackManager.modify_bond(0.08)
			flavor = "%s hangs back as the others crowd the trail. You turn toward them, leave room at your side, and wait. They close the gap at their own pace. For now, the %s can move together again." % [target["name"], COMPANIONS.group_name()]
			var pairs = preload("res://scripts/systems/pack_relationships.gd")
			var strained: Dictionary = pairs.most_strained()
			if not strained.is_empty():
				pairs._change(strained, 0.16, "Your mediation gave both room to be heard.")
				flavor += " You also hear out %s and %s; the tension between them eases." % [strained["a"], strained["b"]]
	MEMORIES.remember("alpha_duty_%d" % GameState.seasons_elapsed, flavor, 9)
	GameState.save_run()
	return _result(flavor)


static func _need_food() -> Dictionary:
	var event := menu()
	event["flavor"] = "You need more food reserves before taking on this duty.\n\n" + str(event.get("flavor", ""))
	return event


static func _result(text: String) -> Dictionary:
	return {"type": "result", "title": "Pack leadership", "flavor": text, "choices": []}
