extends RefCounted

const FEEDBACK = preload("res://scripts/systems/action_feedback.gd")
const COMPANIONS = preload("res://scripts/systems/companions.gd")
const WORLD = preload("res://scripts/systems/world_conditions.gd")
var harness: Node


func _check(ok: bool, message: String) -> void:
	harness._check(ok, message)


func _start(species: String = "iguanodon") -> void:
	GameState.start_run(species)
	GameState.life_stage = 3
	GameState.seasons_elapsed = 17
	GameState.current_season = 1
	GameState.health = 0.8
	GameState.hunger = 0.8
	GameState.daily_luck = 0.0
	COMPANIONS.ensure_cast()
	# These action-feedback fixtures begin after their survival milestone award.
	preload("res://scripts/systems/perks.gd").award()


func run(check_harness: Node) -> void:
	harness = check_harness
	var old_volume := SettingsManager.master_volume
	var old_atmosphere := SettingsManager.atmosphere_enabled
	var old_videos := SettingsManager.reward_videos_enabled
	var old_unlocks := UnlockManager.unlocked.duplicate(true)
	var reward := _check_results()
	await _check_result_ui(reward)
	await _check_weather()
	await _check_settings()
	SettingsManager.set_master_volume(old_volume)
	SettingsManager.set_atmosphere_enabled(old_atmosphere)
	SettingsManager.set_reward_videos_enabled(old_videos)
	UnlockManager.unlocked = old_unlocks
	UnlockManager.save_unlocks()
	GameState.delete_save()
	print("Atmosphere checked: truthful capped/mixed results and milestones, no duplicate cues, real weather profiles and isolated randomness, mute/toggle/save/pause, audio loops and scene cleanup, stat feedback, and readable phone layouts.")


func _check_results() -> Dictionary:
	_start()
	GameState.hunger = 0.96
	GameState.action_uses = {"graze": 1}
	var crit_seed := -1
	for candidate in 500:
		seed(candidate)
		if randf() > 0.99:
			crit_seed = candidate
			break
	_check(crit_seed >= 0, "A deterministic critical grazing fixture must exist.")
	seed(crit_seed)
	var graze := ActionResolver.resolve("graze", "")
	_check(graze.get("feedback", {}).get("gains", []).has("Food +4%") and is_equal_approx(GameState.hunger, 1.0), "Actual grazing feedback must show the capped 4% gain, rather than its nominal 40% reward.")
	_start()
	var name: String = COMPANIONS.current_cast()[0]["name"]
	GameState.companion_event = {"kind": "protect", "name": name}
	var protect := ActionResolver.resolve("companions", "cover")
	_check(protect["feedback"]["gains"].has(name + " trusts you more") and protect["feedback"]["costs"].has("Food −5%") and protect["feedback"]["tone"] == "mixed", "Protecting a companion must show both its food cost and real trust improvement.")
	var food := GameState.hunger
	var replay := ActionResolver.resolve("companions", "cover")
	_check(not replay.has("feedback") and GameState.hunger == food, "A duplicate resolved encounter must not produce fake gains, costs or a fresh feedback cue.")
	_start()
	GameState.journey_state = {"kind": "migration", "phase": 1, "route": "river", "pending": true, "due": 17}
	var crossing := ActionResolver.resolve("journey", "push")
	_check(crossing["feedback"]["costs"].has("Health −8%") and crossing["feedback"]["tone"] == "setback", "An actual dangerous crossing must show its health cost and setback cue.")
	GameState.journey_state["phase"] = 2
	GameState.journey_state["pending"] = true
	GameState.hunger = 0.96
	var arrival := ActionResolver.resolve("journey", "settle")
	_check(arrival["feedback"]["milestones"].has("Migration complete") and arrival["feedback"]["gains"].has("Food +4%"), "Migration completion must show its earned milestone and actual capped arrival reward.")
	var before := FEEDBACK.snapshot()
	var unchanged := {"flavor": "Nothing changes."}
	FEEDBACK.attach(unchanged, before)
	_check(not unchanged.has("feedback"), "Information and unchanged state must not claim a reward.")
	GameState.injuries = [{"name": "Bruise", "stat": "speed", "amount": -0.01, "turns_remaining": 3, "permanent": false}]
	before = FEEDBACK.snapshot()
	GameState.shorten_injuries(2)
	var treated: Dictionary = {}
	FEEDBACK.attach(treated, before)
	_check(treated["feedback"]["gains"].has("Injuries easing"), "Shortening actual injuries must be visible even without a health change.")
	return arrival


