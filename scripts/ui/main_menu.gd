extends Control

const MEMORIAL_VIEW = preload("res://scenes/ui/memorial_view.tscn")
const STYLE = preload("res://scripts/ui/front_end_style.gd")
const LAYOUT = preload("res://scripts/ui/main_menu_layout.gd")

@onready var bg_image: TextureRect       = $BgImage
@onready var new_game_btn: Button        = $ButtonContainer/NewGameBtn
@onready var continue_btn: Button        = $ButtonContainer/ContinueBtn
@onready var settings_btn: Button        = $ButtonContainer/SettingsBtn
@onready var store_btn: Button           = $ButtonContainer/StoreBtn
@onready var no_save_label: Label        = $NoSaveLabel
@onready var settings_panel             = $SettingsPanel
@onready var _story_btn: Button          = $ButtonContainer/StoryBtn
@onready var discoveries_btn: Button     = $ButtonContainer/DiscoveriesBtn

var _hide_label_timer: float = 0.0
var _lineage_btn: Button = null
@onready var menu_actions: VBoxContainer = $ButtonContainer


func _ready() -> void:
	_load_background()
	_build_lineage_btn()
	_build_front_page()
	_style_buttons()
	continue_btn.disabled = not GameState.has_save()
	new_game_btn.pressed.connect(_on_new_game)
	continue_btn.pressed.connect(_on_continue)
	settings_btn.pressed.connect(_on_settings)
	store_btn.pressed.connect(_on_store)
	_lineage_btn.pressed.connect(_show_lineage_panel)
	_story_btn.pressed.connect(_on_story)
	discoveries_btn.pressed.connect(_show_discoveries)
	settings_panel.closed.connect(_style_buttons)


func _build_lineage_btn() -> void:
	_lineage_btn = Button.new()
	_lineage_btn.name = "LineageBtn"
	_lineage_btn.text = "Lineage"
	$ButtonContainer.add_child(_lineage_btn)
	_lineage_btn.custom_minimum_size = Vector2(260, 44)


func _show_discoveries() -> void:
	SoundManager.play("button_tap")
	var page = preload("res://scenes/ui/discoveries_page.tscn").instantiate()
	add_child(page)
	page.z_index = 200


func _process(delta: float) -> void:
	if _hide_label_timer > 0.0:
		_hide_label_timer -= delta
		if _hide_label_timer <= 0.0:
			no_save_label.visible = false


func _load_background() -> void:
	pass


func _build_front_page() -> void:
	LAYOUT.build(self)

func _on_new_game() -> void:
	if GameState.has_save():
		_show_new_game_confirm()
	else:
		_start_new_game()


