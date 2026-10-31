extends Node

const LIFE_STORY = preload("res://scripts/systems/life_story.gd")
const COMPANIONS = preload("res://scripts/systems/companions.gd")

@onready var root: Window = get_tree().root

# Run via run_handoff_checks.py so saves never touch player data.
var _failures: Array[String] = []

class NativeAdMock extends Node:
	signal on_interstitial_ad_loaded(uid: int)
	signal on_interstitial_ad_dismissed_full_screen_content(uid: int)
	signal on_interstitial_ad_failed_to_show_full_screen_content(uid: int, error: Dictionary)
	signal on_rewarded_ad_loaded(uid: int)
	signal on_rewarded_ad_user_earned_reward(uid: int, reward: Dictionary)
	signal on_rewarded_ad_dismissed_full_screen_content(uid: int)
	var next_uid := 0
	var shown_uid := -1
	var loaded_uid := -1
	var unit_id := ""
	func create() -> int:
		next_uid += 1
		return next_uid
	func load(unit: String, _request: Dictionary, _keywords: PackedStringArray, uid: int) -> void:
		unit_id = unit
		loaded_uid = uid
	func show(uid: int) -> void:
		shown_uid = uid
	func destroy(_uid: int) -> void:
		pass


func _ready() -> void:
	_run.call_deferred()


func quit(code: int) -> void:
	get_tree().quit(code)


func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		push_error(message)


func check_choice_layout(overlay: Control) -> void:
	var scroll: ScrollContainer = overlay._choices_grid.get_parent()
	_check(scroll.get_global_rect().end.y <= root.size.y - overlay._safe_bottom, "The choice viewport must stop above the phone's bottom safe area.")
	for button in overlay._choices_grid.get_children():
		scroll.ensure_control_visible(button)
		await get_tree().process_frame
		_check(scroll.get_global_rect().encloses(button.get_global_rect()), "Every choice must be fully readable and reachable by scrolling: " + button.text)
	scroll.scroll_vertical = 0


func _run() -> void:
	root.size = Vector2i(390, 844)
	if not OS.get_user_data_dir().replace("\\", "/").contains("/.godot/handoff_userdata/"):
		push_error("Run checks through run_handoff_checks.py to isolate saves: " + OS.get_user_data_dir())
		quit(2)
		return
	await _check_ads()
	await preload("res://scripts/tests/rewarded_actions_check.gd").new().run(self)
	_check_saves()
	_check_story_graph()
	await _check_overlay()
	await preload("res://scripts/tests/tap_reveal_check.gd").new().run(self)
	await _check_story_rewind()
	_check_parenting_variants()
	await _check_life_stories()
	await _check_chapter_ads()
	await _check_companions()
	_check_dein_companion_challenges()
	_check_velociraptor_companion_challenges()
	_check_argentinosaurus_companions()
	await preload("res://scripts/tests/world_journey_check.gd").new().run(self)
	await preload("res://scripts/tests/unlock_paths_check.gd").new().run(self)
	await preload("res://scripts/tests/atmosphere_check.gd").new().run(self)
	await preload("res://scripts/tests/expansion_check.gd").new().run(self)
	await preload("res://scripts/tests/ui_polish_check.gd").new().run(self)
	await preload("res://scripts/tests/medium_scope_check.gd").new().run(self)
	await preload("res://scripts/tests/large_scope_check.gd").new().run(self)
	await preload("res://scripts/tests/living_depth_check.gd").new().run(self)
	# Let the audio thread release active playback before this test process exits.
	for player in SoundManager.get_children():
		if player is AudioStreamPlayer:
			player.stop()
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().create_timer(0.1).timeout
	if _failures.is_empty():
		print("HANDOFF CHECKS PASSED")
		quit(0)
	else:
		print("HANDOFF CHECKS FAILED: %d" % _failures.size())
		quit(1)


func _check_ads() -> void:
	var manager = load("res://scripts/managers/ad_manager.gd").new()
	var interstitial := NativeAdMock.new()
	var rewarded := NativeAdMock.new()
	root.add_child(manager)
	root.add_child(interstitial)
	root.add_child(rewarded)
	manager._interstitial_plugin = interstitial
	manager._rewarded_plugin = rewarded
	manager._connect_plugin(interstitial, "on_interstitial_ad_loaded", manager._on_interstitial_loaded)
	manager._connect_plugin(interstitial, "on_interstitial_ad_dismissed_full_screen_content", manager._on_interstitial_closed)
	manager._connect_plugin(interstitial, "on_interstitial_ad_failed_to_show_full_screen_content", manager._on_interstitial_failed_to_show)
	manager._connect_plugin(rewarded, "on_rewarded_ad_loaded", manager._on_rewarded_loaded)
	manager._connect_plugin(rewarded, "on_rewarded_ad_user_earned_reward", manager._on_rewarded_earned_reward)
	manager._connect_plugin(rewarded, "on_rewarded_ad_dismissed_full_screen_content", manager._on_rewarded_closed)
	var state := {"earned": 0, "signal": 0, "closed": 0}
	manager.rewarded_earned.connect(func(): state["signal"] += 1)
	manager.interstitial_closed.connect(func(): state["closed"] += 1)
	manager.load_interstitial()
	manager.load_rewarded()
	_check(interstitial.loaded_uid > 0 and rewarded.loaded_uid > 0, "Native loaders must receive created ad IDs.")
	_check(interstitial.unit_id == manager.TEST_INTERSTITIAL_IOS, "Editor checks must use test ad units.")
	interstitial.on_interstitial_ad_loaded.emit(interstitial.loaded_uid)
	rewarded.on_rewarded_ad_loaded.emit(rewarded.loaded_uid)
	await get_tree().process_frame
	var previous_ad_free: bool = StoreManager._ad_free
	var previous_enabled: bool = SettingsManager.reward_videos_enabled
	StoreManager._ad_free = true
	_check(not manager.show_interstitial(), "Ad-free users must skip interstitials.")
	StoreManager._ad_free = false
	SettingsManager.reward_videos_enabled = false
	_check(not manager.show_rewarded(func(): state["earned"] += 1), "Reward preference must block rewarded ads.")
	SettingsManager.reward_videos_enabled = true
	_check(manager.show_rewarded(func(): state["earned"] += 1), "A ready rewarded ad should open.")
	_check(not manager.show_rewarded(func(): state["earned"] += 100), "A second request must not replace an active reward.")
	_check(not manager.show_interstitial(), "Only one fullscreen ad may open at a time.")
	var first_uid: int = rewarded.shown_uid
	rewarded.on_rewarded_ad_user_earned_reward.emit(first_uid, {"amount": 1, "type": "boost"})
	rewarded.on_rewarded_ad_user_earned_reward.emit(first_uid, {"amount": 1, "type": "boost"})
	await get_tree().process_frame
	_check(state["earned"] == 1 and state["signal"] == 1, "Duplicate native reward callbacks must grant exactly one reward.")
	rewarded.on_rewarded_ad_dismissed_full_screen_content.emit(first_uid)
	await get_tree().process_frame
	rewarded.on_rewarded_ad_loaded.emit(first_uid)
	await get_tree().process_frame
	_check(not manager.is_rewarded_ready(), "Stale callbacks must not mark the replacement ad ready.")
	rewarded.on_rewarded_ad_loaded.emit(rewarded.loaded_uid)
	await get_tree().process_frame
	_check(manager.show_rewarded(func(): state["earned"] += 1), "A replacement rewarded ad should open.")
	rewarded.on_rewarded_ad_dismissed_full_screen_content.emit(rewarded.shown_uid)
	await get_tree().process_frame
	_check(state["earned"] == 1, "Closing an unwatched ad must grant no reward.")
	_check(manager.show_interstitial(), "A ready interstitial should open.")
	_check(not manager.show_interstitial(), "The same interstitial cannot show twice.")
	interstitial.on_interstitial_ad_failed_to_show_full_screen_content.emit(interstitial.shown_uid, {"message": "simulated failure"})
	await get_tree().process_frame
	_check(state["closed"] == 1, "Failed presentations must unblock screens awaiting ad dismissal.")
	StoreManager._ad_free = previous_ad_free
	SettingsManager.reward_videos_enabled = previous_enabled
	manager.queue_free()
	interstitial.queue_free()
	rewarded.queue_free()


