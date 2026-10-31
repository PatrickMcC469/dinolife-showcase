extends Control

const ActionCard         = preload("res://scenes/ui/action_card.tscn")
const StatBarScene       = preload("res://scenes/ui/stat_bar.tscn")
const SettingsPanelScene = preload("res://scenes/ui/settings_panel.tscn")
const COMPANIONS = preload("res://scripts/systems/companions.gd")
const JOURNEYS = preload("res://scripts/systems/journeys.gd")
const FEEDBACK = preload("res://scripts/systems/action_feedback.gd")
const LEADERSHIP = preload("res://scripts/systems/pack_leadership.gd")
const AD_REWARDS = preload("res://scripts/systems/rewarded_actions.gd")

# ── Nodes defined in game_screen.tscn ────────────────────────────────────────
# Adjust anchor values in the editor to align each node with its baked PNG slot.
@onready var dino_image: TextureRect          = $DinoPanel/DinoImage
@onready var season_label: Label              = $SeasonLabel
@onready var next_season_btn: Button          = $NextSeasonBtn
@onready var year_label: Label                = $RunLabel
@onready var stage_label: Label               = $AgeLabel
@onready var _health_holder: Control          = $HealthBarHolder
@onready var _hunger_holder: Control          = $HungerBarHolder
@onready var _bond_holder: Control            = $BondBarHolder
@onready var cards_container: VBoxContainer   = $ActionScroll/ActionList/ActionMargin/CardsContainer
@onready var injury_section: VBoxContainer    = $InjurySection
@onready var tab_kills: Button                = $TabsRow/TabKills
@onready var tab_fights: Button               = $TabsRow/TabFights
@onready var tab_bonuses: Button              = $TabsRow/TabBonuses
@onready var settings_btn: Button             = $SettingsBtn
@onready var event_overlay                    = $EventOverlay
@onready var companions_panel: PanelContainer = $ActionScroll/ActionList/Companions

var _stat_bars: Dictionary = {}
var _waiting_for_choice: bool = false
var _action_context: String = ""
var _age_up_active: bool = false
var _queued_events: Array = []
var _tutorial_queue: Array = []
var _bonuses_overlay: Control = null
var _dashboard: Node = null


func _exit_tree() -> void:
	SoundManager.stop_combat_loop()

const PREDATOR_ACTIONS = [
	{ "action_id": "hunt",      "icon": "🥩", "title": "Hunt",             "subtitle": "Search for prey nearby",         "max_uses": 3 },
	{ "action_id": "scavenge",  "icon": "🦴", "title": "Scavenge",         "subtitle": "Look for abandoned kills",        "max_uses": 2 },
	{ "action_id": "rest",      "icon": "💤", "title": "Rest",              "subtitle": "Recover your strength",          "max_uses": 2 },
	{ "action_id": "territory", "icon": "🌿", "title": "Mark Territory",    "subtitle": "Reinforce your claim",           "max_uses": 1 },
	{ "action_id": "sharpen",   "icon": "🦷", "title": "Refine Technique",  "subtitle": "Practice hunting precision",     "max_uses": 1 },
	{ "action_id": "water",     "icon": "💧", "title": "Find Water",        "subtitle": "Locate a water source",          "max_uses": 1 },
	{ "action_id": "bond",      "icon": "🫂", "title": "Strengthen Bond",   "subtitle": "Reinforce your pack connection", "max_uses": 1 },
	{ "action_id": "tend",      "icon": "🩹", "title": "Tend Wounds",       "subtitle": "Care for your injuries",         "max_uses": 1 },
	{ "action_id": "nest_tend", "icon": "🥚", "title": "Tend Nest",         "subtitle": "Spend time with your young",     "max_uses": 1 },
	{ "action_id": "find_pack", "icon": "👥", "title": "Find Pack",         "subtitle": "Look for others to run with",   "max_uses": 2 },
]

const HERBIVORE_ACTIONS = [
	{ "action_id": "graze",     "icon": "🌿", "title": "Graze",             "subtitle": "Feed on nearby vegetation",      "max_uses": 3 },
	{ "action_id": "scavenge",  "icon": "🍂", "title": "Forage",            "subtitle": "Search further for food",        "max_uses": 2 },
	{ "action_id": "rest",      "icon": "💤", "title": "Rest",              "subtitle": "Recover your strength",          "max_uses": 2 },
	{ "action_id": "territory", "icon": "🌾", "title": "Mark Range",        "subtitle": "Establish your feeding ground",  "max_uses": 1 },
	{ "action_id": "sharpen",   "icon": "🦏", "title": "Harden Defenses",   "subtitle": "Condition hooves, horns, hide",  "max_uses": 1 },
	{ "action_id": "water",     "icon": "💧", "title": "Find Water",        "subtitle": "Locate a water source",          "max_uses": 1 },
	{ "action_id": "bond",      "icon": "🫂", "title": "Reinforce the Herd","subtitle": "Strengthen your herd connection","max_uses": 1 },
	{ "action_id": "tend",      "icon": "🩹", "title": "Tend Wounds",       "subtitle": "Care for your injuries",         "max_uses": 1 },
	{ "action_id": "nest_tend", "icon": "🥚", "title": "Tend Nest",         "subtitle": "Spend time with your young",     "max_uses": 1 },
	{ "action_id": "find_herd", "icon": "👥", "title": "Find Herd",         "subtitle": "Look for others of your kind",  "max_uses": 2 },
]

