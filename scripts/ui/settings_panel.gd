extends Control

@onready var card: PanelContainer  = $Card
@onready var vol_slider: HSlider   = $Card/Scroll/VBox/Margin/InnerVBox/VolumeSection/VolumeRow/VolumeSlider
@onready var vol_pct: Label        = $Card/Scroll/VBox/Margin/InnerVBox/VolumeSection/VolumeRow/VolumePct
@onready var back_btn: Button      = $Card/Scroll/VBox/Margin/InnerVBox/BackBtn
@onready var save_exit_btn: Button = $Card/Scroll/VBox/Margin/InnerVBox/SaveExitBtn
@onready var quit_run_btn: Button  = $Card/Scroll/VBox/Margin/InnerVBox/QuitRunBtn
@onready var _inner_vbox: VBoxContainer = $Card/Scroll/VBox/Margin/InnerVBox
@onready var atmosphere_toggle: CheckButton = $Card/Scroll/VBox/Margin/InnerVBox/AtmosphereRow/Toggle

var _reward_toggle: CheckButton = null
var animations_toggle: CheckButton = null
var vibration_toggle: CheckButton
var tension_toggle: CheckButton

signal closed


func _ready() -> void:
	var width := minf(360.0, get_viewport_rect().size.x - 24.0)
	card.offset_left = -width / 2.0
	card.offset_right = width / 2.0
	if OS.get_name() == "iOS":
		var safe := DisplayServer.get_display_safe_area()
		var window := DisplayServer.window_get_size()
		var scale := get_viewport_rect().size.y / maxf(1.0, window.y)
		card.offset_top = maxf(48.0, safe.position.y * scale + 8.0)
		card.offset_bottom = -maxf(40.0, (window.y - safe.end.y) * scale + 8.0)
	vol_slider.value_changed.connect(_on_volume)
	back_btn.pressed.connect(_on_back)
	save_exit_btn.pressed.connect(_on_save_exit)
	quit_run_btn.pressed.connect(_on_quit_run)
	_build_reward_toggle()
	_build_animations_toggle()
	vibration_toggle = _build_feedback_toggle("Vibration feedback", SettingsManager.vibration_enabled, SettingsManager.set_vibration_enabled)
	tension_toggle = _build_feedback_toggle("Tension audio", SettingsManager.tension_audio_enabled, SettingsManager.set_tension_audio_enabled)
	atmosphere_toggle.toggled.connect(SettingsManager.set_atmosphere_enabled)


func _build_reward_toggle() -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)

	var lbl := Label.new()
	lbl.text = "Offer reward videos"
	lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lbl.add_theme_font_size_override("font_size", 17)
	row.add_child(lbl)

	_reward_toggle = CheckButton.new()
	_reward_toggle.button_pressed = SettingsManager.reward_videos_enabled
	atmosphere_toggle.set_pressed_no_signal(SettingsManager.atmosphere_enabled)
	_reward_toggle.toggled.connect(func(on: bool): SettingsManager.set_reward_videos_enabled(on))
	row.add_child(_reward_toggle)

	_inner_vbox.add_child(row)
	_inner_vbox.move_child(row, back_btn.get_index())


func _build_animations_toggle() -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	var label := Label.new()
	label.text = "Interface animations"
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", 17)
	row.add_child(label)
	animations_toggle = CheckButton.new()
	animations_toggle.custom_minimum_size = Vector2(48, 44)
	animations_toggle.accessibility_name = "Interface animations"
	animations_toggle.set_pressed_no_signal(SettingsManager.interface_animations_enabled)
	animations_toggle.toggled.connect(SettingsManager.set_interface_animations_enabled)
	row.add_child(animations_toggle)
	_inner_vbox.add_child(row)
	_inner_vbox.move_child(row, atmosphere_toggle.get_parent().get_index() + 1)


