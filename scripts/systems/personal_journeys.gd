extends RefCounted

const COMPANIONS = preload("res://scripts/systems/companions.gd")
const MEMORIES = preload("res://scripts/systems/life_story.gd")
const STORIES = {
	"deinonychus": {"title": "The broken hunting trail", "start": "The trail that fed you last year ends in empty brush. Beyond it, fresh tracks cross a stony slope. You can read their turns slowly, or follow the freshest scent before it fades.", "careful": "Read the sheltered trail", "bold": "Follow the fresh scent", "middle": "The tracks divide below a ledge. Small prints turn into cover; heavier prey has crossed the exposed slope.", "end": "Beyond the stones, a hunting lane opens between two thickets. You recognize the turns now. The prey has somewhere to run, and you know where it must slow."},
	"triceratops": {"title": "A place for the circle", "start": "The old resting ground has lost its cover. Beyond the next ridge, trees border a wide stretch of browse. Reaching it slowly keeps the defensive line together; the open approach reaches food sooner.", "careful": "Keep to the wooded edge", "bold": "Cross toward the open browse", "middle": "A narrow gap breaks the trail. There is room to turn through it carefully, or push across the broken bank.", "end": "The trees open around a resting place with clear approaches. Even the smallest members could stand behind the outer line here. Richer browse waits a little farther into the open."},
	"lesothosaurus": {"title": "Calls beyond the grass", "start": "The grass around your feeding ground is taller than you now. Familiar warning calls are difficult to place. A shaded trail bends toward new shoots; a short gap cuts straight through the open.", "careful": "Trace the shaded trail", "bold": "Try the shorter gap", "middle": "Wind flattens the grass ahead. You can wait and read the movement beneath it, or dart through before the cover rises again.", "end": "You reach a patch where low shoots grow beside several escape gaps. The calls carry clearly here. Farther out, the tenderest leaves have no grass to hide behind."},
	"ankylosaurus": {"title": "The stone-bound hollow", "start": "Heavy rain has softened your usual ground. A stony hollow lies beyond the next rise, with firm footing and ferns along its edge. The dry approach winds uphill; the short route crosses soft soil.", "careful": "Climb on firm stones", "bold": "Take the softer shortcut", "middle": "A fallen trunk blocks the hollow's entrance. You can spend time finding firm footing around it, or force through the rough bank.", "end": "The hollow holds your weight. You turn once, learning how much room your tail has between the stones. Ferns grow along the sheltered edge; the richest patch lies on an exposed slope."},
	"allosaurus": {"title": "Tracks beyond the basalt", "start": "Prey trails have shifted beyond the black rocks. You can follow them through the lee of the ridge, or take the direct approach while the scent is fresh. You will have to feed and prepare between stretches.", "careful": "Circle through the lee", "bold": "Follow the direct trail", "middle": "Fresh tracks climb out of a gully. The wind is turning. Waiting for a better approach costs reserves; climbing through now risks a scrape on the sharp stone.", "end": "Beyond the basalt, prey crosses a narrow saddle. You know the sheltered approach now. The open flats hold larger meals, but reaching them will expose you."},
	"trex": {"title": "The quiet river crossing", "start": "A herd has moved across the river, leaving your familiar bank quiet. An upstream trail reaches shallow water, while the direct ford cuts toward the strongest scent. A shorter route could be harder when the water rises.", "careful": "Search upstream for shallows", "bold": "Follow the direct ford", "middle": "The river presses against the crossing. You can test each foothold, or push across the uneven bed before the scent disappears.", "end": "On the far bank, deep tracks turn beneath the trees. You pause where their scent gathers. This stretch could feed you for several seasons; the exposed bank offers a larger meal today."},
}


