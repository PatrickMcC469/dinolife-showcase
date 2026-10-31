extends RefCounted

const LIFE_STORY = preload("res://scripts/systems/life_story.gd")
const TRAITS = preload("res://scripts/systems/companion_traits.gd")
const PAIRS = preload("res://scripts/systems/pack_relationships.gd")
const SPECIES = ["compsognathus", "iguanodon", "deinonychus", "triceratops", "velociraptor", "lesothosaurus", "argentinosaurus"]
const TRUSTING := 0.6
const DISTANT := -0.4
const STORIES = {
	"argentinosaurus": {
		"steady": "Patient trailkeeper", "challenger": "Driven pathfinder",
		"intro_title": "Rumbles beside you",
		"intro": "%s answers your low rumbles and waits where the trail narrows. %s presses ahead toward fresh leaves, impatient with the slower pace. Both travel with your %s, each finding a different way through the long seasons.",
		"share_title": "Browse for a friend",
		"share": "%s waited at the crossing while the herd reached fresh browse. You have eaten, but they still search the stripped branches. Will you spare part of your portion?",
		"protect_title": "The bank gives way",
		"protect": "The riverbank crumbles beneath %s. The %s moves toward firmer ground, leaving them struggling for a foothold. You can brace beside them, guide them uphill, or call from safety. Moving on would leave them behind.",
		"lead_title": "A pace for everyone",
		"lead": "%s wants the %s to reach greener ground before the slower members are ready. Finding a route together takes energy. You could also let them scout ahead, or insist that they keep your pace.",
		"stand_label": "Brace beside %s", "cover_label": "Guide them uphill", "warn_label": "Call from firm ground",
		"cooperate_label": "Find a steadier route", "scout_label": "Let them test the trail",
		"shared": "%s eats the browse you spare. When you call again, their answering rumble comes from close beside you.",
		"protected": "%s reaches firm ground beside you. %s Once their footing is steady, they answer you with a low rumble.",
		"wounded": "Rolling stones scrape your flank as you brace along the bank.",
		"cooperated": "%s checks the next stretch and returns to your side. Together, you find a pace the herd can manage.",
		"forced": "%s keeps your pace, but leaves more space between you. Their next answering rumble comes from farther down the trail.",
		"warned": "%s hears your rumble from firm ground and turns toward the stable bank. You kept clear of the crumbling edge, but gave them a direction to follow.",
	},
	"velociraptor": {
		"steady": "Reliable flanker", "challenger": "Rank-minded hunter",
		"intro_title": "Signals in the dust",
		"intro": "%s stays at your flank, waiting for each signal before moving. %s takes the forward position and watches who gives way. Both hunt with your %s, where a shared meal can matter as much as a successful chase.",
		"share_title": "The first bite",
		"share": "%s guarded your blind side during the hunt. Now the other hunters are feeding, but your partner still waits beside the kill. You can share a little of your portion or keep it for yourself.",
		"protect_title": "Shadow on the trail",
		"protect": "A larger hunter follows your trail through the brush. %s has fallen behind the %s, exposed at a narrow crossing. You can turn back beside them, guide them through another gap, or let them escape alone.",
		"lead_title": "A signal too soon",
		"lead": "%s signals the %s forward before the flankers are ready. You can spend energy working out the timing together, let them test an approach, or insist they wait for your signal.",
		"cover_label": "Guide them through brush", "cooperate_label": "Agree on the signals", "scout_label": "Let them test a flank",
		"shared": "%s takes the food you spare, then settles at your flank. They stay close as the other hunters move away.",
		"protected": "%s returns to your flank. %s The hunting line comes together again, with your partner safely beside you.",
		"cooperated": "%s tests the flank and waits for the agreed signal. This time, the hunters move together.",
		"forced": "%s follows your signal, but no longer looks your way between hunts. They keep their place in the formation and their distance from you.",
		"warned": "%s catches your call from the brush and slips through the crossing. You kept yourself clear of the larger hunter, but gave your partner a way out.",
	},
	"lesothosaurus": {
		"steady": "Watchful lookout", "challenger": "Restless pathfinder",
		"intro_title": "Calls in the grass",
		"intro": "%s pauses between mouthfuls to watch the grass, ready to call a warning. %s keeps trying the gaps ahead, eager to choose the next path. Both belong to your %s, and their familiar calls are becoming easier to pick out.",
		"share_title": "A lookout's turn",
		"share": "%s kept watch while the herd fed on tender shoots. You have eaten, but they have barely grazed. You could spare a few mouthfuls, or keep your reserves.",
		"protect_title": "Lost in the grass",
		"protect": "A predator's rush scatters the grass. %s loses sight of the %s and turns toward an exposed gap. You can draw danger away from them, spend energy guiding them into cover, call a warning from safety, or keep running without them.",
		"lead_title": "Which gap is safe?",
		"lead": "%s wants the %s to use a narrow gap, though tall grass hides the far side. Checking it together takes energy. You could let them try it first, or insist on your own route.",
		"stand_label": "Draw danger from %s", "cover_label": "Guide them into grass", "warn_label": "Call from the grass",
		"cooperate_label": "Scout the escape route", "scout_label": "Let them try the path",
		"shared": "%s eats the shoots you spare. When your next warning sounds, their answer comes quickly through the grass.",
		"protected": "%s reaches cover beside the herd. %s You pause together while the movement in the open grass fades.",
		"wounded": "A glancing blow catches you as you draw the predator aside.",
		"cooperated": "%s tries the gaps and returns to your side. You found a route together, and their restless energy has a place in the herd.",
		"forced": "%s takes your chosen path, but their answering calls grow quieter. They stay with the herd, farther from your side.",
		"warned": "%s hears your call through the grass and turns into cover. You did not risk another hit, but you kept them within the herd's warnings.",
	},
	"deinonychus": {
		"steady": "Dependable scout", "challenger": "Ambitious hunter",
		"intro_title": "Hunters beside you",
		"intro": "%s checks the wind and waits for your signal. %s edges ahead, eager for the first strike. These two hunters share your %s, learning your habits while you learn theirs.",
		"share_title": "A hunter's share",
		"share": "%s helped drive the prey out of the brush. You have your portion, but they still wait at the edge of the kill. Will you make room for them to eat?",
		"protect_title": "The hunt breaks apart",
		"protect": "A larger predator scatters the hunters. %s is cut off from the %s, with no one between them and the threat. You can stand beside them, draw them through cover, or leave them to find their own way out.",
		"lead_title": "Who calls the hunt?",
		"lead": "%s wants to rush the next hunt before the %s has found its positions. You can spend energy planning the approach together, let them scout first, or insist they follow your timing. The other hunters wait to see whether you can move as one.",
		"cover_label": "Draw them into cover", "cooperate_label": "Plan the hunt together", "scout_label": "Let them scout first",
		"shared": "%s takes the portion you spare and eats beside you. For a moment, neither hunter needs to keep watch alone.",
		"protected": "%s slips back into the hunting line beside you. %s You move on together as the pack regroups.",
		"cooperated": "%s tests the approach, then waits for your signal. The rest of the pack has time to take its positions.",
		"forced": "%s follows your timing, but keeps their distance between hunts. You won the argument and strained the trust of a hunting partner.",
	},
	"triceratops": {
		"steady": "Steady herd guardian", "challenger": "Bold challenger",
		"intro_title": "A place in the circle",
		"intro": "%s closes gaps in the defensive circle. %s steps toward every warning, eager to hold the outer line. Both stand with your %s, and you are beginning to recognize their movements without looking twice.",
		"share_title": "Room at the browse",
		"share": "%s has held the exposed edge while the herd feeds. Your portion of browse is set aside, but they have not eaten. Making room costs some of your reserves; keeping it leaves a guardian waiting outside the feeding line.",
		"protect_title": "A gap between the horns",
		"protect": "The defensive circle opens as a predator tests the herd. %s is left at the gap, separated from the %s. You can brace beside them, guide them toward the center, or leave the gap to them alone.",
		"lead_title": "Where the line holds",
		"lead": "%s wants the %s to brace farther out on open ground. You can spend energy choosing positions together, let them test the edge, or order them behind your line.",
		"cover_label": "Guide them to center", "cooperate_label": "Plan the line together", "scout_label": "Let them test the edge",
		"shared": "%s moves into the browse you leave. After feeding, they return to their place beside the herd.",
		"protected": "%s reaches the herd's circle beside you. %s The gap closes because you chose to stay with them.",
		"cooperated": "%s checks the outer ground and returns to your side. Together, you choose where the line will hold.",
		"forced": "%s takes the place you insist on behind the line. The formation holds, but they leave more space between you. Their courage has been met with orders.",
	},
}


