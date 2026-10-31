extends Node

const SAVE_PATH = "user://unlocks.json"

var unlocked: Array = []

# ── V1 LINEAR CHAINS ──────────────────────────────────────────────────────────
# One predator line, one herbivore line. Future releases add new chains.
const V1_PRED_CHAIN = ["compsognathus", "deinonychus", "velociraptor", "allosaurus", "trex"]
const V1_HERB_CHAIN = ["lesothosaurus", "iguanodon", "triceratops", "ankylosaurus", "argentinosaurus"]
const PLAYABLE_SPECIES = V1_PRED_CHAIN + V1_HERB_CHAIN

# Unlock conditions for V1 chains.
#   wins_and_elder    — fights_won >= value  AND  reached Elder stage
#   survive_and_elder — (fights_won + fights_fled) >= value  AND  reached Elder stage
const UNLOCK_CONDITIONS = {
	# Predator line
	"deinonychus":     { "type": "wins_and_elder",     "value": 10, "from": "compsognathus" },
	"velociraptor":    { "type": "wins_and_elder",     "value": 15, "from": "deinonychus" },
	"allosaurus":      { "type": "wins_and_elder",     "value": 35, "from": "velociraptor" },
	"trex":            { "type": "wins_and_elder",     "value": 55, "from": "allosaurus" },

	# Herbivore line
	"iguanodon":       { "type": "survive_and_elder",  "value": 12, "from": "lesothosaurus" },
	"triceratops":     { "type": "survive_and_elder",  "value": 25, "from": "iguanodon" },
	"ankylosaurus":    { "type": "survive_and_elder",  "value": 40, "from": "triceratops" },
	"argentinosaurus": { "type": "survive_and_elder",  "value": 60, "from": "ankylosaurus" },
}

# Second paths keep the same predecessor and Elder requirement, earned in one life.
const CARE_PATHS = {
	"deinonychus": {"title": "Range keeper", "needs": {"territories": 1, "protections": 2}},
	"velociraptor": {"title": "Pack guardian", "needs": {"protections": 3, "offspring": 1}},
	"allosaurus": {"title": "Pack guardian", "needs": {"protections": 5, "offspring": 2}},
	"trex": {"title": "Family legacy", "needs": {"offspring": 3}},
	"iguanodon": {"title": "Herd guardian", "needs": {"protections": 2, "offspring": 1}},
	"triceratops": {"title": "Trailblazer", "needs": {"migrations": 1, "offspring": 1}},
	"ankylosaurus": {"title": "Herd guardian", "needs": {"protections": 4, "offspring": 2}},
	"argentinosaurus": {"title": "Family legacy", "needs": {"offspring": 3}},
}
const ACHIEVEMENT_LABELS = {
	"territories": "Completed range stories", "protections": "Companion protections",
	"offspring": "Strong-bond offspring raised", "migrations": "Completed migrations",
}


func _ready() -> void:
	load_unlocks()


func load_unlocks() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		unlocked = SpeciesDB.get_default_unlocked()
		save_unlocks()
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	if data is Array:
		unlocked = data


func save_unlocks() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(unlocked))
	file.close()


func get_unlocked_species() -> Array:
	return unlocked.filter(func(sid): return sid in PLAYABLE_SPECIES)


func get_unlockable_from(species_id: String) -> Array:
	var result := []
	for sid in UNLOCK_CONDITIONS:
		if UNLOCK_CONDITIONS[sid].get("from", "") == species_id and not is_unlocked(sid):
			result.append(sid)
	return result


func get_progress_for(species_id: String, run_record: Dictionary, include_unlocked: bool = false) -> Dictionary:
	if is_unlocked(species_id) and not include_unlocked:
		return { "unlocked": true, "current": 0, "required": 0, "type": "", "elder_reached": false }
	var condition = UNLOCK_CONDITIONS.get(species_id, {})
	if condition.is_empty():
		return {"unlocked": false, "routes": []}
	if run_record.get("species_id", condition["from"]) != condition["from"]:
		run_record = {}
	var required: int = condition.get("value", 0)
	var current := 0
	match condition.get("type", ""):
		"wins_and_elder":    current = _number(run_record.get("fights_won", 0))
		"survive_and_elder": current = _number(run_record.get("fights_fled", 0)) + _number(run_record.get("fights_won", 0))
	var elder_reached: bool = _number(run_record.get("max_stage_reached", 0)) >= 4
	var routes: Array = [_route("Combat" if condition["type"] == "wins_and_elder" else "Survival",
		[{"label": "Fights won" if condition["type"] == "wins_and_elder" else "Encounters survived", "current": current, "required": required}], elder_reached)]
	var path: Dictionary = CARE_PATHS[species_id]
	var achievements := run_achievements(run_record)
	var requirements: Array = []
	for key in path["needs"]:
		requirements.append({"label": ACHIEVEMENT_LABELS[key], "current": achievements[key], "required": path["needs"][key]})
	routes.append(_route(path["title"], requirements, elder_reached))
	return {
		"unlocked":      false,
		"current":       current,
		"required":      required,
		"type":          condition.get("type", ""),
		"elder_reached": elder_reached,
		"routes": routes,
	}


