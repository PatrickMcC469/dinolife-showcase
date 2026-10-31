extends RefCounted

const WORLD = preload("res://scripts/systems/world_conditions.gd")
const JOURNEYS = preload("res://scripts/systems/journeys.gd")
const COMPANIONS = preload("res://scripts/systems/companions.gd")
var harness: Node


func _check(condition: bool, message: String) -> void:
	harness._check(condition, message)


func _start(species: String = "iguanodon") -> void:
	GameState.start_run(species)
	GameState.sex = "male"
	GameState.life_stage = 3
	var stages: Array = SpeciesDB.get_species(species)["life_stages"]
	var adult_start := int(stages[0]) + int(stages[1]) + int(stages[2])
	GameState.seasons_elapsed = adult_start + posmod(1 - adult_start, 4)
	GameState.current_season = 1
	GameState.current_year = int(GameState.seasons_elapsed / 4.0) + 1
	GameState.health = 0.8
	GameState.hunger = 0.8
	GameState.world_state = {"kind": "", "until": -1, "cooldown": 9999, "last_tick": -1}
	COMPANIONS.ensure_cast()
	COMPANIONS.next_event()
	COMPANIONS.resolve("welcome")


func _later() -> void:
	GameState.seasons_elapsed += 1
	GameState.current_season = GameState.seasons_elapsed % 4
	GameState.current_year = int(GameState.seasons_elapsed / 4.0) + 1


func run(check_harness: Node) -> void:
	harness = check_harness
	_check_worlds()
	_check_actions()
	_check_migrations()
	_check_territories()
	_check_saves()
	_check_priorities()
	await _check_ui()
	GameState.delete_save()
	print("World and journey checks: lasting conditions and real action effects, both migration routes, rival range outcomes, companion advice/support, priority, saves, stale/duplicate choices, memorial copies, and phone-width UI.")


func _check_worlds() -> void:
	for condition in WORLD.CONDITIONS:
		_start()
		WORLD.begin(condition)
		var original := GameState.world_state.duplicate(true)
		var memories := GameState.life_events.size()
		seed(73)
		var next_roll := randf()
		seed(73)
		WORLD.tick()
		_check(GameState.world_state == original and is_equal_approx(randf(), next_roll), "Starting a season twice must not reroll world conditions or consume randomness.")
		_check(WORLD.kind() == condition and WORLD.summary().contains("3 seasons"), "Every condition must display its full three-season duration.")
		GameState.save_run()
		GameState.world_state = {}
		_check(GameState.load_run() and WORLD.kind() == condition, "World conditions must survive a real save/load.")
		GameState.seasons_elapsed += 2
		WORLD.tick()
		_check(WORLD.kind() == condition, "Conditions must last through the third affected season.")
		GameState.seasons_elapsed += 1
		WORLD.tick()
		_check(WORLD.kind().is_empty() and GameState.life_events.size() == memories + 1, "Conditions must expire once, with a recovery memory and a quiet interval.")
		WORLD.tick()
		_check(GameState.life_events.size() == memories + 1, "Recovery memories must not duplicate on refresh.")
	_start()
	GameState.life_stage = 0
	GameState.world_state = {}
	WORLD.tick()
	_check(WORLD.kind().is_empty() and WORLD.extra_hunger() == 0.0, "Hatchlings must remain outside lasting condition penalties.")
	# Exercise natural seasonal selection, rather than only manually seeded fixtures.
	for season in 4:
		var appeared := false
		for sample in 50:
			_start()
			GameState.current_season = season
			GameState.world_state = {}
			seed(sample)
			WORLD.tick()
			if not WORLD.kind().is_empty():
				appeared = true
				_check(WORLD.kind() in [["flood", "rivals"], ["drought", "shortage"], ["rivals", "shortage"], ["shortage", "rivals"]][season], "Natural conditions must match the seasonal pool.")
		_check(appeared, "Natural conditions must actually occur in each seasonal pool.")
	_start("compsognathus")
	GameState.hunger = 1.0
	TurnManager._drain_hunger()
	var calm_food := GameState.hunger
	GameState.hunger = 1.0
	WORLD.begin("drought")
	TurnManager._drain_hunger()
	_check(is_equal_approx(calm_food - GameState.hunger, 0.03), "Drought must apply exactly 3% extra food drain in the real turn logic.")


