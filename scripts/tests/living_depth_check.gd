extends RefCounted

const PACK = preload("res://scripts/systems/pack_story_events.gd")
const HABITAT = preload("res://scripts/systems/habitat_conditions.gd")
const FAMILY = preload("res://scripts/systems/family_legacy.gd")
const LIFE = preload("res://scripts/systems/life_story.gd")
const PAIRS = preload("res://scripts/systems/pack_relationships.gd")
var harness: Node
var driver = preload("res://scripts/tests/large_scope_check.gd").new()


func run(check_harness: Node) -> void:
	harness = check_harness
	driver.harness = harness
	_check_names()
	_check_pack()
	_check_habitat()
	_check_family()
	_check_feedback_settings()
	preload("res://scripts/tests/habitat_authority_check.gd").new().run(harness)
	var original_scale: Vector2i = harness.root.content_scale_size
	var emulation := Input.is_emulating_touch_from_mouse()
	Input.set_emulate_touch_from_mouse(true)
	for dimensions in [Vector2i(390, 844), Vector2i(320, 568)]:
		harness.root.size = dimensions
		harness.root.content_scale_size = dimensions
		await _check_ui(dimensions.x)
	Input.set_emulate_touch_from_mouse(emulation)
	harness.root.content_scale_size = original_scale
	harness.root.size = Vector2i(390, 844)
	GameState.delete_save()
	print("Living depth checked: real friend/rival events and alpha influence, saved local resources and scouting costs, child personalities/teaching/growth/reunions, single inherited lessons, malformed/stale saves, phone-size family and map flows.")


func _check_names() -> void:
	for example in [[[], ""], [["Moss"], "Moss"], [["Moss", "Cinder"], "Moss and Cinder"], [["Fern", "Brook", "Cinder"], "Fern, Brook, and Cinder"]]:
		harness._check(LIFE.names_text(example[0]) == example[1], "Character lists must read naturally for zero, one, two and several names.")
	driver._start("iguanodon", 4)
	GameState.companions[2]["name"] = "Moss"
	GameState.companions[3]["name"] = "Cinder"
	GameState.companions[2]["trust"] = -0.35
	GameState.companion_event = {"kind": "intro", "name": "Fern", "season": GameState.seasons_elapsed}
	var intro: Dictionary = driver.C.pending_event()
	harness._check(intro.get("flavor", "").contains("Moss and Cinder travel with you too."), "The actual companion introduction must join two extra companions with and.")
	GameState.save_run()
	harness._check(GameState.load_run() and driver.C.pending_event() == intro and is_equal_approx(GameState.companions[2]["trust"], -0.35), "Existing Story-named Survival companions must keep their identities, trust and pending event on reload.")
	var generated: Array = []
	for index in LIFE.NAMES.size() + 4:
		var name: String = LIFE._new_name()
		harness._check(name not in generated and name.split(" ")[0] not in ["Moss", "Flint", "Scarjaw", "Mother"], "New Survival identities must stay unique and separate from Story Mode, including exhausted pools.")
		generated.append(name)
		GameState.offspring_history.append({"name": name})


