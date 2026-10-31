extends RefCounted

const STYLE = preload("res://scripts/ui/front_end_style.gd")
const ART = preload("res://scripts/ui/adventure_theme.gd")
const SURVIVAL = preload("res://assets/ui/adventure/survival_tile_v2.png")
const STORY = preload("res://assets/ui/adventure/story_tile_v2.png")
# Vertical framing centers, reviewed against each existing stage portrait.
const PORTRAIT_FOCUS = {
	"compsognathus": [0.58, 0.25, 0.22, 0.14, 0.22],
	"deinonychus": [0.44, 0.41, 0.32, 0.27, 0.27],
	"velociraptor": [0.40, 0.41, 0.29, 0.29, 0.28],
	"allosaurus": [0.43, 0.41, 0.40, 0.33, 0.35],
	"trex": [0.52, 0.46, 0.37, 0.31, 0.32],
	"lesothosaurus": [0.41, 0.39, 0.30, 0.20, 0.21],
	"iguanodon": [0.52, 0.47, 0.34, 0.29, 0.29],
	"triceratops": [0.50, 0.49, 0.46, 0.46, 0.46],
	"ankylosaurus": [0.65, 0.57, 0.56, 0.56, 0.56],
	"argentinosaurus": [0.46, 0.39, 0.16, 0.11, 0.12],
}
const LETTERING_REGIONS = {
	"Continue": Rect2(59, 122, 2059, 457),
	"Survival": Rect2(89, 103, 2020, 488),
	"Story Mode": Rect2(26, 132, 2106, 481),
	"Discoveries": Rect2(23, 149, 2140, 405),
	"Lineage": Rect2(46, 82, 2083, 612),
	"Store": Rect2(77, 97, 1850, 602),
	"Settings": Rect2(47, 110, 1995, 555),
}


static func build(menu: Control) -> void:
	STYLE.apply_theme(menu)
	menu.bg_image.texture = preload("res://assets/ui/character_select_bg.png")
	menu.bg_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var shade := ColorRect.new()
	shade.color = Color(0.015, 0.035, 0.015, 0.62)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	menu.add_child(shade)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	menu.move_child(shade, 1)
	var living_art := preload("res://scenes/ui/living_art.tscn").instantiate()
	menu.add_child(living_art)
	menu.move_child(living_art, 2)
	var body := STYLE.page(menu, 16)
	body.add_theme_constant_override("separation", 6)
	var page_margin: MarginContainer = body.get_parent().get_parent()
	page_margin.set_meta("safe_top", page_margin.get_theme_constant("margin_top"))
	page_margin.set_meta("safe_bottom", page_margin.get_theme_constant("margin_bottom"))
	var scroll: ScrollContainer = body.get_parent()
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	var hero := TextureRect.new()
	hero.name = "LivingWildTitle"
	hero.texture = preload("res://assets/ui/adventure/living_wild_title_v1.png")
	hero.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	hero.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	hero.custom_minimum_size.y = clampf(menu.get_viewport_rect().size.x * 0.33, 112, 172)
	hero.mouse_filter = Control.MOUSE_FILTER_IGNORE
	# Keep the complete title above the fixed menu content.
	var safe_top := page_margin.get_theme_constant("margin_top")
	page_margin.add_theme_constant_override("margin_top", safe_top + int(hero.custom_minimum_size.y) + 10)
	menu.add_child(hero)
	hero.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	hero.anchor_bottom = 0.0
	hero.offset_left = 20
	hero.offset_right = -20
	hero.offset_top = safe_top
	hero.offset_bottom = safe_top + hero.custom_minimum_size.y
	menu.continue_btn.reparent(body)
	menu.continue_btn.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	var saved := _saved_life()
	menu.continue_btn.visible = not saved.is_empty()
	if not saved.is_empty():
		_continue_card(menu.continue_btn, saved, menu.get_viewport_rect().size.x)
	menu.menu_actions.reparent(body)
	menu.menu_actions.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	menu.menu_actions.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var modes := HBoxContainer.new()
	modes.name = "ModeCards"
	modes.mouse_filter = Control.MOUSE_FILTER_PASS
	modes.add_theme_constant_override("separation", 10)
	menu.menu_actions.add_child(modes)
	for btn in [menu.new_game_btn, menu._story_btn]:
		btn.reparent(modes)
		btn.custom_minimum_size.x = 0
	_mode_card(menu.new_game_btn, "Survival")
	_mode_card(menu._story_btn, "Story Mode")
	var grid := GridContainer.new()
	grid.name = "CollectionLinks"
	grid.columns = 4
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 8)
	body.add_child(grid)
	var buttons := [menu.discoveries_btn, menu._lineage_btn, menu.store_btn, menu.settings_btn]
	var icons := ["discoveries", "lineage", "store", "settings"]
	for index in buttons.size():
		var btn: Button = buttons[index]
		btn.reparent(grid)
		btn.custom_minimum_size.x = 0
		_collection_card(btn, btn.text, load("res://assets/ui/adventure/collection/%s_fossil_v2.png" % icons[index]))
	menu.no_save_label.reparent(body)
	menu.no_save_label.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	_studio_footer(menu, page_margin)
	menu.move_child(menu.settings_panel, menu.get_child_count() - 1)
	style_buttons(menu)
	menu.resized.connect(func(): _fit_page.call_deferred(menu))
	menu.no_save_label.visibility_changed.connect(func(): _fit_page.call_deferred(menu))


