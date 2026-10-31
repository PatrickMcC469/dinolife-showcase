extends Control

const STAGE_NAMES   = ["Hatchling", "Juvenile", "Sub-adult", "Adult", "Elder"]
const LIFE_STORY = preload("res://scripts/systems/life_story.gd")

@onready var stats_grid: GridContainer  = $Scroll/VBox/Margin/Content/StatsGrid
@onready var unlock_panel: Panel        = $Scroll/VBox/Margin/Content/UnlockPanel
@onready var unlock_image: TextureRect  = $Scroll/VBox/Margin/Content/UnlockPanel/UnlockVBox/UnlockImage
@onready var unlock_name: Label         = $Scroll/VBox/Margin/Content/UnlockPanel/UnlockVBox/UnlockName
@onready var unlock_flavor: Label       = $Scroll/VBox/Margin/Content/UnlockPanel/UnlockVBox/UnlockFlavor
@onready var play_again: Button         = $Scroll/VBox/Margin/Content/PlayAgainButton
@onready var content: VBoxContainer     = $Scroll/VBox/Margin/Content

var _run_record: Dictionary = {}


func _ready() -> void:
	if OS.get_name() == "iOS":
		var safe := DisplayServer.get_display_safe_area()
		var height := float(DisplayServer.window_get_size().y)
		if height > 0.0:
			var scale := get_viewport_rect().size.y / height
			$Scroll/VBox/Margin.add_theme_constant_override("margin_top", maxi(40, int(safe.position.y * scale) + 8))
			$Scroll/VBox/Margin.add_theme_constant_override("margin_bottom", maxi(40, int((height - safe.end.y) * scale) + 8))
	_apply_styles()
	_build_run_record()
	$Scroll/VBox/Margin/Content/Memorial.show_record(_run_record)
	_populate_stats()
	_build_score_section()
	_check_unlocks()
	_show_progress()
	play_again.pressed.connect(_on_play_again)


func _build_run_record() -> void:
	var species = SpeciesDB.get_species(GameState.species_id)
	_run_record = {
		"species_id":        GameState.species_id,
		"display_name":      species.get("display_name", GameState.species_id),
		"kills":             GameState.kills,
		"fights_won":        GameState.fights_won,
		"fights_lost":       GameState.fights_lost,
		"fights_fled":       GameState.fights_fled,
		"kin_created":       GameState.kin_created,
		"miles_traveled":    GameState.miles_traveled,
		"max_stage_reached": GameState.life_stage,
		"successful_hunts":  GameState.kills,
		"survive_events":    GameState.fights_fled + GameState.fights_won,
		"night_hunts":       GameState.night_hunts,
		"total_injuries":    GameState.total_injuries_sustained,
		"lifespan_reduction":GameState.lifespan_reduction,
		"natural_end":       GameState.death_cause == "natural",
		# Fields used by LegacyManager score
		"seasons":           GameState.seasons_elapsed,
		"life_stage":        GameState.life_stage,
		"death_cause":       GameState.death_cause,
		"bonuses":           GameState.bonuses_earned.duplicate(),
		"earned_perks":      GameState.earned_perks.duplicate(),
		"bonus_stat_grants": GameState.bonus_stat_grants.duplicate(true),
		"death_detail":      GameState.death_detail,
		"mate_name":         GameState.mate_name,
		"offspring_history": GameState.offspring_history.duplicate(true),
		"life_events":       GameState.life_events.duplicate(true),
		"companions":        GameState.companions.duplicate(true),
		"journey":           GameState.journey_state.duplicate(true),
		"family":            GameState.family_state.duplicate(true),
	}
	_run_record["memorial"] = LIFE_STORY.build_memorial(_run_record)


# ── STATS ─────────────────────────────────────────────────────────────────────

