extends Node

const UI = preload("res://scripts/ui/perks_panel.gd")
const ART = preload("res://scripts/ui/adventure_theme.gd")
const COMPANIONS = preload("res://scripts/systems/companions.gd")
const WEATHER = preload("res://scripts/ui/weather_info.gd")
const ICONS = preload("res://scripts/ui/illustrated_icons.gd")
var game: Control
var title: Label
var caption: Label
var heading: Label
var stat_labels := {}
var surfaces: Array[Control] = []
var portrait_frame: Panel
var backdrop: TextureRect
var weather_button: Button
var nameplate: Panel
var pack_button: Button
var pack_view: Control
var journal_button: Button
var journal_view: Control
var map_view: Control
var relations_view: Control
var family_view: Control
var map_button: Button
var family_button: Button
var shortcut_row: HBoxContainer


func setup(screen: Control) -> void:
	game = screen
	game.get_node("Background").hide()
	game.get_node("DinoPanel2").hide()
	game.get_node("ActionScroll/ActionList").move_child(game.get_node("ActionScroll/ActionList/ActionMargin"), 0)
	game.get_node("ActionScroll").horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	# Keep the everyday survival actions within the first screenful.
	var action_index := 0
	for id in ["hunt", "graze", "rest", "water", "tend", "nest_tend"]:
		for card in game.cards_container.get_children():
			if card.action_id == id:
				game.cards_container.move_child(card, action_index)
				action_index += 1
				break
	var background := ColorRect.new()
	background.color = Color(0.045, 0.085, 0.063)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.z_index = -3
	game.add_child(background)
	backdrop = TextureRect.new()
	backdrop.texture = preload("res://assets/ui/character_select_bg.png")
	backdrop.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	backdrop.modulate = Color(0.28, 0.31, 0.23)
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backdrop.z_index = -3
	game.add_child(backdrop)
	for color in [Color(0.10, 0.17, 0.12), Color(0.075, 0.13, 0.09)]:
		var panel := Panel.new()
		panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		panel.z_index = -2
		panel.add_theme_stylebox_override("panel", UI.style(color))
		game.add_child(panel)
		surfaces.append(panel)
	surfaces[1].hide()
	portrait_frame = Panel.new()
	portrait_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	portrait_frame.z_index = 2
	portrait_frame.add_theme_stylebox_override("panel", ART.frame())
	game.add_child(portrait_frame)
	nameplate = Panel.new()
	nameplate.name = "DinosaurNameplate"
	nameplate.mouse_filter = Control.MOUSE_FILTER_IGNORE
	nameplate.add_theme_stylebox_override("panel", ART.parchment())
	game.add_child(nameplate)
	title = UI.label("", 22, ART.INK)
	title.name = "DinosaurTitle"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	game.add_child(title)
	caption = UI.label("", 11, ART.MUTED_INK)
	caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	game.add_child(caption)
	heading = UI.label("THIS SEASON · CHOOSE AN ACTION", 11, UI.GOLD)
	game.add_child(heading)
	for label_node in [game.season_label, game.year_label, game.stage_label]: label_node.hide()
	weather_button = Button.new()
	weather_button.name = "WeatherButton"
	weather_button.expand_icon = true
	weather_button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	weather_button.add_theme_constant_override("icon_max_width", 26)
	weather_button.z_index = 3
	weather_button.pressed.connect(_show_weather)
	game.add_child(weather_button)
	journal_view = preload("res://scenes/ui/living_journal.tscn").instantiate()
	game.add_child(journal_view)
	journal_button = Button.new()
	journal_button.name = "JournalButton"
	journal_button.icon = preload("res://assets/ui/action_icons/journal.svg")
	journal_button.expand_icon = true
	journal_button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	journal_button.add_theme_constant_override("icon_max_width", 26)
	journal_button.accessibility_name = "Open your living journal"
	journal_button.tooltip_text = "Living journal"
	journal_button.z_index = 3
	_style_button(journal_button, false)
	journal_button.pressed.connect(_show_journal)
	journal_view.closed.connect(func(): journal_button.grab_focus())
	game.event_overlay.visibility_changed.connect(func():
		if game.event_overlay.visible: close_views())
	game.add_child(journal_button)
	pack_view = preload("res://scripts/ui/pack_view.gd").create(game, game.companions_panel)
	relations_view = pack_view.get_meta("relationships_view")
	map_view = preload("res://scripts/ui/habitat_map.gd").new()
	map_view.name = "HabitatMap"
	game.add_child(map_view)
	map_view.choice_requested.connect(game._on_map_choice)
	family_view = preload("res://scripts/ui/family_view.gd").new()
	family_view.name = "FamilyView"
	game.add_child(family_view)
	family_view.lesson_requested.connect(game._on_family_lesson)
	pack_button = Button.new()
	pack_button.name = "PackButton"
	pack_button.icon = preload("res://assets/ui/action_icons/group.svg")
	pack_button.expand_icon = true
	pack_button.add_theme_constant_override("icon_max_width", 18)
	pack_button.add_theme_font_size_override("font_size", 12)
	pack_button.z_index = 3
	_style_button(pack_button, false)
	pack_button.pressed.connect(_show_pack)
	game.add_child(pack_button)
	for key in game._stat_bars:
		var holder: Control = game._stat_bars[key].get_parent()
		var card := Panel.new()
		card.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		card.z_index = -1
		card.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.add_theme_stylebox_override("panel", ART.parchment(Color.WHITE, 16, true))
		holder.add_child(card)
		var text := UI.label("", 11, ART.INK)
		text.autowrap_mode = TextServer.AUTOWRAP_OFF
		holder.add_child(text)
		stat_labels[key] = text
		var bar: ProgressBar = game._stat_bars[key]
		bar.custom_minimum_size.y = 8
		for state in ["fill", "background"]:
			var meter_style: StyleBoxFlat = bar.get_theme_stylebox(state)
			meter_style.set_corner_radius_all(4)
		bar.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		bar.offset_left = 18
		bar.offset_top = 32
		bar.offset_right = -18
		bar.offset_bottom = -16
	game.tab_fights.hide()
	game.tab_bonuses.text = "Stats\n& perks"
	game.tab_bonuses.icon = null
	for button in [game.tab_kills, game.tab_bonuses, game.settings_btn]:
		_style_button(button, false)
	game.tab_kills.size_flags_stretch_ratio = 1.4
	game.tab_bonuses.size_flags_stretch_ratio = 0.8
	for button in [game.tab_kills, game.tab_bonuses]:
		for state in ["normal", "hover", "pressed", "disabled", "focus"]:
			var box: StyleBox = button.get_theme_stylebox(state)
			box.content_margin_left = 8
			box.content_margin_right = 8
	shortcut_row = HBoxContainer.new()
	shortcut_row.name = "InformationShortcuts"
	shortcut_row.add_theme_constant_override("separation", 4)
	game.add_child(shortcut_row)
	map_button = Button.new()
	map_button.name = "HabitatButton"
	_style_button(map_button, false)
	map_button.pressed.connect(_show_map)
	family_button = Button.new()
	family_button.name = "FamilyButton"
	_style_button(family_button, false)
	family_button.pressed.connect(_show_family)
	for entry in [[weather_button, "Weather", "weather_rain"], [map_button, "Habitat", "territory"], [pack_button, "Pack", "group"], [family_button, "Family", "nest"], [journal_button, "Journal", "journal"], [game.tab_bonuses, "Stats", "training"]]:
		_shortcut(entry[0], entry[1], entry[2])
	var alpha: PanelContainer = game.get_node("AlphaBadge")
	alpha.get_node("Row/Title").hide()
	alpha.get_node("Row/Crown").texture = ICONS.texture("alpha")
	alpha.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	alpha.accessibility_name = "You are the alpha. Open your leadership choices."
	alpha.tooltip_text = "You are the alpha · tap for leadership"
	game.tab_kills.clip_text = true
	game.tab_kills.add_theme_font_size_override("font_size", 11)
	game.tab_bonuses.add_theme_font_size_override("font_size", 13)
	game.settings_btn.text = ""
	game.settings_btn.icon = ICONS.texture("settings")
	game.settings_btn.expand_icon = true
	game.settings_btn.add_theme_constant_override("icon_max_width", 32)
	game.settings_btn.accessibility_name = "Settings and return to main menu"
	game.settings_btn.add_theme_font_size_override("font_size", 22)
	_style_icon_button(game.settings_btn)
	_style_button(game.next_season_btn, true)
	game.next_season_btn.text = "Next\nseason ›"
	game.next_season_btn.accessibility_name = "Advance to the next season"
	game.next_season_btn.add_theme_font_size_override("font_size", 14)
	game.event_overlay.z_index = 100
	game.dino_image.z_index = 0
	game.get_node("DinoPanel").z_index = 0
	game.get_node("DinoPanel").clip_contents = true
	game.dino_image.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	game.dino_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	game.dino_image.get_node("SeasonAtmosphere").modulate.a = 0.45
	var living_art := preload("res://scenes/ui/living_art.tscn").instantiate()
	living_art.portrait_mode = true
	game.dino_image.add_child(living_art)
	game.get_node("DinoPanel/DinoBackground").hide()
	game.resized.connect(layout)
	refresh()


