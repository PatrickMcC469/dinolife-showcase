extends "res://scripts/ui/field_view.gd"

signal care_requested(a: String, b: String)
const PAIRS = preload("res://scripts/systems/pack_relationships.gd")
const COMPANIONS = preload("res://scripts/systems/companions.gd")
var selected := ""
var graph: Control
var pair_cards: VBoxContainer
var member_detail: Label
var care_buttons: Array[Button] = []


func open() -> void:
	COMPANIONS.ensure_cast()
	clear_content()
	var cast := COMPANIONS.active_cast()
	title.text = "Life in your " + COMPANIONS.group_name()
	subtitle.text = "Tap a member to see their bonds."
	back.text = "Back to your " + COMPANIONS.group_name()
	if cast.is_empty():
		content.add_child(UI.label("No companions are traveling with you."))
	else:
		if not cast.any(func(member: Dictionary): return member["name"] == selected): selected = cast[0]["name"]
		graph = preload("res://scripts/ui/pack_relationship_graph.gd").new()
		content.add_child(graph)
		graph.setup(cast, selected)
		graph.member_selected.connect(_select)
		content.add_child(UI.label("Solid green: friends · dashed rust: rivals\nFaint lines: still getting acquainted", 12))
		member_detail = UI.label("", 14)
		content.add_child(member_detail)
		pair_cards = VBoxContainer.new()
		pair_cards.mouse_filter = Control.MOUSE_FILTER_PASS
		pair_cards.add_theme_constant_override("separation", 10)
		content.add_child(pair_cards)
		_select(selected)
	content.add_child(UI.label("Friends who both support you give +2% defense for one season. Rivalries cost the group 2% bond per season in total. Their bonds can bring shared events and influence alpha challenges. Help one pair each season; councils and alpha mediation also shape their bonds.", 12))
	scroll.scroll_vertical = 0
	get_parent().move_child(self, -1)
	show()
	back.grab_focus()


func _select(member_name: String) -> void:
	selected = member_name
	graph.selected = selected
	for key in graph.markers: ART.button(graph.markers[key], key == selected)
	graph.queue_redraw()
	for member in COMPANIONS.active_cast():
		if member["name"] == selected:
			member_detail.text = "%s feels %s toward you · trust %d%%\n%s" % [selected, COMPANIONS.relationship(member).to_lower(), floori((float(member["trust"]) + 1.0) * 50), str(member.get("reason", ""))]
	for child in pair_cards.get_children():
		pair_cards.remove_child(child)
		child.queue_free()
	care_buttons.clear()
	for pair in GameState.pack_relations.get("pairs", []):
		if selected not in [pair["a"], pair["b"]]: continue
		UI.card(pair_cards, "%s & %s" % [pair["a"], pair["b"]], PAIRS.status(pair).to_upper() + " · bond %d%%" % floori((float(pair["score"]) + 1) * 50), "Season %d · %s" % [int(pair["season"]) + 1, pair["reason"]], (float(pair["score"]) + 1) / 2, "group")
		var care := Button.new()
		care.mouse_filter = Control.MOUSE_FILTER_PASS
		care.text = "Help this pair"
		care.custom_minimum_size.y = 44
		care.disabled = GameState.get_action_uses("pair_care") > 0 or GameState.health <= 0.0
		ART.button(care)
		care.pressed.connect(func(): care_requested.emit(pair["a"], pair["b"]))
		pair_cards.add_child(care)
		care_buttons.append(care)
	if care_buttons.is_empty(): pair_cards.add_child(UI.label("They are the only companion here. New bonds begin when someone joins."))
	elif GameState.get_action_uses("pair_care") > 0: pair_cards.add_child(UI.label("You helped a pair this season. More care next season.", 12))
