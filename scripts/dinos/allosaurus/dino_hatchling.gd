extends "res://scripts/dinos/base_dino_hatchling.gd"

# Mating style: tournament_combat  |  nesting_seasons: 4  →  4 hatchling events per cycle

const HATCHLING_EVENTS: Array = [
	{
		"intro": [
			"The eggs crack open, and small Allosaurus hatchlings lift heavy little heads from the shells.",
			"Sharp cries fill the nest as the clutch breaks into the world hungry and demanding.",
			"Your hatchlings emerge with clumsy bodies, open jaws, and immediate hunger.",
			"Broken shells scatter as new predators stumble into the season.",
			"The forest feels louder as your young call for their first meal.",
		],
		"choices": [
			{ "label": "Give them a heavy first meal", "icon": "attack", "sublabel": "Food −12%", "action": "feed_heavy"  },
			{ "label": "Give them a solid feeding",    "icon": "bond",   "sublabel": "Food −7%",  "action": "feed_steady" },
			{ "label": "Give them a little meat",      "icon": "stalk",  "sublabel": "Food −4%",        "action": "feed_light"  },
			{ "label": "Hold back and save your hunger", "icon": "flee", "sublabel": "",           "action": "feed_skip"   },
		],
		"outcomes": {
			"feed_heavy": [
				"The hatchlings tear into the meal and settle with stronger bodies and quieter cries.",
				"Your sacrifice gives the clutch a powerful first start.",
				"Even the smallest hatchlings feed well and rise steadier afterward.",
				"The first meal fills them enough to calm the nest.",
				"The young begin life with full bellies and stronger jaws.",
			],
			"feed_steady": [
				"The hatchlings eat enough to steady their clumsy bodies.",
				"The meal gives the clutch a healthy start.",
				"Most of the young feed well and quiet down afterward.",
				"Your food helps them face the first season with better strength.",
				"The nest feels calmer once their first hunger is answered.",
			],
			"feed_light": [
				"The food helps, but the strongest hatchlings shove the weakest aside.",
				"The meal draws noise and scent around the nest.",
				"Some young gain strength while others remain restless.",
				"The feeding works, but the scramble leaves the clutch unsettled.",
				"You give them a start, but not all of them benefit equally.",
			],
			"feed_skip": [
				"Hunger leaves the hatchlings loud, rough, and harder to control.",
				"The weakest young struggle while the nest grows tense.",
				"The clutch survives, but the first season begins with too much hunger.",
				"The young snap and shove without enough food to settle them.",
				"Their first start is weak, and the forest feels too aware of the nest.",
			],
		},
	},
	{
		"intro": [
			"Your hatchlings are larger now, loud with hunger and clumsy with growing power.",
			"The young Allosaurus test their jaws on anything soft enough to bite.",
			"Each season makes them stronger, but also harder to keep quiet.",
			"The hatchlings stumble after food, already carrying the hunger of future predators.",
			"They are growing quickly, and the forest is beginning to notice.",
		],
		"choices": [
			{ "label": "Bring them rich kills and guard them closely", "icon": "attack", "sublabel": "Food −12%", "action": "feed_heavy"  },
			{ "label": "Feed them well near the nest",                 "icon": "bond",   "sublabel": "Food −7%",   "action": "feed_steady" },
			{ "label": "Give them scraps and rough lessons",           "icon": "stalk",  "sublabel": "Food −4%",     "action": "feed_light"  },
			{ "label": "Let hunger toughen them",                      "icon": "flee",   "sublabel": "",                                        "action": "feed_skip"   },
		],
		"outcomes": {
			"feed_heavy": [
				"The hatchlings feed deeply and grow with powerful, steady energy.",
				"Your sacrifice keeps them strong, calmer, and less desperate.",
				"Even the weakest young gain weight and confidence this season.",
				"Their growing jaws and bodies show clear promise.",
				"The young finish the season stronger and easier to manage.",
			],
			"feed_steady": [
				"The hatchlings get enough food to grow well.",
				"Their hunger settles, and the nest feels less chaotic.",
				"Most of the young grow stronger through the season.",
				"Your care gives them a healthy step forward.",
				"The hatchlings remain demanding, but they are thriving.",
			],
			"feed_light": [
				"Some hatchlings grow strong while others struggle for enough food.",
				"Feeding helps, but the young fight over every scrap.",
				"The season brings growth, but also noise and tension.",
				"The strongest young benefit most, leaving the clutch uneven.",
				"They survive and grow, but not as smoothly as you hoped.",
			],
			"feed_skip": [
				"Hunger makes the hatchlings aggressive and difficult to control.",
				"The young snap at each other too often and waste precious energy.",
				"Poor feeding leaves them loud, thin, and restless.",
				"Their strength grows unevenly, and the weakest fall farther behind.",
				"The season ends with the hatchlings alive, but poorly started.",
			],
		},
	},
]

func get_hatchling_events() -> Array:
	return HATCHLING_EVENTS
