extends Node

const C = preload("res://scripts/systems/companions.gd")
const T = preload("res://scripts/systems/companion_traits.gd")
const L = preload("res://scripts/systems/living_world.gd")
const P = preload("res://scripts/systems/pack_council.gd")
const J = preload("res://scripts/systems/journeys.gd")
const W = preload("res://scripts/systems/world_conditions.gd")
var failures := 0


func _ready() -> void:
	_run.call_deferred()


func _check(ok: bool, message: String) -> void:
	if not ok:
		failures += 1
		push_error(message)


func _start(sid: String = "iguanodon", season: int = 20) -> void:
	GameState.start_run(sid)
	GameState.life_stage = 3
	GameState.seasons_elapsed = season
	GameState.current_season = season % 4
	GameState.current_year = int(season / 4.0) + 1
	GameState.hunger = 0.8
	GameState.health = 0.8
	GameState.world_state = {"kind": "", "until": -1, "cooldown": 9999}
	C.ensure_cast()
	GameState.companion_event_count = 1


func _later() -> void:
	GameState.advance_season()
	GameState.hunger = 0.8
	GameState.health = 0.8


func _snapshot() -> Array:
	return [GameState.hunger, GameState.health, GameState.companions.duplicate(true), GameState.action_uses.duplicate(true)]


