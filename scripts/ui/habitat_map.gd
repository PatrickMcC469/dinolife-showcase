extends "res://scripts/ui/field_view.gd"

signal choice_requested(action: String)
const HOME = preload("res://scripts/systems/living_world.gd")
const GROUP = preload("res://scripts/systems/group_habitat.gd")
const LOCAL = preload("res://scripts/systems/habitat_conditions.gd")
const POINTS = {"ridge": Vector2(0.25, 0.23), "grove": Vector2(0.76, 0.40), "river": Vector2(0.49, 0.76)}
var selected := "ridge"
var map: Control
var markers := {}
var details: VBoxContainer
var actions: Array[Button] = []
var world_panel: Control
var extra_details: VBoxContainer
var details_button: Button


func open() -> void:
	clear_content()
	markers.clear()
	actions.clear()
	title.text = "Your habitat"
	var home := str(GameState.living_state.get("site", ""))
	subtitle.text = ("No home settled" if home.is_empty() else "Home: " + HOME.SITES[home]["name"]) + "\n" + GROUP.control_text()
	selected = home if home in HOME.SITES else "ridge"
	map = Control.new()
	map.custom_minimum_size.y = 220
	map.mouse_filter = Control.MOUSE_FILTER_PASS
	content.add_child(map)
	var art := TextureRect.new()
	art.texture = preload("res://assets/ui/adventure/habitat_map_v1.png")
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_SCALE
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	map.add_child(art)
	art.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for key in HOME.SITES:
		var marker := Button.new()
		marker.mouse_filter = Control.MOUSE_FILTER_PASS
		marker.text = ("⌂ " if key == home else "") + ("Grove" if key == "grove" else HOME.SITES[key]["name"])
		marker.accessibility_name = HOME.SITES[key]["name"] + (", current home" if key == home else "")
		marker.add_theme_font_size_override("font_size", 12)
		marker.custom_minimum_size.y = 44
		marker.pressed.connect(_select.bind(key))
		map.add_child(marker)
		markers[key] = marker
	map.resized.connect(_layout_map)
	details = VBoxContainer.new()
	details.mouse_filter = Control.MOUSE_FILTER_PASS
	details.add_theme_constant_override("separation", 8)
	content.add_child(details)
	_select(selected)
	scroll.scroll_vertical = 0
	get_parent().move_child(self, -1)
	show()
	back.grab_focus()
	_layout_map.call_deferred()


func _layout_map() -> void:
	if not is_instance_valid(map): return
	map.custom_minimum_size.y = ceilf(maxf(205, map.size.x * 2.0 / 3.0))
	for key in markers:
		var marker: Button = markers[key]
		marker.size = Vector2(108 if key != "grove" else 80, 44)
		marker.position = (POINTS[key] * map.size - marker.size / 2).clamp(Vector2(4, 4), map.size - marker.size - Vector2(4, 4)).round()


func _select(key: String) -> void:
	selected = key
	for site in markers: ART.button(markers[site], site == key)
	for child in details.get_children():
		details.remove_child(child)
		child.queue_free()
	actions.clear()
	var home := str(GameState.living_state.get("site", ""))
	var description: String = {"ridge": "Safe from floods. Less food.", "river": "More food. Flood risk.", "grove": "Sheltered. Good for nesting."}[key]
	description += "\nFood: " + ["Very little", "Low", "Steady", "Rich", "Abundant"][int(LOCAL.at(key)["food"])]
	description += " · " + ["Quiet trails", "Predator tracks", "Predators nearby"][LOCAL.pressure(key)]
	if key == home:
		description += "\nShelter: %d of 2" % int(GameState.living_state.get("shelter", 0))
		if int(GameState.living_state.get("wear", 0)) >= 4: description += " · Ground worn"
	UI.card(details, HOME.SITES[key]["name"], "YOUR HOME" if home == key else "LOOKING AT", description)
	var menu := HOME.home_menu()
	for option in menu.get("choices", []):
		if option["action"] == "home_" + key or (home == key and option["action"] in ["home_prepare", "home_rest", "home_scout"]):
			var button := Button.new()
			button.mouse_filter = Control.MOUSE_FILTER_PASS
			button.text = {"home_prepare": "Improve shelter", "home_rest": "Rest the feeding ground", "home_scout": "Scout nearby trails"}.get(option["action"], option["label"])
			button.add_theme_font_size_override("font_size", 13)
			button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			button.custom_minimum_size.y = 48
			var cost := (0.06 if home.is_empty() else 0.08) if option["action"] == "home_" + key else (0.06 if option["action"] == "home_prepare" else 0.04)
			button.text += "\nSpend %d%% food" % roundi(cost * 100)
			button.disabled = GameState.hunger < cost
			ART.button(button, true)
			button.pressed.connect(func(): choice_requested.emit(option["action"]))
			details.add_child(button)
			if button.disabled: details.add_child(UI.label("Feed first to afford this.", 12))
			actions.append(button)
	if not HOME.available(): details.add_child(UI.label("Grow beyond the nest to settle a home.", 13))
	elif not GROUP.can_manage(): details.add_child(UI.label("Only the alpha can move or improve the group's home.", 13))
	elif GameState.get_action_uses("home_duty") > 0: details.add_child(UI.label("Home decision used. More choices next season.", 13))
	else: details.add_child(UI.label("One home decision per season. Moving leaves shelter behind.", 12))
	details_button = Button.new()
	details_button.text = "More details"
	details_button.custom_minimum_size.y = 44
	ART.button(details_button)
	details.add_child(details_button)
	extra_details = VBoxContainer.new()
	extra_details.mouse_filter = Control.MOUSE_FILTER_PASS
	extra_details.add_theme_constant_override("separation", 8)
	details.add_child(extra_details)
	UI.card(extra_details, "Location effects", HOME.SITES[key]["name"], HOME.SITES[key]["detail"] + "\n" + LOCAL.detail(key))
	if key == home and GameState.living_state.get("shelter_author", "player") == "npc": extra_details.add_child(UI.label("Your alpha prepared this shelter. Its protection is shared; Sheltercraft is earned by preparing a shelter yourself.", 12))
	world_panel = preload("res://scenes/ui/world_panel.tscn").instantiate()
	extra_details.add_child(world_panel)
	world_panel.details.visible = true
	world_panel.button.hide()
	world_panel.refresh()
	var group_notice: String = GameState.living_state.get("group_home", {}).get("notice", "")
	if not group_notice.is_empty() and GROUP.grouped(): extra_details.add_child(UI.label(group_notice, 13))
	extra_details.hide()
	details_button.pressed.connect(func():
		extra_details.visible = not extra_details.visible
		details_button.text = "Hide details" if extra_details.visible else "More details")
