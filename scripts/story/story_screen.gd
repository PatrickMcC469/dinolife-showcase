extends Control

# ── UI nodes (built in _ready) ────────────────────────────────────────────────
var _bg:            Panel
var _image_wrap:    Control
var _image_rect:    TextureRect
var _main_vbox:     VBoxContainer
var _text_scroll:   ScrollContainer
var _text_vbox:     VBoxContainer
var _act_label:     Label
var _title_label:   Label
var _rule:          Panel
var _body_label:    Label
var _choice_vbox:   VBoxContainer
var _top_bar:       Control
var _back_btn:      Button
var _settings_panel: Control

# ── Name-entry nodes (shown only on s_start) ─────────────────────────────────
var _name_entry:    LineEdit
var _begin_btn:     Button

# ── State ────────────────────────────────────────────────────────────────────
var _current_image_path: String = ""
var _in_result: bool = false

# ── Typewriter ────────────────────────────────────────────────────────────────
var _typewriter_active:  bool  = false
var _typewriter_elapsed: float = 0.0
var _typewriter_type:    String = ""   # "choices" or "name_entry"
var _revealing_gesture := false
var _text_tween: Tween
const _TYPEWRITER_CPS: float   = 45.0

# ── Music ─────────────────────────────────────────────────────────────────────
var _music_player:        AudioStreamPlayer
var _current_music_track: String = ""
var _music_tween: Tween

const _ACT_MUSIC := {
	"Act One  —  Before the Waters": "ambient_70bpm",
	"Act Two  —  After the Flood":   "low_tension_140bpm",
	"Act Three  —  The Ridge":       "hunt_music",
}
const _MUSIC_FADE_TIME := 0.7

# ── Rewind / history ─────────────────────────────────────────────────────────
var _history:              Array = []       # [{scene_id, state}] — one entry per visible scene
var _entry_state:          Dictionary = {}  # state snapshot when we arrived at current scene
var _current_act:          String = ""      # act string of current scene
var _act_checkpoint_state: Dictionary = {}  # state snapshot at the start of current act
var _in_auto_redirect:     bool = false     # true while traversing auto_redirect chains


func _ready() -> void:
	_build_ui()
	if StoryState.current_scene_id.is_empty():
		StoryState.current_scene_id = "s_start"
	_show_scene(StoryState.current_scene_id)


# ══════════════════════════════════════════════════════════════════════════════
# UI BUILDER
# ══════════════════════════════════════════════════════════════════════════════

