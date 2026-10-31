extends RefCounted

const JOURNEYS = preload("res://scripts/systems/journeys.gd")
const DISCOVERIES = preload("res://scripts/systems/discoveries.gd")
const COMPANIONS = preload("res://scripts/systems/companions.gd")
const WORLD = preload("res://scripts/systems/world_conditions.gd")
var harness: Node


func _check(ok: bool, message: String) -> void:
	harness._check(ok, message)


func _start(species: String) -> void:
	GameState.start_run(species)
	GameState.sex = "male"
	GameState.life_stage = 3
	var stages: Array = SpeciesDB.get_species(species)["life_stages"]
	var age := int(stages[0]) + int(stages[1]) + int(stages[2])
	GameState.seasons_elapsed = age + posmod(1 - age, 4)
	GameState.current_season = 1
	GameState.current_year = int(GameState.seasons_elapsed / 4.0) + 1
	GameState.hunger = 0.8
	GameState.health = 0.8
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
	var old_unlocks := UnlockManager.unlocked.duplicate(true)
	var profile_existed := FileAccess.file_exists(DISCOVERIES.SAVE_PATH)
	var old_profile := FileAccess.get_file_as_string(DISCOVERIES.SAVE_PATH) if profile_existed else ""
	DirAccess.remove_absolute(ProjectSettings.globalize_path(DISCOVERIES.SAVE_PATH))
	_check_journeys()
	_check_discoveries()
	_check_roster_and_shelters()
	_check_hatchling_cost_labels()
	await _check_action_cards()
	await _check_ui()
	if profile_existed:
		var file := FileAccess.open(DISCOVERIES.SAVE_PATH, FileAccess.WRITE)
		file.store_string(old_profile)
		file.close()
	else:
		DirAccess.remove_absolute(ProjectSettings.globalize_path(DISCOVERIES.SAVE_PATH))
	UnlockManager.unlocked = old_unlocks
	UnlockManager.save_unlocks()
	GameState.delete_save()
	print("Expansion checked: giant migration and raptor range routes, saved chapters and costs, three discoveries and later-species rewards, decline/duplicate/legacy saves, ten-dinosaur roster and seven species shelter encounters, and real selection/menu/game layouts.")


func _check_journeys() -> void:
	for species in ["argentinosaurus", "velociraptor"]:
		for route in (["ridge", "river"] if species == "argentinosaurus" else ["share", "hold"]):
			_start(species)
			if species == "velociraptor":
				WORLD.begin("rivals")
			var event := JOURNEYS.next_event()
			_check(not event.is_empty() and event["flavor"].contains("upland forest" if species == "argentinosaurus" else "reed beds"), "Both expanded journeys must start with their own species story.")
			ActionResolver.resolve("journey", route)
			_check(JOURNEYS.next_event().is_empty(), "A new chapter must wait for a separate season.")
			_later()
			event = JOURNEYS.next_event()
			GameState.save_run()
			GameState.start_run("lesothosaurus")
			_check(GameState.load_run() and JOURNEYS.pending_event() == event, "New species must restore their exact pending chapter and route.")
			if species == "argentinosaurus" and route == "river":
				WORLD.begin("flood")
			var health := GameState.health
			ActionResolver.resolve("journey", "push")
			var cost := (0.04 if route == "ridge" else 0.10) if species == "argentinosaurus" else 0.06
			_check(is_equal_approx(health - GameState.health, cost), "Giant crossings and raptor boundaries must apply their stated health costs.")
			_later()
			JOURNEYS.next_event()
			GameState.hunger = 0.5
			var ending := ActionResolver.resolve("journey", "settle")
			_check(GameState.journey_state["phase"] == 3 and ending["flavor"].contains("upland forest" if species == "argentinosaurus" else "reed-bed"), "New journey endings must record the actual species destination.")
			var state := GameState.journey_state.duplicate(true)
			var food := GameState.hunger
			ActionResolver.resolve("journey", "settle")
			_check(GameState.journey_state == state and GameState.hunger == food, "Repeated new-story accepts must not duplicate their reward.")
			_check(WORLD.modifier("graze") > float(WORLD.CONDITIONS.get(WORLD.kind(), {}).get("graze", 0.0)), "Finished new journeys must affect actual feeding modifiers.")
	_start("argentinosaurus")
	JOURNEYS.next_event()
	ActionResolver.resolve("journey", "river")
	_later()
	JOURNEYS.next_event()
	var supporter: Dictionary = COMPANIONS.current_cast()[0]
	var name: String = supporter["name"]
	var help := ActionResolver.resolve("journey", "together")
	_check(help["flavor"].contains(name) and supporter["help_season"] == GameState.seasons_elapsed, "The giants' trusted trailkeeper must actually spend its support on the crossing.")
	_start("velociraptor")
	WORLD.begin("rivals")
	JOURNEYS.next_event()
	ActionResolver.resolve("journey", "hold")
	_later()
	JOURNEYS.next_event()
	ActionResolver.resolve("journey", "careful")
	_check(GameState.journey_state["route"] == "share", "Raptors must be able to change their disputed lanes into a truce.")
	_later()
	JOURNEYS.next_event()
	ActionResolver.resolve("journey", "settle")
	_check(is_equal_approx(float(GameState.journey_state["reward"]), 0.03), "A raptor truce must earn the smaller, peaceful feeding reward.")
	_start("argentinosaurus")
	JOURNEYS.next_event()
	ActionResolver.resolve("journey", "leave")
	_check(float(GameState.journey_state["reward"]) == 0.0 and JOURNEYS.next_event().is_empty(), "Leaving the giant migration must end it without a bonus.")
	_check(JOURNEYS.restore({"kind": "migration", "phase": 1, "route": "ridge"}, "velociraptor").is_empty(), "Saved stories must reject a species assigned to the wrong journey kind.")


