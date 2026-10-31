extends RefCounted

# Survival memories are saved with the run. Story mode has its own cast and saves.
# Flint and Moss belong to Story Mode; new Survival characters use a separate pool.
const NAMES = ["Fern", "Ember", "Reed", "Pebble", "Bramble", "Ash", "Cinder", "Willow", "Dusk", "Rain", "Thistle", "Brook", "Sedge", "Hollow", "Amber", "Clover", "Drift", "Briar", "Ripple", "Shale", "Bracken", "Talon", "Juniper", "Shade"]
const STAGES = ["Hatchling", "Juvenile", "Sub-adult", "Adult", "Elder"]


static func names_text(names: Array) -> String:
	if names.size() <= 2:
		return " and ".join(names)
	return ", ".join(names.slice(0, -1)) + ", and " + str(names[-1])


static func _new_name() -> String:
	var used: Array = [GameState.mate_name, GameState.offspring_name, GameState.juvenile_name, GameState.rival_name, GameState.companion_event.get("name", "")]
	used.append(GameState.council_state.get("newcomer", ""))
	for child in GameState.offspring_history:
		used.append(child.get("name", ""))
	for member in GameState.companions:
		used.append(member.get("name", ""))
	var start := randi() % NAMES.size()
	for offset in NAMES.size():
		var candidate: String = NAMES[(start + offset) % NAMES.size()]
		if candidate not in used:
			return candidate
	var number := used.size() + 1
	while "%s %d" % [NAMES[start], number] in used:
		number += 1
	return "%s %d" % [NAMES[start], number]


static func remember(key: String, text: String, importance: int = 5) -> void:
	for memory in GameState.life_events:
		if memory.get("key") == key:
			return
	GameState.life_events.append({"key": key, "text": text, "season": GameState.seasons_elapsed, "importance": importance})


static func action_snapshot() -> Dictionary:
	return {"kills": GameState.kills, "wins": GameState.fights_won, "fled": GameState.fights_fled,
		"mate": GameState.has_mate, "alpha": GameState.is_alpha, "miles": GameState.miles_traveled,
		"bonuses": GameState.bonuses_earned.size(), "rival": GameState.rival_encounters,
		"territory": GameState.pending_territory_claim}


static func note_action(before: Dictionary, result: Dictionary) -> void:
	if GameState.has_mate and not before["mate"]:
		if GameState.mate_name.is_empty():
			GameState.mate_name = _new_name()
		remember("mate", "Formed a bond with %s." % GameState.mate_name, 6)
		result["flavor"] = result.get("flavor", "") + "\n\nYour mate this season is %s." % GameState.mate_name
	if GameState.kills > before["kills"]:
		remember("first_hunt", "Brought down the first successful hunt.", 4)
		if GameState.kills >= 10:
			remember("ten_hunts", "Completed ten successful hunts.", 7)
	if GameState.fights_won > before["wins"]:
		remember("first_win", "Won a fight and lived to hold the ground.", 4)
	if GameState.fights_fled > before["fled"]:
		remember("first_escape", "Escaped a dangerous encounter. Survival mattered more than the fight.", 4)
	if GameState.is_alpha and not before["alpha"]:
		remember("alpha", "Rose to lead the group as alpha.", 8)
	if GameState.miles_traveled >= 25.0 and before["miles"] < 25.0:
		remember("journey", "Crossed twenty-five miles of unfamiliar ground.", 6)
	if not GameState.pending_territory_claim.is_empty() and GameState.pending_territory_claim != before["territory"]:
		remember("territory", "Established a claim on the territory.", 6)
	if GameState.rival_encounters > before["rival"]:
		remember("rival", "Encountered the rival known as %s." % GameState.rival_name, 6)
	if GameState.bonuses_earned.size() > before["bonuses"]:
		var bonus: String = str(GameState.bonuses_earned.back())
		remember("bonus_" + bonus, "Earned the adaptation: %s." % bonus, 7)


static func young_name() -> String:
	if GameState.offspring_name.is_empty():
		GameState.offspring_name = _new_name()
		remember("young_" + GameState.offspring_name, "Raised a hatchling called %s." % GameState.offspring_name, 5)
	load("res://scripts/systems/family_legacy.gd").ensure_child(GameState.offspring_name)
	return GameState.offspring_name


static func finish_parenting(child_name: String, bond: String) -> void:
	if child_name.is_empty():
		return
	for child in GameState.offspring_history:
		if child.get("name") == child_name:
			return
	var description := "%s left to find a range of their own." % child_name
	if bond == "strong":
		description = "%s left well prepared, carrying the care you gave them." % child_name
	elif bond == "distant":
		description = "%s left with a bond that never quite held." % child_name
	elif bond == "lost":
		description = "The difficult nesting seasons ended with %s gone." % child_name
	remember("departure_" + child_name, description, 8)
	var child: Dictionary = load("res://scripts/systems/family_legacy.gd").ensure_child(child_name).duplicate(true)
	child.merge({"bond": bond, "return_season": GameState.seasons_elapsed + 2, "reunited": false}, true)
	GameState.offspring_history.append(child)