func _action(action: String) -> Dictionary:
	match action:
		"hunt": return ActionResolver._resolve_hunt_roll()
		"graze": return ActionResolver._resolve_graze_roll()
		"scavenge": return ActionResolver._resolve_scavenge("search")
		"water": return ActionResolver._resolve_water()
		_: return ActionResolver._resolve_territory()


func _check_actions() -> void:
	for action in ["hunt", "graze", "scavenge", "water", "territory"]:
		var changed := 0
		for sample in 200:
			_start("iguanodon" if action == "graze" else "compsognathus")
			GameState.daily_luck = 0.0
			GameState.action_uses = {action: 1}
			seed(sample)
			var calm := _action(action)
			_start("iguanodon" if action == "graze" else "compsognathus")
			GameState.daily_luck = 0.0
			GameState.action_uses = {action: 1}
			WORLD.begin("drought" if action == "water" else ("rivals" if action == "territory" else "shortage"))
			seed(sample)
			if _action(action) != calm:
				changed += 1
		_check(changed > 0, "World conditions must change actual %s outcomes, not just their labels." % action)
	_start()
	WORLD.begin("flood")
	_check(WORLD.modifier("graze") > 0.0 and WORLD.modifier("hunt") < 0.0, "Floods must provide fresh growth as well as danger.")


