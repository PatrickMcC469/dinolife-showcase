extends Node

# Run Godot with APPDATA set to <project>/.godot/companion_bond_userdata and
# --headless --path . --scene res://scripts/tests/companion_bond_check.tscn.
const COMPANIONS = preload("res://scripts/systems/companions.gd")
var failures := 0


func _ready() -> void:
	_run.call_deferred()


func _check(ok: bool, message: String) -> void:
	if not ok:
		failures += 1
		push_error(message)


func _seed_for(low: float, high: float) -> int:
	for candidate in 1000:
		seed(candidate)
		var roll := randf()
		if roll >= low and roll < high:
			return candidate
	push_error("No deterministic bond outcome seed found.")
	return 0


func _bond(low: float = 0.0, high: float = 0.2) -> Dictionary:
	GameState.hunger = 0.8
	GameState.daily_luck = 0.0
	seed(_seed_for(low, high))
	return ActionResolver.resolve("bond", "")


func _run() -> void:
	if not OS.get_user_data_dir().replace("\\", "/").contains("/.godot/companion_bond_userdata/"):
		push_error("Run with isolated APPDATA under .godot/companion_bond_userdata.")
		get_tree().quit(2)
		return
	for species in COMPANIONS.SPECIES:
		GameState.start_run(species)
		GameState.life_stage = 3
		GameState.seasons_elapsed = 20
		GameState.pack_bond = 1.0
		COMPANIONS.ensure_cast()
		var cast := COMPANIONS.current_cast()
		for member in cast:
			member["trust"] = -0.5
		var result := _bond()
		_check(is_equal_approx(float(cast[1]["trust"]), -0.4), species + ": successful bonding at 100% must earn companion trust.")
		_check(result.get("feedback", {}).get("gains", []).has(str(cast[1]["name"]) + " trusts you more"), species + ": the result must show trust earned at the pack cap.")
		_check(is_equal_approx(GameState.pack_bond, 1.0) and is_equal_approx(GameState.hunger, 0.73), "Bond cap and food cost must be preserved.")
		_bond()
		_check(is_equal_approx(float(cast[1]["trust"]), -0.4), "Repeated calls in one season must not award more trust.")
		for season in 12:
			GameState.seasons_elapsed += 1
			# Exercise all three successful outcomes while the pack remains capped.
			_bond(0.2, 0.55) if season % 2 == 0 else _bond(0.55, 0.8)
		_check(COMPANIONS.relationship(cast[1]) == "Trusting", species + ": a distant companion must recover into a trusting supporter.")
		_check(str(cast[1]["name"]) in COMPANIONS.supporters(), "Recovered trust must enable actual companion support.")
		var saved_trust: float = cast[1]["trust"]
		GameState.save_run()
		GameState.companions.clear()
		_check(GameState.load_run(), "The updated run must reload.")
		cast = COMPANIONS.current_cast()
		_check(is_equal_approx(float(cast[1]["trust"]), saved_trust) and COMPANIONS.relationship(cast[1]) == "Trusting", "Save/load must preserve trust and its relationship.")
		_bond()
		_check(is_equal_approx(float(cast[1]["trust"]), saved_trust), "Reload must not reset the once-per-season trust credit.")
		GameState.seasons_elapsed += 1
		_bond(0.8, 0.95)
		_check(is_equal_approx(float(cast[1]["trust"]), saved_trust), "A misread bond attempt must not grant trust.")
		_bond(0.95, 1.0)
		_check(is_equal_approx(float(cast[1]["trust"]), saved_trust - 0.1), "A friction outcome must strain companion trust.")
		for member in cast:
			member["trust"] = 0.7
		var refused := ActionResolver.resolve("pack_hunger", "keep_food")
		_check(COMPANIONS.relationship(cast[1]) == "Wary" and is_equal_approx(float(cast[1]["trust"]), 0.3), species + ": refusing food to hungry group members must change Trusting to Wary.")
		_check(refused.get("feedback", {}).get("costs", []).has(str(cast[1]["name"]) + " trusts you less"), "Group choices must report personal trust lost.")
		GameState.pack_bond = 1.0
		ActionResolver.resolve("pack_hunger", "share_food")
		_check(is_equal_approx(float(cast[1]["trust"]), 0.7), "Sharing food must rebuild trust even at maximum bond.")
		ActionResolver.resolve("pack_split_winter", "split_from_pack")
		_check(COMPANIONS.relationship(cast[1]) == "Wary", "Leaving the others to face winter must strain personal trust.")
		cast[0]["active"] = false
		_bond()
		_check(not cast[0]["active"] and COMPANIONS.relationship(cast[0]) == "Gone", "Bonding must not resurrect departed companions.")
	# Old saves without a cast must still earn trust on the first bond action.
	GameState.companions = []
	GameState.seasons_elapsed += 1
	GameState.pack_bond = 0.5
	_bond()
	_check(GameState.companions.size() >= 3 and GameState.companions.size() <= COMPANIONS.max_companions() and is_equal_approx(float(GameState.companions[1]["trust"]), 0.1), "Runs without a cast must initialize a bounded roster before awarding trust.")
	GameState.pack_bond = 0.0
	_bond()
	_check(COMPANIONS.supporters().is_empty() and not GameState.companions[1]["active"] and is_equal_approx(GameState.hunger, 0.8), "Solo runs must not earn companion trust or pay a bond cost.")
	ActionResolver.resolve("pack_hunger", "share_food")
	_check(is_zero_approx(GameState.pack_bond) and is_equal_approx(GameState.hunger, 0.8), "A stale food choice after disbanding must not revive a pack with departed names.")
	GameState.pack_bond = 1.0
	COMPANIONS.new_group()
	# Exercise the actual game action and card refresh, not only the resolver.
	GameState.companion_event = {}
	GameState.seasons_elapsed += 1
	GameState.pack_bond = 1.0
	COMPANIONS.current_cast()[1]["trust"] = 0.55
	var screen := preload("res://scenes/game/game_screen.tscn").instantiate()
	add_child(screen)
	await get_tree().process_frame
	seed(_seed_for(0.0, 0.2))
	GameState.daily_luck = 0.0
	GameState.hunger = 0.8
	screen._on_action_pressed("bond")
	var panel: PanelContainer = screen.companions_panel
	_check(panel.get_node("Content/Cards/Challenger/Content/Identity/Badge/State").text == "TRUSTING", "The actual action must immediately refresh the companion badge.")
	screen._dashboard._show_pack()
	_check(panel.get_node("Content/Cards/Challenger/Content/Extra/Reason").text == "You made time to strengthen the group.", "Details must show the latest trust reason.")
	_check(panel.get_node("Content/Cards/Challenger/Content/Extra/Support/Status").text == "Ready to stand with you", "Details must refresh supporter availability.")
	var steady: Dictionary = COMPANIONS.current_cast()[0]
	var challenger: Dictionary = COMPANIONS.current_cast()[1]
	steady["trust"] = 0.8
	panel.refresh()
	_check(panel.summary.text.contains("Includes you and %d companions" % COMPANIONS.active_cast().size()) and panel.summary.text.contains("2 ready to help"), "The summary must count present companions and willing supporters.")
	var trust_before: float = panel.get_node("Content/Cards/Challenger/Content/Trust/Meter").value
	GameState.companion_event = {"kind": "lead", "name": COMPANIONS.current_cast()[1]["name"], "season": GameState.seasons_elapsed}
	screen._action_context = "companions"
	screen._on_choice_made("force")
	_check(panel.get_node("Content/Cards/Challenger/Content/Identity/Badge/State").text == "WARY", "A negative companion choice must immediately downgrade the displayed badge.")
	_check(panel.get_node("Content/Cards/Challenger/Content/Extra/Reason").text.contains("forced"), "Open details must show why trust was lost.")
	_check(panel.get_node("Content/Cards/Challenger/Content/Extra/Support/Status").text == "Needs more trust to offer support", "Lost trust must immediately remove support availability.")
	_check(panel.get_node("Content/Cards/Challenger/Content/Trust/Meter").value < trust_before, "The visible trust meter must move when trust changes.")
	_check(is_equal_approx(float(steady["trust"]), 0.8) and panel.get_node("Content/Cards/Steady/Content/Identity/Badge/State").text == "TRUSTING", "An individual disagreement must preserve the other companion's independent relationship.")
	GameState.save_run()
	GameState.companions.clear()
	_check(GameState.load_run(), "Live relationship details must reload.")
	panel.refresh()
	_check(panel.get_node("Content/Cards/Challenger/Content/Identity/Name").text == challenger["name"] and panel.get_node("Content/Cards/Challenger/Content/Extra/Reason").text.contains("forced"), "Names and latest reactions must survive resuming the run.")
	GameState.companion_event = {"kind": "protect", "name": challenger["name"], "season": GameState.seasons_elapsed}
	screen._action_context = "companions"
	screen._on_choice_made("abandon")
	_check(panel.summary.text.contains("Includes you and %d companions" % COMPANIONS.active_cast().size()) and panel.summary.text.contains("1 departed"), "Departed companions must not be counted as present.")
	_check(panel.get_node("Content/Cards/Challenger/Content/Identity/Badge/State").text == "GONE" and not panel.get_node("Content/Cards/Challenger/Content/Trust").visible, "Departed companions must clearly leave the active relationship display.")
	PackManager.trigger_disband("The group broke apart.")
	_check(panel.heading.text.begins_with("FORMER ") and panel.summary.text.contains("You are traveling alone"), "When traveling alone, the panel must label the former group instead of claiming it is the current pack.")
	PackManager.join_group(0.5)
	panel.refresh()
	_check(panel.get_node("Content/Cards/Challenger/Content/Identity/Name").text == COMPANIONS.current_cast()[1]["name"] and COMPANIONS.current_cast()[1]["name"] != challenger["name"], "The panel must show the new group's actual names, not historical companions.")
	_check(panel.summary.text.contains("Includes you and %d companions" % COMPANIONS.active_cast().size()) and not panel.summary.text.contains("departed"), "A new group's count must exclude former members.")
	screen.queue_free()
	await get_tree().process_frame
	for player in SoundManager.get_children():
		if player is AudioStreamPlayer:
			player.stop()
	await get_tree().process_frame
	await get_tree().create_timer(0.1).timeout
	GameState.delete_save()
	print("COMPANION BOND CHECKS PASSED" if failures == 0 else "COMPANION BOND CHECKS FAILED: %d" % failures)
	get_tree().quit(0 if failures == 0 else 1)