func get_unlock_hint(species_id: String) -> String:
	var condition = UNLOCK_CONDITIONS.get(species_id, {})
	if condition.is_empty():
		return ""
	var from_name = SpeciesDB.get_species(condition.get("from", "")).get("display_name", condition.get("from", ""))
	var val: int = condition.get("value", 0)
	var first := "Win %d fights" % val if condition["type"] == "wins_and_elder" else "Survive %d encounters" % val
	var second: Array[String] = []
	for key in CARE_PATHS[species_id]["needs"]:
		second.append("%d %s" % [CARE_PATHS[species_id]["needs"][key], ACHIEVEMENT_LABELS[key].to_lower()])
	return "%s OR %s. Reach Elder as %s in the same life." % [first, ", ".join(second), from_name]


func is_unlocked(species_id: String) -> bool:
	return species_id in PLAYABLE_SPECIES and species_id in unlocked


func force_unlock(species_id: String) -> void:
	if species_id not in PLAYABLE_SPECIES:
		return
	if species_id not in unlocked:
		unlocked.append(species_id)
		save_unlocks()


func check_and_unlock(run_record: Dictionary) -> Array:
	var newly_unlocked = []
	for species_id in UNLOCK_CONDITIONS:
		if is_unlocked(species_id):
			continue
		var condition = UNLOCK_CONDITIONS[species_id]
		if condition.get("from", "") != run_record.get("species_id", ""):
			continue
		var progress := get_progress_for(species_id, run_record)
		if progress["routes"].any(func(route: Dictionary): return route["complete"]):
			unlocked.append(species_id)
			newly_unlocked.append(species_id)
	if newly_unlocked.size() > 0:
		save_unlocks()
	return newly_unlocked


func _number(value: Variant) -> int:
	return maxi(0, int(value)) if value is int or value is float else 0


func run_achievements(record: Dictionary) -> Dictionary:
	var result := {"territories": 0, "protections": 0, "offspring": 0, "migrations": 0}
	# Compact per-route personal bests contain already counted achievements.
	if record.get("achievements") is Dictionary:
		for key in result:
			result[key] = _number(record["achievements"].get(key, 0))
		return result
	var children: Array[String] = []
	if record.get("offspring_history") is Array:
		for child in record["offspring_history"]:
			if child is Dictionary and child.get("bond") == "strong" and child.get("name") is String and not child["name"].is_empty() and child["name"] not in children:
				children.append(child["name"])
	result["offspring"] = children.size()
	var protections: Array[String] = []
	if record.get("life_events") is Array:
		for event in record["life_events"]:
			if event is Dictionary and event.get("key") is String:
				var key: String = event["key"]
				if key.begins_with("companion_protected_") and key not in protections:
					protections.append(key)
	result["protections"] = protections.size()
	var journey = record.get("journey", {})
	if journey is Dictionary:
		var phase = journey.get("phase")
		var reward = journey.get("reward")
		if (phase is int or phase is float) and float(phase) == 3.0 and (reward is int or reward is float) and float(reward) > 0.0:
			if journey.get("kind") == "migration": result["migrations"] = 1
			elif journey.get("kind") == "territory": result["territories"] = 1
	return result


func live_record() -> Dictionary:
	return {"species_id": GameState.species_id, "fights_won": GameState.fights_won,
		"fights_fled": GameState.fights_fled, "max_stage_reached": GameState.life_stage,
		"offspring_history": GameState.offspring_history, "life_events": GameState.life_events,
		"journey": GameState.journey_state}


func compact_record(record: Dictionary) -> Dictionary:
	return {"species_id": record.get("species_id", ""), "fights_won": _number(record.get("fights_won")),
		"fights_fled": _number(record.get("fights_fled")), "max_stage_reached": _number(record.get("max_stage_reached")),
		"achievements": run_achievements(record)}


func _route(title: String, requirements: Array, elder: bool) -> Dictionary:
	var rows := requirements.duplicate(true)
	rows.append({"label": "Reach Elder", "current": 1 if elder else 0, "required": 1})
	var fraction := 0.0
	var complete := true
	for row in rows:
		fraction += minf(1.0, float(row["current"]) / float(row["required"]))
		complete = complete and row["current"] >= row["required"]
	return {"title": title, "requirements": rows, "ratio": fraction / rows.size(), "complete": complete}


func get_best_progress(species_id: String) -> Dictionary:
	var from_sid: String = UNLOCK_CONDITIONS[species_id]["from"]
	var best: Dictionary = LegacyManager.get_best_for_species(from_sid)
	var records: Array = best.get("route_bests", []) if best.get("route_bests") is Array else []
	var progress := get_progress_for(species_id, {})
	if progress.get("unlocked", false):
		return progress
	for index in mini(records.size(), progress["routes"].size()):
		if records[index] is Dictionary:
			progress["routes"][index] = get_progress_for(species_id, records[index])["routes"][index]
	return progress


func progress_text(species_id: String, progress: Dictionary) -> String:
	var from_sid: String = UNLOCK_CONDITIONS[species_id]["from"]
	var from_name: String = SpeciesDB.get_species(from_sid).get("display_name", from_sid)
	var lines: Array[String] = ["As %s, complete either path in one life." % from_name]
	for route in progress.get("routes", []):
		lines.append("\n" + str(route["title"]))
		for row in route["requirements"]:
			lines.append("%s: %d / %d%s" % [row["label"], row["current"], row["required"], " ✓" if row["current"] >= row["required"] else ""])
	return "\n".join(lines)
