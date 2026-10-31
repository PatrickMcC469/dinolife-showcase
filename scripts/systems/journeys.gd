extends RefCounted

const COMPANIONS = preload("res://scripts/systems/companions.gd")
const LIFE_STORY = preload("res://scripts/systems/life_story.gd")
const WORLD = preload("res://scripts/systems/world_conditions.gd")
const PERSONAL = preload("res://scripts/systems/personal_journeys.gd")
const SPECIES = {"migration": ["iguanodon", "argentinosaurus"], "territory": ["compsognathus", "velociraptor"], "personal": ["deinonychus", "triceratops", "lesothosaurus", "ankylosaurus", "allosaurus", "trex"]}
const TITLES = {"migration": "The greener valley", "territory": "The disputed range", "personal": "A new feeding ground"}


static func restore(value: Variant, species: String) -> Dictionary:
	if not value is Dictionary or species not in SPECIES.get(value.get("kind", ""), []):
		return {}
	var phase = value.get("phase")
	if not (phase is int or phase is float):
		return {}
	if int(phase) not in [0, 1, 2, 3] or float(phase) != float(int(phase)) or value.get("route", "") not in ["", "ridge", "river", "share", "hold", "careful_route", "bold_route"]:
		return {}
	var state: Dictionary = {"kind": value["kind"], "phase": int(value["phase"]), "route": str(value.get("route", "")),
		"pending": value.get("pending", false) == true}
	if state["phase"] in [1, 2] and state["route"].is_empty():
		return {}
	var routes: Array = {"migration": ["", "ridge", "river"], "territory": ["", "share", "hold"], "personal": ["", "careful_route", "bold_route"]}[state["kind"]]
	if state["route"] not in routes:
		return {}
	for key in ["due", "reward_until"]:
		var number = value.get(key, -1)
		state[key] = int(number) if number is int or number is float else -1
	for key in ["advisor", "outcome", "crossing"]:
		state[key] = value.get(key, "") if value.get(key, "") is String else ""
	var reward = value.get("reward", 0.0)
	state["reward"] = clampf(float(reward), 0.0, 0.05) if reward is int or reward is float else 0.0
	if state["phase"] == 3:
		state["pending"] = false
	return state


static func next_event() -> Dictionary:
	if GameState.health <= 0.0 or GameState.life_stage < 2:
		return {}
	if not GameState.journey_state.is_empty():
		if GameState.journey_state.get("phase", 3) == 3 or GameState.seasons_elapsed < int(GameState.journey_state.get("due", 0)):
			return {}
		GameState.journey_state["pending"] = true
		return pending_event()
	# Meet the companions first. Later, parent and mating events retain priority.
	if GameState.species_id in PERSONAL.STORIES:
		if COMPANIONS.supported() and GameState.pack_bond > 0.0 and GameState.companion_event_count == 0:
			return {}
		GameState.journey_state = {"kind": "personal", "phase": 0, "route": "", "due": GameState.seasons_elapsed, "pending": true}
		return pending_event()
	if GameState.pack_bond <= 0.0 or GameState.companion_event_count == 0 or not GameState.companion_event.is_empty():
		return {}
	var story := ""
	if GameState.species_id in SPECIES["migration"] and (GameState.current_season == 1 or WORLD.kind() in ["drought", "shortage"]):
		story = "migration"
	elif GameState.species_id in SPECIES["territory"] and (GameState.current_season == 3 or WORLD.kind() == "rivals"):
		story = "territory"
	if story.is_empty():
		return {}
	GameState.journey_state = {"kind": story, "phase": 0, "route": "", "due": GameState.seasons_elapsed, "pending": true}
	return pending_event()


static func _advice(role: String, suggestion: String) -> String:
	for member in COMPANIONS.current_cast():
		if member.get("active", false) and member.get("role") == role:
			return "%s %s" % [member["name"], suggestion]
	return "No familiar companion is here to advise this route."


static func _choice(choices: Array, id: String, label: String, food: float = 0.0, health: float = 0.0) -> void:
	if GameState.hunger >= food and GameState.health > health:
		var parts := label.split(" · ", true, 1)
		choices.append({"action": id, "label": parts[0], "sublabel": parts[1] if parts.size() > 1 else "", "icon": "stalk"})


static func _crossing_cost() -> float:
	if GameState.journey_state["kind"] == "territory":
		return 0.06
	if GameState.journey_state["route"] == "ridge":
		return 0.04
	return 0.10 if WORLD.kind() == "flood" else 0.08


