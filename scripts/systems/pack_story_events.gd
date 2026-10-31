extends RefCounted

const PAIRS = preload("res://scripts/systems/pack_relationships.gd")


static func restore(value: Variant) -> Dictionary:
	var state := {"last_event": GameState.seasons_elapsed, "count": 0, "pending": {}}
	if not value is Dictionary: return state
	for key in ["last_event", "count"]:
		state[key] = int(PAIRS._number(value.get(key), state[key]))
	state["last_event"] = clampi(state["last_event"], -3, GameState.seasons_elapsed)
	state["count"] = clampi(state["count"], 0, 100000)
	var pending = value.get("pending")
	if pending is Dictionary and pending.get("kind") in ["defend", "food", "route"] and pending.get("a") is String and pending.get("b") is String and PAIRS._number(pending.get("season"), -1) == GameState.seasons_elapsed and PAIRS._number(pending.get("group_id"), -1) == GameState.companion_group_id:
		state["pending"] = {"kind": pending["kind"], "a": pending["a"], "b": pending["b"], "season": GameState.seasons_elapsed, "group_id": GameState.companion_group_id}
	return state


static func next_event() -> Dictionary:
	if not GameState.pack_story_state.get("pending", {}).is_empty(): return pending_event()
	if GameState.health <= 0 or GameState.life_stage < 1 or GameState.pack_bond <= 0 or GameState.companion_event_count == 0 or not GameState.companion_event.is_empty(): return {}
	if GameState.seasons_elapsed < int(GameState.pack_story_state.get("last_event", 0)) + 3: return {}
	PAIRS.sync()
	var eligible: Array = GameState.pack_relations.get("pairs", []).filter(func(pair): return PAIRS.status(pair) != "Getting acquainted")
	if eligible.is_empty(): return {}
	var count := int(GameState.pack_story_state.get("count", 0))
	var pair: Dictionary = eligible[count % eligible.size()]
	GameState.pack_story_state["pending"] = {"kind": "defend" if PAIRS.status(pair) == "Friends" else ("food" if count % 2 == 0 else "route"), "a": pair["a"], "b": pair["b"], "season": GameState.seasons_elapsed, "group_id": GameState.companion_group_id}
	return pending_event()


static func pending_event() -> Dictionary:
	PAIRS.sync()
	var state: Dictionary = GameState.pack_story_state.get("pending", {})
	if state.is_empty(): return {}
	var pair := PAIRS.pair_for(str(state.get("a", "")), str(state.get("b", "")))
	if GameState.health <= 0 or GameState.life_stage < 1 or GameState.pack_bond <= 0 or pair.is_empty() or int(state.get("season", -1)) != GameState.seasons_elapsed or int(state.get("group_id", -1)) != GameState.companion_group_id:
		GameState.pack_story_state["pending"] = {}
		return {}
	var a: String = state["a"]
	var b: String = state["b"]
	var text := ""
	var title := ""
	var choices: Array = []
	match state["kind"]:
		"defend":
			title = "They won't leave a friend"
			text = "%s stumbles where the trail narrows. %s turns back at once, standing between their friend and the movement in the brush. The others hesitate. You can help them cross together or call everyone toward safety." % [a, b]
			if GameState.hunger >= 0.05: choices.append(_choice("help", "Guide both through cover", "5% food · strengthens their friendship and trust in you", "shield"))
			choices.append(_choice("wait", "Hold back and watch the trail", "+2% defense this season · their friendship holds", "stalk"))
			choices.append(_choice("leave", "Call them away from each other", "No cost · strains their trust and friendship", "flee"))
		"food":
			title = "Too little room to feed"
			text = "%s reaches the feeding ground first. %s tries to move alongside, but neither gives the other room. Their old tension has followed them here. Both look toward you when the calls grow sharp." % [a, b]
			if GameState.hunger >= 0.04: choices.append(_choice("help", "Make two feeding spaces", "4% food · eases rivalry · both trust you more", "bond"))
			choices.append(_choice("first", "Give " + a + " the first turn", "Their trust rises · the other feels overlooked", "food"))
			choices.append(_choice("wait", "Let them keep their distance", "No cost · leaves the rivalry as it is", "stalk"))
		"route":
			title = "Two paths, neither yielding"
			text = "%s waits by the covered trail. %s presses toward open ground, refusing to follow. It is more than a route now: neither wants to give way to the other. You could scout a path they can both use, or decide whose judgment counts today." % [a, b]
			if GameState.hunger >= 0.04: choices.append(_choice("help", "Scout a route for both", "4% food · eases rivalry · +2% feeding chance this season", "territory"))
			choices.append(_choice("first", "Follow " + a + "'s route", "Their trust rises · the other feels overlooked", "footprint"))
			choices.append(_choice("wait", "Travel apart for a while", "No cost · leaves the rivalry as it is", "stalk"))
	return {"type": "living_event", "title": title, "image_key": GameState.species_id + ("_resting_together" if state["kind"] == "defend" else "_wary_distance"), "flavor": text, "choices": choices, "resolve_key": "pack_story", "next_context": "pack_story"}