func _run() -> void:
	if not OS.get_user_data_dir().replace("\\", "/").contains("/.godot/depth_userdata/"):
		push_error("Use isolated APPDATA at .godot/depth_userdata.")
		get_tree().quit(2)
		return
	seed(771)
	for sid in C.SPECIES:
		_start(sid)
		var member: Dictionary = C.active_cast()[0]
		var name: String = member["name"]
		member["trait"] = "cautious"
		GameState.companion_event = {"kind": "lead", "name": name, "season": 20}
		_check(C.pending_event()["flavor"].contains("cautious"), "Personality clues must appear before a decision.")
		C.resolve("scout")
		var cautious: float = member["trust"]
		member["trust"] = 0.35
		member["trait"] = "bold"
		GameState.companion_event = {"kind": "lead", "name": name, "season": 20}
		C.resolve("scout")
		_check(float(member["trust"]) > cautious and member["memories"].size() == 1, "The same choice must affect personalities differently, without duplicating its memory.")
		member["trust"] = 0.8
		GameState.save_run()
		_check(GameState.load_run() and C.active_cast()[0]["name"] == name and C.active_cast()[0]["trait"] == "bold" and T.details(C.active_cast()[0]).contains("trusted"), "Identity, personality and specific memories must survive save/load.")
		_check(L.next_event().is_empty(), "Callbacks must wait at least two seasons.")
		GameState.seasons_elapsed += 2
		var echo := L.next_event()
		_check(echo.get("resolve_key") == "living" and echo["flavor"].contains(name), "A later event must recall the actual named dinosaur's decision.")
		GameState.save_run()
		GameState.living_state.clear()
		_check(GameState.load_run() and L.pending_event()["flavor"].contains(name), "A waiting callback must survive resume.")
		ActionResolver.resolve("living", "echo_help")
		_check(is_equal_approx(GameState.hunger, 0.86) and C.active_cast()[0]["help_season"] == GameState.seasons_elapsed, "Returned care must grant its displayed food and use only that member's help.")
		var after := _snapshot()
		ActionResolver.resolve("living", "echo_help")
		_check(_snapshot() == after, "Replayed callbacks must not grant food, trust or support again.")
		GameState.save_run()
		GameState.load_run()
		_check(C.active_cast()[0]["memories"][0]["resolved"] and L.next_event().is_empty(), "A resolved memory and callback cooldown must survive reload.")
	_start()
	var departed: Dictionary = C.active_cast()[0]
	var departed_name: String = departed["name"]
	GameState.companion_event = {"kind": "protect", "name": departed_name, "season": 20}
	C.resolve("abandon")
	GameState.seasons_elapsed += 2
	_check(L.next_event()["flavor"].contains(departed_name) and L.pending_event()["choices"][0]["action"] == "echo_space", "A departed companion must return as a separate dinosaur with their own life.")
	L.resolve("echo_space")
	_check(not departed["active"] and C.active_cast().all(func(member): return member["name"] != departed_name), "A reunion must never silently resurrect a departed member.")
	_start()
	var repaired: Dictionary = C.active_cast()[0]
	T.record(repaired, "keep")
	repaired["trust"] = 1.0
	GameState.seasons_elapsed += 2
	_check(L.next_event()["flavor"].contains("care you have given since"), "Old hurts must acknowledge a relationship that has since recovered.")
	L.resolve("echo_thanks")
	_start()
	var old_name: String = C.active_cast()[0]["name"]
	C.active_cast()[0]["trust"] = 0.67
	GameState.save_run()
	var save_file := FileAccess.open(GameState.SAVE_PATH, FileAccess.READ)
	var old_save: Dictionary = JSON.parse_string(save_file.get_as_text())
	save_file.close()
	old_save.erase("living_state")
	old_save.erase("council_state")
	for member in old_save["companions"]:
		member.erase("trait")
		member.erase("memories")
		member.erase("rest_until")
	save_file = FileAccess.open(GameState.SAVE_PATH, FileAccess.WRITE)
	save_file.store_string(JSON.stringify(old_save))
	save_file.close()
	_check(GameState.load_run() and C.active_cast()[0]["name"] == old_name and is_equal_approx(C.active_cast()[0]["trust"], 0.67) and C.active_cast()[0]["trait"] == "cautious" and GameState.living_state.is_empty(), "Legacy saves must gain stable traits without replacing names, changing trust or inventing a home.")
	_start()
	ActionResolver.resolve("pack_hunger", "keep_food")
	_check(C.active_cast().all(func(member): return T.details(member).contains("kept the food")), "Whole-group food choices must leave specific individual memories too.")
	for site in L.SITES:
		_start("trex")
		ActionResolver.resolve("home", "home_" + site)
		_check(GameState.living_state["site"] == site and is_equal_approx(GameState.hunger, 0.74), "All solitary and social species must be able to choose a home at the displayed cost.")
		_check(is_equal_approx(W.modifier("hunt"), float(L.SITES[site]["feeding"])), "Home feeding bonuses must reach the real feeding modifier.")
		_check(is_equal_approx(W.modifier("territory"), 0.04 if site == "ridge" else 0.0), "High ground must have a real range-claim advantage to balance sparse feeding.")
		var after := _snapshot()
		L.resolve_home("home_prepare")
		_check(_snapshot() == after, "Settling and tending a home share one seasonal decision.")
		_later()
		ActionResolver.resolve("home", "home_prepare")
		_check(GameState.living_state["shelter"] == 1, "Shelter preparation must persist.")
		_later()
		L.resolve_home("home_prepare")
		_check(GameState.living_state["shelter"] == 2, "Shelter must reach its two-level cap.")
		_later()
		var food: float = GameState.hunger
		L.resolve_home("home_prepare")
		_check(GameState.hunger == food and GameState.get_action_uses("home_duty") == 0, "An obsolete preparation choice must not exceed the shelter cap or charge food.")
		GameState.current_season = 3
		_check(L.cold_cost() == 0.0, "Fully prepared shelter must remove the extra cold-season drain.")
		GameState.living_state["wear"] = 3
		W.begin("flood")
		L.tick()
		var health: float = GameState.health
		_check(is_equal_approx(health, 0.79 if site == "river" else 0.8), "River flood damage must account for prepared shelter; high and wooded homes stay clear.")
		L.tick()
		_check(GameState.health == health and GameState.living_state["wear"] == 4, "A season must not deplete or flood a home twice.")
		_check(is_equal_approx(L.modifier("hunt"), float(L.SITES[site]["feeding"]) - 0.04), "Remaining too long must deplete actual feeding chances.")
		L.resolve_home("home_rest")
		_check(GameState.living_state["wear"] == 0 and GameState.living_state["shelter"] == 2, "Resting the ground restores feeding without removing prepared shelter.")
		_later()
		L.resolve_home("home_grove" if site != "grove" else "home_ridge")
		_check(GameState.living_state["shelter"] == 0 and GameState.living_state["wear"] == 0, "Moving must leave the old shelter behind.")
		GameState.save_run()
		var home := GameState.living_state.duplicate(true)
		GameState.living_state = {}
		_check(GameState.load_run() and GameState.living_state.get("site") == home["site"] and GameState.get_action_uses("home_duty") == 1, "Home identity and seasonal limits must survive reload.")
	for kind_index in 3:
		for action in ["council_first", "council_second", "council_balance"]:
			_start("deinonychus", 21 + kind_index)
			GameState.is_alpha = true
			while C.active_cast().size() >= C.max_companions():
				C._depart(C.active_cast().back(), "Made room for this check.")
			var event := ActionResolver.resolve("leadership", "council")
			_check(event.get("next_context") == "leadership" and GameState.council_state["kind"] == P.KINDS[kind_index], "All three real council dilemmas must be reachable through leadership.")
			GameState.save_run()
			var council := GameState.council_state.duplicate(true)
			GameState.council_state = {}
			_check(GameState.load_run() and GameState.council_state == council, "Names and concerns must not reroll on resume.")
			var first := C._find(str(council["first"]))
			var second := C._find(str(council["second"]))
			var t1: float = first["trust"]
			var t2: float = second["trust"]
			ActionResolver.resolve("leadership", action)
			_check(GameState.get_action_uses("alpha_duty") == 1, "Every council decision must share the existing leadership cooldown.")
			_check((first["trust"] > t1 and second["trust"] > t2) if action == "council_balance" else ((first["trust"] > t1 and second["trust"] < t2) if action == "council_first" else (first["trust"] < t1 and second["trust"] > t2)), "Disagreements must change the two actual members independently.")
			if kind_index == 1 and action == "council_second":
				first["trust"] = 1.0
				_check(first["name"] not in C.supporters(), "An exhausted member must really be unavailable for help.")
				_later()
				_check(first["name"] not in C.supporters(), "Pushing an exhausted member must affect the following season too.")
				_later()
				_check(first["name"] in C.supporters(), "Rest must restore their support on schedule.")
			else:
				var after := _snapshot()
				ActionResolver.resolve("leadership", action)
				_check(_snapshot() == after, "Council decisions must not replay or recruit beyond the roster cap.")
	_start("iguanodon", 21)
	GameState.is_alpha = true
	P.menu()
	GameState.hunger = 0.01
	P.resolve("council_balance")
	_check(GameState.get_action_uses("alpha_duty") == 0 and GameState.hunger == 0.01, "Unaffordable compromises must leave the seasonal duty unused.")
	for sid in J.SPECIES["personal"]:
		for route in ["careful_route", "bold_route"]:
			_start(sid)
			_check(J.next_event().get("resolve_key") == "journey", "Every previously missing dinosaur must naturally begin its journey.")
			J.resolve(route)
			_check(is_equal_approx(GameState.hunger, 0.72 if route == "careful_route" else 0.76), "Journey routes must charge their displayed cost.")
			var saved := GameState.journey_state.duplicate(true)
			GameState.save_run()
			GameState.journey_state = {}
			_check(GameState.load_run() and GameState.journey_state["route"] == saved["route"] and J.next_event().is_empty(), "The chosen route must survive reload and wait until next season.")
			_later()
			J.next_event()
			J.resolve("press")
			_check(is_equal_approx(GameState.health, 0.76 if route == "careful_route" else 0.73), "Earlier route choices must change later crossing costs.")
			_later()
			J.next_event()
			J.resolve("settle")
			_check(GameState.journey_state["phase"] == 3 and is_equal_approx(W.modifier("hunt"), 0.03), "Completing each journey must grant a real, bounded feeding reward.")
			var after := _snapshot()
			J.resolve("settle")
			_check(_snapshot() == after, "Final journey rewards cannot be repeated.")
			GameState.seasons_elapsed += 3
			_check(W.modifier("hunt") == 0.0, "Journey rewards must expire after three seasons.")
	_start("ankylosaurus", 21)
	var quiet := L.next_event()
	_check(quiet.get("resolve_key") == "living" and quiet["flavor"].contains("no other dinosaur"), "Solitary species must have authored quiet moments without a virtual pack.")
	L.resolve("moment_watch")
	_check(is_equal_approx(W.modifier("graze"), 0.02), "Quiet observation must have its displayed seasonal benefit.")
	GameState.save_run()
	GameState.load_run()
	_check(is_equal_approx(W.modifier("graze"), 0.02), "Observation benefits must persist through resume.")
	_later()
	_check(W.modifier("graze") == 0.0, "Observation must expire at the next season.")
	_start("ankylosaurus", 21)
	GameState.species_mating_done = true
	GameState.discovery_state["next"] = 9999
	var stages: Array = SpeciesDB.get_species("ankylosaurus")["life_stages"]
	var adult_start := int(stages[0]) + int(stages[1]) + int(stages[2])
	GameState.seasons_elapsed = adult_start + posmod(-adult_start, 3)
	GameState.current_season = GameState.seasons_elapsed % 4
	GameState.current_year = int(GameState.seasons_elapsed / 4.0) + 1
	GameState.journey_state = {"kind": "personal", "phase": 3}
	var events: Array = []
	var capture := func(event: Dictionary): events.append(event)
	TurnManager.event_fired.connect(capture)
	TurnManager.start_turn()
	TurnManager.event_fired.disconnect(capture)
	_check(not events.is_empty() and events[-1].get("resolve_key") == "living", "Quiet moments must be reachable through the actual seasonal loop after family, stories, companions and discoveries.")
	_start("iguanodon", 21)
	GameState.has_young = true
	GameState.offspring_name = "Briar"
	L.next_event()
	var nesting: float = GameState.nesting_score
	L.resolve("moment_teach")
	_check(GameState.nesting_score > nesting and is_equal_approx(GameState.hunger, 0.77), "A quiet parenting choice must feed into the real nesting system.")
	GameState.living_state["site"] = "grove"
	GameState.living_state["last_tick"] = -1
	# Account for practiced family skills separately before checking the grove's own benefit.
	preload("res://scripts/systems/family_legacy.gd").tick()
	nesting = GameState.nesting_score
	L.tick()
	L.tick()
	_check(is_equal_approx(GameState.nesting_score - nesting, 0.03), "A familiar grove must improve real nesting care once per season.")
	_check(L.restore({"site": "unknown", "shelter": "bad", "wear": 999, "event": {"kind": "echo", "name": [], "choice": "abandon"}})["event"].is_empty() and P.restore({"kind": "rest", "season": []}).is_empty(), "Malformed new save state must use safe defaults.")
	await _art_checks()
	await _ui_checks()
	GameState.delete_save()
	for player in SoundManager.get_children():
		if player is AudioStreamPlayer: player.stop()
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().create_timer(0.5).timeout
	print("DEPTH UPDATE CHECKS PASSED" if failures == 0 else "DEPTH UPDATE CHECKS FAILED: %d" % failures)
	get_tree().quit(0 if failures == 0 else 1)


