extends Node

var failures := 0


func _ready() -> void:
	_run.call_deferred()


func _check(ok: bool, message: String) -> void:
	if not ok:
		failures += 1
		push_error(message)


func _settle() -> void:
	await get_tree().process_frame
	await get_tree().process_frame


func _swipe(point: Vector2, distance: float = -70.0) -> void:
	var touch := InputEventScreenTouch.new()
	touch.position = point
	touch.pressed = true
	Input.parse_input_event(touch)
	Input.flush_buffered_events()
	var drag := InputEventScreenDrag.new()
	drag.position = point + Vector2(0, distance)
	drag.relative = Vector2(0, distance)
	Input.parse_input_event(drag)
	Input.flush_buffered_events()
	touch = touch.duplicate()
	touch.pressed = false
	touch.position = drag.position
	Input.parse_input_event(touch)
	Input.flush_buffered_events()


func _tap(control: Control) -> void:
	var click := InputEventMouseButton.new()
	click.position = control.get_global_rect().get_center()
	click.button_index = MOUSE_BUTTON_LEFT
	click.button_mask = MOUSE_BUTTON_MASK_LEFT
	click.pressed = true
	get_tree().root.push_input(click, true)
	click = click.duplicate()
	click.button_mask = 0
	click.pressed = false
	get_tree().root.push_input(click, true)


func _capture(name: String) -> void:
	if "--capture-memorial" in OS.get_cmdline_user_args():
		await RenderingServer.frame_post_draw
		_check(get_tree().root.get_texture().get_image().save_png("res://.godot/front_end_%s.png" % name) == OK, "Front-end preview must export.")


