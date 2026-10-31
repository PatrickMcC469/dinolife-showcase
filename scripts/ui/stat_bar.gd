extends ProgressBar

# Earthy red (empty) → amber → leaf green (full).
# Labels are supplied by the gameplay dashboard.

var _fill_style: StyleBoxFlat
var _bg_style: StyleBoxFlat
var _change_tween: Tween
var _initialized: bool = false


func _ready() -> void:
	show_percentage = false
	_fill_style = StyleBoxFlat.new()
	_fill_style.corner_radius_top_left = 6
	_fill_style.corner_radius_top_right = 6
	_fill_style.corner_radius_bottom_left = 6
	_fill_style.corner_radius_bottom_right = 6
	_bg_style = StyleBoxFlat.new()
	_bg_style.bg_color = Color(0.2, 0.2, 0.2, 1.0)
	_bg_style.corner_radius_top_left = 6
	_bg_style.corner_radius_top_right = 6
	_bg_style.corner_radius_bottom_left = 6
	_bg_style.corner_radius_bottom_right = 6
	add_theme_stylebox_override("fill", _fill_style)
	add_theme_stylebox_override("background", _bg_style)
	_update_color()
	SettingsManager.interface_animations_changed.connect(_on_motion_setting)


func set_value_normalized(v: float) -> void:
	var previous := value
	value = clampf(v, 0.0, 1.0)
	_update_color()
	if _initialized and SettingsManager.interface_animations_enabled and absf(value - previous) >= 0.005:
		if _change_tween != null: _change_tween.kill()
		modulate = Color(0.75, 1.0, 0.8) if value > previous else Color(1.0, 0.8, 0.65)
		_change_tween = create_tween()
		_change_tween.tween_property(self, "modulate", Color.WHITE, 0.4)
	_initialized = true


func _on_motion_setting(_enabled: bool) -> void:
	if _change_tween != null: _change_tween.kill()
	modulate = Color.WHITE


func _update_color() -> void:
	if _fill_style == null:
		return
	var v = float(value)
	var col: Color
	if v < 0.5:
		col = Color(0.76, 0.30, 0.22).lerp(Color(0.90, 0.67, 0.27), v * 2.0)
	else:
		col = Color(0.90, 0.67, 0.27).lerp(Color(0.38, 0.60, 0.28), (v - 0.5) * 2.0)
	_fill_style.bg_color = col