static func _studio_footer(menu: Control, page_margin: MarginContainer) -> void:
	var safe_bottom := page_margin.get_theme_constant("margin_bottom")
	# Reserve the footer's full height above the existing home-indicator inset.
	page_margin.add_theme_constant_override("margin_bottom", safe_bottom + 66)
	var footer := HBoxContainer.new()
	footer.name = "StudioLogo"
	footer.alignment = BoxContainer.ALIGNMENT_CENTER
	footer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	footer.accessibility_name = "Wandering Turtle Games"
	footer.add_theme_constant_override("separation", 10)
	menu.add_child(footer)
	footer.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM)
	footer.offset_left = -120
	footer.offset_right = 120
	footer.offset_top = -safe_bottom - 56
	footer.offset_bottom = -safe_bottom
	var symbol := TextureRect.new()
	var artwork := preload("res://assets/ui/branding/wandering_turtle_pencil_logo_v1.png").get_image().get_region(Rect2i(27, 179, 1919, 452))
	artwork.resize(768, 181, Image.INTERPOLATE_LANCZOS)
	artwork.generate_mipmaps()
	symbol.texture = ImageTexture.create_from_image(artwork)
	symbol.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	symbol.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	symbol.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	symbol.custom_minimum_size = Vector2(240, 56)
	symbol.mouse_filter = Control.MOUSE_FILTER_IGNORE
	footer.add_child(symbol)


static func _fit_page(menu: Control) -> void:
	var page_margin: MarginContainer = menu.get_node("PageMargin")
	var hero: TextureRect = menu.get_node("LivingWildTitle")
	var footer: Control = menu.get_node("StudioLogo")
	var safe_top: int = page_margin.get_meta("safe_top")
	var safe_bottom: int = page_margin.get_meta("safe_bottom")
	var viewport := menu.get_viewport_rect().size
	var has_continue: bool = menu.continue_btn.visible
	var gaps := 10 + 10 + (12 if has_continue else 6)
	if menu.no_save_label.visible:
		gaps += 6 + ceili(menu.no_save_label.get_combined_minimum_size().y)
	# Shrink the illustrations before sacrificing readable labels or touch targets.
	var minimum := [64.0, 156.0 if has_continue else 0.0, 90.0, 64.0, 36.0]
	var preferred := [clampf(viewport.x * 0.33, 112, 172), clampf(viewport.x * 0.74, 228, 360) if has_continue else 0.0, clampf(viewport.x * 0.43, 138, 220), 82.0, 56.0]
	var minimum_total := 0.0
	var preferred_total := 0.0
	for index in minimum.size():
		minimum_total += minimum[index]
		preferred_total += preferred[index]
	var available := viewport.y - safe_top - safe_bottom - gaps
	var fit := clampf((available - minimum_total) / (preferred_total - minimum_total), 0.0, 1.0)
	var heights: Array[float] = []
	for index in minimum.size():
		heights.append(floorf(lerpf(minimum[index], preferred[index], fit)))
	hero.custom_minimum_size.y = heights[0]
	hero.offset_top = safe_top
	hero.offset_bottom = safe_top + heights[0]
	page_margin.add_theme_constant_override("margin_top", safe_top + int(heights[0]) + 10)
	menu.continue_btn.custom_minimum_size.y = heights[1]
	if has_continue:
		_fit_continue_card(menu.continue_btn, heights[1] < 210)
	for btn in [menu.new_game_btn, menu._story_btn]:
		btn.custom_minimum_size.y = heights[2]
	for btn in [menu.discoveries_btn, menu._lineage_btn, menu.store_btn, menu.settings_btn]:
		btn.custom_minimum_size.y = heights[3]
	footer.get_child(0).custom_minimum_size.y = heights[4]
	var content_end := safe_top + heights[0] + heights[1] + heights[2] + heights[3] + gaps - 10
	var bottom := maxf(safe_bottom, viewport.y - content_end - 10 - heights[4])
	footer.offset_top = -bottom - heights[4]
	footer.offset_bottom = -bottom
	page_margin.add_theme_constant_override("margin_bottom", ceili(bottom + heights[4] + 10))


