extends Control

signal done

@onready var stage_label: Label          = $Card/VBox/StageLabel
@onready var title_label: Label          = $Card/VBox/TitleLabel
@onready var divider: HSeparator         = $Card/VBox/Divider
@onready var body_label: Label           = $Card/VBox/Scroll/BodyLabel
@onready var choices_box: VBoxContainer  = $Card/VBox/ChoicesBox

var _ageup_data: Dictionary = {}


# Returns false if there is no data for this stage (caller should skip showing)
func setup(stage: int) -> bool:
	var sid := GameState.species_id
	var script_path := "res://scripts/dinos/%s/dino_ageup.gd" % sid

	if ResourceLoader.exists(script_path):
		var AgeupScript: GDScript = load(script_path)
		var node: Object = AgeupScript.new()
		_ageup_data = node.get_ageup(stage)

	if _ageup_data.is_empty():
		return false

	_apply_style()
	_populate()
	return true


func _populate() -> void:
	stage_label.text = _ageup_data.get("stage_label", "")
	title_label.text  = _ageup_data.get("title", "")
	body_label.text   = _ageup_data.get("body", "")

	for choice in _ageup_data.get("choices", []) as Array:
		var btn := Button.new()
		btn.text          = choice.get("label", "")
		btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		if choice.get("best", false):
			_style_best_btn(btn)
		else:
			_style_alt_btn(btn)
		choices_box.add_child(btn)
		btn.pressed.connect(func(): done.emit())


func _apply_style() -> void:
	var dim := $DimBg as ColorRect
	dim.color = Color(0, 0, 0, 0.80)

	var card := $Card as Panel
	var ps := StyleBoxFlat.new()
	ps.bg_color     = Color(0.10, 0.06, 0.02, 0.98)
	ps.border_color = Color(0.75, 0.52, 0.18, 0.90)
	ps.set_corner_radius_all(16)
	ps.set_border_width_all(2)
	ps.shadow_color = Color(0, 0, 0, 0.45)
	ps.shadow_size  = 12
	card.add_theme_stylebox_override("panel", ps)

	stage_label.add_theme_color_override("font_color",    Color(0.75, 0.60, 0.30))
	stage_label.add_theme_font_size_override("font_size", 11)

	title_label.add_theme_color_override("font_color",    Color(1.0, 0.88, 0.52))
	title_label.add_theme_font_size_override("font_size", 20)

	body_label.add_theme_color_override("font_color",    Color(0.88, 0.80, 0.65))
	body_label.add_theme_font_size_override("font_size", 13)


func _style_best_btn(btn: Button) -> void:
	var s := StyleBoxFlat.new()
	s.bg_color     = Color(0.48, 0.30, 0.06, 0.95)
	s.border_color = Color(0.90, 0.68, 0.25, 1.0)
	s.set_corner_radius_all(10)
	s.set_border_width_all(2)
	s.content_margin_left   = 12
	s.content_margin_right  = 12
	s.content_margin_top    = 12
	s.content_margin_bottom = 12
	var h := s.duplicate() as StyleBoxFlat
	h.bg_color     = Color(0.60, 0.40, 0.10, 0.98)
	h.border_color = Color(1.0, 0.82, 0.35, 1.0)
	btn.add_theme_stylebox_override("normal",  s)
	btn.add_theme_stylebox_override("hover",   h)
	btn.add_theme_stylebox_override("pressed", h)
	btn.add_theme_color_override("font_color",    Color(1.0, 0.95, 0.72))
	btn.add_theme_font_size_override("font_size", 14)


func _style_alt_btn(btn: Button) -> void:
	var s := StyleBoxFlat.new()
	s.bg_color     = Color(0.18, 0.12, 0.04, 0.85)
	s.border_color = Color(0.50, 0.38, 0.14, 0.60)
	s.set_corner_radius_all(8)
	s.set_border_width_all(1)
	s.content_margin_left   = 12
	s.content_margin_right  = 12
	s.content_margin_top    = 10
	s.content_margin_bottom = 10
	var h := s.duplicate() as StyleBoxFlat
	h.bg_color     = Color(0.26, 0.18, 0.06, 0.90)
	h.border_color = Color(0.68, 0.52, 0.20, 0.80)
	btn.add_theme_stylebox_override("normal",  s)
	btn.add_theme_stylebox_override("hover",   h)
	btn.add_theme_stylebox_override("pressed", h)
	btn.add_theme_color_override("font_color",    Color(0.82, 0.74, 0.55))
	btn.add_theme_font_size_override("font_size", 13)
