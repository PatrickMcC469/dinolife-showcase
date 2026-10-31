extends RefCounted

const COMPANIONS = preload("res://scripts/systems/companions.gd")
const MEMORIES = preload("res://scripts/systems/life_story.gd")
const KINDS = ["route", "rest", "newcomer"]


static func restore(value: Variant) -> Dictionary:
	if not value is Dictionary or value.get("kind") not in KINDS:
		return {}
	var season = value.get("season", -1)
	if not (season is int or season is float):
		return {}
	for key in ["first", "second", "newcomer"]:
		if not value.get(key, "") is String:
			return {}
	return {"kind": value["kind"], "season": int(season), "first": value.get("first", ""), "second": value.get("second", ""), "newcomer": value.get("newcomer", "")}


static func ready() -> bool:
	return COMPANIONS.supported() and GameState.health > 0.0 and GameState.pack_bond > 0.0 and GameState.is_alpha and GameState.get_action_uses("alpha_duty") == 0 and COMPANIONS.active_cast().size() >= 2


static func _member(name: String) -> Dictionary:
	for member in COMPANIONS.active_cast():
		if member["name"] == name:
			return member
	return {}


static func menu() -> Dictionary:
	if not ready():
		return {"flavor": "Only an alpha with an unused seasonal duty can settle the group's concerns.", "choices": []}
	var state := GameState.council_state
	if int(state.get("season", -1)) != GameState.seasons_elapsed or _member(str(state.get("first", ""))).is_empty() or _member(str(state.get("second", ""))).is_empty() or (state.get("kind") == "newcomer" and COMPANIONS.active_cast().size() >= COMPANIONS.max_companions()):
		var cast := COMPANIONS.active_cast()
		cast.sort_custom(func(a: Dictionary, b: Dictionary): return a.get("trait", "") == "cautious" and b.get("trait", "") != "cautious")
		var kind: String = KINDS[posmod(GameState.seasons_elapsed, KINDS.size())]
		if kind == "newcomer" and cast.size() >= COMPANIONS.max_companions():
			kind = "rest"
		GameState.council_state = {"kind": kind, "season": GameState.seasons_elapsed, "first": cast[0]["name"], "second": cast[cast.size() - 1]["name"], "newcomer": ""}
		state = GameState.council_state
		if kind == "newcomer":
			state["newcomer"] = MEMORIES._new_name()
		GameState.save_run()
	var first: String = state["first"]
	var second: String = state["second"]
	var text := ""
	var choices: Array = []
	match state["kind"]:
		"route":
			text = "%s pauses at the covered trail. %s answers from the open bank, where food is easier to reach. The %s waits for your signal. Keeping everyone safe and feeding everyone well ask for different paths today." % [first, second, COMPANIONS.group_name()]
			choices = [
				{"action": "council_first", "label": "Take the covered trail", "icon": "shield", "sublabel": "No cost · +4%% defense\nFavor %s; disappoint %s" % [first, second]},
				{"action": "council_second", "label": "Lead across the open bank", "icon": "graze", "sublabel": "+8%% food · −3%% health\nFavor %s; worry %s" % [second, first]},
				{"action": "council_balance", "label": "Check the bank together first", "icon": "bond", "sublabel": "6% food · both gain a little trust"}]
		"rest":
			text = "%s lags behind, stopping before each rise. %s keeps calling the group toward food. You can let the tired member rest, push the pace, or take the longer work on yourself." % [first, second]
			choices = [
				{"action": "council_first", "label": "Let %s rest" % first, "icon": "rest", "sublabel": "4%% food · rests this season\nFavor %s; disappoint %s" % [first, second]},
				{"action": "council_second", "label": "Keep the feeding pace", "icon": "hunt", "sublabel": "+6%% food · %s rests 2 seasons\nFavor %s; strain %s" % [first, second, first]},
				{"action": "council_balance", "label": "Take the extra work yourself", "icon": "shield", "sublabel": "−4% health · both gain trust"}]
		"newcomer":
			text = "%s waits outside the group's resting place. %s moves aside to leave a gap; %s stays close to the food. There is room for another companion, but welcoming one asks you to share your reserves." % [state["newcomer"], first, second]
			choices = [
				{"action": "council_first", "label": "Welcome " + state["newcomer"], "icon": "bond", "sublabel": "6%% food · new companion\nFavor %s; worry %s" % [first, second]},
				{"action": "council_second", "label": "Keep food for your group", "icon": "stalk", "sublabel": "No cost · newcomer leaves\nFavor %s; disappoint %s" % [second, first]},
				{"action": "council_balance", "label": "Spare food, then part ways", "icon": "graze", "sublabel": "4% food · newcomer leaves\nBoth gain a little trust"}]
	choices = choices.filter(func(option): return not (option["action"] == "council_balance" and state["kind"] == "rest" and GameState.health <= 0.04) and not (option["action"] == "council_second" and state["kind"] == "route" and GameState.health <= 0.03))
	choices.append({"action": "back", "label": "Decide later", "sublabel": "Keep your seasonal duty"})
	return {"type": "council_herd" if COMPANIONS.group_name() == "herd" else "council_pack", "image_key": GameState.species_id + "_council_" + str(state["kind"]), "title": "Two voices in your " + COMPANIONS.group_name(), "flavor": text + "\n\nThis decision uses your one alpha duty for the season.", "choices": choices, "next_context": "leadership"}


