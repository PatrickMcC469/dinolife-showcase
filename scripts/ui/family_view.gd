extends "res://scripts/ui/field_view.gd"

signal lesson_requested(child_name: String)
const FAMILY = preload("res://scripts/systems/family_legacy.gd")


func open() -> void:
	clear_content()
	title.text = "Your family"
	subtitle.text = "Personalities · learned skills · family record"
	var names := FAMILY.active_names()
	for child_name in names:
		var child := FAMILY.ensure_child(child_name)
		var growth := FAMILY.growth(child_name)
		var young: bool = growth["young"]
		var detail := "%d of %d %s seasons · %s %d%%\nLearns to %s quickly.\n%s\nPracticed lessons: +%d%% %s each season." % [growth["age"], growth["duration"], "nest" if young else "juvenile", "care" if young else "bond", roundi(float(growth["care"]) * 100), str(FAMILY.SKILLS[FAMILY.natural_skill(child)]["name"]).to_lower(), FAMILY.skill_summary(child), mini(2, int(FAMILY.learned(child) / 2)), "nesting care" if young else "bond"]
		if int(growth["age"]) >= int(growth["duration"]): detail += "\nThis care stage ends when the next season turns."
		UI.card(content, child_name, ("HATCHLING" if young else "GROWING JUVENILE") + " · " + str(child["trait"]).to_upper(), detail, float(growth["care"]), "nest")
		var button := Button.new()
		button.text = "Spend time with " + child_name
		button.custom_minimum_size.y = 48
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		button.mouse_filter = Control.MOUSE_FILTER_PASS
		button.disabled = GameState.get_action_uses("family_lesson") > 0 or FAMILY.learned(child) >= 6
		ART.button(button, true)
		button.pressed.connect(func(): lesson_requested.emit(child_name))
		content.add_child(button)
	if not names.is_empty(): content.add_child(UI.label("One lesson across your family each season · 3% food. A natural strength takes less practice. Lessons used this season also count toward this limit.", 12))
	var inherited: Dictionary = GameState.family_state.get("inheritance", {})
	if not inherited.is_empty(): UI.card(content, "A lesson carried forward", "THIS LIFE", "%s's %s gave you +2%% %s at birth. This is one lasting bonus, saved with your life." % [inherited["name"], FAMILY.SKILLS[inherited["skill"]]["lesson"], FAMILY.SKILLS[inherited["skill"]]["stat"]], -1, "journal")
	for child in GameState.offspring_history:
		var detail := "Their bond when they left: " + str(child.get("bond", "steady")) + "."
		if child.has("trait"):
			detail += "\n%s\n%s" % [str(child["trait"]).capitalize(), FAMILY.skill_summary(child)]
		else: detail += "\nLessons weren't recorded during this child's care."
		UI.card(content, str(child["name"]), "FAMILY RECORD", detail, -1, "nest")
	if names.is_empty(): content.add_child(UI.label("No young in your care right now. Learned lessons from children who leave with a steady or strong bond can be carried into a new life of this species from Lineage after this run.", 13))
	scroll.scroll_vertical = 0
	get_parent().move_child(self, -1)
	show()
	back.grab_focus()