func _check_saves() -> void:
	var story = load("res://scripts/story/story_state.gd").new()
	story.player_name = "Talon"
	story.current_scene_id = "s1_morning"
	story.flint_trust = 2
	story.flood_warning = true
	story.act_checkpoint_state = {"flint_trust": 1, "flood_warning": false}
	story.save()
	story.reset()
	_check(story.load_save(), "Story save must load.")
	_check(story.flint_trust == 2 and story.flood_warning and story.player_name == "Talon", "Typed story values must survive JSON loading.")
	_check(story.act_checkpoint_state.get("flint_trust") == 1, "Act checkpoint state must persist.")
	var file := FileAccess.open(story.SAVE_PATH, FileAccess.WRITE)
	file.store_string('{"current_scene_id":"s1_morning","flint_trust":2.0,"mother_trust":null,"free_rewinds_remaining":"bad","unknown_key":true}')
	file.close()
	_check(story.load_save(), "Older story saves should load missing fields safely.")
	_check(story.flint_trust == 2 and story.mother_trust == 1 and story.free_rewinds_remaining == 1, "Malformed or missing fields must use typed defaults.")
	story.delete_save()
	story.free()
	var game = load("res://scripts/managers/game_state.gd").new()
	game.species_id = "trex"
	game.fights_lost_bad = 3
	game.death_detail = "Rival Allosaurus"
	game.elder_final_event_triggered = true
	game.rival_name = "the pale one"
	game.rival_encounters = 4
	game.mate_name = "Reed"
	game.offspring_name = "Ember"
	game.juvenile_name = "Pebble"
	game.offspring_history = [{"name": "Fern", "bond": "strong", "return_season": 15, "reunited": true}]
	game.life_events = [{"key": "mate", "text": "Met Reed.", "season": 7, "importance": 6}]
	game.save_run()
	game.fights_lost_bad = 0
	game.death_detail = ""
	game.elder_final_event_triggered = false
	_check(game.load_run(), "Survival save must load.")
	_check(game.fights_lost_bad == 3 and game.death_detail == "Rival Allosaurus" and game.elder_final_event_triggered, "Run summaries and elder events must survive saving.")
	_check(game.rival_name == "the pale one" and game.rival_encounters == 4, "Rival continuity must survive saving.")
	_check(game.mate_name == "Reed" and game.offspring_name == "Ember" and game.juvenile_name == "Pebble", "Family identities must survive saving.")
	_check(game.offspring_history[0]["reunited"] and game.life_events[0]["season"] == 7, "Family outcomes and life memories must survive saving.")
	file = FileAccess.open(game.SAVE_PATH, FileAccess.WRITE)
	file.store_string('{"species_id":"trex"}')
	file.close()
	_check(game.load_run() and game.fights_lost_bad == 0 and game.death_detail == "" and not game.elder_final_event_triggered, "Legacy survival saves must retain defaults for newly saved fields.")
	_check(game.mate_name.is_empty() and game.offspring_history.is_empty() and game.life_events.is_empty(), "Old saves must default new family and memory fields.")
	_check(game.companions.is_empty() and game.companion_event.is_empty() and game.companion_event_count == 0, "Old saves must default new companion fields.")
	file = FileAccess.open(game.SAVE_PATH, FileAccess.WRITE)
	file.store_string('{"species_id":"trex","companions":[null,{"name":5,"role":"steady"},{"name":"Fern","role":"steady","trust":"bad","help_season":{}}],"companion_event":{"kind":{},"name":"Fern"},"companion_event_count":{}}')
	file.close()
	_check(game.load_run() and game.companions.size() == 1 and game.companions[0]["trust"] == 0.0 and game.companions[0]["help_season"] == -1 and game.companion_event.is_empty(), "Malformed companion save fields must use safe defaults and ignore invalid members.")
	game.delete_save()
	game.free()


func _check_story_graph() -> void:
	var scenes: Dictionary = StoryData._build()
	var images := {}
	for id in scenes:
		var scene: Dictionary = scenes[id]
		_check(scene.get("id") == id, "Story scene ID mismatch: %s" % id)
		var destinations: Array = [scene.get("next", "")]
		var image_paths: Array = [scene.get("image", "")]
		for choice in scene.get("choices", []):
			destinations.append(choice.get("next", ""))
			image_paths.append(choice.get("result_image", ""))
			for key in choice.get("requires", {}):
				var property: String = key
				if property.ends_with("_min") or property.ends_with("_max"):
					property = property.left(property.length() - 4)
				_check(property in StoryState, "Unknown story condition: %s" % key)
		for state_images in scene.get("image_by_state", {}).values():
			image_paths.append_array(state_images.values())
		for destination in destinations:
			_check(destination == "" or destination == "_main_menu" or scenes.has(destination), "Missing destination %s from %s" % [destination, id])
		for image_path in image_paths:
			if not image_path.is_empty():
				images[image_path] = true
				_check(ResourceLoader.exists(image_path), "Missing story image: %s" % image_path)
	StoryState.reset()
	_check(not StoryState.check_requires({"flood_warning": true}), "Flood flag must gate choices.")
	StoryState.flood_warning = true
	StoryState.scarjaw_trust = 2
	StoryState.flint_trust = 2
	_check(StoryState.check_requires({"flood_warning": true, "scarjaw_trust_min": 2, "flint_trust_min": 2}), "Major story branches must accept matching flags and trust.")
	var walked := {}
	var endings := {}
	var act_three_reached := false
	var random := RandomNumberGenerator.new()
	random.seed = 62
	var state = load("res://scripts/story/story_state.gd").new()
	for run in range(400):
		state.reset()
		var scene_id := "s_start"
		var completed := false
		for step in range(120):
			walked[scene_id] = true
			var scene: Dictionary = scenes[scene_id]
			if (scene.get("act", "") as String).begins_with("Act Three"):
				act_three_reached = true
			var choices: Array = []
			for choice in scene.get("choices", []):
				if state.check_requires(choice.get("requires", {})):
					choices.append(choice)
			var destination: String = scene.get("next", "")
			if not choices.is_empty():
				var choice: Dictionary = choices[0] if scene.get("type") == "auto_redirect" else choices[random.randi_range(0, choices.size() - 1)]
				state.apply_effects(choice.get("effects", {}))
				destination = choice.get("next", "")
			if destination == "_main_menu":
				endings[scene_id] = true
				completed = true
				break
			if destination.is_empty() or not scenes.has(destination):
				_check(false, "Story path stops without a menu exit at %s." % scene_id)
				break
			scene_id = destination
		_check(completed, "Story walk %d must reach a menu exit." % run)
	state.free()
	_check(act_three_reached, "Story paths must reach Act Three.")
	print("Story graph checked: %d scenes, %d referenced images." % [scenes.size(), images.size()])
	print("Story paths checked: 400 complete walks, %d scenes visited, %d menu exits." % [walked.size(), endings.size()])


