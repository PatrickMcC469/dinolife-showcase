extends Control

const IMG_PATH := "res://assets/story_deno/act01_img01_morning_beneath_roots.jpg"

func _ready() -> void:
	_build_ui()


func _build_ui() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)

	# Background
	var bg := Panel.new()
	bg.layout_mode = 1
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var bg_style := StyleBoxFlat.new()
	bg_style.bg_color = Color(0.055, 0.038, 0.020)
	bg.add_theme_stylebox_override("panel", bg_style)
	add_child(bg)

	# Safe-area
	var safe_top := 16
	if OS.get_name() == "iOS":
		var sa := DisplayServer.get_display_safe_area()
		safe_top = maxi(16, sa.position.y + 6)

	# Top bar
	var top_bar := Control.new()
	top_bar.layout_mode = 1
	top_bar.anchor_left   = 0.0; top_bar.anchor_top    = 0.0
	top_bar.anchor_right  = 1.0; top_bar.anchor_bottom = 0.0
	top_bar.offset_top    = safe_top
	top_bar.offset_bottom = safe_top + 36
	add_child(top_bar)

	var back_btn := Button.new()
	back_btn.layout_mode = 1
	back_btn.set_anchors_preset(Control.PRESET_CENTER_LEFT)
	back_btn.offset_left   = 12
	back_btn.offset_right  = 72
	back_btn.offset_top    = -14
	back_btn.offset_bottom = 14
	back_btn.flat = true
	back_btn.text = "← Menu"
	back_btn.focus_mode = Control.FOCUS_NONE
	back_btn.add_theme_font_size_override("font_size", 13)
	back_btn.add_theme_color_override("font_color",       Color(0.65, 0.58, 0.40, 0.80))
	back_btn.add_theme_color_override("font_hover_color", Color(0.90, 0.78, 0.55, 1.00))
	var back_style := StyleBoxEmpty.new()
	back_btn.add_theme_stylebox_override("normal",  back_style)
	back_btn.add_theme_stylebox_override("hover",   back_style)
	back_btn.add_theme_stylebox_override("pressed", back_style)
	back_btn.pressed.connect(_on_back)
	top_bar.add_child(back_btn)

	# Heading
	var heading := Label.new()
	heading.layout_mode = 1
	heading.set_anchors_preset(Control.PRESET_CENTER_TOP)
	heading.offset_left   = -80
	heading.offset_right  = 80
	heading.offset_top    = safe_top + 6
	heading.offset_bottom = safe_top + 32
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.text = "Stories"
	heading.add_theme_font_size_override("font_size", 18)
	heading.add_theme_color_override("font_color", Color(1.00, 0.88, 0.52))
	add_child(heading)

	# Scroll area below top bar
	var scroll := ScrollContainer.new()
	scroll.layout_mode = 1
	scroll.anchor_left   = 0.0; scroll.anchor_top    = 0.0
	scroll.anchor_right  = 1.0; scroll.anchor_bottom = 1.0
	scroll.offset_top    = safe_top + 44
	scroll.offset_bottom = -20
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(scroll)

	var vbox := VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_theme_constant_override("separation", 16)
	scroll.add_child(vbox)

	var outer := MarginContainer.new()
	outer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	outer.add_theme_constant_override("margin_left",   20)
	outer.add_theme_constant_override("margin_right",  20)
	outer.add_theme_constant_override("margin_top",    12)
	outer.add_theme_constant_override("margin_bottom", 24)
	vbox.add_child(outer)

	var inner := VBoxContainer.new()
	inner.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	inner.add_theme_constant_override("separation", 16)
	outer.add_child(inner)

	# ── Active story card ───────────────────────────────────────────────────────
	inner.add_child(_build_active_card())

	# ── Coming-soon teaser ──────────────────────────────────────────────────────
	inner.add_child(_build_coming_soon())