func _shortcut(button: Button, text: String, icon: String) -> void:
	if button.get_parent(): button.reparent(shortcut_row)
	else: shortcut_row.add_child(button)
	button.icon = null
	button.text = ""
	button.custom_minimum_size = Vector2(44, 58)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.size_flags_stretch_ratio = 1.0
	button.accessibility_name = text + " details"
	button.tooltip_text = text
	_style_icon_button(button)
	var symbol := TextureRect.new()
	symbol.name = "ShortcutIcon"
	symbol.texture = ICONS.texture(icon)
	symbol.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	symbol.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	symbol.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	symbol.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(symbol)
	symbol.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP)
	symbol.offset_left = -18
	symbol.offset_right = 18
	symbol.offset_top = 3
	symbol.offset_bottom = 39
	var label := UI.label(text, 11, UI.TEXT)
	label.name = "ShortcutLabel"
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	button.add_child(label)
	label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	label.anchor_top = 1.0
	label.offset_top = -18
	label.offset_bottom = -3


func _style_button(button: Button, primary: bool) -> void:
	ART.button(button, primary)
	button.focus_mode = Control.FOCUS_ALL


func _style_icon_button(button: Button) -> void:
	for state in ["normal", "hover", "pressed", "disabled", "focus"]:
		button.add_theme_stylebox_override(state, StyleBoxEmpty.new())
	# Highlight the artwork itself for keyboard/controller focus, without adding a box.
	button.focus_entered.connect(func(): button.modulate = Color(1.0, 0.88, 0.60))
	button.focus_exited.connect(func(): button.modulate = Color.WHITE)
	button.button_down.connect(func(): button.modulate = Color(0.76, 0.82, 0.74))
	button.button_up.connect(func(): button.modulate = Color(1.0, 0.88, 0.60) if button.has_focus() else Color.WHITE)
	button.mouse_exited.connect(func(): button.modulate = Color(1.0, 0.88, 0.60) if button.has_focus() else Color.WHITE)


