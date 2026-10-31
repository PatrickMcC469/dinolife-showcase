extends RefCounted

const SAVE_PATH = "user://discoveries.json"
const LIFE_STORY = preload("res://scripts/systems/life_story.gd")
const COMPANIONS = preload("res://scripts/systems/companions.gd")
const ENTRIES = {
	"giant_trail": {"title": "The giants' trail", "species": "argentinosaurus", "finders": ["compsognathus", "lesothosaurus"],
		"story": "An Argentinosaurus herd has trampled a path through the dense plants. The giants are already far ahead. Tender shoots and insects lie exposed in their tracks, though the open trail leaves you little cover.",
		"lesson": "A giant herd opens feeding trails through dense growth."},
	"herd_shelter": {"title": "Room behind the horns", "species": "triceratops", "finders": ["iguanodon", "ankylosaurus", "argentinosaurus"],
		"story": "A Triceratops herd gathers around its young while other browsers feed nearby. From a safe distance, you notice quiet paths behind the line of horns, leading toward fresh growth.",
		"lesson": "A braced Triceratops herd reveals sheltered approaches to feeding grounds."},
	"alarm_calls": {"title": "Warnings in the grass", "species": "lesothosaurus", "finders": ["deinonychus", "velociraptor", "allosaurus", "trex"],
		"story": "A Lesothosaurus lookout calls from the grass, and its group disappears before you approach. You wait and listen. When a larger hunter passes, the calls change, warning you away from the crowded trails.",
		"lesson": "Small-herd warning calls reveal when a feeding trail is crowded."},
}


static func records() -> Dictionary:
	var clean: Dictionary = {}
	if not FileAccess.file_exists(SAVE_PATH):
		return clean
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("Could not read discoveries.")
		return clean
	var value = JSON.parse_string(file.get_as_text())
	if value is Dictionary:
		for id in ENTRIES:
			var item = value.get(id)
			if item is Dictionary and item.get("source") in ENTRIES[id]["finders"]:
				clean[id] = {"source": item["source"]}
	return clean


static func restore(value: Variant) -> Dictionary:
	var state := {"handled": [], "pending": "", "mode": "", "next": 8, "bonus": "", "until": -1}
	if not value is Dictionary:
		return state
	if value.get("handled") is Array:
		for id in value["handled"]:
			if id in ENTRIES and id not in state["handled"]: state["handled"].append(id)
	for key in ["next", "until"]:
		var number = value.get(key)
		if number is int or number is float: state[key] = int(number)
	if value.get("bonus") in ENTRIES: state["bonus"] = value["bonus"]
	if value.get("pending") in ENTRIES and value.get("mode") in ["find", "recall"] and value["pending"] not in state["handled"]:
		state["pending"] = value["pending"]
		state["mode"] = value["mode"]
	return state


static func next_event() -> Dictionary:
	if GameState.life_stage < 2 or GameState.health <= 0.0:
		return {}
	if not GameState.discovery_state.get("pending", "").is_empty():
		return pending_event()
	if GameState.seasons_elapsed < int(GameState.discovery_state.get("next", 8)) or not GameState.companion_event.is_empty():
		return {}
	if COMPANIONS.supported() and GameState.pack_bond > 0.0 and GameState.companion_event_count == 0:
		return {}
	var found := records()
	for id in ENTRIES:
		if id in GameState.discovery_state.get("handled", []): continue
		var mode := ""
		if not found.has(id) and GameState.species_id in ENTRIES[id]["finders"]: mode = "find"
		elif found.has(id) and found[id]["source"] != GameState.species_id: mode = "recall"
		if not mode.is_empty():
			GameState.discovery_state["pending"] = id
			GameState.discovery_state["mode"] = mode
			GameState.save_run()
			return pending_event()
	return {}


