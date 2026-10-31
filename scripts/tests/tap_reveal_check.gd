extends RefCounted

var harness: Node


func run(check_harness: Node) -> void:
	harness = check_harness
	await _check_events()
	await _check_instant_information()
	await _check_story()
	await _check_presentation()
	print("Tap reveal checked: full and compact events, narrative/image/background/choices, mouse and touch, first-tap safety, normal second choices, Story Mode and name entry.")


func _click(point: Vector2, touch: bool = false, button: int = MOUSE_BUTTON_LEFT) -> void:
	if touch:
		var press := InputEventScreenTouch.new()
		press.position = point
		press.pressed = true
		Input.parse_input_event(press)
		Input.flush_buffered_events()
		var release := InputEventScreenTouch.new()
		release.position = point
		Input.parse_input_event(release)
		Input.flush_buffered_events()
	else:
		var motion := InputEventMouseMotion.new()
		motion.position = point
		Input.parse_input_event(motion)
		Input.flush_buffered_events()
		var press := InputEventMouseButton.new()
		press.position = point
		press.button_index = button
		press.button_mask = MOUSE_BUTTON_MASK_LEFT if button == MOUSE_BUTTON_LEFT else 0
		press.pressed = true
		harness.root.push_input(press, true)
		var release: InputEventMouseButton = press.duplicate()
		release.pressed = false
		release.button_mask = 0
		harness.root.push_input(release, true)


func _check_events() -> void:
	var overlay = load("res://scenes/ui/event_overlay.tscn").instantiate()
	harness.root.add_child(overlay)
	var choices: Array[String] = []
	overlay.choice_made.connect(func(action: String): choices.append(action))
	for compact in [false, true]:
		var event := {"title": "" if compact else "Fresh Tracks", "type": "result" if compact else "season_event", "flavor": "A quiet moment gives you time to recover your strength." if compact else "Take your time to read the trail. ".repeat(40), "choices": [{"label": "Continue", "action": "ok"}]}
		for area in ["background", "title", "text", "choice"]:
			for touch in [false, true]:
				overlay.show_event(event)
				await harness.get_tree().create_timer(0.3).timeout
				var point := Vector2(10, 100)
				if area == "title": point = overlay._top_vbox.get_global_rect().position + Vector2(20, 5)
				elif area == "text": point = overlay._flavor_scroll.get_global_rect().get_center()
				elif area == "choice": point = overlay._choices_grid.get_child(-1).get_global_rect().get_center()
				var previous := choices.size()
				_click(point, touch)
				harness._check(overlay._flavor_label.visible_characters == -1 and overlay.visible and choices.size() == previous, "The first tap anywhere must reveal the event without making a choice: %s, compact=%s, touch=%s." % [area, compact, touch])
				_click(overlay._choices_grid.get_child(-1).get_global_rect().get_center(), touch)
				harness._check(not overlay.visible and choices.size() == previous + 1, "A separate second tap on Continue must accept the revealed event exactly once.")
	# Wheels and secondary mouse buttons are not reveal taps.
	overlay.show_event({"title": "Read", "flavor": "More words. ".repeat(100)})
	await harness.get_tree().process_frame
	_click(Vector2(20, 100), false, MOUSE_BUTTON_RIGHT)
	_click(Vector2(20, 100), false, MOUSE_BUTTON_WHEEL_DOWN)
	harness._check(overlay._tw_idx < overlay._tw_full.length(), "A secondary mouse button must not reveal narrative text.")
	overlay.queue_free()
	await harness.get_tree().process_frame


func _check_instant_information() -> void:
	var overlay = load("res://scenes/ui/event_overlay.tscn").instantiate()
	harness.root.add_child(overlay)
	var accepted: Array = []
	overlay.choice_made.connect(func(action: String): accepted.append(action))
	for title in ["Weather & seasonal effects", "Health", "Unlock paths", "Kills"]:
		overlay.show_event({"type": "info", "title": title, "flavor": "These numbers are ready to read. ".repeat(5), "choices": [{"label": "Close", "action": "close"}]})
		await harness.get_tree().process_frame
		await harness.get_tree().process_frame
		harness._check(overlay._tw_idx == overlay._tw_full.length() and overlay._flavor_label.visible_characters == -1, "Metric and reference popups must show their full text immediately.")
		var count := accepted.size()
		_click(overlay._choices_grid.get_child(-1).get_global_rect().get_center())
		harness._check(not overlay.visible and accepted.size() == count + 1, "Instant information must close on the first actual button tap.")
	overlay.show_event({"type": "info", "flavor": "Choose how you will train. ".repeat(8), "choices": [{"label": "Train strength", "action": "strength"}]})
	harness._check(overlay._tw_idx < overlay._tw_full.length(), "Information-shaped events with a real gameplay decision must retain narration typing.")
	overlay.show_event({"type": "living_event", "flavor": "The forest stirs around you. ".repeat(8), "choices": []})
	harness._check(overlay._tw_idx < overlay._tw_full.length(), "Narration must keep its reveal even without decision buttons.")
	overlay.queue_free()
	await harness.get_tree().process_frame