func _populate_stats() -> void:
	var stats = [
		["Seasons Survived", str(GameState.seasons_elapsed)],
		["Years Lived",       str(GameState.current_year)],
		["Kills",             str(GameState.kills)],
		["Fights Won",        str(GameState.fights_won)],
		["Fights Lost",       str(GameState.fights_lost)],
		["Times Fled",        str(GameState.fights_fled)],
		["Kin Created",       str(GameState.kin_created)],
		["Miles Traveled",    "%.0f" % GameState.miles_traveled],
	]
	if GameState.night_hunts > 0:
		stats.append(["Night Hunts", str(GameState.night_hunts)])
	if GameState.total_injuries_sustained > 0:
		stats.append(["Injuries Sustained", str(GameState.total_injuries_sustained)])
	if GameState.lifespan_reduction > 0:
		stats.append(["Seasons Lost to Injuries", str(GameState.lifespan_reduction)])
	for stat in stats:
		var key_label = Label.new()
		key_label.text = stat[0]
		key_label.add_theme_font_size_override("font_size", 13)
		key_label.add_theme_color_override("font_color", Color(0.55, 0.50, 0.44))
		var val_label = Label.new()
		val_label.text = stat[1]
		val_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		val_label.add_theme_font_size_override("font_size", 13)
		val_label.add_theme_color_override("font_color", Color(0.92, 0.88, 0.80))
		stats_grid.add_child(key_label)
		stats_grid.add_child(val_label)

	# Bonuses as a labelled list below the grid
	if not GameState.bonuses_earned.is_empty():
		_build_bonuses_section()


func _build_bonuses_section() -> void:
	var wrapper = VBoxContainer.new()
	wrapper.add_theme_constant_override("separation", 6)

	wrapper.add_child(_divider())

	var header = Label.new()
	header.text = "ADAPTATIONS EARNED"
	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	header.add_theme_font_size_override("font_size", 11)
	header.add_theme_color_override("font_color", Color(0.55, 0.50, 0.44))
	wrapper.add_child(header)

	var counts := {}
	for bonus in GameState.bonuses_earned:
		if bonus is String: counts[bonus] = int(counts.get(bonus, 0)) + 1
	for bonus in counts:
		var lbl = Label.new()
		lbl.text = bonus + (" ×%d" % counts[bonus] if counts[bonus] > 1 else "") + "\n" + preload("res://scripts/systems/perks.gd").legacy_effect(bonus)
		lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lbl.add_theme_font_size_override("font_size", 12)
		lbl.add_theme_color_override("font_color", Color(1.0, 0.82, 0.2, 0.90))
		wrapper.add_child(lbl)

	content.add_child(wrapper)
	content.move_child(wrapper, stats_grid.get_index() + 1)


# ── SCORE / LEGACY ───────────────────────────────────────────────────────────

func _build_score_section() -> void:
	var score     := LegacyManager.calculate_score(_run_record)
	var is_new_best := LegacyManager.check_and_save(_run_record)
	var best      := LegacyManager.get_best()

	var wrapper := VBoxContainer.new()
	wrapper.add_theme_constant_override("separation", 8)
	wrapper.add_child(_divider())

	if is_new_best:
		var banner := Label.new()
		banner.text = "NEW BEST RUN"
		banner.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		banner.add_theme_font_size_override("font_size", 11)
		banner.add_theme_color_override("font_color", Color(1.0, 0.82, 0.2))
		wrapper.add_child(banner)

	var score_lbl := Label.new()
	score_lbl.text = "%d pts" % score
	score_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	score_lbl.add_theme_font_size_override("font_size", 32)
	score_lbl.add_theme_color_override("font_color",
		Color(1.0, 0.82, 0.2) if is_new_best else Color(0.92, 0.88, 0.80))
	wrapper.add_child(score_lbl)

	# Show previous best only if this run didn't beat it
	if not is_new_best and LegacyManager.has_best():
		var prev_score: int = best.get("score", 0)
		var prev_name: String  = best.get("display_name", "Unknown")
		var prev_seasons: int  = best.get("seasons", 0)
		var diff := score - prev_score
		var diff_str := ("+" if diff >= 0 else "") + str(diff) + " pts"
		var diff_color := Color(0.45, 0.72, 0.38) if diff >= 0 else Color(0.72, 0.38, 0.32)

		var best_lbl := Label.new()
		best_lbl.text = "Best: %d pts  ·  %s  ·  %d seasons" % [prev_score, prev_name, prev_seasons]
		best_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		best_lbl.add_theme_font_size_override("font_size", 11)
		best_lbl.add_theme_color_override("font_color", Color(0.55, 0.50, 0.44))
		wrapper.add_child(best_lbl)

		var diff_lbl := Label.new()
		diff_lbl.text = diff_str
		diff_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		diff_lbl.add_theme_font_size_override("font_size", 12)
		diff_lbl.add_theme_color_override("font_color", diff_color)
		wrapper.add_child(diff_lbl)

	wrapper.add_child(_divider())
	content.add_child(wrapper)
	content.move_child(wrapper, stats_grid.get_index() + 1)