func _show_weather() -> void:
	if blocking_view_open() or game.event_overlay.visible or game._waiting_for_choice or game._age_up_active or is_instance_valid(game._bonuses_overlay): return
	game.event_overlay.show_event({"type": "info", "title": "Weather & seasonal effects", "flavor": WEATHER.detail(), "choices": []})


func _show_pack() -> void:
	if blocking_view_open() or not pack_button.visible or game.event_overlay.visible or game._waiting_for_choice or game._age_up_active or is_instance_valid(game._bonuses_overlay): return
	game.companions_panel.refresh()
	pack_view.get_node("Card/Content/Leadership").text = "Your alpha duties" if GameState.is_alpha else "Meet your alpha"
	game.companions_panel.get_parent().scroll_vertical = 0
	game.move_child(pack_view, -1)
	pack_view.show()
	game.companions_panel.get_parent().get_parent().get_node("Close").grab_focus()


func _show_journal() -> void:
	if blocking_view_open() or game.event_overlay.visible or game._waiting_for_choice or game._age_up_active or is_instance_valid(game._bonuses_overlay): return
	journal_view.open()


func _show_map() -> void:
	if blocking_view_open() or game.event_overlay.visible or game._waiting_for_choice or game._age_up_active or is_instance_valid(game._bonuses_overlay): return
	map_view.open()