const FLYER_ACTIONS = [
	{ "action_id": "hunt",        "icon": "🐟", "title": "Hunt",            "subtitle": "Dive for prey below",            "max_uses": 3 },
	{ "action_id": "scavenge",    "icon": "🦴", "title": "Scavenge",        "subtitle": "Circle for anything left behind", "max_uses": 2 },
	{ "action_id": "rest",        "icon": "💤", "title": "Roost",           "subtitle": "Rest on a high perch",           "max_uses": 2 },
	{ "action_id": "territory",   "icon": "🌬", "title": "Claim Thermals",  "subtitle": "Establish your flight corridor",  "max_uses": 1 },
	{ "action_id": "sharpen",     "icon": "🪶", "title": "Glide Practice",  "subtitle": "Refine speed and maneuverability","max_uses": 1 },
	{ "action_id": "water",       "icon": "💧", "title": "Scout Water",     "subtitle": "Search rivers from above",       "max_uses": 1 },
	{ "action_id": "tend",        "icon": "🩹", "title": "Tend Wounds",     "subtitle": "Care for your injuries",         "max_uses": 1 },
	{ "action_id": "nest_tend",   "icon": "🥚", "title": "Tend Nest",       "subtitle": "Spend time with your young",     "max_uses": 1 },
	{ "action_id": "find_colony", "icon": "👥", "title": "Find Colony",     "subtitle": "Search for a roosting group",    "max_uses": 2 },
]


func _ready() -> void:
	event_overlay.visible = false  # hidden until show_event() is called
	$AlphaBadge.gui_input.connect(_on_alpha_badge_input)
	_build_stat_bars()
	_build_action_cards()
	_connect_signals()
	_connect_tabs()
	_dashboard = preload("res://scripts/ui/gameplay_dashboard.gd").new()
	add_child(_dashboard)
	_dashboard.setup(self)
	_refresh_info_labels()
	_update_dino_image()
	SoundManager.play_music()
	if GameState.seasons_elapsed == 0:
		_maybe_show_tutorial()
	var pending := JOURNEYS.pending_event()
	if pending.is_empty():
		pending = preload("res://scripts/systems/living_world.gd").pending_event()
	if pending.is_empty():
		pending = COMPANIONS.pending_event()
	if pending.is_empty():
		pending = preload("res://scripts/systems/discoveries.gd").pending_event()
	if pending.is_empty():
		pending = preload("res://scripts/systems/pack_relationships.gd").pending_event()
	if pending.is_empty(): pending = preload("res://scripts/systems/pack_story_events.gd").pending_event()
	if pending.is_empty(): pending = preload("res://scripts/systems/family_legacy.gd").pending_event()
	if not pending.is_empty():
		_on_event_ready.call_deferred(pending)


# ── STAT BARS ────────────────────────────────────────────────────────────────

func _on_alpha_badge_input(event: InputEvent) -> void:
	if event_overlay.visible or _waiting_for_choice:
		return
	if (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT) or (event is InputEventScreenTouch and event.pressed):
		_on_action_pressed("leadership")


# Holders are placed in the tscn and draggable in the editor.
# We instantiate the actual ProgressBar into each holder here.

func _build_stat_bars() -> void:
	var pairs := [
		["health",    _health_holder],
		["hunger",    _hunger_holder],
		["pack_bond", _bond_holder],
	]
	for pair in pairs:
		var key: String     = pair[0]
		var holder: Control = pair[1]
		var bar = StatBarScene.instantiate()
		bar.set_anchors_preset(Control.PRESET_FULL_RECT)
		bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
		holder.mouse_filter = Control.MOUSE_FILTER_STOP
		var captured_key := key
		holder.gui_input.connect(func(ev: InputEvent) -> void:
			if ev is InputEventScreenTouch and ev.pressed:
				_show_stat_info(captured_key)
			elif ev is InputEventMouseButton and (ev as InputEventMouseButton).pressed:
				_show_stat_info(captured_key)
		)
		holder.add_child(bar)
		_stat_bars[key] = bar
	_on_stat_changed()


func _show_stat_info(stat_key: String) -> void:
	var priority: Array = []
	match stat_key:
		"health":
			priority = ["rest", "water", "tend", "ad_health"]
		"hunger":
			priority = ["hunt", "graze", "scavenge", "water", "ad_hunger"]
		"pack_bond":
			priority = ["bond", "find_pack", "find_herd", "find_colony", "ad_bond"]

	var insert_index := 0
	for aid in priority:
		for i in range(cards_container.get_child_count()):
			var card = cards_container.get_child(i)
			if "action_id" in card and card.action_id == aid and card.visible:
				cards_container.move_child(card, insert_index)
				insert_index += 1
				break

	$ActionScroll.scroll_vertical = 0


