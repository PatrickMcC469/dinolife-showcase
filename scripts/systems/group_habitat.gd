extends RefCounted

const C = preload("res://scripts/systems/companions.gd")
const MEMORY = preload("res://scripts/systems/life_story.gd")
const LOCAL = preload("res://scripts/systems/habitat_conditions.gd")


static func grouped() -> bool:
	return C.supported() and GameState.pack_bond > 0.0


static func can_manage() -> bool:
	return GameState.life_stage >= 1 and GameState.health > 0.0 and (not grouped() or GameState.is_alpha)


static func record_player_decision() -> void:
	if not grouped() or not GameState.is_alpha: return
	C.ensure_cast()
	var state: Dictionary = GameState.living_state.get("group_home", {})
	state.merge({"group_id": GameState.companion_group_id, "last_action": GameState.seasons_elapsed, "pending": false, "notice": ""}, true)
	GameState.living_state["group_home"] = state


static func control_text() -> String:
	if not grouped(): return "You choose your own home."
	if GameState.is_alpha: return "You are the alpha. You choose the group's home."
	var leader: Dictionary = load("res://scripts/systems/pack_leadership.gd").leader()
	return "%s chooses the %s's home. You travel with the group." % [str(leader.get("name", "Your alpha")), C.group_name()]


static func restore(value: Variant) -> Dictionary:
	if not value is Dictionary: return {}
	var state := {"group_id": -1, "last_tick": -1, "last_action": -1, "notice_season": -1, "notice": "", "pending": false, "title": "", "site": ""}
	for key in ["group_id", "last_tick", "last_action", "notice_season"]:
		var number = value.get(key, -1)
		if (number is int or number is float) and is_finite(float(number)):
			state[key] = clampi(int(number), -1, GameState.companion_group_id if key == "group_id" else GameState.seasons_elapsed)
	for key in ["notice", "title"]:
		if value.get(key) is String: state[key] = value[key]
	state["site"] = value.get("site", "") if value.get("site", "") in LOCAL.SITES else ""
	state["pending"] = value.get("pending") == true and not state["notice"].is_empty() and not state["site"].is_empty() and state["notice_season"] >= 0
	return state


static func tick() -> void:
	if not grouped() or GameState.health <= 0: return
	C.ensure_cast()
	var state: Dictionary = GameState.living_state.get("group_home", {})
	if int(state.get("last_tick", -1)) == GameState.seasons_elapsed: return
	state["last_tick"] = GameState.seasons_elapsed
	var old_group := int(state.get("group_id", -1))
	var changed := old_group >= 0 and old_group != GameState.companion_group_id
	state["group_id"] = GameState.companion_group_id
	GameState.living_state["group_home"] = state
	if GameState.is_alpha:
		state["pending"] = false
		return
	var leader: Dictionary = load("res://scripts/systems/pack_leadership.gd").leader()
	if leader.is_empty(): return
	var home = load("res://scripts/systems/living_world.gd")
	var current := str(GameState.living_state.get("site", ""))
	# Adopt an older saved home without unexpectedly moving it on load.
	if old_group < 0 and not current.is_empty(): state["last_action"] = GameState.seasons_elapsed
	if not changed and not current.is_empty() and GameState.seasons_elapsed < int(state.get("last_action", -3)) + 3: return
	var best := _best_site(leader)
	var flood: bool = GameState.world_state.get("kind") == "flood" and GameState.seasons_elapsed < int(GameState.world_state.get("until", -1))
	var worn := int(GameState.living_state.get("wear", 0)) >= 4
	var hungry := int(LOCAL.at(current)["food"]) <= 1 if not current.is_empty() else true
	var text := ""
	var title := ""
	if current.is_empty() or changed or (best != current and (worn or hungry or (current == "river" and flood))):
		GameState.living_state.merge({"site": best, "shelter": 0, "shelter_author": "none", "wear": 0, "last_tick": GameState.seasons_elapsed}, true)
		title = "The %s moves" % C.group_name() if not current.is_empty() else "Your alpha chooses a home"
		text = "%s leads the %s to the %s. You follow the group to its new home." % [leader["name"], C.group_name(), home.SITES[best]["name"].to_lower()]
		if not current.is_empty(): text += " The old shelter stays behind."
		for member in C.active_cast():
			var response: float = load("res://scripts/systems/companion_traits.gd").affinity(member, best)
			if response != 0.0 and member["name"] != leader["name"]:
				var pairs = load("res://scripts/systems/pack_relationships.gd")
				pairs._change(pairs.pair_for(member["name"], leader["name"]), response, "%s chose the group's new home." % leader["name"])
	elif (GameState.current_season == 3 or (current == "river" and flood)) and int(GameState.living_state.get("shelter", 0)) < 2:
		GameState.living_state["shelter"] = int(GameState.living_state.get("shelter", 0)) + 1
		GameState.living_state["shelter_author"] = "npc"
		title = "A safer resting place"
		text = "%s organizes shelter at the %s. The group's home is better prepared for cold or floodwater." % [leader["name"], home.SITES[current]["name"].to_lower()]
	elif worn:
		GameState.living_state["wear"] = 0
		LOCAL.rest_ground(current)
		title = "The feeding ground recovers"
		text = "%s leads the group farther out to feed, giving the ground at home time to recover. Your shelter stays in place." % leader["name"]
	if text.is_empty(): return
	state.merge({"last_action": GameState.seasons_elapsed, "notice_season": GameState.seasons_elapsed, "notice": text, "title": title, "pending": true, "site": GameState.living_state["site"]}, true)
	MEMORY.remember("alpha_home_%d_%d" % [GameState.companion_group_id, GameState.seasons_elapsed], text, 7)


static func _best_site(leader: Dictionary) -> String:
	var home = load("res://scripts/systems/living_world.gd")
	var best := "grove"
	var score := -INF
	var preferred: String = {"cautious": "ridge", "protective": "grove", "bold": "river", "independent": "ridge"}.get(leader.get("trait", ""), "grove")
	for site in LOCAL.SITES:
		var value := float(home.SITES[site]["feeding"]) + LOCAL.feeding(site) + (0.06 if site == preferred else 0.0)
		if site == "river" and GameState.world_state.get("kind") == "flood" and GameState.seasons_elapsed < int(GameState.world_state.get("until", -1)): value -= 0.12
		if value > score:
			score = value
			best = site
	return best


static func pending_event() -> Dictionary:
	var state: Dictionary = GameState.living_state.get("group_home", {})
	if not grouped() or GameState.is_alpha or not state.get("pending", false) or int(state.get("group_id", -1)) != GameState.companion_group_id: return {}
	if state.get("site", "") != GameState.living_state.get("site", ""): return {}
	if not GameState.companion_event.is_empty() or not GameState.family_state.get("pending", {}).is_empty() or not GameState.pack_relations.get("pending", {}).is_empty() or not GameState.pack_story_state.get("pending", {}).is_empty() or not str(GameState.discovery_state.get("pending", "")).is_empty(): return {}
	return {"type": "home_event", "title": state["title"], "flavor": state["notice"], "image_key": "home_" + str(state["site"]), "resolve_key": "living", "next_context": "living", "choices": [{"label": "Continue with the " + C.group_name(), "action": "alpha_home_ack"}]}


static func acknowledge() -> Dictionary:
	if pending_event().is_empty(): return {"flavor": ""}
	GameState.living_state["group_home"]["pending"] = false
	GameState.save_run()
	return {"flavor": ""}
