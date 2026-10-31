extends Node

const SAVE_PATH := "user://story_save.json"

# ── Identity ──────────────────────────────────────────────────────────────────
var player_name: String = ""
var current_scene_id: String = "s_start"

# ── Relationship levels (0=LOW  1=NORMAL  2=HIGH) ─────────────────────────────
var mother_trust: int  = 1
var flint_trust: int   = 1
var moss_trust: int    = 1
var scarjaw_trust: int = 0
var family_unity: int  = 1

# ── Story flags ───────────────────────────────────────────────────────────────
var flood_warning: bool         = false
var reinforced_nest: bool       = false
var early_evacuation: bool      = false
var alternate_route: bool       = false
var mother_freed_in_flood: bool = false
var loose_shale_used: bool      = false
var unstable_ridge_known: bool  = false
var weak_shelf_known: bool      = false
var shelf_prepared: bool        = false
var scarjaw_friendly: bool      = false
var moss_alive: bool            = true
var flint_alive: bool           = true
var scarjaw_alive: bool         = true

# ── Recognition clues (unlocked in the Last Quiet Night) ─────────────────────
var knows_mother_call: bool  = false
var knows_flint_signal: bool = false
var knows_moss_feather: bool = false

# ── Flood result ──────────────────────────────────────────────────────────────
var flood_companion: String = ""   # "mother" | "flint" | "moss" | "alone"
var flood_first_rescue: String = ""

# ── Character conditions (used in Act 3 resolution) ──────────────────────────
# 0=SAFE/HEALTHY  1=WINDED  2=INJURED  3=DOOMED  4=DEAD
var mother_condition: int  = 0
var scarjaw_condition: int = 0
var flint_condition: int   = 0
var moss_condition: int    = 0
var player_condition: int  = 0

var mother_interventions: int  = 0
var scarjaw_interventions: int = 0
var flint_interventions: int   = 0
var moss_interventions: int    = 0
var player_interventions: int  = 0

# ── Ravine / ascent flags ────────────────────────────────────────────────────
var flint_stranded: bool  = false
var moss_stranded: bool   = false
var player_fell: bool     = false
var chose_escape_route: bool = false

# ── Fight doom flags (set during Act 3 confrontation) ───────────────────────
var flint_doomed:  bool = false
var moss_doomed:   bool = false
var scarjaw_doomed: bool = false
var mother_doomed: bool = false
var player_doomed: bool = false

# ── Rewind / fossil system ────────────────────────────────────────────────────
var free_rewinds_remaining: int = 1
var act_checkpoint: String = ""
var act_checkpoint_state: Dictionary = {}


func _ready() -> void:
	if has_save():
		load_save()


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_WM_CLOSE_REQUEST:
		if not current_scene_id.is_empty() and current_scene_id != "s_start":
			save()


func reset() -> void:
	player_name              = ""
	current_scene_id         = "s_start"
	mother_trust             = 1
	flint_trust              = 1
	moss_trust               = 1
	scarjaw_trust            = 0
	family_unity             = 1
	flood_warning            = false
	reinforced_nest          = false
	early_evacuation         = false
	alternate_route          = false
	mother_freed_in_flood    = false
	loose_shale_used         = false
	unstable_ridge_known     = false
	weak_shelf_known         = false
	shelf_prepared           = false
	scarjaw_friendly         = false
	moss_alive               = true
	flint_alive              = true
	scarjaw_alive            = true
	knows_mother_call        = false
	knows_flint_signal       = false
	knows_moss_feather       = false
	flood_companion          = ""
	flood_first_rescue       = ""
	mother_condition         = 0
	scarjaw_condition        = 0
	flint_condition          = 0
	moss_condition           = 0
	player_condition         = 0
	mother_interventions     = 0
	scarjaw_interventions    = 0
	flint_interventions      = 0
	moss_interventions       = 0
	player_interventions     = 0
	flint_stranded           = false
	moss_stranded            = false
	player_fell              = false
	chose_escape_route       = false
	flint_doomed             = false
	moss_doomed              = false
	scarjaw_doomed           = false
	mother_doomed            = false
	player_doomed            = false
	free_rewinds_remaining   = 1
	act_checkpoint           = ""
	act_checkpoint_state     = {}