# ── POPUPS ───────────────────────────────────────────────────────────────────

func _show_hatchling_intro() -> void:
	# Pick a random eligible start event for this species and show it.
	var path := "res://scripts/dinos/%s/dino_start.gd" % GameState.species_id
	var events: Array = []
	if ResourceLoader.exists(path):
		var script = load(path)
		var node   = Node.new()
		node.set_script(script)
		events = node.get_eligible_events()
		node.free()
	if events.is_empty():
		return
	var raw: Dictionary = events[randi() % events.size()]
	# Convert dino_start format to event_overlay format.
	# Each choice's "stat" field becomes the action id for resolution.
	var choices: Array = []
	for c in raw.get("choices", []):
		var stat: String = c.get("stat", "neutral")
		choices.append({
			"action":   stat,
			"label":    c.get("label", "") as String,
			"sublabel": _stat_sublabel(stat),
		})
	_waiting_for_choice   = true
	next_season_btn.disabled = true
	_action_context       = "hatchling_start"
	event_overlay.show_event({
		"title":   raw.get("title",  ""),
		"flavor":  raw.get("flavor", ""),
		"type":    "hatchling_start",
		"choices": choices,
	})


func _stat_sublabel(stat: String) -> String:
	match stat:
		"permanent_strength_mod": return "+Strength"
		"permanent_speed_mod":    return "+Speed"
		"permanent_defense_mod":  return "+Defense"
		"permanent_health_mod":   return "+Health"
	return ""


# ── REWARDED AD CARDS ────────────────────────────────────────────────────────

const AD_CARDS := [
	{ "action_id": "ad_health",   "icon": "▶", "title": "Boost Health",          "subtitle": "Watch an ad: +8% health, up to 100%",              "max_uses": 999 },
	{ "action_id": "ad_hunger",   "icon": "▶", "title": "Boost Food",            "subtitle": "Watch an ad: +8% food, up to 100%",                "max_uses": 999 },
	{ "action_id": "ad_bond",     "icon": "▶", "title": "Boost Pack Bond",       "subtitle": "Watch an ad: +8% bond, up to 100%",                "max_uses": 999 },
	{ "action_id": "ad_training", "icon": "▶", "title": "Extra Training",       "subtitle": "Watch an ad: train once more this season",         "max_uses": 999 },
	{ "action_id": "ad_heal",     "icon": "▶", "title": "Heal Faster",           "subtitle": "Watch an ad: heal 2 seasons sooner per injury",    "max_uses": 999 },
]


func _handle_ad_action(action_id: String) -> void:
	if _waiting_for_choice or event_overlay.visible: return
	if not AD_REWARDS.available(action_id):
		event_overlay.show_event(AD_REWARDS.notice("Reward unavailable", "This benefit is not needed or has already been used this season. Nothing changed."))
		return
	var earned := {"result": {}}
	_waiting_for_choice = true
	next_season_btn.disabled = true
	_action_context = ""
	var started := AdManager.show_rewarded(func():
		earned["result"] = AD_REWARDS.grant(action_id)
	, func(status: String):
		var result: Dictionary = earned["result"]
		if status != "earned":
			result = AD_REWARDS.notice("No reward received", "The ad could not play. Nothing changed. Try again later." if status == "failed" else "The ad ended before a reward was earned. Nothing changed.")
		event_overlay.show_event(result)
		_on_stat_changed()
	)
	if not started:
		_waiting_for_choice = false
		next_season_btn.disabled = false
		event_overlay.show_event(AD_REWARDS.notice("Ad unavailable", "No reward ad is ready right now. Nothing changed. Try again later."))
	_refresh_cards()


# ── TUTORIAL ─────────────────────────────────────────────────────────────────

func _maybe_show_tutorial() -> void:
	if not GameState.show_tutorial:
		TurnManager.start_turn()
		return
	# Only show once — clear the flag so reloading the run doesn't repeat it.
	GameState.show_tutorial = false
	_tutorial_queue = [
		{
			"title":   "How It Works",
			"flavor":  "Each season an event will appear first. Read it carefully — it may carry a warning, an opportunity, or a choice that matters.\n\nOnce the event is dismissed, you will see your available actions. Pick one and then advance the season.",
			"type":    "info",
			"choices": [{ "action": "_tutorial_next", "label": "Got it" }],
		},
		{
			"title":   "Your Three Bars",
			"flavor":  "Health: If it reaches zero, your life ends.\n\nFood: Low food weakens you. Feed regularly.\n\nBond: As a hatchling, this measures your connection to your parents.",
			"type":    "info",
			"choices": [{ "action": "_tutorial_next", "label": "Understood" }],
		},
		{
			"title":   "The Hatchling Years",
			"flavor":  "You begin as a hatchling under the protection of your parents. For now you will experience narrative events as you grow — the action list is shown below but locked until you are old enough to act on your own.\n\nChoose wisely. The traits you build in these early seasons can give you the start you need.",
			"type":    "info",
			"choices": [{ "action": "_tutorial_next", "label": "I'm ready" }],
		},
	]
	_show_next_tutorial()


