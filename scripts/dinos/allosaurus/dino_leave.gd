extends "res://scripts/dinos/base_dino_leave.gd"

func get_leave_event() -> Dictionary:
	return {
		"type": "parents_leave",
		"flavor": "The scent of your parent has always meant one thing: food may come, danger may pass, and something bigger than you still watches the dark.\n\nBut today, that scent drifts away.\n\nNo call brings them back. No shadow waits near the nest. No torn scrap is left for you to claim. You are a sub-adult Allosaurus now, leaner, stronger, and old enough for the wild to stop making room for you.\n\nFrom this point on, hunger will teach you faster than comfort ever could. You will follow trails alone, choose your battles alone, and learn which risks end in meat — and which end in scars.\n\nThe easy meals are gone.",
		"choices": [
			{ "label": "I'll earn every bite.",        "icon": "stalk", "sublabel": "", "action": "leave_accept" },
			{ "label": "No more waiting for scraps.",  "icon": "stalk", "sublabel": "", "action": "leave_accept" },
			{ "label": "The wild teaches alone.",      "icon": "stalk", "sublabel": "", "action": "leave_accept" },
			{ "label": "Hunger can follow me.",        "icon": "stalk", "sublabel": "", "action": "leave_accept" },
			{ "label": "I hunt for myself now.",       "icon": "stalk", "sublabel": "", "action": "leave_accept" },
		],
		"resolve_key": "parents_leave",
	}
