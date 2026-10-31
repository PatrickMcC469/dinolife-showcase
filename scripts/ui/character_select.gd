extends Control

const STYLE = preload("res://scripts/ui/front_end_style.gd")
const ART = preload("res://scripts/ui/adventure_theme.gd")

@onready var herb_tab:    Button        = $HerbTab
@onready var carn_tab:    Button        = $CarnTab
@onready var dino_image:  TextureRect   = $DinoImage
@onready var prev_arrow:  Button = $PrevArrow
@onready var next_arrow:  Button = $NextArrow
@onready var species_name: Label        = $SpeciesName
@onready var description:  Label        = $Description
@onready var lock_overlay: TextureRect  = $LockOverlay
@onready var locked_label: Label        = $LockedLabel
@onready var male_btn:    Button        = $MaleBtn
@onready var female_btn:  Button        = $FemaleBtn

var _current_tree:  String   = "herbivore"
var _current_index: int      = 0
var _tutorial_check: CheckBox = null
var _tooltip: Control = null
var _roster: HBoxContainer
var _diet_badge: Label
var _traits: Label
var _position_label: Label
var _ability_meters: Dictionary = {}


func _ready() -> void:
	_build_selection_page()
	_style_tabs()
	_style_labels()
	_style_gender_buttons()
	species_name.resized.connect(_fit_species_name)

	_add_unlock_button(lock_overlay)
	_add_unlock_button(locked_label)

	herb_tab.pressed.connect(_on_herb_tab)
	carn_tab.pressed.connect(_on_carn_tab)
	prev_arrow.pressed.connect(_on_prev)
	next_arrow.pressed.connect(_on_next)
	male_btn.pressed.connect(func(): _start_run("male"))
	female_btn.pressed.connect(func(): _start_run("female"))
	_refresh()