static func pending_event() -> Dictionary:
	var state := GameState.journey_state
	if not state.get("pending", false) or int(state.get("phase", 3)) >= 3 or GameState.health <= 0.0 or GameState.species_id not in STORIES:
		return {}
	var story: Dictionary = STORIES[GameState.species_id]
	var phase := int(state["phase"])
	var text: String = story[["start", "middle", "end"][phase]]
	var choices: Array = []
	if phase == 0:
		text += "\n\nThe careful approach costs more food now and keeps you away from rough ground later. The shorter approach saves food, but carries a higher crossing risk. This journey continues over three seasons."
		_add(choices, "careful_route", str(story["careful"]), "8% food · later crossing costs 4% health", 0.08)
		_add(choices, "bold_route", str(story["bold"]), "4% food · later crossing costs 7% health; 9% in a flood", 0.04)
	elif phase == 1:
		text += "\n\nYou came by the " + ("careful route, leaving yourself more room to choose your footing." if state["route"] == "careful_route" else "shorter route. Its rough approach has followed you into this season.")
		_add(choices, "patient", "Find a steady way through", "6% food · avoid an injury", 0.06)
		var damage := crossing_cost()
		_add(choices, "press", "Push through the rough ground", "%d%% health · keep your food" % roundi(damage * 100), 0.0, damage)
		if not COMPANIONS.supporters().is_empty():
			_add(choices, "together", "Read the ground with trusted companions", "3% food · uses their support this season", 0.03)
			text += "\n\n%s can help you find the way." % MEMORIES.names_text(COMPANIONS.supporters())
	else:
		text += "\n\nSettle into the sheltered approach for a smaller meal and three seasons of easier feeding, or spend health reaching the richer ground."
		_add(choices, "settle", "Learn the sheltered feeding ground", "+15% food · +3% feeding chance for 3 seasons")
		_add(choices, "reach", "Reach the exposed feeding ground", "−5% health · +25% food · +5% feeding chance for 3 seasons", 0.0, 0.05)
	choices.append({"action": "leave", "label": "Return to familiar ground", "icon": "stalk", "sublabel": "End the journey without another cost"})
	var image_key := GameState.species_id + "_journey_%d" % phase if GameState.species_id in ["trex", "allosaurus", "ankylosaurus"] else "journey_event"
	return {"type": "journey_event", "image_key": image_key, "title": story["title"], "flavor": text, "choices": choices, "resolve_key": "journey", "next_context": "journey"}


static func _add(choices: Array, action: String, label: String, detail: String, food: float = 0.0, health: float = 0.0) -> void:
	if GameState.hunger >= food and GameState.health > health:
		choices.append({"action": action, "label": label, "icon": "stalk", "sublabel": detail})


static func crossing_cost() -> float:
	if GameState.journey_state.get("route") == "careful_route":
		return 0.04
	var flooded: bool = GameState.world_state.get("kind") == "flood" and GameState.seasons_elapsed < int(GameState.world_state.get("until", -1))
	return 0.09 if flooded else 0.07


static func resolve(choice: String) -> Dictionary:
	var event := pending_event()
	if event.is_empty():
		return {"flavor": "That chapter has passed."}
	if not event["choices"].any(func(option): return option["action"] == choice):
		return event
	var state := GameState.journey_state
	var phase := int(state["phase"])
	var text := ""
	if choice == "leave":
		state.merge({"phase": 3, "pending": false, "reward": 0.0, "reward_until": -1, "outcome": "Left %s unfinished." % str(STORIES[GameState.species_id]["title"]).to_lower()}, true)
		text = "You turn back toward ground you know. The route will stay unfinished, but you keep the strength you have left."
	elif phase == 0:
		GameState.hunger -= 0.08 if choice == "careful_route" else 0.04
		state["route"] = choice
		text = "You choose the %s. The next stretch waits until next season; there is time to feed and prepare." % ("careful route through cover" if choice == "careful_route" else "shorter approach")
	elif phase == 1:
		if choice == "patient":
			GameState.hunger -= 0.06
			text = "You spend the time finding steady ground. Your reserves are lighter, but you reach the next resting place without a new wound."
		elif choice == "together":
			GameState.hunger -= 0.03
			var helpers := COMPANIONS.take_support("while finding the new feeding ground")
			text = "%s %s you read the broken ground. You reach the far side together, with one more season before the new range opens." % [MEMORIES.names_text(helpers), "helps" if helpers.size() == 1 else "help"]
		else:
			GameState.health -= crossing_cost()
			text = "You push through the approach you chose. Rough ground leaves a scrape, but you keep your food for the final stretch."
		state["crossing"] = choice
	else:
		var rich := choice == "reach"
		GameState.hunger = minf(1.0, GameState.hunger + (0.25 if rich else 0.15))
		if rich: GameState.health -= 0.05
		text = "The ground you spent three seasons reaching becomes familiar. " + ("You carry a final scrape from the exposed feeding place, but it holds a richer meal." if rich else "You settle along the covered approach, learning where a meal can be found without crossing the open.")
		state.merge({"phase": 3, "pending": false, "reward": 0.05 if rich else 0.03, "reward_until": GameState.seasons_elapsed + 3, "outcome": text}, true)
		MEMORIES.remember("personal_journey_complete", text, 10)
	if phase < 2 and choice != "leave":
		state.merge({"phase": phase + 1, "pending": false, "due": GameState.seasons_elapsed + 1}, true)
	MEMORIES.remember("personal_journey_%d" % phase, text, 7)
	GameState.save_run()
	TurnManager.stat_changed.emit()
	return {"flavor": text}
