extends RefCounted

const PERKS = preload("res://scripts/systems/perks.gd")
const ART = preload("res://scripts/ui/adventure_theme.gd")
const TEXT = Color(0.91, 0.92, 0.84)
const MUTED = Color(0.65, 0.73, 0.65)
const GOLD = Color(0.95, 0.79, 0.42)


static func style(color: Color, border: Color = Color(0.26, 0.35, 0.27)) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = color
	box.border_color = border
	box.set_border_width_all(1)
	box.set_corner_radius_all(14)
	box.content_margin_left = 14
	box.content_margin_right = 14
	box.content_margin_top = 12
	box.content_margin_bottom = 12
	return box


static func label(text: String, size: int = 14, color: Color = TEXT) -> Label:
	var node := Label.new()
	node.text = text
	node.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	node.add_theme_font_size_override("font_size", size)
	node.add_theme_color_override("font_color", color)
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return node


static func card(parent: Control, title: String, status: String, detail: String, progress_value: float = -1.0, icon: String = "") -> void:
	var panel := PanelContainer.new()
	panel.mouse_filter = Control.MOUSE_FILTER_PASS
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", ART.parchment(Color.WHITE, 20))
	parent.add_child(panel)
	var column := VBoxContainer.new()
	column.mouse_filter = Control.MOUSE_FILTER_PASS
	column.add_theme_constant_override("separation", 5)
	panel.add_child(column)
	column.add_child(label(status, 10, Color(0.38, 0.32, 0.14)))
	if icon.is_empty():
		column.add_child(label(title, 18, ART.INK))
	else:
		var row := HBoxContainer.new()
		row.mouse_filter = Control.MOUSE_FILTER_PASS
		row.add_theme_constant_override("separation", 8)
		column.add_child(row)
		var image := TextureRect.new()
		image.texture = load("res://assets/ui/action_icons/" + icon + ".svg")
		image.custom_minimum_size = Vector2(24, 24)
		image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		image.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var well := PanelContainer.new()
		well.mouse_filter = Control.MOUSE_FILTER_PASS
		well.add_theme_stylebox_override("panel", style(Color(0.92, 0.88, 0.71)))
		well.add_child(image)
		row.add_child(well)
		var title_label := label(title, 18, ART.INK)
		title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(title_label)
	column.add_child(label(detail, 13, ART.MUTED_INK))
	if progress_value >= 0.0:
		var bar := ProgressBar.new()
		bar.value = clampf(progress_value * 100.0, 0.0, 100.0)
		bar.show_percentage = false
		bar.custom_minimum_size.y = 6
		column.add_child(bar)