func _check_migrations() -> void:
	for route in ["ridge", "river"]:
		for flooded in [false, true]:
			_start()
			var intro := JOURNEYS.next_event()
			_check(intro.get("resolve_key") == "journey" and intro.get("flavor", "").contains(COMPANIONS.current_cast()[0]["name"]), "A migration must introduce named advice.")
			var advisor: Dictionary = COMPANIONS.current_cast()[0 if route == "ridge" else 1]
			var initial_trust := float(advisor["trust"])
			var initial_food := GameState.hunger
			ActionResolver.resolve("journey", route)
			_check(is_equal_approx(initial_food - GameState.hunger, 0.08 if route == "ridge" else 0.04) and is_equal_approx(float(advisor["trust"]) - initial_trust, 0.15), "Migration routes must charge their stated cost and remember whose advice was followed.")
			var paid := GameState.hunger
			ActionResolver.resolve("journey", route)
			_check(GameState.hunger == paid and JOURNEYS.next_event().is_empty(), "A paid chapter must not repeat or advance twice in one season.")
			_later()
			if flooded:
				WORLD.begin("flood")
			JOURNEYS.next_event()
			GameState.save_run()
			GameState.journey_state = {}
			GameState.load_run()
			_check(not JOURNEYS.pending_event().is_empty() and GameState.journey_state["route"] == route, "A pending crossing must resume on the chosen route.")
			var health_before := GameState.health
			ActionResolver.resolve("journey", "push")
			var expected := 0.04 if route == "ridge" else (0.10 if flooded else 0.08)
			_check(is_equal_approx(health_before - GameState.health, expected), "Route and flood conditions must change the actual crossing cost.")
			_later()
			JOURNEYS.next_event()
			GameState.hunger = 0.4
			ActionResolver.resolve("journey", "settle")
			_check(is_equal_approx(GameState.hunger, 0.6) and GameState.journey_state["phase"] == 3 and GameState.journey_state["outcome"].contains(route), "Arrival must grant its food once and record the chosen migration route.")
			var food_after := GameState.hunger
			ActionResolver.resolve("journey", "settle")
			_check(GameState.hunger == food_after and JOURNEYS.next_event().is_empty(), "Completed migration rewards must never replay.")
			GameState.world_state = {}
			_check(is_equal_approx(WORLD.modifier("graze"), 0.06), "Arrival must combine its three-season 4% feeding reward with the earned 2% Trailwise perk.")
			GameState.seasons_elapsed += 3
			_check(is_equal_approx(WORLD.modifier("graze"), 0.02), "The valley advantage must expire while the once-earned Trailwise perk remains for this life.")
	_start()
	JOURNEYS.next_event()
	JOURNEYS.resolve("river")
	_later()
	JOURNEYS.next_event()
	var cached := JOURNEYS.pending_event()
	GameState.health = 0.02
	GameState.hunger = 0.01
	var invalid := JOURNEYS.resolve("push")
	_check(invalid.get("next_context") == "journey" and is_equal_approx(GameState.health, 0.02) and GameState.journey_state["pending"], "Stale unaffordable crossing choices must preserve the pending chapter and offer new options.")
	_check(cached["choices"].size() > JOURNEYS.pending_event()["choices"].size(), "Weak players must receive affordable current choices.")
	JOURNEYS.resolve("leave")
	_check(GameState.journey_state["phase"] == 3 and GameState.journey_state["reward"] == 0.0, "Turning back must be a free permanent exit without a reward.")
	_start()
	JOURNEYS.next_event()
	JOURNEYS.resolve("ridge")
	_later()
	JOURNEYS.next_event()
	var helper: Dictionary = COMPANIONS.current_cast()[0]
	var helper_name: String = helper["name"]
	var food_before := GameState.hunger
	var supported := JOURNEYS.resolve("together")
	_check(supported["flavor"].contains(helper_name) and int(helper["help_season"]) == GameState.seasons_elapsed and is_equal_approx(food_before - GameState.hunger, 0.03), "A trusting companion must actually help and consume its seasonal support at the stated food cost.")
	_later()
	GameState.pack_bond = 0.0
	COMPANIONS.leave_group("The herd moved away.")
	var alone := JOURNEYS.next_event()
	_check(alone["flavor"].contains("alone"), "An existing migration must remain finishable after the herd disbands.")
	var health_before := GameState.health
	JOURNEYS.resolve("rich")
	_check(is_equal_approx(health_before - GameState.health, 0.07), "The rich arrival choice must charge its exposed approach cost.")
	_start()
	JOURNEYS.next_event()
	JOURNEYS.resolve("river")
	_later()
	JOURNEYS.next_event()
	COMPANIONS.take_support("in another encounter")
	food_before = GameState.hunger
	var used_support := JOURNEYS.resolve("together")
	_check(used_support.get("next_context") == "journey" and GameState.hunger == food_before and GameState.journey_state["pending"], "A stale support choice must not charge food or reuse a companion who already helped this season.")


func _check_territories() -> void:
	for route in ["share", "hold"]:
		_start("compsognathus")
		WORLD.begin("rivals")
		_check(JOURNEYS.next_event().get("flavor", "").contains("Another small pack"), "Compy territory stories must respond to rival pressure.")
		JOURNEYS.resolve(route)
		_later()
		JOURNEYS.next_event()
		JOURNEYS.resolve("careful" if route == "share" else "push")
		_later()
		JOURNEYS.next_event()
		GameState.world_state = {}
		GameState.hunger = 0.4
		var health_before := GameState.health
		JOURNEYS.resolve("settle")
		_check(is_equal_approx(GameState.hunger, 0.55 if route == "share" else 0.6), "Shared and defended ranges must grant different stated food rewards.")
		_check(is_equal_approx(WORLD.modifier("territory"), 0.03 if route == "share" else 0.05) and is_equal_approx(health_before - GameState.health, 0.0 if route == "share" else 0.05), "Territory endings must grant their own lasting advantage and charge only the defended range's final wound.")
		var death = load("res://scripts/ui/death_screen.gd").new()
		death._build_run_record()
		var memorial: Dictionary = death._run_record.duplicate(true)
		GameState.journey_state["outcome"] = "changed"
		_check(memorial["journey"]["outcome"] != "changed" and str(memorial["memorial"]).contains("range"), "Completed territorial memories must stay independent of live state.")
		death.free()
	# Changing course is a real decision, not an irreversible first click.
	_start("compsognathus")
	WORLD.begin("rivals")
	JOURNEYS.next_event()
	JOURNEYS.resolve("hold")
	_later()
	JOURNEYS.next_event()
	JOURNEYS.resolve("careful")
	_check(GameState.journey_state["route"] == "share", "Making room at the second chapter must turn a defended range into a truce.")


