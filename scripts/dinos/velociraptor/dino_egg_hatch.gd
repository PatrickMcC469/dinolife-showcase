extends Node

func get_egg_hatch_event() -> Dictionary:
	return {
		"title":  "A New Life Begins",
		"flavor": "Cool air hits you the moment your shell cracks. Your siblings chirp nearby. The whole world smells alive and you want all of it.",
		"type":   "egg_hatch",
		"choices": [
			{ "action": "hatch_bold",     "label": "Burst out and stand tall",  "sublabel": "+Strength" },
			{ "action": "hatch_swift",    "label": "Dart to the nest's edge",   "sublabel": "+Speed"    },
			{ "action": "hatch_cautious", "label": "Crawl out, claws ready",    "sublabel": "+Defense"  },
			{ "action": "hatch_curious",  "label": "Taste the air with care",   "sublabel": "+Instinct" },
		],
	}
