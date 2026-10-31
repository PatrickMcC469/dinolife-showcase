extends RefCounted

const COMPANIONS = preload("res://scripts/systems/companions.gd")
const LIFE_STORY = preload("res://scripts/systems/life_story.gd")
var harness: Node


func _check(ok: bool, message: String) -> void:
	harness._check(ok, message)


func _reset_unlocks() -> void:
	UnlockManager.unlocked = SpeciesDB.get_default_unlocked()


func _care_record(target: String) -> Dictionary:
	var needs: Dictionary = UnlockManager.CARE_PATHS[target]["needs"]
	var record := {"species_id": UnlockManager.UNLOCK_CONDITIONS[target]["from"], "max_stage_reached": 4,
		"fights_won": 0, "fights_fled": 0, "offspring_history": [], "life_events": []}
	for count in int(needs.get("offspring", 0)):
		record["offspring_history"].append({"name": "Child %d" % count, "bond": "strong"})
	for count in int(needs.get("protections", 0)):
		record["life_events"].append({"key": "companion_protected_Fern_%d" % count, "season": count})
	if needs.has("migrations") or needs.has("territories"):
		record["journey"] = {"kind": "migration" if needs.has("migrations") else "territory", "phase": 3, "reward": 0.04}
	return record


func run(check_harness: Node) -> void:
	harness = check_harness
	var previous_unlocks := UnlockManager.unlocked.duplicate(true)
	var previous_best := LegacyManager._best.duplicate(true)
	var previous_species := LegacyManager._species_bests.duplicate(true)
	var previous_history := LegacyManager._run_history.duplicate(true)
	_check_rules()
	_check_evidence()
	_check_history()
	await _check_ui()
	UnlockManager.unlocked = previous_unlocks
	UnlockManager.save_unlocks()
	LegacyManager._best = previous_best
	LegacyManager._species_bests = previous_species
	LegacyManager._run_history = previous_history
	LegacyManager._save()
	LegacyManager._save_species_bests()
	LegacyManager._save_history()
	GameState.delete_save()
	print("Unlock paths checked: all eight original and care routes, Elder/predecessor gates, real evidence and duplicates, saved single-life bests and old history, live unlock notices, and rendered progress screens.")


func _check_rules() -> void:
	for target in UnlockManager.UNLOCK_CONDITIONS:
		_reset_unlocks()
		var condition: Dictionary = UnlockManager.UNLOCK_CONDITIONS[target]
		var original := {"species_id": condition["from"], "fights_won": condition["value"], "max_stage_reached": 3}
		_check(UnlockManager.check_and_unlock(original).is_empty(), "Original unlocks must still require Elder.")
		original["max_stage_reached"] = 4
		original["fights_won"] -= 1
		_check(UnlockManager.check_and_unlock(original).is_empty(), "Original unlocks must keep their existing encounter thresholds.")
		original["fights_won"] += 1
		_check(UnlockManager.check_and_unlock(original) == [target], "Every original unlock route must remain usable.")
		_check(UnlockManager.check_and_unlock(original).is_empty(), "Original unlocks must not notify or award twice.")
		_reset_unlocks()
		var care := _care_record(target)
		care["max_stage_reached"] = 3
		_check(UnlockManager.check_and_unlock(care).is_empty(), "Complete care achievements must still require Elder in the same life.")
		care["max_stage_reached"] = 4
		var requirements: Dictionary = UnlockManager.CARE_PATHS[target]["needs"]
		for key in requirements:
			var missing := care.duplicate(true)
			match key:
				"offspring": missing["offspring_history"].pop_back()
				"protections": missing["life_events"].pop_back()
				_: missing["journey"]["reward"] = 0.0
			_check(UnlockManager.check_and_unlock(missing).is_empty(), "Every %s care requirement must be needed." % target)
		var wrong_source := care.duplicate(true)
		wrong_source["species_id"] = "trex"
		_check(UnlockManager.check_and_unlock(wrong_source).is_empty(), "Care achievements must come from the specified predecessor.")
		var json_record: Dictionary = JSON.parse_string(JSON.stringify(care))
		_check(UnlockManager.check_and_unlock(json_record) == [target], "Every care route must unlock with zero combat and JSON-restored numbers.")
		UnlockManager.load_unlocks()
		_check(UnlockManager.is_unlocked(target) and UnlockManager.check_and_unlock(care).is_empty(), "New unlocks must persist and remain awarded only once.")
		_check(UnlockManager.get_unlock_hint(target).contains("OR") and UnlockManager.get_unlock_hint(target).contains("same life"), "Unlock hints must explain both paths and their single-life gate.")


