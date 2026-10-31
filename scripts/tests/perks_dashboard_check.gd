extends Node

const P = preload("res://scripts/systems/perks.gd")
const C = preload("res://scripts/systems/companions.gd")
const WEATHER = preload("res://scripts/ui/weather_info.gd")
var failures := 0


func _ready() -> void:
	_run.call_deferred()


func _check(condition: bool, message: String) -> void:
	if condition: return
	failures += 1
	push_error(message)


func _start(sid: String = "iguanodon") -> void:
	GameState.start_run(sid)
	GameState.life_stage = 3
	GameState.seasons_elapsed = 8
	GameState.health = 0.8
	GameState.hunger = 0.8
	GameState.world_state = {"kind": "", "until": -1, "cooldown": 9999}
	C.ensure_cast()


func _run() -> void:
	if not OS.get_user_data_dir().replace("\\", "/").contains("/.godot/perks_userdata/"):
		push_error("Run perks checks with isolated perks_userdata.")
		get_tree().quit(2)
		return
	_start()
	_check(P.award().is_empty(), "Perks must need real milestone evidence.")
	GameState.fights_won = 4
	_check(P.award().is_empty(), "Four wins must not earn a five-win perk.")
	GameState.fights_won = 5
	var strength := GameState.strength
	_check(P.award() == ["Battle Hardened"] and is_equal_approx(GameState.strength, strength + 0.03), "The fifth win must grant a real strength bonus.")
	strength = GameState.strength
	_check(P.award().is_empty() and is_equal_approx(GameState.strength, strength), "A perk must never stack on repeated checks.")
	GameState.journey_state = {"phase": 3, "kind": "personal", "reward": 0.0}
	_check("Trailwise" not in P.award(), "Declined journeys must not count as completed journeys.")
	GameState.journey_state["reward"] = 0.04
	_check(P.award() == ["Trailwise"] and is_equal_approx(P.modifier("graze"), 0.02) and P.modifier("territory") == 0.0, "Trailwise must affect feeding, not unrelated actions.")
	GameState.journey_state["reward_until"] = -1
	_check(is_equal_approx(preload("res://scripts/systems/world_conditions.gd").modifier("graze"), 0.02), "Trailwise must reach real feeding rolls after the temporary journey reward expires.")
	GameState.living_state = {"site": "grove", "shelter": 2}
	GameState.defense = 0.99
	_check(P.award() == ["Sheltercraft"] and GameState.defense == 1.0, "Perk grants must respect the actual stat ceiling.")
	GameState.offspring_history = [{"name": "Reed", "bond": "lost"}]
	_check(P.award().is_empty(), "Lost young must not earn a strong-bond parenting perk.")
	GameState.offspring_history[0]["bond"] = "strong"
	_check(P.award() == ["Devoted Parent"], "Strong-bond departures must earn the parenting perk.")
	GameState.seasons_elapsed = 12
	GameState.life_stage = 1
	_check(P.award().is_empty(), "Long Stride must wait for Sub-adult even in a long juvenile stage.")
	_check(P.progress("long_stride") == 12, "Perk progress must show the real season count even while the life-stage gate is unmet.")
	GameState.life_stage = 2
	_check(P.award() == ["Long Stride"], "Twelve seasons plus Sub-adult must earn Long Stride.")
	for member in C.active_cast(): member["trust"] = 0.8
	_check(P.award() == ["Trusted Circle"], "Two genuinely trusting active companions must qualify.")
	var stats := [GameState.strength, GameState.speed, GameState.defense]
	GameState.save_run()
	GameState.earned_perks = []
	_check(GameState.load_run() and GameState.earned_perks.size() == 6 and P.award().is_empty(), "Save/resume must preserve every earned perk without reapplying it.")
	_check(is_equal_approx(stats[0], GameState.strength) and is_equal_approx(stats[1], GameState.speed) and is_equal_approx(stats[2], GameState.defense), "Restoring earned perks must not alter saved stat values.")
	_check(P.restore([{}, 19, "unknown", "trailwise", "trailwise"]).size() == 6, "Invalid perk fields must be rejected while saved bonus names preserve legitimate awards.")
	for sid in ["trex", "allosaurus", "ankylosaurus"]:
		_start(sid)
		_check(not P.eligible("trusted_circle") and P.progress("trusted_circle") == 0 and GameState.earned_perks.is_empty(), "Solitary species and new lives must not inherit pack perks or earlier awards.")
	_start("trex")
	GameState.maternal_outcome_pending = true
	GameState.offspring_bond = 1.0
	_check(TurnManager._check_maternal_bond_outcome() and GameState.bonus_stat_grants.get("Great Mother", []).size() == 1, "A real parenting outcome must record its randomly selected bonus stat.")
	var actual_grant: Dictionary = GameState.bonus_stat_grants["Great Mother"][0]
	_check(P.legacy_effect("Great Mother").contains("Recorded grant: +4.0% " + actual_grant["stat"]), "New parenting bonuses must explain the exact stat they improved.")
	GameState.save_run()
	_check(GameState.load_run() and GameState.bonus_stat_grants["Great Mother"][0]["stat"] == actual_grant["stat"], "Exact bonus effects must survive a save/resume.")
	_check(P.restore_grants({"Great Mother": [{"stat": "unknown", "amount": 0.04}, {"stat": "speed", "amount": "bad"}]}).get("Great Mother", []).is_empty(), "Malformed bonus effect records must use safe defaults.")
	_check_weather()
	await _ui_checks()
	_start("compsognathus")
	var defense := GameState.defense
	ActionResolver._apply_world_outcome({"buff": {"stat": "defense", "amount": 0.06, "perm": true, "perm_label": "Scarred Survivor"}}, "buff")
	_check(is_equal_approx(GameState.defense, defense + 0.06) and is_equal_approx(GameState.permanent_defense_mod, 0.06), "Existing permanent event perks must update both the current stat and lasting modifier without calling an unsupported Object method.")
	var technique := GameState.type_stat
	ActionResolver._apply_world_outcome({"buff": {"stat": "type_stat", "amount": 0.14, "perm": true, "perm_label": "Titan Nerve"}}, "buff")
	_check(is_equal_approx(GameState.type_stat, minf(1, technique + 0.14)), "Technique perks must still grant their effect when no separate permanent technique modifier exists.")
	GameState.delete_save()
	for player in SoundManager.get_children():
		if player is AudioStreamPlayer: player.stop()
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().create_timer(0.5).timeout
	print("PERKS DASHBOARD CHECKS PASSED" if failures == 0 else "PERKS DASHBOARD CHECKS FAILED: %d" % failures)
	get_tree().quit(0 if failures == 0 else 1)