static func supported() -> bool:
	return max_companions() > 0 and GameState.life_stage >= 1


static func max_companions() -> int:
	var species := SpeciesDB.get_species(GameState.species_id)
	if GameState.species_id not in SPECIES or not species.get("pack_species", false):
		return 0
	return 4 if species.get("tree") == "predator" and GameState.species_id != "compsognathus" else 6


static func group_name() -> String:
	return "herd" if SpeciesDB.get_species(GameState.species_id).get("tree") == "herbivore" else "pack"


static func _text(key: String, fallback: String) -> String:
	return STORIES.get(GameState.species_id, {}).get(key, fallback)


static func personality(member: Dictionary) -> String:
	if member["role"] == "member":
		return "Herd companion" if group_name() == "herd" else "Hunting partner"
	return _text(str(member["role"]), "Dependable companion" if member["role"] == "steady" else "Ambitious challenger")


static func ensure_cast() -> void:
	if not supported():
		return
	if GameState.pack_bond <= 0.0:
		leave_group("The group broke apart.")
		GameState.is_alpha = false
	elif current_cast().is_empty():
		new_group()
	else:
		var present := current_cast().filter(func(member: Dictionary): return member.get("active", false))
		for member in current_cast():
			TRAITS.ensure(member)
		for member in present.slice(max_companions()):
			_depart(member, "The group became too crowded, and they found another path.")
		_check_empty_group()
	PAIRS.sync()