func _check_menu(dimensions: Vector2i) -> void:
	GameState.delete_save()
	var before_species: String = GameState.species_id
	var before_seasons: int = GameState.seasons_elapsed
	for save in [{}, {"species_id": "velociraptor", "life_stage": 2, "seasons_elapsed": 13}, {"species_id": "iguanodon", "life_stage": 3, "seasons_elapsed": 13}, {"species_id": "lesothosaurus"}, {"species_id": "future_dinosaur"}, {"species_id": "trex", "life_stage": "invalid"}]:
		if not save.is_empty():
			var file := FileAccess.open(GameState.SAVE_PATH, FileAccess.WRITE)
			file.store_string(JSON.stringify(save))
			file.close()
		var menu = preload("res://scenes/ui/main_menu.tscn").instantiate()
		add_child(menu)
		await _settle()
		var title: TextureRect = menu.get_node("LivingWildTitle")
		_check(menu.get_viewport_rect().encloses(title.get_global_rect()), "The full DinoLife title must fit the viewport when the menu opens.")
		var studio: Control = menu.get_node("StudioLogo")
		var menu_scroll: ScrollContainer = menu.get_node("PageMargin/PageScroll")
		_check(menu.get_viewport_rect().encloses(studio.get_global_rect()), "The complete studio footer must be visible when the menu opens, including short phones.")
		_check(menu_scroll.vertical_scroll_mode == ScrollContainer.SCROLL_MODE_DISABLED and not menu_scroll.get_v_scroll_bar().visible, "The main menu must have no scrolling or scrollbar.")
		_check(menu_scroll.get_global_rect().end.y <= studio.global_position.y - 4, "The fixed menu must reserve separate space for the studio footer.")
		var menu_body: VBoxContainer = menu_scroll.get_node("Body")
		_check(menu_body.get_combined_minimum_size().y <= menu_scroll.size.y + 1, "Every main menu item must fit without scrolling, including Continue.")
		var links: Control = menu_body.get_node("CollectionLinks")
		_check(studio.global_position.y - links.get_global_rect().end.y <= 24, "The studio logo must stay close to the utility buttons.")
		var valid: bool = save.get("species_id", "") in ["velociraptor", "iguanodon", "lesothosaurus"]
		_check(menu.continue_btn.visible == valid, "Continue must represent a valid playable saved life.")
		_check(GameState.species_id == before_species and GameState.seasons_elapsed == before_seasons, "Previewing a saved life must never load it into the active game.")
		if valid:
			var row: Control = menu.continue_btn.get_node("IllustratedCard")
			var detail: Label = row.find_child("SavedLife", true, false)
			_check(detail.text.contains("Season 1" if save["species_id"] == "lesothosaurus" else "Season 14"), "Saved card must show the actual season, including legacy defaults.")
			var expected_portrait: String = {"velociraptor": "velociraptor_sub_adult", "iguanodon": "iguanodon_adult", "lesothosaurus": "lesothosaurus_hatchling"}[save["species_id"]]
			var portrait: TextureRect = row.find_child("Portrait", true, false)
			_check(portrait.texture.resource_path.contains(expected_portrait), "Continue must use the saved dinosaur's actual stage portrait.")
			_check_portrait(portrait)
			if save["species_id"] == "velociraptor":
				await _capture("menu_saved_%d" % dimensions.x)
			elif save["species_id"] == "iguanodon":
				await _capture("menu_reference_%d" % dimensions.x)
				var studio_position := studio.global_position
				menu_scroll.scroll_vertical = 10000
				_swipe(Vector2(5, dimensions.y * 0.5))
				await _settle()
				_check(menu_scroll.scroll_vertical == 0, "A main menu swipe must not move its fixed controls.")
				_check(studio.global_position.is_equal_approx(studio_position) and menu.get_viewport_rect().encloses(studio.get_global_rect()), "The complete studio footer must remain fixed and visible after a swipe.")
				await _capture("menu_footer_%d" % dimensions.x)
				menu_scroll.scroll_vertical = 0
				await _settle()
		elif save.is_empty():
			await _capture("menu_%d" % dimensions.x)
		for btn in [menu.new_game_btn, menu._story_btn, menu.discoveries_btn, menu._lineage_btn, menu.store_btn, menu.settings_btn]:
			_check(btn.size.x <= dimensions.x - 40 and btn.size.y >= 44, "Menu buttons must fit the viewport and remain large enough to tap.")
			_check(menu_scroll.get_global_rect().encloses(btn.get_global_rect()), "Every main menu button must be visible immediately: " + btn.name)
		# Simulate notch/home-indicator insets without changing the user's device.
		var margin: MarginContainer = menu.get_node("PageMargin")
		margin.set_meta("safe_top", 56)
		margin.set_meta("safe_bottom", 46)
		menu.LAYOUT._fit_page(menu)
		await _settle()
		for btn in [menu.new_game_btn, menu._story_btn, menu.discoveries_btn, menu._lineage_btn, menu.store_btn, menu.settings_btn]:
			_check(menu_scroll.get_global_rect().encloses(btn.get_global_rect()) and btn.size.y >= 44, "Safe areas must not hide a main menu button: " + btn.name)
		_check(title.global_position.y >= 56 and studio.get_global_rect().end.y <= dimensions.y - 46, "Both logos must respect phone safe areas.")
		if valid:
			_check(menu_scroll.get_global_rect().encloses(menu.continue_btn.get_global_rect()), "Continue must fit even with notch/home-indicator insets.")
			_check_portrait(menu.continue_btn.get_node("IllustratedCard/Photo/Portrait"))
		if valid and save["species_id"] == "iguanodon":
			await _capture("menu_safe_%d" % dimensions.x)
		menu.settings_panel.closed.emit()
		await _settle()
		_check(menu_body.get_combined_minimum_size().y <= menu_scroll.size.y + 1, "Restyling after Settings must preserve the fitted menu.")
		_check(is_equal_approx(menu.new_game_btn.global_position.y, menu._story_btn.global_position.y) and menu.new_game_btn.get_global_rect().end.x <= menu._story_btn.global_position.x, "Survival and Story Mode must form two side-by-side illustrated tiles.")
		menu.queue_free()
		await _settle()
		GameState.delete_save()