func _show_new_game_confirm() -> void:
	var confirm_bg := ColorRect.new()
	confirm_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	confirm_bg.color        = Color(0, 0, 0, 0.60)
	confirm_bg.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(confirm_bg)

	var panel := PanelContainer.new()
	panel.layout_mode = 1
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.offset_left   = -170
	panel.offset_right  =  170
	panel.offset_top    = -110
	panel.offset_bottom =  110
	var bg := StyleBoxFlat.new()
	bg.bg_color     = Color(0.09, 0.04, 0.02, 0.98)
	bg.border_color = Color(0.72, 0.22, 0.12, 0.90)
	bg.set_border_width_all(2)
	bg.set_corner_radius_all(12)
	bg.content_margin_left   = 20
	bg.content_margin_right  = 20
	bg.content_margin_top    = 20
	bg.content_margin_bottom = 20
	panel.add_theme_stylebox_override("panel", bg)
	confirm_bg.add_child(panel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	panel.add_child(vbox)

	var title_lbl := Label.new()
	title_lbl.text                 = "Start a new run?"
	title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_lbl.add_theme_font_size_override("font_size", 18)
	title_lbl.add_theme_color_override("font_color", Color(0.97, 0.87, 0.60))
	vbox.add_child(title_lbl)

	var sub_lbl := Label.new()
	sub_lbl.text                 = "Your current run will be lost.\nThis cannot be undone."
	sub_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub_lbl.autowrap_mode        = TextServer.AUTOWRAP_WORD_SMART
	sub_lbl.add_theme_font_size_override("font_size", 13)
	sub_lbl.add_theme_color_override("font_color", Color(0.65, 0.58, 0.44))
	vbox.add_child(sub_lbl)

	var btn_row := HBoxContainer.new()
	btn_row.add_theme_constant_override("separation", 14)
	btn_row.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_child(btn_row)

	var cancel_style := StyleBoxFlat.new()
	cancel_style.bg_color     = Color(0.15, 0.10, 0.03, 0.90)
	cancel_style.border_color = Color(0.75, 0.55, 0.22, 0.90)
	cancel_style.set_border_width_all(2)
	cancel_style.set_corner_radius_all(8)

	var cancel_btn := Button.new()
	cancel_btn.text = "Cancel"
	cancel_btn.custom_minimum_size = Vector2(110, 0)
	cancel_btn.add_theme_font_size_override("font_size", 15)
	cancel_btn.add_theme_stylebox_override("normal",  cancel_style)
	cancel_btn.add_theme_stylebox_override("hover",   cancel_style)
	cancel_btn.add_theme_stylebox_override("pressed", cancel_style)
	cancel_btn.add_theme_color_override("font_color", Color(0.97, 0.93, 0.80))
	cancel_btn.pressed.connect(confirm_bg.queue_free)
	btn_row.add_child(cancel_btn)

	var confirm_style := StyleBoxFlat.new()
	confirm_style.bg_color     = Color(0.22, 0.05, 0.03, 0.90)
	confirm_style.border_color = Color(0.78, 0.22, 0.12, 0.90)
	confirm_style.set_border_width_all(2)
	confirm_style.set_corner_radius_all(8)

	var confirm_btn := Button.new()
	confirm_btn.text = "New Run"
	confirm_btn.custom_minimum_size = Vector2(110, 0)
	confirm_btn.add_theme_font_size_override("font_size", 15)
	confirm_btn.add_theme_stylebox_override("normal",  confirm_style)
	confirm_btn.add_theme_stylebox_override("hover",   confirm_style)
	confirm_btn.add_theme_stylebox_override("pressed", confirm_style)
	confirm_btn.add_theme_color_override("font_color", Color(1.0, 0.75, 0.70))
	confirm_btn.pressed.connect(func():
		confirm_bg.queue_free()
		_start_new_game()
	)
	btn_row.add_child(confirm_btn)

	confirm_bg.gui_input.connect(func(ev: InputEvent):
		if ev is InputEventMouseButton and (ev as InputEventMouseButton).pressed:
			confirm_bg.queue_free()
	)


func _start_new_game() -> void:
	GameState.delete_save()
	for button in [new_game_btn, continue_btn, _story_btn, discoveries_btn, _lineage_btn, store_btn, settings_btn]:
		if button is Button:
			button.disabled = true
	var opening = preload("res://scenes/ui/survival_opening.tscn").instantiate()
	opening.z_index = 250
	opening.finished.connect(func():
		get_tree().change_scene_to_file("res://scenes/ui/character_select.tscn")
	, CONNECT_ONE_SHOT)
	add_child(opening)


func _on_continue() -> void:
	if GameState.load_run():
		get_tree().change_scene_to_file("res://scenes/game/game_screen.tscn")
	else:
		no_save_label.visible = true
		_hide_label_timer = 2.5


func _on_settings() -> void:
	settings_panel.open()


func _on_store() -> void:
	_show_store_panel()


func _show_store_panel() -> void:
	var backdrop := ColorRect.new()
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	backdrop.color        = Color(0, 0, 0, 0.72)
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(backdrop)

	var safe_top := 16
	var safe_bottom := 16
	if OS.get_name() == "iOS":
		var sa := DisplayServer.get_display_safe_area()
		safe_top    = maxi(16, sa.position.y + 8)
		safe_bottom = maxi(16, (DisplayServer.window_get_size().y - sa.end.y) + 8)

	var panel := PanelContainer.new()
	panel.layout_mode = 1
	panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	panel.offset_left   =  16
	panel.offset_right  = -16
	panel.offset_top    =  safe_top
	panel.offset_bottom = -safe_bottom
	var bg := StyleBoxFlat.new()
	bg.bg_color     = Color(0.07, 0.04, 0.02, 0.97)
	bg.border_color = Color(0.75, 0.55, 0.22, 0.90)
	bg.set_border_width_all(2)
	bg.set_corner_radius_all(14)
	bg.content_margin_left   = 18
	bg.content_margin_right  = 18
	bg.content_margin_top    = 18
	bg.content_margin_bottom = 18
	panel.add_theme_stylebox_override("panel", bg)
	backdrop.add_child(panel)

	var outer_vbox := VBoxContainer.new()
	outer_vbox.add_theme_constant_override("separation", 12)
	panel.add_child(outer_vbox)

	var title := Label.new()
	title.text                 = "Store"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 22)
	title.add_theme_color_override("font_color", Color(0.98, 0.88, 0.55))
	outer_vbox.add_child(title)

	var sep := HSeparator.new()
	sep.add_theme_color_override("color", Color(0.75, 0.55, 0.22, 0.50))
	outer_vbox.add_child(sep)

	# Scrollable area so cards fit on small screens
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	outer_vbox.add_child(scroll)

	var scroll_vbox := VBoxContainer.new()
	scroll_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll_vbox.add_theme_constant_override("separation", 12)
	scroll.add_child(scroll_vbox)

	var products := [
		{
			"id":    StoreManager.PRODUCT_AD_FREE,
			"name":  "Ad-Free",
			"desc":  "Remove all ads forever. Rewarded videos remain optional in Settings.",
			"price": "$2.99",
			"owned": StoreManager.is_ad_free(),
		},
		{
			"id":    StoreManager.PRODUCT_PRED_PACK,
			"name":  "Predator Pack",
			"desc":  "Instantly unlock all 5 predators: Compsognathus through T-Rex.",
			"price": "$2.99",
			"owned": StoreManager.has_pred_pack(),
		},
		{
			"id":    StoreManager.PRODUCT_HERB_PACK,
			"name":  "Herbivore Pack",
			"desc":  "Instantly unlock all 5 herbivores: Lesothosaurus through Argentinosaurus.",
			"price": "$2.99",
			"owned": StoreManager.has_herb_pack(),
		},
	]

	for product in products:
		scroll_vbox.add_child(_build_store_card(product, backdrop))

	var restore_btn := Button.new()
	restore_btn.text = "Restore Purchases"
	restore_btn.add_theme_font_size_override("font_size", 14)
	var restore_style := StyleBoxFlat.new()
	restore_style.bg_color     = Color(0.08, 0.05, 0.02, 0.60)
	restore_style.border_color = Color(0.55, 0.42, 0.18, 0.60)
	restore_style.set_border_width_all(1)
	restore_style.set_corner_radius_all(8)
	restore_btn.add_theme_stylebox_override("normal",  restore_style)
	restore_btn.add_theme_stylebox_override("hover",   restore_style)
	restore_btn.add_theme_stylebox_override("pressed", restore_style)
	restore_btn.add_theme_color_override("font_color", Color(0.75, 0.70, 0.55))
	restore_btn.pressed.connect(func():
		StoreManager.restore_purchases()
		backdrop.queue_free()
	)
	scroll_vbox.add_child(restore_btn)

	var close_btn := Button.new()
	close_btn.text = "Close"
	close_btn.add_theme_font_size_override("font_size", 16)
	var btn_style := StyleBoxFlat.new()
	btn_style.bg_color     = Color(0.18, 0.12, 0.04, 0.90)
	btn_style.border_color = Color(0.75, 0.55, 0.22, 0.90)
	btn_style.set_border_width_all(2)
	btn_style.set_corner_radius_all(8)
	close_btn.add_theme_stylebox_override("normal",  btn_style)
	close_btn.add_theme_stylebox_override("hover",   btn_style)
	close_btn.add_theme_stylebox_override("pressed", btn_style)
	close_btn.add_theme_color_override("font_color", Color(0.97, 0.93, 0.80))
	close_btn.pressed.connect(backdrop.queue_free)
	outer_vbox.add_child(close_btn)

	backdrop.gui_input.connect(func(ev: InputEvent):
		if ev is InputEventMouseButton and (ev as InputEventMouseButton).pressed:
			backdrop.queue_free()
	)

	# Close and reopen on successful purchase so cards refresh to "Owned"
	var on_purchase_done: Callable
	var on_purchase_fail: Callable
	on_purchase_done = func(_pid: String) -> void:
		if is_instance_valid(backdrop):
			backdrop.queue_free()
			_show_store_panel()
	on_purchase_fail = func(_pid: String) -> void:
		pass  # panel stays open; user can retry or close
	StoreManager.purchase_completed.connect(on_purchase_done)
	StoreManager.purchase_failed.connect(on_purchase_fail)
	backdrop.tree_exited.connect(func() -> void:
		if StoreManager.purchase_completed.is_connected(on_purchase_done):
			StoreManager.purchase_completed.disconnect(on_purchase_done)
		if StoreManager.purchase_failed.is_connected(on_purchase_fail):
			StoreManager.purchase_failed.disconnect(on_purchase_fail)
	, CONNECT_ONE_SHOT)