func _check_story() -> void:
	StoryState.reset()

	StoryState.current_scene_id = "s1_morning"
	var screen = load("res://scenes/story/story_screen.tscn").instantiate()
	harness.root.add_child(screen)
	await harness.get_tree().process_frame
	await harness.get_tree().process_frame
	for touch in [false, true]:
		for area in ["image", "text", "choice"]:
			StoryState.flint_trust = 0
			screen._show_scene("s1_morning")
			await harness.get_tree().process_frame
			await harness.get_tree().process_frame
			var point: Vector2 = screen._image_rect.get_global_rect().get_center()
			if area == "text": point = screen._text_scroll.get_global_rect().get_center()
			elif area == "choice": point = screen._choice_vbox.get_child(-1).get_global_rect().get_center()
			var state: Dictionary = screen._snapshot_state()
			_click(point, touch)
			harness._check(not screen._typewriter_active and screen._body_label.visible_characters == -1 and screen._snapshot_state() == state and not screen._in_result, "Story taps must reveal text without changing the scene or applying a choice: %s, touch=%s." % [area, touch])
			var trust: int = StoryState.flint_trust
			_click(screen._choice_vbox.get_child(0).get_global_rect().get_center(), touch)
			await harness.get_tree().process_frame
			await harness.get_tree().process_frame
			harness._check(screen._in_result and StoryState.flint_trust == trust + 1, "A separate Story choice tap must apply its actual effect exactly once.")
			_click(screen._text_scroll.get_global_rect().get_center(), touch)
			harness._check(not screen._typewriter_active and screen._in_result and StoryState.current_scene_id == "s1_morning", "A result-text tap must reveal the result without advancing.")
			_click(screen._choice_vbox.get_child(-1).get_global_rect().get_center(), touch)
			await harness.get_tree().process_frame
			await harness.get_tree().process_frame
			harness._check(StoryState.current_scene_id == "s2_mother", "A separate Continue tap must advance the revealed Story result.")
	screen._show_scene("s1_morning")
	await harness.get_tree().process_frame
	screen._settings_panel.show()
	_click(Vector2(10, 100))
	harness._check(screen._typewriter_active, "Taps in Settings must not reveal the hidden story behind that panel.")
	screen._settings_panel.hide()
	# Name controls appear after revealing the introduction, without submitting it.
	screen._show_scene("s_start")
	await harness.get_tree().process_frame
	_click(Vector2(10, 100), true)
	harness._check(screen._name_entry.visible and screen._begin_btn.visible and StoryState.current_scene_id == "s_start", "An introduction tap must reveal name entry without beginning the story.")
	screen.queue_free()
	await harness.get_tree().process_frame
	StoryState.reset()



func _capture(name: String) -> void:
	if "--capture-memorial" in OS.get_cmdline_user_args():
		await RenderingServer.frame_post_draw
		harness.root.get_texture().get_image().save_png("res://.godot/narrative_%s.png" % name)


func _swipe(point: Vector2) -> void:
	var press := InputEventScreenTouch.new()
	press.position = point
	press.pressed = true
	Input.parse_input_event(press)
	Input.flush_buffered_events()
	var drag := InputEventScreenDrag.new()
	drag.position = point + Vector2(0, -65)
	drag.relative = Vector2(0, -65)
	Input.parse_input_event(drag)
	Input.flush_buffered_events()
	var release := InputEventScreenTouch.new()
	release.position = drag.position
	Input.parse_input_event(release)
	Input.flush_buffered_events()