func _check_overlay() -> void:
	var overlay = load("res://scenes/ui/event_overlay.tscn").instantiate()
	root.add_child(overlay)
	overlay.show_event({"title": "A very long event title that needs to wrap", "flavor": "Long narrative text. ".repeat(100), "choices": [{"label": "Continue", "action": "ok"}]})
	await get_tree().process_frame
	await get_tree().process_frame
	var scroll: ScrollContainer = overlay.get_node("PopupPanel/TopSection/TopVBox/FlavorScroll")
	var label: Label = scroll.get_node("StoryContent/FlavorLabel")
	var top: Control = overlay.get_node("PopupPanel/TopSection")
	var bottom: Control = overlay.get_node("PopupPanel/BottomSection")
	_check(label.size.x <= scroll.size.x + 1.0, "Narrative text must fit the scroll width.")
	_check(scroll.get_v_scroll_bar().max_value > scroll.get_v_scroll_bar().page, "Long narratives must be vertically scrollable.")
	_check(top.get_global_rect().end.y <= bottom.get_global_rect().position.y + 1.0, "Narrative area must end above the choice buttons.")
	var chosen := {"count": 0}
	overlay.choice_made.connect(func(_action): chosen["count"] += 1)
	overlay._on_choice("ok")
	_check(chosen["count"] == 0 and label.visible_characters == -1, "First tap must finish the typewriter.")
	overlay._on_choice("ok")
	_check(chosen["count"] == 1 and not overlay.visible, "Second tap must accept the choice.")
	overlay.show_event({"flavor": "Short result.", "choices": [{"label": "Back", "action": "back"}]})
	await get_tree().process_frame
	await get_tree().process_frame
	_check(is_equal_approx(overlay._popup_panel.anchor_top, 0.52) and scroll.size.y >= 80.0, "Compact events must retain a usable narrative area.")
	_check(overlay._back_btn.offset_bottom <= -overlay._safe_bottom, "Floating back button must clear the bottom safe area.")
	overlay.queue_free()


func _check_story_rewind() -> void:
	StoryState.reset()
	StoryState.current_scene_id = "s1_morning"
	var screen = load("res://scripts/story/story_screen.gd").new()
	root.add_child(screen)
	await get_tree().process_frame
	await get_tree().process_frame
	var checkpoint: String = StoryState.act_checkpoint
	var original_trust: int = StoryState.flint_trust
	screen._history.append({"scene_id": "s1_morning", "state": screen._snapshot_state()})
	StoryState.flint_trust = 2
	StoryState.free_rewinds_remaining = 0
	screen._do_rewind()
	await get_tree().process_frame
	_check(StoryState.free_rewinds_remaining == 0, "Rewind must not refund a consumed fossil.")
	_check(StoryState.flint_trust == original_trust, "Rewind must restore relationship state.")
	StoryState.save()
	screen.queue_free()
	await get_tree().process_frame
	StoryState.reset()
	_check(StoryState.load_save(), "Story resume must reload persisted checkpoint.")
	screen = load("res://scripts/story/story_screen.gd").new()
	root.add_child(screen)
	await get_tree().process_frame
	await get_tree().process_frame
	_check(StoryState.act_checkpoint == checkpoint and not screen._act_checkpoint_state.is_empty(), "Resume must retain the act checkpoint.")
	StoryState.flint_trust = 2
	screen._go_to_act_checkpoint()
	await get_tree().process_frame
	_check(StoryState.flint_trust == original_trust and StoryState.free_rewinds_remaining == 0, "Act restart must restore its state without replenishing fossils.")
	var earned := {"count": 0}
	screen._show_ad(func(): earned["count"] += 1)
	await get_tree().process_frame
	_check(earned["count"] == 0, "Unavailable offering must not bypass rewarded ads.")
	# Blank act headings on transition slides must still resume the saved act.
	StoryState.act_checkpoint = "s10_hunt"
	StoryState.act_checkpoint_state = screen._snapshot_state(false)
	StoryState.current_scene_id = "s_text_after_hunt"
	StoryState.save()
	screen.queue_free()
	await get_tree().process_frame
	StoryState.reset()
	StoryState.load_save()
	screen = load("res://scripts/story/story_screen.gd").new()
	root.add_child(screen)
	await get_tree().process_frame
	await get_tree().process_frame
	_check(screen._current_act.begins_with("Act Two") and StoryState.act_checkpoint == "s10_hunt", "Text-only story slides must resume their saved act and checkpoint.")
	await get_tree().create_timer(0.8).timeout
	screen.queue_free()
	StoryState.delete_save()


func _check_parenting_variants() -> void:
	GameState.sex = "male"
	GameState.start_run("deinonychus")
	var breeding := ActionResolver.resolve("dein_alpha_breeding", "guard")
	_check(GameState.has_mate and not GameState.mate_name.is_empty() and breeding.get("flavor", "").contains(GameState.mate_name), "Actual breeding resolution must introduce the named mate through the shared action hook.")
	for species_id in ["trex", "allosaurus", "ankylosaurus"]:
		GameState.sex = "female"
		GameState.start_run(species_id)
		GameState.life_stage = 3
		GameState.pending_egg = true
		TurnManager._check_pending_egg()
		TurnManager._check_hatchling_event()
		var child: String = GameState.offspring_name
		GameState.nesting_score = 1.0
		GameState.has_young_turns = int(SpeciesDB.get_species(species_id).get("nesting_seasons", 3)) + 1
		TurnManager._check_nesting_outcome()
		_check(GameState.has_juvenile and GameState.juvenile_name == child and GameState.offspring_history.is_empty(), "Maternal species must keep the same named child through the juvenile phase: " + species_id)
		GameState.offspring_bond = 0.6
		GameState.maternal_outcome_pending = true
		TurnManager._check_maternal_bond_outcome()
		_check(GameState.offspring_history.size() == 1 and GameState.offspring_history[0]["name"] == child and GameState.offspring_history[0]["bond"] == "strong", "Maternal departure must preserve identity and use the final bond: " + species_id)