func _build_ui() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_music_player = AudioStreamPlayer.new()
	_music_player.bus = "Master"
	add_child(_music_player)

	# Background
	_bg = Panel.new()
	_bg.layout_mode = 1
	_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var bg_style := StyleBoxFlat.new()
	bg_style.bg_color = Color(0.08, 0.13, 0.105)
	_bg.add_theme_stylebox_override("panel", bg_style)
	add_child(_bg)
	var backdrop := TextureRect.new()
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	backdrop.texture = preload("res://scenes/ui/narrative_backdrop.tres")
	backdrop.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_bg.add_child(backdrop)

	# Stop gameplay ambient music — SoundManager keeps playing across scenes
	SoundManager._music.stop()

	# Safe-area margins — convert physical pixels to viewport logical pixels
	var safe_top := 16
	var safe_bottom := 20
	if OS.get_name() == "iOS":
		var sa      := DisplayServer.get_display_safe_area()
		var win_h   := float(DisplayServer.window_get_size().y)
		var vp_h    := get_viewport().get_visible_rect().size.y
		var scale   := (vp_h / win_h) if win_h > 0.0 else 1.0
		safe_top    = maxi(16, int(sa.position.y    * scale) + 4)
		safe_bottom = maxi(20, int((win_h - sa.end.y) * scale) + 6)

	# Top bar
	_top_bar = Control.new()
	_top_bar.layout_mode = 1
	_top_bar.anchor_left   = 0.0; _top_bar.anchor_top    = 0.0
	_top_bar.anchor_right  = 1.0; _top_bar.anchor_bottom = 0.0
	_top_bar.offset_top    = safe_top
	_top_bar.offset_bottom = safe_top + 36
	add_child(_top_bar)

	# Home button (left)
	var menu_btn := Button.new()
	menu_btn.layout_mode = 1
	menu_btn.set_anchors_preset(Control.PRESET_CENTER_LEFT)
	menu_btn.offset_left   = 12
	menu_btn.offset_right  = 68
	menu_btn.offset_top    = -14
	menu_btn.offset_bottom = 14
	menu_btn.flat = true
	menu_btn.text = "Home"
	menu_btn.focus_mode = Control.FOCUS_NONE
	menu_btn.add_theme_font_size_override("font_size", 13)
	menu_btn.add_theme_color_override("font_color",       Color(0.65, 0.58, 0.40, 0.80))
	menu_btn.add_theme_color_override("font_hover_color", Color(0.90, 0.78, 0.55, 1.00))
	var mb_style := StyleBoxEmpty.new()
	menu_btn.add_theme_stylebox_override("normal",  mb_style)
	menu_btn.add_theme_stylebox_override("hover",   mb_style)
	menu_btn.add_theme_stylebox_override("pressed", mb_style)
	menu_btn.pressed.connect(_on_menu_pressed)
	_top_bar.add_child(menu_btn)

	# Settings button (left, beside Home)
	var settings_btn := Button.new()
	settings_btn.layout_mode = 1
	settings_btn.set_anchors_preset(Control.PRESET_CENTER_LEFT)
	settings_btn.offset_left   = 76
	settings_btn.offset_right  = 136
	settings_btn.offset_top    = -14
	settings_btn.offset_bottom = 14
	settings_btn.flat = true
	settings_btn.text = "⚙ Settings"
	settings_btn.focus_mode = Control.FOCUS_NONE
	settings_btn.add_theme_font_size_override("font_size", 13)
	settings_btn.add_theme_color_override("font_color",       Color(0.65, 0.58, 0.40, 0.80))
	settings_btn.add_theme_color_override("font_hover_color", Color(0.90, 0.78, 0.55, 1.00))
	var sb_style := StyleBoxEmpty.new()
	settings_btn.add_theme_stylebox_override("normal",  sb_style)
	settings_btn.add_theme_stylebox_override("hover",   sb_style)
	settings_btn.add_theme_stylebox_override("pressed", sb_style)
	settings_btn.pressed.connect(_on_settings_pressed)
	_top_bar.add_child(settings_btn)

	# Settings panel (instantiated from scene, hidden until opened)
	_settings_panel = preload("res://scenes/ui/settings_panel.tscn").instantiate()
	_settings_panel.layout_mode = 1
	_settings_panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	_settings_panel.visible = false
	add_child(_settings_panel)

	# Back button (right)
	_back_btn = Button.new()
	_back_btn.layout_mode = 1
	_back_btn.set_anchors_preset(Control.PRESET_CENTER_RIGHT)
	_back_btn.offset_left   = -82
	_back_btn.offset_right  = -12
	_back_btn.offset_top    = -14
	_back_btn.offset_bottom = 14
	_back_btn.flat = true
	_back_btn.text = "← Back"
	_back_btn.focus_mode = Control.FOCUS_NONE
	_back_btn.disabled = true
	_back_btn.add_theme_font_size_override("font_size", 13)
	_back_btn.add_theme_color_override("font_color",          Color(0.65, 0.58, 0.40, 0.80))
	_back_btn.add_theme_color_override("font_hover_color",    Color(0.90, 0.78, 0.55, 1.00))
	_back_btn.add_theme_color_override("font_disabled_color", Color(0.65, 0.58, 0.40, 0.22))
	var back_empty := StyleBoxEmpty.new()
	_back_btn.add_theme_stylebox_override("normal",   back_empty)
	_back_btn.add_theme_stylebox_override("hover",    back_empty)
	_back_btn.add_theme_stylebox_override("pressed",  back_empty)
	_back_btn.add_theme_stylebox_override("disabled", back_empty)
	_back_btn.pressed.connect(_on_back_pressed)
	_top_bar.add_child(_back_btn)

	# Outer margin container below top bar
	var outer := MarginContainer.new()
	outer.layout_mode = 1
	outer.anchor_left   = 0.0; outer.anchor_top    = 0.0
	outer.anchor_right  = 1.0; outer.anchor_bottom = 1.0
	outer.offset_top    = safe_top + 36
	outer.offset_bottom = -safe_bottom
	outer.add_theme_constant_override("margin_left",   0)
	outer.add_theme_constant_override("margin_right",  0)
	outer.add_theme_constant_override("margin_top",    0)
	outer.add_theme_constant_override("margin_bottom", 0)
	add_child(outer)

	_main_vbox = VBoxContainer.new()
	_main_vbox.add_theme_constant_override("separation", 10)
	outer.add_child(_main_vbox)

	# Image area
	_image_wrap = Control.new()
	_image_wrap.layout_mode = 2
	_image_wrap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_update_image_height()
	get_viewport().size_changed.connect(_update_image_height)
	_image_wrap.visible = false
	_image_wrap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_main_vbox.add_child(_image_wrap)

	_image_rect = TextureRect.new()
	_image_rect.layout_mode    = 1
	_image_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_image_rect.expand_mode    = TextureRect.EXPAND_IGNORE_SIZE
	_image_rect.stretch_mode   = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_image_rect.mouse_filter   = Control.MOUSE_FILTER_IGNORE
	_image_wrap.add_child(_image_rect)

	# Gradient fade: transparent top, solid bottom
	var fade_grad   := Gradient.new()
	fade_grad.offsets = PackedFloat32Array([0.4, 1.0])
	fade_grad.colors  = PackedColorArray([
		Color(0.08, 0.13, 0.105, 0.0),
		Color(0.08, 0.13, 0.105, 1.0),
	])
	var fade_tex         := GradientTexture2D.new()
	fade_tex.gradient     = fade_grad
	fade_tex.fill_from    = Vector2(0.0, 0.0)
	fade_tex.fill_to      = Vector2(0.0, 1.0)
	var fade_rect         := TextureRect.new()
	fade_rect.layout_mode  = 1
	fade_rect.anchor_left   = 0.0; fade_rect.anchor_top    = 0.0
	fade_rect.anchor_right  = 1.0; fade_rect.anchor_bottom = 1.0
	fade_rect.texture       = fade_tex
	fade_rect.expand_mode   = TextureRect.EXPAND_IGNORE_SIZE
	fade_rect.stretch_mode  = TextureRect.STRETCH_SCALE
	fade_rect.mouse_filter  = Control.MOUSE_FILTER_IGNORE
	_image_wrap.add_child(fade_rect)

	# Text scroll area
	_text_scroll = ScrollContainer.new()
	_text_scroll.layout_mode = 2
	_text_scroll.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	_text_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_text_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_text_scroll.vertical_scroll_mode   = ScrollContainer.SCROLL_MODE_AUTO
	var reading := StyleBoxFlat.new()
	reading.bg_color = Color(0.91, 0.865, 0.735)
	reading.border_color = Color(0.66, 0.57, 0.36)
	reading.set_border_width_all(1)
	reading.set_corner_radius_all(16)
	reading.content_margin_left = 10
	reading.content_margin_right = 10
	reading.content_margin_top = 4
	reading.content_margin_bottom = 4
	reading.shadow_color = Color(0, 0, 0, 0.24)
	reading.shadow_size = 4
	_text_scroll.add_theme_stylebox_override("panel", reading)
	_main_vbox.add_child(_text_scroll)

	_text_vbox = VBoxContainer.new()
	_text_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_text_vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_text_vbox.add_theme_constant_override("separation", 6)
	_text_scroll.add_child(_text_vbox)

	var text_margin := MarginContainer.new()
	text_margin.layout_mode = 2
	text_margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_margin.add_theme_constant_override("margin_left",   14)
	text_margin.add_theme_constant_override("margin_right",  14)
	text_margin.add_theme_constant_override("margin_top",    14)
	text_margin.add_theme_constant_override("margin_bottom", 12)
	_text_vbox.add_child(text_margin)
	text_margin.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var inner_vbox := VBoxContainer.new()
	inner_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	inner_vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	inner_vbox.add_theme_constant_override("separation", 8)
	text_margin.add_child(inner_vbox)

	_act_label = Label.new()
	_act_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_act_label.add_theme_font_size_override("font_size", 11)
	_act_label.add_theme_color_override("font_color", Color(0.43, 0.34, 0.18))
	inner_vbox.add_child(_act_label)

	_title_label = Label.new()
	_title_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_title_label.add_theme_font_size_override("font_size", 22)
	_title_label.add_theme_color_override("font_color", Color(0.22, 0.29, 0.20))
	inner_vbox.add_child(_title_label)

	_rule = Panel.new()
	_rule.layout_mode = 2
	_rule.custom_minimum_size = Vector2(0, 1)
	var rule_style := StyleBoxFlat.new()
	rule_style.bg_color = Color(0.70, 0.52, 0.18, 0.40)
	_rule.add_theme_stylebox_override("panel", rule_style)
	inner_vbox.add_child(_rule)

	_body_label = Label.new()
	_body_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_body_label.visible_characters_behavior = TextServer.VC_CHARS_AFTER_SHAPING
	_body_label.add_theme_font_size_override("font_size", 16)
	_body_label.add_theme_color_override("font_color", Color(0.20, 0.21, 0.16))
	_body_label.add_theme_constant_override("line_spacing", 4)
	inner_vbox.add_child(_body_label)

	# Name entry widgets (hidden unless s_start)
	_name_entry = LineEdit.new()
	_name_entry.placeholder_text    = "Enter a name..."
	_name_entry.max_length          = 18
	_name_entry.visible             = false
	_name_entry.alignment           = HORIZONTAL_ALIGNMENT_CENTER
	_name_entry.add_theme_font_size_override("font_size", 18)
	_name_entry.add_theme_color_override("font_color", Color(0.97, 0.93, 0.80))
	var ne_style := StyleBoxFlat.new()
	ne_style.bg_color     = Color(0.12, 0.08, 0.03)
	ne_style.border_color = Color(0.70, 0.52, 0.20, 0.80)
	ne_style.set_border_width_all(2)
	ne_style.set_corner_radius_all(8)
	ne_style.content_margin_left   = 12
	ne_style.content_margin_right  = 12
	ne_style.content_margin_top    = 10
	ne_style.content_margin_bottom = 10
	_name_entry.add_theme_stylebox_override("normal", ne_style)
	_name_entry.add_theme_stylebox_override("focus",  ne_style)
	inner_vbox.add_child(_name_entry)

	_begin_btn = Button.new()
	_begin_btn.text = "Begin the Story"
	_begin_btn.visible = false
	_begin_btn.custom_minimum_size = Vector2(0, 48)
	_begin_btn.focus_mode = Control.FOCUS_NONE
	_begin_btn.add_theme_font_size_override("font_size", 17)
	_begin_btn.add_theme_color_override("font_color", Color(0.97, 0.93, 0.80))
	var bb_style := StyleBoxFlat.new()
	bb_style.bg_color     = Color(0.20, 0.14, 0.06)
	bb_style.border_color = Color(0.78, 0.58, 0.22)
	bb_style.set_border_width_all(2)
	bb_style.set_corner_radius_all(10)
	_begin_btn.add_theme_stylebox_override("normal",  bb_style)
	_begin_btn.add_theme_stylebox_override("hover",   bb_style)
	_begin_btn.add_theme_stylebox_override("pressed", bb_style)
	_begin_btn.pressed.connect(_on_begin_pressed)
	inner_vbox.add_child(_begin_btn)

	# Choice button area (outside scroll, always at bottom)
	var choice_margin := MarginContainer.new()
	choice_margin.layout_mode = 2
	choice_margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	choice_margin.add_theme_constant_override("margin_left",   16)
	choice_margin.add_theme_constant_override("margin_right",  16)
	choice_margin.add_theme_constant_override("margin_top",    6)
	choice_margin.add_theme_constant_override("margin_bottom", 10)
	choice_margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_main_vbox.add_child(choice_margin)

	_choice_vbox = VBoxContainer.new()
	_choice_vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_choice_vbox.add_theme_constant_override("separation", 8)
	choice_margin.add_child(_choice_vbox)


