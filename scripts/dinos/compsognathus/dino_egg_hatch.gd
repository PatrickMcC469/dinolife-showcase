extends Node

func get_egg_hatch_event() -> Dictionary:
	return {
		"title":  "A New Life Begins",
		"flavor": "You tumble free from your egg — the smallest of your clutch. The forest floor looms enormous, but your legs are already twitching to run.",
		"type":   "egg_hatch",
		"choices": [
			{ "action": "hatch_bold",     "label": "Peck your sibling first", "sublabel": "+Strength" },
			{ "action": "hatch_swift",    "label": "Sprint to the nest edge", "sublabel": "+Speed"    },
			{ "action": "hatch_cautious", "label": "Tuck beneath the shells", "sublabel": "+Defense"  },
			{ "action": "hatch_curious",  "label": "Sniff the strange smells","sublabel": "+Instinct" },
		],
	}
