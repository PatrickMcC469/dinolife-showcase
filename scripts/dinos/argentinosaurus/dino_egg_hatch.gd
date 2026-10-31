extends Node

func get_egg_hatch_event() -> Dictionary:
	return {
		"title":  "A New Life Begins",
		"flavor": "The ground trembles as your parents move nearby. Your egg splits and you fall into a world that already feels small for what you will become.",
		"type":   "egg_hatch",
		"choices": [
			{ "action": "hatch_bold",     "label": "Bellow your first call",    "sublabel": "+Strength" },
			{ "action": "hatch_swift",    "label": "Keep pace with the adults", "sublabel": "+Speed"    },
			{ "action": "hatch_cautious", "label": "Stay beneath their shadows","sublabel": "+Defense"  },
			{ "action": "hatch_curious",  "label": "Crane your neck skyward",   "sublabel": "+Instinct" },
		],
	}