func _update_image_height() -> void:
	var height := get_viewport_rect().size.y
	_image_wrap.custom_minimum_size.y = clampf(height * 0.3, 100, minf(260, maxf(100, height - 450)))


# ══════════════════════════════════════════════════════════════════════════════
# SCENE LOADING
# ══════════════════════════════════════════════════════════════════════════════

func _show_scene(scene_id: String, allow_chapter_ad: bool = false) -> void:
	var scene: Dictionary = StoryData.get_scene(scene_id)
	_in_result = false
	_typewriter_active = false
	_revealing_gesture = false

	# Auto-redirect: follow first matching branch without rendering
	if scene.get("type", "") == "auto_redirect":
		_in_auto_redirect = true
		var choices: Array = scene.get("choices", []) as Array
		for choice in choices:
			var req: Dictionary = choice.get("requires", {}) as Dictionary
			if req.is_empty() or StoryState.check_requires(req):
				var fx: Dictionary = choice.get("effects", {}) as Dictionary
				if not fx.is_empty():
					StoryState.apply_effects(fx)
				var dest: String = choice.get("next", "") as String
				if not dest.is_empty():
					_navigate(dest, allow_chapter_ad)
					_in_auto_redirect = false
					return
		_in_auto_redirect = false
		return

	# Track act changes — update checkpoint to this scene when entering a new act
	var act_text: String = scene.get("act", "") as String
	if act_text.is_empty() and not StoryState.act_checkpoint.is_empty():
		act_text = StoryData.get_scene(StoryState.act_checkpoint).get("act", "")
	var act_changed := not act_text.is_empty() and act_text != _current_act
	if act_changed:
		# Forward chapter transitions are a natural pause. Resume and rewind skip ads.
		if allow_chapter_ad and not _current_act.is_empty():
			AdManager.show_interstitial()
		_current_act = act_text
		var saved_act: String = StoryData.get_scene(StoryState.act_checkpoint).get("act", "") if not StoryState.act_checkpoint.is_empty() else ""
		if saved_act != act_text or StoryState.act_checkpoint_state.is_empty():
			StoryState.act_checkpoint = scene_id
			StoryState.act_checkpoint_state = _snapshot_state(false)
		_act_checkpoint_state = StoryState.act_checkpoint_state.duplicate(true)

	# Snapshot state before choices, after setting this act's checkpoint.
	_entry_state = _snapshot_state()

	# Music: scene-level override → new-act default → keep whatever is playing
	var desired_music: String = scene.get("music", "") as String
	if desired_music.is_empty():
		desired_music = _ACT_MUSIC.get(act_text, _current_music_track) if act_changed else _current_music_track
	_crossfade_music(desired_music)

	# Image (with optional per-state override)
	var img_path: String = scene.get("image", "") as String
	var img_map: Dictionary = scene.get("image_by_state", {}) as Dictionary
	if not img_map.is_empty():
		for state_key in img_map:
			var sval = StoryState.get(state_key)
			var smap: Dictionary = img_map[state_key] as Dictionary
			var sval_str: String = str(sval) if sval != null else ""
			if sval_str in smap:
				img_path = smap[sval_str] as String
			elif "default" in smap:
				img_path = smap["default"] as String
			break
	_set_image(img_path)

	# Labels
	var title_text: String = scene.get("title", "") as String
	var body_text: String  = scene.get("text",  "") as String
	body_text = body_text.replace("{name}", StoryState.player_name)

	_act_label.text    = act_text.to_upper()
	_act_label.visible = false
	_title_label.text    = title_text
	_title_label.visible = not title_text.is_empty()
	_rule.visible = not title_text.is_empty()
	_body_label.text = body_text
	_body_label.visible_characters = 0
	_fade_text()

	# Scroll back to top
	await get_tree().process_frame
	_text_scroll.scroll_vertical = 0

	# Name entry vs choices
	var scene_type: String = scene.get("type", "story") as String
	if scene_type == "name_entry":
		_name_entry.visible = false
		_begin_btn.visible  = false
		_clear_choices()
		_typewriter_type = "name_entry"
	else:
		_name_entry.visible = false
		_begin_btn.visible  = false
		_build_choices(scene)
		_choice_vbox.modulate.a = 0.0
		_typewriter_type = "choices"

	# Start typewriter, or reveal instantly if there is no body text
	if not body_text.is_empty():
		_typewriter_elapsed = 0.0
		_typewriter_active  = true
	else:
		_finish_typewriter()

	StoryState.current_scene_id = scene_id
	StoryState.save()