static func create(game: Control) -> Control:
	var backdrop := ColorRect.new()
	backdrop.name = "PerksOverlay"
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backdrop.color = Color(0.035, 0.065, 0.045)
	backdrop.z_index = 150
	game.add_child(backdrop)
	var panel := PanelContainer.new()
	panel.mouse_filter = Control.MOUSE_FILTER_PASS
	panel.name = "Card"
	panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	panel.offset_left = 12
	panel.offset_right = -12
	panel.offset_top = 48
	panel.offset_bottom = -32
	if OS.get_name() == "iOS":
		var safe := DisplayServer.get_display_safe_area()
		var window := DisplayServer.window_get_size()
		var scale := game.size.y / maxf(1.0, window.y)
		panel.offset_top = maxf(48, safe.position.y * scale + 8)
		panel.offset_bottom = -maxf(32, (window.y - safe.end.y) * scale + 8)
	panel.add_theme_stylebox_override("panel", ART.frame())
	backdrop.add_child(panel)
	var column := VBoxContainer.new()
	column.mouse_filter = Control.MOUSE_FILTER_PASS
	column.add_theme_constant_override("separation", 12)
	panel.add_child(column)
	column.add_child(label("Stats & perks", 24))
	var scroll := ScrollContainer.new()
	scroll.name = "Scroll"
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	column.add_child(scroll)
	var list := VBoxContainer.new()
	list.mouse_filter = Control.MOUSE_FILTER_PASS
	list.name = "Cards"
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list.add_theme_constant_override("separation", 10)
	scroll.add_child(list)
	list.add_child(label("CURRENT ABILITIES", 11, GOLD))
	var species := SpeciesDB.get_species(GameState.species_id)
	var descriptions := {
		"strength": "Power behind your attacks.",
		"speed": "Helps you chase prey and escape danger.",
		"defense": "Helps you withstand attacks.",
		"type_stat": "Your species' specialized survival ability.",
	}
	for stat in ["strength", "speed", "defense", "type_stat"]:
		var title: String = str(species.get("type_stat_name", "Technique")).replace("_", " ").capitalize() if stat == "type_stat" else stat.capitalize()
		var value := float(GameState.get(stat))
		card(list, "%s · %.1f%%" % [title, value * 100], "CURRENT VALUE", descriptions[stat], value)
	list.add_child(label("Ability levels include growth, bonuses and injuries.", 13, MUTED))
	list.add_child(label("EARNED PERKS", 11, GOLD))
	list.add_child(label("Perks last for this life.", 13, MUTED))
	var earned_count := 0
	for key in PERKS.CATALOG:
		if key in GameState.earned_perks:
			earned_count += 1
			card(list, PERKS.CATALOG[key]["name"], "EARNED · THIS LIFE", PERKS.effect(key) + "\n" + PERKS.CATALOG[key]["requirement"], -1.0, PERKS.CATALOG[key]["icon"])
	if earned_count == 0:
		list.add_child(label("No perks earned yet.", 13, MUTED))
	var counts := {}
	for name in GameState.bonuses_earned:
		if not name is String or PERKS.CATALOG.values().any(func(data): return data["name"] == name): continue
		counts[name] = int(counts.get(name, 0)) + 1
	if not counts.is_empty():
		list.add_child(label("OTHER EARNED BONUSES", 11, GOLD))
		for name in counts:
			card(list, str(name) + (" ×%d" % counts[name] if counts[name] > 1 else ""), PERKS.legacy_status(name), PERKS.legacy_effect(name))
	list.add_child(label("TEMPORARY EFFECTS", 11, GOLD))
	var feeding_action := "graze" if SpeciesDB.get_species(GameState.species_id).get("tree") == "herbivore" else "hunt"
	var feeding_effect: float = preload("res://scripts/systems/world_conditions.gd").modifier(feeding_action) if GameState.life_stage > 0 else 0.0
	card(list, "Feeding conditions", "THIS SEASON", "Current effect: %+.1f points to feeding chance.\nIncludes your home, weather and active advantages. Your final chance also depends on the action and your dinosaur." % (feeding_effect * 100), -1, "leaf" if feeding_action == "graze" else "hunt")
	var temporary := false
	for boost in GameState.temp_buffs:
		temporary = true
		card(list, str(boost.get("source", "Temporary boost")).replace("_", " ").capitalize(), "%d SEASONS LEFT" % int(boost.get("turns_remaining", 0)), "%+.1f%% %s while active." % [float(boost.get("amount", 0.0)) * 100, str(boost.get("stat", "stat")).capitalize()])
	var journey := GameState.journey_state
	var remaining := int(journey.get("reward_until", -1)) - GameState.seasons_elapsed
	if remaining > 0 and float(journey.get("reward", 0.0)) > 0:
		temporary = true
		card(list, "Journey reward", "%d SEASONS LEFT" % remaining, "+%.1f percentage points to %s success chances." % [float(journey["reward"]) * 100, "range claims" if journey.get("kind") == "territory" else "feeding"])
	if not preload("res://scripts/systems/discoveries.gd").summary().is_empty():
		temporary = true
		card(list, "Discovery advantage", "TEMPORARY", "+2.5 percentage points to feeding success chances.\n" + preload("res://scripts/systems/discoveries.gd").summary())
	if not temporary: list.add_child(label("No temporary boosts are active.", 13, MUTED))
	list.add_child(label("WORK TOWARD", 11, GOLD))
	for key in PERKS.CATALOG:
		if key in GameState.earned_perks or not PERKS.eligible(key): continue
		var data: Dictionary = PERKS.CATALOG[key]
		var current := mini(PERKS.progress(key), int(data["goal"]))
		var status := "%d / %d · NOT YET EARNED" % [current, data["goal"]]
		if key == "long_stride" and current == data["goal"] and GameState.life_stage < 2: status = "%d / %d · REACH SUB-ADULT" % [current, data["goal"]]
		card(list, data["name"], status, data["requirement"] + "\nReward: " + PERKS.effect(key), float(current) / float(data["goal"]), data["icon"])
	var close := Button.new()
	close.name = "Close"
	close.text = "Back to your life"
	close.custom_minimum_size.y = 48
	ART.button(close, true)
	close.pressed.connect(func(): backdrop.queue_free())
	column.add_child(close)
	return backdrop