func _art_checks() -> void:
	_start()
	var overlay := preload("res://scenes/ui/event_overlay.tscn").instantiate()
	add_child(overlay)
	await get_tree().process_frame
	var events: Array = []
	for site in L.SITES:
		GameState.living_state["site"] = site
		events.append(L.home_menu())
	GameState.living_state["site"] = "river"
	W.begin("flood")
	_check(L.home_menu()["image_key"] == "flooded_rivers", "An active river flood must not show peaceful river art.")
	GameState.world_state = {}
	GameState.living_state["event"] = {"kind": "moment", "moment": "solitary", "name": ""}
	events.append(L.pending_event())
	for sid in ["iguanodon", "deinonychus", "triceratops", "velociraptor", "compsognathus", "lesothosaurus", "argentinosaurus"]:
		_start(sid)
		var member: Dictionary = C.active_cast()[0]
		T.record(member, "share")
		GameState.living_state["event"] = {"kind": "echo", "choice": "share", "season": GameState.seasons_elapsed, "name": member["name"]}
		member["trust"] = 1.0
		events.append(L.pending_event())
		_check(events[-1]["image_key"] == sid + "_returned_care", "A trusting remembered kindness must show that species returning care.")
		member["trust"] = 0.1
		events.append(L.pending_event())
		_check(events[-1]["image_key"] == sid + "_wary_distance", "Art must follow current trust even after an earlier kindness.")
		member["trust"] = 1.0
		member["active"] = false
		_check(L.pending_event()["image_key"] == sid + "_wary_distance", "Departed companions must keep their distance even with high trust.")
		member["active"] = true
		T.record(member, "keep")
		GameState.living_state["event"]["choice"] = "keep"
		_check(L.pending_event()["image_key"] == sid + "_resting_together", "An old hurt with repaired trust must show current closeness.")
		GameState.living_state["event"] = {"kind": "moment", "moment": "companion", "name": member["name"]}
		events.append(L.pending_event())
		GameState.has_young = true
		GameState.offspring_name = "Briar"
		GameState.living_state["event"] = {"kind": "moment", "moment": "young", "name": "Briar"}
		events.append(L.pending_event())
		GameState.save_run()
		GameState.living_state.clear()
		_check(GameState.load_run() and L.pending_event()["image_key"] == sid + "_teaching_young", "Pending family art must keep the correct species through resume.")
	for sid in ["trex", "allosaurus", "ankylosaurus"]:
		_start(sid)
		GameState.has_young = true
		GameState.offspring_name = "Briar"
		GameState.living_state["event"] = {"kind": "moment", "moment": "young", "name": "Briar"}
		events.append(L.pending_event())
		_check(events[-1]["image_key"] == sid + "_teaching_young" and C.active_cast().is_empty(), "Solo family art must match the species without creating companions.")
		GameState.save_run()
		GameState.living_state.clear()
		_check(GameState.load_run() and L.pending_event()["image_key"] == sid + "_teaching_young", "Solo family art must survive resume.")
		GameState.is_alpha = true
		_check(not P.menu().has("image_key"), "Solo dinosaurs must never gain alpha councils through family art.")
		_start(sid)
		var journey := J.next_event()
		for phase in 3:
			_check(journey.get("image_key") == sid + "_journey_%d" % phase, "Journey art must follow the actual species and chapter.")
			events.append(journey)
			GameState.save_run()
			GameState.journey_state.clear()
			_check(GameState.load_run() and J.pending_event().get("image_key") == journey.get("image_key"), "Journey chapter art must survive resume.")
			J.resolve(["careful_route", "patient", "settle"][phase])
			_later()
			journey = J.next_event()
		_check(journey.is_empty(), "Completed journeys must not replay their chapter artwork.")
	for sid in C.SPECIES:
		for kind_index in 3:
			_start(sid, 21 + kind_index)
			GameState.is_alpha = true
			while C.active_cast().size() >= C.max_companions():
				C._depart(C.active_cast().back(), "Made room for this check.")
			var council := P.menu()
			_check(council.get("image_key") == sid + "_council_" + P.KINDS[kind_index], "Council art must match the species and actual dilemma.")
			events.append(council)
			GameState.save_run()
			GameState.council_state.clear()
			_check(GameState.load_run() and P.menu().get("image_key") == council.get("image_key"), "Council art and dilemma must stay together after resume.")
	_start("iguanodon", 23)
	GameState.is_alpha = true
	P.menu()
	while C.active_cast().size() < C.max_companions():
		C._add_member("Visitor%d" % C.active_cast().size())
	_check(P.menu().get("image_key") == "iguanodon_council_rest", "A full roster must show the replacement rest dilemma, not newcomer art.")
	_start("deinonychus")
	_check(J.next_event().get("image_key") == "journey_event", "Journeys awaiting art must never display a different species' chapter.")
	GameState.species_id = "future_species"
	GameState.living_state["event"] = {"kind": "moment", "moment": "young", "name": "Briar"}
	_check(L._image_key("living") == "living_event", "Unsupported species must keep a generic family fallback.")
	_start()
	for dimensions in [Vector2i(390, 844), Vector2i(320, 568)]:
		get_tree().root.size = dimensions
		get_tree().root.content_scale_size = dimensions
		for event in events:
			overlay.show_event(event)
			overlay._finish_typewriter()
			_check(overlay._event_image.texture.resource_path.ends_with(overlay._EVENT_IMAGES[event["image_key"]]), "Event art must load the selected image: " + str(event["image_key"]))
			await _capture("art_" + str(event["image_key"]) + "_%d" % dimensions.x)
	overlay.queue_free()
	await get_tree().process_frame


