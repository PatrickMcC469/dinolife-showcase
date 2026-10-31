extends RefCounted

const JOURNAL = preload("res://scripts/ui/living_journal.gd")
const LIFE = preload("res://scripts/systems/life_story.gd")
var harness: Node


func run(check_harness: Node) -> void:
	harness = check_harness
	var old_atmosphere := SettingsManager.atmosphere_enabled
	var old_motion := SettingsManager.interface_animations_enabled
	var old_scale: Vector2i = harness.root.content_scale_size
	var old_emulation := Input.is_emulating_touch_from_mouse()
	Input.set_emulate_touch_from_mouse(true)
	SettingsManager.set_atmosphere_enabled(true)
	SettingsManager.set_interface_animations_enabled(true)
	GameState.start_run("iguanodon")
	GameState.life_stage = 3
	GameState.is_alpha = true
	GameState.hunger = 0.8
	GameState.seasons_elapsed = 6
	LIFE.remember("companion_shared_Fern", "Shared scarce food with Fern.")
	GameState.seasons_elapsed = 9
	LIFE.remember("journey", "Crossed twenty-five miles of unfamiliar ground.")
	GameState.seasons_elapsed = 12
	LIFE.remember("mate", "Formed a bond with Reed.")
	LIFE.remember("young_Brook", "Raised a hatchling called Brook.")
	GameState.seasons_elapsed = 15
	LIFE.remember("alpha", "Rose to lead the group as alpha.")
	GameState.seasons_elapsed = 18
	var home := ActionResolver.resolve("home", "home_river")
	harness._check(home.get("flavor", "").contains("river") and JOURNAL.recorded_memories().any(func(memory: Dictionary): return memory["category"] == "Home" and memory["season"] == 18), "A real home decision must appear at its recorded season even when a perk is earned afterward.")
	var memories := GameState.life_events.duplicate(true)
	var journal_before := JOURNAL.recorded_memories()
	GameState.save_run()
	harness._check(GameState.load_run() and JOURNAL.recorded_memories() == journal_before, "Journal dates/text/order must survive JSON's numeric coercion during actual save/resume.")
	memories = GameState.life_events.duplicate(true)
	GameState.life_events.append({"key": "old", "text": "An earlier moment."})
	GameState.life_events.append({"key": "future", "text": "Not yet lived.", "season": 900})
	GameState.life_events.append({"key": "broken", "text": 5, "season": 0})
	var clean := JOURNAL.recorded_memories()
	harness._check(clean.size() == memories.size() + 1 and clean[-1]["season"] == -1, "Old memories without dates must be honest; malformed and future memories must be omitted.")
	GameState.life_events = memories.duplicate(true)
	for dimensions in [Vector2i(390, 844), Vector2i(320, 568)]:
		harness.root.content_scale_size = dimensions
		harness.root.size = dimensions
		await _check_game(dimensions.x)
	harness.root.content_scale_size = old_scale
	harness.root.size = Vector2i(390, 844)
	await _check_menu()
	Input.set_emulate_touch_from_mouse(old_emulation)
	SettingsManager.set_atmosphere_enabled(old_atmosphere)
	SettingsManager.set_interface_animations_enabled(old_motion)
	GameState.delete_save()
	print("Medium scope checked: recorded/saved journal memories, date order and malformed/legacy data, filtering/expansion/touch scrolling, modal safety, unchanged dinosaur art, decorative randomness, motion settings and pause/resume.")


func _settle() -> void:
	await harness.get_tree().process_frame
	await harness.get_tree().process_frame


func _capture(name: String) -> void:
	if "--capture-memorial" in OS.get_cmdline_user_args():
		await RenderingServer.frame_post_draw
		harness.root.get_texture().get_image().save_png("res://.godot/medium_%s.png" % name)


func _tap(control: Control) -> void:
	var driver := preload("res://scripts/tests/tap_reveal_check.gd").new()
	driver.harness = harness
	driver._click(control.get_global_rect().get_center(), false)


