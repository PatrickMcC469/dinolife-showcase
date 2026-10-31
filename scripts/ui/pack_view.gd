extends RefCounted

const ART = preload("res://scripts/ui/adventure_theme.gd")


static func create(game: Control, roster: PanelContainer) -> Control:
	# Reuse the live roster so names, relationships and leadership have one source.
	var backdrop := ColorRect.new()
	backdrop.name = "PackView"
	backdrop.color = Color(0.035, 0.065, 0.045, 0.96)
	backdrop.z_index = 150
	game.add_child(backdrop)
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var panel := PanelContainer.new()
	panel.name = "Card"
	panel.mouse_filter = Control.MOUSE_FILTER_PASS
	backdrop.add_child(panel)
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
	var column := VBoxContainer.new()
	column.name = "Content"
	column.mouse_filter = Control.MOUSE_FILTER_PASS
	column.add_theme_constant_override("separation", 12)
	panel.add_child(column)
	var relationships := preload("res://scripts/ui/pack_relationships_view.gd").new()
	relationships.name = "PackRelationships"
	game.add_child(relationships)
	backdrop.set_meta("relationships_view", relationships)
	var web_button := Button.new()
	web_button.name = "Relationships"
	web_button.text = "Friends & rivals"
	web_button.custom_minimum_size.y = 44
	ART.button(web_button)
	web_button.pressed.connect(func():
		backdrop.hide()
		relationships.open())
	relationships.closed.connect(func():
		roster.refresh()
		game.move_child(backdrop, -1)
		backdrop.show()
		web_button.grab_focus())
	relationships.care_requested.connect(game._on_pair_care)
	column.add_child(web_button)
	var leadership := Button.new()
	leadership.name = "Leadership"
	leadership.text = "Your alpha duties" if GameState.is_alpha else "Meet your alpha"
	leadership.icon = preload("res://scripts/ui/illustrated_icons.gd").texture("alpha")
	leadership.expand_icon = true
	leadership.add_theme_constant_override("icon_max_width", 22)
	leadership.custom_minimum_size.y = 44
	ART.button(leadership)
	leadership.pressed.connect(func():
		backdrop.hide()
		game._on_action_pressed("leadership"))
	column.add_child(leadership)
	var scroll := ScrollContainer.new()
	scroll.name = "Scroll"
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	column.add_child(scroll)
	roster.reparent(scroll)
	roster.expanded = true
	roster.details_button.hide()
	roster.heading.add_theme_font_size_override("font_size", 20)
	roster.refresh()
	var close := Button.new()
	close.name = "Close"
	close.text = "Back to your life"
	close.custom_minimum_size.y = 48
	ART.button(close, true)
	close.pressed.connect(backdrop.hide)
	column.add_child(close)
	backdrop.hide()
	return backdrop