func _build_choices(scene: Dictionary) -> void:
	_clear_choices()

	var choices: Array = scene.get("choices", []) as Array
	var next_id: String = scene.get("next", "") as String

	# Filter choices by requires
	var valid_choices: Array = []
	for choice in choices:
		var requires: Dictionary = choice.get("requires", {}) as Dictionary
		if requires.is_empty() or StoryState.check_requires(requires):
			valid_choices.append(choice)

	if valid_choices.is_empty():
		# Linear — single Continue button
		if not next_id.is_empty():
			var btn := _make_btn("Continue")
			_choice_vbox.add_child(btn)
			btn.pressed.connect(func():
				_navigate(next_id)
			)
	else:
		for choice in valid_choices:
			var label: String  = choice.get("label", "Continue") as String
			var c_next: String = choice.get("next",  "") as String
			var effects        = choice.get("effects", {})
			var result: String = choice.get("result", "") as String
			var result_img: String = choice.get("result_image", "") as String
			var btn := _make_btn(label)
			_choice_vbox.add_child(btn)
			btn.pressed.connect(func():
				StoryState.apply_effects(effects)
				if not result.is_empty():
					_show_result(result, result_img, c_next)
				else:
					_navigate(c_next)
			)


func _show_result(result_text: String, result_image: String, next_id: String) -> void:
	_in_result = true
	_typewriter_active = false
	_revealing_gesture = false
	_clear_choices()

	if not result_image.is_empty() and result_image != _current_image_path:
		_set_image(result_image)

	var name := StoryState.player_name
	_act_label.visible   = false
	_title_label.visible = false
	_rule.visible        = false
	_body_label.text = result_text.replace("{name}", name)
	_body_label.visible_characters = 0
	_fade_text()

	await get_tree().process_frame
	_text_scroll.scroll_vertical = 0

	var btn := _make_btn("Continue")
	_choice_vbox.add_child(btn)
	btn.pressed.connect(func():
		_navigate(next_id)
	)
	_choice_vbox.modulate.a = 0.0
	_typewriter_type    = "choices"
	_typewriter_elapsed = 0.0
	_typewriter_active  = true


