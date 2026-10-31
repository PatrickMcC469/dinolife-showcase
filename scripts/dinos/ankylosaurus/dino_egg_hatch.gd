extends Node

func get_egg_hatch_event() -> Dictionary:
	return {
		"title":  "A New Life Begins",
		"flavor": "You break free slowly — your shell was thick and so are you. Your armored back catches the sun. Even now, nothing will find you easy to hurt.",
		"type":   "egg_hatch",
		"choices": [
			{ "action": "hatch_bold",     "label": "Swing your tail at once",   "sublabel": "+Strength" },
			{ "action": "hatch_swift",    "label": "Plod toward the tree line", "sublabel": "+Speed"    },
			{ "action": "hatch_cautious", "label": "Press flat against the earth","sublabel": "+Defense" },
			{ "action": "hatch_curious",  "label": "Inspect your own armour",   "sublabel": "+Instinct" },
		],
	}