static func new_group() -> void:
	if not supported() or GameState.pack_bond <= 0.0:
		return
	leave_group("You moved on to a different group.")
	# Give pre-roster saves' last two companions a group before moving on.
	current_cast()
	GameState.companion_group_id += 1
	for index in randi_range(3, max_companions()):
		_add_member(LIFE_STORY._new_name(), ["steady", "challenger"][index] if index < 2 else "member")
	GameState.companion_event_count = 0
	GameState.companion_last_event_season = -1


static func current_cast() -> Array:
	if not supported():
		return []
	if GameState.companion_group_id == 0 and not GameState.companions.is_empty():
		# Old saves archive earlier pairs. Keep the final pair and all its trust.
		GameState.companion_group_id = 1
		for member in GameState.companions.slice(maxi(0, GameState.companions.size() - 2)):
			member["group_id"] = 1
	return GameState.companions.filter(func(member: Dictionary): return int(member.get("group_id", 0)) == GameState.companion_group_id)


static func active_cast() -> Array:
	return current_cast().filter(func(member: Dictionary): return member.get("active", false)).slice(0, max_companions())


static func _add_member(member_name: String, role: String = "member") -> void:
	if not supported() or GameState.pack_bond <= 0.0 or active_cast().size() >= max_companions():
		return
	GameState.companions.append({"name": member_name, "role": role, "active": true,
		"group_id": GameState.companion_group_id,
		"trust": 0.35 if role == "steady" else 0.0, "reason": "Still learning whether to rely on you.",
		"help_season": -1, "bond_season": -1})
	TRAITS.ensure(GameState.companions.back())
	PAIRS.sync()


