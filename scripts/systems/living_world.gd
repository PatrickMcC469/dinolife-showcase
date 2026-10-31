extends RefCounted

const COMPANIONS = preload("res://scripts/systems/companions.gd")
const TRAITS = preload("res://scripts/systems/companion_traits.gd")
const MEMORIES = preload("res://scripts/systems/life_story.gd")
const GROUP_HOME = preload("res://scripts/systems/group_habitat.gd")
const SITES = {
	"ridge": {"name": "High ridge", "caption": "−2% feeding · flood-safe\n+4% range claims", "detail": "Above floodwater. Sparse food: −2% feeding chance. Clear approaches improve range claims by 4%.", "feeding": -0.02},
	"river": {"name": "River bend", "caption": "+3% feeding\nFloods: −4% health", "detail": "Rich feeding: +3% chance. Floods cost 4% health each season; prepared shelter reduces that cost.", "feeding": 0.03},
	"grove": {"name": "Sheltered grove", "caption": "+1% feeding · nesting care", "detail": "Steady cover and +1% feeding chance. Young gain 3% nesting care each season here.", "feeding": 0.01},
}
const MOMENTS = ["young", "companion", "home", "solitary"]


static func restore(value: Variant) -> Dictionary:
	if not value is Dictionary:
		return {}
	var state := {"site": str(value.get("site", "")) if value.get("site", "") in SITES else ""}
	for key in ["shelter", "wear", "last_tick", "last_event", "moment_count", "watch_until"]:
		var number = value.get(key, -1 if key.begins_with("last") else 0)
		state[key] = int(number) if number is int or number is float else (-1 if key.begins_with("last") else 0)
	state["shelter"] = clampi(state["shelter"], 0, 2)
	state["wear"] = clampi(state["wear"], 0, 4)
	state["moment_count"] = maxi(0, state["moment_count"])
	state["notice"] = str(value.get("notice", "")) if value.get("notice", "") is String else ""
	if value.has("shelter_author"): state["shelter_author"] = value["shelter_author"] if value["shelter_author"] in ["player", "npc", "none"] else "none"
	if value.has("group_home"): state["group_home"] = GROUP_HOME.restore(value["group_home"])
	state["event"] = {}
	var event = value.get("event")
	if event is Dictionary and event.get("kind") in ["echo", "moment"] and event.get("name", "") is String:
		if event["kind"] == "moment" and event.get("moment") in MOMENTS:
			state["event"] = {"kind": "moment", "moment": event["moment"], "name": event.get("name", "")}
		elif event["kind"] == "echo" and event.get("choice") in TRAITS.REMEMBERED:
			var season = event.get("season", -1)
			if season is int or season is float:
				state["event"] = {"kind": "echo", "name": event["name"], "choice": event["choice"], "season": int(season)}
	return state


static func available() -> bool:
	return GameState.life_stage >= 1 and GameState.health > 0.0


static func tick() -> void:
	preload("res://scripts/systems/pack_relationships.gd").tick()
	preload("res://scripts/systems/habitat_conditions.gd").tick()
	preload("res://scripts/systems/family_legacy.gd").tick()
	GROUP_HOME.tick()
	if not available() or int(GameState.living_state.get("last_tick", -1)) == GameState.seasons_elapsed:
		return
	GameState.living_state["last_tick"] = GameState.seasons_elapsed
	GameState.living_state["notice"] = ""
	var site := str(GameState.living_state.get("site", ""))
	if site.is_empty():
		return
	GameState.living_state["wear"] = mini(4, int(GameState.living_state.get("wear", 0)) + 1)
	if site == "grove" and GameState.has_young:
		GameState.nesting_score = minf(1.0, GameState.nesting_score + 0.03)
		GameState.living_state["notice"] = "The grove's cover gives your young a steadier resting place. +3% nesting care."
	if site == "river" and GameState.world_state.get("kind") == "flood" and GameState.seasons_elapsed < int(GameState.world_state.get("until", -1)):
		var damage := 0.04 - int(GameState.living_state.get("shelter", 0)) * 0.015
		GameState.health = maxf(0.0, GameState.health - damage)
		var text := "Floodwater reached your river bend. " + ("The shelter you prepared held back the worst of it." if int(GameState.living_state.get("shelter", 0)) > 0 else "There was no prepared shelter above the bank.")
		GameState.living_state["notice"] = text + " −%d%% health." % roundi(damage * 100)
		MEMORIES.remember("home_flood_%d" % GameState.seasons_elapsed, text, 7)