func _check_presentation() -> void:
	var was_emulating := Input.is_emulating_touch_from_mouse()
	Input.set_emulate_touch_from_mouse(true)
	harness._check(DisplayServer.is_touchscreen_available(), "Styled scroll checks require touchscreen emulation.")
	var overlay = load("res://scenes/ui/event_overlay.tscn").instantiate()
	harness.root.add_child(overlay)
	var accepted: Array[String] = []
	overlay.choice_made.connect(func(action: String): accepted.append(action))
	var scene_choices: Array = []
	for i in 6:
		scene_choices.append({"label": "Take the sheltered route" if i == 0 else "Choose another approach", "sublabel": "Keep your companions close", "action": str(i)})
	var old_scale: Vector2i = harness.root.content_scale_size
	for viewport_size in [Vector2i(390, 844), Vector2i(320, 568)]:
		harness.root.content_scale_size = viewport_size
		harness.root.size = viewport_size
		for image in [false, true]:
			overlay.show_event({"id": "fresh_tracks" if image else "", "title": "A trail through the valley", "flavor": "You pause beside the water. A sheltered path winds between the roots, where your companions can rest.\n\nThe open crossing is quicker, but leaves you exposed to the changing weather. ".repeat(3), "choices": scene_choices})
			await harness.get_tree().create_timer(0.3).timeout
			overlay._finish_typewriter()
			var top: Control = overlay.get_node("PopupPanel/TopSection")
			harness._check(top.get_global_rect().end.y <= overlay._bottom_section.get_global_rect().position.y, "Styled narrative cards must end above the choice area at both phone sizes.")
			harness._check(overlay._flavor_label.size.x <= overlay._flavor_scroll.size.x and overlay._flavor_scroll.size.y >= 80, "Styled text must retain a readable scroll area without horizontal clipping.")
			var choices_scroll: ScrollContainer = overlay._choices_grid.get_parent()
			harness._check(choices_scroll.get_global_rect().end.y <= viewport_size.y - overlay._safe_bottom, "Dense choices must stay in their own scrolling area above the phone safe area.")
			harness._check(choices_scroll.scroll_vertical == 0, "Every new event must start at its first choice.")
			_swipe(overlay._choices_grid.get_child(0).get_global_rect().get_center())
			harness._check(choices_scroll.scroll_vertical > 0 and accepted.is_empty() and overlay.visible, "Swiping a styled choice must scroll the options without accepting an action.")
			choices_scroll.ensure_control_visible(overlay._choices_grid.get_child(-1))
			await harness.get_tree().process_frame
			harness._check(overlay._choices_grid.get_child(-1).get_global_rect().end.y <= choices_scroll.get_global_rect().end.y + 1, "The last choice must remain reachable in the styled choice area.")
			choices_scroll.scroll_vertical = 0
			await _capture("%s_%d" % ["illustrated" if image else "choices", viewport_size.x])
	harness.root.content_scale_size = old_scale
	harness.root.size = Vector2i(390, 844)
	overlay.queue_free()
	await harness.get_tree().process_frame
	StoryState.reset()
	StoryState.current_scene_id = "s1_morning"
	var screen = load("res://scenes/story/story_screen.tscn").instantiate()
	harness.root.add_child(screen)
	await harness.get_tree().process_frame
	await harness.get_tree().process_frame
	for viewport_size in [Vector2i(390, 844), Vector2i(320, 568)]:
		harness.root.content_scale_size = viewport_size
		harness.root.size = viewport_size
		screen._show_scene("s1_morning")
		await harness.get_tree().process_frame
		await harness.get_tree().process_frame
		screen._finish_typewriter()
		harness._check(screen._bg.size.x == viewport_size.x and screen._text_scroll.size.x >= viewport_size.x - 40 and screen._text_scroll.size.y >= 170, "The actual Story scene must fill each phone width with a readable text card.")
		harness._check(screen._choice_vbox.get_global_rect().end.y <= viewport_size.y - 20, "Story choices must stay above the bottom safe area.")
		_swipe(screen._text_scroll.get_global_rect().get_center())
		harness._check(screen._text_scroll.scroll_vertical > 0 and not screen._in_result, "Swiping the styled Story text card must scroll the narrative without making a choice.")
		screen._text_scroll.scroll_vertical = 0
		await _capture("story" if viewport_size.x == 390 else "story_320")
		screen._show_result("The trail opens into a quiet grove. Your companions settle beside you, and the forest feels a little less unfamiliar.", "", "s2_mother")
		await harness.get_tree().process_frame
		await harness.get_tree().process_frame
		screen._finish_typewriter()
		await _capture("story_result" if viewport_size.x == 390 else "story_result_320")
	harness.root.content_scale_size = old_scale
	harness.root.size = Vector2i(390, 844)
	screen.queue_free()
	await harness.get_tree().process_frame
	StoryState.reset()
	Input.set_emulate_touch_from_mouse(was_emulating)