static func _check_empty_group() -> void:
	if GameState.pack_bond > 0.0 and active_cast().is_empty():
		PackManager.trigger_disband("The last companion has left. You are traveling alone now.")


static func relationship(member: Dictionary) -> String:
	if not member.get("active", false):
		return "Gone"
	var trust := float(member.get("trust", 0.0))
	if trust >= TRUSTING:
		return "Trusting"
	if trust <= DISTANT:
		return "Distant"
	return "Wary"


static func leave_group(reason: String) -> void:
	GameState.pack_alpha_name = ""
	GameState.companion_event = {}
	for member in GameState.companions:
		if member.get("active", false):
			_depart(member, reason)


static func _depart(member: Dictionary, reason: String) -> void:
	member["active"] = false
	member["reason"] = reason
	LIFE_STORY.remember("companion_left_" + member["name"], "%s left the %s. %s" % [member["name"], group_name(), reason], 9)
	PAIRS.sync()


static func _change(member: Dictionary, amount: float, reason: String) -> void:
	member["trust"] = clampf(float(member.get("trust", 0.0)) + amount, -1.0, 1.0)
	member["reason"] = reason
	if float(member["trust"]) <= -0.8:
		_depart(member, "Too many seasons without your support.")


static func bond_effort() -> void:
	for member in current_cast():
		if member.get("active", false) and int(member.get("bond_season", -1)) != GameState.seasons_elapsed:
			member["bond_season"] = GameState.seasons_elapsed
			_change(member, 0.1, "You made time to strengthen the group.")


static func group_response(amount: float, reason: String, remembered_choice: String = "") -> void:
	if not supported() or GameState.pack_bond <= 0.0:
		return
	ensure_cast()
	for member in current_cast():
		if member.get("active", false):
			_change(member, amount, reason)
			TRAITS.record(member, remembered_choice)
	_check_empty_group()


static func supporters() -> Array[String]:
	var names: Array[String] = []
	if not supported() or GameState.pack_bond <= 0.0 or GameState.health <= 0.0:
		return names
	for member in active_cast():
		if relationship(member) == "Trusting" and int(member.get("help_season", -1)) != GameState.seasons_elapsed and GameState.seasons_elapsed >= int(member.get("rest_until", -1)):
			names.append(str(member["name"]))
	return names


static func take_support(context: String, excluded: String = "") -> Array[String]:
	var names := supporters()
	names.erase(excluded)
	for member in current_cast():
		if member["name"] in names:
			member["help_season"] = GameState.seasons_elapsed
			LIFE_STORY.remember("companion_help_%s_%d" % [member["name"], GameState.seasons_elapsed],
				"%s stood beside you %s, remembering the support you gave them." % [member["name"], context], 9)
	PAIRS.cooperation(names)
	return names


static func next_event() -> Dictionary:
	ensure_cast()
	if not supported() or GameState.pack_bond <= 0.0 or GameState.health <= 0.0:
		return {}
	if not GameState.companion_event.is_empty():
		return pending_event()
	if GameState.companion_last_event_season >= 0 and GameState.seasons_elapsed < GameState.companion_last_event_season + 2:
		return {}
	var active := active_cast()
	if active.is_empty():
		return {}
	var step := GameState.companion_event_count
	if step > 0 and step % 5 == 0 and active.size() < max_companions() and GameState.pack_bond >= 0.4:
		GameState.companion_event = {"kind": "join", "name": LIFE_STORY._new_name(), "season": GameState.seasons_elapsed}
		return pending_event()
	var kind: String = "intro" if step == 0 else ["share", "protect", "lead", "shelter"][(step - 1) % 4]
	var member: Dictionary = active[(step - 1) % active.size()] if step > 0 else active[0]
	if kind == "lead" and active.size() <= 2:
		for candidate in active:
			if candidate.get("role") == "challenger":
				member = candidate
	GameState.companion_event = {"kind": kind, "name": member["name"], "season": GameState.seasons_elapsed}
	return pending_event()