func _check_weather() -> void:
	_start()
	for season in 4:
		GameState.current_season = season
		_check(WEATHER.caption() == GameState.get_season_name() and WEATHER.icon() != null and WEATHER.detail().contains(GameState.get_season_name()), "Weather must show the actual season and a matching symbol.")
	preload("res://scripts/systems/world_conditions.gd").begin("drought")
	_check(WEATHER.caption() == "Drought" and WEATHER.detail().contains("3 seasons remaining") and WEATHER.detail().contains("-5 percentage points") and WEATHER.detail().contains("3% extra"), "Active drought details must show the real duration, grazing penalty and food cost.")
	GameState.world_state["until"] = GameState.seasons_elapsed
	_check(WEATHER.caption() == "Cold" and not WEATHER.detail().contains("Drought food cost"), "Expired weather conditions must disappear immediately.")
	GameState.living_state = {"site": "grove", "shelter": 1}
	_check(WEATHER.detail().contains("Cold food cost: 1%"), "Cold details must use the actual shelter-adjusted food cost.")
	GameState.living_state["shelter"] = 2
	_check(WEATHER.detail().contains("Cold food cost: 0%"), "Complete shelter must explain that the extra cold food cost is removed.")
	preload("res://scripts/systems/world_conditions.gd").begin("flood")
	GameState.is_alpha = true
	for shelter in 3:
		GameState.living_state = {"site": "river", "shelter": shelter, "last_tick": -1}
		var before := GameState.health
		preload("res://scripts/systems/living_world.gd").tick()
		_check(WEATHER.caption() == "Flood" and WEATHER.detail().contains("%.1f%% health" % ((before - GameState.health) * 100)), "Flood information must match the actual river damage at every shelter level.")
	GameState.life_stage = 0
	_check(WEATHER.detail().contains("do not apply yet") and not WEATHER.detail().contains("Cold food cost:"), "Hatchling weather details must not invent adult resource costs.")


