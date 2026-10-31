extends RefCounted

const REWARDS = preload("res://scripts/systems/rewarded_actions.gd")
var harness: Node

class NativeRewardMock extends Node:
	var uid := 100
	func create() -> int:
		uid += 1
		return uid
	func load(_unit: String, _request: Dictionary, _keywords: PackedStringArray, _id: int) -> void: pass
	func show(_id: int) -> void: pass
	func destroy(_id: int) -> void: pass


func _check(ok: bool, message: String) -> void:
	harness._check(ok, message)


func _ready_ad() -> void:
	AdManager.load_rewarded()
	AdManager._on_rewarded_loaded(AdManager._rewarded_uid)


func _watch(game: Control, action: String, earn: bool = true, fail: bool = false) -> String:
	game.event_overlay.hide_overlay()
	game._waiting_for_choice = false
	_ready_ad()
	game._handle_ad_action(action)
	var uid: int = AdManager._rewarded_uid
	_check(game._waiting_for_choice and game.next_season_btn.disabled, "A reward ad must block seasonal choices until its receipt is dismissed.")
	if earn:
		AdManager._on_rewarded_earned_reward(uid, {})
		var state := GameState.action_uses.duplicate(true)
		var food := GameState.hunger
		AdManager._on_rewarded_earned_reward(uid, {})
		_check(GameState.action_uses == state and GameState.hunger == food, "Duplicate earned callbacks must not repeat gameplay rewards.")
		_check(not game.event_overlay.visible, "The receipt must wait until the native ad closes.")
		var file := FileAccess.open(GameState.SAVE_PATH, FileAccess.READ)
		var saved: Dictionary = JSON.parse_string(file.get_as_text())
		file.close()
		_check(is_equal_approx(float(saved["hunger"]), GameState.hunger), "Earned food must be saved before dismissal.")
		for key in GameState.action_uses:
			_check(int(saved["action_uses"].get(key, -1)) == GameState.get_action_uses(key), "Earned seasonal allowances must survive JSON number coercion before dismissal.")
	if fail: AdManager._on_rewarded_failed_to_show(uid, {"message": "simulated failure"})
	else: AdManager._on_rewarded_closed(uid)
	await harness.get_tree().process_frame
	_check(game.event_overlay.visible and game.event_overlay._flavor_label.visible_characters == -1, "Ad receipts must be immediately readable after dismissal, with no typing delay.")
	var text: String = game.event_overlay._flavor_label.text
	AdManager._on_rewarded_closed(uid)
	_check(game.event_overlay._flavor_label.text == text, "Duplicate dismissals must not replace the reward receipt.")
	return text


func _capture(name: String) -> void:
	if "--capture-memorial" in OS.get_cmdline_user_args():
		await harness.get_tree().create_timer(0.3).timeout
		await RenderingServer.frame_post_draw
		harness.root.get_texture().get_image().save_png("res://.godot/ad_reward_%s.png" % name)