func blocking_view_open() -> bool:
	for view in [pack_view, journal_view, map_view, relations_view, family_view]:
		if is_instance_valid(view) and view.visible: return true
	return false


func close_views() -> void:
	for view in [pack_view, journal_view, map_view, relations_view, family_view]:
		if is_instance_valid(view): view.hide()


func _show_family() -> void:
	if blocking_view_open() or game.event_overlay.visible or game._waiting_for_choice or game._age_up_active or is_instance_valid(game._bonuses_overlay) or not preload("res://scripts/systems/family_legacy.gd").available(): return
	family_view.open()


func _place(control: Control, x: float, y: float, width: float, height: float) -> void:
	control.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	control.position = Vector2(x, y)
	control.size = Vector2(width, height)


func layout() -> void:
	if not is_instance_valid(game) or not is_instance_valid(title): return
	var width := game.size.x
	var height := game.size.y
	var top := 16.0
	var bottom := 12.0
	if OS.get_name() == "iOS":
		var safe := DisplayServer.get_display_safe_area()
		var window := DisplayServer.window_get_size()
		var scale := height / maxf(1, window.y)
		top = maxf(top, safe.position.y * scale + 8)
		bottom = maxf(bottom, (window.y - safe.end.y) * scale + 8)
	var inset := maxf(12, (width - 640) / 2)
	var content_width := width - inset * 2
	var plate_width := content_width - 56
	var short_screen := height < 680
	_place(nameplate, inset, top, plate_width, 60 if short_screen else 72)
	title.add_theme_font_size_override("font_size", 20 if short_screen else 22)
	caption.add_theme_font_size_override("font_size", 10 if short_screen else 11)
	_place(title, inset + 16, top + (5 if short_screen else 13), plate_width - 32, 26 if short_screen else 28)
	_place(caption, inset + 16, top + (32 if short_screen else 43), plate_width - 32, 14 if short_screen else 16)
	_place(game.settings_btn, width - inset - 44, top + 14, 44, 44)
	# Fill a wider portrait while reserving usable actions on short phones.
	var art_height := minf((content_width - 24) / 1.6 + 24, maxf(100, height - top - bottom - 464))
	game.dino_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED if (content_width - 24) / (art_height - 24) <= 1.85 else TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var art_top := top + (64 if short_screen else 76)
	_place(game.get_node("DinoPanel"), inset, art_top, content_width, art_height)
	_place(surfaces[0], inset, art_top, content_width, art_height)
	_place(portrait_frame, inset, art_top, content_width, art_height)
	_place(game.get_node("DinoPanel"), inset + 12, art_top + 12, content_width - 24, art_height - 24)
	_place(game.get_node("AlphaBadge"), inset + 16, top + 12, 28, 28)
	if GameState.is_alpha: _place(title, inset + 40, top + (5 if short_screen else 13), plate_width - 50, 26 if short_screen else 28)
	var stats_top := art_top + art_height + 6
	var social := COMPANIONS.supported()
	game._bond_holder.visible = social
	var keys := ["health", "hunger", "pack_bond"] if social else ["health", "hunger"]
	var stat_width := (content_width - (keys.size() - 1) * 8) / keys.size()
	for i in keys.size():
		var holder: Control = game._stat_bars[keys[i]].get_parent()
		_place(holder, inset + i * (stat_width + 8), stats_top, stat_width, 56)
		_place(stat_labels[keys[i]], 13, 13, stat_width - 26, 16)
	_place(shortcut_row, inset, stats_top + 60, content_width, 58)
	for button in shortcut_row.get_children(): button.get_node("ShortcutLabel").add_theme_font_size_override("font_size", 10 if short_screen else 11)
	var actions_top := stats_top + 136
	_place(heading, inset + 2, actions_top - 18, content_width, 18)
	var footer_height := 54 if short_screen else 58
	var footer_top := height - bottom - footer_height
	var injury_height := 58 if not GameState.injuries.is_empty() else 0
	_place(game.injury_section, inset, footer_top - injury_height - 8, content_width, injury_height)
	var action_height := maxf(60, footer_top - injury_height - 10 - actions_top)
	_place(game.get_node("ActionScroll"), inset, actions_top, content_width, action_height)
	_place(surfaces[1], inset - 2, actions_top - 2, content_width + 4, action_height + 4)
	_place(game.get_node("TabsRow"), inset, footer_top, content_width - 100, footer_height)
	game.get_node("TabsRow").add_theme_constant_override("separation", 8)
	_place(game.next_season_btn, width - inset - 92, footer_top, 92, footer_height)