func _check_life_stories() -> void:
	GameState.sex = "male"
	GameState.start_run("compsognathus")
	GameState.life_stage = 3
	GameState.seasons_elapsed = 10
	var before := LIFE_STORY.action_snapshot()
	GameState.has_mate = true
	var result := {"flavor": "A successful breeding season."}
	LIFE_STORY.note_action(before, result)
	var mate: String = GameState.mate_name
	_check(not mate.is_empty() and result["flavor"].contains(mate), "Successful mating must introduce the persistent mate.")
	GameState.has_mate = false
	before = LIFE_STORY.action_snapshot()
	GameState.has_mate = true
	LIFE_STORY.note_action(before, result)
	_check(GameState.mate_name == mate, "Returning breeding seasons must preserve mate identity.")
	GameState.pending_egg = true
	_check(TurnManager._check_pending_egg(), "An actual clutch must start the parenting cycle.")
	_check(TurnManager._check_hatchling_event(), "Hatchling events must introduce a named offspring.")
	var child: String = GameState.offspring_name
	_check(not child.is_empty() and child != mate, "Offspring must have a distinct identity.")
	GameState.nesting_score = 1.0
	GameState.has_young_turns = int(SpeciesDB.get_species(GameState.species_id).get("nesting_seasons", 3)) + 1
	_check(TurnManager._check_nesting_outcome(), "The actual nesting outcome must record the family consequence.")
	_check(GameState.offspring_history.size() == 1 and GameState.offspring_history[0]["bond"] == "strong", "Good parenting must leave a strong bond.")
	GameState.hunger = 0.2
	_check(LIFE_STORY.next_reunion().is_empty(), "An offspring must not return immediately after departure.")
	GameState.seasons_elapsed += 2
	GameState.hunger = 0.8
	_check(LIFE_STORY.next_reunion().is_empty(), "Family reunions must wait for a lean season.")
	GameState.hunger = 0.2
	GameState.health = 0.5
	GameState.save_run()
	GameState.start_run("trex")
	_check(GameState.life_events.is_empty() and GameState.offspring_history.is_empty(), "New runs must reset family and memories.")
	GameState.load_run()
	var reunion := LIFE_STORY.next_reunion()
	_check(reunion.get("flavor", "").contains(child) and is_equal_approx(GameState.hunger, 0.38) and is_equal_approx(GameState.health, 0.54), "A saved strong bond must return the same offspring with modest food and health aid.")
	GameState.hunger = 0.2
	_check(LIFE_STORY.next_reunion().is_empty(), "Each offspring may help only once.")
	LIFE_STORY.finish_parenting(child, "strong")
	_check(GameState.offspring_history.size() == 1, "Repeated outcome resolution must not create duplicate family rewards.")
	var distant_child := LIFE_STORY._new_name()
	LIFE_STORY.finish_parenting(distant_child, "distant")
	LIFE_STORY.finish_parenting(LIFE_STORY._new_name(), "lost")
	GameState.seasons_elapsed += 2
	var hunger_before: float = GameState.hunger
	reunion = LIFE_STORY.next_reunion()
	_check(reunion.get("flavor", "").contains(distant_child) and GameState.hunger == hunger_before, "A distant offspring must remember neglect and provide no aid.")
	_check(LIFE_STORY.next_reunion().is_empty(), "Lost offspring must never return.")
	_check(LIFE_STORY.earned_title({"kin_created": 3, "offspring_history": [{"bond": "lost"}]}) != "Line Keeper", "Failed nests must not earn the successful-parenting title.")
	_check(LIFE_STORY.earned_title({"offspring_history": [{"bond": "strong"}, {"bond": "steady"}]}) == "Line Keeper", "Successfully raising multiple offspring must earn a parenting title.")
	GameState.death_cause = "starvation"
	GameState.death_detail = "Dry, Year 4"
	var death = load("res://scenes/ui/death_screen.tscn").instantiate()
	root.add_child(death)
	await get_tree().process_frame
	await get_tree().process_frame
	var record: Dictionary = death._run_record
	var memorial := LIFE_STORY.memorial_for(record)
	_check(memorial["moments"].size() == 3 and LIFE_STORY.share_text(record).contains("Dry, Year 4"), "Death must build three defining moments and a shareable, specific ending.")
	_check("\n".join(memorial["moments"]).contains(child), "Parenting must remain part of the recorded life story.")
	var stored: Dictionary = LegacyManager.get_run_history().back()
	var stored_text := LIFE_STORY.share_text(stored)
	record["memorial"]["title"] = "changed"
	_check(LIFE_STORY.share_text(stored) == stored_text, "Saved memorials must not change when the active record changes.")
	var card: Control = death.get_node("Scroll/VBox/Margin/Content/Memorial")
	_check(card.size.x <= root.get_visible_rect().size.x - 48.0 and card.get_node("Content/Portrait").texture != null, "Death memorial must fit phone width and show stage artwork.")
	death.queue_free()
	await get_tree().process_frame
	var old_record := {"species_id": "trex", "display_name": "Tyrannosaurus Rex", "max_stage_reached": 4.0, "seasons": 26.0, "kills": 14.0, "death_cause": "natural"}
	memorial = LIFE_STORY.memorial_for(old_record)
	_check(memorial["title"] == "Old Soul" and memorial["moments"].size() == 3, "Old JSON lineage records must receive truthful stat-based memorials.")
	LegacyManager.check_and_save(old_record)
	var menu = load("res://scenes/ui/main_menu.tscn").instantiate()
	root.add_child(menu)
	menu._show_lineage_panel()
	await get_tree().process_frame
	await get_tree().process_frame
	var lineage: Control = menu.get_child(menu.get_child_count() - 1)
	var panel: Control = lineage.get_child(0)
	_check(panel.get_global_rect().position.x >= 0 and panel.get_global_rect().end.x <= root.get_visible_rect().size.x, "Lineage must fit the phone viewport.")
	menu._show_memorial(stored)
	await get_tree().process_frame
	await get_tree().process_frame
	var view = menu.get_child(menu.get_child_count() - 1)
	var close: Control = view.get_node("Margin/Content/CloseButton")
	_check(close.get_global_rect().end.y <= root.get_visible_rect().size.y - 40, "Memorial close button must stay outside the bottom safe area.")
	_check(view.card.title_label.text == "The " + stored["memorial"]["title"], "Lineage must reopen the stored memorial.")
	if "--capture-memorial" in OS.get_cmdline_user_args():
		await RenderingServer.frame_post_draw
		var capture := root.get_texture().get_image()
		_check(capture.save_png("res://.godot/handoff_memorial.png") == OK, "Memorial preview must export.")
	menu.queue_free()
	GameState.delete_save()
	print("Life stories checked: family continuity, parenting consequences, save/resume, immutable memorials, old lineage and phone-width layouts.")


func _check_chapter_ads() -> void:
	var native := NativeAdMock.new()
	root.add_child(native)
	var old_plugin = AdManager._interstitial_plugin
	var old_ad_free: bool = StoreManager._ad_free
	AdManager._interstitial_plugin = native
	StoreManager._ad_free = false
	AdManager.load_interstitial()
	AdManager._on_interstitial_loaded(native.loaded_uid)
	StoryState.reset()
	StoryState.current_scene_id = "s1_morning"
	var screen = load("res://scripts/story/story_screen.gd").new()
	root.add_child(screen)
	await get_tree().process_frame
	await get_tree().process_frame
	var initial_music_length: float = screen._music_player.stream.get_length()
	for scene_id in ["s2_mother", "s2_meal", "s3_boundary"]:
		screen._navigate(scene_id)
		await get_tree().process_frame
	_check(native.shown_uid == -1, "Three scenes within one chapter must not trigger an ad.")
	screen._navigate("s10_hunt")
	await get_tree().process_frame
	_check(native.shown_uid == native.loaded_uid, "A forward chapter boundary must offer the ready interstitial.")
	AdManager._on_interstitial_closed(native.shown_uid)
	AdManager._on_interstitial_loaded(native.loaded_uid)
	native.shown_uid = -1
	screen._show_scene("s1_morning")
	await get_tree().process_frame
	_check(native.shown_uid == -1, "Restoring an earlier chapter must not trigger an ad.")
	await get_tree().create_timer(0.8).timeout
	_check(is_equal_approx(screen._music_player.stream.get_length(), initial_music_length), "Quick chapter changes must finish on the current chapter's music.")
	screen.queue_free()
	AdManager._interstitial_plugin = old_plugin
	AdManager._is_interstitial_loaded = false
	StoreManager._ad_free = old_ad_free
	native.queue_free()
	StoryState.delete_save()
	print("Story ad pacing checked: uninterrupted scenes, chapter boundary, and restore without ads.")


