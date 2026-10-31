extends Control

signal closed
const ART = preload("res://scripts/ui/adventure_theme.gd")
const CATEGORIES = ["All memories", "Family", "Pack", "Home", "Journeys", "Discoveries", "Milestones", "Encounters"]
@onready var panel: PanelContainer = $Card
@onready var subtitle: Label = $Card/Content/Subtitle
@onready var filter: OptionButton = $Card/Content/Filter
@onready var scroll: ScrollContainer = $Card/Content/Scroll
@onready var cards: VBoxContainer = $Card/Content/Scroll/Cards
@onready var back: Button = $Card/Content/Back
var _memories: Array[Dictionary] = []


func _ready() -> void:
	preload("res://scripts/ui/front_end_style.gd").apply_theme(self)
	panel.add_theme_stylebox_override("panel", ART.frame())
	ART.button(back, true)
	ART.button(filter)
	for category in CATEGORIES: filter.add_item(category)
	filter.item_selected.connect(_filter_changed)
	back.pressed.connect(_close)
	if OS.get_name() == "iOS":
		var safe := DisplayServer.get_display_safe_area()
		var window := DisplayServer.window_get_size()
		var scale := get_viewport_rect().size.y / maxf(1.0, window.y)
		panel.offset_top = maxf(36, safe.position.y * scale + 8)
		panel.offset_bottom = -maxf(32, (window.y - safe.end.y) * scale + 8)


static func recorded_memories() -> Array[Dictionary]:
	var items: Array[Dictionary] = []
	for index in GameState.life_events.size():
		var memory = GameState.life_events[index]
		if not memory is Dictionary or not memory.get("key") is String or not memory.get("text") is String or memory["text"].strip_edges().is_empty(): continue
		var season = memory.get("season", -1)
		if not (season is int or season is float) or not is_finite(float(season)) or season < -1 or season > GameState.seasons_elapsed: continue
		var category := _category(memory["key"])
		items.append({"key": memory["key"], "text": memory["text"], "season": int(season), "category": category, "image": _image(memory["key"], category), "order": index})
	items.sort_custom(func(a: Dictionary, b: Dictionary):
		return a["order"] > b["order"] if a["season"] == b["season"] else a["season"] > b["season"])
	return items


static func _category(key: String) -> String:
	for prefix in ["mate", "young_", "departure_", "reunion_", "family_"]:
		if key.begins_with(prefix): return "Family"
	if key.begins_with("companion") or key == "alpha" or key.begins_with("council_") or key.begins_with("pack_pair_"): return "Pack"
	if key.begins_with("home_") or key.begins_with("alpha_home_") or key.begins_with("habitat_") or key == "territory": return "Home"
	if key.begins_with("journey"): return "Journeys"
	if key.begins_with("discovery_"): return "Discoveries"
	if key.begins_with("living_"): return "Encounters"
	return "Milestones"


static func _image(key: String, category: String) -> String:
	if category == "Discoveries":
		var entry: Dictionary = preload("res://scripts/systems/discoveries.gd").ENTRIES.get(key.trim_prefix("discovery_"), {})
		if not entry.is_empty(): return "res://assets/character_selection/%s_selection.png" % entry["species"]
	var files := {"Family": "hatchling_hidden_nest_all_species.png", "Home": "all_species_heavy_foilage_cover.png", "Journeys": "fresh_tracks.png", "Discoveries": "spring_growth.png", "Milestones": "spring_growth.png", "Encounters": "shared_waterhole.png"}
	if category == "Pack":
		return "res://assets/event_images/" + ("dense_herd.png" if SpeciesDB.get_species(GameState.species_id).get("tree") == "herbivore" else "creatures_watching.png")
	return "res://assets/event_images/" + files[category]


func open() -> void:
	_memories = recorded_memories()
	subtitle.text = "%s · Season %d" % [SpeciesDB.get_species(GameState.species_id).get("display_name", "Dinosaur"), GameState.seasons_elapsed + 1]
	filter.select(0)
	_render(0)
	get_parent().move_child(self, -1)
	show()
	back.grab_focus()


func _filter_changed(index: int) -> void:
	_render(index)


func _render(index: int) -> void:
	for child in cards.get_children():
		cards.remove_child(child)
		child.queue_free()
	for memory in _memories:
		if index != 0 and memory["category"] != CATEGORIES[index]: continue
		var card := preload("res://scenes/ui/journal_memory_card.tscn").instantiate()
		cards.add_child(card)
		card.setup(memory)
	if cards.get_child_count() == 0:
		var empty := preload("res://scripts/ui/perks_panel.gd").label("No memories recorded yet." if index == 0 else "No %s memories recorded yet." % CATEGORIES[index].to_lower())
		cards.add_child(empty)
	scroll.scroll_vertical = 0


func _close() -> void:
	hide()
	closed.emit()


func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		_close()
		get_viewport().set_input_as_handled()