func _navigate(next_id: String, allow_chapter_ad: bool = true) -> void:
	if next_id == "_main_menu":
		get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
		return
	if next_id.is_empty():
		return

	# Push current scene to history — skip auto_redirect pass-throughs (player never saw them)
	if not _in_auto_redirect and not StoryState.current_scene_id.is_empty():
		_history.append({
			"scene_id": StoryState.current_scene_id,
			"state":    _entry_state,
		})
		if is_instance_valid(_back_btn):
			_back_btn.disabled = false

	_show_scene(next_id, allow_chapter_ad)


func _set_image(img_path: String) -> void:
	if img_path == _current_image_path:
		return
	_current_image_path = img_path

	if img_path.is_empty() or not ResourceLoader.exists(img_path):
		_image_wrap.visible = false
		return

	_image_rect.texture = load(img_path)
	_image_wrap.visible = true


func _clear_choices() -> void:
	for child in _choice_vbox.get_children():
		# Keep the pressed button in the tree until its input dispatch finishes.
		child.hide()
		child.disabled = true
		child.queue_free()


# ══════════════════════════════════════════════════════════════════════════════
# BUTTON FACTORY
# ══════════════════════════════════════════════════════════════════════════════

func _make_btn(label: String) -> Button:
	var btn := Button.new()
	btn.text = label
	btn.custom_minimum_size = Vector2(0, 50)
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn.focus_mode = Control.FOCUS_ALL
	btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	var normal := StyleBoxFlat.new()
	normal.bg_color     = Color(0.18, 0.235, 0.19, 1.0)
	normal.border_color = Color(0.68, 0.50, 0.20, 0.90)
	normal.set_border_width_all(1)
	normal.border_width_left = 4
	normal.set_corner_radius_all(12)
	normal.content_margin_left   = 14
	normal.content_margin_right  = 14
	normal.content_margin_top    =  8
	normal.content_margin_bottom =  8

	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color     = Color(0.26, 0.32, 0.24, 1.0)
	hover.border_color = Color(0.90, 0.70, 0.30, 1.0)

	var pressed_s := normal.duplicate() as StyleBoxFlat
	pressed_s.bg_color = Color(0.12, 0.17, 0.14, 1.0)

	btn.add_theme_stylebox_override("normal",  normal)
	btn.add_theme_stylebox_override("hover",   hover)
	btn.add_theme_stylebox_override("pressed", pressed_s)
	btn.add_theme_stylebox_override("focus",   normal)
	btn.add_theme_font_size_override("font_size", 15)
	btn.add_theme_color_override("font_color", Color(1.00, 0.92, 0.72))
	preload("res://scripts/ui/choice_motion.gd").attach(btn)
	return btn