static func pending_event() -> Dictionary:
	var state := GameState.journey_state
	if state.get("kind") == "personal":
		return PERSONAL.pending_event()
	if not state.get("pending", false) or state.get("phase", 3) == 3 or GameState.health <= 0.0:
		return {}
	var migration: bool = state["kind"] == "migration"
	var phase := int(state["phase"])
	var choices: Array = []
	var text := ""
	var title: String = TITLES[state["kind"]]
	if phase == 0:
		if migration:
			text = "The herd's feeding ground is thinning. Beyond the ridge lies a greener valley, two seasons away. The high trail avoids the river but costs more food. The river trail is shorter to each resting place; a flood can make its crossing dangerous.\n\n%s\n%s" % [_advice("steady", "favors the high trail, away from the banks."), _advice("challenger", "wants to follow the river toward fresher growth.")]
			_choice(choices, "ridge", "Take the high trail · 8% food", 0.08)
			_choice(choices, "river", "Follow the river · 4% food", 0.04)
		else:
			text = "Another small pack is feeding across your boundary. You can spend the next two seasons sharing the range or holding its edge. A shared range offers a quieter truce; holding it demands food and risks wounds.\n\n%s\n%s" % [_advice("steady", "calls for a shared feeding ground."), _advice("challenger", "wants the pack to hold its boundary.")]
			_choice(choices, "share", "Offer a shared range · 8% food", 0.08)
			_choice(choices, "hold", "Patrol the boundary · 6% food", 0.06)
		_choice(choices, "leave", "Stay clear · End this story without a cost")
	elif phase == 1:
		if migration:
			title = "Crossing the trail"
			var river: bool = state["route"] == "river"
			var flooded: bool = river and WORLD.kind() == "flood"
			text = ("The river is swollen. Your shorter route has reached a dangerous crossing." if flooded else ("Your river route reaches a narrow crossing. The far bank is close, but its footing is loose." if river else "The high trail reaches a rocky pass. You kept clear of the river, but the climb takes energy."))
			text += "\n\nYou can search for firm ground, risk an injury by pushing through, or turn back. The valley is still one season away."
			_choice(choices, "careful", "Find firm ground · 8% food", 0.08)
			var cost := _crossing_cost()
			_choice(choices, "push", "Push through · %d%% health" % roundi(cost * 100), 0.0, cost)
		else:
			title = "The other pack returns"
			text = "The rival pack returns to " + ("the shared feeding ground. A small portion can keep the truce alive." if state["route"] == "share" else "the boundary you patrolled. Holding it will cost another wound; making room costs food.")
			text += "\n\nYour choice now decides whether the range becomes shared or defended. One more season will show what holds."
			_choice(choices, "careful", "Make room · 6% food", 0.06)
			_choice(choices, "push", "Hold the line · 6% health", 0.0, 0.06)
		if not COMPANIONS.supporters().is_empty():
			_choice(choices, "together", "With trusted companions · 3% food", 0.03)
			text += "\n\n%s can help you %s, using their support for this season." % [LIFE_STORY.names_text(COMPANIONS.supporters()), "find a safer crossing" if migration else "keep your chosen agreement"]
		_choice(choices, "leave", "Turn back · End this story without a cost")
	else:
		if migration:
			title = "The greener valley"
			text = "The valley finally opens below you. The " + ("high trail kept you above the banks." if state["route"] == "ridge" else "river trail brought you to the fresh growth.")
			text += "\n\nSettle at the sheltered edge for 20% food and easier feeding for three seasons. The richest browse gives 35% food, but crossing its exposed approach costs 7% health."
			_choice(choices, "settle", "Settle at the edge · +20% food; feeding bonus for 3 seasons")
			_choice(choices, "rich", "Reach the rich browse · −7% health", 0.0, 0.07)
		else:
			title = "A lasting boundary"
			text = "The calls across the range have changed. " + ("Both packs are leaving room at the feeding ground. Accepting the truce gives 15% food and a modest feeding and territory advantage for three seasons." if state["route"] == "share" else "The other pack waits beyond your line. Holding the range gives 20% food and a stronger feeding and territory advantage for three seasons, at a final cost of 5% health.")
			_choice(choices, "settle", "Accept the truce · +15% food" if state["route"] == "share" else "Hold the range · −5% health", 0.0, 0.0 if state["route"] == "share" else 0.05)
		_choice(choices, "leave", "Move on · End without a bonus")
	if GameState.pack_bond <= 0.0:
		text += "\n\nYour group is no longer with you. You will have to finish the journey alone."
	var event := {"type": "journey_event", "title": title, "flavor": text, "choices": choices, "resolve_key": "journey", "next_context": "journey"}
	preload("res://scripts/systems/journey_stories.gd").customize(event, state)
	return event


static func _listen(route: String) -> void:
	var role := "steady" if route in ["ridge", "share"] else "challenger"
	for member in COMPANIONS.current_cast():
		if member.get("active", false) and member.get("role") == role:
			GameState.journey_state["advisor"] = member["name"]
			COMPANIONS._change(member, 0.15, "You listened when they offered a path forward.")
			LIFE_STORY.remember("journey_advice_" + member["name"], "Listened to %s while choosing how to %s." % [member["name"], "migrate" if route in ["ridge", "river"] else "meet a rival pack"], 7)
			return