func open(in_game: bool = false) -> void:
	_apply_card_style()
	vol_slider.value = SettingsManager.master_volume
	vol_pct.text = "%d%%" % int(SettingsManager.master_volume * 100)
	_reward_toggle.button_pressed = SettingsManager.reward_videos_enabled
	atmosphere_toggle.set_pressed_no_signal(SettingsManager.atmosphere_enabled)
	save_exit_btn.visible = in_game
	animations_toggle.set_pressed_no_signal(SettingsManager.interface_animations_enabled)
	vibration_toggle.set_pressed_no_signal(SettingsManager.vibration_enabled)
	tension_toggle.set_pressed_no_signal(SettingsManager.tension_audio_enabled)
	quit_run_btn.visible  = in_game
	visible = true


func _build_feedback_toggle(text: String, enabled: bool, setter: Callable) -> CheckButton:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", 17)
	row.add_child(label)
	var toggle := CheckButton.new()
	toggle.custom_minimum_size = Vector2(48, 44)
	toggle.accessibility_name = text
	toggle.set_pressed_no_signal(enabled)
	toggle.toggled.connect(setter)
	row.add_child(toggle)
	_inner_vbox.add_child(row)
	_inner_vbox.move_child(row, back_btn.get_index())
	return toggle


func _apply_card_style() -> void:
	var bg := StyleBoxFlat.new()
	bg.bg_color = Color(0.10, 0.07, 0.03, 0.97)
	bg.set_corner_radius_all(14)
	bg.set_border_width_all(2)
	bg.border_color = Color(0.75, 0.55, 0.22, 0.80)
	card.add_theme_stylebox_override("panel", bg)

	for child in _get_all_labels(card):
		child.add_theme_color_override("font_color", Color(0.95, 0.90, 0.75))

	_style_back_btn()
	_style_save_exit_btn()
	_style_quit_run_btn()


func _style_back_btn() -> void:
	var s := StyleBoxFlat.new()
	s.bg_color = Color(0.08, 0.05, 0.02, 0.82)
	s.set_corner_radius_all(10)
	s.set_border_width_all(2)
	s.border_color = Color(0.75, 0.55, 0.22, 0.90)
	back_btn.add_theme_stylebox_override("normal", s)
	back_btn.add_theme_stylebox_override("hover", s)
	back_btn.add_theme_color_override("font_color", Color(0.97, 0.93, 0.80))
	back_btn.add_theme_font_size_override("font_size", 18)


func _get_all_labels(node: Node) -> Array:
	var result: Array = []
	for child in node.get_children():
		if child is Label:
			result.append(child)
		result.append_array(_get_all_labels(child))
	return result


func _on_volume(value: float) -> void:
	SettingsManager.set_master_volume(value)
	vol_pct.text = "%d%%" % int(value * 100)


func _style_save_exit_btn() -> void:
	var s := StyleBoxFlat.new()
	s.bg_color = Color(0.08, 0.05, 0.02, 0.82)
	s.set_corner_radius_all(10)
	s.set_border_width_all(2)
	s.border_color = Color(0.75, 0.55, 0.22, 0.90)
	save_exit_btn.add_theme_stylebox_override("normal", s)
	save_exit_btn.add_theme_stylebox_override("hover", s)
	save_exit_btn.add_theme_color_override("font_color", Color(0.97, 0.93, 0.80))
	save_exit_btn.add_theme_font_size_override("font_size", 18)


func _style_quit_run_btn() -> void:
	var s := StyleBoxFlat.new()
	s.bg_color = Color(0.20, 0.04, 0.02, 0.90)
	s.set_corner_radius_all(10)
	s.set_border_width_all(2)
	s.border_color = Color(0.80, 0.28, 0.18, 0.90)
	quit_run_btn.add_theme_stylebox_override("normal", s)
	quit_run_btn.add_theme_stylebox_override("hover", s)
	quit_run_btn.add_theme_color_override("font_color", Color(1.0, 0.60, 0.50))
	quit_run_btn.add_theme_font_size_override("font_size", 18)


func _on_back() -> void:
	visible = false
	closed.emit()


func _on_save_exit() -> void:
	GameState.save_run()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")


func _on_quit_run() -> void:
	GameState.delete_save()
	get_tree().change_scene_to_file("res://scenes/ui/character_select.tscn")
