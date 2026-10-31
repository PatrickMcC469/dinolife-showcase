extends Node

const LEAD = preload("res://scripts/systems/pack_leadership.gd")
const COMPANIONS = preload("res://scripts/systems/companions.gd")
var failures := 0


func _ready() -> void:
	_run.call_deferred()


func _check(ok: bool, message: String) -> void:
	if not ok:
		failures += 1
		push_error(message)


func _setup(sid: String) -> void:
	GameState.start_run(sid)
	GameState.life_stage = 3
	GameState.seasons_elapsed = 20
	GameState.pack_bond = 0.8
	GameState.health = 1.0
	GameState.hunger = 0.8
	COMPANIONS.ensure_cast()


func _capture(file: String) -> void:
	if "--capture-update" in OS.get_cmdline_user_args():
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().create_timer(0.25).timeout
		await RenderingServer.frame_post_draw
		get_tree().root.get_texture().get_image().save_png("res://.godot/" + file + ".png")


func _run() -> void:
	if not OS.get_user_data_dir().replace("\\", "/").contains("/.godot/alpha_userdata/"):
		push_error("Run with isolated APPDATA under .godot/alpha_userdata.")
		get_tree().quit(2)
		return
	seed(771)
	for sid in COMPANIONS.SPECIES:
		_setup(sid)
		var alpha := LEAD.leader()
		var name: String = alpha["name"]
		_check(COMPANIONS.active_cast().has(alpha) and LEAD.is_leader(alpha), "The alpha must be a real active member: " + sid)
		alpha["trust"] = 0.7
		_check(LEAD.menu()["flavor"].contains("trusting"), "Leadership must use the real individual trust.")
		COMPANIONS._change(alpha, -0.3, "You kept the food.")
		_check(LEAD.menu()["flavor"].contains("wary"), "The alpha's feelings must update with their real relationship.")
		GameState.save_run()
		GameState.pack_alpha_name = ""
		_check(GameState.load_run() and LEAD.leader()["name"] == name and is_equal_approx(LEAD.leader()["trust"], 0.4), "Reload must retain the alpha's identity and trust.")
		GameState.life_stage = 1
		var juvenile_health: float = GameState.health
		LEAD.resolve("challenge")
		_check(not GameState.is_alpha and GameState.health == juvenile_health and GameState.get_action_uses("alpha_challenge") == 0, "Juveniles must not bypass leadership eligibility.")
		GameState.life_stage = 3
		GameState.is_alpha = true
		_check(not LEAD.is_leader(alpha) and LEAD.duty_ready(), "Only the player must carry the alpha title after winning.")
		var target: Dictionary = COMPANIONS.active_cast()[0]
		target["trust"] = -0.5
		var before: float = target["trust"]
		ActionResolver.resolve("leadership", "mediate")
		_check(target["trust"] > before and GameState.get_action_uses("alpha_duty") == 1, "An alpha must improve the least trusting ally with a real seasonal action.")
		var hunger: float = GameState.hunger
		var defense: float = GameState.defense
		ActionResolver.resolve("leadership", "patrol")
		_check(GameState.hunger == hunger and GameState.defense == defense, "Different duties must share the same seasonal limit.")
		GameState.save_run()
		GameState.action_uses.clear()
		_check(GameState.load_run() and not LEAD.duty_ready(), "Reload must not bypass a used duty.")
		GameState.advance_season()
		_check(LEAD.duty_ready(), "The leadership action must return next season.")
		GameState.hunger = 0.02
		ActionResolver.resolve("leadership", "patrol")
		_check(LEAD.duty_ready() and GameState.hunger == 0.02, "Insufficient food must not charge or consume the duty.")
		GameState.hunger = 0.8
		ActionResolver.resolve("leadership", "patrol")
		_check(GameState.defense > defense and GameState.temp_buffs.any(func(buff): return buff["source"] == "Alpha watch"), "Organizing a watch must grant real temporary defense.")
		GameState.tick_temp_buffs()
		GameState.advance_season()
		_check(not GameState.temp_buffs.any(func(buff): return buff["source"] == "Alpha watch"), "Alpha watch must expire rather than stack forever.")
		GameState.hunger = 0.4
		for member in COMPANIONS.active_cast():
			member["trust"] = 1.0
		ActionResolver.resolve("leadership", "provision")
		_check(is_equal_approx(GameState.hunger, 0.5), "Even six allies must keep the food bonus capped at two helpers.")
		LEAD.cede()
		_check(not GameState.is_alpha and LEAD.is_leader(LEAD.leader()), "Yielding must transfer the title to a named living companion.")
		var old_name: String = LEAD.leader()["name"]
		COMPANIONS._depart(LEAD.leader(), "They moved on.")
		_check(LEAD.leader()["name"] != old_name, "A departed alpha must be replaced by a living member.")
		PackManager.trigger_disband("The group broke apart.")
		var disband_hunger: float = GameState.hunger
		ActionResolver.resolve("leadership", "provision")
		_check(LEAD.leader().is_empty() and not GameState.is_alpha and GameState.pack_alpha_name.is_empty() and GameState.hunger == disband_hunger, "Disbanding must clear leadership and invalidate stale duties.")
	for sid in ["trex", "allosaurus", "ankylosaurus"]:
		_setup(sid)
		GameState.is_alpha = true
		_check(not LEAD.available() and LEAD.leader().is_empty(), "Solitary species must have no alpha feature.")
	# Exercise the real new challenge path, including costs, losses, and replay.
	var wins := 0
	var losses := 0
	for attempt in range(1, 18):
		_setup("deinonychus")
		var incumbent := LEAD.leader()
		for member in COMPANIONS.active_cast():
			member["trust"] = 1.0
		GameState.daily_luck = 0.0
		seed(attempt)
		ActionResolver.resolve("leadership", "challenge")
		wins += 1 if GameState.is_alpha else 0
		losses += 0 if GameState.is_alpha else 1
		_check(incumbent["help_season"] != GameState.seasons_elapsed and incumbent["trust"] < 1.0, "The incumbent must react to the challenge without helping overthrow themselves.")
		_check(GameState.get_action_uses("alpha_challenge") == 1 and is_equal_approx(GameState.hunger, 0.72), "The new challenge must cost food and count once.")
		var after_health: float = GameState.health
		var after_food: float = GameState.hunger
		ActionResolver.resolve("leadership", "challenge")
		_check(GameState.health == after_health and GameState.hunger == after_food, "Replaying a challenge must not grant another roll or charge more food.")
		GameState.save_run()
		GameState.action_uses.clear()
		_check(GameState.load_run() and not LEAD.challenge_ready(), "Challenge cooldowns must survive save/resume.")
	_check(wins > 0 and losses > 0, "New leadership challenges must exercise both wins and losses.")
	_setup("deinonychus")
	GameState.is_alpha = true
	GameState.pack_bond = 0.0
	LEAD.leader()
	_check(not GameState.is_alpha and GameState.pack_alpha_name.is_empty(), "A bond that reaches zero must not retain phantom leadership.")
	_setup("deinonychus")
	GameState.is_alpha = true
	var screen := preload("res://scenes/game/game_screen.tscn").instantiate()
	add_child(screen)
	await get_tree().process_frame
	_check(screen.get_node("AlphaBadge").visible, "Player leadership must appear on the main portrait.")
	var panel = screen.companions_panel
	_check(panel.summary.text.contains("You are the alpha"), "The roster must state when the player leads.")
	await _capture("alpha_player")
	var tap := InputEventMouseButton.new()
	tap.pressed = true
	tap.button_index = MOUSE_BUTTON_LEFT
	screen._on_alpha_badge_input(tap)
	_check(screen._action_context == "leadership" and screen._waiting_for_choice, "The portrait badge must open real seasonal leadership choices.")
	screen.event_overlay._finish_typewriter()
	await _capture("alpha_duties")
	screen._on_choice_made("back")
	screen.event_overlay.hide()
	GameState.is_alpha = false
	screen._on_stat_changed()
	var marked := 0
	for card in panel.cards.get_children():
		if card.visible and card.get_node("Content/Identity/Alpha").visible:
			marked += 1
	_check(marked == 1 and not screen.get_node("AlphaBadge").visible, "Exactly the current named alpha must have a crown after the player loses leadership.")
	screen._dashboard._show_pack()
	for card in panel.cards.get_children():
		if card.visible and card.get_node("Content/Identity/Alpha").visible:
			panel.get_parent().ensure_control_visible(card)
	await _capture("alpha_member")
	screen.queue_free()
	await get_tree().process_frame
	for dimensions in [Vector2i(390, 844), Vector2i(320, 568), Vector2i(768, 1024)]:
		get_tree().root.content_scale_size = dimensions
		get_tree().root.size = dimensions
		var menu := preload("res://scenes/ui/main_menu.tscn").instantiate()
		add_child(menu)
		await get_tree().process_frame
		await get_tree().process_frame
		for btn in [menu.new_game_btn, menu._story_btn, menu.continue_btn, menu.discoveries_btn, menu._lineage_btn, menu.store_btn, menu.settings_btn]:
			_check(btn.size.x <= dimensions.x - 40 and btn.size.y >= 44, "Menu cards must fit with usable touch targets at %s: %s %s" % [dimensions, btn.name, btn.size])
		await _capture("menu_update_%d" % dimensions.x)
		var menu_scroll := menu.get_node("PageMargin/PageScroll") as ScrollContainer
		_check(menu_scroll.vertical_scroll_mode == ScrollContainer.SCROLL_MODE_DISABLED and menu_scroll.get_global_rect().encloses(menu.settings_btn.get_global_rect()), "Small-phone menus must show the bottom controls without scrolling.")
		menu.queue_free()
		await get_tree().process_frame
		var selection := preload("res://scenes/ui/character_select.tscn").instantiate()
		add_child(selection)
		await get_tree().process_frame
		await get_tree().process_frame
		for tree in ["herbivore", "carnivore"]:
			selection._current_tree = tree
			selection._style_tabs()
			selection._refresh()
			await get_tree().process_frame
			await get_tree().process_frame
			_check(selection._roster.get_child_count() == 5, "Selection must show five actual dinosaurs per diet.")
			_check(selection.dino_image.size.x <= dimensions.x - 40, "Selection artwork must stay inside the phone width.")
			_check(selection._roster.size.x <= dimensions.x - 40, "The five-dinosaur strip must fit the screen width: %s at %s" % [selection._roster.size, dimensions])
			selection._roster.get_child(1).pressed.emit()
			_check(selection._current_index == 1, "Tapping a roster photo must select the matching dinosaur.")
			await get_tree().process_frame
		selection._current_index = 0
		selection._refresh()
		await _capture("selection_update_%d" % dimensions.x)
		var select_scroll := selection.get_node("PageMargin/PageScroll") as ScrollContainer
		select_scroll.ensure_control_visible(selection._tutorial_check)
		await get_tree().process_frame
		_check(select_scroll.get_global_rect().encloses(selection._tutorial_check.get_global_rect()), "Small-phone selection must scroll to the start controls and tutorial toggle.")
		selection.queue_free()
		await get_tree().process_frame
	GameState.delete_save()
	for player in SoundManager.get_children():
		if player is AudioStreamPlayer:
			player.stop()
	await get_tree().process_frame
	await get_tree().create_timer(0.1).timeout
	print("ALPHA UPDATE CHECKS PASSED" if failures == 0 else "ALPHA UPDATE CHECKS FAILED: %d" % failures)
	get_tree().quit(0 if failures == 0 else 1)