static func resolve(choice: String) -> Dictionary:
	if GameState.journey_state.get("kind") == "personal":
		return PERSONAL.resolve(choice)
	var event := pending_event()
	if event.is_empty():
		return {"flavor": "This chapter has already passed."}
	var allowed: Array = event["choices"].map(func(option: Dictionary): return option["action"])
	if choice not in allowed:
		event["flavor"] = "Your situation has changed. Choose a path you can manage now.\n\n" + str(event["flavor"])
		return event
	var state := GameState.journey_state
	var migration: bool = state["kind"] == "migration"
	var phase := int(state["phase"])
	var text := ""
	if choice == "leave":
		_finish("Turned away from the migration." if migration else "Left the disputed range behind.", 0.0)
		text = "You turn away and return to the familiar trails. There is no reward or further cost for this journey. Conditions across the wider range still affect you."
	elif phase == 0:
		var costs := {"ridge": 0.08, "river": 0.04, "share": 0.08, "hold": 0.06}
		GameState.hunger -= float(costs[choice])
		state["route"] = choice
		_listen(choice)
		text = "You commit to the %s. The journey continues next season, giving you time to feed and prepare." % {"ridge": "high trail", "river": "river trail", "share": "plan for a shared range", "hold": "patrol of your boundary"}[choice]
	elif phase == 1:
		if choice == "together":
			var helpers := COMPANIONS.take_support("on the migration trail" if migration else "at the disputed boundary")
			GameState.hunger -= 0.03
			text = "With %s beside you, you %s. Their help costs 3%% food and uses their support for this season." % [LIFE_STORY.names_text(helpers), "find firm ground" if migration else "keep the range " + ("shared" if state["route"] == "share" else "defended")]
		elif choice == "careful":
			GameState.hunger -= 0.08 if migration else 0.06
			if not migration:
				state["route"] = "share"
			text = "You use some of your reserves to %s. The journey will reach its end next season." % ("find a safer crossing" if migration else "make room for the other pack")
		else:
			GameState.health -= _crossing_cost()
			if not migration:
				state["route"] = "hold"
			text = "You move on, carrying a wound from %s. The journey will reach its end next season." % ("the crossing" if migration else "holding the line")
		LIFE_STORY.remember("journey_crossing_" + state["kind"], text, 7)
	else:
		if migration:
			GameState.hunger = minf(1.0, GameState.hunger + (0.35 if choice == "rich" else 0.20))
			if choice == "rich":
				GameState.health -= 0.07
			_finish(("Reached the upland forest by the %s trail." if GameState.species_id == "argentinosaurus" else "Reached the greener valley by the %s trail.") % state["route"], 0.04)
		else:
			var shared: bool = state["route"] == "share"
			GameState.hunger = minf(1.0, GameState.hunger + (0.15 if shared else 0.20))
			if not shared:
				GameState.health -= 0.05
			var outcome := "Made a lasting truce on the shared range." if shared else "Held the range against the rival pack."
			if GameState.species_id == "velociraptor":
				outcome = "Established shared hunting lanes at the reed beds." if shared else "Kept the reed-bed hunting lanes for your pack."
			_finish(outcome, 0.03 if shared else 0.05)
		text = str(state["outcome"]) + " Feeding becomes easier for this season and the next two. " + ("Your territory claims also benefit." if not migration else "Your route has become a place to recover.")
	if phase < 2 and choice != "leave":
		state["phase"] = phase + 1
		state["due"] = GameState.seasons_elapsed + 1
		state["pending"] = false
	GameState.save_run()
	TurnManager.stat_changed.emit()
	return {"flavor": text}


static func _finish(outcome: String, reward: float) -> void:
	GameState.journey_state.merge({"phase": 3, "pending": false, "outcome": outcome, "reward": reward,
		"reward_until": GameState.seasons_elapsed + 3 if reward > 0.0 else -1}, true)
	LIFE_STORY.remember("journey_finished_" + str(GameState.journey_state["kind"]), outcome, 10 if reward > 0.0 else 6)


static func summary() -> String:
	var state := GameState.journey_state
	if state.is_empty():
		return ""
	if state.get("phase", 3) == 3:
		var remaining := int(state.get("reward_until", -1)) - GameState.seasons_elapsed
		return str(state.get("outcome", "")) + (" Bonus: %d season%s remaining." % [remaining, "" if remaining == 1 else "s"] if remaining > 0 else "")
	var title: String = PERSONAL.STORIES[GameState.species_id]["title"] if state["kind"] == "personal" else preload("res://scripts/systems/journey_stories.gd").title(TITLES[state["kind"]])
	return "%s · chapter %d of 3. %s" % [title, int(state["phase"]) + 1,
		"A choice is waiting." if state.get("pending", false) else "Continue next season, after family events."]