func _check_discoveries() -> void:
	_start("iguanodon")
	var event := DISCOVERIES.next_event()
	_check(event.get("title") == "Room behind the horns", "Large browsers must be able to find the Triceratops shelter.")
	var pending := GameState.discovery_state.duplicate(true)
	GameState.hunger = 0.03
	var retry := ActionResolver.resolve("discovery", "observe")
	_check(retry.get("resolve_key") == "discovery" and GameState.discovery_state == pending, "An unaffordable saved discovery must refresh without spending food or recording knowledge.")
	ActionResolver.resolve("discovery", "leave")
	_check(DISCOVERIES.records().is_empty(), "Moving on must neither record the discovery nor grant a feeding bonus.")
	_start("iguanodon")
	DISCOVERIES.next_event()
	GameState.hunger = 0.96
	GameState.save_run()
	GameState.start_run("trex")
	_check(GameState.load_run() and DISCOVERIES.pending_event().get("title") == event["title"], "A discovery choice must survive a real save/resume.")
	var result := ActionResolver.resolve("discovery", "observe")
	_check(DISCOVERIES.records().has("herd_shelter") and result["feedback"]["gains"].has("Food +4%"), "The recorded shelter must persist and show only the actual capped food gain.")
	var state := GameState.discovery_state.duplicate(true)
	var food := GameState.hunger
	ActionResolver.resolve("discovery", "observe")
	_check(GameState.discovery_state == state and GameState.hunger == food and DISCOVERIES.records().size() == 1, "Duplicate discovery accepts must not spend food or repeat rewards.")
	_check(is_equal_approx(DISCOVERIES.modifier("graze"), 0.025), "Discovery knowledge must add its small modifier to feeding.")
	GameState.seasons_elapsed = int(state["until"])
	_check(DISCOVERIES.modifier("graze") == 0.0, "Discovery advantages must expire after three seasons.")
	_start("lesothosaurus")
	event = DISCOVERIES.next_event()
	_check(GameState.discovery_state["mode"] == "find" and event["flavor"].contains("Argentinosaurus"), "The tiny browser must be able to discover the giants' trail.")
	ActionResolver.resolve("discovery", "observe")
	_start("trex")
	event = DISCOVERIES.next_event()
	var first_id: String = GameState.discovery_state["pending"]
	var source: String = SpeciesDB.get_species(DISCOVERIES.records()[first_id]["source"])["display_name"]
	_check(GameState.discovery_state["mode"] == "recall" and event["flavor"].contains("earlier %s life" % source), "A different later species must be able to use genuinely recorded knowledge.")
	ActionResolver.resolve("discovery", "observe")
	GameState.seasons_elapsed += 4
	event = DISCOVERIES.next_event()
	var second_id: String = GameState.discovery_state["pending"]
	source = SpeciesDB.get_species(DISCOVERIES.records()[second_id]["source"])["display_name"]
	_check(second_id != first_id and event["flavor"].contains("earlier %s life" % source), "A second discovery must retain the actual species that learned it.")
	ActionResolver.resolve("discovery", "observe")
	_check(is_equal_approx(DISCOVERIES.modifier("hunt"), 0.025), "Multiple discovery rewards must replace rather than stack their feeding advantage.")
	GameState.seasons_elapsed += 4
	event = DISCOVERIES.next_event()
	_check(GameState.discovery_state["mode"] == "find" and event["flavor"].contains("Lesothosaurus"), "Large hunters must have their own between-species observation.")
	ActionResolver.resolve("discovery", "observe")
	_check(DISCOVERIES.records().size() == 3 and DISCOVERIES.records()["giant_trail"]["source"] == "lesothosaurus", "The collection must retain all three actual discoveries and their original finder across lives.")
	GameState.save_run()
	GameState.start_run("lesothosaurus")
	GameState.load_run()
	_check(DISCOVERIES.next_event().is_empty(), "Resume must preserve handled discoveries and prevent farming them in the same life.")
	var restored := DISCOVERIES.restore({"handled": ["herd_shelter", "herd_shelter", 17], "pending": "herd_shelter", "mode": "find", "next": "bad", "bonus": "unknown", "until": []})
	_check(restored["handled"] == ["herd_shelter"] and restored["pending"].is_empty() and restored["bonus"].is_empty(), "Malformed and duplicate discovery fields must load with safe defaults.")
	_check(DISCOVERIES.restore(null)["handled"].is_empty(), "Older saves must get a clean discovery state.")
	_start("iguanodon")
	GameState.journey_state = {"kind": "migration", "phase": 1, "route": "ridge", "due": GameState.seasons_elapsed, "pending": false}
	var events: Array = []
	var capture := func(value: Dictionary): events.append(value)
	TurnManager.event_fired.connect(capture)
	TurnManager.start_turn()
	TurnManager.event_fired.disconnect(capture)
	_check(not events.is_empty() and events[-1].get("resolve_key") == "journey" and GameState.discovery_state["pending"].is_empty(), "A due journey must retain priority over discoveries.")
	GameState.save_run()
	var file := FileAccess.open(GameState.SAVE_PATH, FileAccess.READ)
	var old_save: Dictionary = JSON.parse_string(file.get_as_text())
	file.close()
	old_save.erase("discovery_state")
	file = FileAccess.open(GameState.SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(old_save))
	file.close()
	_check(GameState.load_run() and GameState.discovery_state["handled"].is_empty(), "An actual older run save must load without a discovery field.")