func _check_evidence() -> void:
	var proof := {"offspring_history": [{"name": "Fern", "bond": "strong"}, {"name": "Fern", "bond": "strong"}, {"name": "Ash", "bond": "distant"}, {"name": "Rain", "bond": "lost"}, null],
		"life_events": [{"key": "companion_protected_Reed_4"}, {"key": "companion_protected_Reed_4"}, {"key": "companion_shared_Reed"}, "bad"],
		"journey": {"kind": "migration", "phase": 2, "reward": 0.04}}
	var achievements := UnlockManager.run_achievements(proof)
	_check(achievements == {"offspring": 1, "protections": 1, "migrations": 0, "territories": 0}, "Only unique strong offspring, real protection memories and finished journeys must count.")
	for journey in [{"kind": "migration", "phase": 3, "reward": 0.0}, {"kind": "migration", "phase": "3", "reward": 0.04}, {"kind": "migration", "phase": 3.5, "reward": 0.04}, "bad"]:
		proof["journey"] = journey
		_check(UnlockManager.run_achievements(proof)["migrations"] == 0, "Abandoned, malformed and unfinished migrations must not earn progress.")
	GameState.start_run("lesothosaurus")
	GameState.life_stage = 3
	GameState.seasons_elapsed = 10
	COMPANIONS.ensure_cast()
	var member_name: String = COMPANIONS.current_cast()[0]["name"]
	for season in [10, 12]:
		GameState.seasons_elapsed = season
		GameState.companion_event = {"kind": "protect", "name": member_name}
		ActionResolver.resolve("companions", "cover")
		ActionResolver.resolve("companions", "cover")
	_check(UnlockManager.run_achievements(UnlockManager.live_record())["protections"] == 2, "Successful rescues in different seasons must count, while repeated accepts do not.")
	GameState.seasons_elapsed = 14
	GameState.companion_event = {"kind": "protect", "name": member_name}
	ActionResolver.resolve("companions", "warn")
	_check(UnlockManager.run_achievements(UnlockManager.live_record())["protections"] == 2, "A free warning must not count as a paid rescue.")
	LIFE_STORY.finish_parenting("Child", "strong")
	LIFE_STORY.finish_parenting("Child", "strong")
	GameState.save_run()
	GameState.life_events = []
	GameState.offspring_history = []
	_check(GameState.load_run() and UnlockManager.run_achievements(UnlockManager.live_record())["offspring"] == 1 and UnlockManager.run_achievements(UnlockManager.live_record())["protections"] == 2, "Real care evidence must persist in the existing run save without duplicate parenting credit.")
	_check(UnlockManager.run_achievements({"achievements": {"protections": "bad", "offspring": -5, "migrations": []}}) == {"offspring": 0, "protections": 0, "migrations": 0, "territories": 0}, "Malformed compact achievement values must recover safely.")


func _check_history() -> void:
	_reset_unlocks()
	LegacyManager._species_bests = {}
	LegacyManager._run_history = []
	var first := _care_record("velociraptor")
	first["life_events"] = []
	var second := _care_record("velociraptor")
	second["offspring_history"] = []
	LegacyManager.check_and_save(first)
	LegacyManager.check_and_save(second)
	var best := UnlockManager.get_best_progress("velociraptor")
	_check(not best["routes"][1]["complete"], "Care progress must never combine offspring and protections from different lives.")
	var adult := _care_record("velociraptor")
	adult["max_stage_reached"] = 3
	LegacyManager.check_and_save(adult)
	_check(not UnlockManager.get_best_progress("velociraptor")["routes"][1]["complete"], "Elder status in an earlier life must not complete another life's care route.")
	LegacyManager._load()
	_check(not UnlockManager.is_unlocked("velociraptor") and not UnlockManager.get_best_progress("velociraptor")["routes"][1]["complete"], "Single-life progress must survive profile reload without creating a combined unlock.")
	var complete := _care_record("velociraptor")
	LegacyManager.check_and_save(complete)
	_check(UnlockManager.get_best_progress("velociraptor")["routes"][1]["complete"], "A complete care life must become the saved best care route.")
	# Recover older honest histories, never inventing care stats from aggregate bests.
	LegacyManager._species_bests["deinonychus"].erase("route_bests")
	LegacyManager._save_species_bests()
	LegacyManager._load()
	_check(UnlockManager.is_unlocked("velociraptor") and LegacyManager._species_bests["deinonychus"].has("route_bests"), "An eligible old completed life must be recognized and its route progress backfilled.")
	_reset_unlocks()
	UnlockManager.save_unlocks()
	LegacyManager._species_bests = {"deinonychus": {"fights_won": 500, "max_stage_reached": 4}}
	LegacyManager._run_history = []
	LegacyManager._save_species_bests()
	LegacyManager._save_history()
	LegacyManager._load()
	_check(not UnlockManager.is_unlocked("velociraptor") and not UnlockManager.get_best_progress("velociraptor")["routes"][1]["complete"], "Aggregate older bests without evidence must not manufacture a care unlock.")
	var already := "trex"
	UnlockManager.force_unlock(already)
	LegacyManager._load()
	_check(UnlockManager.is_unlocked(already), "Profile migration must preserve already-earned or purchased unlocks.")


