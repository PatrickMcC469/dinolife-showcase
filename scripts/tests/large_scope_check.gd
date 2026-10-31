extends RefCounted

const PAIRS = preload("res://scripts/systems/pack_relationships.gd")
const C = preload("res://scripts/systems/companions.gd")
var harness: Node


func _start(species: String = "iguanodon", count: int = 6) -> void:
	GameState.start_run(species)
	GameState.life_stage = 3
	GameState.seasons_elapsed = 20
	GameState.hunger = 0.8
	GameState.health = 0.8
	GameState.pack_bond = 0.8
	GameState.companions = []
	GameState.companion_group_id = 1
	GameState.pack_relations = {}
	for index in count:
		C._add_member(["Fern", "Brook", "Reed", "Willow", "Clover", "Moss"][index])
		C.active_cast().back()["trait"] = "cautious"
	GameState.companion_event = {}
	GameState.companion_event_count = 1
	GameState.companion_last_event_season = 20
	GameState.living_state = {"last_event": 20}
	PAIRS.sync()


func run(check_harness: Node) -> void:
	harness = check_harness
	_check_relationships()
	var old_scale: Vector2i = harness.root.content_scale_size
	var old_emulation := Input.is_emulating_touch_from_mouse()
	Input.set_emulate_touch_from_mouse(true)
	for dimensions in [Vector2i(390, 844), Vector2i(320, 568)]:
		harness.root.size = dimensions
		harness.root.content_scale_size = dimensions
		await _check_ui(dimensions.x)
	Input.set_emulate_touch_from_mouse(old_emulation)
	harness.root.content_scale_size = old_scale
	harness.root.size = Vector2i(390, 844)
	GameState.delete_save()
	print("Large scope checked: live capped peer bonds, season/council/care/support consequences, saved and stale decisions, group changes and solo species, real habitat choices, phone-size map/web taps, scrolling and modal safety.")