func _show_next_tutorial() -> void:
	if _tutorial_queue.is_empty():
		TurnManager.start_turn()
		return
	var ev: Dictionary = _tutorial_queue.pop_front()
	_action_context = "_tutorial"
	event_overlay.show_event(ev)


func _resolve_hatchling_start(stat: String) -> void:
	_waiting_for_choice      = false
	next_season_btn.disabled = false
	_action_context          = ""
	match stat:
		"permanent_strength_mod": GameState.strength = minf(GameState.strength + 0.04, 1.0)
		"permanent_speed_mod":    GameState.speed    = minf(GameState.speed    + 0.04, 1.0)
		"permanent_defense_mod":  GameState.defense  = minf(GameState.defense  + 0.04, 1.0)
		"permanent_health_mod":   GameState.health   = minf(GameState.health   + 0.04, 1.0)
	_on_stat_changed()
	_flush_next_queued()


func _show_age_up_popup(stage: int) -> void:
	var path := "res://scripts/dinos/%s/dino_ageup.gd" % GameState.species_id
	var event_data := {}
	if ResourceLoader.exists(path):
		var script = load(path)
		var node   = Node.new()
		node.set_script(script)
		event_data = node.get_ageup(stage)
		node.free()
	if event_data.is_empty():
		_flush_age_up()
		return
	var raw_choices: Array = event_data.get("choices", [])
	var choices: Array = []
	for c in raw_choices.slice(0, 4):
		choices.append({ "action": "age_up_ack", "label": c.get("label", "") })
	_waiting_for_choice      = true
	next_season_btn.disabled = true
	_action_context          = "age_up"
	event_overlay.show_event({
		"title":   event_data.get("title", ""),
		"flavor":  event_data.get("body",  ""),
		"type":    "age_up",
		"choices": choices,
	})


func _flush_next_queued() -> void:
	if _queued_events.is_empty() or _age_up_active or _waiting_for_choice:
		return
	var next_event: Dictionary = _queued_events.pop_front()
	_on_event_ready(next_event)


func _flush_age_up() -> void:
	_age_up_active = false
	next_season_btn.disabled = false
	var queued := _queued_events.duplicate()
	_queued_events.clear()
	for event in queued:
		_on_event_ready(event)


# ── SIGNALS ──────────────────────────────────────────────────────────────────

func _connect_signals() -> void:
	TurnManager.stat_changed.connect(_on_stat_changed)
	TurnManager.turn_started.connect(_on_turn_started)
	TurnManager.life_stage_changed.connect(_on_life_stage_changed)
	TurnManager.event_fired.connect(_on_event_ready)
	TurnManager.run_ended.connect(_on_run_ended)
	EventManager.world_flavor_ready.connect(_on_world_flavor)
	EventManager.event_ready.connect(_on_event_ready)
	PackManager.pack_disbanded.connect(_on_pack_disbanded)
	event_overlay.choice_made.connect(_on_choice_made)
	next_season_btn.pressed.connect(_on_next_season)
	settings_btn.pressed.connect(_on_settings_pressed)


func _connect_tabs() -> void:
	tab_kills.pressed.connect(_show_unlock_paths)
	tab_bonuses.pressed.connect(func(): _show_stats_popup("bonuses"))
	_refresh_stat_labels()


func _show_unlock_paths() -> void:
	if _waiting_for_choice or _age_up_active or event_overlay.visible:
		return
	var targets := UnlockManager.get_unlockable_from(GameState.species_id)
	if targets.is_empty():
		return
	var target: String = targets[0]
	event_overlay.show_event({"type": "info", "title": "Unlock paths", "choices": [],
		"flavor": UnlockManager.progress_text(target, UnlockManager.get_progress_for(target, UnlockManager.live_record()))})


# ── ACTION CARDS ─────────────────────────────────────────────────────────────