func _check_portrait(image: TextureRect) -> void:
	var photo: Control = image.get_parent()
	_check(photo.clip_contents and image.get_global_rect().encloses(photo.get_global_rect()), "Continue artwork must fill its entire frame without empty bands.")
	_check(is_equal_approx(image.size.aspect(), image.texture.get_size().aspect()), "Dinosaur artwork must keep its original proportions.")
	var focus_y: float = image.global_position.y + float(image.get_meta("focus_y")) * image.size.y
	_check(focus_y >= photo.global_position.y + 4 and focus_y <= photo.get_global_rect().end.y - 4, "The reviewed portrait focus must stay inside the visible artwork.")
	var caption: Control = photo.get_parent().get_node("Caption")
	_check(photo.get_global_rect().end.y <= caption.global_position.y + 1, "Continue lettering must sit below the dinosaur artwork.")


func _check_all_portrait_stages() -> void:
	for sid in UnlockManager.PLAYABLE_SPECIES:
		for stage in 5:
			var button := Button.new()
			add_child(button)
			preload("res://scripts/ui/main_menu_layout.gd")._continue_card(button, {"species_id": sid, "life_stage": stage}, 320)
			button.custom_minimum_size = Vector2.ZERO
			for dimensions in [Vector2(280, 156), Vector2(350, 289)]:
				button.size = dimensions
				preload("res://scripts/ui/main_menu_layout.gd")._fit_continue_card(button, dimensions.y < 210)
				await _settle()
				_check_portrait(button.get_node("IllustratedCard/Photo/Portrait"))
			button.queue_free()
			await _settle()


