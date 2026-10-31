extends RefCounted

const DISCOVERIES = preload("res://scripts/systems/discoveries.gd")
var harness: Node


func run(check_harness: Node) -> void:
	harness = check_harness
	var old_motion := SettingsManager.interface_animations_enabled
	var old_scale: Vector2i = harness.root.content_scale_size
	var existed := FileAccess.file_exists(DISCOVERIES.SAVE_PATH)
	var profile := FileAccess.get_file_as_string(DISCOVERIES.SAVE_PATH) if existed else ""
	DirAccess.remove_absolute(ProjectSettings.globalize_path(DISCOVERIES.SAVE_PATH))
	SettingsManager.set_interface_animations_enabled(true)
	GameState.start_run("compsognathus")
	GameState.life_stage = 3
	GameState.seasons_elapsed = 18
	GameState.hunger = 0.8
	GameState.discovery_state["pending"] = "giant_trail"
	GameState.discovery_state["mode"] = "find"
	var result := ActionResolver.resolve("discovery", "observe")
	harness._check(result.get("reveal", {}).get("species") == "argentinosaurus" and is_equal_approx(GameState.hunger, 0.88), "An actual newly recorded discovery must carry its photo without changing its food reward.")
	var repeat := ActionResolver.resolve("discovery", "observe")
	harness._check(not repeat.has("reveal") and is_equal_approx(GameState.hunger, 0.88), "A repeated discovery must not show a fresh reveal or grant more food.")
	GameState.discovery_state["pending"] = "giant_trail"
	GameState.discovery_state["mode"] = "recall"
	GameState.discovery_state["handled"] = []
	GameState.species_id = "iguanodon"
	var recall := ActionResolver.resolve("discovery", "observe")
	harness._check(not recall.has("reveal"), "Using knowledge from an earlier life must not claim a newly recorded discovery.")
	for dimensions in [Vector2i(390, 844), Vector2i(320, 568)]:
		harness.root.content_scale_size = dimensions
		harness.root.size = dimensions
		await _check_popup(result, dimensions.x)
		await _check_settings(dimensions.x)
	harness.root.content_scale_size = old_scale
	harness.root.size = Vector2i(390, 844)
	await _check_press()
	if existed:
		var file := FileAccess.open(DISCOVERIES.SAVE_PATH, FileAccess.WRITE)
		file.store_string(profile)
		file.close()
	else:
		DirAccess.remove_absolute(ProjectSettings.globalize_path(DISCOVERIES.SAVE_PATH))
	SettingsManager.set_interface_animations_enabled(old_motion)
	GameState.delete_save()
	print("UI polish checked: real discovery awards and recall/replay safety, interrupted reveals, no-motion preference/save, small-phone scrolling, and unchanged native choice bounds.")


func _settle() -> void:
	await harness.get_tree().process_frame
	await harness.get_tree().process_frame


func _capture(name: String) -> void:
	if "--capture-memorial" in OS.get_cmdline_user_args():
		await RenderingServer.frame_post_draw
		harness.root.get_texture().get_image().save_png("res://.godot/ui_polish_%s.png" % name)


func _check_popup(result: Dictionary, width: int) -> void:
	SettingsManager.set_interface_animations_enabled(true)
	var overlay = load("res://scenes/ui/event_overlay.tscn").instantiate()
	harness.root.add_child(overlay)
	await _settle()
	overlay.show_event(result)
	var panel = overlay._result_feedback
	harness._check(panel.reveal_card.visible and panel.reveal_image.texture.resource_path.ends_with("argentinosaurus_selection.png"), "The result must show the discovered species' real bundled photo.")
	harness._check(panel.reveal_image.material.get_shader_parameter("progress") == 0.0, "A new discovery must begin its illustration reveal.")
	overlay._finish_typewriter()
	await harness.get_tree().create_timer(0.4).timeout
	harness._check(is_equal_approx(panel.reveal_image.material.get_shader_parameter("progress"), 1.0), "The illustration must finish revealing promptly.")
	harness._check(panel.reveal_card.size.x <= overlay._flavor_scroll.size.x, "The discovery card must fit inside the reading scroll area.")
	await _capture("discovery_%d" % width)
	panel.cue.stop()
	overlay.show_event(result)
	harness._check(not panel.cue.playing and panel.reveal_image.material.get_shader_parameter("progress") == 1.0, "Redisplaying a result must not replay its reveal or sound.")
	harness._check(is_equal_approx(GameState.hunger, 0.96), "Showing and redisplaying a discovery must not grant any additional food.")
	SettingsManager.set_interface_animations_enabled(false)
	var fresh := result.duplicate(true)
	fresh["feedback"]["serial"] += 100000 + width
	overlay.show_event(fresh)
	harness._check(overlay._popup_panel.modulate.a == 1.0 and overlay._popup_panel.offset_top == 0.0 and panel.reveal_image.material.get_shader_parameter("progress") == 1.0, "With interface animations off, the popup and discovery photo must be immediately readable.")
	overlay.show_event({"flavor": "A quiet moment."})
	harness._check(not panel.reveal_card.visible and not panel.visible, "Ordinary information must clear the previous discovery card.")
	overlay.queue_free()
	await _settle()