func _build_store_card(product: Dictionary, backdrop: ColorRect) -> PanelContainer:
	var card := PanelContainer.new()
	var card_bg := StyleBoxFlat.new()
	card_bg.bg_color     = Color(0.10, 0.07, 0.03, 0.80)
	card_bg.border_color = Color(0.55, 0.40, 0.15, 0.60)
	card_bg.set_border_width_all(1)
	card_bg.set_corner_radius_all(8)
	card_bg.content_margin_left   = 14
	card_bg.content_margin_right  = 14
	card_bg.content_margin_top    = 12
	card_bg.content_margin_bottom = 12
	card.add_theme_stylebox_override("panel", card_bg)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 4)
	card.add_child(vbox)

	var top_row := HBoxContainer.new()
	top_row.add_theme_constant_override("separation", 8)
	vbox.add_child(top_row)

	var name_lbl := Label.new()
	name_lbl.text                 = product["name"] as String
	name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_lbl.add_theme_font_size_override("font_size", 16)
	name_lbl.add_theme_color_override("font_color", Color(0.97, 0.87, 0.60))
	top_row.add_child(name_lbl)

	var price_lbl := Label.new()
	price_lbl.text = product["price"] as String
	price_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	price_lbl.add_theme_font_size_override("font_size", 15)
	price_lbl.add_theme_color_override("font_color", Color(0.80, 0.75, 0.55))
	top_row.add_child(price_lbl)

	var desc_lbl := Label.new()
	desc_lbl.text          = product["desc"] as String
	desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc_lbl.add_theme_font_size_override("font_size", 12)
	desc_lbl.add_theme_color_override("font_color", Color(0.72, 0.67, 0.54))
	vbox.add_child(desc_lbl)

	var owned: bool      = product["owned"] as bool
	var product_id: String = product["id"] as String

	var buy_btn := Button.new()
	buy_btn.text                    = "Owned" if owned else "Buy"
	buy_btn.disabled                = owned
	buy_btn.custom_minimum_size     = Vector2(0, 34)
	buy_btn.add_theme_font_size_override("font_size", 14)

	var buy_style := StyleBoxFlat.new()
	if owned:
		buy_style.bg_color     = Color(0.10, 0.18, 0.08, 0.70)
		buy_style.border_color = Color(0.35, 0.60, 0.25, 0.70)
	else:
		buy_style.bg_color     = Color(0.16, 0.10, 0.03, 0.90)
		buy_style.border_color = Color(0.75, 0.55, 0.22, 0.90)
	buy_style.set_border_width_all(2)
	buy_style.set_corner_radius_all(8)
	buy_btn.add_theme_stylebox_override("normal",   buy_style)
	buy_btn.add_theme_stylebox_override("hover",    buy_style)
	buy_btn.add_theme_stylebox_override("pressed",  buy_style)
	buy_btn.add_theme_stylebox_override("disabled", buy_style)
	var font_color := Color(0.55, 0.75, 0.45) if owned else Color(0.97, 0.93, 0.80)
	buy_btn.add_theme_color_override("font_color",          font_color)
	buy_btn.add_theme_color_override("font_disabled_color", font_color)

	if not owned:
		StoreManager.purchase_failed.connect(func(pid: String) -> void:
			if pid == product_id and is_instance_valid(buy_btn):
				buy_btn.disabled = false
		)
		buy_btn.pressed.connect(func():
			buy_btn.disabled = true
			SoundManager.play("button_tap")
			buy_btn.pivot_offset = buy_btn.size / 2.0
			var tw := buy_btn.create_tween()
			tw.tween_property(buy_btn, "scale", Vector2(0.92, 0.92), 0.07)
			tw.tween_property(buy_btn, "scale", Vector2(1.0,  1.0),  0.10)
			StoreManager.purchase(product_id)
		)
	vbox.add_child(buy_btn)

	return card


