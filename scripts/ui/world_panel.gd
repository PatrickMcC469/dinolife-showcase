extends PanelContainer

const WORLD = preload("res://scripts/systems/world_conditions.gd")
const JOURNEYS = preload("res://scripts/systems/journeys.gd")

@onready var summary: Label = $Content/Summary
@onready var heading: Label = $Content/Header/Heading
@onready var details: Label = $Content/Details
@onready var button: Button = $Content/Header/DetailsButton


func _ready() -> void:
	button.pressed.connect(_toggle)
	TurnManager.turn_started.connect(refresh)
	TurnManager.stat_changed.connect(refresh)
	refresh()


func _toggle() -> void:
	details.visible = not details.visible
	button.text = "Close" if details.visible else "Details"
	refresh()


func refresh() -> void:
	var active_story: bool = not GameState.journey_state.is_empty() and GameState.journey_state.get("phase", 3) < 3
	var reward_active: bool = GameState.seasons_elapsed < int(GameState.journey_state.get("reward_until", -1))
	var discovery: String = preload("res://scripts/systems/discoveries.gd").summary()
	visible = GameState.life_stage > 0 and (not WORLD.kind().is_empty() or active_story or reward_active or not discovery.is_empty() or not GameState.living_state.get("site", "").is_empty())
	heading.text = "ENVIRONMENT\n" + WORLD.summary().replace(" remaining", "")
	summary.text = ""
	if not GameState.journey_state.is_empty() and GameState.journey_state.get("phase", 3) < 3:
		summary.text += "\n" + {"migration": "Migration underway", "territory": "Range dispute underway", "personal": "A new feeding ground awaits"}.get(GameState.journey_state["kind"], "Journey underway")
	elif GameState.seasons_elapsed < int(GameState.journey_state.get("reward_until", -1)):
		summary.text += "\nA settled range helps you feed."
	details.text = WORLD.detail()
	summary.text += "\n" + preload("res://scripts/systems/living_world.gd").summary()
	summary.text = summary.text.strip_edges()
	summary.visible = details.visible and not summary.text.is_empty()
	details.text += "\n\n" + preload("res://scripts/systems/living_world.gd").detail()
	if not discovery.is_empty():
		details.text += "\n\n" + discovery
	var story := JOURNEYS.summary()
	if not story.is_empty():
		details.text += "\n\n" + story
		if GameState.seasons_elapsed < int(GameState.journey_state.get("reward_until", -1)):
			details.text += "\nYour story bonus improves feeding chances" + (" and territory claims." if GameState.journey_state["kind"] == "territory" else ".")