func _check_roster_and_shelters() -> void:
	var roster: Array = UnlockManager.PLAYABLE_SPECIES
	_check(roster.size() == 10 and roster == ["compsognathus", "deinonychus", "velociraptor", "allosaurus", "trex", "lesothosaurus", "iguanodon", "triceratops", "ankylosaurus", "argentinosaurus"], "The first edition must contain exactly its original ten playable dinosaurs, separately from Story Mode.")
	for id in DISCOVERIES.ENTRIES:
		_check(DISCOVERIES.ENTRIES[id]["species"] in roster and DISCOVERIES.ENTRIES[id]["finders"].all(func(sid): return sid in roster), "Discovery encounters must use only the first-edition roster.")
	var original := UnlockManager.unlocked.duplicate(true)
	UnlockManager.unlocked.append("microceratus")
	_check(not UnlockManager.is_unlocked("microceratus") and "microceratus" not in UnlockManager.get_unlocked_species(), "Future database species must stay outside the first-edition playable roster, even in an older unlock file.")
	UnlockManager.unlocked = original
	for species in COMPANIONS.SPECIES:
		_start(species)
		GameState.companion_event_count = 4
		GameState.seasons_elapsed += 2
		var event := COMPANIONS.next_event()
		_check(GameState.companion_event.get("kind") == "shelter" and event["flavor"].contains("rest"), "Every current companion species must receive its authored fourth encounter.")
		var name: String = GameState.companion_event["name"]
		GameState.save_run()
		GameState.start_run("trex")
		_check(GameState.load_run() and COMPANIONS.pending_event() == event, "A pending shelter encounter must survive actual save/resume with the same identity.")
		GameState.hunger = 0.02
		var retry := ActionResolver.resolve("companions", "share_shelter")
		_check(retry.get("resolve_key") == "companions" and GameState.hunger == 0.02, "Shelter costs must be rechecked and a free choice must remain at low food.")
		GameState.hunger = 0.8
		var member: Dictionary = COMPANIONS._find(name)
		var trust: float = member["trust"]
		var before_protections: int = UnlockManager.run_achievements(UnlockManager.live_record())["protections"]
		var result := ActionResolver.resolve("companions", "share_shelter")
		_check(is_equal_approx(GameState.hunger, 0.74) and is_equal_approx(float(member["trust"]) - trust, 0.3) and result["flavor"].contains(name), "Paid shelter must cost six percent food and build real named trust.")
		_check(UnlockManager.run_achievements(UnlockManager.live_record())["protections"] == before_protections, "Shelter memories must not manufacture protection credit for existing unlock routes.")
		var food := GameState.hunger
		ActionResolver.resolve("companions", "share_shelter")
		_check(GameState.hunger == food and COMPANIONS.next_event().is_empty(), "Repeated shelter accepts must not spend food again or bypass event cadence.")
		GameState.seasons_elapsed += 2
		GameState.companion_event = {"kind": "shelter", "name": name}
		trust = member["trust"]
		ActionResolver.resolve("companions", "guide_shelter")
		_check(GameState.hunger == food and is_equal_approx(float(member["trust"]) - trust, 0.1), "The free shelter guidance must build less trust without spending food.")
		GameState.seasons_elapsed += 2
		GameState.companion_event = {"kind": "shelter", "name": name}
		trust = member["trust"]
		ActionResolver.resolve("companions", "keep_shelter")
		_check(is_equal_approx(trust - float(member["trust"]), 0.3), "Keeping the best shelter must have a real relationship consequence.")
	_start("lesothosaurus")
	JOURNEYS.next_event()
	JOURNEYS.resolve("leave")
	GameState.companion_last_event_season = GameState.seasons_elapsed
	var events: Array = []
	var capture := func(event: Dictionary): events.append(event)
	TurnManager.event_fired.connect(capture)
	TurnManager.start_turn()
	TurnManager.event_fired.disconnect(capture)
	_check(not events.is_empty() and events[-1].get("resolve_key") == "discovery", "Discoveries must remain reachable through the real turn loop between companion events.")
	GameState.save_run()
	var file := FileAccess.open(GameState.SAVE_PATH, FileAccess.READ)
	var unsupported: Dictionary = JSON.parse_string(file.get_as_text())
	file.close()
	unsupported["species_id"] = "microceratus"
	file = FileAccess.open(GameState.SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(unsupported))
	file.close()
	_check(not GameState.load_run(), "Survival must reject a future-species save instead of starting an eleventh first-edition dinosaur.")