func _build_selection_page() -> void:
	STYLE.apply_theme(self)
	$Background.texture = preload("res://assets/ui/character_select_bg.png")
	var shade := ColorRect.new()
	shade.color = Color(0.015, 0.035, 0.02, 0.82)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(shade)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	move_child(shade, 1)
	var body := STYLE.page(self, 20)
	body.add_theme_constant_override("separation", 8)
	var header := HBoxContainer.new()
	body.add_child(header)
	var title := STYLE.heading("Choose a dinosaur", 19 if get_viewport_rect().size.x < 360 else 22)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(title)
	var back := Button.new()
	back.text = "‹ Back"
	STYLE.button(back)
	ART.button(back)
	back.custom_minimum_size.x = 64
	back.size_flags_horizontal = Control.SIZE_SHRINK_END
	back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn"))
	header.add_child(back)
	var tabs := HBoxContainer.new()
	tabs.add_theme_constant_override("separation", 8)
	body.add_child(tabs)
	for tab in [herb_tab, carn_tab]:
		tab.reparent(tabs)
		tab.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	herb_tab.text = "Herbivores"
	carn_tab.text = "Carnivores"
	_roster = HBoxContainer.new()
	_roster.add_theme_constant_override("separation", 7)
	body.add_child(_roster)
	var portrait := Panel.new()
	portrait.name = "PortraitCard"
	portrait.custom_minimum_size.y = clampf(get_viewport_rect().size.x * 0.64, 210, 350)
	portrait.add_theme_stylebox_override("panel", ART.frame())
	body.add_child(portrait)
	var image_area := Control.new()
	image_area.clip_contents = true
	portrait.add_child(image_area)
	image_area.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	image_area.offset_left = 12
	image_area.offset_right = -12
	image_area.offset_top = 12
	image_area.offset_bottom = -12
	dino_image.reparent(image_area)
	dino_image.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dino_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	lock_overlay.reparent(image_area)
	lock_overlay.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	lock_overlay.offset_left = -25
	lock_overlay.offset_right = 25
	lock_overlay.offset_top = -25
	lock_overlay.offset_bottom = 25
	for arrow in [prev_arrow, next_arrow]:
		arrow.reparent(image_area)
		STYLE.button(arrow)
		ART.button(arrow)
		arrow.custom_minimum_size = Vector2(40, 44)
		arrow.set_anchors_and_offsets_preset(Control.PRESET_CENTER_LEFT if arrow == prev_arrow else Control.PRESET_CENTER_RIGHT)
		arrow.offset_left = 4 if arrow == prev_arrow else -44
		arrow.offset_right = 44 if arrow == prev_arrow else -4
		arrow.offset_top = -22
		arrow.offset_bottom = 22
		arrow.text = "‹" if arrow == prev_arrow else "›"
	_position_label = STYLE.label("", 10, STYLE.PAPER)
	_position_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.8))
	_position_label.add_theme_constant_override("shadow_offset_y", 1)
	_position_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	image_area.add_child(_position_label)
	_position_label.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	_position_label.offset_left = -125
	_position_label.offset_right = -8
	_position_label.offset_top = 6
	_position_label.offset_bottom = 25
	var nameplate := PanelContainer.new()
	nameplate.name = "AttachedNameplate"
	nameplate.add_theme_stylebox_override("panel", STYLE.nameplate())
	portrait.add_child(nameplate)
	nameplate.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	nameplate.anchor_left = 0.10
	nameplate.anchor_right = 0.90
	nameplate.anchor_top = 1.0
	nameplate.offset_top = -43
	nameplate.offset_bottom = 1
	species_name.reparent(nameplate)
	species_name.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	species_name.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var badges := HBoxContainer.new()
	badges.alignment = BoxContainer.ALIGNMENT_CENTER
	badges.add_theme_constant_override("separation", 8)
	body.add_child(badges)
	for index in 2:
		var badge := PanelContainer.new()
		badge.add_theme_stylebox_override("panel", _badge_skin())
		badges.add_child(badge)
		var label := STYLE.label("", 12, STYLE.PAPER)
		label.custom_minimum_size.x = 70 if index == 0 else 55
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		badge.add_child(label)
		if index == 0:
			_diet_badge = label
		else:
			_traits = label
		badge.mouse_filter = Control.MOUSE_FILTER_PASS
	description.reparent(body)
	description.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	description.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var stats_band := HBoxContainer.new()
	stats_band.add_theme_constant_override("separation", 10)
	body.add_child(stats_band)
	var info := VBoxContainer.new()
	info.name = "StartingAbilities"
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info.add_theme_constant_override("separation", 5)
	stats_band.add_child(info)
	info.add_child(STYLE.label("Starting abilities · species scale", 10, STYLE.MUTED))
	for stat in ["strength", "speed", "defense"]:
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 6)
		info.add_child(row)
		var icon := TextureRect.new()
		icon.texture = load("res://assets/ui/action_icons/%s.svg" % {"strength": "hunt_light", "speed": "footprint_light", "defense": "shield_light"}[stat])
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.custom_minimum_size = Vector2(18, 18)
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_child(icon)
		var value := STYLE.label(str(stat).capitalize(), 12, STYLE.PAPER)
		value.custom_minimum_size.x = 58
		row.add_child(value)
		var meter := ProgressBar.new()
		meter.max_value = 1.0
		meter.show_percentage = false
		meter.custom_minimum_size = Vector2(12, 9)
		meter.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		meter.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		meter.mouse_filter = Control.MOUSE_FILTER_IGNORE
		meter.add_theme_stylebox_override("background", STYLE.box(Color(0.12, 0.18, 0.10), Color(0.40, 0.44, 0.25), 3))
		meter.add_theme_stylebox_override("fill", STYLE.box(Color(0.95, 0.69, 0.28), Color.TRANSPARENT, 3))
		for state in ["background", "fill"]:
			var skin := meter.get_theme_stylebox(state)
			for side in [SIDE_LEFT, SIDE_TOP, SIDE_RIGHT, SIDE_BOTTOM]: skin.set_content_margin(side, 0)
		row.add_child(meter)
		var number := STYLE.label("", 10, STYLE.GOLD)
		number.custom_minimum_size.x = 30
		number.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		row.add_child(number)
		_ability_meters[stat] = {"label": value, "meter": meter, "number": number}
		row.mouse_filter = Control.MOUSE_FILTER_PASS
	locked_label.reparent(stats_band)
	locked_label.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	locked_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	locked_label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	locked_label.custom_minimum_size = Vector2(100, 48)
	locked_label.add_theme_stylebox_override("normal", ART.parchment(Color.WHITE, 10, true))
	var genders := HBoxContainer.new()
	genders.add_theme_constant_override("separation", 10)
	body.add_child(genders)
	for btn in [male_btn, female_btn]:
		btn.reparent(genders)
		btn.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	male_btn.text = "Begin as male"
	female_btn.text = "Begin as female"
	male_btn.icon = preload("res://assets/ui/action_icons/male.svg")
	female_btn.icon = preload("res://assets/ui/action_icons/female.svg")
	for btn in [male_btn, female_btn]:
		btn.add_theme_constant_override("icon_max_width", 22)
	_build_tutorial_toggle()
	_tutorial_check.reparent(body)
	_tutorial_check.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	_tutorial_check.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	for control in [header, tabs, _roster, portrait, image_area, nameplate, badges, stats_band, info, genders, _tutorial_check]:
		control.mouse_filter = Control.MOUSE_FILTER_PASS


