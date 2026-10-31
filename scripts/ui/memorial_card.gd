extends PanelContainer

const LIFE_STORY = preload("res://scripts/systems/life_story.gd")
const ART_STAGES = ["hatchling", "juvenile", "sub_adult", "adult", "elder"]

@onready var portrait: TextureRect = $Content/Portrait
@onready var title_label: Label = $Content/Title
@onready var species_label: Label = $Content/Species
@onready var life_label: Label = $Content/Life
@onready var moments: VBoxContainer = $Content/Moments
@onready var ending_label: Label = $Content/Ending
@onready var copy_button: Button = $Content/CopyButton

var _record: Dictionary = {}


func _ready() -> void:
	copy_button.pressed.connect(_copy_story)


func show_record(record: Dictionary) -> void:
	_record = record.duplicate(true)
	var memorial := LIFE_STORY.memorial_for(_record)
	var stage := clampi(int(record.get("life_stage", record.get("max_stage_reached", 0))), 0, 4)
	title_label.text = "The " + str(memorial["title"])
	species_label.text = str(record.get("display_name", "Dinosaur"))
	life_label.text = "%s · %d seasons" % [LIFE_STORY.STAGES[stage], int(record.get("seasons", 0))]
	ending_label.text = str(memorial["ending"])
	for i in moments.get_child_count():
		var label: Label = moments.get_child(i)
		label.visible = i < memorial["moments"].size()
		label.text = "• " + str(memorial["moments"][i]) if label.visible else ""
	var species_id: String = record.get("species_id", "")
	var art := "res://assets/dinos/%s_%s.png" % [species_id, ART_STAGES[stage]]
	if not ResourceLoader.exists(art):
		art = "res://assets/dinos/%s_adult.png" % species_id
	portrait.texture = load(art) if ResourceLoader.exists(art) else null
	portrait.visible = portrait.texture != null
	copy_button.text = "Copy to share"


func _copy_story() -> void:
	DisplayServer.clipboard_set(LIFE_STORY.share_text(_record))
	copy_button.text = "Copied — ready to share"
