extends Node

func get_egg_hatch_event() -> Dictionary:
	return {
		"title":  "A New Life Begins",
		"flavor": "Your shell gives way with a heavy crack. Your frill is already flushed pink and your tiny horns stub the air. You were born ready.",
		"type":   "egg_hatch",
		"choices": [
			{ "action": "hatch_bold",     "label": "Lower your head and charge","sublabel": "+Strength" },
			{ "action": "hatch_swift",    "label": "Trot to the herd's center","sublabel": "+Speed"    },
			{ "action": "hatch_cautious", "label": "Stay behind the adults",    "sublabel": "+Defense"  },
			{ "action": "hatch_curious",  "label": "Study the other hatchlings","sublabel": "+Instinct" },
		],
	}
