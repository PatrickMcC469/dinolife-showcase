extends RefCounted

const GOLD = Color(0.91, 0.76, 0.43)
const PAPER = Color(0.96, 0.94, 0.83)
const MUTED = Color(0.70, 0.76, 0.65)
const FONT = preload("res://assets/fonts/Lora.ttf")
const HEADING_FONT = preload("res://assets/fonts/Lora-Bold.tres")


static func apply_theme(root: Control) -> void:
	var theme := Theme.new()
	theme.default_font = FONT
	theme.default_font_size = 14
	theme.set_font("font", "Button", HEADING_FONT)
	root.theme = theme


static func heading(text: String, font_size: int = 22, color: Color = GOLD) -> Label:
	var node := label(text, font_size, color)
	node.add_theme_font_override("font", HEADING_FONT)
	return node


static func nameplate() -> StyleBoxTexture:
	var style := StyleBoxTexture.new()
	var artwork := AtlasTexture.new()
	artwork.atlas = preload("res://assets/ui/adventure/portrait_nameplate_v2.png")
	# Frame the visible paper without changing the original generated bitmap.
	artwork.region = Rect2(12, 162, 2148, 399)
	style.texture = artwork
	for side in [SIDE_LEFT, SIDE_RIGHT]:
		style.set_content_margin(side, 18)
	for side in [SIDE_TOP, SIDE_BOTTOM]:
		style.set_content_margin(side, 6)
	return style


static func box(color: Color, border: Color = Color(0.32, 0.42, 0.30), radius: int = 14) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = border
	style.set_border_width_all(1)
	style.set_corner_radius_all(radius)
	style.content_margin_left = 16
	style.content_margin_right = 16
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	return style


static func button(btn: Button, primary: bool = false, selected: bool = false) -> void:
	btn.mouse_filter = Control.MOUSE_FILTER_PASS
	btn.flat = false
	btn.add_theme_stylebox_override("normal", box(Color(0.10, 0.20, 0.14, 0.96) if primary else Color(0.045, 0.09, 0.07, 0.94), GOLD if primary or selected else Color(0.30, 0.40, 0.28)))
	btn.add_theme_stylebox_override("hover", box(Color(0.14, 0.25, 0.18), GOLD))
	btn.add_theme_stylebox_override("pressed", box(Color(0.06, 0.14, 0.10), GOLD))
	btn.add_theme_stylebox_override("focus", box(Color(0, 0, 0, 0), GOLD))
	btn.add_theme_stylebox_override("disabled", box(Color(0.04, 0.07, 0.05, 0.75), Color(0.25, 0.30, 0.23)))
	btn.add_theme_color_override("font_color", PAPER)
	btn.add_theme_color_override("font_hover_color", Color.WHITE)
	btn.add_theme_color_override("font_disabled_color", Color(0.48, 0.54, 0.47))
	btn.add_theme_font_size_override("font_size", 17 if primary else 14)
	for state in ["normal", "hover", "pressed", "disabled"]:
		var style := btn.get_theme_stylebox(state) as StyleBoxFlat
		style.content_margin_left = 10
		style.content_margin_right = 10
	btn.custom_minimum_size.y = 48
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn.add_theme_constant_override("icon_max_width", 26)
	btn.expand_icon = true
	btn.add_theme_constant_override("h_separation", 8)


static func label(text: String, font_size: int = 14, color: Color = PAPER) -> Label:
	var node := Label.new()
	node.text = text
	node.add_theme_font_size_override("font_size", font_size)
	node.add_theme_color_override("font_color", color)
	node.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return node


static func page(root: Control, top: int = 32) -> VBoxContainer:
	var margin := MarginContainer.new()
	margin.name = "PageMargin"
	root.add_child(margin)
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var side := maxi(20, int((root.get_viewport_rect().size.x - 560) * 0.5))
	margin.add_theme_constant_override("margin_left", 0)
	margin.add_theme_constant_override("margin_right", 0)
	margin.add_theme_constant_override("margin_top", top)
	margin.add_theme_constant_override("margin_bottom", 28)
	if OS.get_name() == "iOS":
		var safe := DisplayServer.get_display_safe_area()
		var height := float(DisplayServer.window_get_size().y)
		if height > 0.0:
			var scale := root.get_viewport_rect().size.y / height
			margin.add_theme_constant_override("margin_top", maxi(top, int(safe.position.y * scale) + 12))
			margin.add_theme_constant_override("margin_bottom", maxi(28, int((height - safe.end.y) * scale) + 12))
	var scroll := ScrollContainer.new()
	scroll.name = "PageScroll"
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.follow_focus = true
	scroll.add_theme_constant_override("scrollbar_width", 0)
	# Keep the artwork inset while accepting swipes at either screen edge.
	var padding := StyleBoxEmpty.new()
	padding.content_margin_left = side
	padding.content_margin_right = side
	scroll.add_theme_stylebox_override("panel", padding)
	margin.add_child(scroll)
	var rail := StyleBoxEmpty.new()
	rail.content_margin_left = 3
	rail.content_margin_right = 3
	scroll.get_v_scroll_bar().add_theme_stylebox_override("scroll", rail)
	for state in ["grabber", "grabber_highlight", "grabber_pressed"]:
		var thumb := StyleBoxFlat.new()
		thumb.bg_color = Color(0.73, 0.76, 0.52, 0.65)
		thumb.set_corner_radius_all(3)
		scroll.get_v_scroll_bar().add_theme_stylebox_override(state, thumb)
	var body := VBoxContainer.new()
	body.name = "Body"
	body.mouse_filter = Control.MOUSE_FILTER_PASS
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 12)
	scroll.add_child(body)
	return body