func _check_pack() -> void:
	driver._start()
	var pair := PAIRS.pair_for("Fern", "Brook")
	pair["score"] = 0.5
	GameState.journey_state = {"phase": 3}
	GameState.discovery_state["next"] = 9999
	var events: Array = []
	var capture := func(event: Dictionary): events.append(event)
	TurnManager.event_fired.connect(capture)
	TurnManager.start_turn()
	TurnManager.event_fired.disconnect(capture)
	harness._check(not events.is_empty() and events[-1].get("resolve_key") == "pack_story", "An established pair story must be reachable through the actual seasonal event loop.")
	var current := PACK.next_event()
	harness._check(current.get("flavor", "").contains("Brook") and current["flavor"].contains("Fern") and current["title"] == "They won't leave a friend", "Established friends must drive an event about those exact two active dinosaurs.")
	GameState.save_run()
	harness._check(GameState.load_run() and PACK.pending_event() == current, "A relationship event must resume with the same people, choices and story.")
	pair = PAIRS.pair_for("Fern", "Brook")
	var score: float = pair["score"]
	var food := GameState.hunger
	var result := ActionResolver.resolve("pack_story", "help")
	harness._check(is_equal_approx(food - GameState.hunger, 0.05) and is_equal_approx(pair["score"] - score, 0.16) and result.get("feedback", {}).get("gains", []).any(func(gain): return gain.contains("bond +8%")), "A friend rescue must charge its displayed food cost and improve actual pair and player relationships.")
	food = GameState.hunger
	ActionResolver.resolve("pack_story", "help")
	harness._check(GameState.hunger == food and PACK.next_event().is_empty(), "Completed pack events must not replay or bypass their three-season cooldown.")
	driver._start()
	pair = PAIRS.pair_for("Fern", "Brook")
	pair["score"] = -0.5
	PACK.next_event()
	var trust: float = driver.C._find("Fern")["trust"]
	var other: float = driver.C._find("Brook")["trust"]
	ActionResolver.resolve("pack_story", "first")
	harness._check(is_equal_approx(driver.C._find("Fern")["trust"] - trust, -0.10) and is_equal_approx(driver.C._find("Brook")["trust"] - other, 0.10) and is_equal_approx(pair["score"], -0.62), "Backing the canonical first rival must increase that member's trust, reduce the other's and strain their shared bond.")
	GameState.seasons_elapsed += 3
	GameState.action_uses = {}
	current = PACK.next_event()
	harness._check(current.get("title") == "Two paths, neither yielding", "A later rivalry encounter must offer a route dispute rather than repeating the food event.")
	food = GameState.hunger
	GameState.hunger = 0.01
	ActionResolver.resolve("pack_story", "help")
	harness._check(GameState.hunger == 0.01 and not PACK.pending_event().is_empty(), "A food-cost choice that becomes unaffordable must preserve the event and reserves.")
	GameState.hunger = food
	ActionResolver.resolve("pack_story", "help")
	harness._check(GameState.living_state.get("watch_until", -1) == GameState.seasons_elapsed + 1, "The shared route must grant the real seasonal feeding modifier.")
	GameState.is_alpha = true
	GameState.action_uses = {}
	score = pair["score"]
	ActionResolver.resolve("leadership", "mediate")
	harness._check(is_equal_approx(pair["score"] - score, 0.16), "An alpha's mediation must ease an actual strained peer relationship too.")
	GameState.pack_alpha_name = "Brook"
	pair["score"] = -0.5
	var names: Array[String] = ["Fern"]
	harness._check(is_equal_approx(PACK.alpha_modifier(names, "Brook"), 0.02), "A real supporter's rivalry with the alpha must help a challenge by two points.")
	pair["score"] = 0.5
	harness._check(is_equal_approx(PACK.alpha_modifier(names, "Brook"), -0.02), "A real supporter's friendship with the alpha must temper the challenge by two points.")
	GameState.is_alpha = false
	GameState.action_uses = {}
	driver.C._find("Fern")["trust"] = 0.9
	var leadership := preload("res://scripts/systems/pack_leadership.gd").menu()
	harness._check(leadership.get("flavor", "").contains("Ready to support you:") and leadership["flavor"].contains("-2 points"), "The leadership preview must show the same real supporters and peer adjustment used by the fight.")
	result = PackManager.resolve_alpha_fight()
	harness._check(str(result.get("support_note", "")).contains("−2") or str(result.get("support_note", "")).contains("-2"), "The actual alpha fight must report the real peer-bond influence, not only compute it in isolation.")
	driver._start()
	PAIRS.pair_for("Fern", "Brook")["score"] = 0.5
	PACK.next_event()
	driver.C._depart(driver.C._find("Fern"), "Left the range.")
	harness._check(PACK.pending_event().is_empty(), "A departed member must invalidate the saved pair story before any choice applies.")
	for species in ["trex", "allosaurus", "ankylosaurus"]:
		driver._start(species, 0)
		harness._check(PACK.next_event().is_empty(), "Solitary species must never receive friendship or rivalry events.")