func _ui_checks() -> void:
	var original_size := get_tree().root.size
	var original_scale := get_tree().root.content_scale_size
	for viewport_size in [Vector2i(390, 844), Vector2i(320, 568), Vector2i(768, 1024)]:
		get_tree().root.size = viewport_size
		get_tree().root.content_scale_size = viewport_size
		_start()
		GameState.seasons_elapsed = 13
		GameState.has_young = true
		GameState.offspring_name = "Reed"
		GameState.bonuses_earned = ["Great Bond", "Good Parent", "Good Parent", "Well Fed Adult", "Great Mother"]
		GameState.apply_temp_buff("strength", 0.12, 4, "solo_raise_strength")
		for i in 6:
			GameState.injuries.append({"name": "Healing wound %d" % i, "stat": "health", "amount": -0.03, "turns_remaining": 3, "permanent": false})
		var game := preload("res://scenes/game/game_screen.tscn").instantiate()
		add_child(game)
		await get_tree().process_frame
		await get_tree().process_frame
		game.event_overlay.hide_overlay()
		game._waiting_for_choice = false
		game.next_season_btn.disabled = false
		game._dashboard.refresh()
		var scroll: ScrollContainer = game.get_node("ActionScroll")
		_check(game.next_season_btn.get_global_rect().end.y <= viewport_size.y and game.next_season_btn.size.x >= 44 and game.settings_btn.size.x >= 44, "Primary navigation must fit and remain tappable on every display.")
		_check(scroll.size.y >= 90 and scroll.get_global_rect().end.y < game.injury_section.position.y and game.injury_section.get_global_rect().end.y <= game.next_season_btn.position.y, "Actions, wounds and seasonal navigation must have separate reachable space.")
		await _check_card_text(game, viewport_size)
		_check(game.cards_container.get_children().all(func(card): return card.action_id not in ["home", "family", "leadership"]) and not game.has_node("ActionScroll/ActionList/World"), "The central scrolling area must contain seasonal choices, with information shortcuts outside it.")
		var before_reading := [GameState.health, GameState.hunger, GameState.seasons_elapsed, GameState.action_uses.duplicate(true)]
		_tap(game._dashboard.map_button)
		await get_tree().process_frame
		_check(game._dashboard.map_view.visible, "An actual tap on the fixed habitat icon must open home and environment details.")
		_tap(game._dashboard.map_view.back)
		_tap(game._dashboard.family_button)
		await get_tree().process_frame
		_check(game._dashboard.family_view.visible, "An actual tap on the fixed family icon must open the family record.")
		_tap(game._dashboard.family_view.back)
		_check(before_reading == [GameState.health, GameState.hunger, GameState.seasons_elapsed, GameState.action_uses], "Opening detail icons must not spend reserves, seasonal actions or time.")
		var reserves := [GameState.health, GameState.hunger, GameState.earned_perks.duplicate()]
		var weather_button: Button = game._dashboard.weather_button
		var portrait_rect: Rect2 = game._dashboard.portrait_frame.get_global_rect()
		_check(weather_button.size.x >= 44 and weather_button.size.y >= 44 and weather_button.text.is_empty() and not portrait_rect.intersects(weather_button.get_global_rect()), "Weather must stay immediately reachable without covering any portrait.")
		_check(game._dashboard.nameplate.get_global_rect().encloses(game._dashboard.title.get_global_rect()) and game._dashboard.caption.text == "Adult · Season 14", "The named dinosaur and life-stage details must sit inside the illustrated nameplate.")
		var title_font: Font = game._dashboard.title.get_theme_font("font")
		for sid in ["compsognathus", "deinonychus", "velociraptor", "allosaurus", "trex", "lesothosaurus", "iguanodon", "triceratops", "ankylosaurus", "argentinosaurus"]:
			var species_name: String = SpeciesDB.get_species(sid)["display_name"]
			_check(title_font.get_string_size(species_name, HORIZONTAL_ALIGNMENT_LEFT, -1, 22).x <= game._dashboard.title.size.x, "Every first-edition dinosaur name must fit its nameplate on the smallest supported layout.")
		for key in game._stat_bars:
			var meter: ProgressBar = game._stat_bars[key]
			if not meter.get_parent().visible: continue
			var holder: Control = meter.get_parent()
			_check(meter.position.x >= 18 and meter.position.y >= 32 and meter.get_rect().end.x <= holder.size.x - 17 and meter.get_rect().end.y <= holder.size.y - 15, "Every stat meter must fit inside the illustrated border, including its native minimum height.")
		var weather_tap := InputEventMouseButton.new()
		weather_tap.button_index = MOUSE_BUTTON_LEFT
		weather_tap.position = weather_button.get_global_rect().get_center()
		weather_tap.pressed = true
		Input.parse_input_event(weather_tap)
		Input.flush_buffered_events()
		await get_tree().process_frame
		weather_tap = weather_tap.duplicate()
		weather_tap.pressed = false
		Input.parse_input_event(weather_tap)
		Input.flush_buffered_events()
		await get_tree().process_frame
		_check(game.event_overlay.visible and game.event_overlay._flavor_label.text.contains("CURRENT SEASON"), "Tapping the weather symbol must open its actual effects.")
		game.event_overlay._finish_typewriter()
		if viewport_size.x == 390 and DisplayServer.get_name() != "headless":
			await get_tree().create_timer(0.25).timeout
			await RenderingServer.frame_post_draw
			get_viewport().get_texture().get_image().save_png("res://.godot/weather_info_390.png")
		game.event_overlay._on_choice("ok")
		_check(reserves == [GameState.health, GameState.hunger, GameState.earned_perks] and GameState.seasons_elapsed == 13, "Reading and closing weather must not spend resources or advance the season.")

		var pack_button: Button = game._dashboard.pack_button
		_check(pack_button.visible and pack_button.get_node("ShortcutLabel").text == "Herd" and pack_button.size.y >= 44 and not portrait_rect.intersects(pack_button.get_global_rect()), "The herd icon must be reachable without scrolling or covering the dinosaur.")
		for icon_button in game._dashboard.shortcut_row.get_children() + [game.settings_btn]:
			_check(icon_button.get_theme_stylebox("normal") is StyleBoxEmpty and icon_button.get_theme_stylebox("focus") is StyleBoxEmpty, "Information and settings icons must use unframed artwork, including focus.")
		_check(not game.get_node("ActionScroll/ActionList").is_ancestor_of(game.companions_panel), "The roster must leave the gameplay action scroll.")
		_tap(pack_button)
		await get_tree().process_frame
		await get_tree().process_frame
		_check(game._dashboard.pack_view.visible and game.companions_panel.expanded, "Tapping the herd button must open full live member details.")
		var roster: PanelContainer = game.companions_panel
		var focal_member: Dictionary = C.active_cast()[0]
		var old_trust: float = focal_member["trust"]
		focal_member["trust"] = -0.8
		TurnManager.stat_changed.emit()
		_check(roster.cards.get_child(0).get_node("Content/Identity/Badge/State").text == "DISTANT", "The open roster must refresh when a member's relationship changes.")
		focal_member["trust"] = old_trust
		TurnManager.stat_changed.emit()
		game._on_next_season()
		game._on_action_pressed("graze")
		game._dashboard._show_weather()
		game._show_bonuses_popup()
		_check(GameState.seasons_elapsed == 13 and reserves == [GameState.health, GameState.hunger, GameState.earned_perks] and not game.event_overlay.visible and not is_instance_valid(game._bonuses_overlay), "Reading members must neither trigger gameplay nor open competing overlays.")
		if DisplayServer.get_name() != "headless":
			await RenderingServer.frame_post_draw
			get_viewport().get_texture().get_image().save_png("res://.godot/pack_view_%d.png" % viewport_size.x)
		var pack_close: Button = roster.get_parent().get_parent().get_node("Close")
		_check(pack_close.size.y >= 44 and pack_close.get_global_rect().end.y <= viewport_size.y, "Back must stay reachable outside the member scroll on every display.")
		_tap(game._dashboard.pack_view.get_node("Card/Content/Leadership"))
		_check(not game._dashboard.pack_view.visible and game._waiting_for_choice and game._action_context == "leadership", "The actual pack-view alpha button must open the guarded leadership choice flow.")
		game.event_overlay._finish_typewriter()
		game._on_choice_made("back")
		game.event_overlay.hide_overlay()
		game._waiting_for_choice = false
		_tap(pack_button)
		_tap(pack_close)
		_check(not game._dashboard.pack_view.visible, "Back must return to gameplay through an actual tap.")
		game._waiting_for_choice = true
		game._dashboard._show_pack()
		_check(not game._dashboard.pack_view.visible, "The roster must not interrupt an unanswered choice.")
		game._waiting_for_choice = false
		for sid in ["trex", "allosaurus", "ankylosaurus"]:
			GameState.species_id = sid
			game._dashboard.refresh()
			_check(not pack_button.visible, "Solitary dinosaurs must have no pack button.")
		GameState.species_id = "iguanodon"
		game._dashboard.refresh()
		if DisplayServer.get_name() != "headless":
			await RenderingServer.frame_post_draw
			get_viewport().get_texture().get_image().save_png("res://.godot/dashboard_%d.png" % viewport_size.x)
		_check(game.tab_bonuses.accessibility_name == "Stats and perks" and game.tab_bonuses.get_node("ShortcutLabel").text == "Stats", "Current stats must have a clearly named gameplay shortcut.")
		_tap(game.tab_bonuses)
		await get_tree().process_frame
		await get_tree().process_frame
		_check(is_instance_valid(game._bonuses_overlay) and reserves == [GameState.health, GameState.hunger, GameState.earned_perks], "Opening perks must show information without granting perks or changing the run.")
		var list: VBoxContainer = game._bonuses_overlay.get_node("Card").get_child(0).get_node("Scroll/Cards")
		_check(list.get_child(0).text == "CURRENT ABILITIES" and list.get_child(1).get_child(0).get_child(1).text == "Strength · %.1f%%" % (GameState.strength * 100), "The stats page must start with the actual current values rather than burying them below perks.")
		var detail_text := ""
		for card in list.get_children():
			if card is Label: detail_text += card.text
			elif card is PanelContainer:
				_check(card.size.x <= viewport_size.x - 40, "Bonus cards must wrap within the phone width.")
				for line in card.get_child(0).get_children():
					if line is Label: detail_text += line.text
		_check(detail_text.contains("Good Parent ×2") and detail_text.contains("+5% health") and detail_text.contains("NOT YET EARNED") and detail_text.contains("4 SEASONS LEFT"), "Perks must show repeated bonus counts, real effects, progress and temporary duration.")
		var bonus_scroll: ScrollContainer = list.get_parent()
		var was_emulating := Input.is_emulating_touch_from_mouse()
		Input.set_emulate_touch_from_mouse(true)
		var touch := InputEventScreenTouch.new()
		touch.position = bonus_scroll.get_global_rect().get_center()
		touch.pressed = true
		Input.parse_input_event(touch)
		Input.flush_buffered_events()
		await get_tree().process_frame
		var drag := InputEventScreenDrag.new()
		drag.position = touch.position - Vector2(0, 100)
		drag.relative = Vector2(0, -100)
		Input.parse_input_event(drag)
		Input.flush_buffered_events()
		await get_tree().process_frame
		touch.pressed = false
		touch.position = drag.position
		Input.parse_input_event(touch)
		Input.flush_buffered_events()
		await get_tree().process_frame
		_check(bonus_scroll.scroll_vertical > 0, "An actual touch swipe must scroll the bonus cards.")
		Input.set_emulate_touch_from_mouse(was_emulating)
		bonus_scroll.ensure_control_visible(list.get_child(list.get_child_count() - 1))
		await get_tree().process_frame
		_check(bonus_scroll.scroll_vertical > 0, "The final bonus card must be reachable by scrolling.")
		bonus_scroll.scroll_vertical = 0
		if DisplayServer.get_name() != "headless":
			await RenderingServer.frame_post_draw
			get_viewport().get_texture().get_image().save_png("res://.godot/perks_%d.png" % viewport_size.x)
		var close: Button = game._bonuses_overlay.get_node("Card").get_child(0).get_node("Close")
		_check(close.get_global_rect().end.y <= viewport_size.y and close.size.y >= 44, "Back must remain outside the scroll and always reachable.")
		close.pressed.emit()
		await get_tree().process_frame
		await get_tree().process_frame
		_check(not is_instance_valid(game._bonuses_overlay), "Back must close the perks screen cleanly.")
		var original_strength := GameState.strength
		GameState.strength += 0.03
		_tap(game.tab_bonuses)
		await get_tree().process_frame
		var refreshed_list: VBoxContainer = game._bonuses_overlay.get_node("Card").get_child(0).get_node("Scroll/Cards")
		_check(refreshed_list.get_child(1).get_child(0).get_child(1).text == "Strength · %.1f%%" % (GameState.strength * 100), "Reopening stats after an ability changes must show the new value.")
		game._hide_bonuses_overlay()
		GameState.strength = original_strength
		if viewport_size.x == 390:
			GameState.journey_state = {"kind": "migration", "phase": 3, "reward": 0.04, "reward_until": GameState.seasons_elapsed + 3}
			GameState.living_state = {"site": "grove", "shelter": 2}
			GameState.offspring_history = [{"name": "Reed", "bond": "strong"}]
			GameState.fights_won = 5
			for member in C.active_cast(): member["trust"] = 0.8
			P.award()
			game._dashboard.refresh()
			game._show_bonuses_popup()
			await get_tree().process_frame
			await get_tree().process_frame
			if DisplayServer.get_name() != "headless":
				await RenderingServer.frame_post_draw
				get_viewport().get_texture().get_image().save_png("res://.godot/perks_earned_390.png")
		game._hide_bonuses_overlay()
		if viewport_size.x == 390:
			GameState.injuries.clear()
			game._dashboard.refresh()
			await get_tree().process_frame
			await get_tree().process_frame
			if DisplayServer.get_name() != "headless":
				await RenderingServer.frame_post_draw
				get_viewport().get_texture().get_image().save_png("res://.godot/adventure_gameplay_390.png")
		game.event_overlay.show_event({"type": "living_event", "title": "A quiet moment", "event_id": "iguanodon_resting_together", "flavor": "Reed settles beside you beneath the ferns. For once, there is no rush to move on.\n\nYou could stay a little longer, or lead the herd toward the river before dusk.", "choices": [{"action": "rest", "label": "Rest together"}, {"action": "water", "label": "Head to the river"}]})
		game.event_overlay._finish_typewriter()
		await get_tree().create_timer(0.4).timeout
		if DisplayServer.get_name() != "headless":
			await RenderingServer.frame_post_draw
			get_viewport().get_texture().get_image().save_png("res://.godot/adventure_event_%d.png" % viewport_size.x)
		await _check_portrait_shortcuts(game, viewport_size)
		game.queue_free()
		await get_tree().process_frame
		await _capture_trex_game(viewport_size)
	get_tree().root.size = original_size
	get_tree().root.content_scale_size = original_scale