func _build_active_card() -> Control:
	var card := PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var card_style := StyleBoxFlat.new()
	card_style.bg_color = Color(0.10, 0.07, 0.03, 0.95)
	card_style.set_corner_radius_all(14)
	card_style.set_border_width_all(2)
	card_style.border_color = Color(0.75, 0.55, 0.22, 0.90)
	card.add_theme_stylebox_override("panel", card_style)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 0)
	card.add_child(vbox)

	# Cover image
	if ResourceLoader.exists(IMG_PATH):
		var img_wrap := Control.new()
		img_wrap.layout_mode = 2
		img_wrap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		img_wrap.custom_minimum_size    = Vector2(0, 180)
		img_wrap.clip_contents          = true
		vbox.add_child(img_wrap)

		var img := TextureRect.new()
		img.layout_mode  = 1
		img.set_anchors_preset(Control.PRESET_FULL_RECT)
		img.texture      = load(IMG_PATH)
		img.expand_mode  = TextureRect.EXPAND_IGNORE_SIZE
		img.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		img_wrap.add_child(img)

		# Gradient fade bottom of image
		var grad := Gradient.new()
		grad.offsets = PackedFloat32Array([0.5, 1.0])
		grad.colors  = PackedColorArray([Color(0.10, 0.07, 0.03, 0.0), Color(0.10, 0.07, 0.03, 1.0)])
		var grad_tex := GradientTexture2D.new()
		grad_tex.gradient = grad
		grad_tex.fill_from = Vector2(0, 0)
		grad_tex.fill_to   = Vector2(0, 1)
		var fade := TextureRect.new()
		fade.layout_mode  = 1
		fade.set_anchors_preset(Control.PRESET_FULL_RECT)
		fade.texture      = grad_tex
		fade.expand_mode  = TextureRect.EXPAND_IGNORE_SIZE
		fade.stretch_mode = TextureRect.STRETCH_SCALE
		fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
		img_wrap.add_child(fade)

	# Text block
	var text_margin := MarginContainer.new()
	text_margin.add_theme_constant_override("margin_left",   18)
	text_margin.add_theme_constant_override("margin_right",  18)
	text_margin.add_theme_constant_override("margin_top",    14)
	text_margin.add_theme_constant_override("margin_bottom", 16)
	vbox.add_child(text_margin)

	var text_vbox := VBoxContainer.new()
	text_vbox.add_theme_constant_override("separation", 6)
	text_margin.add_child(text_vbox)

	var title_lbl := Label.new()
	title_lbl.text = "Deinonychus"
	title_lbl.add_theme_font_size_override("font_size", 22)
	title_lbl.add_theme_color_override("font_color", Color(1.00, 0.88, 0.52))
	text_vbox.add_child(title_lbl)

	var tag_lbl := Label.new()
	tag_lbl.text = "The forest remembers those who learn to read it."
	tag_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	tag_lbl.add_theme_font_size_override("font_size", 14)
	tag_lbl.add_theme_color_override("font_color", Color(0.88, 0.84, 0.72, 0.90))
	text_vbox.add_child(tag_lbl)

	# Button style helpers (shared)
	var btn_style := StyleBoxFlat.new()
	btn_style.bg_color = Color(0.20, 0.14, 0.04, 0.90)
	btn_style.set_corner_radius_all(10)
	btn_style.set_border_width_all(2)
	btn_style.border_color = Color(0.75, 0.55, 0.22, 0.90)
	var btn_hover := StyleBoxFlat.new()
	btn_hover.bg_color = Color(0.30, 0.20, 0.06, 0.95)
	btn_hover.set_corner_radius_all(10)
	btn_hover.set_border_width_all(2)
	btn_hover.border_color = Color(0.90, 0.70, 0.30, 1.0)

	var has_progress := StoryState.has_save() and StoryState.current_scene_id != "s_start" \
		and not StoryState.current_scene_id.is_empty()

	if has_progress:
		# Primary: continue
		var cont_btn := Button.new()
		cont_btn.text = "Continue Story"
		cont_btn.custom_minimum_size = Vector2(0, 44)
		cont_btn.add_theme_font_size_override("font_size", 16)
		cont_btn.add_theme_color_override("font_color", Color(0.97, 0.93, 0.80))
		cont_btn.add_theme_stylebox_override("normal",  btn_style)
		cont_btn.add_theme_stylebox_override("hover",   btn_hover)
		cont_btn.add_theme_stylebox_override("pressed", btn_style)
		cont_btn.focus_mode = Control.FOCUS_NONE
		cont_btn.pressed.connect(_on_continue)
		text_vbox.add_child(cont_btn)

		# Secondary: start over (dimmer)
		var restart_btn := Button.new()
		restart_btn.text = "Start Over"
		restart_btn.custom_minimum_size = Vector2(0, 34)
		restart_btn.add_theme_font_size_override("font_size", 13)
		restart_btn.add_theme_color_override("font_color", Color(0.70, 0.60, 0.40, 0.80))
		var dim_style := StyleBoxFlat.new()
		dim_style.bg_color = Color(0.12, 0.08, 0.02, 0.50)
		dim_style.set_corner_radius_all(8)
		dim_style.set_border_width_all(1)
		dim_style.border_color = Color(0.50, 0.38, 0.15, 0.50)
		restart_btn.add_theme_stylebox_override("normal",  dim_style)
		restart_btn.add_theme_stylebox_override("hover",   dim_style)
		restart_btn.add_theme_stylebox_override("pressed", dim_style)
		restart_btn.focus_mode = Control.FOCUS_NONE
		restart_btn.pressed.connect(_on_start_over)
		text_vbox.add_child(restart_btn)
	else:
		var play_btn := Button.new()
		play_btn.text = "Play Story"
		play_btn.custom_minimum_size = Vector2(0, 44)
		play_btn.add_theme_font_size_override("font_size", 16)
		play_btn.add_theme_color_override("font_color", Color(0.97, 0.93, 0.80))
		play_btn.add_theme_stylebox_override("normal",  btn_style)
		play_btn.add_theme_stylebox_override("hover",   btn_hover)
		play_btn.add_theme_stylebox_override("pressed", btn_style)
		play_btn.focus_mode = Control.FOCUS_NONE
		play_btn.pressed.connect(_on_continue)
		text_vbox.add_child(play_btn)

	return card


