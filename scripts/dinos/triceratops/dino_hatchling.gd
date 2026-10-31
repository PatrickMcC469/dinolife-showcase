extends "res://scripts/dinos/base_dino_hatchling.gd"

# Mating style: tournament_combat  |  nesting_seasons: 4  →  4 hatchling events per cycle

const HATCHLING_EVENTS: Array = [
	{
		"intro": [
			"Small Triceratops hatch beneath the herd's watch, soft frills lifting for the first time.",
			"The eggs crack open, and tiny calves stumble into the protection of horns and heavy bodies.",
			"New calves push free of their shells, hungry, shaky, and stubborn already.",
			"The clutch fills with soft snorts and clumsy steps.",
			"Broken shells mark the arrival of young born for the herd circle.",
		],
		"choices": [
			{ "label": "Give them the best first feeding", "icon": "attack", "sublabel": "Food −12%", "action": "feed_heavy"  },
			{ "label": "Give them a steady meal",          "icon": "bond",   "sublabel": "Food −7%",  "action": "feed_steady" },
			{ "label": "Give them a few safe bites",       "icon": "stalk",  "sublabel": "Food −4%",        "action": "feed_light"  },
			{ "label": "Hold back and save your hunger",   "icon": "flee",   "sublabel": "",           "action": "feed_skip"   },
		],
		"outcomes": {
			"feed_heavy": [
				"The calves feed well and stand stronger beneath the herd's protection.",
				"Your sacrifice gives the clutch a powerful start inside the circle.",
				"The smallest calves gain strength and stay close after feeding.",
				"Their first meal steadies their legs and quiets their nervous calls.",
				"The young begin the season fed, firm, and ready to learn the herd's rhythm.",
			],
			"feed_steady": [
				"The calves eat enough to steady themselves.",
				"The first feeding gives the young a healthy beginning.",
				"Most of the clutch feeds well and settles within the herd's safety.",
				"Your food helps them stand stronger for the season ahead.",
				"The calves remain delicate, but their first need is met.",
			],
			"feed_light": [
				"Some calves feed well while others struggle to stay close.",
				"The food helps, but the clutch remains unsettled.",
				"A few young grow steadier while others still wobble behind.",
				"The first feeding works, but not evenly.",
				"The calves gain some strength, though the start feels uncertain.",
			],
			"feed_skip": [
				"Too little food leaves the calves weak and slow to settle.",
				"The clutch survives, but the young begin the season shaky.",
				"Hunger makes the calves restless inside the herd circle.",
				"The weakest calves struggle to keep close after the poor start.",
				"The first season begins under strain, and the herd's protection may not be enough.",
			],
		},
	},
	{
		"intro": [
			"The calves are steadier now, but their small horns and soft frills do not make them safe yet.",
			"Young Triceratops move within the herd circle, learning where strength comes from.",
			"The season tests whether the calves can stay close, feed well, and brace when warned.",
			"Their little bodies are growing, but the herd's protection still matters most.",
			"The calves follow heavy footsteps through open ground, watched by every hungry eye.",
		],
		"choices": [
			{ "label": "Keep them deep inside the herd circle", "icon": "attack", "sublabel": "Food −12%", "action": "feed_heavy"  },
			{ "label": "Lead them to the safest feeding",       "icon": "bond",   "sublabel": "Food −7%",   "action": "feed_steady" },
			{ "label": "Teach them to brace with the herd",     "icon": "stalk",  "sublabel": "Food −4%",     "action": "feed_light"  },
			{ "label": "Let them learn from the circle",        "icon": "flee",   "sublabel": "",                                        "action": "feed_skip"   },
		],
		"outcomes": {
			"feed_heavy": [
				"The calves stay close, feed well, and begin bracing when the herd shifts.",
				"Your effort gives the young a strong, protected season.",
				"They learn to lower their heads and hold near the safest bodies.",
				"The calves grow sturdier beneath horns and watchful eyes.",
				"The season leaves them stronger and more confident in the herd.",
			],
			"feed_steady": [
				"The calves feed enough and remain mostly protected.",
				"Your guidance helps them stay close to the group.",
				"They begin to understand the herd's defensive rhythm.",
				"Most of the young grow steadily this season.",
				"The circle holds well enough around them.",
			],
			"feed_light": [
				"Some calves stay close while others wander toward the gaps.",
				"They learn a little, but the herd's movement still frightens them.",
				"Feeding goes well for some and poorly for others.",
				"The season helps, but the calves remain uneven.",
				"Their progress is real, but fragile.",
			],
			"feed_skip": [
				"The calves drift toward the outer gaps and panic when the herd shifts.",
				"Poor feeding leaves them tired inside the circle.",
				"They mistake movement for danger and stumble at the wrong times.",
				"The season ends with the young weaker and more nervous.",
				"The herd protects them, but their growth suffers.",
			],
		},
	},
]

func get_hatchling_events() -> Array:
	return HATCHLING_EVENTS