func _check_habitat() -> void:
	driver._start()
	GameState.is_alpha = true
	GameState.living_state = {"site": "ridge", "shelter": 0, "wear": 0}
	HABITAT.tick()
	harness._check(HABITAT.at("ridge")["food"] == 1 and HABITAT.at("river")["food"] == 3, "Food must deplete at the occupied home and recover in an unused place.")
	var snapshot := GameState.habitat_state.duplicate(true)
	HABITAT.tick()
	HABITAT.detail("river")
	harness._check(GameState.habitat_state == snapshot, "Repeated seasonal hooks and map reads must not reroll pressure or recover food again.")
	GameState.habitat_state["sites"]["ridge"]["pressure"] = 2
	var modifier := preload("res://scripts/systems/world_conditions.gd").modifier("graze")
	var food := GameState.hunger
	ActionResolver.resolve("home", "home_scout")
	harness._check(is_equal_approx(food - GameState.hunger, 0.04) and GameState.get_action_uses("home_duty") == 1 and HABITAT.pressure("ridge") == 1 and is_equal_approx(preload("res://scripts/systems/world_conditions.gd").modifier("graze") - modifier, 0.01), "Scouting must cost four percent food, spend the range decision and improve the actual feeding chance by one point.")
	food = GameState.hunger
	ActionResolver.resolve("home", "home_scout")
	harness._check(food == GameState.hunger, "Duplicate scouting cannot consume food or stack danger mitigation.")
	GameState.save_run()
	harness._check(GameState.load_run() and HABITAT.pressure("ridge") == 1 and GameState.get_action_uses("home_duty") == 1, "Local food, predator pressure, scouting and the seasonal limit must survive JSON resume.")
	GameState.seasons_elapsed += 1
	GameState.action_uses = {}
	harness._check(HABITAT.pressure("ridge") == 2, "Scouting protection must expire at the next season.")
	GameState.living_state["wear"] = 4
	GameState.habitat_state["sites"]["ridge"]["food"] = 0
	ActionResolver.resolve("home", "home_rest")
	harness._check(HABITAT.at("ridge")["food"] == 2 and GameState.living_state["wear"] == 0, "Ground care must restore both actual food and the original depletion penalty.")
	GameState.world_state = {"kind": "drought", "until": GameState.seasons_elapsed + 3}
	var stock: int = HABITAT.at("river")["food"]
	HABITAT.tick()
	harness._check(HABITAT.at("river")["food"] == stock - 1, "A drought must prevent unused habitat food recovery and deplete it instead.")
	var restored := HABITAT.restore({"sites": {"ridge": {"food": INF, "pressure": 99}, "unknown": {}}, "last_tick": "bad", "scout_season": INF})
	harness._check(restored["sites"].size() == 1 and restored["sites"]["ridge"] == {"food": 2, "pressure": 2} and restored["last_tick"] == -1, "Malformed habitat saves must keep only known places and finite bounded levels.")