func _check_companions() -> void:
	for species_id in ["compsognathus", "iguanodon", "deinonychus", "triceratops", "velociraptor", "lesothosaurus", "argentinosaurus"]:
		GameState.sex = "male"
		GameState.start_run(species_id)
		GameState.life_stage = 3
		var stages: Array = SpeciesDB.get_species(species_id)["life_stages"]
		var adult_start: int = stages[0] + stages[1] + stages[2]
		GameState.seasons_elapsed = adult_start + posmod(1 - adult_start, 4)
		GameState.current_season = 1
		GameState.current_year = int(GameState.seasons_elapsed / 4.0) + 1
		GameState.hunger = 0.8
		GameState.health = 0.8
		COMPANIONS.ensure_cast()
		var cast := COMPANIONS.current_cast()
		var steady: String = cast[0]["name"]
		var challenger: String = cast[1]["name"]
		_check(cast.size() >= 3 and cast.size() <= COMPANIONS.max_companions() and steady != challenger and cast[0]["role"] != cast[1]["role"], "Each social species needs a bounded roster with distinct recurring personalities: " + species_id)
		var turn_events: Array = []
		var capture_event := func(event: Dictionary): turn_events.append(event)
		TurnManager.event_fired.connect(capture_event)
		TurnManager.start_turn()
		TurnManager.event_fired.disconnect(capture_event)
		_check(turn_events.size() == 1 and turn_events[0].get("resolve_key") == "companions", "The actual turn loop must introduce companions before ordinary world events.")
		var intro := COMPANIONS.pending_event()
		_check(intro.get("flavor", "").contains(steady) and intro.get("flavor", "").contains(challenger), "The introduction must name both companions.")
		if species_id == "deinonychus":
			_check(intro["flavor"].contains("wind") and COMPANIONS.personality(cast[0]) == "Dependable scout", "Deinonychus needs hunting personalities and its own introduction.")
		elif species_id == "triceratops":
			_check(intro["flavor"].contains("defensive circle") and COMPANIONS.group_name() == "herd", "Triceratops needs herd guardians and its own introduction.")
		elif species_id == "velociraptor":
			_check(intro["flavor"].contains("flank") and COMPANIONS.personality(cast[1]) == "Rank-minded hunter", "Velociraptor needs flanking partners and rank rivalry.")
		elif species_id == "lesothosaurus":
			_check(intro["flavor"].contains("warning") and COMPANIONS.personality(cast[0]) == "Watchful lookout", "Lesothosaurus needs lookouts and escape-focused companions.")
		elif species_id == "argentinosaurus":
			_check(intro["flavor"].contains("rumbles") and COMPANIONS.personality(cast[0]) == "Patient trailkeeper", "Argentinosaurus needs companions built around calls, crossings, and shared pace.")
		ActionResolver.resolve("companions", "welcome")
		var count: int = GameState.companion_event_count
		ActionResolver.resolve("companions", "welcome")
		_check(GameState.companion_event_count == count and COMPANIONS.next_event().is_empty(), "An event must resolve only once and leave a two-season gap.")
		_check(COMPANIONS.relationship(cast[0]) == "Trusting" and COMPANIONS.relationship(cast[1]) == "Wary", "The dependable companion should warm up sooner than the challenger.")
		GameState.seasons_elapsed += 2
		var food := COMPANIONS.next_event()
		_check(food.get("flavor", "").contains(steady), "The same companion must return for a later food choice.")
		if species_id in ["deinonychus", "triceratops"]:
			_check(food["flavor"].contains("kill" if species_id == "deinonychus" else "browse"), "Food-sharing must match the new species' feeding story.")
		elif species_id in ["velociraptor", "lesothosaurus"]:
			_check(food["flavor"].contains("blind side" if species_id == "velociraptor" else "tender shoots"), "The next batch must use its own feeding encounters.")
		elif species_id == "argentinosaurus":
			_check(food["flavor"].contains("stripped branches") and food["flavor"].contains("crossing"), "Argentinosaurus sharing must remember the companion who waited for the herd.")
		GameState.save_run()
		GameState.start_run("trex")
		_check(GameState.companions.is_empty() and GameState.companion_event.is_empty(), "A new run must reset companions and pending choices.")
		GameState.load_run()
		cast = COMPANIONS.current_cast()
		_check(cast[0]["name"] == steady and cast[1]["name"] == challenger and COMPANIONS.pending_event().get("flavor", "") == food["flavor"], "Save/resume must preserve names, trust, and the unanswered choice.")
		var hunger_before: float = GameState.hunger
		ActionResolver.resolve("companions", "share")
		_check(is_equal_approx(GameState.hunger, hunger_before - 0.08) and cast[0]["reason"].contains("shared food"), "Food-sharing must cost reserves and leave a readable memory.")
		GameState.seasons_elapsed += 2
		var protection := COMPANIONS.next_event()
		_check(protection.get("flavor", "").contains(challenger), "The challenger must get a separate protection encounter.")
		var health_before: float = GameState.health
		var food_before: float = GameState.hunger
		GameState.health = 0.04
		GameState.hunger = 0.02
		var safe_choices: Array = COMPANIONS.pending_event()["choices"].map(func(option): return option["action"])
		var count_before: int = GameState.companion_event_count
		var retry: Dictionary = ActionResolver.resolve("companions", "stand")
		_check("warn" in safe_choices and "stand" not in safe_choices and "cover" not in safe_choices, "A weakened dinosaur must still have a free way to help without abandoning its companion.")
		_check(retry.get("resolve_key") == "companions" and GameState.companion_event_count == count_before and is_equal_approx(GameState.health, 0.04), "An unaffordable saved choice must refresh its options without applying costs.")
		GameState.health = health_before
		GameState.hunger = food_before
		ActionResolver.resolve("companions", "stand")
		_check(is_equal_approx(GameState.health, health_before - 0.06) and COMPANIONS.relationship(cast[1]) == "Trusting", "Protection must cost health and earn the challenger's trust.")
		GameState.seasons_elapsed += 2
		GameState.hunger = 0.2
		GameState.health = 0.25
		GameState.injuries = [{"name": "Twisted Leg", "stat": "speed", "amount": -0.07, "turns_remaining": 3}]
		ActionResolver._pending_prey = {"name": "a much larger rival", "fight_power": 0.4, "size": GameState.size + 3, "hunger_value": 0.0}
		var preview: Dictionary = ActionResolver._show_combat_preview(false)
		var clue: String = preview["flavor"]
		_check(clue.contains("towers") and clue.contains("badly weakened") and clue.contains("food reserves") and clue.contains("leg") and clue.contains(steady), "Before combat, size, injury, hunger, low health, and willing companions must be visible.")
		var actions: Array = preview["choices"].map(func(option): return option["action"])
		_check("combat_companions" in actions, "Trusted companions must offer a combat support choice for both pack and herd.")
		_check(("combat_pack" in actions) == (species_id in ["compsognathus", "deinonychus", "velociraptor"]), "Combat must distinguish a predator pack from a herbivore herd using existing species metadata.")
		# Give the enemy trivial power for a safe exercise of the real combat route.
		ActionResolver._pending_combat_context["enemy"]["fight_power"] = 0.01
		ActionResolver._pending_combat_context["enemy"]["size"] = 1
		ActionResolver._pending_combat_context["enemy"]["power"] = 0.01
		ActionResolver._pending_combat_context["enemy"]["resilience"] = 0.01
		GameState.health = 0.9
		var combat: Dictionary = ActionResolver.resolve("combat_preview", "combat_companions")
		_check(combat.get("flavor", "").contains(steady) and combat.get("flavor", "").contains(challenger) and COMPANIONS.supporters().is_empty(), "Combat must consume and name the companions who actually helped.")
		var previous_wins: int = GameState.fights_won
		ActionResolver.resolve("combat_preview", "combat_companions")
		_check(GameState.fights_won == previous_wins, "A consumed combat choice must not replay combat or rewards.")
		GameState.save_run()
		GameState.load_run()
		_check(COMPANIONS.supporters().is_empty(), "Used companion support must stay consumed across save/resume.")
		var memorial := LIFE_STORY.build_memorial({"display_name": species_id, "life_events": GameState.life_events})
		_check("\n".join(memorial["moments"]).contains("stood beside you"), "Actual companion support must become part of the memorial.")
		GameState.seasons_elapsed += 1
		_check(COMPANIONS.supporters().size() == 2, "Trusted companions can help again in a later season.")
		GameState.injuries = []
		GameState.hunger = 0.8
		GameState.health = 0.8
		GameState.companion_event = {}
		if species_id == "compsognathus":
			GameState.is_alpha = true
			seed(23)
			var defense: Dictionary = PackManager.resolve_defender_fight()
			_check(defense.get("flavor", "").contains(steady) and COMPANIONS.supporters().is_empty(), "Trust earned through food-sharing must support an actual leadership challenge.")
			# The combat roll may disband the group; prepare the departure checks independently.
			GameState.pack_bond = 0.6
			for member in COMPANIONS.current_cast():
				member["active"] = true
		GameState.companion_event = {"kind": "lead", "name": challenger, "season": GameState.seasons_elapsed}
		var route_food: float = GameState.hunger
		ActionResolver.resolve("companions", "cooperate")
		_check(is_equal_approx(GameState.hunger, route_food - 0.05) and COMPANIONS.current_cast()[1]["reason"].contains("judgment"), "Listening to the challenger must cost scouting energy and be remembered.")
		GameState.companion_event = {"kind": "protect", "name": challenger, "season": GameState.seasons_elapsed}
		ActionResolver.resolve("companions", "abandon")
		_check(COMPANIONS.relationship(COMPANIONS.current_cast()[1]) == "Gone" and challenger not in COMPANIONS.supporters(), "Abandoned companions must leave and stop offering support.")
		var departing: Dictionary = COMPANIONS.current_cast()[0]
		departing["trust"] = 0.0
		for turn in 2:
			GameState.companion_event = {"kind": "share", "name": steady, "season": GameState.seasons_elapsed}
			ActionResolver.resolve("companions", "keep")
		_check(COMPANIONS.relationship(departing) == "Gone", "Repeated neglect must eventually cause a departure.")
		var old_names: Array = GameState.companions.map(func(member): return member["name"])
		PackManager.join_group(0.5)
		_check(COMPANIONS.current_cast()[0]["name"] not in old_names and COMPANIONS.current_cast()[1]["name"] not in old_names, "Joining another group must create new faces without reusing departed identities.")
		# Leave an unanswered intro, then instantiate the real game screen to check restoration and UI.
		COMPANIONS.next_event()
		GameState.current_season = GameState.seasons_elapsed % 4
		GameState.current_year = int(GameState.seasons_elapsed / 4.0) + 1
		var game = load("res://scenes/game/game_screen.tscn").instantiate()
		root.add_child(game)
		await get_tree().process_frame
		await get_tree().process_frame
		_check(game._waiting_for_choice and game._action_context == "companions", "The real game screen must restore the pending companion choice.")
		game.event_overlay._on_choice("welcome")
		game.event_overlay._on_choice("welcome")
		game.event_overlay._on_choice("ok")
		game.event_overlay._on_choice("ok")
		await get_tree().process_frame
		var panel = game.companions_panel
		game._dashboard._show_pack()
		await get_tree().process_frame
		var first_card: Control = panel.cards.get_child(0)
		_check(panel.visible and panel.expanded and first_card.get_node("Content/Identity/Name").text == COMPANIONS.current_cast()[0]["name"], "The actual game screen must display names, states, and expandable relationship details.")
		_check(panel.heading.text == "YOUR " + COMPANIONS.group_name().to_upper() and first_card.get_node("Content/Extra/Role").text.begins_with(COMPANIONS.personality(COMPANIONS.current_cast()[0])) and first_card.get_node("Content/Extra/Role").text.contains("Cautious"), "The real panel must retain the species role and show the persistent personality.")
		var scroll: ScrollContainer = panel.get_parent()
		_check(panel.size.x <= scroll.size.x and scroll.get_v_scroll_bar().max_value > scroll.get_v_scroll_bar().page, "Expanded companion details must fit phone width and scroll through every member.")
		await _check_companion_scrolling(game, panel, scroll)
		if "--capture-memorial" in OS.get_cmdline_user_args():
			await RenderingServer.frame_post_draw
			root.get_texture().get_image().save_png("res://.godot/companions_%s_details.png" % species_id)
			game._dashboard.pack_view.hide()
			await get_tree().process_frame
			await RenderingServer.frame_post_draw
			root.get_texture().get_image().save_png("res://.godot/companions_%s.png" % species_id)
			GameState.health = 0.25
			GameState.hunger = 0.2
			GameState.injuries = [{"name": "Twisted Leg", "stat": "speed", "amount": -0.07, "turns_remaining": 3}]
			ActionResolver._pending_prey = {"name": "a much larger rival", "fight_power": 0.4, "size": GameState.size + 3, "hunger_value": 0.0}
			preview = ActionResolver._show_combat_preview(false)
			game._on_event_ready(preview)
			game.event_overlay._on_choice("combat_companions")  # Reveal the clues without accepting the choice.
			await get_tree().process_frame
			await get_tree().create_timer(0.25).timeout
			await check_choice_layout(game.event_overlay)
			await RenderingServer.frame_post_draw
			root.get_texture().get_image().save_png("res://.godot/companions_%s_risk.png" % species_id)
			if species_id in ["deinonychus", "triceratops", "velociraptor", "lesothosaurus", "argentinosaurus"]:
				GameState.health = 0.8
				GameState.hunger = 0.8
				for kind in ["protect", "lead"]:
					GameState.companion_event = {"kind": kind, "name": COMPANIONS.current_cast()[1]["name"]}
					var encounter := COMPANIONS.pending_event()
					game.event_overlay.show_event(encounter)
					game.event_overlay._on_choice("warn" if kind == "protect" else "scout")
					await get_tree().create_timer(0.25).timeout
					await check_choice_layout(game.event_overlay)
					await RenderingServer.frame_post_draw
					root.get_texture().get_image().save_png("res://.godot/companions_%s_%s.png" % [species_id, kind])
		game.queue_free()
		await get_tree().process_frame
	for species_id in ["trex", "allosaurus"]:
		GameState.start_run(species_id)
		GameState.life_stage = 3
		COMPANIONS.ensure_cast()
		_check(GameState.companions.is_empty() and COMPANIONS.next_event().is_empty(), "Solitary species must keep their existing gameplay.")
	GameState.delete_save()
	print("Companions checked: all seven species, distinct hunting/herd stories, trust and departure, saves and pending choices, combat and leadership support, risk clues, memorials and real game UI.")