func _show_lineage_panel() -> void:
	var history: Array = LegacyManager.get_run_history()
	if history.is_empty():
		_show_coming_soon_text("No lineage recorded yet.\n\nComplete a run to start your legacy.")
		return

	var backdrop := ColorRect.new()
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	backdrop.color        = Color(0, 0, 0, 0.72)
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(backdrop)

	var panel := PanelContainer.new()
	panel.layout_mode = 1
	panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	panel.offset_left   = 24
	panel.offset_right  = -24
	panel.offset_top    = 64
	panel.offset_bottom = -64
	var bg := StyleBoxFlat.new()
	bg.bg_color     = Color(0.07, 0.04, 0.02, 0.97)
	bg.border_color = Color(0.75, 0.55, 0.22, 0.90)
	bg.set_border_width_all(2)
	bg.set_corner_radius_all(14)
	bg.content_margin_left   = 18
	bg.content_margin_right  = 18
	bg.content_margin_top    = 18
	bg.content_margin_bottom = 18
	panel.add_theme_stylebox_override("panel", bg)
	backdrop.add_child(panel)

	var outer_vbox := VBoxContainer.new()
	outer_vbox.add_theme_constant_override("separation", 10)
	panel.add_child(outer_vbox)

	var title := Label.new()
	title.text                 = "Lineage"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 22)
	title.add_theme_color_override("font_color", Color(0.98, 0.88, 0.55))
	outer_vbox.add_child(title)
	var family_selection := preload("res://scripts/ui/perks_panel.gd").label("Choose one learned family lesson below for your next new life.", 12)
	var queued: Dictionary = LegacyManager._family_lesson
	if not queued.is_empty(): family_selection.text = "%s's %s is chosen for your next new %s life." % [queued["name"], preload("res://scripts/systems/family_legacy.gd").SKILLS[queued["skill"]]["lesson"], SpeciesDB.get_species(queued["species_id"]).get("display_name", "dinosaur")]
	outer_vbox.add_child(family_selection)

	var sep := HSeparator.new()
	sep.add_theme_color_override("color", Color(0.75, 0.55, 0.22, 0.50))
	outer_vbox.add_child(sep)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	outer_vbox.add_child(scroll)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(vbox)

	var stage_names := ["Hatchling", "Juvenile", "Sub-Adult", "Adult", "Elder"]
	var death_labels := {
		"natural":    "Natural causes",
		"starvation": "Starved",
		"predator":   "Killed by predator",
		"combat":     "Killed in combat",
		"injury":     "Died of injuries",
		"exposure":   "Died of exposure",
	}

	# Newest run first.
	for i in range(history.size() - 1, -1, -1):
		var record: Dictionary = history[i] as Dictionary
		var display: String    = record.get("display_name", record.get("species_id", "Unknown")) as String
		var stage: int         = record.get("max_stage_reached", 0) as int
		var seasons: int       = record.get("seasons", 0) as int
		var kills: int         = record.get("kills", 0) as int
		var fights: int        = record.get("fights_won", 0) as int
		var score: int         = record.get("score", 0) as int
		var death_raw: String  = record.get("death_cause", "") as String
		var death_str: String  = death_labels.get(death_raw, death_raw.capitalize()) if not death_raw.is_empty() else ""
		var stage_str: String  = stage_names[mini(stage, stage_names.size() - 1)]

		var card := PanelContainer.new()
		var card_bg := StyleBoxFlat.new()
		card_bg.bg_color     = Color(0.10, 0.07, 0.03, 0.80)
		card_bg.border_color = Color(0.55, 0.40, 0.15, 0.60)
		card_bg.set_border_width_all(1)
		card_bg.set_corner_radius_all(8)
		card_bg.content_margin_left   = 12
		card_bg.content_margin_right  = 8
		card_bg.content_margin_top    = 10
		card_bg.content_margin_bottom = 8
		card.add_theme_stylebox_override("panel", card_bg)
		vbox.add_child(card)

		var card_vbox := VBoxContainer.new()
		card_vbox.add_theme_constant_override("separation", 3)
		card.add_child(card_vbox)

		var name_lbl := Label.new()
		name_lbl.text = display
		name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		name_lbl.add_theme_font_size_override("font_size", 15)
		name_lbl.add_theme_color_override("font_color", Color(0.97, 0.87, 0.60))
		card_vbox.add_child(name_lbl)

		var stats_lbl := Label.new()
		stats_lbl.text = "%s  •  %d seasons  •  %d kills  •  %d wins" % [stage_str, seasons, kills, fights]
		stats_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		stats_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		stats_lbl.add_theme_font_size_override("font_size", 12)
		stats_lbl.add_theme_color_override("font_color", Color(0.75, 0.70, 0.58))
		card_vbox.add_child(stats_lbl)
		var story_btn := Button.new()
		story_btn.text = "Remember this life"
		story_btn.custom_minimum_size.y = 44
		story_btn.pressed.connect(_show_memorial.bind(record))
		card_vbox.add_child(story_btn)
		preload("res://scripts/ui/family_lineage_choices.gd").add_to(card_vbox, record, family_selection)

		var bottom_row := HBoxContainer.new()
		bottom_row.add_theme_constant_override("separation", 0)
		card_vbox.add_child(bottom_row)

		var death_lbl := Label.new()
		death_lbl.text = death_str
		death_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		death_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		death_lbl.add_theme_font_size_override("font_size", 11)
		death_lbl.add_theme_color_override("font_color", Color(0.60, 0.55, 0.42))
		bottom_row.add_child(death_lbl)

		var score_lbl := Label.new()
		score_lbl.text = "%d pts" % score
		score_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		score_lbl.add_theme_font_size_override("font_size", 11)
		score_lbl.add_theme_color_override("font_color", Color(0.55, 0.50, 0.38))
		bottom_row.add_child(score_lbl)

		var trash_btn := Button.new()
		trash_btn.text = "  🗑  "
		trash_btn.flat = false
		trash_btn.custom_minimum_size = Vector2(36, 28)
		var trash_style := StyleBoxFlat.new()
		trash_style.bg_color     = Color(0.18, 0.05, 0.03, 0.0)
		trash_style.border_color = Color(0.0, 0.0, 0.0, 0.0)
		trash_style.set_border_width_all(0)
		trash_style.set_corner_radius_all(6)
		var trash_hover := StyleBoxFlat.new()
		trash_hover.bg_color     = Color(0.30, 0.07, 0.04, 0.70)
		trash_hover.border_color = Color(0.70, 0.20, 0.12, 0.80)
		trash_hover.set_border_width_all(1)
		trash_hover.set_corner_radius_all(6)
		trash_btn.add_theme_stylebox_override("normal",  trash_style)
		trash_btn.add_theme_stylebox_override("pressed", trash_hover)
		trash_btn.add_theme_stylebox_override("hover",   trash_hover)
		trash_btn.add_theme_font_size_override("font_size", 14)
		var run_index := i
		trash_btn.pressed.connect(func(): _show_delete_confirm(run_index, backdrop))
		bottom_row.add_child(trash_btn)

	var close_btn := Button.new()
	close_btn.text = "Close"
	close_btn.custom_minimum_size.y = 48
	close_btn.add_theme_font_size_override("font_size", 16)
	var btn_style := StyleBoxFlat.new()
	btn_style.bg_color     = Color(0.18, 0.12, 0.04, 0.90)
	btn_style.border_color = Color(0.75, 0.55, 0.22, 0.90)
	btn_style.set_border_width_all(2)
	btn_style.set_corner_radius_all(8)
	close_btn.add_theme_stylebox_override("normal",  btn_style)
	close_btn.add_theme_stylebox_override("hover",   btn_style)
	close_btn.add_theme_stylebox_override("pressed", btn_style)
	close_btn.add_theme_color_override("font_color", Color(0.97, 0.93, 0.80))
	close_btn.pressed.connect(backdrop.queue_free)
	outer_vbox.add_child(close_btn)

	backdrop.gui_input.connect(func(ev: InputEvent):
		if ev is InputEventMouseButton and (ev as InputEventMouseButton).pressed:
			backdrop.queue_free()
	)


