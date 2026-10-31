extends "res://scripts/dinos/base_dino_hatchling.gd"

# Mating style: pack_coalition  |  nesting_seasons: 3  →  3 hatchling events per cycle

const HATCHLING_EVENTS: Array = [
	{
		"intro": [
			"Feathered hatchlings break from the eggs, tiny sickle claws flexing weakly beside the nest.",
			"Sharp little cries rise as the clutch hatches under the pack's watch.",
			"New hunters enter the world trembling, hungry, and unable to stand without care.",
			"The nest stirs with downy bodies and broken shell as the hatchlings cry for food.",
			"The clutch hatches one by one, fragile now but filled with predator blood.",
		],
		"choices": [
			{ "label": "Bring them the best meat you can",  "icon": "attack", "sublabel": "Food −12%", "action": "feed_heavy"  },
			{ "label": "Bring them a steady first meal",    "icon": "bond",   "sublabel": "Food −7%",  "action": "feed_steady" },
			{ "label": "Give them only what you can spare", "icon": "stalk",  "sublabel": "Food −4%",        "action": "feed_light"  },
			{ "label": "Hold back and save your hunger",    "icon": "flee",   "sublabel": "",           "action": "feed_skip"   },
		],
		"outcomes": {
			"feed_heavy": [
				"The hatchlings feed deeply, their tiny bodies gaining strength beneath the pack's watch.",
				"Fresh meat gives the clutch a powerful start, and their cries settle into quiet energy.",
				"Your sacrifice leaves the hatchlings stronger, calmer, and ready for the next danger.",
				"The weakest hatchlings perk up after feeding, and the nest feels secure.",
				"The clutch takes its first meal well, and the pack's future feels brighter.",
			],
			"feed_steady": [
				"The hatchlings eat enough to steady themselves.",
				"The meal gives the clutch a healthy first step.",
				"Most of the young feed well and settle beneath warm feathers.",
				"Your effort gives them a fair start in a dangerous world.",
				"The nest quiets after feeding, fragile but stable.",
			],
			"feed_light": [
				"The food helps, but the scent lingers around the nest.",
				"Some hatchlings feed strongly while others are pushed back.",
				"The clutch gains strength, though the feeding turns noisy and tense.",
				"The meal helps enough, but it also stirs restless movement.",
				"The start is good for some and uncertain for others.",
			],
			"feed_skip": [
				"The hatchlings remain hungry, crying loud enough to make the nest feel exposed.",
				"Too little food leaves the weakest young struggling beside the shells.",
				"The clutch survives, but the first season begins with thin strength.",
				"Hunger makes the nest restless and harder for the pack to keep calm.",
				"The young are alive, but their beginning feels weaker than it should.",
			],
		},
	},
	{
		"intro": [
			"The hatchlings are growing into their claws, but their bodies are still soft beneath new feathers.",
			"The young watch every movement you make, trying to copy the rhythm of the pack.",
			"Their first bold steps carry them farther from the nest each season.",
			"Tiny predators now follow at the edge of the pack, hungry to learn and easy to lose.",
			"The hatchlings are no longer helpless, but they are far from safe.",
		],
		"choices": [
			{ "label": "Train them beside the pack",      "icon": "attack", "sublabel": "Food −12%", "action": "feed_heavy"  },
			{ "label": "Keep them close during feeding",  "icon": "bond",   "sublabel": "Food −7%",   "action": "feed_steady" },
			{ "label": "Teach short hunting calls",       "icon": "stalk",  "sublabel": "Food −4%",     "action": "feed_light"  },
			{ "label": "Let their instincts lead",        "icon": "flee",   "sublabel": "",                                        "action": "feed_skip"   },
		],
		"outcomes": {
			"feed_heavy": [
				"The hatchlings copy the pack's rhythm and begin moving with sharper purpose.",
				"Your effort gives them food, safety, and the first shape of real hunting instinct.",
				"They learn when to follow, when to freeze, and when to keep quiet.",
				"The young grow bolder without becoming reckless.",
				"The pack's attention helps them become stronger little hunters.",
			],
			"feed_steady": [
				"The hatchlings learn enough to stay close and respond to danger.",
				"Your guidance gives them a steadier place in the pack.",
				"Their movements remain clumsy, but they are improving.",
				"The season strengthens them without too much trouble.",
				"The young end the season more alert and better fed.",
			],
			"feed_light": [
				"Some hatchlings follow well, while others rush ahead too quickly.",
				"Training helps, but their excitement makes them noisy.",
				"The pack supports them unevenly, leaving a few young behind at times.",
				"They learn part of the lesson, but not cleanly.",
				"The season gives them progress, but also bad habits.",
			],
			"feed_skip": [
				"The hatchlings grow too bold and stray farther than they should.",
				"Hunger and noise make the young harder for the pack to protect.",
				"Your limited care leaves them restless and underprepared.",
				"They mistake excitement for skill and stumble into danger too often.",
				"The season ends with the young alive, but less disciplined.",
			],
		},
	},
]

func get_hatchling_events() -> Array:
	return HATCHLING_EVENTS
