extends Node

func get_egg_hatch_event() -> Dictionary:
	return {
		"title":  "A New Life Begins",
		"flavor": "You hatch into blinding daylight, quick and light on your feet. Everything around you is enormous and moving fast. You'll have to be faster.",
		"type":   "egg_hatch",
		"choices": [
			{ "action": "hatch_bold",     "label": "Chirp loudly at the world", "sublabel": "+Strength" },
			{ "action": "hatch_swift",    "label": "Sprint away from the nest", "sublabel": "+Speed"    },
			{ "action": "hatch_cautious", "label": "Crouch low and listen",     "sublabel": "+Defense"  },
			{ "action": "hatch_curious",  "label": "Watch the other hatchlings","sublabel": "+Instinct" },
		],
	}
