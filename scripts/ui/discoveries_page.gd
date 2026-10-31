extends Control

const DISCOVERIES = preload("res://scripts/systems/discoveries.gd")
const SPECIES_CARD = preload("res://scenes/ui/discovery_species_card.tscn")
const ENTRY_CARD = preload("res://scenes/ui/discovery_entry_card.tscn")
const FOUND_COLOR = Color(0.65, 0.84, 0.53)
const UNFOUND_COLOR = Color(0.83, 0.73, 0.52)

@onready var scroll: ScrollContainer = $Margin/Content/Scroll
@onready var grid: GridContainer = $Margin/Content/Scroll/Body/Grid
@onready var details: VBoxContainer = $Margin/Content/Scroll/Body/Details
@onready var heading: Label = $Margin/Content/Section/Heading
@onready var all_button: Button = $Margin/Content/Section/AllButton
@onready var close_button: Button = $Margin/Content/Header/CloseButton
@onready var progress_label: Label = $Margin/Content/Progress/Count

var found: Dictionary = {}
var selected_species := ""


func _ready() -> void:
	found = DISCOVERIES.records()
	progress_label.text = "%d / %d discoveries found" % [found.size(), DISCOVERIES.ENTRIES.size()]
	$Margin/Content/Progress/Bar.value = float(found.size()) / DISCOVERIES.ENTRIES.size() * 100.0
	close_button.pressed.connect(queue_free)
	all_button.pressed.connect(_show_grid)
	if OS.get_name() == "iOS":
		var safe := DisplayServer.get_display_safe_area()
		var height := float(DisplayServer.window_get_size().y)
		if height > 0.0:
			var scale := get_viewport_rect().size.y / height
			$Margin.add_theme_constant_override("margin_top", maxi(48, int(safe.position.y * scale) + 12))
			$Margin.add_theme_constant_override("margin_bottom", maxi(24, int((height - safe.end.y) * scale) + 12))
	for species in UnlockManager.PLAYABLE_SPECIES:
		var card = SPECIES_CARD.instantiate()
		grid.add_child(card)
		card.set_meta("species_id", species)
		card.get_node("Margin/Content/Photo").texture = _portrait(species)
		card.get_node("Margin/Content/Name").text = SpeciesDB.get_species(species)["display_name"]
		var title: Label = card.get_node("Margin/Content/Discovery")
		var status: Label = card.get_node("Margin/Content/Status")
		var eligible := ""
		for id in DISCOVERIES.ENTRIES:
			if species in DISCOVERIES.ENTRIES[id]["finders"]:
				eligible = id
				break
		title.text = DISCOVERIES.ENTRIES[eligible]["title"] if not eligible.is_empty() else "Knowledge from other lives"
		if eligible.is_empty():
			status.text = "%d SHARED DISCOVERIES" % found.size()
		elif found.has(eligible):
			status.text = "FOUND BY\n" + str(SpeciesDB.get_species(found[eligible]["source"])["display_name"])
		else:
			status.text = "UNDISCOVERED"
		status.modulate = FOUND_COLOR if found.has(eligible) or (eligible.is_empty() and not found.is_empty()) else UNFOUND_COLOR
		card.accessibility_name = str(SpeciesDB.get_species(species)["display_name"]) + ": " + title.text + ", " + status.text
		card.tooltip_text = card.accessibility_name
		card.pressed.connect(_show_species.bind(species))
	_show_grid()


func _portrait(species: String) -> Texture2D:
	return load("res://assets/dinos/%s_adult.png" % species)


func _show_grid() -> void:
	selected_species = ""
	grid.show()
	details.hide()
	all_button.hide()
	$Margin/Content/Hint.text = "Tap a dinosaur to see its discoveries."
	heading.text = "CHOOSE A DINOSAUR"
	scroll.scroll_vertical = 0


func _show_species(species: String) -> void:
	SoundManager.play("button_tap")
	selected_species = species
	grid.hide()
	details.show()
	all_button.show()
	$Margin/Content/Hint.text = "Feeding advantage · This season and the next two"
	heading.text = SpeciesDB.get_species(species)["display_name"]
	for child in details.get_children():
		details.remove_child(child)
		child.queue_free()
	# Findable discoveries first; knowledge from other species follows.
	var ids: Array = DISCOVERIES.ENTRIES.keys()
	ids.sort_custom(func(a, b): return (species in DISCOVERIES.ENTRIES[a]["finders"]) and (species not in DISCOVERIES.ENTRIES[b]["finders"]))
	for id in ids:
		var data: Dictionary = DISCOVERIES.ENTRIES[id]
		var card = ENTRY_CARD.instantiate()
		details.add_child(card)
		card.set_meta("discovery_id", id)
		card.get_node("Content/Photo").texture = _portrait(data["species"])
		card.get_node("Content/Text/Title").text = data["title"]
		card.get_node("Content/Text/Encounter").text = "Signs of " + str(SpeciesDB.get_species(data["species"])["display_name"])
		card.get_node("Content/Text/Lesson").text = data["lesson"]
		var status: Label = card.get_node("Content/Text/Status")
		status.text = "Found by " + str(SpeciesDB.get_species(found[id]["source"])["display_name"]) if found.has(id) else "Undiscovered"
		status.modulate = FOUND_COLOR if found.has(id) else UNFOUND_COLOR
		var use_label: Label = card.get_node("Content/Text/Use")
		if found.has(id):
			use_label.text = "Discovered in this species' life" if found[id]["source"] == species else "Can recall in this dinosaur's life"
		elif species in data["finders"]:
			use_label.text = "Can find · Sub-adult · Season 8+"
		else:
			var names: Array[String] = []
			for finder in data["finders"]: names.append(SpeciesDB.get_species(finder)["display_name"])
			use_label.text = "Find first as: " + ", ".join(names)
	scroll.scroll_vertical = 0


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if selected_species.is_empty(): queue_free()
		else: _show_grid()
		get_viewport().set_input_as_handled()
