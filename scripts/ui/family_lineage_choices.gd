extends RefCounted

const FAMILY = preload("res://scripts/systems/family_legacy.gd")
const UI = preload("res://scripts/ui/perks_panel.gd")


static func add_to(column: VBoxContainer, record: Dictionary, selection: Label) -> void:
	for child in record.get("offspring_history", []):
		if not child is Dictionary or not child.get("name") is String or not child.get("skills") is Dictionary: continue
		UI.card(column, child["name"], "FAMILY · " + str(child.get("trait", "")).to_upper(), "Left with a %s bond.\n%s" % [child.get("bond", "steady"), FAMILY.skill_summary(child)], -1, "nest")
		if FAMILY.legacy_skill(child).is_empty(): continue
		for skill in FAMILY.SKILLS:
			if int(child["skills"].get(skill, 0)) != 2: continue
			var button := Button.new()
			button.text = "Carry %s's %s" % [child["name"], FAMILY.SKILLS[skill]["lesson"]]
			button.custom_minimum_size.y = 64
			button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			button.mouse_filter = Control.MOUSE_FILTER_PASS
			preload("res://scripts/ui/adventure_theme.gd").button(button, true)
			var note := UI.label("Next new %s life: +2%% %s. Choosing a lesson replaces the previous choice. Your current life keeps its own bonus." % [record.get("display_name", "dinosaur"), FAMILY.SKILLS[skill]["stat"]], 12)
			button.pressed.connect(func():
				if LegacyManager.select_family_lesson(record, child, skill):
					selection.text = "Chosen for your next new %s life: %s's %s (+2%% %s)." % [record.get("display_name", "dinosaur"), child["name"], FAMILY.SKILLS[skill]["lesson"], FAMILY.SKILLS[skill]["stat"]])
			column.add_child(button)
			column.add_child(note)
