extends Button

const ART = preload("res://scripts/ui/adventure_theme.gd")
@onready var content: MarginContainer = $Content
@onready var portrait: TextureRect = $Content/Column/Row/Picture/Portrait
@onready var season_label: Label = $Content/Column/Row/Text/Season
@onready var summary: Label = $Content/Column/Row/Text/Summary
@onready var hint: Label = $Content/Column/Row/Text/Hint
@onready var detail: Label = $Content/Column/Detail
var expanded: bool = false


func _ready() -> void:
	ART.button(self, false, false)
	pressed.connect(_toggle)
	content.minimum_size_changed.connect(_fit)
	preload("res://scripts/ui/choice_motion.gd").attach(self)
	_fit()


func setup(memory: Dictionary) -> void:
	season_label.text = ("Season %d" % (int(memory["season"]) + 1) if memory["season"] >= 0 else "Earlier memory") + " · " + memory["category"]
	detail.text = memory["text"]
	summary.text = memory["text"].replace("\n", " ")
	portrait.texture = load(memory["image"])
	accessibility_name = season_label.text + ". " + memory["text"] + ". Tap to expand or collapse."
	_fit()


func _toggle() -> void:
	expanded = not expanded
	detail.visible = expanded
	summary.visible = not expanded
	hint.text = "Less ▴" if expanded else "Read memory ▾"
	_fit()


func _fit() -> void:
	custom_minimum_size.y = content.get_combined_minimum_size().y