static func _choice(action: String, label: String, detail: String, icon: String) -> Dictionary:
	return {"action": action, "label": label, "sublabel": detail, "icon": icon}


static func resolve(choice: String) -> Dictionary:
	var current := pending_event()
	if current.is_empty(): return {"type": "result", "flavor": "That moment has passed.", "choices": []}
	if not current["choices"].any(func(option): return option["action"] == choice): return current
	var state: Dictionary = GameState.pack_story_state["pending"]
	var pair := PAIRS.pair_for(state["a"], state["b"])
	var text := ""
	var companions = load("res://scripts/systems/companions.gd")
	var a: Dictionary = companions._find(state["a"])
	var b: Dictionary = companions._find(state["b"])
	if choice == "help":
		GameState.hunger -= 0.05 if state["kind"] == "defend" else 0.04
		PAIRS._change(pair, 0.16, "You helped them find a way through together.")
		for member in [a, b]: companions._change(member, 0.08, "You made room for both of them when their bond mattered.")
		if state["kind"] == "route": GameState.living_state["watch_until"] = GameState.seasons_elapsed + 1
		text = ("You find cover wide enough for both. %s waits until %s is safely beside them before moving on." if state["kind"] == "defend" else "You make room for both %s and %s. Neither has to push the other aside this time.") % [state["a"], state["b"]]
	elif choice == "first":
		PAIRS._change(pair, -0.12, "You gave one of them the deciding voice.")
		companions._change(a, 0.10, "You backed their judgment over a rival's.")
		companions._change(b, -0.10, "You let their rival speak for both of them.")
		text = "%s answers your call and moves first. %s follows at a distance, leaving a gap that stays open for the rest of the day." % [state["a"], state["b"]]
	elif choice == "leave":
		PAIRS._change(pair, -0.12, "You pulled them apart when one needed their friend.")
		for member in [a, b]: companions._change(member, -0.08, "You called them away when their friend needed help.")
		text = "%s follows your call, but keeps looking back for %s. The group moves on with less trust than it brought to the crossing." % [state["b"], state["a"]]
	else:
		if state["kind"] == "defend": GameState.apply_temp_buff("defense", 0.02, 1, "Watching for two friends")
		text = "%s and %s keep their own space. You watch until both are moving safely again." % [state["a"], state["b"]]
	GameState.pack_story_state.merge({"pending": {}, "last_event": GameState.seasons_elapsed, "count": int(GameState.pack_story_state.get("count", 0)) + 1}, true)
	load("res://scripts/systems/life_story.gd").remember("pack_pair_story_%d" % GameState.seasons_elapsed, text, 8)
	GameState.save_run()
	TurnManager.stat_changed.emit()
	return {"type": "result", "flavor": text, "choices": []}


static func alpha_modifier(supporters: Array[String], alpha_name: String) -> float:
	var amount := 0.0
	for name in supporters:
		var status := PAIRS.status(PAIRS.pair_for(name, alpha_name))
		if status == "Friends": amount -= 0.02
		elif status == "Rivals": amount += 0.02
	return clampf(amount, -0.04, 0.04)