func _check_relationships() -> void:
	_start()
	harness._check(GameState.pack_relations["pairs"].size() == 15 and GameState.pack_relations["pairs"].all(func(pair): return pair["score"] == 0.0), "Six companions must have exactly fifteen neutral pair bonds, never invented friendships.")
	var first: Dictionary = C.active_cast()[0]
	var second: Dictionary = C.active_cast()[1]
	var pair := PAIRS.pair_for(first["name"], second["name"])
	for season in range(21, 26):
		GameState.seasons_elapsed = season
		PAIRS.tick()
	harness._check(PAIRS.status(pair) == "Friends", "Compatible members must become friends over actual seasons.")
	var score: float = pair["score"]
	PAIRS.tick()
	harness._check(pair["score"] == score, "Repeated seasonal hooks must not improve bonds twice.")
	first["trust"] = 0.9
	second["trust"] = 0.9
	var support := C.take_support("at a crossing")
	harness._check(first["name"] in support and second["name"] in support and GameState.temp_buffs.any(func(buff): return buff["source"] == "Friends working together" and is_equal_approx(buff["amount"], 0.02)), "Two actual trusted friends supporting a crossing must grant the real defense buff.")
	PAIRS.cooperation(support)
	harness._check(GameState.get_action_uses("pair_support") == 1, "Friendship support must be capped once per season.")
	pair["score"] = -0.4
	var another := PAIRS.pair_for(first["name"], C.active_cast()[2]["name"])
	another["score"] = -0.4
	GameState.seasons_elapsed += 1
	var bond := GameState.pack_bond
	PAIRS.tick()
	harness._check(is_equal_approx(bond - GameState.pack_bond, 0.02), "Multiple rivalries must cost only two percent group bond in total.")
	PAIRS.tick()
	harness._check(is_equal_approx(bond - GameState.pack_bond, 0.02), "A repeated seasonal rivalry hook must not charge bond again.")
	GameState.action_uses = {}
	GameState.is_alpha = true
	GameState.council_state = {"kind": "route", "season": GameState.seasons_elapsed, "first": first["name"], "second": second["name"], "newcomer": ""}
	score = pair["score"]
	ActionResolver.resolve("leadership", "council_balance")
	harness._check(is_equal_approx(pair["score"] - score, 0.20), "A real council compromise must improve the two actual members' pair bond.")
	GameState.action_uses = {}
	GameState.council_state["season"] = GameState.seasons_elapsed
	score = pair["score"]
	ActionResolver.resolve("leadership", "council_first")
	harness._check(is_equal_approx(pair["score"] - score, -0.18), "Backing one council concern must strain the pair, not only player trust.")
	var event := PAIRS.event(first["name"], second["name"])
	score = pair["score"]
	GameState.save_run()
	harness._check(GameState.load_run() and PAIRS.pending_event() == event and is_equal_approx(PAIRS.pair_for(first["name"], second["name"])["score"], score), "Pair history, score and the exact pending care choice must survive a real JSON save/resume.")
	pair = PAIRS.pair_for(first["name"], second["name"])
	var food := GameState.hunger
	var care := ActionResolver.resolve("pack_relations", "pair_share")
	harness._check(care.get("feedback", {}).get("gains", []).any(func(gain): return gain.contains("bond +10%")), "Care feedback must report the real visible pair-bond gain on its zero-to-one-hundred meter.")
	harness._check(is_equal_approx(food - GameState.hunger, 0.04) and is_equal_approx(pair["score"] - score, 0.20) and GameState.get_action_uses("pair_care") == 1, "The actual care resolver must charge four percent food and improve the selected pair once.")
	food = GameState.hunger
	score = pair["score"]
	ActionResolver.resolve("pack_relations", "pair_share")
	harness._check(GameState.hunger == food and pair["score"] == score and PAIRS.event(first["name"], second["name"]).is_empty(), "Duplicate care and another pair in the same season must not bypass the limit.")
	GameState.action_uses = {}
	PAIRS.event(first["name"], second["name"])
	GameState.hunger = 0.01
	ActionResolver.resolve("pack_relations", "pair_share")
	harness._check(GameState.hunger == 0.01 and GameState.get_action_uses("pair_care") == 0, "A stale unaffordable share must preserve reserves and the seasonal care.")
	ActionResolver.resolve("pack_relations", "back")
	harness._check(PAIRS.pending_event().is_empty() and GameState.get_action_uses("pair_care") == 0, "Leaving a pair decision must clear saved pending state without spending care.")
	PAIRS.event(first["name"], second["name"])
	GameState.seasons_elapsed += 1
	harness._check(PAIRS.pending_event().is_empty(), "A care choice from an earlier season must expire.")
	PAIRS.event(first["name"], second["name"])
	C._depart(C.active_cast()[0], "Found a different trail.")
	harness._check(GameState.pack_relations["pairs"].size() == 10 and PAIRS.pending_event().is_empty(), "Departures must prune all affected active pairs and stale choices.")
	GameState.hunger = 0.8
	C.new_group()
	harness._check(GameState.pack_relations["pairs"].all(func(link): return link["score"] == 0.0), "Joining another group must start new peer bonds without carrying previous relationships across names.")
	for species in ["trex", "allosaurus", "ankylosaurus"]:
		_start(species, 0)
		PAIRS.tick()
		harness._check(GameState.pack_relations["pairs"].is_empty() and PAIRS.event("Fern", "Brook").is_empty(), "Solitary dinosaurs must never acquire a pack relationship feature.")
	_start()
	var malformed := {"group_id": 1, "pairs": [{"a": "Brook", "b": "Fern", "score": NAN}, {"a": "Brook", "b": "Fern", "score": 1}, {"a": "Fern", "b": "Missing", "score": 1}], "last_tick": INF, "pending": {"a": "Fern", "b": "Missing", "season": 20}}
	var restored := PAIRS.restore(malformed)
	harness._check(restored["pairs"].size() == 1 and restored["pairs"][0]["score"] == 0.0 and restored["pending"].is_empty(), "Malformed, duplicate, nonfinite and unknown-member pair state must be sanitized.")
	GameState.pack_relations = PAIRS.restore(null)
	PAIRS.sync()
	harness._check(GameState.pack_relations["pairs"].size() == 15 and GameState.pack_relations["pairs"].all(func(link): return link["score"] == 0.0), "Older saves must gain neutral peer bonds without rewriting individual trust or names.")
	_start("deinonychus", 4)
	C.active_cast()[0]["trait"] = "bold"
	pair = PAIRS.pair_for("Fern", "Brook")
	for season in range(21, 27):
		GameState.seasons_elapsed = season
		preload("res://scripts/systems/living_world.gd").tick()
	harness._check(PAIRS.status(pair) == "Rivals", "Opposing actual personalities must become rivals through the live season hook even without a home.")
	GameState.action_uses = {}
	score = pair["score"]
	PAIRS.event("Fern", "Brook")
	food = GameState.hunger
	ActionResolver.resolve("pack_relations", "pair_space")
	harness._check(GameState.hunger == food and is_equal_approx(pair["score"] - score, 0.06) and GameState.get_action_uses("pair_care") == 1, "Free care must ease the selected actual rivalry, spend one seasonal care, and charge no food.")