func _build_action_cards() -> void:
	for child in cards_container.get_children():
		child.queue_free()
	var is_hatchling := GameState.life_stage == 0
	var species     = SpeciesDB.get_species(GameState.species_id)
	var tree        = species.get("tree", "predator")
	var action_list = PREDATOR_ACTIONS
	if tree == "herbivore":
		action_list = HERBIVORE_ACTIONS
	elif tree == "flyer":
		action_list = FLYER_ACTIONS
	action_list = action_list.duplicate()
	for action_data in action_list:
		var card = ActionCard.instantiate()
		cards_container.add_child(card)
		card.setup(action_data)
		card.card_pressed.connect(_on_action_pressed)
		# Hide nest_tend until the player actually has young.
		if action_data["action_id"] == "nest_tend" and not GameState.has_young:
			card.visible = false
		# Hatchlings see all cards disabled. Otherwise disable ineligible actions.
		elif is_hatchling or _should_disable_action(action_data["action_id"]):
			card.disabled = true

	# Ad cards — appended at bottom, visibility managed in _refresh_cards
	for ad_data in AD_CARDS:
		var card = ActionCard.instantiate()
		cards_container.add_child(card)
		card.setup(ad_data)
		card.card_pressed.connect(_on_action_pressed)
		card.visible = false  # hidden until _refresh_cards enables them


# Returns true when an action should be shown greyed out (not usable right now).
func _should_disable_action(action_id: String) -> bool:
	var species := SpeciesDB.get_species(GameState.species_id)
	match action_id:
		"family":
			return not preload("res://scripts/systems/family_legacy.gd").available()
		"home":
			return not preload("res://scripts/systems/living_world.gd").available()
		"leadership":
			return not LEADERSHIP.available()
		"tend":
			return GameState.injuries.is_empty()
		"nest_tend":
			return not GameState.has_young
		"bond":
			# Can only reinforce a bond that already exists.
			return not (species.get("pack_species", false) and GameState.pack_bond > 0.0)
		"find_pack", "find_herd", "find_colony":
			# Show but disable if already in a group, or not a pack species, or too young.
			return not species.get("pack_species", false) \
				or GameState.pack_bond > 0.0 \
				or GameState.life_stage < 1
		"territory", "sharpen":
			return GameState.life_stage < 1
		"scavenge":
			if species.get("tree", "") == "herbivore":
				return GameState.life_stage < 1
	return false


# ── ACTION HANDLING ──────────────────────────────────────────────────────────

func _on_action_pressed(action_id: String) -> void:
	if _waiting_for_choice or (is_instance_valid(_dashboard) and _dashboard.blocking_view_open()):
		return
	SoundManager.play("button_tap")
	if action_id == "family":
		_dashboard._show_family()
		return
	if action_id == "home":
		_dashboard._show_map()
		return
	if action_id.begins_with("ad_"):
		_handle_ad_action(action_id)
		return
	if action_id not in ["leadership", "home"]:
		GameState.record_action_use(action_id)
	_refresh_cards()
	_action_context = action_id
	var event = EventManager.get_action_event(action_id)
	if not event.is_empty() and event.get("choices", []).size() > 0:
		_waiting_for_choice = true
		next_season_btn.disabled = true
		_action_context = event.get("next_context", action_id)
		event_overlay.show_event(event)
	else:
		var result = ActionResolver.resolve(action_id, "")
		if result.get("choices", []).size() > 0:
			_waiting_for_choice = true
			next_season_btn.disabled = true
			_action_context = result.get("next_context", action_id)
			event_overlay.show_event(result)
		elif result.get("flavor", "") != "":
			event_overlay.show_event(result)
		_on_stat_changed()


func _on_map_choice(action: String) -> void:
	if not _dashboard.map_view.visible or _waiting_for_choice or event_overlay.visible: return
	_dashboard.map_view.hide()
	var result := ActionResolver.resolve("home", action)
	if result.get("choices", []).size() > 0:
		result["resolve_key"] = "home"
	_on_event_ready(result)
	_on_stat_changed()


func _on_pair_care(a: String, b: String) -> void:
	if not _dashboard.relations_view.visible or _waiting_for_choice or event_overlay.visible: return
	var event := preload("res://scripts/systems/pack_relationships.gd").event(a, b)
	if not event.is_empty(): _on_event_ready(event)


func _on_family_lesson(child_name: String) -> void:
	if not _dashboard.family_view.visible or _waiting_for_choice or event_overlay.visible: return
	var event := preload("res://scripts/systems/family_legacy.gd").event(child_name)
	if not event.is_empty(): _on_event_ready(event)


func _fire_egg_hatch_event() -> void:
	var path := "res://scripts/dinos/%s/dino_egg_hatch.gd" % GameState.species_id
	var event := {}
	if ResourceLoader.exists(path):
		var script = load(path)
		var node   = Node.new()
		node.set_script(script)
		event = node.get_egg_hatch_event()
		node.free()
	if event.is_empty():
		# Generic fallback
		var base_path := "res://scripts/dinos/base_dino_egg_hatch.gd"
		var bscript = load(base_path)
		var bnode   = Node.new()
		bnode.set_script(bscript)
		event = bnode.get_egg_hatch_event()
		bnode.free()
	_waiting_for_choice   = true
	next_season_btn.disabled = true
	_action_context       = "egg_hatch"
	event_overlay.show_event(event)