static func pending_event() -> Dictionary:
	if GameState.companion_event.is_empty() or not supported() or GameState.pack_bond <= 0.0:
		return {}
	var pending := GameState.companion_event
	if pending.get("kind") == "join":
		var join_choices: Array = []
		var has_room := active_cast().size() < max_companions()
		if has_room:
			join_choices.append({"label": "Welcome " + str(pending["name"]), "icon": "bond", "sublabel": "A new companion with their own trust", "action": "accept_member"})
		join_choices.append({"label": "Keep the group as it is", "icon": "stalk", "sublabel": "Continue with your current companions", "action": "decline_member"})
		var invitation := "There is room to welcome another companion if you want to make it." if has_room else "Your group is full. You continue with the companions already beside you."
		return {"type": "companion_event", "resolve_key": "companions", "next_context": "companions",
			"title": "A new face on the trail", "flavor": "%s keeps pace beside your %s, answering its calls from a little farther away. %s\n\nCompanions: %d of %d." % [pending["name"], group_name(), invitation, active_cast().size(), max_companions()], "choices": join_choices}
	var member: Dictionary = _find(str(pending.get("name", "")))
	if member.is_empty() or not member.get("active", false):
		GameState.companion_event = {}
		return {}
	var kind: String = pending.get("kind", "")
	var member_name: String = member["name"]
	var flavor := ""
	var title := ""
	var choices: Array = []
	match kind:
		"intro":
			var cast := active_cast()
			title = _text("intro_title", "Two familiar shapes")
			if cast.size() >= 2:
				flavor = _text("intro", "%s checks the path before settling beside you. %s presses ahead and watches who follows. Both are part of your %s now, and their familiar calls stand out from the others.") % [cast[0]["name"], cast[1]["name"], group_name()]
			else:
				flavor = "%s keeps pace beside you, still learning whether to answer your calls." % cast[0]["name"]
			if cast.size() > 2:
				var others: Array = cast.slice(2).map(func(candidate: Dictionary): return candidate["name"])
				flavor += "\n\n%s %s with you too." % [LIFE_STORY.names_text(others), "travels" if others.size() == 1 else "travel"]
			flavor += "\n\nThere are %d in your %s, including you." % [cast.size() + 1, group_name()]
			choices = [{"label": "Make room for them", "icon": "bond", "sublabel": "Start building trust", "action": "welcome"},
				{"label": "Keep your distance", "icon": "stalk", "sublabel": "Let trust come slowly", "action": "distance"}]
		"share":
			title = _text("share_title", "Who eats first?")
			var food_intro := "The dry season has thinned the feeding grounds. " if GameState.current_season == 1 else "You reach a small patch of food first. "
			flavor = _text("share", food_intro + "%s waits nearby, watching you feed. You could make room and share a little, or keep the food for yourself.") % member_name
			if GameState.hunger >= 0.08:
				choices.append({"label": "Share with " + member_name, "icon": "bond", "sublabel": "Give up a little food; build trust", "action": "share"})
			else:
				flavor += "\n\nYour reserves are too low to spare a portion."
			choices.append({"label": "Keep your portion", "icon": "stalk", "sublabel": "Preserve food; they may pull away", "action": "keep"})
		"protect":
			title = _text("protect_title", "Caught at the edge")
			flavor = _text("protect", "%s has fallen behind the %s as a predator crosses its edge. You can return to their side, guide them through cover, or warn them from safety. Moving on would leave them alone.") % [member_name, group_name()]
			if GameState.health > 0.08:
				choices.append({"label": _text("stand_label", "Stand beside %s") % member_name, "icon": "shield", "sublabel": "Costs health; build trust", "action": "stand"})
			else:
				flavor += "\n\nYou are too wounded to take another hit for them."
			if GameState.hunger >= 0.05:
				choices.append({"label": _text("cover_label", "Lead them through cover"), "icon": "flee", "sublabel": "Costs food; safer protection", "action": "cover"})
			choices.append({"label": _text("warn_label", "Warn them from cover"), "icon": "stalk", "sublabel": "Keep your distance; offer a warning", "action": "warn"})
			choices.append({"label": "Leave them behind", "icon": "stalk", "sublabel": "They will leave your group", "action": "abandon"})
		"lead":
			title = _text("lead_title", "A different direction")
			flavor = _text("lead", "%s pushes toward a new route before the %s is ready. They want their judgment to count. The others watch how you respond.") % [member_name, group_name()]
			if GameState.hunger >= 0.05:
				choices.append({"label": _text("cooperate_label", "Choose the route together"), "icon": "bond", "sublabel": "Costs food; earn their cooperation", "action": "cooperate"})
			choices.append({"label": _text("scout_label", "Let them scout ahead"), "icon": "stalk", "sublabel": "Show a little confidence in them", "action": "scout"})
			choices.append({"label": "Force them to follow", "icon": "attack", "sublabel": "Keep control; strain their trust", "action": "force"})
		"shelter":
			var shelter := preload("res://scripts/systems/companion_shelters.gd").story()
			title = shelter["title"]
			flavor = str(shelter["intro"]) % [member_name, group_name()]
			if GameState.hunger >= 0.06:
				choices.append({"label": "Make room for " + member_name, "icon": "bond", "sublabel": "6% food; prepare shared shelter", "action": "share_shelter"})
			choices.append({"label": "Show another sheltered spot", "icon": "stalk", "sublabel": "No cost; offer a little help", "action": "guide_shelter"})
			choices.append({"label": "Keep the best spot", "icon": "rest", "sublabel": "No cost; strain their trust", "action": "keep_shelter"})
		_:
			GameState.companion_event = {}
			return {}
	var hint := TRAITS.hint(member, kind)
	if not hint.is_empty():
		flavor += "\n\n" + hint
	return {"type": "companion_event", "resolve_key": "companions", "next_context": "companions",
		"title": title, "flavor": flavor, "choices": choices}