func _capture(name: String) -> void:
	if "--capture-memorial" in OS.get_cmdline_user_args():
		await RenderingServer.frame_post_draw
		harness.root.get_texture().get_image().save_png("res://.godot/expansion_%s.png" % name)


func _check_hatchling_cost_labels() -> void:
	for species in UnlockManager.PLAYABLE_SPECIES:
		_start(species)
		var events: Array = TurnManager._load_hatchling_data()
		for event in events:
			for choice in event["choices"]:
				if choice["action"] not in ["feed_heavy", "feed_steady", "feed_light"]: continue
				GameState.hunger = 0.8
				GameState.active_hatchling_outcomes = event["outcomes"].duplicate(true)
				ActionResolver.resolve("hatchling_event", choice["action"])
				var cost := roundi((0.8 - GameState.hunger) * 100)
				_check(choice["sublabel"] == "Food −%d%%" % cost, "Every hatchling choice must display its real food cost as a percentage: " + species + " " + choice["action"])


func _check_action_cards() -> void:
	var old_plugin: Object = AdManager._rewarded_plugin
	var old_loaded: bool = AdManager._is_rewarded_loaded
	var old_showing: bool = AdManager._showing_rewarded
	var old_interstitial: bool = AdManager._showing_interstitial
	var old_enabled := SettingsManager.reward_videos_enabled
	var mock := Node.new()
	harness.root.add_child(mock)
	AdManager._rewarded_plugin = mock
	AdManager._is_rewarded_loaded = true
	AdManager._showing_rewarded = false
	AdManager._showing_interstitial = false
	SettingsManager.reward_videos_enabled = true
	for species in ["velociraptor", "iguanodon"]:
		_start(species)
		GameState.injuries = [{"name": "Bruise", "turns_remaining": 3}]
		GameState.action_uses["sharpen"] = 1
		var game = load("res://scenes/game/game_screen.tscn").instantiate()
		harness.root.add_child(game)
		await harness.get_tree().process_frame
		await harness.get_tree().process_frame
		game.event_overlay.hide()
		game._waiting_for_choice = false
		game._refresh_cards()
		await harness.get_tree().process_frame
		var rewards: Array = []
		for card in game.cards_container.get_children():
			var is_ad: bool = card.action_id.begins_with("ad_")
			_check(card.action_icon.texture != null, "Every action and reward must have a bundled image symbol.")
			_check(card.reward_label.visible == is_ad and card.video.visible == is_ad and card.arrow.visible != is_ad, "Only reward ads must display an explicit ad label and video marker.")
			if is_ad:
				rewards.append(card)
				_check(card.visible and card.accessibility_name.begins_with("Optional reward ad."), "Ready rewards must also identify the ad to assistive technology.")
			elif card.action_id == "scavenge":
				_check(card.action_icon.texture.resource_path.ends_with("leaf.svg" if species == "iguanodon" else "bone.svg"), "Foraging and scavenging must use the appropriate food symbol.")
			elif card.action_id == "sharpen" and species == "iguanodon":
				_check(card.action_icon.texture.resource_path.ends_with("shield.svg"), "Herbivore defense training must use a shield symbol.")
		var scroll: ScrollContainer = game.get_node("ActionScroll")
		scroll.ensure_control_visible(game.cards_container.get_child(0))
		await harness.get_tree().process_frame
		await _capture(species + "_action_icons")
		scroll.ensure_control_visible(rewards[0])
		await harness.get_tree().process_frame
		await _capture(species + "_reward_ad")
		var original_scale: Vector2i = harness.root.content_scale_size
		for width in [390, 320]:
			harness.root.content_scale_size = Vector2i(width, 844)
			harness.root.size = Vector2i(width, 844)
			await harness.get_tree().process_frame
			await harness.get_tree().process_frame
			for card in game.cards_container.get_children():
				if not card.visible: continue
				_check(card.size.x <= scroll.size.x and card.subtitle_label.get_global_rect().end.y <= card.get_global_rect().end.y - 4, "Action descriptions and ad labels must fit inside their cards at phone widths: %s at %d." % [card.action_id, width])
				_check(card.title_label.get_global_rect().end.x <= card.get_global_rect().end.x - 24, "Action titles must leave room for the arrow or video symbol.")
			if width == 320:
				scroll.ensure_control_visible(rewards[3])
				await harness.get_tree().process_frame
				await _capture(species + "_reward_small")
		harness.root.content_scale_size = original_scale
		harness.root.size = Vector2i(390, 844)
		SettingsManager.reward_videos_enabled = false
		game._refresh_cards()
		_check(rewards.all(func(card): return not card.visible), "Disabling optional reward videos must still hide every reward card.")
		SettingsManager.reward_videos_enabled = true
		AdManager._is_rewarded_loaded = false
		game._refresh_cards()
		_check(rewards.all(func(card): return not card.visible), "Unavailable reward ads must not be displayed as ordinary actions.")
		AdManager._is_rewarded_loaded = true
		game.queue_free()
		await harness.get_tree().process_frame
	AdManager._rewarded_plugin = old_plugin
	AdManager._is_rewarded_loaded = old_loaded
	AdManager._showing_rewarded = old_showing
	AdManager._showing_interstitial = old_interstitial
	SettingsManager.reward_videos_enabled = old_enabled
	mock.queue_free()
	await harness.get_tree().process_frame