func _check_card_text(game: Control, dimensions: Vector2i) -> void:
	var card: Button = game.cards_container.get_child(0)
	var old_description: String = card.subtitle_label.text
	card.subtitle_label.text = "Your herd is resting near the river. Shelter is improving, but the nearby rivals are growing bolder and your companions need time to recover."
	for frame in 5: await get_tree().process_frame
	var grown_height := card.size.y
	for action in game.cards_container.get_children():
		if not action.visible: continue
		var inside: Rect2 = action.get_global_rect().grow_individual(-17, -16, -17, -16)
		for line in [action.title_label, action.subtitle_label, action.reward_label]:
			if line.visible:
				_check(inside.encloses(line.get_global_rect()), "Wrapped action text must stay within the illustrated padding at %dpx: %s." % [dimensions.x, action.action_id])
	_check(grown_height > 80, "Long descriptions must grow the card instead of crossing its border.")
	card.subtitle_label.text = old_description
	for frame in 5: await get_tree().process_frame
	_check(card.size.y < grown_height, "A shortened live description must release its extra space.")
	for sid in UnlockManager.PLAYABLE_SPECIES:
		GameState.species_id = sid
		game.event_overlay.show_event(ActionResolver._resolve_sharpen_prompt())
		game.event_overlay._finish_typewriter()
		for frame in 3: await get_tree().process_frame
		var grid: GridContainer = game.event_overlay._choices_grid
		for button in grid.get_children():
			var font: Font = button.get_theme_font("font")
			var style: StyleBox = button.get_theme_stylebox("normal")
			var available_width: float = button.size.x - style.get_content_margin(SIDE_LEFT) - style.get_content_margin(SIDE_RIGHT)
			for line in button.text.split("\n"):
				_check(font.get_string_size(line, HORIZONTAL_ALIGNMENT_LEFT, -1, 16).x <= available_width, "Every dinosaur's training choice must fit inside its card at %dpx: %s." % [dimensions.x, sid])
			_check(button.get_combined_minimum_size().y <= button.size.y and button.get_global_rect().end.x <= dimensions.x - 12, "Training choices must have room for every text line and both borders.")
		var choices_scroll: ScrollContainer = grid.get_parent()
		choices_scroll.ensure_control_visible(grid.get_child(grid.get_child_count() - 1))
		await get_tree().process_frame
		_check(choices_scroll.get_global_rect().intersects(grid.get_child(grid.get_child_count() - 1).get_global_rect()), "The last training choice must remain reachable when larger cards need scrolling.")
		if sid == "iguanodon" and DisplayServer.get_name() != "headless":
			choices_scroll.scroll_vertical = 0
			await get_tree().create_timer(0.3).timeout
			await RenderingServer.frame_post_draw
			get_viewport().get_texture().get_image().save_png("res://.godot/training_cards_%d.png" % dimensions.x)
	GameState.species_id = "iguanodon"
	game.event_overlay.hide_overlay()
	game._dashboard.refresh()


