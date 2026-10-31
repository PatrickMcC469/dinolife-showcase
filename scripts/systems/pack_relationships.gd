extends RefCounted

const MEMORIES = preload("res://scripts/systems/life_story.gd")


static func _cast() -> Array:
	# Runtime lookup avoids a preload cycle with companions' membership hooks.
	return load("res://scripts/systems/companions.gd").active_cast() if GameState.pack_bond > 0.0 else []


static func _number(value: Variant, fallback: float) -> float:
	return float(value) if (value is float or value is int) and is_finite(float(value)) else fallback


static func restore(value: Variant) -> Dictionary:
	var state := {"group_id": GameState.companion_group_id, "pairs": [], "last_tick": GameState.seasons_elapsed, "pending": {}}
	if not value is Dictionary or _number(value.get("group_id"), -1) != GameState.companion_group_id:
		return state
	var names: Array = _cast().map(func(member: Dictionary): return member["name"])
	var seen: Array = []
	for pair in value.get("pairs", []) if value.get("pairs") is Array else []:
		if not pair is Dictionary or not pair.get("a") is String or not pair.get("b") is String: continue
		var a: String = pair["a"]
		var b: String = pair["b"]
		if a >= b or a not in names or b not in names or [a, b] in seen: continue
		seen.append([a, b])
		state["pairs"].append({"a": a, "b": b, "score": clampf(_number(pair.get("score"), 0), -1, 1), "reason": pair.get("reason") if pair.get("reason") is String else "Still learning one another's pace.", "season": clampi(int(_number(pair.get("season"), GameState.seasons_elapsed)), 0, GameState.seasons_elapsed)})
		if state["pairs"].size() >= 15: break
	state["last_tick"] = clampi(int(_number(value.get("last_tick"), GameState.seasons_elapsed)), -1, GameState.seasons_elapsed)
	var pending = value.get("pending")
	if pending is Dictionary and [pending.get("a"), pending.get("b")] in seen and _number(pending.get("season"), -1) == GameState.seasons_elapsed:
		state["pending"] = {"a": pending["a"], "b": pending["b"], "season": GameState.seasons_elapsed}
	return state


static func sync() -> void:
	var cast := _cast()
	if int(GameState.pack_relations.get("group_id", -1)) != GameState.companion_group_id:
		GameState.pack_relations = {"group_id": GameState.companion_group_id, "pairs": [], "last_tick": GameState.seasons_elapsed, "pending": {}}
	var names: Array = cast.map(func(member: Dictionary): return member["name"])
	var pairs: Array = GameState.pack_relations.get("pairs", [])
	pairs = pairs.filter(func(pair: Dictionary): return pair["a"] in names and pair["b"] in names)
	for i in names.size():
		for j in range(i + 1, names.size()):
			var a: String = names[i] if names[i] < names[j] else names[j]
			var b: String = names[j] if names[i] < names[j] else names[i]
			if not pairs.any(func(pair: Dictionary): return pair["a"] == a and pair["b"] == b):
				pairs.append({"a": a, "b": b, "score": 0.0, "reason": "Still learning one another's pace.", "season": GameState.seasons_elapsed})
	GameState.pack_relations["pairs"] = pairs
	var pending: Dictionary = GameState.pack_relations.get("pending", {})
	if pending.get("a", "") not in names or pending.get("b", "") not in names or int(pending.get("season", -1)) != GameState.seasons_elapsed:
		GameState.pack_relations["pending"] = {}


static func pair_for(a: String, b: String) -> Dictionary:
	var first := a if a < b else b
	var second := b if a < b else a
	for pair in GameState.pack_relations.get("pairs", []):
		if pair["a"] == first and pair["b"] == second: return pair
	return {}


static func status(pair: Dictionary) -> String:
	var score := float(pair.get("score", 0.0))
	return "Friends" if score >= 0.299999 else ("Rivals" if score <= -0.299999 else "Getting acquainted")


static func most_strained() -> Dictionary:
	sync()
	var chosen := {}
	for pair in GameState.pack_relations.get("pairs", []):
		if float(pair["score"]) < float(chosen.get("score", 0)): chosen = pair
	return chosen


static func _change(pair: Dictionary, amount: float, reason: String) -> void:
	if pair.is_empty(): return
	var before := status(pair)
	pair["score"] = clampf(float(pair["score"]) + amount, -1.0, 1.0)
	pair["reason"] = reason
	pair["season"] = GameState.seasons_elapsed
	if before != status(pair):
		MEMORIES.remember("pack_pair_%s_%s_%d_%s" % [pair["a"], pair["b"], GameState.seasons_elapsed, status(pair)], "%s and %s: %s. %s" % [pair["a"], pair["b"], status(pair).to_lower(), reason], 7)


static func council(first: Dictionary, second: Dictionary, balanced: bool) -> void:
	sync()
	_change(pair_for(str(first["name"]), str(second["name"])), 0.20 if balanced else -0.18, "You helped both concerns find room in the council." if balanced else "The council backed one concern and left the other unheard.")


