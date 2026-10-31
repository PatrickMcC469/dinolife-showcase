extends Control

signal member_selected(member_name: String)
const PAIRS = preload("res://scripts/systems/pack_relationships.gd")
const ART = preload("res://scripts/ui/adventure_theme.gd")
var members: Array = []
var selected := ""
var markers := {}
var you: Label


func setup(cast: Array, member_name: String) -> void:
	members = cast
	selected = member_name
	custom_minimum_size.y = 285
	mouse_filter = Control.MOUSE_FILTER_PASS
	var alpha: Dictionary = preload("res://scripts/systems/pack_leadership.gd").leader()
	for member in members:
		var button := Button.new()
		button.mouse_filter = Control.MOUSE_FILTER_PASS
		var leader: bool = not GameState.is_alpha and member["name"] == alpha.get("name")
		button.text = member["name"] + ("\nAlpha" if leader else "")
		button.icon = load("res://assets/character_selection/%s_selection.png" % GameState.species_id)
		button.expand_icon = true
		button.add_theme_constant_override("icon_max_width", 30)
		button.add_theme_font_size_override("font_size", 12)
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		button.custom_minimum_size = Vector2(78, 64)
		button.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
		button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		button.alignment = HORIZONTAL_ALIGNMENT_CENTER
		button.accessibility_name = "View " + member["name"] + (", alpha" if leader else "")
		button.pressed.connect(func(): member_selected.emit(member["name"]))
		ART.button(button, member["name"] == selected)
		add_child(button)
		if leader:
			var crown := TextureRect.new()
			crown.texture = preload("res://assets/ui/action_icons/alpha.svg")
			crown.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			crown.mouse_filter = Control.MOUSE_FILTER_IGNORE
			button.add_child(crown)
			crown.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
			crown.offset_left = -23
			crown.offset_right = -5
			crown.offset_top = 6
			crown.offset_bottom = 24
		markers[member["name"]] = button
	you = preload("res://scripts/ui/perks_panel.gd").label("YOU\nAlpha" if GameState.is_alpha else "YOU", 14, ART.CREAM)
	you.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(you)
	if GameState.is_alpha:
		var crown := TextureRect.new()
		crown.texture = preload("res://assets/ui/action_icons/alpha.svg")
		crown.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		crown.mouse_filter = Control.MOUSE_FILTER_IGNORE
		you.add_child(crown)
		crown.position = Vector2(30, -20)
		crown.size = Vector2(20, 20)
	resized.connect(_layout)
	_layout.call_deferred()


func _layout() -> void:
	for i in members.size():
		var button: Button = markers[members[i]["name"]]
		var angle := -PI / 2.0 + TAU * i / members.size()
		button.size = Vector2(78, 64)
		button.position = size / 2 + Vector2(cos(angle) * maxf(50, size.x / 2 - 43), sin(angle) * (size.y / 2 - 36)) - button.size / 2
	you.size = Vector2(80, 48)
	you.position = size / 2 - you.size / 2
	queue_redraw()


func _draw() -> void:
	for pair in GameState.pack_relations.get("pairs", []):
		if not markers.has(pair["a"]) or not markers.has(pair["b"]): continue
		var status := PAIRS.status(pair)
		if status == "Getting acquainted" and selected not in [pair["a"], pair["b"]]: continue
		var a: Button = markers[pair["a"]]
		var b: Button = markers[pair["b"]]
		var start := a.position + a.size / 2
		var end := b.position + b.size / 2
		var emphasized: bool = selected in [pair["a"], pair["b"]]
		var color := Color(0.94, 0.47, 0.32) if status == "Rivals" else (Color(0.48, 0.78, 0.54) if status == "Friends" else Color(0.54, 0.60, 0.51, 0.45))
		if not emphasized: color.a = 0.30
		if status == "Rivals": draw_dashed_line(start, end, color, 2 if emphasized else 1, 6, true)
		else: draw_line(start, end, color, 2 if emphasized else 1, true)