func _check_game(width: int) -> void:
	var game = load("res://scenes/game/game_screen.tscn").instantiate()
	harness.root.add_child(game)
	await _settle()
	game.event_overlay.hide_overlay()
	game._waiting_for_choice = false
	var journal = game._dashboard.journal_view
	var art = game.dino_image.get_node("LivingArt")
	var state := [GameState.health, GameState.hunger, GameState.seasons_elapsed, GameState.life_events.duplicate(true), GameState.action_uses.duplicate(true)]
	var saved := FileAccess.get_file_as_string(GameState.SAVE_PATH)
	seed(913)
	var expected := randf()
	seed(913)
	_tap(game._dashboard.journal_button)
	await _settle()
	harness._check(is_equal_approx(randf(), expected) and journal.visible, "The real journal button must open without consuming gameplay randomness.")
	harness._check(journal.cards.get_child_count() == GameState.life_events.size() and journal.cards.get_child(0).season_label.text.begins_with("Season 19"), "All real memories must appear newest first with correct one-based seasons.")
	harness._check(harness.root.get_visible_rect().encloses(journal.panel.get_global_rect()) and journal.back.size.y >= 44, "Journal and its fixed Back button must fit both phone sizes.")
	await _capture("journal_%d" % width)
	game._on_next_season()
	game._on_action_pressed("rest")
	harness._check(state == [GameState.health, GameState.hunger, GameState.seasons_elapsed, GameState.life_events, GameState.action_uses], "An open journal must block underlying actions and season changes.")
	var first = journal.cards.get_child(0)
	_tap(first)
	await _settle()
	harness._check(first.expanded and first.detail.visible and first.detail.text == GameState.life_events[-1]["text"], "Tapping a memory must expand its exact saved text.")
	await _capture("journal_expanded_%d" % width)
	var touch := InputEventScreenTouch.new()
	touch.position = journal.scroll.get_global_rect().get_center()
	touch.pressed = true
	Input.parse_input_event(touch)
	Input.flush_buffered_events()
	var drag := InputEventScreenDrag.new()
	drag.position = touch.position - Vector2(0, 100)
	drag.relative = Vector2(0, -100)
	Input.parse_input_event(drag)
	Input.flush_buffered_events()
	touch = touch.duplicate()
	touch.pressed = false
	touch.position = drag.position
	Input.parse_input_event(touch)
	Input.flush_buffered_events()
	await _settle()
	harness._check(journal.scroll.scroll_vertical > 0, "An actual swipe over journal cards must scroll them.")
	journal.filter.select(1)
	journal.filter.item_selected.emit(1)
	await _settle()
	harness._check(journal.cards.get_child_count() == 2 and journal.cards.get_child(0).season_label.text.contains("Family"), "The category filter must select recorded family memories only.")
	harness._check(GameState.life_events == state[3] and FileAccess.get_file_as_string(GameState.SAVE_PATH) == saved, "Reading/filtering memories must not rewrite the run or its history.")
	journal.filter.select(5)
	journal.filter.item_selected.emit(5)
	await _settle()
	harness._check(journal.cards.get_child(0) is Label and journal.cards.get_child(0).text.contains("No discoveries"), "An empty category must explain that no memories were recorded, without inventing any.")
	_tap(journal.back)
	harness._check(not journal.visible, "Back must return to gameplay without advancing a season.")
	game._dashboard._show_journal()
	game.event_overlay.show_event({"type": "info", "title": "A new event", "flavor": "Read the trail."})
	harness._check(not journal.visible, "A new event must close the journal so it cannot conceal gameplay decisions.")
	game.event_overlay.hide_overlay()
	game._dashboard._show_pack()
	game._dashboard._show_journal()
	harness._check(not journal.visible, "Pack and journal views must not stack.")
	game._dashboard.pack_view.hide()
	await _check_art(game, art)
	await _capture("game_%d" % width)
	game.queue_free()
	await _settle()


func _check_art(game: Control, art: Control) -> void:
	var texture: Texture2D = game.dino_image.texture
	var species := GameState.species_id
	var bounds: Rect2 = game.dino_image.get_global_rect()
	var rotation: float = game.dino_image.rotation
	seed(412)
	var expected := randf()
	seed(412)
	art._process(0.5)
	harness._check(is_equal_approx(randf(), expected) and game.dino_image.texture == texture and game.dino_image.get_global_rect() == bounds and game.dino_image.rotation == rotation, "Scenery motion must never consume survival randomness or distort the dinosaur art.")
	for sid in UnlockManager.PLAYABLE_SPECIES:
		GameState.species_id = sid
		game._update_dino_image()
		var original: Texture2D = game.dino_image.texture
		art._process(0.016)
		harness._check(game.dino_image.texture == original and game.dino_image.rotation == rotation and game.dino_image.get_global_rect() == bounds, "All ten species must keep their real portrait and anatomy unchanged during scenery motion.")
	GameState.species_id = species
	game._update_dino_image()
	harness._check(art.mouse_filter == Control.MOUSE_FILTER_IGNORE and art.clip_contents and art.size == game.dino_image.size, "Living scenery must be clipped and never intercept portrait controls.")
	SettingsManager.set_interface_animations_enabled(false)
	harness._check(not art.is_processing(), "Turning off interface motion must freeze the decorative layer.")
	SettingsManager.set_interface_animations_enabled(true)
	SettingsManager.set_atmosphere_enabled(false)
	harness._check(not art.visible and not art.is_processing(), "Turning off atmosphere must remove and stop living scenery.")
	SettingsManager.set_atmosphere_enabled(true)
	art._notification(Node.NOTIFICATION_APPLICATION_PAUSED)
	harness._check(not art.visible and not art.is_processing(), "Decorative processing must stop when the app pauses.")
	art._notification(Node.NOTIFICATION_APPLICATION_RESUMED)
	harness._check(art.visible and art.is_processing(), "Decorative processing must resume with the saved preferences.")


func _check_menu() -> void:
	SettingsManager.set_atmosphere_enabled(false)
	var menu = load("res://scenes/ui/main_menu.tscn").instantiate()
	harness.root.add_child(menu)
	await _settle()
	var art = menu.get_node("LivingArt")
	harness._check(not art.visible and not art.is_processing(), "A menu created with atmosphere already disabled must not start decorative motion.")
	SettingsManager.set_atmosphere_enabled(true)
	harness._check(art.visible and art.mouse_filter == Control.MOUSE_FILTER_IGNORE, "Menu living scenery must sit behind native controls without capturing taps.")
	await _capture("menu_390")
	menu.queue_free()
	await _settle()
	var recorded := GameState.life_events.duplicate(true)
	GameState.life_events = []
	var journal = load("res://scenes/ui/living_journal.tscn").instantiate()
	harness.root.add_child(journal)
	await _settle()
	journal.open()
	harness._check(journal.cards.get_child_count() == 1 and journal.cards.get_child(0) is Label and JOURNAL.recorded_memories().is_empty(), "A fresh or older life without memories must show an honest empty journal.")
	journal.queue_free()
	GameState.life_events = recorded
	await _settle()