static func tick() -> void:
	sync()
	if GameState.health <= 0.0 or int(GameState.pack_relations.get("last_tick", -1)) == GameState.seasons_elapsed: return
	GameState.pack_relations["last_tick"] = GameState.seasons_elapsed
	var traits := {}
	for member in _cast(): traits[member["name"]] = member.get("trait", "")
	var rivals: Array[String] = []
	for pair in GameState.pack_relations["pairs"]:
		var a: String = traits[pair["a"]]
		var b: String = traits[pair["b"]]
		var compatible: bool = a == b or (a in ["cautious", "protective"] and b in ["cautious", "protective"]) or (a in ["bold", "independent"] and b in ["bold", "independent"])
		var clashes: bool = (a in ["cautious", "bold"] and b in ["cautious", "bold"] and a != b) or (a in ["protective", "independent"] and b in ["protective", "independent"] and a != b)
		if compatible:
			_change(pair, 0.06 if a == b else 0.04, "Their %s and %s habits helped them find a shared pace this season." % [a, b])
		elif clashes:
			_change(pair, -0.06 if a in ["cautious", "bold"] else -0.04, "Their %s and %s habits pulled them in different directions this season." % [a, b])
		if status(pair) == "Rivals": rivals.append("%s and %s" % [pair["a"], pair["b"]])
	if not rivals.is_empty():
		PackManager.modify_bond(-0.02)
		MEMORIES.remember("pack_pair_tension_%d" % GameState.seasons_elapsed, "Tension between %s strained the group. −2%% bond this season." % "; ".join(rivals), 6)


static func cooperation(names: Array[String]) -> void:
	if GameState.get_action_uses("pair_support") > 0: return
	for pair in GameState.pack_relations.get("pairs", []):
		if pair["a"] in names and pair["b"] in names and status(pair) == "Friends":
			GameState.record_action_use("pair_support")
			GameState.apply_temp_buff("defense", 0.02, 1, "Friends working together")
			MEMORIES.remember("pack_pair_help_%d" % GameState.seasons_elapsed, "%s and %s worked together beside you. +2%% defense for this season." % [pair["a"], pair["b"]], 7)
			return


static func event(a: String, b: String) -> Dictionary:
	sync()
	var pair := pair_for(a, b)
	if pair.is_empty() or GameState.get_action_uses("pair_care") > 0 or GameState.health <= 0.0: return {}
	GameState.pack_relations["pending"] = {"a": pair["a"], "b": pair["b"], "season": GameState.seasons_elapsed}
	GameState.save_run()
	return pending_event()


static func pending_event() -> Dictionary:
	sync()
	var pending: Dictionary = GameState.pack_relations.get("pending", {})
	if pending.is_empty() or GameState.get_action_uses("pair_care") > 0 or GameState.health <= 0.0:
		GameState.pack_relations["pending"] = {}
		return {}
	var pair := pair_for(pending["a"], pending["b"])
	var choices: Array = []
	if GameState.hunger >= 0.04: choices.append({"action": "pair_share", "label": "Share a feeding task", "icon": "bond", "sublabel": "4% food · strengthens their bond and trust in you"})
	choices.append({"action": "pair_space", "label": "Give both room to rest", "icon": "rest", "sublabel": "No food cost · small gain in their bond"})
	choices.append({"action": "back", "label": "Leave it for now", "sublabel": "Keep your seasonal care"})
	return {"type": "living_event", "title": "%s & %s" % [pair["a"], pair["b"]], "flavor": "%s\n\n%s\n\nYou can help one pair find a steadier pace each season." % [status(pair), pair["reason"]], "choices": choices, "resolve_key": "pack_relations", "next_context": "pack_relations"}


static func resolve(choice: String) -> Dictionary:
	var current := pending_event()
	if current.is_empty(): return {"flavor": "That moment has passed."}
	if not current["choices"].any(func(option: Dictionary): return option["action"] == choice): return current
	var pending: Dictionary = GameState.pack_relations["pending"]
	GameState.pack_relations["pending"] = {}
	if choice == "back":
		GameState.save_run()
		return {"flavor": ""}
	GameState.record_action_use("pair_care")
	var share := choice == "pair_share"
	if share: GameState.hunger -= 0.04
	var text := "%s and %s %s" % [pending["a"], pending["b"], "feed side by side. Your shared portion gives them a reason to work together, and both remember your care." if share else "rest with room between them. Neither has to compete for space."]
	_change(pair_for(pending["a"], pending["b"]), 0.20 if share else 0.06, "You made room for a shared feeding task." if share else "You let both rest without competing for space.")
	if share:
		for member in _cast():
			if member["name"] in [pending["a"], pending["b"]]: load("res://scripts/systems/companions.gd")._change(member, 0.04, "You helped them find room beside another companion.")
	MEMORIES.remember("pack_pair_care_%d" % GameState.seasons_elapsed, text, 7)
	GameState.save_run()
	TurnManager.stat_changed.emit()
	return {"type": "result", "flavor": text, "choices": []}
