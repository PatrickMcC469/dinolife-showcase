extends Node

func get_egg_hatch_event() -> Dictionary:
	return {
		"title":  "A New Life Begins",
		"flavor": "Your egg cracks with a sharp snap. Through the gap you see your nestmates already moving — they hatched before you. Not for long.",
		"type":   "egg_hatch",
		"choices": [
			{ "action": "hatch_bold",     "label": "Kick free and snap",       "sublabel": "+Strength" },
			{ "action": "hatch_swift",    "label": "Slip out before the rest", "sublabel": "+Speed"    },
			{ "action": "hatch_cautious", "label": "Watch before you move",    "sublabel": "+Defense"  },
			{ "action": "hatch_curious",  "label": "Call out, see what answers","sublabel": "+Instinct" },
		],
	}