func _capture(name: String) -> void:
	if "--capture-memorial" in OS.get_cmdline_user_args():
		await RenderingServer.frame_post_draw
		harness.root.get_texture().get_image().save_png("res://.godot/atmosphere_%s.png" % name)


func _check_result_ui(reward: Dictionary) -> void:
	var overlay = load("res://scenes/ui/event_overlay.tscn").instantiate()
	harness.root.add_child(overlay)
	await harness.get_tree().process_frame
	overlay.show_event(reward)
	await harness.get_tree().process_frame
	await harness.get_tree().process_frame
	var panel = overlay._result_feedback
	_check(panel.visible and panel.milestone.text.contains("Migration complete") and panel.gains.text.contains("Food +4%"), "The real result popup must render its earned milestone and net reward.")
	_check(panel.cue.stream == panel.CUES["reward"] and panel.cue.bus == "Master", "Feedback cues must use the proper sound and respect master volume.")
	panel.cue.stop()
	overlay.show_event(reward)
	_check(not panel.cue.playing, "Redisplaying the same result must not replay its sound.")
	overlay._on_choice("ok")
	await harness.get_tree().create_timer(0.25).timeout
	_check(overlay.visible and overlay._flavor_label.visible_characters == -1, "First tap must still reveal the narrative, leaving the result available to read.")
	await _capture("reward")
	overlay._on_choice("ok")
	_check(not overlay.visible, "Second tap must retain the normal result dismissal.")
	var long_result := {"title": "A costly choice", "flavor": "You keep the herd together. ".repeat(30), "feedback": {
		"serial": 900000, "milestones": [], "gains": ["Food +4%", "Fern trusts you more"], "costs": ["Health −8%"], "tone": "mixed"},
		"choices": [{"label": "Continue together", "action": "together"}, {"label": "Make room", "action": "room"}, {"label": "Turn back", "action": "back"}]}
	overlay.show_event(long_result)
	overlay._on_choice("together")
	await harness.get_tree().create_timer(0.25).timeout
	_check(panel.gains.visible and panel.costs.visible and overlay._flavor_scroll.get_v_scroll_bar().max_value > overlay._flavor_scroll.get_v_scroll_bar().page, "Mixed results and long narrative must share a scrollable reading area.")
	for button in overlay._choices_grid.get_children():
		_check(button.get_global_rect().end.y <= harness.root.size.y - overlay._safe_bottom, "Feedback must not push choices below the phone's bottom safe area.")
	await _capture("mixed")
	overlay.show_event({"type": "info", "flavor": "A quiet moment.", "choices": []})
	_check(not panel.visible, "Opening information after a result must clear all stale result labels.")
	overlay.queue_free()
	await harness.get_tree().process_frame
	var bar = load("res://scenes/ui/stat_bar.tscn").instantiate()
	harness.root.add_child(bar)
	bar.set_value_normalized(0.8)
	_check(bar.modulate == Color.WHITE, "Initializing a stat bar must not flash a fake change.")
	bar.set_value_normalized(0.6)
	_check(is_equal_approx(bar.value, 0.6) and bar.modulate != Color.WHITE, "A real stat change must remain numerically immediate with a gentle visual cue.")
	bar.set_value_normalized(0.9)
	await harness.get_tree().create_timer(0.45).timeout
	_check(bar.modulate.is_equal_approx(Color.WHITE), "Rapid stat changes must return to the normal color without an old tween leaving a tint.")
	bar.queue_free()
	await harness.get_tree().process_frame


