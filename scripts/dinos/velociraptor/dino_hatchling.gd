extends "res://scripts/dinos/base_dino_hatchling.gd"

# Mating style: pack_alpha  |  nesting_seasons: 3  →  3 hatchling events per cycle

const HATCHLING_EVENTS: Array = [
	{
		"intro": [
			"Tiny feathered shapes push from the eggs beneath dust and thornbrush.",
			"The hidden nest shifts as hatchlings break into the warm, dangerous air.",
			"New raptors blink into the dust, trembling, hungry, and already listening.",
			"The clutch hatches in quiet cover, small bodies stirring beneath dry brush.",
			"Shell fragments crack under tiny claws as the hatchlings enter the world.",
		],
		"choices": [
			{ "label": "Give them the cleanest prey you can", "icon": "attack", "sublabel": "Food −12%", "action": "feed_heavy"  },
			{ "label": "Give them a careful first feeding",   "icon": "bond",   "sublabel": "Food −7%",  "action": "feed_steady" },
			{ "label": "Give them a few small bites",         "icon": "stalk",  "sublabel": "Food −4%",        "action": "feed_light"  },
			{ "label": "Hold back and save your hunger",      "icon": "flee",   "sublabel": "",           "action": "feed_skip"   },
		],
		"outcomes": {
			"feed_heavy": [
				"The hatchlings feed quietly and gain strength without drawing attention.",
				"The first meal is clean and controlled, giving the clutch a strong beginning.",
				"Your sacrifice leaves the young steady, quiet, and easier to protect.",
				"The nest settles after feeding, hidden and calm beneath the brush.",
				"Every hatchling gets enough to start the season with strength.",
			],
			"feed_steady": [
				"The hatchlings feed well enough to quiet their first hunger.",
				"The meal helps them settle into the hidden nest.",
				"Most of the clutch gains strength from the careful feeding.",
				"Your food gives them a solid start beneath the thornbrush.",
				"The hatchlings remain fragile, but their first need is met.",
			],
			"feed_light": [
				"Some hatchlings eat well, but the feeding leaves scent near the nest.",
				"The meal helps, though the young scramble more loudly than you wanted.",
				"A few hatchlings settle quickly while others keep crying.",
				"The clutch gains something, but not enough to feel secure.",
				"The start works, but the nest feels more exposed afterward.",
			],
			"feed_skip": [
				"The hatchlings stay hungry and restless, shifting loudly beneath the brush.",
				"Too little food leaves the clutch weak and difficult to quiet.",
				"The first feeding fails to calm them, and the nest feels vulnerable.",
				"The young survive, but their first season begins with hunger pressing close.",
				"The clutch starts life thin, noisy, and harder to protect.",
			],
		},
	},
	{
		"intro": [
			"The hatchlings move through dust and thornbrush now, small, sharp, and still easy to expose.",
			"Each season teaches the young raptors more about silence, scent, and danger.",
			"The nest is behind them, but the open brush is not kind.",
			"Tiny raptors follow the pack's pattern, though their steps are still clumsy.",
			"The young are learning to be quiet, but their hunger still gives them away.",
		],
		"choices": [
			{ "label": "Guide them through silent paths",   "icon": "attack", "sublabel": "Food −12%", "action": "feed_heavy"  },
			{ "label": "Keep them fed near cover",          "icon": "bond",   "sublabel": "Food −7%",   "action": "feed_steady" },
			{ "label": "Teach them to freeze at signals",   "icon": "stalk",  "sublabel": "Food −4%",     "action": "feed_light"  },
			{ "label": "Let them test the brush alone",     "icon": "flee",   "sublabel": "",                                        "action": "feed_skip"   },
		],
		"outcomes": {
			"feed_heavy": [
				"The hatchlings learn to freeze, creep, and settle before danger notices them.",
				"Your careful effort keeps them fed and hidden through the season.",
				"The young begin copying the pack's quiet pattern with surprising skill.",
				"They grow stronger without leaving too many tracks behind.",
				"The hatchlings become harder to hear, harder to smell, and harder to catch.",
			],
			"feed_steady": [
				"The young learn enough silence to stay safer than before.",
				"Your guidance gives them a solid season of food and cover.",
				"Their steps are still clumsy, but they are improving.",
				"The pack's pattern holds around them.",
				"They end the season sharper and more careful.",
			],
			"feed_light": [
				"Some hatchlings stay quiet, while others scrape loudly through the brush.",
				"The lesson helps, but their hunger keeps breaking their focus.",
				"A few follow your signals well, but the group remains uneven.",
				"The season teaches them, though not without risk.",
				"The hatchlings survive, but their path stays messy.",
			],
			"feed_skip": [
				"The young scatter through the brush and leave too many signs behind.",
				"Their noise and hunger make the hiding ground feel exposed.",
				"Without enough guidance, they learn boldness before caution.",
				"The hatchlings move too far from cover and return weaker.",
				"The season leaves them alive, but less hidden than they should be.",
			],
		},
	},
]

func get_hatchling_events() -> Array:
	return HATCHLING_EVENTS