func _check_family() -> void:
	driver._start("trex", 0)
	GameState.has_young = true
	GameState.offspring_name = "Pebble"
	GameState.has_juvenile = true
	GameState.juvenile_name = "Willow"
	var child := FAMILY.ensure_child("Pebble")
	child["trait"] = "curious"
	FAMILY.ensure_child("Willow")["trait"] = "cautious"
	var growth := FAMILY.growth("Pebble")
	harness._check(growth["young"] and growth["duration"] == int(SpeciesDB.get_species("trex").get("nesting_seasons", 3)) and FAMILY.growth("Willow")["duration"] == TurnManager.MATERNAL_JUVENILE_SEASONS, "Family progress must use this species' real nesting period and the actual juvenile phase duration.")
	harness._check(FAMILY.natural_skill(child) == "forage" and FAMILY.natural_skill(FAMILY.ensure_child("Willow")) == "cover", "Personality hints must point to the lessons the actual teaching rules favor.")
	var current := FAMILY.event("Pebble")
	GameState.save_run()
	harness._check(GameState.load_run() and FAMILY.pending_event() == current, "A child's personality and pending lesson must survive real save/resume.")
	var food := GameState.hunger
	var care := GameState.nesting_score
	var result := ActionResolver.resolve("family", "forage")
	child = FAMILY.ensure_child("Pebble")
	harness._check(child["skills"]["forage"] == 2 and is_equal_approx(food - GameState.hunger, 0.03) and is_equal_approx(GameState.nesting_score - care, 0.03) and result.get("feedback", {}).get("milestones", []).any(func(item): return item.contains("Pebble: Find food (learned)")), "A curious child must learn food quickly, with the displayed real cost, care gain and visible milestone.")
	food = GameState.hunger
	ActionResolver.resolve("family", "forage")
	harness._check(GameState.hunger == food and FAMILY.event("Willow").is_empty(), "One family lesson must be shared across overlapping young and juveniles without duplicate charges.")
	GameState.seasons_elapsed += 1
	GameState.action_uses = {}
	care = GameState.nesting_score
	FAMILY.tick()
	harness._check(is_equal_approx(GameState.nesting_score - care, 0.01), "Practiced lessons must improve actual seasonal parenting care.")
	FAMILY.tick()
	harness._check(is_equal_approx(GameState.nesting_score - care, 0.01), "Seasonal parenting skill benefits must apply only once.")
	FAMILY.event("Willow")
	ActionResolver.resolve("family", "cover")
	harness._check(FAMILY.ensure_child("Willow")["skills"]["cover"] == 2 and child["skills"]["cover"] == 0, "Teaching an older juvenile must update their own skills rather than their younger sibling's.")
	GameState.has_young = false
	LIFE.finish_parenting("Pebble", "strong")
	var archived: Dictionary = GameState.offspring_history[0]
	harness._check(archived["trait"] == "curious" and archived["skills"]["forage"] == 2, "A child leaving the nest must preserve their exact nature and lessons in the family record.")
	GameState.seasons_elapsed += 2
	GameState.hunger = 0.3
	LIFE.next_reunion()
	harness._check(is_equal_approx(GameState.hunger, 0.50), "A strongly bonded child's learned food skill must add two actual food points to a reunion.")
	var record := {"species_id": "trex", "display_name": "T-Rex", "offspring_history": [archived]}
	harness._check(LegacyManager.select_family_lesson(record, archived, "forage"), "A learned skill from a strongly bonded child must be selectable for a later life.")
	GameState.start_run("iguanodon")
	harness._check(GameState.family_state.get("inheritance", {}).is_empty() and LegacyManager._family_lesson.get("species_id") == "trex", "Starting another species must preserve the queued lesson without applying it.")
	GameState.start_run("trex")
	harness._check(is_equal_approx(GameState.permanent_strength_mod, 0.02) and GameState.family_state["inheritance"]["name"] == "Pebble" and LegacyManager._family_lesson.is_empty(), "The matching new life must receive exactly one chosen two-percent lasting bonus.")
	GameState.save_run()
	harness._check(GameState.load_run() and is_equal_approx(GameState.permanent_strength_mod, 0.02) and GameState.bonus_stat_grants["Family Lesson"].size() == 1, "Resuming an inherited lesson must retain its stat explanation without re-awarding the bonus.")
	FAMILY.inherit({"name": "Willow", "skill": "cover"})
	harness._check(GameState.permanent_defense_mod == 0 and GameState.family_state["inheritance"]["name"] == "Pebble", "A second inherited lesson must not stack in the same life.")
	GameState.start_run("trex")
	harness._check(GameState.permanent_strength_mod == 0, "A consumed lesson must not automatically repeat on another new life.")
	archived["bond"] = "lost"
	harness._check(not LegacyManager.select_family_lesson(record, archived, "forage"), "A lost child must never provide a selectable legacy lesson.")
	GameState.has_young = true
	GameState.offspring_name = "Pebble"
	var malformed := FAMILY.restore({"children": {"Pebble": {"trait": "wrong", "skills": {"cover": INF, "forage": 99}}, "Ghost": {}}, "last_tick": NAN})
	harness._check(malformed["children"].size() == 1 and malformed["children"]["Pebble"]["skills"]["cover"] == 0 and malformed["children"]["Pebble"]["skills"]["forage"] == 2, "Malformed child records must prune unknown names and sanitize trait and skill bounds.")
	GameState.family_state = FAMILY.restore(null)
	FAMILY.event("Pebble")
	GameState.hunger = 0.01
	ActionResolver.resolve("family", "cover")
	harness._check(GameState.hunger == 0.01 and GameState.get_action_uses("family_lesson") == 0, "Unaffordable lessons must preserve food and the seasonal opportunity.")
	GameState.seasons_elapsed += 1
	harness._check(FAMILY.pending_event().is_empty(), "A saved lesson must expire after its season.")


func _check_ui(width: int) -> void:
	driver._start()
	GameState.has_young = true
	GameState.offspring_name = "Pebble"
	FAMILY.ensure_child("Pebble")["trait"] = "curious"
	GameState.has_juvenile = true
	GameState.juvenile_name = "Willow"
	FAMILY.ensure_child("Willow")["trait"] = "cautious"
	GameState.living_state["site"] = "river"
	HABITAT.tick()
	GameState.save_run()
	var game = load("res://scenes/game/game_screen.tscn").instantiate()
	harness.root.add_child(game)
	await driver._settle()
	game.event_overlay.hide_overlay()
	game._waiting_for_choice = false
	game._age_up_active = false
	driver._tap(game._dashboard.family_button)
	await driver._settle()
	var view = game._dashboard.family_view
	harness._check(view.visible and harness.root.get_visible_rect().encloses(view.panel.get_global_rect()), "The actual family action must open a readable modal at both phone sizes.")
	await driver._capture("family_depth_%d" % width)
	var buttons: Array = view.content.get_children().filter(func(node): return node is Button)
	view.scroll.ensure_control_visible(buttons[0])
	await driver._settle()
	var food := GameState.hunger
	var season := GameState.seasons_elapsed
	game._on_next_season()
	game._on_action_pressed("rest")
	harness._check(GameState.hunger == food and GameState.seasons_elapsed == season, "The family modal must block all underlying life actions.")
	await driver._swipe(buttons[0])
	harness._check(view.scroll.scroll_vertical > 0 and not game.event_overlay.visible, "A swipe beginning on a family lesson button must scroll without spending food or selecting it.")
	view.scroll.ensure_control_visible(buttons[0])
	await driver._settle()
	driver._tap(buttons[0])
	await driver._settle()
	harness._check(not view.visible and game.event_overlay.visible and game._action_context == "family" and game._waiting_for_choice, "The actual lesson button must open the saved blocking family choice flow.")
	game._on_choice_made("forage")
	harness._check(FAMILY.ensure_child("Pebble")["skills"]["forage"] == 2 and is_equal_approx(food - GameState.hunger, 0.03), "The displayed lesson choice must route through the actual game resolver and charge exactly once.")
	game.event_overlay.hide_overlay()
	game._waiting_for_choice = false
	driver._tap(game._dashboard.map_button)
	await driver._settle()
	var map = game._dashboard.map_view
	harness._check(map.visible and map.details.get_child_count() > 2 and not map.extra_details.visible, "The habitat map must show simple local conditions with optional expanded detail.")
	await driver._capture("habitat_conditions_%d" % width)
	game.queue_free()
	await driver._settle()
	await _check_lineage_ui(width)