func _resolve_egg_hatch(choice: String) -> void:
	_waiting_for_choice      = false
	next_season_btn.disabled = false
	_action_context          = ""
	match choice:
		"hatch_bold":     GameState.strength  = minf(GameState.strength  + 0.08, 1.0)
		"hatch_swift":    GameState.speed     = minf(GameState.speed     + 0.08, 1.0)
		"hatch_cautious": GameState.defense   = minf(GameState.defense   + 0.08, 1.0)
		"hatch_curious":  GameState.type_stat = minf(GameState.type_stat + 0.08, 1.0)
	_on_stat_changed()
	_flush_next_queued()


func _on_choice_made(choice: String) -> void:
	if choice == "_tutorial_next":
		_action_context = ""
		_show_next_tutorial()
		return
	if choice == "ok":
		# Generic dismiss from an info popup — just unlock the UI.
		_waiting_for_choice      = false
		next_season_btn.disabled = false
		if _action_context == "age_up":
			# Safety: age_up popup emitted "ok" instead of "age_up_ack" (empty choices).
			# Must still flush age_up so queued events aren't lost forever.
			_action_context = ""
			_flush_age_up()
		else:
			_action_context = ""
			_flush_next_queued()
		return
	if _action_context == "egg_hatch":
		_resolve_egg_hatch(choice)
		return
	if _action_context == "hatchling_start":
		_resolve_hatchling_start(choice)
		return
	if _action_context == "age_up":
		_waiting_for_choice = false
		_action_context     = ""
		_flush_age_up()
		return
	if _action_context == "elder_victory":
		_waiting_for_choice      = false
		next_season_btn.disabled = false
		_action_context          = ""
		if choice == "end_run":
			GameState.death_cause = "elder_glory"
			TurnManager.run_ended.emit()
		else:
			_flush_next_queued()
		return
	var result = ActionResolver.resolve(_action_context, choice)
	_on_stat_changed()
	var next_ctx = result.get("next_context", "")
	if next_ctx != "" and result.get("choices", []).size() > 0:
		_action_context = next_ctx
		event_overlay.show_event(result)
	else:
		_waiting_for_choice = false
		next_season_btn.disabled = false
		_action_context = ""
		if result.get("flavor", "") != "":
			event_overlay.show_event(result)
		else:
			_flush_next_queued()


func _on_next_season() -> void:
	if _waiting_for_choice or (is_instance_valid(_dashboard) and _dashboard.blocking_view_open()):
		return
	GameState.save_run()
	TurnManager.end_turn()


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_WM_GO_BACK_REQUEST:
		GameState.save_run()


# ── TURN / STATE CALLBACKS ───────────────────────────────────────────────────

func _on_turn_started() -> void:
	_refresh_info_labels()
	_refresh_cards()
	_update_dino_image()
	if GameState.life_stage == 0:
		if GameState.seasons_elapsed == 0:
			_fire_egg_hatch_event()   # very first moment of existence
		else:
			_show_hatchling_intro()   # subsequent egg seasons


func _on_stat_changed() -> void:
	companions_panel.refresh()
	$AlphaBadge.visible = LEADERSHIP.available() and GameState.is_alpha
	_refresh_stat_labels()
	for stat_key in _stat_bars:
		var val: float
		match stat_key:
			"pack_bond": val = clampf(GameState.pack_bond, 0.0, 1.0)
			_:           val = clampf(float(GameState.get(stat_key)), 0.0, 1.0)
		_stat_bars[stat_key].set_value_normalized(val)
	_refresh_injury_bar()
	# Re-evaluate card availability whenever stats change — injuries may have
	# appeared or cleared mid-season, which affects the Tend Wounds card.
	_refresh_cards()
	_check_live_unlocks()


func _check_live_unlocks() -> void:
	var live_record := UnlockManager.live_record()
	var newly_unlocked: Array = UnlockManager.check_and_unlock(live_record)
	for sid in newly_unlocked:
		var display_name: String = SpeciesDB.get_species(sid).get("display_name", sid)
		var notice := {
			"type":    "result",
			"title":   "New Dino Unlocked!",
			"flavor":  "%s is now available to play." % display_name,
			"feedback": FEEDBACK.milestone("New dinosaur available"),
			"choices": [],
		}
		if _age_up_active or _waiting_for_choice:
			_queued_events.append(notice)
		else:
			event_overlay.show_event(notice)


func _refresh_injury_bar() -> void:
	if is_instance_valid(_dashboard):
		_dashboard.refresh()


func _on_injury_tapped(injury: Dictionary) -> void:
	var stat: String = injury.get("stat", "")
	var stat_label: String
	match stat:
		"strength": stat_label = "Strength"
		"defense":  stat_label = "Defense"
		"speed":    stat_label = "Speed"
		"stamina":  stat_label = "Stamina"
		_:          stat_label = "Health"
	var pct := int(injury.get("amount", 0.0) * 100)
	var duration: String
	if injury.get("permanent", false):
		duration = "Permanent. Will not heal on its own."
	else:
		var t: int = injury.get("turns_remaining", 0)
		duration = "%d season%s remaining." % [t, "s" if t != 1 else ""]
	var detail := "%s\n\nAffects: %s (-%d%%)\n%s" % [
		injury.get("name", "Unknown Injury"), stat_label, pct, duration
	]
	event_overlay.show_event({
		"title": injury.get("name", "Injury"),
		"flavor": detail,
		"choices": [],
	})