func _check_companion_scrolling(game: Control, panel: Control, scroll: ScrollContainer) -> void:
	# ScrollContainer uses mouse events from touch emulation on phones. Exercise
	# viewport hit testing over the actual cards, rather than setting the scrollbar.
	var was_emulating := Input.is_emulating_touch_from_mouse()
	Input.set_emulate_touch_from_mouse(true)
	_check(DisplayServer.is_touchscreen_available(), "Companion swipe tests require touchscreen emulation.")
	var actions: Control = game.get_node("ActionScroll/ActionList/ActionMargin/CardsContainer")
	var chosen: Array[String] = []
	var capture := func(action: String): chosen.append(action)
	for action in actions.get_children():
		action.card_pressed.connect(capture)
	var card: Control = panel.cards.get_child(0)
	for path in ["Content/Identity/Name", "Content/Identity/Badge", "Content/Extra/Role", "Content/Extra/Reason"]:
		scroll.scroll_vertical = 0
		await get_tree().process_frame
		var target: Control = card.get_node(path)
		scroll.ensure_control_visible(target)
		await get_tree().process_frame
		var before_swipe := scroll.scroll_vertical
		var point := target.get_global_rect().get_center()
		_check(scroll.get_global_rect().has_point(point), "Companion swipe target must be visible: " + path)
		_swipe_companion(point)
		_check(scroll.scroll_vertical > before_swipe, "Swiping over a companion must scroll: " + path)
	# Exercise enough real swipes to traverse the entire variable-sized roster.
	var bottom := int(scroll.get_v_scroll_bar().max_value - scroll.get_v_scroll_bar().page)
	for i in ceili(float(bottom) / 65.0) + 2:
		if scroll.scroll_vertical >= bottom:
			break
		_swipe_companion(scroll.get_global_rect().get_center())
		await get_tree().process_frame
	_check(scroll.scroll_vertical >= bottom, "Companion swipes must reach the bottom of the actions (%d / %d)." % [scroll.scroll_vertical, bottom])
	_check(panel.get_global_rect().end.y <= scroll.get_global_rect().end.y + 1, "The final roster member must be reachable after swiping.")
	_check(chosen.is_empty(), "Swiping through members must not select a gameplay action.")
	for action in actions.get_children():
		action.card_pressed.disconnect(capture)
	scroll.scroll_vertical = 0
	await get_tree().process_frame
	var wheel := InputEventMouseButton.new()
	scroll.ensure_control_visible(card.get_node("Content/Identity/Name"))
	await get_tree().process_frame
	var before_wheel := scroll.scroll_vertical
	wheel.position = card.get_global_rect().position + Vector2(20, 20)
	wheel.button_index = MOUSE_BUTTON_WHEEL_DOWN
	wheel.pressed = true
	root.push_input(wheel, true)
	_check(scroll.scroll_vertical > before_wheel, "Mouse wheel scrolling over companion cards must also work.")
	wheel = wheel.duplicate()
	wheel.pressed = false
	root.push_input(wheel, true)
	scroll.scroll_vertical = 0
	await get_tree().process_frame
	var close: Button = scroll.get_parent().get_node("Close")
	_check(close.size.y >= 44 and close.get_global_rect().end.y <= root.size.y, "Back must remain visible outside the roster scroll.")
	_click_companion_control(close)
	_check(not game._dashboard.pack_view.visible, "Back must return to gameplay.")
	_click_companion_control(game._dashboard.pack_button)
	_check(game._dashboard.pack_view.visible and panel.expanded, "The portrait button must reopen full relationship details.")
	if GameState.species_id == "velociraptor":
		var old_scale := root.content_scale_size
		root.content_scale_size = Vector2i(320, 568)
		root.size = Vector2i(320, 568)
		await get_tree().process_frame
		await get_tree().process_frame
		for member_card in panel.cards.get_children():
			_check(member_card.size.x <= scroll.size.x and member_card.get_global_rect().end.x <= 300, "Companion cards must fit a smaller phone without horizontal clipping.")
		_swipe_companion(scroll.get_global_rect().get_center())
		_check(scroll.scroll_vertical > 0, "Expanded companion cards must also respond to swipes on a smaller phone.")
		if "--capture-memorial" in OS.get_cmdline_user_args():
			await RenderingServer.frame_post_draw
			root.get_texture().get_image().save_png("res://.godot/companions_small.png")
		root.content_scale_size = old_scale
		root.size = Vector2i(390, 844)
		scroll.scroll_vertical = 0
		await get_tree().process_frame
		await get_tree().process_frame
	Input.set_emulate_touch_from_mouse(was_emulating)
	await get_tree().process_frame


