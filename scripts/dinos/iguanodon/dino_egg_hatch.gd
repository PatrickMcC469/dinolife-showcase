extends Node

func get_egg_hatch_event() -> Dictionary:
	return {
		"title":  "A New Life Begins",
		"flavor": "You push free from your egg with surprising strength. Your thumb-spike catches the light. Around you the herd's low rumble is already comforting.",
		"type":   "egg_hatch",
		"choices": [
			{ "action": "hatch_bold",     "label": "Shove toward the herd",    "sublabel": "+Strength" },
			{ "action": "hatch_swift",    "label": "Race to keep up already",  "sublabel": "+Speed"    },
			{ "action": "hatch_cautious", "label": "Stay near the biggest adult","sublabel": "+Defense" },
			{ "action": "hatch_curious",  "label": "Sniff every strange plant", "sublabel": "+Instinct" },
		],
	}
