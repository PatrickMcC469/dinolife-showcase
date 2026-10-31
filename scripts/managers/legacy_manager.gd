extends Node

const SAVE_PATH         = "user://legacy.json"
const SPECIES_SAVE_PATH = "user://legacy_species.json"
const HISTORY_SAVE_PATH = "user://legacy_history.json"
const FAMILY_SAVE_PATH = "user://family_lesson.json"
var _family_lesson: Dictionary = {}

var _best:          Dictionary = {}
# Per-species personal bests — tracks progress toward unlocks across all runs.
# Format: { "compsognathus": { "fights_won": 7, "fights_fled": 3, "max_stage_reached": 3 }, ... }
var _species_bests: Dictionary = {}
# Full run history — every completed run appended in order (oldest first).
var _run_history:   Array      = []


func _ready() -> void:
	_load()
	if FileAccess.file_exists(FAMILY_SAVE_PATH):
		var data = JSON.parse_string(FileAccess.get_file_as_string(FAMILY_SAVE_PATH))
		if data is Dictionary and data.get("species_id") in UnlockManager.PLAYABLE_SPECIES and data.get("name") is String and data.get("skill") in preload("res://scripts/systems/family_legacy.gd").SKILLS:
			_family_lesson = {"species_id": data["species_id"], "name": data["name"], "skill": data["skill"]}


func select_family_lesson(record: Dictionary, child: Dictionary, skill: String) -> bool:
	if record.get("species_id") not in UnlockManager.PLAYABLE_SPECIES or skill not in preload("res://scripts/systems/family_legacy.gd").SKILLS or child.get("bond") not in ["strong", "steady"] or int(child.get("skills", {}).get(skill, 0)) != 2: return false
	var previous := _family_lesson
	_family_lesson = {"species_id": record["species_id"], "name": child["name"], "skill": skill}
	if _save_family_lesson(): return true
	_family_lesson = previous
	return false


func take_family_lesson(species: String) -> Dictionary:
	if _family_lesson.get("species_id", "") != species: return {}
	var lesson := _family_lesson.duplicate()
	_family_lesson = {}
	if _save_family_lesson(): return lesson
	_family_lesson = lesson
	return {}


func _save_family_lesson() -> bool:
	var file := FileAccess.open(FAMILY_SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Could not save the chosen family lesson.")
		return false
	file.store_string(JSON.stringify(_family_lesson))
	return file.get_error() == OK


# ── SCORE ─────────────────────────────────────────────────────────────────────

func calculate_score(record: Dictionary) -> int:
	var s := 0
	s += record.get("seasons", 0)         * 8
	s += record.get("kills", 0)           * 12
	s += record.get("life_stage", 0)      * 30
	s += record.get("kin_created", 0)     * 15
	s += record.get("night_hunts", 0)     * 8
	s += record.get("bonuses", []).size() * 20
	s += int(record.get("miles_traveled", 0.0) * 0.05)
	if record.get("death_cause", "") == "natural":
		s += 100
	return s


# ── SAVE / LOAD ───────────────────────────────────────────────────────────────

func check_and_save(record: Dictionary) -> bool:
	_update_species_best(record)
	var entry := record.duplicate(true)
	entry["score"] = calculate_score(record)
	_run_history.append(entry)
	_save_history()
	var score: int = entry["score"] as int
	var prev: int  = _best.get("score", -1) as int
	if score > prev:
		_best = entry.duplicate(true)
		_save()
		return true
	return false


func get_best() -> Dictionary:
	return _best


func has_best() -> bool:
	return not _best.is_empty()


func get_run_history() -> Array:
	return _run_history


func delete_run(index: int) -> void:
	if index >= 0 and index < _run_history.size():
		_run_history.remove_at(index)
		_save_history()


# Returns the best stats recorded for a given species across all runs.
# Used by the character select unlock tooltip to show progress.
func get_best_for_species(species_id: String) -> Dictionary:
	return _species_bests.get(species_id, {}) as Dictionary


func _update_species_best(record: Dictionary) -> void:
	var sid: String = record.get("species_id", "") as String
	if sid.is_empty():
		return
	var prev: Dictionary = _species_bests.get(sid, {}) as Dictionary
	_species_bests[sid] = {
		"fights_won":        maxi(record.get("fights_won",        0) as int, prev.get("fights_won",        0) as int),
		"fights_fled":       maxi(record.get("fights_fled",       0) as int, prev.get("fights_fled",       0) as int),
		"max_stage_reached": maxi(record.get("max_stage_reached", 0) as int, prev.get("max_stage_reached", 0) as int),
		"seasons":           maxi(record.get("seasons",           0) as int, prev.get("seasons",           0) as int),
		"kills":             maxi(record.get("kills",             0) as int, prev.get("kills",             0) as int),
		"display_name":      record.get("display_name", sid) as String,
		"route_bests":       _update_route_bests(record, prev),
	}
	_save_species_bests()


func _update_route_bests(record: Dictionary, previous: Dictionary) -> Array:
	var sid: String = record.get("species_id", "")
	var bests: Array = previous.get("route_bests", []).duplicate(true) if previous.get("route_bests", []) is Array else []
	for target in UnlockManager.UNLOCK_CONDITIONS:
		if UnlockManager.UNLOCK_CONDITIONS[target]["from"] != sid:
			continue
		while bests.size() < 2:
			bests.append({})
		var compact := UnlockManager.compact_record(record)
		var routes: Array = UnlockManager.get_progress_for(target, compact, true)["routes"]
		for index in 2:
			var old_record: Dictionary = bests[index] if bests[index] is Dictionary else {}
			var old_routes: Array = UnlockManager.get_progress_for(target, old_record, true)["routes"]
			if routes[index]["ratio"] > old_routes[index]["ratio"] or old_record.is_empty():
				bests[index] = compact.duplicate(true)
	return bests


func _save() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(_best))
	file.close()


func _save_species_bests() -> void:
	var file = FileAccess.open(SPECIES_SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(_species_bests))
	file.close()


func _save_history() -> void:
	var file = FileAccess.open(HISTORY_SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(_run_history))
	file.close()


func _load() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		if data is Dictionary:
			_best = data
	if FileAccess.file_exists(SPECIES_SAVE_PATH):
		var file = FileAccess.open(SPECIES_SAVE_PATH, FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		if data is Dictionary:
			_species_bests = data
	if FileAccess.file_exists(HISTORY_SAVE_PATH):
		var file = FileAccess.open(HISTORY_SAVE_PATH, FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		if data is Array:
			_run_history = data
	# Recover honest single-life progress from older history once, without
	# combining achievements or Elder status from different lives.
	var missing: Array = _species_bests.keys().filter(func(sid): return not _species_bests[sid].has("route_bests"))
	var changed := false
	for record in _run_history:
		if not record is Dictionary or not record.get("species_id") is String:
			continue
		var sid: String = record["species_id"]
		if sid.is_empty():
			continue
		UnlockManager.check_and_unlock(record)
		if sid not in _species_bests:
			_species_bests[sid] = {}
			missing.append(sid)
		if sid not in missing:
			continue
		_species_bests[sid]["route_bests"] = _update_route_bests(record, _species_bests[sid])
		changed = true
	if changed:
		_save_species_bests()