static func modifier(action: String) -> float:
	if not available():
		return 0.0
	var site := str(GameState.living_state.get("site", ""))
	if action == "territory":
		return 0.04 if site == "ridge" else 0.0
	if action not in ["hunt", "graze", "scavenge"]:
		return 0.0
	return float(SITES.get(site, {}).get("feeding", 0.0)) - (0.04 if not site.is_empty() and int(GameState.living_state.get("wear", 0)) >= 4 else 0.0) + (0.02 if GameState.seasons_elapsed < int(GameState.living_state.get("watch_until", -1)) else 0.0)


static func cold_cost() -> float:
	if not available() or GameState.current_season != 3 or GameState.living_state.get("site", "").is_empty():
		return 0.0
	return maxf(0.0, 0.02 - int(GameState.living_state.get("shelter", 0)) * 0.01)


static func summary() -> String:
	var site := str(GameState.living_state.get("site", ""))
	if site.is_empty():
		return "Choose a home range from Habitat map."
	return "%s · shelter %d / 2\n%s" % [SITES[site]["name"], int(GameState.living_state.get("shelter", 0)), "Feeding ground needs a rest" if int(GameState.living_state.get("wear", 0)) >= 4 else "Familiar feeding ground"]


static func detail() -> String:
	var site := str(GameState.living_state.get("site", ""))
	if site.is_empty():
		return "You have not settled a home range yet. Choose cover, rich river feeding, or high ground."
	return "%s\n%s\nShelter reduces the extra 2%% cold-season food cost by 1%% per level. After four seasons in one place, feeding chance falls by 4%% until you rest the ground.\n%s" % [summary(), SITES[site]["detail"], str(GameState.living_state.get("notice", ""))]


static func home_menu() -> Dictionary:
	if not available():
		return _result("Grow beyond the nest before choosing a range of your own.")
	if not GROUP_HOME.can_manage():
		return _event("Your group's home", GROUP_HOME.control_text(), [{"action": "back", "label": "Back to your life"}], "home")
	var choices: Array = []
	var site := str(GameState.living_state.get("site", ""))
	var text := detail()
	if GameState.get_action_uses("home_duty") == 0:
		var cost := 0.06 if site.is_empty() else 0.08
		for key in SITES:
			if key != site:
				choices.append({"action": "home_" + key, "label": ("Settle at " if site.is_empty() else "Move to ") + SITES[key]["name"].to_lower(), "icon": "territory", "sublabel": "%d%% food\n%s" % [roundi(cost * 100), SITES[key]["caption"]]})
		if not site.is_empty():
			choices.append({"action": "home_scout", "label": "Scout the approaches", "icon": "stalk", "sublabel": "4% food · avoids one level of local predator pressure this season"})
			if int(GameState.living_state.get("shelter", 0)) < 2:
				choices.append({"action": "home_prepare", "label": "Prepare higher, sheltered ground", "icon": "shield", "sublabel": "6% food · shelter +1 · reduces cold and river flood costs"})
			if int(GameState.living_state.get("wear", 0)) > 0:
				choices.append({"action": "home_rest", "label": "Rest the feeding ground", "icon": "rest", "sublabel": "4% food · clear depletion; keep your shelter"})
		if COMPANIONS.supported() and GameState.pack_bond > 0.0:
			text += "\n\nYour companions notice your choice: cautious members favor the ridge, bold members the river, and protective members the grove. Independent members prefer more space away from the grove."
	else:
		text += "\n\nYou have already tended or moved your range this season."
	choices.append({"action": "back", "label": "Return to your trails", "sublabel": "One range decision per season"})
	return _event("A place to return to", text, choices, "home")