static func resolve(choice: String) -> Dictionary:
	var prior := GameState.council_state
	if int(prior.get("season", -1)) != GameState.seasons_elapsed or _member(str(prior.get("first", ""))).is_empty() or _member(str(prior.get("second", ""))).is_empty() or (prior.get("kind") == "newcomer" and COMPANIONS.active_cast().size() >= COMPANIONS.max_companions()):
		return menu()
	var event := menu()
	if not ready() or not event.get("choices", []).any(func(option): return option["action"] == choice):
		return {"flavor": "That concern is no longer yours to settle this season."}
	var state := GameState.council_state
	var balanced := choice == "council_balance"
	var first_choice := choice == "council_first"
	var cost := 0.0
	if state["kind"] == "route" and balanced: cost = 0.06
	if state["kind"] == "rest" and first_choice: cost = 0.04
	if state["kind"] == "newcomer": cost = 0.04 if balanced else (0.06 if first_choice else 0.0)
	if GameState.hunger < cost:
		event["flavor"] = "Your reserves are too low for that choice.\n\n" + event["flavor"]
		return event
	GameState.hunger -= cost
	GameState.record_action_use("alpha_duty")
	var first := _member(str(state["first"]))
	var second := _member(str(state["second"]))
	COMPANIONS._change(first, 0.08 if balanced else (0.18 if first_choice else -0.12), "You listened to both sides." if balanced else ("You backed their concern when the group disagreed." if first_choice else "You chose the other member's plan."))
	COMPANIONS._change(second, 0.08 if balanced else (-0.12 if first_choice else 0.18), "You listened to both sides." if balanced else ("You chose the other member's plan." if first_choice else "You backed their concern when the group disagreed."))
	preload("res://scripts/systems/companion_traits.gd").record(first, "council_heard" if balanced else ("council_backed" if first_choice else "council_overruled"))
	preload("res://scripts/systems/companion_traits.gd").record(second, "council_heard" if balanced else ("council_overruled" if first_choice else "council_backed"))
	var text := ""
	match state["kind"]:
		"route":
			if first_choice:
				GameState.apply_temp_buff("defense", 0.04, 1, "Council cover")
			elif not balanced:
				GameState.hunger = minf(1.0, GameState.hunger + 0.08)
				GameState.health -= 0.03
			text = "You scout the bank together, spending reserves to hear both concerns." if balanced else ("You keep to cover. %s settles beside you, while %s watches the feeding ground disappear behind the trees." % [first["name"], second["name"]] if first_choice else "The open bank feeds the group, but its exposed approach leaves you with a scrape. %s follows willingly; %s keeps checking behind." % [second["name"], first["name"]])
		"rest":
			first["rest_until"] = GameState.seasons_elapsed + (1 if first_choice else (0 if balanced else 2))
			if balanced: GameState.health -= 0.04
			elif not first_choice: GameState.hunger = minf(1.0, GameState.hunger + 0.06)
			text = "You carry the longer work yourself. Both members keep their place, but your body pays for the compromise." if balanced else ("%s rests while the others feed. %s keeps moving, frustrated by the slower pace." % [first["name"], second["name"]] if first_choice else "The group reaches food, but %s is too exhausted to help this season or next. The meal has a cost that will last beyond today." % first["name"])
		"newcomer":
			if first_choice:
				COMPANIONS._add_member(str(state["newcomer"]))
			text = "%s leaves with a little food and without a place in your group. Both members saw you make room for care without adding another mouth." % state["newcomer"] if balanced else ("%s joins your %s. %s answers their call; %s stays back, still uncertain about your decision." % [state["newcomer"], COMPANIONS.group_name(), first["name"], second["name"]] if first_choice else "%s moves on. You kept your reserves for the familiar faces, but %s watches the newcomer leave." % [state["newcomer"], first["name"]])
	PackManager.modify_bond(0.02 if balanced else -0.01)
	preload("res://scripts/systems/pack_relationships.gd").council(first, second, balanced)
	COMPANIONS._check_empty_group()
	MEMORIES.remember("council_%d" % GameState.seasons_elapsed, text, 9)
	GameState.save_run()
	return {"type": "result", "flavor": text, "choices": []}