# ══════════════════════════════════════════════════════════════════════════════
# REWIND SYSTEM
# ══════════════════════════════════════════════════════════════════════════════

func _snapshot_state(include_checkpoint: bool = true) -> Dictionary:
	var snap := {}
	for prop in StoryState.get_property_list():
		if prop["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE and (include_checkpoint or prop["name"] != "act_checkpoint_state"):
			var value = StoryState.get(prop["name"])
			snap[prop["name"]] = value.duplicate(true) if value is Dictionary or value is Array else value
	return snap


func _restore_state(snapshot: Dictionary) -> void:
	StoryState.restore(snapshot)


func _on_back_pressed() -> void:
	if _history.is_empty():
		return
	_show_fossil_dialog()


func _do_rewind() -> void:
	if _history.is_empty():
		return
	var entry: Dictionary = _history.pop_back()
	var rewinds_remaining := StoryState.free_rewinds_remaining
	_restore_state(entry["state"])
	StoryState.free_rewinds_remaining = rewinds_remaining
	_in_auto_redirect = false
	if is_instance_valid(_back_btn):
		_back_btn.disabled = _history.is_empty()
	_show_scene(entry["scene_id"])


func _go_to_act_checkpoint() -> void:
	if StoryState.act_checkpoint.is_empty() or _act_checkpoint_state.is_empty():
		return
	var checkpoint_id := StoryState.act_checkpoint
	var rewinds_remaining := StoryState.free_rewinds_remaining
	_restore_state(_act_checkpoint_state)
	StoryState.act_checkpoint = checkpoint_id
	StoryState.free_rewinds_remaining = rewinds_remaining
	_history.clear()
	if is_instance_valid(_back_btn):
		_back_btn.disabled = true
	_show_scene(StoryState.act_checkpoint)


func _show_fossil_dialog() -> void:
	var has_free       := StoryState.free_rewinds_remaining > 0
	var has_checkpoint := not StoryState.act_checkpoint.is_empty()

	# Full-screen dark overlay
	var overlay := Panel.new()
	overlay.layout_mode = 1
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	var ov_style := StyleBoxFlat.new()
	ov_style.bg_color = Color(0.0, 0.0, 0.0, 0.72)
	overlay.add_theme_stylebox_override("panel", ov_style)
	add_child(overlay)

	# Dialog panel — 90% wide, centered vertically
	var dialog := Panel.new()
	dialog.layout_mode = 1
	dialog.anchor_left   = 0.05
	dialog.anchor_right  = 0.95
	dialog.anchor_top    = 0.5
	dialog.anchor_bottom = 0.5
	dialog.offset_top    = -180
	dialog.offset_bottom =  180
	var dlg_style := StyleBoxFlat.new()
	dlg_style.bg_color     = Color(0.10, 0.07, 0.03)
	dlg_style.border_color = Color(0.65, 0.48, 0.18, 0.80)
	dlg_style.set_border_width_all(2)
	dlg_style.set_corner_radius_all(14)
	dlg_style.content_margin_left   = 20
	dlg_style.content_margin_right  = 20
	dlg_style.content_margin_top    = 22
	dlg_style.content_margin_bottom = 22
	dialog.add_theme_stylebox_override("panel", dlg_style)
	overlay.add_child(dialog)

	# Content vbox inside dialog
	var vbox := VBoxContainer.new()
	vbox.layout_mode = 1
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.offset_left   = 20
	vbox.offset_right  = -20
	vbox.offset_top    = 22
	vbox.offset_bottom = -22
	vbox.add_theme_constant_override("separation", 10)
	dialog.add_child(vbox)

	var title_lbl := Label.new()
	title_lbl.text = "Time Flows One Way"
	title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_lbl.add_theme_font_size_override("font_size", 16)
	title_lbl.add_theme_color_override("font_color", Color(1.0, 0.88, 0.52))
	vbox.add_child(title_lbl)

	var body_lbl := Label.new()
	body_lbl.text = "Return to your previous choice.\nUse a fossil or choose an optional reward ad."
	body_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	body_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body_lbl.add_theme_font_size_override("font_size", 13)
	body_lbl.add_theme_color_override("font_color", Color(0.78, 0.72, 0.58))
	vbox.add_child(body_lbl)

	var sep := Panel.new()
	sep.custom_minimum_size = Vector2(0, 1)
	sep.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var sep_style := StyleBoxFlat.new()
	sep_style.bg_color = Color(0.65, 0.48, 0.18, 0.30)
	sep.add_theme_stylebox_override("panel", sep_style)
	vbox.add_child(sep)

	# Primary action
	if has_free:
		var fossil_btn := _make_btn(
			"Use Your Fossil  (%d remaining)" % StoryState.free_rewinds_remaining
		)
		vbox.add_child(fossil_btn)
		fossil_btn.pressed.connect(func():
			StoryState.free_rewinds_remaining -= 1
			overlay.queue_free()
			_do_rewind()
		)
	else:
		var ad_btn := _make_btn("Watch Ad: Rewind One Choice")
		vbox.add_child(ad_btn)
		ad_btn.pressed.connect(func():
			overlay.queue_free()
			_show_ad(func(): _do_rewind())
		)

	# Chapter checkpoint (always free)
	if has_checkpoint:
		var cp_btn := _make_btn("Return to Act Start  —  Free")
		cp_btn.add_theme_color_override("font_color", Color(0.70, 0.90, 0.70))
		vbox.add_child(cp_btn)
		cp_btn.pressed.connect(func():
			overlay.queue_free()
			_go_to_act_checkpoint()
		)

	# Cancel
	var cancel_btn := _make_btn("Stay")
	cancel_btn.add_theme_color_override("font_color", Color(0.60, 0.55, 0.45))
	vbox.add_child(cancel_btn)
	cancel_btn.pressed.connect(func(): overlay.queue_free())


func _show_ad(callback: Callable) -> void:
	var history_size := _history.size()
	if not AdManager.show_rewarded(callback, func(status: String):
		if status == "earned" and _history.size() < history_size:
			_reward_notice("Reward received", "Returned to your previous story choice. No fossil was used.")
		elif status == "earned":
			_reward_notice("No rewind available", "There was no previous choice to return to. Story progress did not change.")
		else:
			_reward_notice("No reward received", "The ad could not play. Story progress did not change." if status == "failed" else "The ad ended before a reward was earned. Story progress did not change.")
	):
		_reward_notice("Ad unavailable", "No reward ad is ready. Try again later, or return to the act start for free.")


func _reward_notice(title: String, text: String) -> void:
	var notice := AcceptDialog.new()
	notice.title = title
	notice.dialog_text = text
	add_child(notice)
	notice.confirmed.connect(notice.queue_free)
	notice.canceled.connect(notice.queue_free)
	notice.popup_centered(Vector2i(280, 0))


# ══════════════════════════════════════════════════════════════════════════════
# CALLBACKS
# ══════════════════════════════════════════════════════════════════════════════

func _on_begin_pressed() -> void:
	var entered := _name_entry.text.strip_edges()
	if entered.is_empty():
		entered = "Talon"
	StoryState.player_name = entered
	var scene: Dictionary = StoryData.get_scene(StoryState.current_scene_id)
	var next_id: String   = scene.get("next", "s1_morning") as String
	_navigate(next_id)


func _process(delta: float) -> void:
	if not _typewriter_active:
		return
	_typewriter_elapsed += delta
	var shown := int(_typewriter_elapsed * _TYPEWRITER_CPS)
	if shown >= _body_label.get_total_character_count():
		_finish_typewriter()
	else:
		_body_label.visible_characters = shown


func _fade_text() -> void:
	if _text_tween and _text_tween.is_valid():
		_text_tween.kill()
	_text_scroll.modulate.a = 0.65
	_text_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_text_tween.tween_property(_text_scroll, "modulate:a", 1.0, 0.18)


func _finish_typewriter() -> void:
	if _text_tween and _text_tween.is_valid():
		_text_tween.kill()
	_text_scroll.modulate.a = 1.0
	_typewriter_active = false
	_body_label.visible_characters = -1
	if _typewriter_type == "name_entry":
		_name_entry.visible = true
		_begin_btn.visible  = true
	else:
		_choice_vbox.modulate.a = 1.0


func _input(event: InputEvent) -> void:
	if not is_visible_in_tree() or _settings_panel.visible:
		return
	var is_tap := false
	if event is InputEventScreenTouch and event.pressed:
		is_tap = true
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		is_tap = true
	var pointer: bool = event is InputEventScreenTouch or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT)
	if _revealing_gesture and pointer:
		_revealing_gesture = event.pressed
		get_viewport().set_input_as_handled()
		return

	# Dismiss keyboard when tapping outside the name entry field
	if is_tap and _name_entry.visible and _name_entry.has_focus():
		var tap_pos: Vector2
		if event is InputEventScreenTouch:
			tap_pos = event.position
		else:
			tap_pos = event.position
		if not _name_entry.get_global_rect().has_point(tap_pos):
			_name_entry.release_focus()
			get_viewport().set_input_as_handled()
			return

	if not _typewriter_active:
		return
	if is_tap:
		_revealing_gesture = true
		_finish_typewriter()
		get_viewport().set_input_as_handled()