func _badge_skin() -> StyleBoxFlat:
	var skin := STYLE.box(Color(0.065, 0.12, 0.075, 0.96), Color(0.45, 0.47, 0.27), 7)
	skin.content_margin_left = 10
	skin.content_margin_right = 10
	skin.content_margin_top = 4
	skin.content_margin_bottom = 4
	return skin


# ── Styling ────────────────────────────────────────────────────────────────────

func _style_tabs() -> void:
	_apply_tab_style(herb_tab, _current_tree == "herbivore")
	_apply_tab_style(carn_tab, _current_tree == "carnivore")


func _apply_tab_style(btn: Button, selected: bool) -> void:
	STYLE.button(btn, false, selected)
	if selected:
		ART.button(btn, true)
	btn.toggle_mode = true
	btn.set_pressed_no_signal(selected)
	if selected:
		btn.add_theme_stylebox_override("pressed", btn.get_theme_stylebox("normal").duplicate())
	btn.add_theme_font_size_override("font_size", 13)
	btn.add_theme_constant_override("icon_max_width", 18)
	var glyph := "leaf" if btn == herb_tab else "hunt"
	btn.icon = load("res://assets/ui/action_icons/%s%s.svg" % [glyph, "" if selected else "_light"])
	btn.accessibility_name = btn.text + (". Selected" if selected else ". Show dinosaurs")


func _style_labels() -> void:
	species_name.add_theme_color_override("font_color", ART.INK)
	species_name.add_theme_font_override("font", STYLE.HEADING_FONT)
	species_name.add_theme_font_size_override("font_size", 22)
	description.add_theme_color_override("font_color", STYLE.MUTED)
	description.add_theme_font_size_override("font_size", 12)
	locked_label.add_theme_color_override("font_color", ART.INK)
	locked_label.add_theme_font_size_override("font_size", 11)


func _style_gender_buttons() -> void:
	for btn in [male_btn, female_btn]:
		STYLE.button(btn, true)
		btn.add_theme_font_size_override("font_size", 12 if get_viewport_rect().size.x < 360 else 13)
		if btn == female_btn:
			btn.add_theme_stylebox_override("normal", STYLE.box(Color(0.25, 0.16, 0.07, 0.96), STYLE.GOLD, 10))


func _build_tutorial_toggle() -> void:
	var check := CheckBox.new()
	check.text           = "Tutorial"
	check.button_pressed = GameState.show_tutorial
	check.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	check.position = Vector2(20.0, -52.0)
	check.add_theme_color_override("font_color",       Color(0.92, 0.86, 0.70))
	check.add_theme_color_override("font_hover_color", Color(1.00, 0.96, 0.80))
	check.add_theme_font_size_override("font_size", 13)
	add_child(check)
	_tutorial_check = check


# ── Navigation ─────────────────────────────────────────────────────────────────

func _current_chain() -> Array:
	return UnlockManager.V1_HERB_CHAIN if _current_tree == "herbivore" \
		   else UnlockManager.V1_PRED_CHAIN


func _current_species_id() -> String:
	return _current_chain()[_current_index]


func _on_herb_tab() -> void:
	SoundManager.play("tab_switch")
	_hide_tooltip()
	_current_tree  = "herbivore"
	_current_index = 0
	_style_tabs()
	_refresh()


func _on_carn_tab() -> void:
	SoundManager.play("tab_switch")
	_hide_tooltip()
	_current_tree  = "carnivore"
	_current_index = 0
	_style_tabs()
	_refresh()


