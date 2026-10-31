extends Node

# Animate only the card's ink/paper tint, never its layout or touch bounds.
var _tween: Tween
@onready var button: Button = get_parent()


static func attach(target: Button) -> void:
	var motion := new()
	motion.name = "ChoiceMotion"
	target.add_child(motion)


func _ready() -> void:
	button.button_down.connect(_press)
	button.button_up.connect(_release)
	button.mouse_exited.connect(_release)
	button.visibility_changed.connect(_reset)
	SettingsManager.interface_animations_changed.connect(_on_setting)


func _press() -> void:
	if not button.disabled and SettingsManager.interface_animations_enabled:
		_animate(Color(0.90, 0.88, 0.81), 0.06)


func _release() -> void:
	if SettingsManager.interface_animations_enabled and button.is_visible_in_tree():
		_animate(Color.WHITE, 0.12)
	else:
		_reset()


func _animate(color: Color, duration: float) -> void:
	if _tween != null: _tween.kill()
	_tween = create_tween()
	_tween.tween_property(button, "self_modulate", color, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func _reset() -> void:
	if _tween != null: _tween.kill()
	button.self_modulate = Color.WHITE


func _on_setting(_enabled: bool) -> void:
	_reset()


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_PAUSED:
		_reset()