func _check_portrait_shortcuts(game: Control, dimensions: Vector2i) -> void:
	var previous := {"species_id": GameState.species_id, "life_stage": GameState.life_stage, "health": GameState.health}
	await get_tree().process_frame
	game.event_overlay.hide_overlay()
	game._waiting_for_choice = false
	game._queued_events.clear()
	for sid in UnlockManager.PLAYABLE_SPECIES:
		GameState.species_id = sid
		for stage in 5:
			GameState.life_stage = stage
			for health in [0.8, 0.4]:
				GameState.health = health
				game._update_dino_image()
				game._dashboard.refresh()
				await get_tree().process_frame
				await get_tree().process_frame
				var portrait: Rect2 = game.dino_image.get_global_rect()
				for button in game._dashboard.shortcut_row.get_children():
					if not button.visible: continue
					_check(get_viewport().get_visible_rect().encloses(button.get_global_rect()) and button.size.x >= 44 and button.size.y >= 44 and not portrait.intersects(button.get_global_rect()), "Every detail icon must remain tappable outside all ten species' healthy and injured stage portraits.")
				_check(not portrait.intersects(game.settings_btn.get_global_rect()) and not portrait.intersects(game.get_node("AlphaBadge").get_global_rect()), "Settings and the alpha crown must never cover a dinosaur's face.")
				if sid == "trex" and stage == 3 and DisplayServer.get_name() != "headless":
					await RenderingServer.frame_post_draw
					get_viewport().get_texture().get_image().save_png("res://.godot/shortcuts_trex_%d_%s.png" % [dimensions.x, "healthy" if health > 0.6 else "injured"])
	for key in previous: GameState.set(key, previous[key])
	game._update_dino_image()
	game._dashboard.refresh()