func _check_feedback_settings() -> void:
	var settings := [SettingsManager.vibration_enabled, SettingsManager.tension_audio_enabled]
	SettingsManager.set_vibration_enabled(true)
	SettingsManager.set_tension_audio_enabled(false)
	SettingsManager.vibration_enabled = false
	SettingsManager.tension_audio_enabled = true
	SettingsManager.load_settings()
	harness._check(SettingsManager.vibration_enabled and not SettingsManager.tension_audio_enabled, "Vibration and tension audio must restore as independent saved preferences.")
	SoundManager.start_combat_loop()
	harness._check(not SoundManager._loop.playing, "Disabled tension audio must not start at a threat.")
	SettingsManager.set_tension_audio_enabled(true)
	harness._check(SoundManager._loop.playing and SoundManager._loop.volume_db == -18, "Tension audio must play quietly when re-enabled during an actual threat.")
	SoundManager._notification(Node.NOTIFICATION_APPLICATION_PAUSED)
	harness._check(not SoundManager._loop.playing and not SoundManager.pulse_haptic(), "Backgrounding must stop tension audio and suppress haptic requests.")
	SoundManager._notification(Node.NOTIFICATION_APPLICATION_RESUMED)
	harness._check(SoundManager._loop.playing, "A still-active threat may restore tension audio on resume.")
	SoundManager.stop_combat_loop()
	harness._check(not SoundManager._loop.playing and not SoundManager._combat_active, "Dismissing the threat must stop and clear tension audio.")
	SettingsManager.set_vibration_enabled(false)
	harness._check(not SoundManager.pulse_haptic(), "Disabled vibration must never request hardware feedback.")
	SettingsManager.set_vibration_enabled(settings[0])
	SettingsManager.set_tension_audio_enabled(settings[1])


func _check_lineage_ui(width: int) -> void:
	var history: Array = LegacyManager._run_history.duplicate(true)
	var child := {"name": "Pebble", "trait": "curious", "bond": "strong", "skills": {"forage": 2, "cover": 2, "routes": 0}}
	LegacyManager._run_history = [{"species_id": "iguanodon", "display_name": "Iguanodon", "offspring_history": [child]}]
	var menu = load("res://scenes/ui/main_menu.tscn").instantiate()
	harness.root.add_child(menu)
	await driver._settle()
	menu._show_lineage_panel()
	await driver._settle()
	var buttons: Array = menu.find_children("*", "Button", true, false).filter(func(button): return button.text.begins_with("Carry Pebble"))
	harness._check(buttons.size() == 2, "Lineage must expose each genuinely learned skill as a choice, without unlearned skills.")
	var scroll: ScrollContainer = buttons[0].get_parent().get_parent().get_parent().get_parent()
	scroll.ensure_control_visible(buttons[0])
	await driver._settle()
	driver._tap(buttons[0])
	await driver._settle()
	harness._check(LegacyManager._family_lesson.get("skill") == "forage", "The actual lineage button must queue the displayed child's food skill.")
	scroll.ensure_control_visible(buttons[1])
	await driver._settle()
	driver._tap(buttons[1])
	await driver._settle()
	harness._check(LegacyManager._family_lesson.get("skill") == "cover", "Choosing another real lineage button must replace the previous lesson, not accumulate it.")
	await driver._capture("family_lineage_%d" % width)
	LegacyManager._family_lesson = {}
	LegacyManager._save_family_lesson()
	LegacyManager._run_history = history
	menu.queue_free()
	await driver._settle()