func _check_saves() -> void:
	_start()
	JOURNEYS.next_event()
	WORLD.begin("drought")
	GameState.save_run()
	var original := JSON.parse_string(FileAccess.get_file_as_string(GameState.SAVE_PATH)) as Dictionary
	for bad in [null, [], "invalid", {"kind": "unknown"}, {"kind": "migration", "phase": "two"}, {"kind": "migration", "phase": 1, "route": "hold"}]:
		var data := original.duplicate(true)
		data["journey_state"] = bad
		data["world_state"] = bad
		var file := FileAccess.open(GameState.SAVE_PATH, FileAccess.WRITE)
		file.store_string(JSON.stringify(data))
		file.close()
		_check(GameState.load_run() and GameState.journey_state.is_empty(), "Malformed new save fields must recover safely without inventing a chapter.")
		_check(WORLD.kind().is_empty(), "Malformed condition saves must load without a penalty.")
	original.erase("world_state")
	original.erase("journey_state")
	var file := FileAccess.open(GameState.SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(original))
	file.close()
	_check(GameState.load_run() and GameState.world_state.is_empty() and GameState.journey_state.is_empty(), "Older saves must resume with empty new-field defaults.")
	var sanitized := JOURNEYS.restore({"kind": "migration", "phase": 3.0, "route": "river", "pending": true, "reward": "bad", "due": "bad", "advisor": [], "reward_until": "bad"}, "iguanodon")
	_check(not sanitized["pending"] and sanitized["reward"] == 0.0 and sanitized["due"] == -1 and sanitized["advisor"] == "", "New numeric and text fields must be explicitly restored to safe types.")
	_check(JOURNEYS.restore({"kind": "migration", "phase": 0}, "compsognathus").is_empty(), "A saved journey must belong to its dinosaur.")


func _check_priorities() -> void:
	_start()
	GameState.companion_event_count = 0
	_check(JOURNEYS.next_event().is_empty(), "New companions must get their introduction before a journey can start.")
	GameState.companion_event_count = 1
	JOURNEYS.next_event()
	JOURNEYS.resolve("ridge")
	_later()
	GameState.breed_effort_pending = true
	var events: Array = []
	var capture := func(event: Dictionary): events.append(event)
	TurnManager.event_fired.connect(capture)
	TurnManager.start_turn()
	TurnManager.event_fired.disconnect(capture)
	_check(not events.is_empty() and events[-1].get("resolve_key") != "journey" and not GameState.journey_state["pending"], "Existing breeding continuations must precede a due migration chapter.")
	GameState.breed_effort_pending = false
	_later()
	GameState.health = 0.8
	GameState.hunger = 0.8
	events.clear()
	TurnManager.event_fired.connect(capture)
	TurnManager.start_turn()
	TurnManager.event_fired.disconnect(capture)
	_check(not events.is_empty() and events[-1].get("resolve_key") == "journey", "The real turn loop must offer a delayed chapter when higher-priority events are clear.")
	_start()
	JOURNEYS.next_event()
	JOURNEYS.resolve("river")
	_later()
	GameState.has_young = true
	GameState.has_young_turns = 999
	GameState.nesting_score = 0.7
	events.clear()
	TurnManager.event_fired.connect(capture)
	TurnManager.start_turn()
	TurnManager.event_fired.disconnect(capture)
	_check(not events.is_empty() and events[-1].get("resolve_key") != "journey" and not GameState.journey_state["pending"], "A nesting outcome must retain priority over a due migration chapter.")
	for species in ["trex", "allosaurus", "triceratops", "deinonychus", "lesothosaurus", "ankylosaurus"]:
		_start(species)
		_check(JOURNEYS.next_event().get("resolve_key") == "journey" and GameState.journey_state.get("kind") == "personal", "The six remaining first-edition species must have an authored journey, including solitary dinosaurs.")