func _check_weather() -> void:
	_start("trex")
	SettingsManager.set_atmosphere_enabled(true)
	var game = load("res://scenes/game/game_screen.tscn").instantiate()
	harness.root.add_child(game)
	await harness.get_tree().process_frame
	await harness.get_tree().process_frame
	var atmosphere = game.get_node("DinoPanel/DinoImage/SeasonAtmosphere")
	_check(atmosphere.mouse_filter == Control.MOUSE_FILTER_IGNORE and atmosphere.clip_contents and atmosphere.size == game.dino_image.size, "Weather must be clipped to the art and must not intercept game controls.")
	_check(atmosphere.rain.stream.loop_mode == AudioStreamWAV.LOOP_FORWARD and is_equal_approx(atmosphere.rain.stream.get_length(), 8.0), "Rain must use an actual seamless eight-second looping stream.")
	_check(atmosphere.wind.stream.loop_mode == AudioStreamWAV.LOOP_FORWARD and is_equal_approx(atmosphere.wind.stream.get_length(), 8.0), "Wind must use an actual eight-second looping stream.")
	var record_before := UnlockManager.compact_record(UnlockManager.live_record())
	for season in 4:
		GameState.current_season = season
		seed(273)
		var expected_roll := randf()
		seed(273)
		game._on_turn_started()
		atmosphere.refresh()
		_check(is_equal_approx(randf(), expected_roll), "Atmosphere refreshes must never consume gameplay randomness.")
		_check(atmosphere.profile == ["wet", "dry", "mating", "cold"][season], "Every season must select its own atmosphere.")
		await harness.get_tree().create_timer(0.12).timeout
		await _capture(atmosphere.profile)
	for condition in ["flood", "drought"]:
		WORLD.begin(condition)
		atmosphere.refresh()
		_check(atmosphere.profile == condition, "Lasting flood and drought must override the normal seasonal presentation.")
		await harness.get_tree().create_timer(0.12).timeout
		await _capture(condition)
	GameState.world_state = {}
	GameState.current_season = 0
	atmosphere.refresh()
	GameState.current_season = 3
	atmosphere.refresh()
	await harness.get_tree().create_timer(0.9).timeout
	_check(atmosphere.profile == "cold" and is_equal_approx(atmosphere.wind.volume_db, -25.0) and is_equal_approx(atmosphere.rain.volume_db, -80.0), "Fast season changes must cancel the old mix and finish at the latest season's sound levels.")
	_check(UnlockManager.compact_record(UnlockManager.live_record()) == record_before, "Atmosphere must not change stats, achievements or progression.")
	SettingsManager.set_master_volume(0.0)
	_check(AudioServer.get_bus_volume_db(0) <= -79.0 and atmosphere.wind.bus == "Master", "Muted master volume must silence weather along with the game's existing audio.")
	SettingsManager.set_atmosphere_enabled(false)
	_check(not atmosphere.visible and not atmosphere.rain.playing and not atmosphere.wind.playing and not atmosphere.is_processing(), "Disabling atmosphere must remove motion and stop both sound layers immediately.")
	SettingsManager.set_atmosphere_enabled(true)
	_check(atmosphere.visible and atmosphere.rain.playing and atmosphere.wind.playing, "Re-enabling atmosphere must restore the current world without a reroll.")
	atmosphere._notification(MainLoop.NOTIFICATION_APPLICATION_PAUSED)
	_check(not atmosphere.visible and not atmosphere.wind.playing, "Weather must stop while the app is paused.")
	atmosphere._notification(MainLoop.NOTIFICATION_APPLICATION_RESUMED)
	_check(atmosphere.visible and atmosphere.wind.playing, "App resume must restore the current season's sound.")
	SoundManager.play_music()
	await harness.get_tree().create_timer(0.1).timeout
	var position := SoundManager._music.get_playback_position()
	SoundManager.play_music()
	_check(SoundManager._music.get_playback_position() >= position - 0.01, "Reopening a survival screen must not restart already-playing background music.")
	var player_ref: WeakRef = weakref(atmosphere.wind)
	game.queue_free()
	await harness.get_tree().process_frame
	_check(player_ref.get_ref() == null, "Leaving survival must free its weather players rather than leave audio running.")


func _check_settings() -> void:
	SettingsManager.set_atmosphere_enabled(false)
	SettingsManager.atmosphere_enabled = true
	SettingsManager.load_settings()
	_check(not SettingsManager.atmosphere_enabled, "The atmosphere preference must persist across settings reload.")
	var settings = load("res://scenes/ui/settings_panel.tscn").instantiate()
	harness.root.add_child(settings)
	settings.open(true)
	await harness.get_tree().process_frame
	await harness.get_tree().process_frame
	_check(not settings.atmosphere_toggle.button_pressed and settings.size == Vector2(harness.root.size), "The full-screen settings panel must display the saved atmosphere preference.")
	settings.atmosphere_toggle.button_pressed = true
	_check(SettingsManager.atmosphere_enabled, "The actual settings toggle must change the live preference.")
	_check(settings.back_btn.get_global_rect().end.y < harness.root.size.y - 40 and settings.atmosphere_toggle.size.y >= 44, "Settings Back and the new toggle must remain usable above the phone safe area.")
	await _capture("settings")
	settings.queue_free()
	await harness.get_tree().process_frame
	var file := FileAccess.open(SettingsManager.SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify({"master_volume": 0.7, "reward_videos_enabled": false}))
	file.close()
	SettingsManager.load_settings()
	_check(SettingsManager.atmosphere_enabled, "Older settings without an atmosphere key must use the enabled default.")
	_check(SettingsManager.interface_animations_enabled, "Older settings without an animation key must retain enabled interface animations.")