# ── UNLOCKS ───────────────────────────────────────────────────────────────────

func _check_unlocks() -> void:
	var newly_unlocked: Array = UnlockManager.check_and_unlock(_run_record)
	if newly_unlocked.is_empty():
		return
	_show_unlock(newly_unlocked[0])
	if newly_unlocked.size() > 1:
		var extra_names = newly_unlocked.slice(1).map(
			func(sid): return SpeciesDB.get_species(sid).get("display_name", sid)
		)
		var also_lbl = Label.new()
		also_lbl.text = "Also unlocked: " + ", ".join(extra_names)
		also_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		also_lbl.add_theme_font_size_override("font_size", 12)
		also_lbl.add_theme_color_override("font_color", Color(1.0, 0.82, 0.2, 0.80))
		content.add_child(also_lbl)
		content.move_child(also_lbl, play_again.get_index())


func _show_unlock(species_id: String) -> void:
	SoundManager.play("unlock")
	var species = SpeciesDB.get_species(species_id)
	unlock_name.text = species.get("display_name", species_id)
	unlock_flavor.text = species.get("description", "")
	var img_path = "res://assets/dinos/%s_adult.png" % species_id
	if ResourceLoader.exists(img_path):
		unlock_image.texture = load(img_path)
	_style_unlock_panel()
	unlock_panel.visible = true


# ── UNLOCK PROGRESS ───────────────────────────────────────────────────────────

func _show_progress() -> void:
	var targets = UnlockManager.get_unlockable_from(GameState.species_id)
	if targets.is_empty():
		return
	var panel = _build_progress_panel(targets)
	content.add_child(panel)
	content.move_child(panel, play_again.get_index())


func _build_progress_panel(targets: Array) -> Control:
	var wrapper = VBoxContainer.new()
	wrapper.add_theme_constant_override("separation", 14)

	wrapper.add_child(_divider())

	var header = Label.new()
	header.text = "NEXT UNLOCK"
	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	header.add_theme_font_size_override("font_size", 11)
	header.add_theme_color_override("font_color", Color(0.55, 0.50, 0.44))
	wrapper.add_child(header)

	for species_id in targets:
		var entry = _build_progress_entry(species_id)
		if entry:
			wrapper.add_child(entry)

	return wrapper