func _capture(name: String) -> void:
	if "--capture-depth" not in OS.get_cmdline_user_args(): return
	await get_tree().create_timer(0.3).timeout
	await RenderingServer.frame_post_draw
	get_tree().root.get_texture().get_image().save_png("res://.godot/" + name + ".png")


func _choice_layout(overlay: Control) -> void:
	# Let the preceding menu's queued buttons leave before collecting the new ones.
	await get_tree().process_frame
	var scroll: ScrollContainer = overlay._choices_grid.get_parent()
	for button in overlay._choices_grid.get_children():
		scroll.ensure_control_visible(button)
		await get_tree().process_frame
		_check(scroll.get_global_rect().encloses(button.get_global_rect()), "Every new choice must be fully reachable: %s; button %s; scroll %s" % [button.text, button.get_global_rect(), scroll.get_global_rect()])
		for line in button.text.split("\n"):
			_check(button.get_theme_font("font").get_string_size(line, HORIZONTAL_ALIGNMENT_LEFT, -1, 16).x <= button.size.x - 24.0, "Choice costs and consequences must fit without clipped text: " + line)
		if is_instance_valid(overlay._back_btn):
			_check(not overlay._back_btn.get_global_rect().intersects(scroll.get_global_rect()), "The Back button must not cover a choice.")
	scroll.scroll_vertical = 0