func _on_prev() -> void:
	SoundManager.play("button_tap")
	_hide_tooltip()
	if _current_index > 0:
		_current_index -= 1
		_refresh()


func _on_next() -> void:
	SoundManager.play("button_tap")
	_hide_tooltip()
	if _current_index < _current_chain().size() - 1:
		_current_index += 1
		_refresh()


# ── Refresh display ────────────────────────────────────────────────────────────

func _refresh() -> void:
	var chain: Array        = _current_chain()
	var sid: String         = chain[_current_index] as String
	var sp: Dictionary      = SpeciesDB.get_species(sid)
	var is_unlocked: bool   = UnlockManager.is_unlocked(sid)
	_style_tabs()
	_refresh_roster(chain)
	_position_label.text = "%d / %d%s" % [_current_index + 1, chain.size(), "" if is_unlocked else " · Locked"]
	_diet_badge.text = "Herbivore" if _current_tree == "herbivore" else "Carnivore"
	_traits.text = ("Herd" if _current_tree == "herbivore" else "Pack") if sp.get("pack_species", false) else "Solitary"
	for stat in _ability_meters:
		var start: float = sp.get("base_" + stat, 0.0)
		_ability_meters[stat]["number"].text = "%d%%" % roundi(start * 100)
		_ability_meters[stat]["meter"].value = start
		_ability_meters[stat]["meter"].tooltip_text = "Starting %s on this dinosaur's own scale." % stat

	# Dino image — prefer selection art, fall back to adult art.
	var img_path := "res://assets/character_selection/%s_selection.png" % sid
	if not ResourceLoader.exists(img_path):
		img_path = "res://assets/dinos/%s_adult.png" % sid
	if ResourceLoader.exists(img_path):
		dino_image.texture  = load(img_path)
		dino_image.modulate = Color.WHITE if is_unlocked else Color(0.65, 0.65, 0.65, 1)
	else:
		dino_image.texture = null

	# Always show name and description — dim them when locked.
	species_name.text    = sp.get("display_name", sid)
	_fit_species_name()
	description.text     = sp.get("description",  "")
	species_name.visible = true
	description.visible  = true
	species_name.modulate = Color.WHITE
	description.modulate = Color.WHITE

	lock_overlay.visible = not is_unlocked
	locked_label.visible = not is_unlocked
	locked_label.text = ""
	if not is_unlocked:
		var best_path := 0.0
		for route in UnlockManager.get_best_progress(sid).get("routes", []):
			best_path = maxf(best_path, float(route["ratio"]))
		locked_label.text = "Unlock paths\nBest path %d%%" % roundi(best_path * 100)
	male_btn.visible     = is_unlocked
	female_btn.visible   = is_unlocked

	prev_arrow.disabled = _current_index == 0
	next_arrow.disabled = _current_index == chain.size() - 1


