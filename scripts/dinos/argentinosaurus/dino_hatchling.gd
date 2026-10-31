extends "res://scripts/dinos/base_dino_hatchling.gd"

# Mating style: tournament_combat  |  nesting_seasons: 5  →  5 hatchling events per cycle

const HATCHLING_EVENTS: Array = [
	{
		"intro": [
			"Tiny giants hatch beneath the herd's shadow, trembling on legs that will one day shake the earth.",
			"The huge eggs crack open, and long-necked hatchlings rise into a world too large for them.",
			"Deep herd rumbles answer the first weak calls from the nest.",
			"New Argentinosaurus hatch slowly, hungry, fragile, and full of impossible promise.",
			"Broken shells lie beneath towering bodies as the young take their first breaths.",
		],
		"choices": [
			{ "label": "Give them the richest soft leaves",  "icon": "attack", "sublabel": "Food −12%", "action": "feed_heavy"  },
			{ "label": "Give them a steady first feeding",   "icon": "bond",   "sublabel": "Food −7%",  "action": "feed_steady" },
			{ "label": "Give them a few safe mouthfuls",     "icon": "stalk",  "sublabel": "Food −4%",        "action": "feed_light"  },
			{ "label": "Hold back and save your hunger",     "icon": "flee",   "sublabel": "",           "action": "feed_skip"   },
		],
		"outcomes": {
			"feed_heavy": [
				"The hatchlings feed well beneath the herd's shadows, gaining strength for their first steps.",
				"Your sacrifice gives the young giants a strong beginning.",
				"Even the smallest hatchlings settle after feeding on soft leaves.",
				"Their first meal steadies their long necks and trembling legs.",
				"The clutch begins life fed, calm, and ready to follow the herd.",
			],
			"feed_steady": [
				"The hatchlings eat enough to steady their huge little bodies.",
				"The first feeding gives the young a healthy start.",
				"Most of the clutch feeds well and stays close beneath the herd.",
				"Your food helps them face the season with more strength.",
				"The young remain fragile, but their first hunger is met.",
			],
			"feed_light": [
				"Some hatchlings feed well, but others struggle to reach enough leaves.",
				"The food helps, though the young remain slow and uncertain.",
				"A few gain strength while others lag behind.",
				"The first feeding works unevenly across the clutch.",
				"The young giants survive the start, but not all begin strong.",
			],
			"feed_skip": [
				"Too little food leaves the hatchlings weak beneath the wide sky.",
				"The young struggle to settle, hunger making them slow and restless.",
				"The clutch survives, but the first season begins with thin strength.",
				"The weakest hatchlings have trouble keeping up after the poor start.",
				"The herd's shadows feel less safe when the young begin life hungry.",
			],
		},
	},
	{
		"intro": [
			"The young giants walk beneath the herd now, small only compared to the shadows around them.",
			"Each season asks the hatchlings to eat, follow, and keep up with bodies far larger than theirs.",
			"Their long necks reach higher now, but the world still feels too wide.",
			"The herd's deep calls guide them across open land.",
			"The young are growing, but every step still takes effort.",
		],
		"choices": [
			{ "label": "Keep them fed beneath the herd's safest shadows", "icon": "attack", "sublabel": "Food −12%", "action": "feed_heavy"  },
			{ "label": "Lead them to soft high leaves",                   "icon": "bond",   "sublabel": "Food −7%",   "action": "feed_steady" },
			{ "label": "Teach them to follow the deep calls",             "icon": "stalk",  "sublabel": "Food −4%",     "action": "feed_light"  },
			{ "label": "Let the herd rhythm teach them",                  "icon": "flee",   "sublabel": "",                                        "action": "feed_skip"   },
		],
		"outcomes": {
			"feed_heavy": [
				"The hatchlings feed well and keep pace beneath the herd's protection.",
				"Your care gives the young giants a strong, steady season.",
				"They begin answering deep calls and moving when the herd moves.",
				"Their legs grow stronger, and their long necks reach with more confidence.",
				"The season leaves them healthier, calmer, and better connected to the herd.",
			],
			"feed_steady": [
				"The hatchlings eat enough and follow the herd more steadily.",
				"Your guidance helps them stay close through the season.",
				"They learn some of the herd's deep signals.",
				"Most of the young grow well beneath the larger bodies.",
				"The herd's rhythm begins to settle into them.",
			],
			"feed_light": [
				"Some hatchlings keep up, while others lag behind.",
				"They feed well in places, but tire before the season ends.",
				"The deep calls help, though not every young one responds.",
				"The season brings growth, but not evenly.",
				"A few young grow strong while others remain slow and uncertain.",
			],
			"feed_skip": [
				"The hatchlings struggle to keep up with the moving herd.",
				"Poor feeding leaves them weak beneath the wide sky.",
				"They miss the deep calls and drift at the wrong moments.",
				"The season ends with tired legs and thin strength.",
				"The herd moves on, but the young fall behind more than they should.",
			],
		},
	},
]

func get_hatchling_events() -> Array:
	return HATCHLING_EVENTS
