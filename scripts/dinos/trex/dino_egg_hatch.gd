extends Node

func get_egg_hatch_event() -> Dictionary:
	return {
		"title":  "A New Life Begins",
		"flavor": "Your egg splits with a crack that echoes through the forest. Even now you are heavier than anything nearby. The ground shakes with your first steps.",
		"type":   "egg_hatch",
		"choices": [
			{ "action": "hatch_bold",     "label": "Stomp and snap at once",    "sublabel": "+Strength" },
			{ "action": "hatch_swift",    "label": "Charge the nearest ridge",  "sublabel": "+Speed"    },
			{ "action": "hatch_cautious", "label": "Hold still, take it all in","sublabel": "+Defense"  },
			{ "action": "hatch_curious",  "label": "Follow the smell of death", "sublabel": "+Instinct" },
		],
	}