func _build_coming_soon() -> Control:
	var card := PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var card_style := StyleBoxFlat.new()
	card_style.bg_color = Color(0.07, 0.05, 0.025, 0.50)
	card_style.set_corner_radius_all(14)
	card_style.set_border_width_all(1)
	card_style.border_color = Color(0.35, 0.30, 0.20, 0.30)
	card.add_theme_stylebox_override("panel", card_style)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left",   20)
	margin.add_theme_constant_override("margin_right",  20)
	margin.add_theme_constant_override("margin_top",    20)
	margin.add_theme_constant_override("margin_bottom", 20)
	card.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 6)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	margin.add_child(vbox)

	var icon_lbl := Label.new()
	icon_lbl.text = "🦕"
	icon_lbl.add_theme_font_size_override("font_size", 28)
	icon_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(icon_lbl)

	var title_lbl := Label.new()
	title_lbl.text = "More Stories Coming"
	title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_lbl.add_theme_font_size_override("font_size", 15)
	title_lbl.add_theme_color_override("font_color", Color(0.55, 0.50, 0.38, 0.65))
	vbox.add_child(title_lbl)

	var sub_lbl := Label.new()
	sub_lbl.text = "New species. New worlds. New choices."
	sub_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	sub_lbl.add_theme_font_size_override("font_size", 12)
	sub_lbl.add_theme_color_override("font_color", Color(0.42, 0.38, 0.28, 0.50))
	vbox.add_child(sub_lbl)

	return card


func _build_teaser_card(title: String, tagline: String) -> Control:
	var card := PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var card_style := StyleBoxFlat.new()
	card_style.bg_color = Color(0.07, 0.05, 0.025, 0.70)
	card_style.set_corner_radius_all(14)
	card_style.set_border_width_all(2)
	card_style.border_color = Color(0.35, 0.30, 0.20, 0.40)
	card.add_theme_stylebox_override("panel", card_style)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left",   18)
	margin.add_theme_constant_override("margin_right",  18)
	margin.add_theme_constant_override("margin_top",    18)
	margin.add_theme_constant_override("margin_bottom", 18)
	card.add_child(margin)

	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 12)
	margin.add_child(hbox)

	# Lock badge
	var lock_lbl := Label.new()
	lock_lbl.text = "🔒"
	lock_lbl.add_theme_font_size_override("font_size", 24)
	lock_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hbox.add_child(lock_lbl)

	var text_vbox := VBoxContainer.new()
	text_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_vbox.add_theme_constant_override("separation", 4)
	hbox.add_child(text_vbox)

	var title_lbl := Label.new()
	title_lbl.text = title
	title_lbl.add_theme_font_size_override("font_size", 16)
	title_lbl.add_theme_color_override("font_color", Color(0.55, 0.50, 0.38, 0.70))
	text_vbox.add_child(title_lbl)

	var tag_lbl := Label.new()
	tag_lbl.text = tagline
	tag_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	tag_lbl.add_theme_font_size_override("font_size", 13)
	tag_lbl.add_theme_color_override("font_color", Color(0.45, 0.40, 0.30, 0.60))
	text_vbox.add_child(tag_lbl)

	var soon_lbl := Label.new()
	soon_lbl.text = "Coming Soon"
	soon_lbl.add_theme_font_size_override("font_size", 11)
	soon_lbl.add_theme_color_override("font_color", Color(0.60, 0.50, 0.28, 0.55))
	text_vbox.add_child(soon_lbl)

	return card


func _on_continue() -> void:
	get_tree().change_scene_to_file("res://scenes/story/story_screen.tscn")


func _on_start_over() -> void:
	StoryState.reset()
	StoryState.delete_save()
	get_tree().change_scene_to_file("res://scenes/story/story_screen.tscn")


func _on_back() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