static func _find(member_name: String) -> Dictionary:
	for member in current_cast():
		if member.get("name", "") == member_name:
			return member
	return {}


static func resolve(choice: String) -> Dictionary:
	var event := pending_event()
	if event.is_empty():
		return {"type": "result", "flavor": "The moment has passed.", "choices": []}
	var allowed: Array = event["choices"].map(func(option: Dictionary): return option["action"])
	if choice not in allowed:
		return event  # State can change while a saved popup is waiting; show current options.
	if GameState.companion_event.get("kind") == "join":
		var newcomer: String = GameState.companion_event["name"]
		var welcome := choice == "accept_member"
		if welcome:
			_add_member(newcomer)
			LIFE_STORY.remember("companion_joined_" + newcomer, "Welcomed %s into the %s." % [newcomer, group_name()], 7)
		return _finish_event("%s falls into step beside you. Trust will grow through the seasons you share." % newcomer if welcome else "%s lets the group move on and follows another trail. You continue with your familiar companions." % newcomer)
	var member := _find(str(GameState.companion_event["name"]))
	var member_name: String = member["name"]
	var flavor := ""
	TRAITS.record(member, choice)
	match choice:
		"welcome", "distance":
			for candidate in active_cast():
				_change(candidate, 0.25 if choice == "welcome" else -0.1,
					"You made room for them." if choice == "welcome" else "You kept your distance at first.")
			flavor = "They settle beside you, answering your calls as the group moves on. You have time ahead to learn one another's habits." if choice == "welcome" else "They leave some space between you and follow the others. Trust will have to come more slowly."
			var names: Array = active_cast().map(func(candidate: Dictionary): return candidate["name"])
			LIFE_STORY.remember("companions_met_" + str(GameState.companion_group_id), "Shared the %s with %s." % [group_name(), LIFE_STORY.names_text(names)], 6)
		"share":
			GameState.hunger = maxf(0.0, GameState.hunger - 0.08)
			_change(member, 0.4, "You shared food when they were waiting.")
			flavor = _text("shared", "%s eats the portion you spare, then stays beside you as the others move on.") % member_name
			LIFE_STORY.remember("companion_shared_" + member_name, "Shared scarce food with %s." % member_name, 7)
		"keep":
			_change(member, -0.4, "You kept the food for yourself.")
			flavor = "%s turns away from the feeding ground. You kept your reserves, but the distance between you has grown." % member_name
		"stand", "cover":
			if choice == "stand":
				GameState.health -= 0.06
			else:
				GameState.hunger = maxf(0.0, GameState.hunger - 0.05)
			_change(member, (0.5 if choice == "stand" else 0.3) + TRAITS.affinity(member, choice), "You protected them when they were exposed.")
			var cost := _text("wounded", "You carry a small wound from standing between them and the threat.") if choice == "stand" else "The safer route cost you energy, but kept you both out of danger."
			flavor = _text("protected", "%s reaches safety beside you. %s You pause together until the danger passes.") % [member_name, cost]
			LIFE_STORY.remember("companion_protected_%s_%d" % [member_name, GameState.seasons_elapsed], "Protected %s when danger reached the edge of the %s." % [member_name, group_name()], 8)
		"abandon":
			_depart(member, "You left them exposed to danger.")
			flavor = "%s finds another way out. By the time the %s settles, they are gone. You chose your own safety; they chose not to rely on you again." % [member_name, group_name()]
		"warn":
			_change(member, 0.1, "You warned them while keeping yourself out of danger.")
			flavor = _text("warned", "%s hears your warning and finds cover. You kept your distance, but you did not leave them without a signal.") % member_name
		"cooperate", "scout":
			if choice == "cooperate":
				GameState.hunger = maxf(0.0, GameState.hunger - 0.05)
			_change(member, (0.4 if choice == "cooperate" else 0.1) + TRAITS.affinity(member, choice), "You gave their judgment a place in the group.")
			flavor = _text("cooperated", "%s checks the route, then looks back for you. This time, they wait until you are ready to follow.") % member_name
		"force":
			_change(member, -0.5, "You forced them to follow instead of listening.")
			flavor = _text("forced", "%s follows your chosen route but keeps away from your side. Their answering calls are less frequent now.") % member_name
		"share_shelter", "guide_shelter", "keep_shelter":
			var share: bool = choice == "share_shelter"
			var guide: bool = choice == "guide_shelter"
			if share: GameState.hunger -= 0.06
			_change(member, 0.3 if share else (0.1 if guide else -0.3), "You prepared shelter beside them." if share else ("You showed them another sheltered spot." if guide else "You kept the best shelter for yourself."))
			flavor = (str(preload("res://scripts/systems/companion_shelters.gd").story()["result"]) if share else ("%s follows your signal to another sheltered spot. You kept your own place and still gave them a little help." if guide else "%s settles farther away. You kept the best cover, but they remember being left at its edge.")) % member_name
			if share:
				LIFE_STORY.remember("companion_sheltered_%s_%d" % [member_name, GameState.seasons_elapsed], "Prepared shared shelter with %s." % member_name, 7)
	if not member.get("active", false) and choice != "abandon":
		flavor += "\n\n%s leaves the %s. The trust between you no longer holds." % [member_name, group_name()]
	if active_cast().is_empty():
		flavor += "\n\nNo companions remain. You are traveling alone now."
	_check_empty_group()
	return _finish_event(flavor)


static func _finish_event(flavor: String) -> Dictionary:
	GameState.companion_event = {}
	GameState.companion_last_event_season = GameState.seasons_elapsed
	GameState.companion_event_count += 1
	return {"type": "result", "flavor": flavor, "choices": []}