func _settle() -> void:
	for i in 4: await harness.get_tree().process_frame


func _tap(control: Control) -> void:
	var driver := preload("res://scripts/tests/tap_reveal_check.gd").new()
	driver.harness = harness
	driver._click(control.get_global_rect().get_center(), false)


func _capture(name: String) -> void:
	if "--capture-memorial" in OS.get_cmdline_user_args():
		await RenderingServer.frame_post_draw
		harness.root.get_texture().get_image().save_png("res://.godot/" + name + ".png")


func _swipe(control: Control) -> void:
	# Exercise native scrolling with desktop touch emulation, using viewport
	# coordinates independently of the OS cursor. Screen-touch input is checked too.
	var point: Vector2 = control.get_global_rect().get_center()
	var motion := InputEventMouseMotion.new()
	motion.position = point
	harness.root.push_input(motion, true)
	var press := InputEventMouseButton.new()
	press.position = point
	press.button_index = MOUSE_BUTTON_LEFT
	press.button_mask = MOUSE_BUTTON_MASK_LEFT
	press.pressed = true
	harness.root.push_input(press, true)
	motion = motion.duplicate()
	motion.button_mask = MOUSE_BUTTON_MASK_LEFT
	motion.position = point - Vector2(0, 20)
	motion.relative = Vector2(0, -20)
	harness.root.push_input(motion, true)
	await harness.get_tree().process_frame
	motion = motion.duplicate()
	motion.position = point - Vector2(0, 90)
	motion.relative = Vector2(0, -70)
	harness.root.push_input(motion, true)
	var release: InputEventMouseButton = press.duplicate()
	release.position = motion.position
	release.button_mask = 0
	release.pressed = false
	harness.root.push_input(release, true)
	await _settle()


func _touch_swipe(control: Control) -> void:
	var press := InputEventScreenTouch.new()
	press.position = control.get_global_rect().get_center()
	press.pressed = true
	Input.parse_input_event(press)
	Input.flush_buffered_events()
	var drag := InputEventScreenDrag.new()
	drag.position = press.position - Vector2(0, 90)
	drag.relative = Vector2(0, -90)
	Input.parse_input_event(drag)
	Input.flush_buffered_events()
	var release: InputEventScreenTouch = press.duplicate()
	release.position = drag.position
	release.pressed = false
	Input.parse_input_event(release)
	Input.flush_buffered_events()
	await _settle()


