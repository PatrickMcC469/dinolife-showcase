extends Control

signal finished

const DURATION := 6.5
const FOREST = preload("res://assets/cinematic/nest_forest.png")
const STEPS = preload("res://assets/cinematic/hatchling_steps.png")
const PREDATOR = preload("res://assets/cinematic/predator_lunge.png")
const FERNS = preload("res://assets/cinematic/foreground_ferns.png")

var elapsed := 0.0
var _done := false
var _forest: TextureRect
var _baby: TextureRect
var _predator: TextureRect
var _ferns: TextureRect
var _shade: ColorRect
var _title: Label
var _skip: Button
var _roar: AudioStreamPlayer
var _frames: Array[AtlasTexture] = []
var _roared := false
var _safe_bottom := 48.0


func _ready() -> void:
	clip_contents = true
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	if OS.get_name() in ["iOS", "Android"]:
		var safe := DisplayServer.get_display_safe_area()
		var window_height := float(DisplayServer.window_get_size().y)
		var scale := size.y / window_height if window_height > 0.0 else 1.0
		_safe_bottom = maxf(48.0, (window_height - safe.end.y) * scale + 12.0)
	_forest = _picture(FOREST)
	_forest.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	for i in range(2):
		var frame := AtlasTexture.new()
		frame.atlas = STEPS
		var side := STEPS.get_width() / 2.0
		frame.region = Rect2(i * side, 0, side, STEPS.get_height())
		_frames.append(frame)
	_baby = _picture(_frames[0])
	_predator = _picture(PREDATOR)
	_ferns = _picture(FERNS)
	_shade = ColorRect.new()
	_shade.color = Color(0.025, 0.035, 0.02)
	_shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_shade)
	_title = Label.new()
	_title.text = "How many seasons\ncan you survive?"
	_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_title.add_theme_color_override("font_color", Color(0.98, 0.9, 0.69))
	_title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_title)
	_skip = Button.new()
	_skip.text = "Skip  ›"
	_skip.add_theme_font_size_override("font_size", 16)
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.035, 0.055, 0.025, 0.85)
	style.border_color = Color(0.73, 0.68, 0.43, 0.65)
	style.set_border_width_all(1)
	style.set_corner_radius_all(12)
	_skip.add_theme_stylebox_override("normal", style)
	_skip.add_theme_stylebox_override("hover", style)
	_skip.add_theme_stylebox_override("pressed", style)
	var focus := StyleBoxFlat.new()
	focus.bg_color = Color.TRANSPARENT
	focus.border_color = Color(0.88, 0.79, 0.49, 0.9)
	focus.set_border_width_all(2)
	focus.set_corner_radius_all(12)
	_skip.add_theme_stylebox_override("focus", focus)
	_skip.add_theme_color_override("font_color", Color(1, 0.95, 0.82))
	_skip.pressed.connect(_finish)
	add_child(_skip)
	_skip.grab_focus()
	_roar = AudioStreamPlayer.new()
	_roar.stream = preload("res://assets/audio/raptor_roar.ogg")
	_roar.volume_db = -14.0
	add_child(_roar)
	# Atmosphere off also avoids the opening's sudden predator movement.
	if not SettingsManager.atmosphere_enabled:
		_finish.call_deferred()
	_pose()


func _picture(texture: Texture2D) -> TextureRect:
	var picture := TextureRect.new()
	picture.texture = texture
	picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	picture.stretch_mode = TextureRect.STRETCH_SCALE
	picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(picture)
	return picture


func _process(delta: float) -> void:
	if _done:
		return
	elapsed += delta
	_pose()
	if elapsed >= 3.38 and not _roared:
		_roared = true
		_roar.play()
	if elapsed >= DURATION:
		_finish()


func _pose() -> void:
	var w := size.x
	var h := size.y
	# Slight camera drift, two walking poses, a stumble, then a cautious pause.
	_forest.position = Vector2(-w * 0.025, -h * 0.015)
	_forest.size = size * 1.05
	_forest.position.x -= minf(elapsed, 3.8) * w * 0.003
	var walk := clampf(elapsed / 2.4, 0.0, 1.0)
	var stumble := sin(clampf((elapsed - 1.05) / 0.5, 0.0, 1.0) * PI)
	var bob := absf(sin(elapsed * 11.0)) * w * 0.009 if elapsed < 2.4 else 0.0
	_baby.size = Vector2.ONE * w * 0.45
	_baby.pivot_offset = _baby.size * Vector2(0.5, 0.78)
	_baby.position = Vector2(lerpf(-0.06, 0.20, walk) * w, h * 0.78 - w * 0.45 * 0.79 - bob + stumble * w * 0.025)
	_baby.rotation = stumble * 0.15
	_baby.texture = _frames[int(elapsed * 6.0) % 2] if elapsed < 2.4 else _frames[0]
	var rustle := sin(elapsed * 39.0) * sin(clampf((elapsed - 2.45) / 0.9, 0.0, 1.0) * PI)
	_ferns.size = Vector2.ONE * w * 0.68
	_ferns.position = Vector2(w * 0.56 + rustle * w * 0.012, h * 0.68)
	_ferns.pivot_offset = _ferns.size * Vector2(0.5, 0.9)
	_ferns.rotation = rustle * 0.035
	var leap := clampf((elapsed - 3.38) / 0.45, 0.0, 1.0)
	_predator.size = Vector2(w * 1.18, w * 1.18 * 2.0 / 3.0)
	_predator.position = Vector2(lerpf(1.1, 0.63, leap * leap) * w, h * 0.58 - sin(leap * PI * 0.5) * h * 0.045)
	_predator.visible = elapsed >= 3.38 and elapsed < 3.83
	_shade.size = size
	_shade.modulate.a = 1.0 if elapsed >= 3.83 else clampf(1.0 - elapsed / 0.35, 0.0, 1.0)
	_title.size = Vector2(w * 0.88, h * 0.3)
	_title.position = Vector2(w * 0.06, h * 0.35)
	_title.add_theme_font_size_override("font_size", int(clampf(w * 0.075, 24.0, 42.0)))
	_title.modulate.a = clampf((elapsed - 3.83) / 0.20, 0.0, 1.0)
	_skip.size = Vector2(94, 48)
	_skip.position = Vector2(w - 114, h - _safe_bottom - 48)


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		_finish()


func _finish() -> void:
	if _done:
		return
	_done = true
	_roar.stop()
	_skip.disabled = true
	finished.emit()


func _exit_tree() -> void:
	_done = true
