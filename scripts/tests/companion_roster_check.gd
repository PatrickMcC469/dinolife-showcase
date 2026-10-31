extends Node

# Run with isolated APPDATA at <project>/.godot/companion_roster_userdata.
const COMPANIONS = preload("res://scripts/systems/companions.gd")
var failures := 0


func _ready() -> void:
	_run.call_deferred()


func _check(ok: bool, message: String) -> void:
	if not ok:
		failures += 1
		push_error(message)


func _setup(species: String) -> void:
	GameState.start_run(species)
	GameState.life_stage = 3
	GameState.seasons_elapsed = 20
	GameState.pack_bond = 0.8
	GameState.hunger = 1.0
	GameState.health = 1.0
	COMPANIONS.ensure_cast()


func _names(cast: Array) -> Array:
	return cast.map(func(member: Dictionary): return member["name"])


func _seed_for(low: float, high: float) -> int:
	for candidate in 1000:
		seed(candidate)
		var roll := randf()
		if roll >= low and roll < high:
			return candidate
	return 0


func _run() -> void:
	if not OS.get_user_data_dir().replace("\\", "/").contains("/.godot/companion_roster_userdata/"):
		push_error("Run with isolated APPDATA under .godot/companion_roster_userdata.")
		get_tree().quit(2)
		return
	seed(884)
	for species in COMPANIONS.SPECIES:
		_setup(species)
		var limit := COMPANIONS.max_companions()
		_check(limit == (4 if species in ["deinonychus", "velociraptor"] else 6), "Species limits must stay bounded: " + species)
		var sizes: Array = []
		for attempt in 15:
			PackManager.join_group(0.8)
			var count := COMPANIONS.active_cast().size()
			_check(count >= 3 and count <= limit, "New groups must have a varied, bounded full roster.")
			if count not in sizes:
				sizes.append(count)
		_check(sizes.size() > 1, "The starting roster must not always have the same size.")
		var intro := COMPANIONS.next_event()
		for name in _names(COMPANIONS.active_cast()):
			_check(intro.get("flavor", "").contains(name), "The introduction must name every actual member.")
		ActionResolver.resolve("companions", "welcome")
		for attempt in 30:
			COMPANIONS._add_member(preload("res://scripts/systems/life_story.gd")._new_name())
		_check(COMPANIONS.active_cast().size() == limit, "Repeated additions must never exceed the species cap.")
		var names := _names(COMPANIONS.active_cast())
		_check(names.all(func(name): return names.count(name) == 1), "Every roster member must have a distinct name.")
		GameState.pack_bond = 1.0
		_check(PackManager.get_virtual_group_size() == limit, "Full-bond combat must use the actual active roster.")
		var member: Dictionary = COMPANIONS.active_cast()[2]
		var member_name: String = member["name"]
		var original_trust: float = COMPANIONS.active_cast()[0]["trust"]
		member["trust"] = 0.7
		GameState.companion_event = {"kind": "lead", "name": member_name, "season": GameState.seasons_elapsed}
		ActionResolver.resolve("companions", "force")
		_check(COMPANIONS.relationship(member) == "Wary" and is_equal_approx(float(COMPANIONS.active_cast()[0]["trust"]), original_trust), "Additional roster members must have independent real relationships.")
		GameState.companion_event = {"kind": "join", "name": "Outside", "season": GameState.seasons_elapsed}
		var full := ActionResolver.resolve("companions", "accept_member")
		_check(full.get("next_context") == "companions" and COMPANIONS.active_cast().size() == limit, "A stale join choice at the cap must not add anyone.")
		ActionResolver.resolve("companions", "decline_member")
		GameState.companion_event = {"kind": "protect", "name": member_name, "season": GameState.seasons_elapsed}
		ActionResolver.resolve("companions", "abandon")
		_check(COMPANIONS.active_cast().size() == limit - 1 and COMPANIONS.relationship(member) == "Gone", "A real departure must reduce the roster and combat strength.")
		_check(PackManager.get_virtual_group_size() == limit - 1, "Combat must lose a departed member immediately.")
		GameState.companion_event_count = 5
		GameState.seasons_elapsed += 2
		var joining := COMPANIONS.next_event()
		var newcomer: String = GameState.companion_event.get("name", "")
		_check(joining.get("title") == "A new face on the trail" and newcomer not in names, "A vacancy must allow a new persistent, distinct member.")
		var group_id: int = GameState.companion_group_id
		GameState.save_run()
		GameState.companions.clear()
		GameState.companion_group_id = 0
		_check(GameState.load_run() and GameState.companion_group_id == group_id and GameState.companion_event.get("name") == newcomer, "Resume must preserve the current group and the waiting newcomer's identity.")
		ActionResolver.resolve("companions", "accept_member")
		_check(COMPANIONS.active_cast().size() == limit and newcomer in _names(COMPANIONS.active_cast()), "Accepting a newcomer must fill only the available place.")
		ActionResolver.resolve("companions", "accept_member")
		_check(COMPANIONS.active_cast().size() == limit, "A completed welcome must not add a duplicate.")
		_check(member_name not in _names(COMPANIONS.active_cast()), "A departed identity must not silently return.")
		# Cycle real encounters and confirm members beyond the original pair participate.
		var encountered: Array = []
		GameState.companion_event_count = 1
		for encounter in 36:
			GameState.seasons_elapsed += 2
			GameState.hunger = 1.0
			GameState.health = 1.0
			var event := COMPANIONS.next_event()
			_check(not event.is_empty(), "Full rosters must keep producing playable encounters.")
			var target: String = GameState.companion_event.get("name", "")
			if target not in encountered:
				encountered.append(target)
			ActionResolver.resolve("companions", event["choices"][0]["action"])
		_check(encountered.size() == limit, "Every present member must participate in recurring encounters.")
		var previous := _names(COMPANIONS.active_cast())
		var last_departure: Dictionary = {}
		for name in previous:
			GameState.companion_event = {"kind": "protect", "name": name, "season": GameState.seasons_elapsed}
			last_departure = ActionResolver.resolve("companions", "abandon")
		_check(is_zero_approx(GameState.pack_bond) and COMPANIONS.active_cast().is_empty() and COMPANIONS.supporters().is_empty(), "Losing the last member must make the player genuinely solo.")
		_check(last_departure.get("flavor", "").contains("traveling alone"), "The last departure's event must clearly describe the now-empty group.")
		PackManager.join_group(0.6)
		_check(_names(COMPANIONS.active_cast()).all(func(name): return name not in previous), "Joining another group must never use the old group's roster.")
	# Pre-roster saves: previous groups stay archived; the final pair stays familiar.
	_setup("velociraptor")
	GameState.companion_group_id = 0
	GameState.companions = [
		{"name": "Old", "role": "steady", "active": false, "trust": -0.6},
		{"name": "Past", "role": "challenger", "active": false, "trust": -0.8},
		{"name": "Fern", "role": "steady", "active": true, "trust": 0.8, "reason": "You shared food.", "bond_season": 20},
		{"name": "Ember", "role": "challenger", "active": false, "trust": -0.9, "reason": "You left them."}]
	GameState.companion_event = {"kind": "share", "name": "Fern", "season": 20}
	GameState.save_run()
	_check(GameState.load_run(), "A pre-roster save must still load.")
	COMPANIONS.ensure_cast()
	_check(_names(COMPANIONS.current_cast()) == ["Fern", "Ember"] and _names(COMPANIONS.active_cast()) == ["Fern"], "Legacy migration must preserve the final pair and each departure.")
	_check(is_equal_approx(float(COMPANIONS.current_cast()[0]["trust"]), 0.8) and COMPANIONS.pending_event()["flavor"].contains("Fern"), "Legacy trust and the pending choice must remain intact.")
	GameState.save_run()
	_check(GameState.load_run() and _names(COMPANIONS.active_cast()) == ["Fern"], "Migration must remain stable through another save/reload.")
	COMPANIONS.current_cast()[0]["active"] = false
	GameState.save_run()
	_check(GameState.load_run(), "An old run with all companions gone must load.")
	COMPANIONS.ensure_cast()
	_check(is_zero_approx(GameState.pack_bond) and COMPANIONS.active_cast().is_empty(), "A migrated empty group must become solo so finding a new group is available.")
	for species in ["trex", "allosaurus", "ankylosaurus"]:
		_setup(species)
		PackManager.join_group(0.9)
		COMPANIONS._add_member("Nobody")
		_check(not COMPANIONS.supported() and GameState.companions.is_empty() and COMPANIONS.next_event().is_empty() and PackManager.get_virtual_group_size() == 0, "Solitary dinosaurs must have no roster or phantom group bonus: " + species)
		var hidden_panel := preload("res://scenes/ui/companions_panel.tscn").instantiate()
		add_child(hidden_panel)
		_check(not hidden_panel.visible, "Solitary dinosaurs must not show the pack feature.")
		hidden_panel.queue_free()
	_setup("compsognathus")
	for attempt in 10:
		COMPANIONS._add_member("Helper %d" % attempt)
	for member in COMPANIONS.active_cast():
		member["trust"] = 1.0
	GameState.daily_luck = 0.0
	seed(_seed_for(0.65, 0.70))
	var challenge := PackManager.resolve_alpha_fight()
	_check(not challenge["won"], "Six supporters must preserve the two-companion leadership bonus ceiling.")
	_setup("compsognathus")
	for attempt in 10:
		COMPANIONS._add_member("Defender %d" % attempt)
	for member in COMPANIONS.active_cast():
		member["trust"] = 1.0
	GameState.daily_luck = 0.0
	seed(_seed_for(0.75, 0.80))
	var defense := PackManager.resolve_defender_fight()
	_check(not defense["won"], "Six defenders must not inflate the leadership defense bonus beyond its old ceiling.")
	_setup("argentinosaurus")
	for attempt in 20:
		COMPANIONS._add_member("Member %d" % attempt)
	for shared_meal in 3:
		GameState.hunger = 1.0
		ActionResolver.resolve("pack_hunger", "share_food")
	var screen := preload("res://scenes/game/game_screen.tscn").instantiate()
	add_child(screen)
	await get_tree().process_frame
	var panel: PanelContainer = screen.companions_panel
	screen._dashboard._show_pack()
	_check(panel.summary.text.contains("Herd size: 7 / 7") and panel.summary.text.contains("6 ready to help"), "The UI must show the actual total including the player and the full member cap.")
	var shown: Array = []
	for card in panel.cards.get_children():
		if card.visible:
			shown.append(card.get_node("Content/Identity/Name").text)
	_check(shown == _names(COMPANIONS.active_cast()), "The actual Details UI must display every current roster member exactly once.")
	if "--capture-roster" in OS.get_cmdline_user_args():
		await RenderingServer.frame_post_draw
		get_tree().root.get_texture().get_image().save_png("res://.godot/companion_roster_full.png")
		var scroll: ScrollContainer = panel.get_parent()
		scroll.ensure_control_visible(panel.cards.get_child(5))
		await get_tree().process_frame
		await RenderingServer.frame_post_draw
		get_tree().root.get_texture().get_image().save_png("res://.godot/companion_roster_last_member.png")
		get_tree().root.content_scale_size = Vector2i(320, 568)
		get_tree().root.size = Vector2i(320, 568)
		await get_tree().process_frame
		await get_tree().process_frame
		for card in panel.cards.get_children():
			_check(card.size.x <= scroll.size.x, "The maximum roster must fit a small phone.")
		scroll.scroll_vertical = 0
		await get_tree().process_frame
		await RenderingServer.frame_post_draw
		get_tree().root.get_texture().get_image().save_png("res://.godot/companion_roster_small.png")
	screen.queue_free()
	await get_tree().process_frame
	for player in SoundManager.get_children():
		if player is AudioStreamPlayer:
			player.stop()
	await get_tree().process_frame
	await get_tree().create_timer(0.1).timeout
	GameState.delete_save()
	print("COMPANION ROSTER CHECKS PASSED" if failures == 0 else "COMPANION ROSTER CHECKS FAILED: %d" % failures)
	get_tree().quit(0 if failures == 0 else 1)