func _check_ui(width: int) -> void:
	_start()
	GameState.is_alpha = true
	PAIRS.pair_for("Fern", "Brook")["score"] = 0.5
	PAIRS.pair_for("Fern", "Brook")["reason"] = "Their cautious habits helped them find a shared pace this season."
	PAIRS.pair_for("Fern", "Reed")["score"] = -0.5
	PAIRS.pair_for("Fern", "Reed")["reason"] = "Their cautious and bold habits pulled them in different directions this season."
	C.active_cast()[2]["trait"] = "bold"
	GameState.pack_alpha_name = "Reed"
	GameState.save_run()
	var game = load("res://scenes/game/game_screen.tscn").instantiate()
	harness.root.add_child(game)
	await _settle()
	game.event_overlay.hide_overlay()
	game._waiting_for_choice = false
	game._age_up_active = false
	var saved := FileAccess.get_file_as_string(GameState.SAVE_PATH)
	var state := [GameState.health, GameState.hunger, GameState.seasons_elapsed, GameState.action_uses.duplicate(true)]
	_tap(game._dashboard.map_button)
	await _settle()
	var map = game._dashboard.map_view
	harness._check(map.visible and not game.event_overlay.visible and harness.root.get_visible_rect().encloses(map.panel.get_global_rect()), "The actual home action must open a readable native map on both phone sizes.")
	for marker in map.markers.values(): harness._check(map.map.get_global_rect().encloses(marker.get_global_rect()) and marker.size.y >= 44, "Map marker must fit and be 44 pixels tall: %s %s in %s" % [marker.text, marker.get_global_rect(), map.map.get_global_rect()])
	_tap(map.markers["river"])
	await _settle()
	harness._check(map.selected == "river", "Tapping the river art marker must select its real detail and costs.")
	await _capture("habitat_map_%d" % width)
	await _swipe(map.markers["ridge"])
	harness._check(map.selected == "river", "A swipe over a map marker must scroll instead of selecting another location.")
	if width == 320: harness._check(map.scroll.scroll_vertical > 0, "The short-phone map must scroll from a swipe over its actual marker.")
	game._on_next_season()
	game._on_action_pressed("rest")
	game._dashboard._show_pack()
	harness._check(state == [GameState.health, GameState.hunger, GameState.seasons_elapsed, GameState.action_uses] and not game._dashboard.pack_view.visible and FileAccess.get_file_as_string(GameState.SAVE_PATH) == saved, "Viewing or selecting map places must be read-only and block underlying gameplay and other panels.")
	map.scroll.ensure_control_visible(map.actions[0])
	await _settle()
	_tap(map.actions[0])
	await _settle()
	harness._check(not map.visible and GameState.living_state.get("site") == "river" and is_equal_approx(GameState.hunger, 0.74) and GameState.get_action_uses("home_duty") == 1, "Tapping the displayed settle button must execute the actual range resolver exactly once.")
	game.event_overlay.hide_overlay()
	game._waiting_for_choice = false
	game._on_action_pressed("home")
	await _settle()
	harness._check(map.actions.is_empty(), "The map must reflect a spent seasonal range decision.")
	_tap(map.back)
	GameState.is_alpha = false
	game._dashboard._show_pack()
	await _settle()
	_tap(game._dashboard.pack_view.get_node("Card/Content/Relationships"))
	await _settle()
	var web = game._dashboard.relations_view
	harness._check(web.visible and not game._dashboard.pack_view.visible and web.graph.markers.size() == 6, "The actual Pack Relationships button must show every active member, up to six.")
	for marker in web.graph.markers.values(): harness._check(web.graph.get_global_rect().encloses(marker.get_global_rect()) and marker.size.y >= 44, "Every member button must fit the relationship graph and remain tappable.")
	harness._check(web.graph.markers["Reed"].text.contains("Alpha"), "Only the real companion alpha must be marked in the web.")
	_tap(web.graph.markers["Fern"])
	await _settle()
	harness._check(web.selected == "Fern" and web.care_buttons.size() == 5 and web.member_detail.text.contains("toward you"), "Selecting a member must show all five peer ties separately from their trust in the player.")
	await _capture("pack_relationships_%d" % width)
	await _swipe(web.graph.markers["Reed"])
	harness._check(web.scroll.scroll_vertical > 0 and web.selected == "Fern", "Graph swipe %d: scroll=%d, selected=%s, range=%s, view=%s, point=%s; must scroll without selecting." % [width, web.scroll.scroll_vertical, web.selected, web.scroll.get_v_scroll_bar().max_value, web.scroll.get_global_rect(), web.graph.markers["Reed"].get_global_rect().get_center()])
	web.scroll.scroll_vertical = 0
	await _settle()
	await _touch_swipe(web.graph.markers["Reed"])
	harness._check(web.scroll.scroll_vertical > 0 and web.selected == "Fern", "Actual screen-touch events must scroll from the member button and never click the underlying Pack button.")
	var before := GameState.seasons_elapsed
	game._on_next_season()
	harness._check(GameState.seasons_elapsed == before, "A relationship screen must block the underlying next-season button.")
	web.scroll.ensure_control_visible(web.care_buttons[0])
	await _settle()
	_tap(web.care_buttons[0])
	await _settle()
	harness._check(not web.visible and game.event_overlay.visible and game._waiting_for_choice and game._action_context == "pack_relations", "The actual care button must open the saved and blocking pair decision flow.")
	game.event_overlay.hide_overlay()
	game._on_choice_made("back")
	game._dashboard._show_pack()
	await _settle()
	_tap(game._dashboard.pack_view.get_node("Card/Content/Relationships"))
	await _settle()
	_tap(web.back)
	harness._check(game._dashboard.pack_view.visible and not web.visible, "Back from relationships must return to the real roster.")
	game.queue_free()
	await _settle()
