extends "res://scripts/dinos/base_dino_hatchling.gd"

# Mating style: solitary_stalk  |  nesting_seasons: 5  →  5 hatchling events per cycle

const HATCHLING_EVENTS: Array = [
	{
		"intro": [
			"The large eggs split open, and tiny tyrants cry into the air with oversized heads and hungry mouths.",
			"Heavy little bodies push from broken shells, fragile despite the power waiting in their blood.",
			"Your hatchlings emerge loud, clumsy, and already demanding the world feed them.",
			"The nest trembles with new life and sharp cries.",
			"One shell breaks, then another, until the clutch is alive with hunger.",
		],
		"choices": [
			{ "label": "Give them the richest meat",        "icon": "attack", "sublabel": "Food −12%", "action": "feed_heavy"  },
			{ "label": "Give them a strong first feeding",  "icon": "bond",   "sublabel": "Food −7%",  "action": "feed_steady" },
			{ "label": "Give them a small meal",            "icon": "stalk",  "sublabel": "Food −4%",        "action": "feed_light"  },
			{ "label": "Hold back and save your hunger",    "icon": "flee",   "sublabel": "",           "action": "feed_skip"   },
		],
		"outcomes": {
			"feed_heavy": [
				"The hatchlings feed hard and quiet down, their little bodies stronger after the rich meal.",
				"Your sacrifice turns their first hunger into strength.",
				"Even the loudest hatchlings settle after feeding, heavy with a strong start.",
				"The clutch begins life with power in their bellies and steadier bodies.",
				"Their first meal matches their hunger, and the nest finally goes calm.",
			],
			"feed_steady": [
				"The hatchlings eat enough to quiet their first cries.",
				"The meal gives the young a solid beginning.",
				"Most of the clutch gains strength from the feeding.",
				"Your food steadies the hatchlings before their hunger turns chaotic.",
				"The nest settles, still dangerous but less desperate.",
			],
			"feed_light": [
				"The loudest hatchlings feed first, leaving others to struggle for scraps.",
				"The food helps, but the feeding turns noisy enough to feel risky.",
				"Some young quiet down while others keep crying.",
				"The clutch gains strength unevenly.",
				"The first meal works, but not enough to fully satisfy them.",
			],
			"feed_skip": [
				"Hunger makes the hatchlings loud and restless, drawing danger closer in your mind.",
				"Too little food leaves the weakest young struggling under the others' cries.",
				"The clutch survives, but their first season begins with sharp hunger.",
				"The nest grows chaotic as hunger turns the hatchlings against each other.",
				"Their first start is poor, and the young feel harder to protect.",
			],
		},
	},
	{
		"intro": [
			"The hatchlings are bigger now, with oversized jaws and hunger that never seems to end.",
			"Tiny tyrants stumble through the season, loud, bold, and still dangerously fragile.",
			"Your young demand food with sharp cries and clumsy force.",
			"Each season adds weight to their bodies and danger to their appetite.",
			"They are still small, but the world already feels challenged by them.",
		],
		"choices": [
			{ "label": "Feed them until the nest goes quiet", "icon": "attack", "sublabel": "Food −12%", "action": "feed_heavy"  },
			{ "label": "Bring them a strong meal",            "icon": "bond",   "sublabel": "Food −7%",   "action": "feed_steady" },
			{ "label": "Give them what meat you can spare",   "icon": "stalk",  "sublabel": "Food −4%",     "action": "feed_light"  },
			{ "label": "Let them endure hunger",              "icon": "flee",   "sublabel": "",                                        "action": "feed_skip"   },
		],
		"outcomes": {
			"feed_heavy": [
				"The hatchlings feed hard and grow calmer, their bodies thickening with strength.",
				"Your sacrifice turns their hunger into real growth.",
				"The nest settles beneath the weight of full bellies and stronger young.",
				"Even the weakest hatchling gains enough to keep up.",
				"The young end the season heavier, louder, and healthier.",
			],
			"feed_steady": [
				"The hatchlings eat enough to grow steadily.",
				"Their hunger quiets for now, and the nest feels more stable.",
				"Most of the young gain strength from your effort.",
				"The season moves them closer to becoming real threats.",
				"Their bodies grow stronger, even if their hunger remains endless.",
			],
			"feed_light": [
				"The loudest hatchlings eat best, while others fall behind.",
				"The feeding helps, but the nest becomes noisy and risky.",
				"Some young grow strong while others remain thin and restless.",
				"The season gives progress, but not evenly.",
				"They survive, but hunger still rules too much of their behavior.",
			],
			"feed_skip": [
				"Hunger turns the hatchlings rough, loud, and harder to protect.",
				"The weakest young struggle beneath the demands of stronger siblings.",
				"The nest grows chaotic as hunger sharpens every cry.",
				"The season ends with thin bodies and dangerous noise.",
				"The hatchlings live, but their growth suffers.",
			],
		},
	},
]

func get_hatchling_events() -> Array:
	return HATCHLING_EVENTS