func _crossfade_music(track_name: String) -> void:
	if track_name == _current_music_track:
		return
	if _music_tween and _music_tween.is_valid():
		_music_tween.kill()
	_current_music_track = track_name
	if _music_player.playing:
		_music_tween = create_tween()
		_music_tween.tween_property(_music_player, "volume_db", -80.0, _MUSIC_FADE_TIME)
		_music_tween.tween_callback(func():
			_music_player.stop()
			if not track_name.is_empty():
				_play_music(track_name)
		)
	elif not track_name.is_empty():
		_play_music(track_name)


func _play_music(track_name: String) -> void:
	var path := "res://assets/audio/story/%s.ogg" % track_name
	if not ResourceLoader.exists(path):
		return
	var stream := load(path) as AudioStreamOggVorbis
	if not stream:
		return
	stream = stream.duplicate() as AudioStreamOggVorbis
	stream.loop = true
	_music_player.stream = stream
	_music_player.volume_db = -60.0
	_music_player.play()
	_music_tween = create_tween()
	_music_tween.tween_property(_music_player, "volume_db", -14.0, _MUSIC_FADE_TIME)


func _exit_tree() -> void:
	if _music_tween and _music_tween.is_valid():
		_music_tween.kill()
	if is_instance_valid(_music_player):
		_music_player.stop()


func _on_menu_pressed() -> void:
	StoryState.save()
	if _music_tween and _music_tween.is_valid():
		_music_tween.kill()
	if _music_player.playing:
		var tween := create_tween()
		tween.tween_property(_music_player, "volume_db", -60.0, 0.5)
		await tween.finished
	if AdManager.show_interstitial():
		await AdManager.interstitial_closed
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")


func _on_settings_pressed() -> void:
	_settings_panel.open(false)