func _run() -> void:
	if not OS.get_user_data_dir().replace("\\", "/").contains("/.godot/selection_userdata/"):
		get_tree().quit(2)
		return
	var old_emulation := Input.is_emulating_touch_from_mouse()
	Input.set_emulate_touch_from_mouse(true)
	UnlockManager.unlocked = SpeciesDB.get_default_unlocked()
	await _check_all_portrait_stages()
	for dimensions in [Vector2i(320, 568), Vector2i(390, 844), Vector2i(768, 1024)]:
		get_tree().root.content_scale_size = dimensions
		get_tree().root.size = dimensions
		await _check_menu(dimensions)
		var selection = preload("res://scenes/ui/character_select.tscn").instantiate()
		add_child(selection)
		await _settle()
		var scroll: ScrollContainer = selection.get_node("PageMargin/PageScroll")
		for diet in ["herbivore", "carnivore"]:
			selection._current_tree = diet
			for species_index in 5:
				selection._current_index = species_index
				selection._refresh()
				await _settle()
				var name_label: Label = selection.species_name
				_check(name_label.get_theme_font("font").get_string_size(name_label.text, HORIZONTAL_ALIGNMENT_LEFT, -1, name_label.get_theme_font_size("font_size")).x <= name_label.size.x, "Every dinosaur name must fit its nameplate without splitting a word.")
			for index in [0, 4]:
				selection._current_index = index
				selection._refresh()
				await _settle()
				scroll.scroll_vertical = 0
				await _settle()
				await _capture("selection_%s_%d_%d" % [diet, index, dimensions.x])
				scroll.scroll_vertical = int(scroll.get_v_scroll_bar().max_value)
				await _settle()
				await _capture("selection_bottom_%s_%d_%d" % [diet, index, dimensions.x])
				_check(selection.herb_tab.button_pressed == (diet == "herbivore") and selection.carn_tab.button_pressed == (diet == "carnivore"), "Exactly one clearly selected diet must match the displayed species.")
				_check(selection._roster.get_child_count() == 5, "Each diet must retain exactly five first-edition dinosaurs.")
				var species: Dictionary = SpeciesDB.get_species(selection._current_species_id())
				for stat in selection._ability_meters:
					_check(is_equal_approx(selection._ability_meters[stat]["meter"].value, species["base_" + stat]), "Selection abilities must match the actual starting values.")
				_check(selection._roster.size.x <= dimensions.x - 40, "Roster must retain its inset width.")
				_check(selection.dino_image.stretch_mode == TextureRect.STRETCH_KEEP_ASPECT_COVERED, "The selection portrait must fill its frame.")
				_check(selection.get_node("PageMargin/PageScroll/Body/PortraitCard").is_ancestor_of(selection.species_name), "The nameplate must be attached to the portrait.")
				_check(selection._diet_badge.size.y <= 25 and selection._traits.size.y <= 25, "Trait badges must remain single readable lines.")
				var targets: Array[Control] = [selection.herb_tab, selection.carn_tab, selection._roster.get_child(0), selection.dino_image.get_parent(), selection.species_name, selection.next_arrow, selection.description, selection._tutorial_check]
				if selection.locked_label.visible:
					targets.append(selection.locked_label)
					targets.append(selection.lock_overlay)
				else:
					targets.append(selection.male_btn)
				for target in targets:
					scroll.scroll_vertical = 0
					await _settle()
					scroll.ensure_control_visible(target)
					await _settle()
					# Start near the target's bottom to leave room to swipe upward.
					var point := target.get_global_rect().get_center()
					point.y = minf(target.get_global_rect().end.y - 5, scroll.get_global_rect().end.y - 5)
					var before := scroll.scroll_vertical
					var bottom := int(scroll.get_v_scroll_bar().max_value - scroll.get_v_scroll_bar().page)
					var direction := -70.0 if before < bottom else 70.0
					var tutorial_before: bool = selection._tutorial_check.button_pressed
					_swipe(point, direction)
					_check(bottom <= 0 or (scroll.scroll_vertical > before if direction < 0 else scroll.scroll_vertical < before), "Swipe must scroll over %s at %s (%s/%d)." % [target.name, dimensions, diet, index])
					_check(selection._current_index == index and selection._current_tree == diet and selection._tutorial_check.button_pressed == tutorial_before and not is_instance_valid(selection._tooltip), "A swipe must not select a dinosaur, toggle tutorial or open unlock details.")
					await _settle()
				for x in [8.0, float(dimensions.x) - 8.0, 32.0, float(dimensions.x) - 32.0]:
					scroll.scroll_vertical = 0
					await _settle()
					_swipe(Vector2(x, scroll.get_global_rect().get_center().y))
					_check(scroll.get_v_scroll_bar().max_value <= scroll.get_v_scroll_bar().page or scroll.scroll_vertical > 0, "Swipes must work at both screen/portrait edges: %s at %s." % [x, dimensions])
					await _settle()
			selection._current_index = 0
			selection._refresh()
			scroll.scroll_vertical = 0
			await _settle()
			_tap(selection._roster.get_child(1))
			_check(selection._current_index == 1, "Stationary roster tap must select its dinosaur.")
			await _settle()
			scroll.ensure_control_visible(selection.locked_label)
			await _settle()
			_tap(selection.locked_label.get_node("UnlockButton"))
			_check(is_instance_valid(selection._tooltip), "Stationary unlock tap must still open details.")
			selection._hide_tooltip()
			await _settle()
			scroll.ensure_control_visible(selection.next_arrow)
			await _settle()
			_tap(selection.next_arrow)
			_check(selection._current_index == 2, "A normal arrow tap must still advance one dinosaur.")
			await _settle()
			scroll.ensure_control_visible(selection._tutorial_check)
			await _settle()
			var tutorial_before: bool = selection._tutorial_check.button_pressed
			_tap(selection._tutorial_check)
			_check(selection._tutorial_check.button_pressed != tutorial_before, "A normal tutorial tap must still toggle the checkbox.")
			scroll.scroll_vertical = 0
			await _settle()
			_tap(selection.carn_tab if diet == "herbivore" else selection.herb_tab)
			_check(selection._current_tree != diet and selection._current_index == 0, "Both diet buttons must switch the actual roster on a normal tap.")
		if dimensions.x == 390:
			var original_unlocked = UnlockManager.unlocked.duplicate()
			UnlockManager.unlocked.append("iguanodon")
			selection._current_tree = "herbivore"
			selection._current_index = 1
			selection._refresh()
			scroll.scroll_vertical = 0
			await _settle()
			await _capture("selection_reference_390")
			UnlockManager.unlocked = original_unlocked
		selection.queue_free()
		await _settle()
	Input.set_emulate_touch_from_mouse(old_emulation)
	for player in SoundManager.get_children():
		if player is AudioStreamPlayer:
			player.stop()
	await get_tree().create_timer(0.5).timeout
	print("SELECTION SCROLL CHECKS PASSED" if failures == 0 else "SELECTION SCROLL CHECKS FAILED")
	get_tree().quit(0 if failures == 0 else 1)
