extends VBoxContainer

@onready var milestone: Label = $Milestone
@onready var gains: Label = $Gains
@onready var costs: Label = $Costs
@onready var cue: AudioStreamPlayer = $Cue
@onready var reveal_card: PanelContainer = $RevealCard
@onready var reveal_image: TextureRect = $RevealCard/Row/Portrait
@onready var reveal_title: Label = $RevealCard/Row/Text/Title
var _last_serial: int = -1
var _reveal_tween: Tween

const CUES = {
	"reward": preload("res://assets/audio/feedback_reward.wav"),
	"setback": preload("res://assets/audio/feedback_setback.wav"),
	"mixed": preload("res://assets/audio/feedback_choice.wav"),
}


func _ready() -> void:
	SettingsManager.interface_animations_changed.connect(_on_setting)
	visibility_changed.connect(finish_animation)


func show_result(value: Variant, reveal: Variant = null) -> void:
	finish_animation()
	reveal_card.hide()
	visible = value is Dictionary and not value.is_empty()
	if not visible:
		return
	var data: Dictionary = value
	for pair in [[milestone, "milestones"], [gains, "gains"], [costs, "costs"]]:
		var label: Label = pair[0]
		var entries: Array = data.get(pair[1], []) if data.get(pair[1]) is Array else []
		label.text = " · ".join(entries)
		label.visible = not label.text.is_empty()
	if reveal is Dictionary and reveal.get("species") in UnlockManager.PLAYABLE_SPECIES and reveal.get("title") is String:
		reveal_image.texture = load("res://assets/character_selection/%s_selection.png" % reveal["species"])
		reveal_title.text = reveal["title"]
		reveal_card.show()
		reveal_card.accessibility_name = "Discovery recorded. " + reveal["title"] + ". Feeding chance increases by 2.5 percentage points this season and the next two."
	var serial = data.get("serial", -1)
	if not (serial is int or serial is float) or int(serial) == _last_serial:
		return
	_last_serial = int(serial)
	if not data.get("milestones", []).is_empty(): SoundManager.pulse_haptic()
	if data.get("tone") in CUES:
		cue.stream = CUES[data["tone"]]
		cue.play()
	if reveal_card.visible and SettingsManager.interface_animations_enabled:
		reveal_image.material.set_shader_parameter("progress", 0.0)
		_reveal_tween = create_tween()
		_reveal_tween.tween_method(func(amount: float): reveal_image.material.set_shader_parameter("progress", amount), 0.0, 1.0, 0.32).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func finish_animation() -> void:
	if _reveal_tween != null: _reveal_tween.kill()
	if is_instance_valid(reveal_image): reveal_image.material.set_shader_parameter("progress", 1.0)


func _on_setting(_enabled: bool) -> void:
	finish_animation()


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_PAUSED and is_instance_valid(cue):
		cue.stop()
		finish_animation()
