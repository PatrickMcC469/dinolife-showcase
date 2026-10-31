extends "res://scripts/dinos/base_dino_leave.gd"

func get_leave_event() -> Dictionary:
	return {
		"type": "parents_leave",
		"flavor": "For your youngest seasons, protection had weight. A larger body nearby. A familiar scent in the grass. A steady presence between you and the teeth beyond the ferns.\n\nNow the space beside you is empty.\n\nYour parent has moved on, leaving only tracks pressed deep into the mud. You are a sub-adult Ankylosaurus now. Your armor has hardened, your body has widened, and your tail no longer feels like something you drag — it feels like something the world should respect.\n\nYou will not be fast enough to flee every danger. You will not be hidden enough to avoid every hungry eye.\n\nSo you must become what you were born to be.\n\nDifficult.",
		"choices": [
			{ "label": "Let them try to move me.", "icon": "stalk", "sublabel": "", "action": "leave_accept" },
			{ "label": "I stand for myself now.",  "icon": "stalk", "sublabel": "", "action": "leave_accept" },
			{ "label": "Armor up. Head low.",      "icon": "stalk", "sublabel": "", "action": "leave_accept" },
			{ "label": "The wild can test me.",    "icon": "stalk", "sublabel": "", "action": "leave_accept" },
		],
		"resolve_key": "parents_leave",
	}