static func _fit_continue_card(btn: Button, compact: bool) -> void:
	var content: Control = btn.get_node("IllustratedCard")
	var photo: Control = content.get_node("Photo")
	var caption: Control = content.get_node("Caption")
	var row: Control = caption.get_node("Row")
	photo.offset_bottom = -52
	caption.offset_top = -52
	row.get_node("Footprint").visible = not compact
	var text: Control = row.get_node("Text")
	text.offset_left = 16 if compact else 28
	text.offset_right = -28
	_fit_portrait(photo)


static func _fit_portrait(photo: Control) -> void:
	var image: TextureRect = photo.get_node("Portrait")
	var source := image.texture.get_size()
	var scale := maxf(photo.size.x / source.x, photo.size.y / source.y)
	image.size = source * scale
	image.position.x = (photo.size.x - image.size.x) * 0.5
	image.position.y = clampf(photo.size.y * 0.48 - float(image.get_meta("focus_y")) * image.size.y, photo.size.y - image.size.y, 0.0)


static func style_buttons(menu: Control) -> void:
	for btn in [menu.new_game_btn, menu.continue_btn, menu._story_btn, menu.discoveries_btn, menu._lineage_btn, menu.store_btn, menu.settings_btn]:
		STYLE.button(btn)
		btn.custom_minimum_size.x = 0
		if btn in [menu.new_game_btn, menu._story_btn]:
			btn.custom_minimum_size.y = clampf(menu.get_viewport_rect().size.x * 0.43, 138, 220)
			var texture: Texture2D = SURVIVAL if btn == menu.new_game_btn else STORY
			for state in ["normal", "hover", "pressed", "disabled"]:
				var skin := StyleBoxTexture.new()
				skin.texture = texture
				skin.modulate_color = Color(0.80, 0.80, 0.75) if state == "pressed" else Color.WHITE
				btn.add_theme_stylebox_override(state, skin)
		elif btn == menu.continue_btn:
			btn.custom_minimum_size.y = clampf(menu.get_viewport_rect().size.x * 0.74, 228, 360)
			for state in ["normal", "hover", "pressed", "disabled"]:
				var skin := ART.frame()
				skin.modulate_color = Color(0.83, 0.83, 0.76) if state == "pressed" else Color.WHITE
				btn.add_theme_stylebox_override(state, skin)
		else:
			ART.button(btn)
			btn.custom_minimum_size.y = 82
	_fit_page.call_deferred(menu)


static func _mode_card(btn: Button, title: String) -> void:
	btn.text = ""
	btn.icon = null
	btn.accessibility_name = title
	var caption := _wordmark(title, 24)
	caption.custom_minimum_size.y = 0
	caption.name = "ModeTitle"
	btn.add_child(caption)
	caption.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	# The two illustrations have different parchment positions.
	caption.anchor_top = 0.70 if title == "Survival" else 0.64
	caption.anchor_bottom = 0.90 if title == "Survival" else 0.865
	caption.anchor_left = 0.12
	caption.anchor_right = 0.88


