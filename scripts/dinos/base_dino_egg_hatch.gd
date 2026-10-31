extends Node
# Generic fallback egg hatch event used when no species-specific version exists.

func get_egg_hatch_event() -> Dictionary:
	return {
		"title":   "A New Life Begins",
		"flavor":  "Your shell cracks open. Light and noise flood in for the very first time.",
		"type":    "egg_hatch",
		"choices": [
			{ "action": "hatch_bold",     "label": "Burst free fiercely",     "sublabel": "+Strength" },
			{ "action": "hatch_swift",    "label": "Scramble out quickly",    "sublabel": "+Speed"    },
			{ "action": "hatch_cautious", "label": "Emerge slowly, quietly",  "sublabel": "+Defense"  },
			{ "action": "hatch_curious",  "label": "Sniff the air first",     "sublabel": "+Instinct" },
		],
	}