func _capture(name: String) -> void:
	if "--capture-memorial" in OS.get_cmdline_user_args():
		await RenderingServer.frame_post_draw
		harness.root.get_texture().get_image().save_png("res://.godot/unlock_%s.png" % name)


func _check_ui() -> void:
	_reset_unlocks()
	LegacyManager._species_bests = {}
	var select = load("res://scenes/ui/character_select.tscn").instantiate()
	harness.root.add_child(select)
	await harness.get_tree().process_frame
	select._show_unlock_tooltip("triceratops")
	await harness.get_tree().process_frame
	await harness.get_tree().process_frame
	var overlay = select._tooltip
	_check(overlay._flavor_label.visible_characters == -1, "Unlock progress must appear immediately without a reveal tap.")
	_check(overlay._flavor_label.text.contains("Completed migrations") and overlay._flavor_label.text.contains("Encounters survived"), "Character selection must show both original and migration paths.")
	_check(overlay._choices_grid.get_child(0).get_global_rect().end.y <= harness.root.size.y - overlay._safe_bottom, "Unlock progress Close must stay above the phone safe area.")
	await _capture("selection_paths")
	overlay._on_choice("close")
	_check(select._tooltip == null, "The unlock path dialog must dismiss normally.")
	select.queue_free()
	await harness.get_tree().process_frame
	GameState.start_run("lesothosaurus")
	GameState.life_stage = 3
	GameState.seasons_elapsed = 16
	GameState.current_season = 0
	GameState.offspring_history = [{"name": "Child", "bond": "strong"}]
	GameState.life_events = [{"key": "companion_protected_Fern_8"}, {"key": "companion_protected_Fern_14"}]
	var game = load("res://scenes/game/game_screen.tscn").instantiate()
	harness.root.add_child(game)
	await harness.get_tree().process_frame
	await harness.get_tree().process_frame
	_check(game.tab_kills.text.contains("Care path ready") and game.tab_kills.mouse_filter == Control.MOUSE_FILTER_STOP, "The live tracker must display ready care achievements and be tappable.")
	game.tab_kills.pressed.emit()
	game.event_overlay._on_choice("ok")
	await harness.get_tree().create_timer(0.25).timeout
	_check(game.event_overlay._flavor_label.text.contains("Strong-bond offspring raised") and game.event_overlay._flavor_label.text.contains("Reach Elder: 0 / 1"), "The live path dialog must show exact care progress and the remaining Elder gate.")
	await _capture("live_paths")
	game.event_overlay._on_choice("ok")
	GameState.life_stage = 4
	game._on_stat_changed()
	_check(UnlockManager.is_unlocked("iguanodon") and game.event_overlay.visible and game.event_overlay._flavor_label.text.contains("Iguanodon"), "Reaching Elder with actual care evidence must award and announce a live unlock.")
	await _capture("live_award")
	game.queue_free()
	await harness.get_tree().process_frame
	_reset_unlocks()
	GameState.start_run("iguanodon")
	GameState.life_stage = 3
	GameState.seasons_elapsed = 17
	GameState.journey_state = {"kind": "migration", "phase": 3, "reward": 0.04}
	var death = load("res://scenes/ui/death_screen.tscn").instantiate()
	harness.root.add_child(death)
	await harness.get_tree().process_frame
	await harness.get_tree().process_frame
	var found := false
	for hint in death.content.find_children("*", "Label", true, false):
		if hint.text.contains("Completed migrations: 1 / 1") and hint.text.contains("Strong-bond offspring raised: 0 / 1"):
			found = true
	_check(found, "The death screen must show exact unmet care requirements alongside original progress.")
	var scroll: ScrollContainer = death.get_node("Scroll")
	scroll.scroll_vertical = int(scroll.get_v_scroll_bar().max_value)
	await harness.get_tree().process_frame
	await _capture("death_progress")
	death.queue_free()
	await harness.get_tree().process_frame
