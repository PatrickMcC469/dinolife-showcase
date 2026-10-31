extends Node

func get_egg_hatch_event() -> Dictionary:
	return {
		"title":  "A New Life Begins",
		"flavor": "You push through your shell alone. No siblings, no nest sounds — just wide forest and a distant river smell. This land is yours to learn.",
		"type":   "egg_hatch",
		"choices": [
			{ "action": "hatch_bold",     "label": "Roar at the treeline",       "sublabel": "+Strength" },
			{ "action": "hatch_swift",    "label": "Bolt toward the water smell","sublabel": "+Speed"    },
			{ "action": "hatch_cautious", "label": "Press against the warm shell","sublabel": "+Defense"  },
			{ "action": "hatch_curious",  "label": "Follow the strange prints",  "sublabel": "+Instinct" },
		],
	}