func _on_life_stage_changed(stage: int) -> void:
	_refresh_info_labels()
	_build_action_cards()
	$ActionScroll.scroll_vertical = 0
	_update_dino_image()
	_age_up_active = true
	_maybe_queue_parents_leave(stage)
	_check_live_unlocks()
	call_deferred("_show_age_up_popup", stage)


func _maybe_queue_parents_leave(stage: int) -> void:
	var species = SpeciesDB.get_species(GameState.species_id)
	if species.get("leaves_at_stage", -1) != stage:
		return
	var path = "res://scripts/dinos/%s/dino_leave.gd" % GameState.species_id
	if not ResourceLoader.exists(path):
		return
	var script = load(path)
	var node   = Node.new()
	node.set_script(script)
	var event: Dictionary = node.get_leave_event()
	node.free()
	if not event.is_empty():
		_queued_events.append(event)


func _on_world_flavor(text: String) -> void:
	# Route ambient flavor through the event overlay (no dedicated label needed).
	if text.strip_edges() != "":
		event_overlay.show_event({ "type": "result", "flavor": text, "choices": [] })


func _on_event_ready(event_data: Dictionary) -> void:
	if event_data.get("resolve_key", "") in ["family", "pack_story"]:
		event_data = preload("res://scripts/systems/family_legacy.gd").pending_event() if event_data["resolve_key"] == "family" else preload("res://scripts/systems/pack_story_events.gd").pending_event()
		if event_data.is_empty(): return
	if event_data.get("resolve_key", "") == "pack_relations":
		event_data = preload("res://scripts/systems/pack_relationships.gd").pending_event()
		if event_data.is_empty(): return
	if event_data.get("resolve_key", "") == "living":
		event_data = preload("res://scripts/systems/living_world.gd").pending_event()
		if event_data.is_empty():
			return
	if event_data.get("resolve_key", "") == "discovery":
		event_data = preload("res://scripts/systems/discoveries.gd").pending_event()
		if event_data.is_empty():
			return
	if event_data.get("resolve_key", "") == "journey":
		event_data = JOURNEYS.pending_event()
		if event_data.is_empty():
			return
	if event_data.get("resolve_key", "") == "companions":
		event_data = COMPANIONS.pending_event()
		if event_data.is_empty():
			return
	if _age_up_active or _waiting_for_choice:
		_queued_events.append(event_data)
		return
	if is_instance_valid(_dashboard):
		_dashboard.close_views()
	if event_data.get("choices", []).size() > 0:
		_waiting_for_choice = true
		next_season_btn.disabled = true
		var rk = event_data.get("resolve_key", "")
		if rk != "":
			_action_context = rk
	event_overlay.show_event(event_data)


func _on_run_ended() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/death_screen.tscn")


func _on_pack_disbanded(flavor: String) -> void:
	_on_stat_changed()
	_build_action_cards()
	event_overlay.show_event({ "type": "result", "flavor": flavor, "choices": [] })


func _on_settings_pressed() -> void:
	var panel: Control = SettingsPanelScene.instantiate()
	panel.z_index = 200
	add_child(panel)
	panel.open(true)
	var back = panel.get_node_or_null("Card/Scroll/VBox/Margin/InnerVBox/BackBtn")
	if back:
		back.pressed.connect(func(): panel.queue_free())


# ── DISPLAY ──────────────────────────────────────────────────────────────────

func _refresh_stat_labels() -> void:
	var next_list := UnlockManager.get_unlockable_from(GameState.species_id)
	if next_list.is_empty():
		tab_kills.text = "Chain Complete ★"
		return

	var next_sid: String  = next_list[0]
	var next_name: String = SpeciesDB.get_species(next_sid).get("display_name", next_sid)
	var live_record := UnlockManager.live_record()
	var prog := UnlockManager.get_progress_for(next_sid, live_record)
	var current:  int  = prog.get("current",  0)
	var required: int  = prog.get("required", 0)
	var elder_met: bool = prog.get("elder_reached", false)
	var stat_word := "Survived" if (prog.get("type", "") == "survive_and_elder") else "Wins"
	var elder_icon := "★" if elder_met else "☆"

	var care: Dictionary = prog["routes"][1]
	var care_ready: bool = care["requirements"].slice(0, -1).all(func(row): return row["current"] >= row["required"])
	tab_kills.text = "Next: %s\n%d/%d %s %s" % [next_name, current, required, stat_word, elder_icon]
	tab_kills.tooltip_text = UnlockManager.progress_text(next_sid, prog)
	if float(care["ratio"]) > float(prog["routes"][0]["ratio"]):
		tab_kills.text = "Next: %s\nCare path %s %s" % [next_name, "ready" if care_ready else "%d%%" % roundi(float(care["ratio"]) * 100.0), elder_icon]