static func resolve_home(choice: String) -> Dictionary:
	if choice.is_empty():
		return home_menu()
	if choice == "back":
		return {"flavor": ""}
	if not GROUP_HOME.can_manage(): return _result(GROUP_HOME.control_text() if available() else "Grow beyond the nest before choosing a home.")
	if choice == "home_scout": return preload("res://scripts/systems/habitat_conditions.gd").scout()
	var menu := home_menu()
	if not available() or GameState.get_action_uses("home_duty") > 0 or not menu.get("choices", []).any(func(option): return option["action"] == choice):
		return _result("That range decision is no longer available.")
	var site := str(GameState.living_state.get("site", ""))
	var settling := choice.begins_with("home_") and choice.trim_prefix("home_") in SITES
	var cost := (0.06 if site.is_empty() else 0.08) if settling else (0.06 if choice == "home_prepare" else 0.04)
	if GameState.hunger < cost:
		menu["flavor"] = "Your food reserves are too low for that work. Feed first.\n\n" + menu["flavor"]
		return menu
	GameState.hunger -= cost
	GameState.record_action_use("home_duty")
	var text := ""
	if settling:
		site = choice.trim_prefix("home_")
		GameState.living_state.merge({"site": site, "shelter": 0, "shelter_author": "none", "wear": 0, "last_tick": GameState.seasons_elapsed, "notice": ""}, true)
		text = "You learn the approaches to the %s: where the wind turns, where food gathers, and where to rest. This is somewhere you can return to. Your old shelter stays behind when you move." % SITES[site]["name"].to_lower()
		for member in COMPANIONS.active_cast():
			var response := TRAITS.affinity(member, site)
			if response != 0.0:
				COMPANIONS._change(member, response, "You chose the %s; their %s nature shaped how they felt about it." % [SITES[site]["name"].to_lower(), member["trait"]])
				text += "\n%s %s the new range." % [member["name"], "welcomes" if response > 0.0 else "is uneasy about"]
	elif choice == "home_prepare":
		GameState.living_state["shelter"] = int(GameState.living_state.get("shelter", 0)) + 1
		GameState.living_state["shelter_author"] = "player"
		text = "You test the higher ground until you find a place out of the wind. The next cold season, or a flood at the river bend, will meet a better prepared home."
	else:
		GameState.living_state["wear"] = 0
		preload("res://scripts/systems/habitat_conditions.gd").rest_ground(site)
		text = "You feed farther afield for a while. At home, fresh growth and small tracks begin returning. You keep your shelter and give the familiar ground time to recover."
	GROUP_HOME.record_player_decision()
	MEMORIES.remember("home_%d" % GameState.seasons_elapsed, text, 7)
	return _finish(text)


static func _member(name: String) -> Dictionary:
	for member in GameState.companions:
		if member.get("name") == name:
			return member
	return {}


static func _memory(member: Dictionary, event: Dictionary) -> Dictionary:
	TRAITS.ensure(member)
	for memory in member["memories"]:
		if memory["choice"] == event.get("choice") and int(memory["season"]) == int(event.get("season", -1)) and not memory["resolved"]:
			return memory
	return {}


static func next_event() -> Dictionary:
	if not available():
		return {}
	if not GameState.living_state.get("event", {}).is_empty():
		return pending_event()
	var group_notice := GROUP_HOME.pending_event()
	if not group_notice.is_empty(): return group_notice
	if GameState.seasons_elapsed < int(GameState.living_state.get("last_event", -3)) + 3:
		return {}
	for member in GameState.companions:
		TRAITS.ensure(member)
		for memory in member["memories"]:
			if not memory["resolved"] and GameState.seasons_elapsed >= int(memory["season"]) + 2:
				GameState.living_state["event"] = {"kind": "echo", "name": member["name"], "choice": memory["choice"], "season": memory["season"]}
				return pending_event()
	# Quiet moments alternate with the other seasonal encounters; no extra popup stack.
	if GameState.seasons_elapsed % 3 != 0:
		return {}
	var count := int(GameState.living_state.get("moment_count", 0))
	var cast := COMPANIONS.active_cast()
	var moment := "solitary"
	var name := ""
	if GameState.has_young and count % 2 == 0:
		moment = "young"
		name = MEMORIES.young_name()
	elif not cast.is_empty() and count % 2 == 0:
		moment = "companion"
		name = str(cast[count % cast.size()]["name"])
	elif not GameState.living_state.get("site", "").is_empty():
		moment = "home"
	GameState.living_state["event"] = {"kind": "moment", "moment": moment, "name": name}
	return pending_event()