func apply_effects(effects: Dictionary) -> void:
	for key in effects:
		var val = effects[key]
		match key:
			"mother_trust":  mother_trust  = clampi(mother_trust  + (val as int), 0, 2)
			"flint_trust":   flint_trust   = clampi(flint_trust   + (val as int), 0, 2)
			"moss_trust":    moss_trust    = clampi(moss_trust    + (val as int), 0, 2)
			"scarjaw_trust": scarjaw_trust = clampi(scarjaw_trust + (val as int), 0, 2)
			"family_unity":  family_unity  = clampi(family_unity  + (val as int), 0, 2)
			"flood_warning":           flood_warning           = val as bool
			"reinforced_nest":         reinforced_nest         = val as bool
			"early_evacuation":        early_evacuation        = val as bool
			"alternate_route":         alternate_route         = val as bool
			"mother_freed_in_flood":   mother_freed_in_flood   = val as bool
			"loose_shale_used":        loose_shale_used        = val as bool
			"unstable_ridge_known":    unstable_ridge_known    = val as bool
			"weak_shelf_known":        weak_shelf_known        = val as bool
			"shelf_prepared":          shelf_prepared          = val as bool
			"scarjaw_friendly":        scarjaw_friendly        = val as bool
			"moss_alive":              moss_alive              = val as bool
			"flint_alive":             flint_alive             = val as bool
			"scarjaw_alive":           scarjaw_alive           = val as bool
			"knows_mother_call":       knows_mother_call       = val as bool
			"knows_flint_signal":      knows_flint_signal      = val as bool
			"knows_moss_feather":      knows_moss_feather      = val as bool
			"flood_companion":         flood_companion         = val as String
			"flood_first_rescue":      flood_first_rescue      = val as String
			"mother_condition":        mother_condition        = val as int
			"scarjaw_condition":       scarjaw_condition       = val as int
			"flint_condition":         flint_condition         = val as int
			"moss_condition":          moss_condition          = val as int
			"player_condition":        player_condition        = val as int
			"flint_stranded":          flint_stranded          = val as bool
			"moss_stranded":           moss_stranded           = val as bool
			"player_fell":             player_fell             = val as bool
			"chose_escape_route":      chose_escape_route      = val as bool
			"flint_doomed":            flint_doomed            = val as bool
			"moss_doomed":             moss_doomed             = val as bool
			"scarjaw_doomed":          scarjaw_doomed          = val as bool
			"mother_doomed":           mother_doomed           = val as bool
			"player_doomed":           player_doomed           = val as bool
			"mother_interventions_inc": mother_interventions   = clampi(mother_interventions  + (val as int), 0, 5)
			"scarjaw_interventions_inc": scarjaw_interventions = clampi(scarjaw_interventions + (val as int), 0, 5)
			"flint_interventions_inc": flint_interventions     = clampi(flint_interventions   + (val as int), 0, 5)
			"moss_interventions_inc":  moss_interventions      = clampi(moss_interventions    + (val as int), 0, 5)
			"player_interventions_inc": player_interventions   = clampi(player_interventions  + (val as int), 0, 5)


func check_requires(requires: Dictionary) -> bool:
	for key in requires:
		var expected = requires[key]
		if key.ends_with("_min"):
			var prop_key: String = key.left(key.length() - 4)
			var actual = get(prop_key)
			if actual == null or (actual as int) < (expected as int):
				return false
		elif key.ends_with("_max"):
			var prop_key: String = key.left(key.length() - 4)
			var actual = get(prop_key)
			if actual == null or (actual as int) > (expected as int):
				return false
		else:
			var actual = get(key)
			if actual == null:
				return false
			if actual != expected:
				return false
	return true


func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)


func save() -> void:
	var data := {}
	for prop in get_property_list():
		if prop["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE:
			data[prop["name"]] = get(prop["name"])
	var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(data))


func load_save() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not f:
		return false
	var parsed = JSON.parse_string(f.get_as_text())
	if not parsed is Dictionary:
		return false
	# Older saves keep defaults for absent fields; JSON numbers need explicit
	# coercion before assigning typed script properties through set().
	reset()
	restore(parsed)
	return true


func restore(data: Dictionary) -> void:
	for prop in get_property_list():
		if not prop["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE:
			continue
		var key: String = prop["name"]
		if not data.has(key):
			continue
		var value = data[key]
		match prop["type"]:
			TYPE_INT:
				if value is int or value is float:
					set(key, int(value))
			TYPE_BOOL:
				if value is bool:
					set(key, bool(value))
			TYPE_STRING:
				if value is String:
					set(key, value)
			TYPE_DICTIONARY:
				if value is Dictionary:
					set(key, value)


func delete_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
