extends "res://scripts/dinos/base_dino_hatchling.gd"

# Mating style: solitary_stalk  |  nesting_seasons: 3  →  3 hatchling events per cycle

const HATCHLING_EVENTS: Array = [
	{
		"intro": [
			"Small Ankylosaurus hatch low in the nest, soft armor glistening beneath broken shells.",
			"The clutch opens slowly, revealing tiny armored bodies pressed close to the ground.",
			"New hatchlings wriggle free like living stones, hungry and stubborn from the start.",
			"The nest stirs with soft plates, heavy little tails, and quiet hunger.",
			"The eggs crack beneath cover, and the young emerge ready to endure.",
		],
		"choices": [
			{ "label": "Give them the best sturdy plants",  "icon": "attack", "sublabel": "Food −12%", "action": "feed_heavy"  },
			{ "label": "Give them a steady first feeding",  "icon": "bond",   "sublabel": "Food −7%",  "action": "feed_steady" },
			{ "label": "Give them a few safe bites",        "icon": "stalk",  "sublabel": "Food −4%",        "action": "feed_light"  },
			{ "label": "Hold back and save your hunger",    "icon": "flee",   "sublabel": "",           "action": "feed_skip"   },
		],
		"outcomes": {
			"feed_heavy": [
				"The hatchlings feed steadily and settle low with surprising strength.",
				"Your sacrifice gives the small armored young a sturdy beginning.",
				"Every hatchling gains enough to quiet down and rest.",
				"The first feeding helps their little bodies feel solid beneath their soft armor.",
				"The clutch starts calm, fed, and ready to grow tougher.",
			],
			"feed_steady": [
				"The hatchlings eat enough to settle beneath cover.",
				"The meal gives them a steady first start.",
				"Most of the young feed well and tuck close to the ground.",
				"Your food helps them begin the season with better strength.",
				"The clutch remains fragile, but their first hunger is answered.",
			],
			"feed_light": [
				"Some hatchlings feed well, but others struggle with the tougher plants.",
				"The meal helps, though the young remain restless.",
				"A few settle after eating while others keep shifting under cover.",
				"The first feeding works unevenly.",
				"The clutch gains some strength, but not enough to feel secure.",
			],
			"feed_skip": [
				"Too little food leaves the hatchlings weak beneath their soft armor.",
				"The young shuffle restlessly, hungry and harder to keep hidden.",
				"The clutch survives, but the first season begins with thin strength.",
				"The poor start leaves them unsettled and slower to calm.",
				"The hatchlings begin life hungry, and even their armor feels too soft for the world.",
			],
		},
	},
	{
		"intro": [
			"The hatchlings are tougher now, but their armor is still soft and their steps still clumsy.",
			"Small Ankylosaurus shuffle beneath cover, learning that survival can mean staying low.",
			"Each season hardens them a little more, if they can get enough food and rest.",
			"The young move like living stones, slow, stubborn, and not yet safe.",
			"Their tails drag behind them as they learn where to hide and when to brace.",
		],
		"choices": [
			{ "label": "Keep them low, fed, and hidden",    "icon": "attack", "sublabel": "Food −12%", "action": "feed_heavy"  },
			{ "label": "Guide them to sturdy plants",       "icon": "bond",   "sublabel": "Food −7%",   "action": "feed_steady" },
			{ "label": "Teach them to tuck and hold still", "icon": "stalk",  "sublabel": "Food −4%",     "action": "feed_light"  },
			{ "label": "Let toughness come naturally",      "icon": "flee",   "sublabel": "",                                        "action": "feed_skip"   },
		],
		"outcomes": {
			"feed_heavy": [
				"The hatchlings feed well, stay low, and grow sturdier beneath their soft armor.",
				"Your care gives them a strong season of safety and growth.",
				"They learn to tuck close to the ground when danger passes.",
				"The young grow calmer, heavier, and harder to disturb.",
				"The season leaves them tougher than before.",
			],
			"feed_steady": [
				"The hatchlings eat enough and remain mostly hidden.",
				"Your guidance helps them grow slowly but steadily.",
				"They begin learning when to brace and when to move.",
				"Most of the young finish the season stronger.",
				"Their armor still needs time, but they are improving.",
			],
			"feed_light": [
				"Some hatchlings feed well while others refuse tougher plants.",
				"They hide sometimes, but shuffle too loudly at other moments.",
				"The season helps, though their progress is uneven.",
				"A few grow stronger while others remain soft and restless.",
				"The young survive, but not all grow well.",
			],
			"feed_skip": [
				"The hatchlings stay hungry and restless beneath cover.",
				"They move too much when they should stay low.",
				"Poor feeding leaves their little bodies weaker under soft armor.",
				"The season ends with the young less sturdy than they should be.",
				"Their toughness does not come quickly enough this season.",
			],
		},
	},
]

func get_hatchling_events() -> Array:
	return HATCHLING_EVENTS