static func pending_event() -> Dictionary:
	if not available():
		return {}
	var state: Dictionary = GameState.living_state.get("event", {})
	if state.is_empty():
		return GROUP_HOME.pending_event()
	var choices: Array = []
	var text := ""
	var title := "A quiet moment"
	if state["kind"] == "echo":
		var member := _member(str(state["name"]))
		if member.is_empty() or _memory(member, state).is_empty():
			GameState.living_state["event"] = {}
			return {}
		var good: bool = state["choice"] in ["share", "stand", "cover", "cooperate", "scout", "share_shelter", "council_backed", "council_heard"]
		title = "What they remember"
		text = "Season %d: %s\n\n" % [int(state["season"]) + 1, TRAITS.REMEMBERED[state["choice"]]]
		if not member.get("active", false):
			text += "%s appears across a familiar trail. They survived, but have made a life beyond your group. Their head lifts at your call; they wait to see whether you will give them space." % member["name"]
			choices.append({"action": "echo_space", "label": "Let them pass safely", "icon": "stalk", "sublabel": "Respect their distance; they remain outside the group"})
		elif good and COMPANIONS.relationship(member) == "Trusting":
			text += "%s pauses beside a fresh trail to food and looks back for you. They remember the time you made room for them. Today, they are ready to return that care." % member["name"]
			if member["name"] in COMPANIONS.supporters():
				choices.append({"action": "echo_help", "label": "Follow their lead", "icon": "bond", "sublabel": "+6% food · uses their help this season"})
			choices.append({"action": "echo_thanks", "label": "Rest beside them", "icon": "rest", "sublabel": "Acknowledge their care · small trust gain"})
		elif COMPANIONS.relationship(member) == "Trusting":
			text += "%s comes close again. They have not forgotten that earlier season, but the care you have given since has changed the space between you. There is room to rest together now." % member["name"]
			choices.append({"action": "echo_thanks", "label": "Stay beside them", "icon": "bond", "sublabel": "Recognize the bond you rebuilt · small trust gain"})
		else:
			text += "%s keeps a space between you. " % member["name"] + ("That earlier kindness still matters, but the bond needs care now." if good else "The earlier slight has outlasted the moment. When you approach, they wait for you to make the first move.")
			if GameState.hunger >= 0.04:
				choices.append({"action": "echo_repair", "label": "Leave room and a small portion", "icon": "bond", "sublabel": "4% food · rebuild trust through action"})
			choices.append({"action": "echo_space", "label": "Give them space", "icon": "stalk", "sublabel": "No cost · leave the relationship as it is"})
	else:
		match state["moment"]:
			"young":
				if not GameState.has_young or state["name"] != GameState.offspring_name:
					GameState.living_state["event"] = {}
					return {}
				text = "%s copies the way you pause to read the wind. Their first attempt is clumsy; they try again when you turn toward them. There is time to show them what you noticed." % state["name"]
				if GameState.hunger >= 0.03 and GameState.get_action_uses("family_lesson") == 0 and int(preload("res://scripts/systems/family_legacy.gd").ensure_child(str(state["name"]))["skills"]["cover"]) < 2:
					choices.append({"action": "moment_teach", "label": "Show them slowly", "icon": "nest", "sublabel": "3% food · practices cover · +5% care & bond · uses your family lesson"})
			"companion":
				var member := _member(str(state["name"]))
				if member.is_empty() or not member.get("active", false):
					GameState.living_state["event"] = {}
					return {}
				text = "%s settles " % state["name"] + ("close enough that your shoulders almost touch. Neither of you needs to keep watch alone." if COMPANIONS.relationship(member) == "Trusting" else "a little farther down the trail. They glance your way before lowering their head; there is room for the distance to close.")
				choices.append({"action": "moment_company", "label": "Stay beside them a while", "icon": "bond", "sublabel": "Small trust gain · no food cost"})
			"home":
				text = "You find your own tracks at the " + str(SITES.get(GameState.living_state.get("site", ""), {}).get("name", "familiar trail")).to_lower() + ". The wind carries familiar scents. For a little while, the ground asks nothing of you."
				choices.append({"action": "moment_rest", "label": "Take a moment to rest", "icon": "rest", "sublabel": "+2% health · keep this place in your memories"})
			"solitary":
				text = "The first light reaches your flank. You follow the small sounds in the brush without chasing them. Here, with no other dinosaur setting the pace, you can decide what this day will be."
				choices.append({"action": "moment_watch", "label": "Learn the sounds of this place", "icon": "stalk", "sublabel": "+2% feeding chance for this season"})
		choices.append({"action": "moment_move", "label": "Keep moving", "icon": "flee", "sublabel": "No cost · carry on with your season"})
	return _event(title, text, choices, "living")


