extends Control

signal intro_done

@onready var dim_bg: ColorRect            = $DimBg
@onready var card: Panel                  = $Card
@onready var title_label: Label           = $Card/VBox/TitleLabel
@onready var flavor_label: Label          = $Card/VBox/FlavorLabel
@onready var choices_box: VBoxContainer   = $Card/VBox/ChoicesBox
@onready var result_label: Label          = $Card/VBox/ResultLabel
@onready var continue_btn: Button         = $Card/VBox/ContinueBtn

var _pending_stat: String = ""
var _dino_start_ref: Object = null


func _ready() -> void:
	_apply_style()
	_load_and_show()


func _load_and_show() -> void:
	result_label.hide()
	continue_btn.hide()
	continue_btn.pressed.connect(_on_continue)

	var sid := GameState.species_id
	var script_path := "res://scripts/dinos/%s/dino_start.gd" % sid

	if not ResourceLoader.exists(script_path):
		intro_done.emit()
		return

	var DStart: GDScript = load(script_path)
	_dino_start_ref = DStart.new()

	var events: Array = _dino_start_ref.get_eligible_events()
	if events.is_empty():
		_dino_start_ref = null
		intro_done.emit()
		return

	var event: Dictionary = events[randi() % events.size()]
	title_label.text  = event.get("title", "")
	flavor_label.text = event.get("flavor", "")

	for choice in event.get("choices", []) as Array:
		var btn := Button.new()
		btn.text          = choice.get("label", "")
		btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		_style_choice_btn(btn)
		choices_box.add_child(btn)
		var stat: String   = choice.get("stat", "")
		var result: String = choice.get("result", "")
		btn.pressed.connect(func(): _on_choice(stat, result))


func _on_choice(stat: String, result: String) -> void:
	_pending_stat = stat
	choices_box.hide()
	result_label.text = result
	result_label.show()
	continue_btn.show()


func _on_continue() -> void:
	if _pending_stat != "" and _dino_start_ref != null:
		_dino_start_ref.apply_boost(_pending_stat)
	_dino_start_ref = null
	intro_done.emit()


func _apply_style() -> void:
	dim_bg.color = Color(0, 0, 0, 0.75)

	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0.10, 0.06, 0.02, 0.97)
	panel_style.set_corner_radius_all(16)
	panel_style.set_border_width_all(2)
	panel_style.border_color = Color(0.72, 0.50, 0.18, 0.90)
	panel_style.shadow_color = Color(0, 0, 0, 0.40)
	panel_style.shadow_size  = 10
	card.add_theme_stylebox_override("panel", panel_style)

	title_label.add_theme_color_override("font_color",    Color(1.0, 0.88, 0.52))
	title_label.add_theme_font_size_override("font_size", 18)

	flavor_label.add_theme_color_override("font_color",    Color(0.88, 0.80, 0.65))
	flavor_label.add_theme_font_size_override("font_size", 13)

	result_label.add_theme_color_override("font_color",    Color(0.78, 0.92, 0.68))
	result_label.add_theme_font_size_override("font_size", 13)

	_style_continue_btn()


func _style_choice_btn(btn: Button) -> void:
	var s := StyleBoxFlat.new()
	s.bg_color     = Color(0.20, 0.13, 0.05, 0.90)
	s.border_color = Color(0.55, 0.40, 0.16, 0.70)
	s.set_corner_radius_all(8)
	s.set_border_width_all(1)
	s.content_margin_left   = 12
	s.content_margin_right  = 12
	s.content_margin_top    = 10
	s.content_margin_bottom = 10

	var h := s.duplicate() as StyleBoxFlat
	h.bg_color     = Color(0.30, 0.20, 0.07, 0.95)
	h.border_color = Color(0.78, 0.58, 0.25, 0.90)

	btn.add_theme_stylebox_override("normal",  s)
	btn.add_theme_stylebox_override("hover",   h)
	btn.add_theme_stylebox_override("pressed", h)
	btn.add_theme_color_override("font_color",       Color(0.95, 0.88, 0.70))
	btn.add_theme_font_size_override("font_size",    13)


func _style_continue_btn() -> void:
	var s := StyleBoxFlat.new()
	s.bg_color     = Color(0.55, 0.35, 0.08, 0.95)
	s.border_color = Color(0.85, 0.65, 0.25, 1.0)
	s.set_corner_radius_all(10)
	s.set_border_width_all(2)
	s.content_margin_top    = 12
	s.content_margin_bottom = 12

	var h := s.duplicate() as StyleBoxFlat
	h.bg_color = Color(0.68, 0.45, 0.12, 0.98)

	continue_btn.add_theme_stylebox_override("normal",  s)
	continue_btn.add_theme_stylebox_override("hover",   h)
	continue_btn.add_theme_stylebox_override("pressed", h)
	continue_btn.add_theme_color_override("font_color",    Color(1.0, 0.95, 0.75))
	continue_btn.add_theme_font_size_override("font_size", 14)
	continue_btn.text = "Begin Your Journey"