static func pending_event() -> Dictionary:
	var id: String = GameState.discovery_state.get("pending", "")
	var mode: String = GameState.discovery_state.get("mode", "")
	if id not in ENTRIES or mode not in ["find", "recall"] or id in GameState.discovery_state.get("handled", []) or GameState.health <= 0.0:
		return {}
	var data: Dictionary = ENTRIES[id]
	var text: String = data["story"]
	var found := records()
	if mode == "recall":
		if not found.has(id) or found[id]["source"] == GameState.species_id:
			GameState.discovery_state["pending"] = ""
			return {}
		var source: String = SpeciesDB.get_species(found[id]["source"])["display_name"]
		text = "An earlier %s life recorded this discovery.\n\n%s\n\nYou recognize its signs in this life and can use that knowledge on your own feeding trails." % [source, data["lesson"]]
	elif GameState.species_id not in data["finders"]:
		GameState.discovery_state["pending"] = ""
		GameState.discovery_state["mode"] = ""
		return {}
	text += "\n\nSpend 4% food observing carefully. You find up to 12% food and gain a small feeding advantage for this season and the next two. Moving on has no cost."
	var choices: Array = []
	if GameState.hunger >= 0.04:
		choices.append({"action": "observe", "label": "Use the remembered signs" if mode == "recall" else "Watch and learn", "sublabel": "4% food; find food and learn a route", "icon": "stalk"})
	choices.append({"action": "leave", "label": "Move on", "sublabel": "No cost or reward", "icon": "flee"})
	return {"type": "discovery_event", "title": data["title"], "flavor": text, "choices": choices, "resolve_key": "discovery", "next_context": "discovery"}


static func resolve(choice: String) -> Dictionary:
	var event := pending_event()
	if event.is_empty(): return {"flavor": "This discovery has already passed."}
	if not event["choices"].any(func(option: Dictionary): return option["action"] == choice):
		event["flavor"] = "Your reserves changed. Choose what you can manage now.\n\n" + str(event["flavor"])
		return event
	var state := GameState.discovery_state
	var id: String = state["pending"]
	var mode: String = state["mode"]
	var text := "You leave the signs undisturbed. No food is spent and no reward is earned."
	var reveal: Dictionary = {}
	if choice == "observe":
		var found := records()
		if mode == "find" and not found.has(id):
			found[id] = {"source": GameState.species_id}
			var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
			if file == null:
				push_error("Could not save discovery.")
				event["flavor"] = "Your discovery could not be recorded. Try again or move on."
				return event
			file.store_string(JSON.stringify(found))
			file.close()
			reveal = {"title": ENTRIES[id]["title"], "species": ENTRIES[id]["species"]}
		GameState.hunger = minf(1.0, GameState.hunger - 0.04 + 0.12)
		state["bonus"] = id
		state["until"] = GameState.seasons_elapsed + 3
		text = str(ENTRIES[id]["lesson"]) + " You spend time observing, then feed along the new route. Feeding chances improve slightly for this season and the next two."
		LIFE_STORY.remember("discovery_" + id, ("Used an earlier life's discovery: " if mode == "recall" else "Discovered: ") + str(ENTRIES[id]["lesson"]), 8)
	state["handled"].append(id)
	state["pending"] = ""
	state["mode"] = ""
	state["next"] = GameState.seasons_elapsed + 4
	GameState.save_run()
	TurnManager.stat_changed.emit()
	var result := {"flavor": text}
	if not reveal.is_empty(): result["reveal"] = reveal
	return result


static func modifier(action: String) -> float:
	return 0.025 if action in ["hunt", "graze", "scavenge"] and GameState.seasons_elapsed < int(GameState.discovery_state.get("until", -1)) and GameState.discovery_state.get("bonus") in ENTRIES else 0.0


static func summary() -> String:
	if modifier("graze") == 0.0: return ""
	return "%s: feeding advantage for %d more seasons." % [ENTRIES[GameState.discovery_state["bonus"]]["title"], int(GameState.discovery_state["until"]) - GameState.seasons_elapsed]