func _capture_trex_game(dimensions: Vector2i) -> void:
	_start("trex")
	GameState.seasons_elapsed = 13
	GameState.has_young = true
	GameState.offspring_name = "Pebble"
	var game := preload("res://scenes/game/game_screen.tscn").instantiate()
	add_child(game)
	await get_tree().process_frame
	await get_tree().process_frame
	_check(game.cards_container.get_children().any(func(card): return card.action_id == "hunt") and game.cards_container.get_children().all(func(card): return card.action_id != "graze"), "T-Rex previews must use an actual predator game screen and its own action choices.")
	for health in [0.8, 0.4]:
		GameState.health = health
		game._stat_bars["health"].set_value_normalized(health)
		game._update_dino_image()
		game._dashboard.refresh()
		await get_tree().process_frame
		await get_tree().process_frame
		if DisplayServer.get_name() != "headless":
			await RenderingServer.frame_post_draw
			get_viewport().get_texture().get_image().save_png("res://.godot/shortcuts_trex_%d_%s.png" % [dimensions.x, "healthy" if health > 0.6 else "injured"])
	game.queue_free()
	await get_tree().process_frame


func _tap(control: Control) -> void:
	var click := InputEventMouseButton.new()
	click.position = control.get_global_rect().get_center()
	click.button_index = MOUSE_BUTTON_LEFT
	click.pressed = true
	Input.parse_input_event(click)
	Input.flush_buffered_events()
	click = click.duplicate()
	click.pressed = false
	Input.parse_input_event(click)
	Input.flush_buffered_events()
