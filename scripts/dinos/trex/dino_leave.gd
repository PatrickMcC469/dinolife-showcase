extends "res://scripts/dinos/base_dino_leave.gd"

func get_leave_event() -> Dictionary:
	return {
		"type": "parents_leave",
		"flavor": "For many seasons, a larger shadow meant safety. A warning scent, a distant footstep, a half-shared meal — signs that you were not facing the wild alone.\n\nNow that shadow is gone.\n\nYour parent leaves without ceremony, disappearing beyond the trees with the quiet certainty of a creature that knows its work is done. You are a sub-adult T-Rex now. Too large to be sheltered. Too hungry to be carried. Too dangerous to remain a child.\n\nFrom this season forward, every meal is yours to find. Every wound is yours to survive. Every rival, storm, and starving day belongs to you.\n\nThe world has stopped protecting you.",
		"choices": [
			{ "label": "Then I'll make it fear me.", "icon": "stalk", "sublabel": "", "action": "leave_accept" },
			{ "label": "No one feeds me now.",        "icon": "stalk", "sublabel": "", "action": "leave_accept" },
			{ "label": "I stand alone.",              "icon": "stalk", "sublabel": "", "action": "leave_accept" },
			{ "label": "The crown starts here.",      "icon": "stalk", "sublabel": "", "action": "leave_accept" },
			{ "label": "Let the wild try.",           "icon": "stalk", "sublabel": "", "action": "leave_accept" },
		],
		"resolve_key": "parents_leave",
	}