func _build_progress_entry(species_id: String) -> Control:
	var progress = UnlockManager.get_progress_for(species_id, _run_record)
	if progress["unlocked"]:
		return null

	var species   = SpeciesDB.get_species(species_id)
	var ratio := maxf(float(progress["routes"][0]["ratio"]), float(progress["routes"][1]["ratio"]))

	var entry = VBoxContainer.new()
	entry.add_theme_constant_override("separation", 6)

	var name_row = HBoxContainer.new()
	var name_lbl = Label.new()
	name_lbl.text = species.get("display_name", species_id)
	name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_lbl.add_theme_font_size_override("font_size", 15)
	name_lbl.add_theme_color_override("font_color", Color(0.92, 0.88, 0.80))
	var tree_lbl = Label.new()
	tree_lbl.text = species.get("tree", "").capitalize()
	tree_lbl.add_theme_font_size_override("font_size", 10)
	tree_lbl.add_theme_color_override("font_color", _tree_color(species.get("tree", "")))
	name_row.add_child(name_lbl)
	name_row.add_child(tree_lbl)
	entry.add_child(name_row)

	var bar = ProgressBar.new()
	bar.custom_minimum_size = Vector2(0, 8)
	bar.max_value = 1.0
	bar.value = ratio
	bar.show_percentage = false
	var bar_bg = StyleBoxFlat.new()
	bar_bg.bg_color = Color(0.22, 0.18, 0.14)
	bar_bg.corner_radius_top_left    = 4
	bar_bg.corner_radius_top_right   = 4
	bar_bg.corner_radius_bottom_left = 4
	bar_bg.corner_radius_bottom_right = 4
	var bar_fill = StyleBoxFlat.new()
	bar_fill.bg_color = Color(0.85, 0.35, 0.25) if ratio < 1.0 else Color(1.0, 0.82, 0.2)
	bar_fill.corner_radius_top_left    = 4
	bar_fill.corner_radius_top_right   = 4
	bar_fill.corner_radius_bottom_left = 4
	bar_fill.corner_radius_bottom_right = 4
	bar.add_theme_stylebox_override("background", bar_bg)
	bar.add_theme_stylebox_override("fill", bar_fill)
	entry.add_child(bar)

	var hint = Label.new()
	hint.text = UnlockManager.progress_text(species_id, progress)
	hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hint.add_theme_font_size_override("font_size", 13)
	hint.add_theme_color_override("font_color", Color(0.75, 0.70, 0.60))
	entry.add_child(hint)

	return entry



func _divider() -> HSeparator:
	var sep = HSeparator.new()
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.30, 0.25, 0.20)
	sep.add_theme_stylebox_override("separator", style)
	return sep


func _tree_color(tree: String) -> Color:
	match tree:
		"predator": return Color(0.75, 0.22, 0.15)
		"herbivore": return Color(0.25, 0.52, 0.22)
		"flyer":     return Color(0.22, 0.40, 0.70)
	return Color(0.5, 0.5, 0.5)


func _on_play_again() -> void:
	if AdManager.show_interstitial():
		AdManager.interstitial_closed.connect(
			func(): get_tree().change_scene_to_file("res://scenes/ui/character_select.tscn"),
			CONNECT_ONE_SHOT
		)
	else:
		get_tree().change_scene_to_file("res://scenes/ui/character_select.tscn")


func _apply_styles() -> void:
	var btn_style = StyleBoxFlat.new()
	btn_style.bg_color = Color(0.85, 0.35, 0.25)
	btn_style.corner_radius_top_left = 12
	btn_style.corner_radius_top_right = 12
	btn_style.corner_radius_bottom_left = 12
	btn_style.corner_radius_bottom_right = 12
	play_again.add_theme_stylebox_override("normal", btn_style)
	play_again.add_theme_color_override("font_color", Color(1, 1, 1))
	play_again.add_theme_font_size_override("font_size", 16)
	var hover = btn_style.duplicate()
	hover.bg_color = Color(0.95, 0.42, 0.30)
	play_again.add_theme_stylebox_override("hover", hover)


func _style_unlock_panel() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.15, 0.12, 0.09)
	style.corner_radius_top_left = 16
	style.corner_radius_top_right = 16
	style.corner_radius_bottom_left = 16
	style.corner_radius_bottom_right = 16
	style.border_color = Color(1.0, 0.82, 0.2, 0.6)
	style.border_width_top = 2
	style.border_width_bottom = 2
	style.border_width_left = 2
	style.border_width_right = 2
	style.content_margin_left   = 16.0
	style.content_margin_right  = 16.0
	style.content_margin_top    = 16.0
	style.content_margin_bottom = 16.0
	unlock_panel.add_theme_stylebox_override("panel", style)