func _refresh_info_labels() -> void:
	stage_label.text  = GameState.get_stage_name()
	season_label.text = GameState.get_season_name()
	# RUN slot: seasons survived so far this run
	year_label.text   = "Season %d" % (GameState.seasons_elapsed + 1)


func _refresh_cards() -> void:
	var is_hatchling := GameState.life_stage == 0
	var ad_ready     := AdManager.is_rewarded_ready() and not is_hatchling
	for card in cards_container.get_children():
		if not ("action_id" in card):
			continue
		var aid: String = card.action_id
		if aid == "family":
			card.visible = preload("res://scripts/systems/family_legacy.gd").available()
			card.disabled = not card.visible
			card.subtitle_label.text = "Lesson given · returns next season" if GameState.get_action_uses("family_lesson") > 0 else "Their nature, learned skills and family record"
			continue
		if aid == "home":
			card.visible = GameState.life_stage > 0
			card.subtitle_label.text = "Range decision used · returns next season" if GameState.get_action_uses("home_duty") > 0 else preload("res://scripts/systems/living_world.gd").summary().replace("\n", " · ")
			card.disabled = not preload("res://scripts/systems/living_world.gd").available()
			continue
		if aid == "leadership":
			card.visible = LEADERSHIP.available()
			card.title_label.text = "Your alpha duties" if GameState.is_alpha else "Meet your alpha"
			card.subtitle_label.text = ("Leadership action used · returns next season" if not LEADERSHIP.duty_ready() else "Choose one leadership action this season") if GameState.is_alpha else "View their trust · earn or challenge leadership"
			card.disabled = not LEADERSHIP.available() or (GameState.is_alpha and not LEADERSHIP.duty_ready())
			continue

		# Ad cards — show/hide based on ad availability and conditions
		if aid.begins_with("ad_"):
			card.visible = ad_ready and AD_REWARDS.available(aid)
			continue

		# Regular cards
		if card.has_method("refresh_state"):
			card.refresh_state()
		if aid == "nest_tend":
			card.visible = GameState.has_young
			if not GameState.has_young:
				continue
		if is_hatchling or _should_disable_action(aid):
			card.disabled = true


func _update_dino_image() -> void:
	var sid  := GameState.species_id
	var hurt := GameState.health < 0.60
	var img_path: String
	match GameState.life_stage:
		0:
			img_path = "res://assets/dinos/%s_hatchling.png" % sid
		1:
			var variant = "%s_juvenile_injured" % sid if hurt else "%s_juvenile" % sid
			img_path = "res://assets/dinos/%s.png" % variant
			if hurt and not ResourceLoader.exists(img_path):
				img_path = "res://assets/dinos/%s_juvenile.png" % sid
		2:
			var variant = "%s_sub_adult_injured" % sid if hurt else "%s_sub_adult" % sid
			img_path = "res://assets/dinos/%s.png" % variant
			if hurt and not ResourceLoader.exists(img_path):
				img_path = "res://assets/dinos/%s_sub_adult.png" % sid
		3:
			img_path = "res://assets/dinos/%s_adult_injured.png" % sid if hurt \
				else "res://assets/dinos/%s_adult.png" % sid
		4:
			img_path = "res://assets/dinos/%s_elder_injured.png" % sid if hurt \
				else "res://assets/dinos/%s_elder.png" % sid
			if not ResourceLoader.exists(img_path):
				img_path = "res://assets/dinos/%s_adult_injured.png" % sid if hurt \
					else "res://assets/dinos/%s_adult.png" % sid
		_:
			img_path = "res://assets/dinos/%s_adult.png" % sid
	if ResourceLoader.exists(img_path):
		dino_image.texture = load(img_path)


# ── STATS POPUP ──────────────────────────────────────────────────────────────

func _show_stats_popup(tab: String) -> void:
	if tab == "bonuses":
		_show_bonuses_popup()
		return
	var title  := ""
	var flavor := ""
	match tab:
		"kills":
			title  = "Kills"
			flavor = "%d kills this run." % GameState.kills
		"fights":
			title  = "Fights"
			flavor = "Won: %d\nLost: %d\nFled: %d" % [
				GameState.fights_won, GameState.fights_lost, GameState.fights_fled]
	event_overlay.show_event({ "type": "info", "title": title, "flavor": flavor, "choices": [] })


func _hide_bonuses_overlay() -> void:
	if is_instance_valid(_bonuses_overlay):
		_bonuses_overlay.queue_free()
		_bonuses_overlay = null


func _show_bonuses_popup() -> void:
	if event_overlay.visible or _waiting_for_choice or _dashboard.blocking_view_open():
		return
	_hide_bonuses_overlay()
	_bonuses_overlay = preload("res://scripts/ui/perks_panel.gd").create(self)
