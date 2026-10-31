extends RefCounted

const INK = Color(0.19, 0.16, 0.10)
const MUTED_INK = Color(0.37, 0.31, 0.21)
const CREAM = Color(0.96, 0.90, 0.73)
const GOLD = Color(0.96, 0.77, 0.39)
const PANEL = preload("res://assets/ui/adventure/parchment_panel_v1.png")
const FRAME = preload("res://assets/ui/adventure/portrait_frame_v1.png")
static var _panel_texture: Texture2D
static var _small_texture: Texture2D
static var _frame_texture: Texture2D


static func parchment(tint: Color = Color.WHITE, padding: float = 16.0, compact: bool = false) -> StyleBoxTexture:
	if compact:
		if _small_texture == null:
			var image := PANEL.get_image()
			image.resize(96, 96, Image.INTERPOLATE_LANCZOS)
			_small_texture = ImageTexture.create_from_image(image)
		var box := _box(_small_texture, tint, padding)
		for side in [SIDE_LEFT, SIDE_TOP, SIDE_RIGHT, SIDE_BOTTOM]: box.set_texture_margin(side, 14)
		return box
	if _panel_texture == null:
		var image := PANEL.get_image()
		image.resize(160, 160, Image.INTERPOLATE_LANCZOS)
		_panel_texture = ImageTexture.create_from_image(image)
	return _box(_panel_texture, tint, padding)


static func frame() -> StyleBoxTexture:
	if _frame_texture == null:
		var image := FRAME.get_image()
		image.resize(160, 160, Image.INTERPOLATE_LANCZOS)
		_frame_texture = ImageTexture.create_from_image(image)
	return _box(_frame_texture, Color.WHITE, 16.0)


static func _box(texture: Texture2D, tint: Color, padding: float) -> StyleBoxTexture:
	var box := StyleBoxTexture.new()
	box.texture = texture
	box.modulate_color = tint
	for side in [SIDE_LEFT, SIDE_TOP, SIDE_RIGHT, SIDE_BOTTOM]:
		box.set_texture_margin(side, 22)
		box.set_content_margin(side, padding)
	return box


static func button(node: Button, primary: bool = false, compact: bool = true) -> void:
	node.flat = false
	node.add_theme_stylebox_override("normal", parchment(Color(1, 0.89, 0.57) if primary else Color.WHITE, 10, compact))
	node.add_theme_stylebox_override("hover", parchment(Color(1, 0.97, 0.83), 10, compact))
	node.add_theme_stylebox_override("pressed", parchment(Color(0.84, 0.81, 0.68), 10, compact))
	node.add_theme_stylebox_override("disabled", parchment(Color(0.64, 0.64, 0.58), 10, compact))
	var focus := StyleBoxFlat.new()
	focus.bg_color = Color.TRANSPARENT
	focus.border_color = GOLD
	focus.set_border_width_all(2)
	focus.set_corner_radius_all(10)
	node.add_theme_stylebox_override("focus", focus)
	for state in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		node.add_theme_color_override(state, INK)
	node.add_theme_color_override("font_disabled_color", Color(0.31, 0.29, 0.23))
	node.add_theme_constant_override("outline_size", 0)