static func resolve(choice: String) -> Dictionary:
	var event := pending_event()
	if event.is_empty():
		return _result("That moment has passed.")
	if not event["choices"].any(func(option): return option["action"] == choice):
		return event
	if choice == "alpha_home_ack": return GROUP_HOME.acknowledge()
	var state: Dictionary = GameState.living_state["event"]
	var text := ""
	if state["kind"] == "echo":
		var member := _member(str(state["name"]))
		var memory := _memory(member, state)
		memory["resolved"] = true
		match choice:
			"echo_help":
				member["help_season"] = GameState.seasons_elapsed
				GameState.hunger = minf(1.0, GameState.hunger + 0.06)
				text = "%s leads you to food, then waits while you eat. What you gave them in an earlier season has found its way back to you." % member["name"]
			"echo_repair":
				GameState.hunger -= 0.04
				COMPANIONS._change(member, 0.18, "You returned to an old hurt and made room for them.")
				text = "%s takes the portion slowly. One gesture cannot erase the earlier season, but this is a beginning they can remember too." % member["name"]
			"echo_thanks":
				COMPANIONS._change(member, 0.05, "You acknowledged the care they returned.")
				text = "You settle beside %s until the sounds of the range grow quiet. The bond between you has a history now." % member["name"]
			_:
				text = "You leave %s room to choose their own path. For a moment you share the trail, then each of you moves on." % member["name"]
	else:
		match choice:
			"moment_teach":
				GameState.hunger -= 0.03
				GameState.nesting_score = minf(1.0, GameState.nesting_score + 0.05)
				GameState.offspring_bond = minf(1.0, GameState.offspring_bond + 0.05)
				preload("res://scripts/systems/family_legacy.gd").teach(str(state["name"]), "cover")
				text = "%s waits for your pause, then copies it. This time, they turn toward the sound before you do. You give them the time to get it right." % state["name"]
			"moment_company":
				COMPANIONS._change(_member(str(state["name"])), 0.06, "You stayed beside them when there was nothing to ask for.")
				text = "You stay with %s. When the group moves again, the space between you is a little smaller." % state["name"]
			"moment_rest":
				GameState.health = minf(1.0, GameState.health + 0.02)
				text = "You rest on ground you know. When you rise, the next part of the trail feels a little less heavy."
			"moment_watch":
				GameState.living_state["watch_until"] = GameState.seasons_elapsed + 1
				text = "You learn which rustle belongs to feeding and which belongs to flight. For the rest of this season, the familiar sounds help you find food."
			_:
				text = "You carry the quiet moment with you and return to the trail."
		GameState.living_state["moment_count"] = int(GameState.living_state.get("moment_count", 0)) + 1
	MEMORIES.remember("living_%d" % GameState.seasons_elapsed, text, 8 if state["kind"] == "echo" else 5)
	GameState.living_state["event"] = {}
	GameState.living_state["last_event"] = GameState.seasons_elapsed
	return _finish(text)


static func _event(title: String, text: String, choices: Array, context: String) -> Dictionary:
	return {"type": "home_event" if context == "home" else "living_event", "image_key": _image_key(context), "title": title, "flavor": text, "choices": choices, "resolve_key": context, "next_context": context}


static func _image_key(context: String) -> String:
	var event: Dictionary = GameState.living_state.get("event", {})
	if context == "home" or (event.get("kind") == "moment" and event.get("moment") == "home"):
		var site := str(GameState.living_state.get("site", ""))
		if site == "river" and GameState.world_state.get("kind") == "flood" and GameState.seasons_elapsed < int(GameState.world_state.get("until", -1)):
			return "flooded_rivers"
		return "home_" + site if site in SITES else "home_event"
	if event.get("kind") == "moment" and event.get("moment") == "solitary":
		return "living_solitary_dawn"
	if event.get("kind") == "moment" and event.get("moment") == "young" and GameState.species_id in ["trex", "allosaurus", "ankylosaurus"]:
		return GameState.species_id + "_teaching_young"
	# Only species with a complete art set use species-specific living scenes.
	if GameState.species_id not in ["iguanodon", "deinonychus", "triceratops", "velociraptor", "compsognathus", "lesothosaurus", "argentinosaurus"]:
		return "living_event"
	var prefix := GameState.species_id + "_"
	if event.get("kind") == "moment" and event.get("moment") == "young":
		return prefix + "teaching_young"
	var member := _member(str(event.get("name", "")))
	if member.is_empty():
		return "living_event"
	if not member.get("active", false) or COMPANIONS.relationship(member) != "Trusting":
		return prefix + "wary_distance"
	if event.get("kind") == "echo" and event.get("choice") in ["share", "stand", "cover", "cooperate", "scout", "share_shelter", "council_backed", "council_heard"]:
		return prefix + "returned_care"
	return prefix + "resting_together"


static func _result(text: String) -> Dictionary:
	return {"type": "result", "flavor": text, "choices": []}


static func _finish(text: String) -> Dictionary:
	GameState.save_run()
	TurnManager.stat_changed.emit()
	return _result(text)