static func _continue_card(btn: Button, saved: Dictionary, viewport_width: float) -> void:
	btn.text = ""
	btn.icon = null
	var sid: String = saved["species_id"]
	var stage := clampi(int(saved.get("life_stage", 0)), 0, 4)
	var stages := ["hatchling", "juvenile", "sub_adult", "adult", "elder"]
	var portrait_path := "res://assets/dinos/%s_%s.png" % [sid, stages[stage]]
	if not ResourceLoader.exists(portrait_path):
		portrait_path = "res://assets/character_selection/%s_selection.png" % sid
	var detail := "%s · %s · Season %d" % [SpeciesDB.get_species(sid).get("display_name", sid), GameState.STAGE_NAMES[stage], maxi(0, int(saved.get("seasons_elapsed", 0))) + 1]
	btn.accessibility_name = "Continue. " + detail
	btn.tooltip_text = detail
	var content := Control.new()
	content.name = "IllustratedCard"
	content.mouse_filter = Control.MOUSE_FILTER_IGNORE
	btn.add_child(content)
	content.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	content.offset_left = 12
	content.offset_right = -12
	content.offset_top = 12
	content.offset_bottom = -8
	var photo := Control.new()
	photo.name = "Photo"
	photo.clip_contents = true
	photo.mouse_filter = Control.MOUSE_FILTER_IGNORE
	content.add_child(photo)
	photo.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	photo.offset_bottom = -60
	var image := TextureRect.new()
	image.name = "Portrait"
	image.texture = load(portrait_path)
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image.stretch_mode = TextureRect.STRETCH_SCALE
	image.set_meta("focus_y", PORTRAIT_FOCUS[sid][stage])
	image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	photo.add_child(image)
	image.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	# Cover the entire frame without distortion, keeping the actual face in view.
	photo.resized.connect(func(): _fit_portrait(photo))
	var caption := PanelContainer.new()
	caption.name = "Caption"
	caption.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var paper := STYLE.nameplate()
	paper.content_margin_top = 3
	paper.content_margin_bottom = 3
	caption.add_theme_stylebox_override("panel", paper)
	content.add_child(caption)
	caption.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	caption.anchor_top = 1.0
	caption.offset_top = -60
	caption.offset_left = -7
	caption.offset_right = 7
	var row := Control.new()
	row.name = "Row"
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	caption.add_child(row)
	var icon := TextureRect.new()
	icon.name = "Footprint"
	icon.texture = preload("res://assets/ui/action_icons/footprint.svg")
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(icon)
	icon.set_anchors_and_offsets_preset(Control.PRESET_CENTER_LEFT)
	icon.offset_top = -16
	icon.offset_bottom = 16
	icon.offset_left = 6
	icon.offset_right = 33
	var text := VBoxContainer.new()
	text.name = "Text"
	text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	text.alignment = BoxContainer.ALIGNMENT_CENTER
	text.add_theme_constant_override("separation", 0)
	row.add_child(text)
	text.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	text.offset_left = 28
	text.offset_right = -28
	var title := _wordmark("Continue", 24)
	title.name = "ContinueTitle"
	text.add_child(title)
	var short_detail := "%s · Season %d" % [SpeciesDB.get_species(sid).get("display_name", sid), maxi(0, int(saved.get("seasons_elapsed", 0))) + 1]
	var saved_life := STYLE.label(short_detail, 12, ART.INK)
	saved_life.name = "SavedLife"
	text.add_child(saved_life)
	_center_label(saved_life, 12, 11)
	var arrow := STYLE.heading("›", 26, ART.INK)
	arrow.name = "Arrow"
	arrow.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	arrow.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	row.add_child(arrow)
	arrow.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	arrow.anchor_left = 1.0
	arrow.offset_left = -33
	arrow.offset_right = -6
	btn.custom_minimum_size.y = clampf(viewport_width * 0.74, 228, 360)


static func _collection_card(btn: Button, title: String, texture: Texture2D) -> void:
	btn.text = ""
	btn.icon = null
	btn.accessibility_name = title
	var column := VBoxContainer.new()
	column.mouse_filter = Control.MOUSE_FILTER_IGNORE
	column.alignment = BoxContainer.ALIGNMENT_CENTER
	column.add_theme_constant_override("separation", 4)
	btn.add_child(column)
	column.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	column.offset_left = 5
	column.offset_right = -5
	column.offset_top = 8
	column.offset_bottom = -8
	var icon := TextureRect.new()
	icon.texture = texture
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.custom_minimum_size.y = 32
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	column.add_child(icon)
	var label := _wordmark(title, 16)
	label.name = "CollectionTitle"
	column.add_child(label)


static func _wordmark(title: String, height: float) -> TextureRect:
	var artwork: Texture2D = load("res://assets/ui/adventure/lettering/%s_v1.png" % title.to_snake_case())
	# Prepare a small, smoothly filtered UI texture; preserve the original PNG.
	var pixels := artwork.get_image().get_region(LETTERING_REGIONS[title])
	pixels.resize(512, maxi(1, roundi(512.0 * pixels.get_height() / pixels.get_width())), Image.INTERPOLATE_LANCZOS)
	pixels.generate_mipmaps()
	var image := TextureRect.new()
	image.texture = ImageTexture.create_from_image(pixels)
	image.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	image.custom_minimum_size.y = height
	image.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return image


static func _center_label(label: Label, preferred_size: int, minimum_size: int) -> void:
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	label.clip_text = true
	label.resized.connect(func():
		var font := label.get_theme_font("font")
		var font_size := preferred_size
		for line in label.text.split("\n"):
			while font_size > minimum_size and font.get_string_size(line, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x > label.size.x - 4:
				font_size -= 1
		label.add_theme_font_size_override("font_size", font_size)
	)


static func _saved_life() -> Dictionary:
	# Read the card without loading a run or changing any player state.
	if not GameState.has_save():
		return {}
	var file := FileAccess.open(GameState.SAVE_PATH, FileAccess.READ)
	if file == null:
		return {}
	var saved = JSON.parse_string(file.get_as_text())
	if not saved is Dictionary or saved.get("species_id", "") not in UnlockManager.PLAYABLE_SPECIES:
		return {}
	for key in ["life_stage", "seasons_elapsed"]:
		if saved.has(key) and not (saved[key] is int or saved[key] is float):
			return {}
	return saved
