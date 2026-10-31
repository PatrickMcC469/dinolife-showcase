extends Button

const ART = preload("res://scripts/ui/adventure_theme.gd")

signal card_pressed(action_id: String)

var action_id: String = ""
var max_uses: int = 3

const ICONS := {
	"family": preload("res://assets/ui/action_icons/nest.svg"),
	"home": preload("res://assets/ui/action_icons/nest.svg"),
	"leadership": preload("res://assets/ui/action_icons/alpha.svg"),
	"hunt": preload("res://assets/ui/action_icons/hunt.svg"),
	"scavenge": preload("res://assets/ui/action_icons/bone.svg"),
	"graze": preload("res://assets/ui/action_icons/leaf.svg"),
	"rest": preload("res://assets/ui/action_icons/rest.svg"),
	"territory": preload("res://assets/ui/action_icons/territory.svg"),
	"sharpen": preload("res://assets/ui/action_icons/training.svg"),
	"water": preload("res://assets/ui/action_icons/water.svg"),
	"bond": preload("res://assets/ui/action_icons/group.svg"),
	"tend": preload("res://assets/ui/action_icons/bandage.svg"),
	"nest_tend": preload("res://assets/ui/action_icons/nest.svg"),
	"find_pack": preload("res://assets/ui/action_icons/find_group.svg"),
	"find_herd": preload("res://assets/ui/action_icons/find_group.svg"),
	"find_colony": preload("res://assets/ui/action_icons/find_group.svg"),
	"ad_health": preload("res://assets/ui/action_icons/health.svg"),
	"ad_hunger": preload("res://assets/ui/action_icons/food.svg"),
	"ad_bond": preload("res://assets/ui/action_icons/group.svg"),
	"ad_training": preload("res://assets/ui/action_icons/training.svg"),
	"ad_heal": preload("res://assets/ui/action_icons/bandage.svg"),
}

@onready var action_icon: TextureRect = $HBox/IconWell/Icon
@onready var title_label: Label = $HBox/TextBox/Title
@onready var subtitle_label: Label = $HBox/TextBox/Subtitle
@onready var reward_label: Label = $HBox/TextBox/RewardLabel
@onready var video: TextureRect = $HBox/Video
@onready var arrow: Label = $HBox/Arrow


func _ready() -> void:
	$HBox.minimum_size_changed.connect(_fit_content)
	_apply_style()
	preload("res://scripts/ui/choice_motion.gd").attach(self)


func _fit_content() -> void:
	custom_minimum_size.y = maxf(110 if reward_label.visible else 80, $HBox.get_combined_minimum_size().y + 32)


func _pressed() -> void:
	# ScrollContainer cancels native Button presses when a swipe begins.
	card_pressed.emit(action_id)


func setup(data: Dictionary) -> void:
	action_id = data.get("action_id", "")
	max_uses = data.get("max_uses", 3)
	action_icon.texture = ICONS.get(action_id, ICONS["sharpen"])
	if action_id in ["hunt", "rest", "water"]:
		action_icon.texture = preload("res://scripts/ui/illustrated_icons.gd").texture(action_id)
		action_icon.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	if action_id == "scavenge" and SpeciesDB.get_species(GameState.species_id).get("tree") == "herbivore":
		action_icon.texture = ICONS["graze"]
	elif action_id == "sharpen" and SpeciesDB.get_species(GameState.species_id).get("tree") == "herbivore":
		action_icon.texture = preload("res://assets/ui/action_icons/shield.svg")
	title_label.text = data.get("title", "")
	if action_id == "ad_bond" and SpeciesDB.get_species(GameState.species_id).get("tree") == "herbivore":
		title_label.text = "Boost Herd Bond"
	subtitle_label.text = data.get("subtitle", "")
	var reward_ad := action_id.begins_with("ad_")
	reward_label.visible = reward_ad
	video.visible = reward_ad
	arrow.visible = not reward_ad
	custom_minimum_size.y = 110 if reward_ad else 80
	accessibility_name = ("Optional reward ad. " if reward_ad else "") + title_label.text + ". " + subtitle_label.text
	_apply_style(reward_ad)
	refresh_state()


func refresh_state() -> void:
	disabled = GameState.get_action_uses(action_id) >= max_uses


func _apply_style(reward_ad: bool = false) -> void:
	ART.button(self, reward_ad, false)
	title_label.add_theme_font_size_override("font_size", 16)
	title_label.add_theme_color_override("font_color", ART.INK)
	subtitle_label.add_theme_font_size_override("font_size", 12)
	subtitle_label.add_theme_color_override("font_color", ART.MUTED_INK)