func _check_ui() -> void:
	for species in ["argentinosaurus", "velociraptor"]:
		_start(species)
		if species == "velociraptor": WORLD.begin("rivals")
		JOURNEYS.next_event()
		var game = load("res://scenes/game/game_screen.tscn").instantiate()
		harness.root.add_child(game)
		await harness.get_tree().process_frame
		await harness.get_tree().process_frame
		game.event_overlay._on_choice("leave")
		await harness.get_tree().create_timer(0.25).timeout
		await harness.check_choice_layout(game.event_overlay)
		await _capture(species + "_story")
		game.queue_free()
		await harness.get_tree().process_frame
	_start("lesothosaurus")
	DISCOVERIES.next_event()
	var game = load("res://scenes/game/game_screen.tscn").instantiate()
	harness.root.add_child(game)
	await harness.get_tree().process_frame
	await harness.get_tree().process_frame
	_check(game._waiting_for_choice and game._action_context == "discovery", "The actual game screen must restore a pending discovery as a resolvable choice.")
	game.event_overlay._on_choice("leave")
	await harness.get_tree().create_timer(0.25).timeout
	await _capture("discovery_recall")
	game.event_overlay._on_choice("leave")
	await harness.get_tree().process_frame
	GameState.companion_event = {"kind": "shelter", "name": COMPANIONS.current_cast()[1]["name"]}
	game._on_event_ready(COMPANIONS.pending_event())
	game.event_overlay._on_choice("guide_shelter")
	await harness.get_tree().create_timer(0.25).timeout
	await _capture("shelter")
	await harness.check_choice_layout(game.event_overlay)
	game.queue_free()
	await harness.get_tree().process_frame
	var selection = load("res://scenes/ui/character_select.tscn").instantiate()
	harness.root.add_child(selection)
	for tree in ["herbivore", "carnivore"]:
		selection._current_tree = tree
		_check(selection._current_chain().size() == 5, "Both selection tabs must contain exactly five first-edition dinosaurs.")
		for index in 5:
			selection._current_index = index
			selection._refresh()
			_check(selection.dino_image.texture != null and selection._current_species_id() in UnlockManager.PLAYABLE_SPECIES, "Every first-edition dinosaur must retain selection art.")
	await _capture("roster")
	selection.queue_free()
	await harness.get_tree().process_frame
	var menu = load("res://scenes/ui/main_menu.tscn").instantiate()
	harness.root.add_child(menu)
	await harness.get_tree().process_frame
	await harness.get_tree().process_frame
	for button in [menu.new_game_btn, menu._story_btn, menu.continue_btn, menu.settings_btn, menu.store_btn, menu.discoveries_btn, menu._lineage_btn]:
		if not button.visible:
			continue
		_check(button.size.y >= 44 and button.get_global_rect().end.y < 724, "All menu controls must fit on the page with usable touch heights.")
	await _capture("menu")
	menu.discoveries_btn.pressed.emit()
	await harness.get_tree().process_frame
	var page = menu.get_child(menu.get_child_count() - 1)
	_check(page.grid.get_child_count() == 10 and page.progress_label.text == "3 / 3 discoveries found", "The visual collection must show all ten dinosaurs and actual saved discovery progress immediately.")
	page.close_button.pressed.emit()
	await harness.get_tree().process_frame
	var file := FileAccess.open(DISCOVERIES.SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify({"giant_trail": {"source": "lesothosaurus"}}))
	file.close()
	menu.discoveries_btn.pressed.emit()
	await harness.get_tree().process_frame
	await harness.get_tree().process_frame
	page = menu.get_child(menu.get_child_count() - 1)
	_check(page.progress_label.text == "1 / 3 discoveries found", "Reopening the collection must read the current profile rather than cache old progress.")
	_check(page.scroll.get_v_scroll_bar().max_value > page.scroll.get_v_scroll_bar().page, "All ten photo cards must be reachable by vertical scrolling.")
	for card in page.grid.get_children():
		_check(card.get_meta("species_id") in UnlockManager.PLAYABLE_SPECIES and card.get_node("Margin/Content/Photo").texture != null, "Every collection card must have real first-edition dinosaur artwork.")
		_check(card.get_node("Margin/Content/Discovery").visible_characters == -1, "Discovery card text must appear fully without typewriter reveal.")
		_check(card.size.x <= 175 and card.get_global_rect().end.x <= 370, "The dinosaur grid must fit at phone width without horizontal overflow.")
	await _capture("discoveries_grid")
	page.grid.get_child(0).pressed.emit()
	await harness.get_tree().process_frame
	await harness.get_tree().process_frame
	var entry = page.details.get_child(0)
	_check(page.selected_species == "compsognathus" and page.details.visible and not page.grid.visible, "A photo-card tap must open the selected dinosaur's discoveries.")
	_check(entry.get_meta("discovery_id") == "giant_trail" and entry.get_node("Content/Text/Status").text == "Found by Lesothosaurus", "Cards must distinguish the actual discoverer from a dinosaur that can recall shared knowledge.")
	_check(entry.get_node("Content/Text/Use").text.contains("Can recall"), "Previously learned discoveries must describe the selected species' real recall eligibility.")
	_check(page.details.get_child(1).get_node("Content/Text/Status").text == "Undiscovered", "The detail cards must retain honest undiscovered states.")
	await _capture("discoveries_details")
	page.all_button.pressed.emit()
	await harness.get_tree().process_frame
	_check(page.grid.visible and not page.details.visible and page.scroll.scroll_vertical == 0, "All dinosaurs must return to the photo grid and reset scrolling.")
	page._show_species("triceratops")
	await harness.get_tree().process_frame
	_check(page.details.get_child(0).get_node("Content/Text/Use").text.contains("Can recall"), "A species without a first discovery must still show genuine shared knowledge.")
	page.close_button.pressed.emit()
	await harness.get_tree().process_frame
	_check(DISCOVERIES.records() == {"giant_trail": {"source": "lesothosaurus"}}, "Browsing and closing the page must never grant discoveries or modify the profile.")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(DISCOVERIES.SAVE_PATH))
	menu.discoveries_btn.pressed.emit()
	await harness.get_tree().process_frame
	await harness.get_tree().process_frame
	page = menu.get_child(menu.get_child_count() - 1)
	_check(page.progress_label.text == "0 / 3 discoveries found", "A fresh profile must show an empty collection with discoverable dinosaur cards.")
	await _capture("discoveries_empty")
	var original_scale: Vector2i = harness.root.content_scale_size
	harness.root.content_scale_size = Vector2i(320, 568)
	harness.root.size = Vector2i(320, 568)
	await harness.get_tree().process_frame
	await harness.get_tree().process_frame
	_check(page.close_button.get_global_rect().end.x <= 300 and page.close_button.size.y >= 44, "Closing the collection must remain accessible on a smaller phone.")
	for card in page.grid.get_children():
		_check(card.get_global_rect().end.x <= 300 and card.size.x > 100, "The photo grid must adapt to a smaller phone without horizontal clipping.")
	await _capture("discoveries_small")
	page.close_button.pressed.emit()
	menu.queue_free()
	await harness.get_tree().process_frame
	harness.root.content_scale_size = original_scale
	harness.root.size = Vector2i(390, 844)