func _check_settings(width: int) -> void:
	SettingsManager.interface_animations_enabled = true
	SettingsManager.load_settings()
	harness._check(not SettingsManager.interface_animations_enabled, "The disabled interface-animation preference must survive reloading settings.")
	var settings = load("res://scenes/ui/settings_panel.tscn").instantiate()
	harness.root.add_child(settings)
	settings.open(true)
	await _settle()
	harness._check(not settings.animations_toggle.button_pressed and settings.animations_toggle.size.y >= 44, "The actual animation toggle must show the saved value with a usable touch height.")
	settings.animations_toggle.button_pressed = true
	harness._check(SettingsManager.interface_animations_enabled, "The settings toggle must change the live animation preference.")
	var scroll: ScrollContainer = settings.get_node("Card/Scroll")
	scroll.ensure_control_visible(settings.back_btn)
	await _settle()
	harness._check(scroll.get_global_rect().encloses(settings.back_btn.get_global_rect()) and harness.root.get_visible_rect().encloses(settings.card.get_global_rect()), "Settings and its Back button must remain reachable inside the short-phone viewport.")
	await _capture("settings_%d" % width)
	settings.queue_free()
	await _settle()
	SettingsManager.set_interface_animations_enabled(false)


func _check_press() -> void:
	SettingsManager.set_interface_animations_enabled(true)
	var card = load("res://scenes/ui/action_card.tscn").instantiate()
	harness.root.add_child(card)
	card.size = Vector2(300, 100)
	await _settle()
	var bounds: Rect2 = card.get_global_rect()
	var accepted: Array = []
	card.card_pressed.connect(func(action: String): accepted.append(action))
	card.button_down.emit()
	await harness.get_tree().create_timer(0.08).timeout
	harness._check(card.self_modulate != Color.WHITE and card.get_global_rect() == bounds and accepted.is_empty(), "Press motion must change only the tint, leaving touch bounds and action state unchanged.")
	card.button_up.emit()
	await harness.get_tree().create_timer(0.16).timeout
	harness._check(card.self_modulate == Color.WHITE, "A released or cancelled press must return to its normal appearance.")
	card.button_down.emit()
	SettingsManager.set_interface_animations_enabled(false)
	await harness.get_tree().create_timer(0.08).timeout
	harness._check(card.self_modulate == Color.WHITE, "Disabling animation during a press must cancel its old tween immediately.")
	SettingsManager.set_interface_animations_enabled(true)
	var scroll := ScrollContainer.new()
	var old_emulation := Input.is_emulating_touch_from_mouse()
	Input.set_emulate_touch_from_mouse(true)
	harness.root.add_child(scroll)
	scroll.position = Vector2(14, 120)
	scroll.size = Vector2(310, 260)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	var column := VBoxContainer.new()
	column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(column)
	card.reparent(column)
	var space := Control.new()
	space.custom_minimum_size.y = 800
	space.mouse_filter = Control.MOUSE_FILTER_IGNORE
	column.add_child(space)
	await _settle()
	var point: Vector2 = card.get_global_rect().get_center()
	var touch := InputEventScreenTouch.new()
	touch.position = point
	touch.pressed = true
	Input.parse_input_event(touch)
	Input.flush_buffered_events()
	var drag := InputEventScreenDrag.new()
	drag.position = point - Vector2(0, 80)
	drag.relative = Vector2(0, -80)
	Input.parse_input_event(drag)
	Input.flush_buffered_events()
	touch = touch.duplicate()
	touch.pressed = false
	touch.position = drag.position
	Input.parse_input_event(touch)
	Input.flush_buffered_events()
	await harness.get_tree().create_timer(0.2).timeout
	harness._check(scroll.scroll_vertical > 0 and accepted.is_empty() and card.self_modulate == Color.WHITE, "An actual swipe over an animated card must scroll, cancel its choice and clear its press tint.")
	scroll.scroll_vertical = 0
	await _settle()
	var input_driver := preload("res://scripts/tests/tap_reveal_check.gd").new()
	input_driver.harness = harness
	input_driver._click(card.get_global_rect().get_center(), true)
	harness._check(accepted.size() == 1, "A stationary touch must still accept the animated card exactly once.")
	Input.set_emulate_touch_from_mouse(old_emulation)
	SettingsManager.set_interface_animations_enabled(false)
	var bar = load("res://scenes/ui/stat_bar.tscn").instantiate()
	harness.root.add_child(bar)
	bar.set_value_normalized(0.8)
	bar.set_value_normalized(0.5)
	harness._check(is_equal_approx(bar.value, 0.5) and bar.modulate == Color.WHITE, "Disabling interface animation must leave real stat changes immediate without pulses.")
	scroll.queue_free()
	bar.queue_free()
	await _settle()