func _check_ui() -> void:
	for species in ["iguanodon", "compsognathus"]:
		_start(species)
		WORLD.begin("drought" if species == "iguanodon" else "rivals")
		JOURNEYS.next_event()
		GameState.save_run()
		GameState.journey_state = {}
		GameState.load_run()
		var game = load("res://scenes/game/game_screen.tscn").instantiate()
		harness.root.add_child(game)
		await harness.get_tree().process_frame
		await harness.get_tree().process_frame
		_check(game._waiting_for_choice and game._action_context == "journey", "The actual game screen must restore a waiting journey chapter.")
		_check(not game.has_node("ActionScroll/ActionList/World") and game._dashboard.map_button.visible, "Environment information must be reachable from a fixed icon rather than occupying the action list.")
		var route := "river" if species == "iguanodon" else "hold"
		for phase in 3:
			if phase > 0:
				_later()
				game._on_turn_started()
				game._on_event_ready(JOURNEYS.next_event())
			# First tap reveals the full text without making the choice.
			var action := route if phase == 0 else ("together" if phase == 1 else "settle")
			game.event_overlay._on_choice(action)
			await harness.get_tree().create_timer(0.25).timeout
			_check(game.event_overlay._flavor_label.text.length() > 100, "Journey chapters must display their authored story text.")
			for button in game.event_overlay._choices_grid.get_children():
				var choices_scroll: ScrollContainer = game.event_overlay._choices_grid.get_parent()
				choices_scroll.ensure_control_visible(button)
				await harness.get_tree().process_frame
				_check(not button.text.is_empty() and choices_scroll.get_global_rect().encloses(button.get_global_rect()) and button.get_global_rect().end.y <= harness.root.get_visible_rect().size.y - game.event_overlay._safe_bottom, "Every fully wrapped journey choice must be reachable above the phone's bottom safe area.")
			game.event_overlay._choices_grid.get_parent().scroll_vertical = 0
			if "--capture-memorial" in OS.get_cmdline_user_args():
				await RenderingServer.frame_post_draw
				harness.root.get_texture().get_image().save_png("res://.godot/journey_%s_%d.png" % [species, phase])
			game.event_overlay._on_choice(action)
			game.event_overlay._on_choice("ok")
			game.event_overlay._on_choice("ok")
			await harness.get_tree().process_frame
		game._dashboard._show_map()
		await harness.get_tree().process_frame
		game._dashboard.map_view.details_button.pressed.emit()
		await harness.get_tree().process_frame
		var panel = game._dashboard.map_view.world_panel
		_check(panel.details.visible and panel.details.text.contains("bonus"), "World details must explain the lasting story reward alongside current conditions.")
		var scroll: ScrollContainer = game._dashboard.map_view.scroll
		_check(panel.size.x <= scroll.size.x and scroll.get_v_scroll_bar().max_value > scroll.get_v_scroll_bar().page, "Environment details must fit phone width inside the dedicated habitat view.")
		if "--capture-memorial" in OS.get_cmdline_user_args():
			await RenderingServer.frame_post_draw
			harness.root.get_texture().get_image().save_png("res://.godot/world_%s.png" % species)
			scroll.scroll_vertical = int(panel.position.y)
			await harness.get_tree().process_frame
			await RenderingServer.frame_post_draw
			harness.root.get_texture().get_image().save_png("res://.godot/world_%s_details.png" % species)
		GameState.world_state = {}
		GameState.seasons_elapsed += 3
		panel.refresh()
		_check(not panel.visible, "A settled world with an expired story bonus must give the space back to action cards.")
		game.queue_free()
		await harness.get_tree().process_frame