func refresh() -> void:
	if not is_instance_valid(title): return
	pack_button.visible = COMPANIONS.supported() and not COMPANIONS.current_cast().is_empty()
	pack_button.text = ""
	pack_button.get_node("ShortcutLabel").text = COMPANIONS.group_name().capitalize()
	pack_button.accessibility_name = "View your " + COMPANIONS.group_name() + " members and relationships"
	map_button.accessibility_name = "Habitat, environment and home details"
	family_button.visible = preload("res://scripts/systems/family_legacy.gd").available()
	game.tab_bonuses.accessibility_name = "Stats and perks"
	title.text = str(SpeciesDB.get_species(GameState.species_id).get("display_name", "DinoLife"))
	caption.text = "%s · Season %d" % [GameState.get_stage_name(), GameState.seasons_elapsed + 1]
	weather_button.text = ""
	weather_button.get_node("ShortcutIcon").texture = WEATHER.icon()
	weather_button.accessibility_name = "Weather and seasonal effects: " + WEATHER.caption()
	weather_button.tooltip_text = WEATHER.caption() + " · Tap for weather and seasonal effects"
	game.tab_kills.text = game.tab_kills.text.replace("Next: ", "").replace("Survived", "seasons")
	game.tab_bonuses.text = ""
	for key in stat_labels:
		var name: String = {"health": "Health", "hunger": "Food", "pack_bond": "Bond"}[key]
		stat_labels[key].text = "%s %.0f%%" % [name, float(GameState.get(key)) * 100]
	for child in game.injury_section.get_children():
		game.injury_section.remove_child(child)
		child.queue_free()
	if not GameState.injuries.is_empty():
		var row := HBoxContainer.new()
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		game.injury_section.add_child(row)
		var wound_label := UI.label("Wounds", 11, Color(0.96, 0.66, 0.56))
		wound_label.autowrap_mode = TextServer.AUTOWRAP_OFF
		wound_label.custom_minimum_size.x = 52
		wound_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		row.add_child(wound_label)
		var scroll := ScrollContainer.new()
		scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
		row.add_child(scroll)
		var tokens := HBoxContainer.new()
		scroll.add_child(tokens)
		for injury in GameState.injuries:
			var button := Button.new()
			button.text = str(injury.get("name", "Injury"))
			button.custom_minimum_size.y = 44
			_style_button(button, false)
			button.add_theme_font_size_override("font_size", 12)
			for state in ["normal", "hover", "pressed", "disabled"]:
				var box := button.get_theme_stylebox(state)
				box.content_margin_left = 18
				box.content_margin_right = 18
			button.pressed.connect(game._on_injury_tapped.bind(injury.duplicate()))
			tokens.add_child(button)
	layout()