func _show_memorial(record: Dictionary) -> void:
	var view := MEMORIAL_VIEW.instantiate()
	add_child(view)
	view.show_record(record)


func _show_delete_confirm(run_index: int, lineage_backdrop: ColorRect) -> void:
	var confirm_bg := ColorRect.new()
	confirm_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	confirm_bg.color        = Color(0, 0, 0, 0.55)
	confirm_bg.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(confirm_bg)

	var panel := PanelContainer.new()
	panel.layout_mode = 1
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.offset_left   = -155
	panel.offset_right  =  155
	panel.offset_top    = -90
	panel.offset_bottom =  90
	var bg := StyleBoxFlat.new()
	bg.bg_color     = Color(0.09, 0.04, 0.02, 0.98)
	bg.border_color = Color(0.72, 0.22, 0.12, 0.90)
	bg.set_border_width_all(2)
	bg.set_corner_radius_all(12)
	bg.content_margin_left   = 20
	bg.content_margin_right  = 20
	bg.content_margin_top    = 20
	bg.content_margin_bottom = 20
	panel.add_theme_stylebox_override("panel", bg)
	confirm_bg.add_child(panel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	panel.add_child(vbox)

	var title_lbl := Label.new()
	title_lbl.text                 = "Delete this run?"
	title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_lbl.add_theme_font_size_override("font_size", 17)
	title_lbl.add_theme_color_override("font_color", Color(0.97, 0.87, 0.60))
	vbox.add_child(title_lbl)

	var sub_lbl := Label.new()
	sub_lbl.text                 = "This cannot be undone."
	sub_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub_lbl.add_theme_font_size_override("font_size", 13)
	sub_lbl.add_theme_color_override("font_color", Color(0.65, 0.58, 0.44))
	vbox.add_child(sub_lbl)

	var btn_row := HBoxContainer.new()
	btn_row.add_theme_constant_override("separation", 14)
	btn_row.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_child(btn_row)

	var cancel_style := StyleBoxFlat.new()
	cancel_style.bg_color     = Color(0.15, 0.10, 0.03, 0.90)
	cancel_style.border_color = Color(0.75, 0.55, 0.22, 0.90)
	cancel_style.set_border_width_all(2)
	cancel_style.set_corner_radius_all(8)

	var cancel_btn := Button.new()
	cancel_btn.text = "Cancel"
	cancel_btn.custom_minimum_size = Vector2(100, 0)
	cancel_btn.add_theme_font_size_override("font_size", 15)
	cancel_btn.add_theme_stylebox_override("normal",  cancel_style)
	cancel_btn.add_theme_stylebox_override("hover",   cancel_style)
	cancel_btn.add_theme_stylebox_override("pressed", cancel_style)
	cancel_btn.add_theme_color_override("font_color", Color(0.97, 0.93, 0.80))
	cancel_btn.pressed.connect(confirm_bg.queue_free)
	btn_row.add_child(cancel_btn)

	var delete_style := StyleBoxFlat.new()
	delete_style.bg_color     = Color(0.22, 0.05, 0.03, 0.90)
	delete_style.border_color = Color(0.78, 0.22, 0.12, 0.90)
	delete_style.set_border_width_all(2)
	delete_style.set_corner_radius_all(8)

	var delete_btn := Button.new()
	delete_btn.text = "Delete"
	delete_btn.custom_minimum_size = Vector2(100, 0)
	delete_btn.add_theme_font_size_override("font_size", 15)
	delete_btn.add_theme_stylebox_override("normal",  delete_style)
	delete_btn.add_theme_stylebox_override("hover",   delete_style)
	delete_btn.add_theme_stylebox_override("pressed", delete_style)
	delete_btn.add_theme_color_override("font_color", Color(1.0, 0.75, 0.70))
	delete_btn.pressed.connect(func():
		LegacyManager.delete_run(run_index)
		confirm_bg.queue_free()
		lineage_backdrop.queue_free()
		_show_lineage_panel()
	)
	btn_row.add_child(delete_btn)


func _on_story() -> void:
	get_tree().change_scene_to_file("res://scenes/story/story_select.tscn")


func _show_coming_soon_text(body_text: String) -> void:
	var backdrop := ColorRect.new()
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	backdrop.color        = Color(0, 0, 0, 0.60)
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(backdrop)

	var panel := PanelContainer.new()
	panel.layout_mode = 1
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.offset_left   = -170
	panel.offset_right  =  170
	panel.offset_top    = -90
	panel.offset_bottom =  90
	var bg := StyleBoxFlat.new()
	bg.bg_color     = Color(0.08, 0.05, 0.02, 0.97)
	bg.border_color = Color(0.75, 0.55, 0.22, 0.90)
	bg.set_border_width_all(2)
	bg.set_corner_radius_all(14)
	bg.content_margin_left   = 20
	bg.content_margin_right  = 20
	bg.content_margin_top    = 20
	bg.content_margin_bottom = 20
	panel.add_theme_stylebox_override("panel", bg)
	backdrop.add_child(panel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 14)
	panel.add_child(vbox)

	var body := Label.new()
	body.text                 = body_text
	body.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	body.autowrap_mode        = TextServer.AUTOWRAP_WORD_SMART
	body.add_theme_font_size_override("font_size", 15)
	body.add_theme_color_override("font_color", Color(0.85, 0.78, 0.62))
	vbox.add_child(body)

	var close_btn := Button.new()
	close_btn.text = "Close"
	close_btn.add_theme_font_size_override("font_size", 15)
	var btn_style := StyleBoxFlat.new()
	btn_style.bg_color     = Color(0.18, 0.12, 0.04, 0.90)
	btn_style.border_color = Color(0.75, 0.55, 0.22, 0.90)
	btn_style.set_border_width_all(2)
	btn_style.set_corner_radius_all(8)
	close_btn.add_theme_stylebox_override("normal",  btn_style)
	close_btn.add_theme_stylebox_override("hover",   btn_style)
	close_btn.add_theme_stylebox_override("pressed", btn_style)
	close_btn.add_theme_color_override("font_color", Color(0.97, 0.93, 0.80))
	close_btn.pressed.connect(backdrop.queue_free)
	vbox.add_child(close_btn)

	backdrop.gui_input.connect(func(ev: InputEvent):
		if ev is InputEventMouseButton and (ev as InputEventMouseButton).pressed:
			backdrop.queue_free()
	)


func _style_buttons() -> void:
	LAYOUT.style_buttons(self)