func _ui_checks() -> void:
	for dimensions in [Vector2i(390, 844), Vector2i(320, 568)]:
		_start("iguanodon", 21)
		GameState.is_alpha = true
		var member: Dictionary = C.active_cast()[0]
		T.record(member, "stand")
		GameState.companion_event = {}
		GameState.show_tutorial = false
		get_tree().root.size = dimensions
		get_tree().root.content_scale_size = dimensions
		var screen := preload("res://scenes/game/game_screen.tscn").instantiate()
		add_child(screen)
		await get_tree().process_frame
		await get_tree().process_frame
		var panel = screen.companions_panel
		screen._dashboard._show_pack()
		await get_tree().process_frame
		_check(panel.cards.get_child(0).get_node("Content/Extra/Memories").text.contains("stayed beside") and panel.cards.get_child(0).size.x <= dimensions.x, "Live pack Details must show personality and real memories within phone width.")
		panel.get_parent().ensure_control_visible(panel.cards.get_child(0))
		await _capture("depth_pack_%d" % dimensions.x)
		screen._dashboard.pack_view.hide()
		screen._on_action_pressed("home")
		await get_tree().process_frame
		_check(screen._dashboard.map_view.visible and not screen._waiting_for_choice, "Habitat map must open through the actual game action flow.")
		await _capture("depth_home_%d" % dimensions.x)
		screen._on_map_choice("home_grove")
		_check(GameState.living_state.get("site") == "grove" and not screen._waiting_for_choice, "A home choice must resolve and unlock the real game screen.")
		for kind_index in 3:
			GameState.seasons_elapsed = 21 + kind_index
			GameState.action_uses.erase("alpha_duty")
			GameState.council_state = {}
			while C.active_cast().size() >= C.max_companions():
				C._depart(C.active_cast().back(), "Made room for this check.")
			screen.event_overlay.hide_overlay()
			screen._on_action_pressed("leadership")
			screen._on_choice_made("council")
			await get_tree().process_frame
			screen.event_overlay._finish_typewriter()
			_check(screen._action_context == "leadership" and screen._waiting_for_choice, "Council concerns must continue inside the real choice flow.")
			await _choice_layout(screen.event_overlay)
			await _capture("depth_council_%s_%d" % [P.KINDS[kind_index], dimensions.x])
			screen._on_choice_made("council_first")
			_check(GameState.get_action_uses("alpha_duty") == 1 and not screen._waiting_for_choice, "A council resolution must unlock play and consume the duty.")
		screen.queue_free()
		await get_tree().process_frame
