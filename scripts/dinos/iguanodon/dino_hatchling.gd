extends "res://scripts/dinos/base_dino_hatchling.gd"

# Mating style: tournament_combat  |  nesting_seasons: 3  →  3 hatchling events per cycle

const HATCHLING_EVENTS: Array = [
	{
		"intro": [
			"Small Iguanodon hatch near the herd path, blinking beneath broad leaves.",
			"The clutch opens slowly, and unsteady young push into the world beside familiar footsteps.",
			"Soft calls rise from the nest as your hatchlings reach for their first food.",
			"Broken shells scatter beneath the herd's watch.",
			"The young emerge curious, hungry, and ready to follow if they can grow strong enough.",
		],
		"choices": [
			{ "label": "Give them the best soft leaves",   "icon": "attack", "sublabel": "Food −12%", "action": "feed_heavy"  },
			{ "label": "Give them a steady first meal",    "icon": "bond",   "sublabel": "Food −7%",  "action": "feed_steady" },
			{ "label": "Give them a few safe mouthfuls",   "icon": "stalk",  "sublabel": "Food −4%",        "action": "feed_light"  },
			{ "label": "Hold back and save your hunger",   "icon": "flee",   "sublabel": "",           "action": "feed_skip"   },
		],
		"outcomes": {
			"feed_heavy": [
				"The hatchlings feed well, gaining strength beneath the comfort of the herd.",
				"Your sacrifice gives the young a strong, steady beginning.",
				"Every hatchling gets enough soft food to settle and stand stronger.",
				"The first feeding goes smoothly, and the clutch feels healthier at once.",
				"The young begin the season fed, calm, and ready to follow.",
			],
			"feed_steady": [
				"The hatchlings eat enough to steady their first steps.",
				"The meal gives the clutch a healthy start.",
				"Most of the young feed well and settle near the herd path.",
				"Your food helps them face the season with better strength.",
				"The young remain fragile, but their first hunger is answered.",
			],
			"feed_light": [
				"Some hatchlings feed well while others struggle to chew.",
				"The food helps, but a few young wander before finishing.",
				"The feeding works unevenly across the clutch.",
				"The young gain something, but their start still feels uncertain.",
				"A few settle after eating, while others remain restless.",
			],
			"feed_skip": [
				"Too little food leaves the hatchlings weak beside the herd path.",
				"The young grow restless and harder to keep near the group.",
				"Their first season begins with hunger still clinging to them.",
				"The clutch survives, but the start feels thin and uncertain.",
				"The hatchlings remain fragile, and the herd's safety feels less comforting.",
			],
		},
	},
	{
		"intro": [
			"The hatchlings walk near the herd path now, curious, hungry, and still easy to overwhelm.",
			"Young Iguanodon browse beside larger bodies, learning what is safe by watching the herd.",
			"The season asks whether they can keep pace without losing themselves.",
			"Small footsteps follow the herd's rhythm, though not always cleanly.",
			"The young are growing sturdier, but the trail is long.",
		],
		"choices": [
			{ "label": "Keep them close to the safest herd path",  "icon": "attack", "sublabel": "Food −12%", "action": "feed_heavy"  },
			{ "label": "Guide them to good feeding grounds",       "icon": "bond",   "sublabel": "Food −7%",   "action": "feed_steady" },
			{ "label": "Teach them the herd's warning sounds",     "icon": "stalk",  "sublabel": "Food −4%",     "action": "feed_light"  },
			{ "label": "Let the herd carry the lesson",            "icon": "flee",   "sublabel": "",                                        "action": "feed_skip"   },
		],
		"outcomes": {
			"feed_heavy": [
				"The hatchlings stay close, feed well, and begin understanding the herd's rhythm.",
				"Your guidance gives them a strong season of food and safety.",
				"They learn which calls mean danger and which paths mean food.",
				"The young grow steadier beside the herd.",
				"The season leaves them stronger, calmer, and easier to guide.",
			],
			"feed_steady": [
				"The hatchlings keep up well enough and feed through the season.",
				"Your care helps them grow stronger near the herd path.",
				"They learn some of the herd's signals.",
				"Most of the young finish the season in better condition.",
				"The trail feels safer with the young moving more steadily.",
			],
			"feed_light": [
				"Some hatchlings keep pace, while others lag behind.",
				"They feed, but not all of them learn the herd's signals clearly.",
				"The season helps them grow, though confusion remains.",
				"The group protects them unevenly.",
				"The young improve, but their progress is scattered.",
			],
			"feed_skip": [
				"The hatchlings drift too close to danger and too far from guidance.",
				"They miss important warning sounds and react too late.",
				"Poor feeding leaves them tired on the herd path.",
				"The season ends with the young weaker and harder to direct.",
				"The herd moves on, but the hatchlings struggle to keep up.",
			],
		},
	},
]

func get_hatchling_events() -> Array:
	return HATCHLING_EVENTS