func _fit_species_name() -> void:
	if species_name.size.x <= 0:
		return
	var font := species_name.get_theme_font("font")
	var font_size := 22
	while font_size > 14 and font.get_string_size(species_name.text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x > species_name.size.x:
		font_size -= 1
	species_name.add_theme_font_size_override("font_size", font_size)


func _refresh_roster(chain: Array) -> void:
	for child in _roster.get_children():
		_roster.remove_child(child)
		child.queue_free()
	for index in chain.size():
		var sid: String = chain[index]
		var tile := Button.new()
		STYLE.button(tile, false, index == _current_index)
		var skin := tile.get_theme_stylebox("normal").duplicate() as StyleBoxFlat
		skin.set_border_width_all(2)
		tile.add_theme_stylebox_override("normal", skin)
		tile.custom_minimum_size = Vector2(0, 62)
		tile.tooltip_text = str(SpeciesDB.get_species(sid)["display_name"])
		tile.accessibility_name = tile.tooltip_text + (". Available" if UnlockManager.is_unlocked(sid) else ". Locked")
		_roster.add_child(tile)
		var art := Control.new()
		art.mouse_filter = Control.MOUSE_FILTER_IGNORE
		art.clip_contents = true
		tile.add_child(art)
		art.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		art.offset_left = 4
		art.offset_right = -4
		art.offset_top = 4
		art.offset_bottom = -4
		var image := TextureRect.new()
		image.texture = _portrait_thumbnail(sid)
		image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		image.mouse_filter = Control.MOUSE_FILTER_IGNORE
		image.modulate = Color.WHITE if UnlockManager.is_unlocked(sid) else Color(0.72, 0.72, 0.64)
		art.add_child(image)
		image.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		if not UnlockManager.is_unlocked(sid):
			var lock_icon := TextureRect.new()
			lock_icon.texture = preload("res://assets/ui/action_icons/lock.svg")
			lock_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			lock_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
			art.add_child(lock_icon)
			lock_icon.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
			lock_icon.offset_left = -20
			lock_icon.offset_top = -20
			lock_icon.offset_right = -1
			lock_icon.offset_bottom = -1
		tile.pressed.connect(func():
			SoundManager.play("button_tap")
			_hide_tooltip()
			_current_index = index
			_refresh()
		)


func _portrait_thumbnail(sid: String) -> AtlasTexture:
	var source: Texture2D = load("res://assets/character_selection/%s_selection.png" % sid)
	# Native atlas framing gives the existing artwork a readable head portrait.
	var centers := {"compsognathus": Vector2(0.30, 0.27), "deinonychus": Vector2(0.20, 0.20),
		"velociraptor": Vector2(0.72, 0.22), "allosaurus": Vector2(0.76, 0.25),
		"trex": Vector2(0.26, 0.30), "lesothosaurus": Vector2(0.23, 0.25),
		"iguanodon": Vector2(0.80, 0.28), "triceratops": Vector2(0.27, 0.36),
		"ankylosaurus": Vector2(0.80, 0.54), "argentinosaurus": Vector2(0.20, 0.15)}
	var dimensions := source.get_size()
	var side := dimensions.y * (0.62 if sid == "triceratops" else 0.48)
	var center: Vector2 = centers[sid] * dimensions
	var origin := Vector2(clampf(center.x - side / 2, 0, dimensions.x - side), clampf(center.y - side / 2, 0, dimensions.y - side))
	var portrait := AtlasTexture.new()
	portrait.atlas = source
	portrait.region = Rect2(origin, Vector2(side, side))
	return portrait


# ── Unlock tooltip ─────────────────────────────────────────────────────────────

func _add_unlock_button(control: Control) -> void:
	control.mouse_filter = Control.MOUSE_FILTER_PASS
	var button := Button.new()
	button.name = "UnlockButton"
	button.flat = true
	button.mouse_filter = Control.MOUSE_FILTER_PASS
	button.accessibility_name = "Show dinosaur unlock paths"
	control.add_child(button)
	button.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	# Native buttons cancel a tap when a touch turns into a scrolling gesture.
	button.pressed.connect(func(): _show_unlock_tooltip(_current_species_id()))


func _show_unlock_tooltip(sid: String) -> void:
	_hide_tooltip()
	if sid not in UnlockManager.UNLOCK_CONDITIONS or UnlockManager.is_unlocked(sid):
		return
	var progress := UnlockManager.get_best_progress(sid)
	var target_name: String = SpeciesDB.get_species(sid).get("display_name", sid)
	var overlay = preload("res://scenes/ui/event_overlay.tscn").instantiate()
	_tooltip = overlay
	add_child(overlay)
	overlay.z_index = 200
	overlay.choice_made.connect(func(_choice: String): _hide_tooltip())
	var text := UnlockManager.progress_text(sid, progress) + "\n\nProgress shows your best completed life for each path."
	overlay.show_event({"type": "info", "title": "Unlock paths",
		"flavor": target_name + "\n\n" + text,
		"choices": [{"action": "close", "label": "Close"}]})


func _hide_tooltip() -> void:
	if is_instance_valid(_tooltip):
		_tooltip.queue_free()
		_tooltip = null


# ── Start run ──────────────────────────────────────────────────────────────────

func _start_run(sex: String) -> void:
	if not UnlockManager.is_unlocked(_current_species_id()):
		return
	SoundManager.play("button_tap")
	GameState.show_tutorial = _tutorial_check != null and _tutorial_check.button_pressed
	var sid = _current_species_id()
	GameState.sex = sex
	GameState.start_run(sid)
	GameState.save_run()
	get_tree().change_scene_to_file("res://scenes/game/game_screen.tscn")