func _click_companion_control(control: Control) -> void:
	var motion := InputEventMouseMotion.new()
	motion.position = control.get_global_rect().get_center()
	Input.parse_input_event(motion)
	Input.flush_buffered_events()
	var click := InputEventMouseButton.new()
	click.position = control.get_global_rect().get_center()
	click.button_index = MOUSE_BUTTON_LEFT
	click.pressed = true
	click.button_mask = MOUSE_BUTTON_MASK_LEFT
	root.push_input(click, true)
	click = click.duplicate()
	click.pressed = false
	click.button_mask = 0
	root.push_input(click, true)


func _swipe_companion(point: Vector2) -> void:
	var press := InputEventScreenTouch.new()
	press.position = point
	press.pressed = true
	Input.parse_input_event(press)
	Input.flush_buffered_events()
	var drag := InputEventScreenDrag.new()
	drag.position = point + Vector2(0, -65)
	drag.relative = Vector2(0, -65)
	Input.parse_input_event(drag)
	Input.flush_buffered_events()
	var release := InputEventScreenTouch.new()
	release.position = drag.position
	Input.parse_input_event(release)
	Input.flush_buffered_events()


func _check_dein_companion_challenges() -> void:
	for species_id in ["deinonychus", "triceratops", "velociraptor", "lesothosaurus", "argentinosaurus"]:
		GameState.start_run(species_id)
		GameState.sex = "male"
		GameState.life_stage = 3
		var stages: Array = SpeciesDB.get_species(species_id)["life_stages"]
		var adult_start: int = stages[0] + stages[1] + stages[2]
		GameState.seasons_elapsed = adult_start + posmod(2 - adult_start, 4)
		GameState.current_season = 2
		GameState.hunger = 0.8
		COMPANIONS.ensure_cast()
		var names: Array = COMPANIONS.current_cast().map(func(member): return member["name"])
		var events: Array = []
		var capture_event := func(event: Dictionary): events.append(event)
		TurnManager.event_fired.connect(capture_event)
		TurnManager.start_turn()
		TurnManager.event_fired.disconnect(capture_event)
		var expected := "dein_sub_mating" if species_id == "deinonychus" else "mate_pack_alpha_male_sub" if species_id == "velociraptor" else "pattern_b_tournament"
		_check(events.size() == 1 and events[0].get("resolve_key") == expected and GameState.companion_event.is_empty(), "Existing breeding events must retain priority over companion introductions: " + species_id)
		_check(COMPANIONS.current_cast()[0]["name"] == names[0], "Breeding-season events must retain companion identities.")
	for context in ["dein_sub_mating", "dein_rival_challenge"]:
		var victories := 0
		var defeats := 0
		var injuries := 0
		for roll_seed in range(1, 25):
			GameState.start_run("deinonychus")
			GameState.sex = "male"
			GameState.life_stage = 3
			GameState.seasons_elapsed = 18
			GameState.current_season = 2
			GameState.health = 1.0
			GameState.daily_luck = 0.0
			GameState.is_alpha = context == "dein_rival_challenge"
			COMPANIONS.ensure_cast()
			for member in COMPANIONS.current_cast():
				member["trust"] = 1.0
			var names := COMPANIONS.supporters()
			var helpers := names.duplicate()
			if not GameState.is_alpha:
				helpers.erase(str(preload("res://scripts/systems/pack_leadership.gd").leader()["name"]))
			seed(roll_seed)
			var result: Dictionary = ActionResolver.resolve(context, "challenge" if context == "dein_sub_mating" else "fight")
			_check(helpers.all(func(name): return result["flavor"].contains(name)) and helpers.all(func(name): return name not in COMPANIONS.supporters()), "Deinonychus challenges must credit actual helpers, excluding the incumbent alpha.")
			_check(GameState.pack_bond > 0.0 and COMPANIONS.current_cast()[0]["active"], "Deinonychus coalition losses must preserve the pack and companions.")
			if GameState.is_alpha:
				victories += 1
				_check(GameState.alpha_breed_pending, "A supported mating-season win must retain the breeding continuation.")
			else:
				defeats += 1
				_check(not GameState.alpha_breed_pending, "Losing leadership must not grant the alpha breeding continuation.")
			for injury in GameState.injuries:
				injuries += 1
				_check(injury["name"] in ["Sickle Claw Slash", "Pack Rake", "Feather Bite"], "Supported challenges must keep Deinonychus-specific injuries.")
		_check(victories > 0 and defeats > 0 and injuries > 0, "Deinonychus support checks must exercise victory, defeat, and injury for " + context)
		GameState.start_run("deinonychus")
		GameState.life_stage = 3
		COMPANIONS.ensure_cast()
		COMPANIONS.current_cast()[0]["trust"] = 1.0
		var ready := COMPANIONS.supporters()
		ActionResolver.resolve(context, "stay" if context == "dein_sub_mating" else "yield")
		_check(COMPANIONS.supporters() == ready, "Declining a leadership fight must leave companion support available.")
	print("Deinonychus challenges checked: named support, win/loss/injury, retained coalition and breeding continuation.")