func run(check_harness: Node) -> void:
	harness = check_harness
	var old: Dictionary = {}
	for key in ["_rewarded_plugin", "_rewarded_uid", "_is_rewarded_loaded", "_showing_rewarded", "_showing_interstitial", "_reward_callback", "_reward_finished", "_reward_was_earned"]:
		old[key] = AdManager.get(key)
	var enabled := SettingsManager.reward_videos_enabled
	var mock := NativeRewardMock.new()
	harness.root.add_child(mock)
	AdManager._rewarded_plugin = mock
	AdManager._rewarded_uid = -1
	AdManager._showing_rewarded = false
	AdManager._showing_interstitial = false
	SettingsManager.reward_videos_enabled = true
	GameState.start_run("deinonychus")
	GameState.life_stage = 3
	GameState.seasons_elapsed = 20
	GameState.health = 0.95
	GameState.hunger = 0.8
	preload("res://scripts/systems/companions.gd").ensure_cast()
	var game = load("res://scenes/game/game_screen.tscn").instantiate()
	harness.root.add_child(game)
	await harness.get_tree().process_frame
	await harness.get_tree().process_frame
	var text := await _watch(game, "ad_health")
	_check(game.event_overlay._result_feedback.gains.text.contains("Health +5%") and text.contains("95% → 100%") and is_equal_approx(GameState.health, 1.0), "Health receipt must report the capped five-point benefit, not promise eight.")
	await _capture("health_390")
	_check(not REWARDS.available("ad_health"), "Full health must hide its ad reward.")
	text = await _watch(game, "ad_hunger")
	_check(game.event_overlay._result_feedback.gains.text.contains("Food +8%") and text.contains("80% → 88%"), "Food rewards must explain the actual before/after reserves.")
	GameState.pack_bond = 0.96
	text = await _watch(game, "ad_bond")
	_check(game.event_overlay._result_feedback.gains.text.contains("Bond +4%") and text.contains("96% → 100%"), "Group-bond receipt must explain its real capped benefit.")
	GameState.pack_bond = 0.0
	_check(not REWARDS.available("ad_bond"), "A missing group must not offer a bond reward that silently creates one.")
	GameState.species_id = "trex"
	GameState.pack_bond = 0.5
	_check(not REWARDS.available("ad_bond"), "Solitary dinosaurs must not receive pack-bond ads.")
	GameState.species_id = "deinonychus"
	_check(not REWARDS.available("ad_training"), "Extra Training must wait until the normal training has been used.")
	GameState.action_uses["sharpen"] = 1
	var strength := GameState.strength
	text = await _watch(game, "ad_training")
	_check(text.contains("Tap Refine Technique") and text.contains("usual food cost") and GameState.get_action_uses("sharpen") == 0 and GameState.strength == strength, "The training receipt must identify the reopened action without claiming a stat award.")
	_check(not REWARDS.available("ad_training") and GameState.ad_bonus_training_used, "An earned extra session must be limited to once per season.")
	await _capture("training_390")
	GameState.injuries = [
		{"name": "Bruised Leg", "stat": "speed", "amount": -0.1, "permanent": false, "turns_remaining": 5},
		{"name": "Scratched Hide", "stat": "defense", "amount": -0.05, "permanent": false, "turns_remaining": 1},
		{"name": "Old Scar", "stat": "strength", "amount": -0.02, "permanent": true, "turns_remaining": 8}]
	var defense := GameState.defense
	text = await _watch(game, "ad_heal")
	_check(text.contains("Bruised Leg: 5 → 3 seasons") and text.contains("Scratched Hide: healed") and text.contains("Permanent injuries remain"), "Healing must name each injury's exact reduction, fully healed wounds and permanent scars.")
	_check(GameState.injuries.size() == 2 and is_equal_approx(GameState.defense, minf(defense + 0.05, 1.0)), "Healing receipts must describe the real removed injury and restored stat.")
	await _capture("healing_390")
	var scale: Vector2i = harness.root.content_scale_size
	harness.root.content_scale_size = Vector2i(320, 568)
	harness.root.size = Vector2i(320, 568)
	await harness.get_tree().process_frame
	game.event_overlay.show_event(REWARDS.notice("Reward received", text))
	await harness.get_tree().process_frame
	await _capture("healing_320")
	_check(game.event_overlay._choices_grid.get_parent().get_global_rect().end.y <= 568, "Reward acknowledgement must remain reachable on small phones.")
	_check(game.event_overlay._reading_frame.get_global_rect().encloses(game.event_overlay._flavor_scroll.get_global_rect()), "The reward reading viewport must stay inside its artwork border on short phones.")
	harness.root.content_scale_size = scale
	harness.root.size = Vector2i(390, 844)
	var food := GameState.hunger
	var uses := GameState.get_action_uses("ad_hunger")
	text = await _watch(game, "ad_hunger", false)
	_check(text.contains("ended before") and GameState.hunger == food and GameState.get_action_uses("ad_hunger") == uses, "Incomplete ads must explain that nothing changed and consume no reward allowance.")
	text = await _watch(game, "ad_hunger", false, true)
	_check(text.contains("could not play") and GameState.hunger == food, "Failed presentations must visibly explain that no reward was granted.")
	game.event_overlay.hide_overlay()
	game._waiting_for_choice = false
	AdManager._is_rewarded_loaded = false
	game._handle_ad_action("ad_hunger")
	_check(game.event_overlay._flavor_label.text.contains("No reward ad is ready") and not game._waiting_for_choice, "Unavailable ads must show a retry message without blocking the game.")
	GameState.hunger = 0.5
	GameState.action_uses["ad_hunger"] = 0
	for index in 3: await _watch(game, "ad_hunger")
	_check(not REWARDS.available("ad_hunger"), "The existing three boosts per stat per season limit must remain enforced.")
	GameState.load_run()
	_check(GameState.get_action_uses("ad_hunger") == 3 and not REWARDS.available("ad_hunger"), "Reloading a rewarded save must preserve its seasonal cap.")
	GameState.reset_action_uses()
	_check(REWARDS.available("ad_hunger"), "A new season must reset the saved boost allowance.")
	game.queue_free()
	await harness.get_tree().process_frame
	await _story_reward()
	for key in old: AdManager.set(key, old[key])
	SettingsManager.reward_videos_enabled = enabled
	mock.queue_free()
	GameState.delete_save()
	print("Reward receipts checked: earned-only grants, capped stats, training availability, named healing, saved limits, cancellation/failure, duplicate callbacks and Story rewind feedback.")


func _story_reward() -> void:
	StoryState.reset()
	StoryState.current_scene_id = "s1_morning"
	var story = load("res://scripts/story/story_screen.gd").new()
	harness.root.add_child(story)
	await harness.get_tree().process_frame
	await harness.get_tree().process_frame
	story._history.append({"scene_id": "s1_morning", "state": story._snapshot_state()})
	StoryState.flint_trust = 2
	var trust: int = story._history[-1]["state"]["flint_trust"]
	_ready_ad()
	story._show_ad(func(): story._do_rewind())
	var uid: int = AdManager._rewarded_uid
	AdManager._on_rewarded_earned_reward(uid, {})
	AdManager._on_rewarded_closed(uid)
	await harness.get_tree().process_frame
	var notice: AcceptDialog
	for child in story.get_children():
		if child is AcceptDialog: notice = child
	_check(is_instance_valid(notice) and notice.dialog_text.contains("previous story choice") and StoryState.flint_trust == trust, "The real Story rewind must explain the returned choice after the earned ad closes.")
	story.queue_free()
	await harness.get_tree().process_frame