static func next_reunion() -> Dictionary:
	# A reunion is an occasional consequence of parenting, when food is scarce.
	if GameState.health <= 0.0 or GameState.hunger >= 0.55:
		return {}
	for child in GameState.offspring_history:
		if child.get("reunited", false) or child.get("bond", "") not in ["strong", "distant"]:
			continue
		if GameState.seasons_elapsed < int(child.get("return_season", 0)):
			continue
		child["reunited"] = true
		var child_name: String = child["name"]
		var flavor: String
		if child["bond"] == "strong":
			GameState.hunger = minf(1.0, GameState.hunger + 0.18)
			GameState.health = minf(1.0, GameState.health + 0.04)
			flavor = "%s appears at the edge of your range. Grown now, but the movement is familiar. They recognize you and lead you along a sheltered route to food. The seasons you spent protecting them have come back to you." % child_name
			remember("reunion_" + child_name, "%s returned in a lean season and helped you find food." % child_name, 10)
			if int(child.get("skills", {}).get("forage", 0)) == 2:
				GameState.hunger = minf(1.0, GameState.hunger + 0.02)
				flavor += " They read the feeding signs just as you taught them. Their learned food skill adds up to 2% more food."
		else:
			flavor = "You recognize %s before they recognize you. For a moment they stop at the edge of your range. Then they keep their distance and move on. The bond you left behind was too thin to bring them closer." % child_name
			remember("reunion_" + child_name, "%s crossed your range again, but kept their distance." % child_name, 9)
		return {"type": "family_reunion", "title": "A familiar shape", "flavor": flavor, "choices": []}
	return {}


static func earned_title(record: Dictionary) -> String:
	var bonuses: Array = record.get("bonuses", [])
	var raised := 0
	for child in record.get("offspring_history", []):
		if child.get("bond", "") in ["strong", "steady"]:
			raised += 1
	if raised >= 2 or "Great Mother" in bonuses or "Good Mother" in bonuses or "Good Parent" in bonuses:
		return "Line Keeper"
	if int(record.get("kin_created", 0)) >= 3:
		return "Nest Builder"
	if record.get("death_cause", "") == "natural":
		return "Old Soul"
	if float(record.get("miles_traveled", 0.0)) >= 50.0:
		return "Pathfinder"
	if int(record.get("night_hunts", 0)) >= 5:
		return "Night Hunter"
	if int(record.get("fights_won", 0)) >= 10:
		return "Battle Tested"
	if int(record.get("kills", 0)) >= 10:
		return "Fearsome Hunter"
	if int(record.get("fights_fled", 0)) >= 5:
		return "Quick Thinker"
	if int(record.get("life_stage", record.get("max_stage_reached", 0))) >= 3:
		return "Survivor"
	return "Brief Spark"


static func build_memorial(record: Dictionary) -> Dictionary:
	var memories: Array = record.get("life_events", []).duplicate(true)
	memories.sort_custom(func(a: Dictionary, b: Dictionary):
		if int(a.get("importance", 0)) == int(b.get("importance", 0)):
			return int(a.get("season", 0)) > int(b.get("season", 0))
		return int(a.get("importance", 0)) > int(b.get("importance", 0)))
	memories = memories.slice(0, 3)
	memories.sort_custom(func(a: Dictionary, b: Dictionary): return int(a.get("season", 0)) < int(b.get("season", 0)))
	var moments: Array[String] = []
	for memory in memories:
		moments.append("Season %d — %s" % [int(memory.get("season", 0)) + 1, memory.get("text", "")])
	var stage: int = clampi(int(record.get("life_stage", record.get("max_stage_reached", 0))), 0, 4)
	var fallback: Array[String] = []
	if int(record.get("kin_created", 0)) > 0:
		fallback.append("Had %d offspring." % int(record["kin_created"]))
	if int(record.get("kills", 0)) > 0:
		fallback.append("Completed %d successful hunts." % int(record["kills"]))
	if float(record.get("miles_traveled", 0.0)) > 0.0:
		fallback.append("Travelled %.0f miles across the land." % float(record["miles_traveled"]))
	if int(record.get("fights_won", 0)) > 0:
		fallback.append("Won %d fights." % int(record["fights_won"]))
	fallback.append("Reached the %s stage." % STAGES[stage])
	fallback.append("Lived through %d seasons." % int(record.get("seasons", 0)))
	fallback.append("Began life as a %s." % record.get("display_name", "dinosaur"))
	for text in fallback:
		if moments.size() == 3:
			break
		moments.append(text)
	var cause: String = record.get("death_cause", "")
	var detail: String = record.get("death_detail", "")
	var endings := {"natural": "A complete life. Every season available was used.",
		"combat": "The final fight ended the journey.", "starvation": "The reserves ran out before the season turned.",
		"wounds": "The body carried the cost of too many wounds.", "elder_glory": "An elder's last stand. The land remembers.",
		"elder_event": "The final season asked more than the body could give."}
	var ending: String = endings.get(cause, "The record ends here. What came before it was real.")
	if cause == "combat" and not detail.is_empty():
		ending = "Killed by %s." % detail
	elif cause == "starvation" and not detail.is_empty():
		ending = "Starved — %s." % detail
	return {"title": earned_title(record), "moments": moments, "ending": ending}


static func memorial_for(record: Dictionary) -> Dictionary:
	# Old lineage entries get a summary from their recorded stats, without invented events.
	var saved = record.get("memorial")
	if saved is Dictionary and saved.get("moments") is Array and saved.get("title") is String:
		return saved
	return build_memorial(record)


static func share_text(record: Dictionary) -> String:
	var memorial := memorial_for(record)
	return "DinoLife — The %s\n%s · %d seasons\n\n%s\n\n%s" % [memorial["title"],
		record.get("display_name", "Dinosaur"), int(record.get("seasons", 0)),
		"\n".join(memorial["moments"]), memorial["ending"]]