func _check_velociraptor_companion_challenges() -> void:
	for context in ["alpha_challenge_mandatory", "mate_pack_alpha_male_sub", "rival_challenge"]:
		var victories := 0
		var defeats := 0
		var injuries := 0
		for roll_seed in range(1, 25):
			GameState.start_run("velociraptor")
			GameState.sex = "male"
			GameState.life_stage = 3
			GameState.seasons_elapsed = 22
			GameState.current_season = 2
			GameState.health = 1.0
			GameState.daily_luck = 0.0
			GameState.is_alpha = context == "rival_challenge"
			COMPANIONS.ensure_cast()
			for member in COMPANIONS.current_cast():
				member["trust"] = 1.0
			var names := COMPANIONS.supporters()
			var helpers := names.duplicate()
			if not GameState.is_alpha:
				helpers.erase(str(preload("res://scripts/systems/pack_leadership.gd").leader()["name"]))
			GameState.companion_event = {"kind": "protect", "name": names[1]}
			seed(roll_seed)
			var result: Dictionary = ActionResolver.resolve(context, "fight" if context == "rival_challenge" else "alpha_fight")
			var flavor: String = result["flavor"]
			_check(helpers.all(func(name): return flavor.contains(name)) and helpers.all(func(name): return name not in COMPANIONS.supporters()), "Velociraptor leadership must credit actual helpers once, excluding the incumbent.")
			_check(flavor.count("backed your claim") + flavor.count("stayed beside you") == 1, "Custom leadership flavor must preserve support without duplicating the note.")
			for member in COMPANIONS.current_cast():
				_check((member["help_season"] == GameState.seasons_elapsed) == (member["name"] in helpers), "Only actual leadership supporters must consume their season's aid.")
			if GameState.is_alpha:
				victories += 1
				_check(GameState.pack_bond > 0.0 and COMPANIONS.current_cast()[0]["active"], "Winning leadership must retain Velociraptor companions.")
				if context != "alpha_challenge_mandatory":
					_check(GameState.has_mate and GameState.pending_egg, "A breeding-season leadership win must retain the mating outcome.")
			else:
				defeats += 1
				_check(GameState.pack_bond == 0.0 and COMPANIONS.current_cast().all(func(member): return not member["active"]) and GameState.companion_event.is_empty(), "Velociraptor leadership losses must disband the pack and clear pending companion choices.")
				_check(not GameState.has_mate and not GameState.pending_egg, "A lost leadership fight must not grant a mate.")
				if defeats == 1:
					GameState.save_run()
					GameState.start_run("trex")
					GameState.load_run()
					_check(COMPANIONS.current_cast()[0]["name"] == names[0] and COMPANIONS.relationship(COMPANIONS.current_cast()[0]) == "Gone" and COMPANIONS.supporters().is_empty(), "Disbanded Velociraptor companions must remain gone after save/resume.")
			injuries += GameState.injuries.size()
		_check(victories > 0 and defeats > 0 and injuries > 0, "Velociraptor checks must cover win, loss, and injury for " + context)
	for species_id in ["velociraptor", "lesothosaurus"]:
		GameState.start_run(species_id)
		GameState.life_stage = 3
		COMPANIONS.ensure_cast()
		var member: Dictionary = COMPANIONS.current_cast()[1]
		GameState.health = 0.04
		GameState.hunger = 0.02
		GameState.companion_event = {"kind": "protect", "name": member["name"]}
		var warning: Dictionary = ActionResolver.resolve("companions", "warn")
		_check(is_equal_approx(GameState.health, 0.04) and is_equal_approx(GameState.hunger, 0.02) and is_equal_approx(member["trust"], 0.1), "Weak members of the next batch must retain a free warning that builds trust.")
		_check(warning["flavor"].contains("brush" if species_id == "velociraptor" else "grass"), "Free warnings need species-specific outcomes.")
	GameState.delete_save()
	print("Next batch checked: Velociraptor leadership win/loss/injury and disband saves, breeding priority, and free species-specific warnings.")


func _check_argentinosaurus_companions() -> void:
	GameState.start_run("argentinosaurus")
	GameState.sex = "male"
	GameState.life_stage = 1
	GameState.seasons_elapsed = 5
	GameState.current_season = 1
	COMPANIONS.ensure_cast()
	var names: Array = COMPANIONS.current_cast().map(func(member): return member["name"])
	COMPANIONS.next_event()
	ActionResolver.resolve("companions", "welcome")
	GameState.life_stage = 4
	GameState.seasons_elapsed = 75
	GameState.current_season = 3
	GameState.current_year = 19
	GameState.hunger = 0.8
	GameState.health = 0.8
	var events: Array = []
	var capture_event := func(event: Dictionary): events.append(event)
	TurnManager.event_fired.connect(capture_event)
	TurnManager.start_turn()
	TurnManager.event_fired.disconnect(capture_event)
	_check(events.size() == 1 and events[0].get("resolve_key") == "elder_final_argentinosaurus", "Argentinosaurus's elder trial must retain priority over companion encounters.")
	_check(COMPANIONS.current_cast()[0]["name"] == names[0] and COMPANIONS.current_cast()[1]["name"] == names[1], "The same Argentinosaurus companions must remain through a long life into Elder.")
	GameState.companion_event = {"kind": "protect", "name": names[1]}
	GameState.health = 0.04
	GameState.hunger = 0.02
	var warning: Dictionary = ActionResolver.resolve("companions", "warn")
	_check(warning["flavor"].contains("stable bank") and is_equal_approx(GameState.health, 0.04) and is_equal_approx(GameState.hunger, 0.02), "A weakened Argentinosaurus must be able to warn its companion without spending health or food.")
	GameState.save_run()
	GameState.start_run("trex")
	GameState.load_run()
	_check(GameState.life_stage == 4 and GameState.elder_final_event_triggered and COMPANIONS.current_cast()[0]["name"] == names[0] and is_equal_approx(COMPANIONS.current_cast()[1]["trust"], 0.35), "Late-life saves must preserve elder trial state, identities, and remembered warning trust.")
	GameState.delete_save()
	print("Argentinosaurus checked: juvenile-to-elder companions, elder trial priority, safe crossing warnings, and late-life save continuity.")
