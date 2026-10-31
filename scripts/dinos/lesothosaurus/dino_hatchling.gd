extends "res://scripts/dinos/base_dino_hatchling.gd"

# Mating style: tournament_speed  |  nesting_seasons: 2  →  2 hatchling events per cycle

const HATCHLING_EVENTS: Array = [
	{
		"intro": [
			"Tiny Lesothosaurus hatch beneath low cover, trembling on legs made to run.",
			"The eggs crack open, and nervous little bodies stumble toward the grass.",
			"Soft calls rise from the nest as the hatchlings blink into a world full of danger.",
			"The clutch hatches quickly, small, fragile, and already needing food.",
			"New life rustles beneath the plants as hatchlings take their first shaky breaths.",
		],
		"choices": [
			{ "label": "Give them the best soft plants", "icon": "attack", "sublabel": "Food −12%", "action": "feed_heavy"  },
			{ "label": "Give them a steady feeding",     "icon": "bond",   "sublabel": "Food −7%",  "action": "feed_steady" },
			{ "label": "Give them a few safe bites",     "icon": "stalk",  "sublabel": "Food −4%",        "action": "feed_light"  },
			{ "label": "Hold back and save your hunger", "icon": "flee",   "sublabel": "",           "action": "feed_skip"   },
		],
		"outcomes": {
			"feed_heavy": [
				"The hatchlings feed well and gain strength for their first nervous steps.",
				"Your sacrifice gives the clutch a calm, healthy beginning.",
				"Even the smallest young settle after feeding on soft plants.",
				"The first meal helps their tiny bodies steady beneath the grass.",
				"The clutch starts strong, quiet, and ready to follow.",
			],
			"feed_steady": [
				"The hatchlings eat enough to calm their trembling bodies.",
				"Their first feeding gives them a fair start.",
				"Most of the young feed well and stay close.",
				"The food helps them face the season with less fear.",
				"The clutch settles into the grass, still fragile but fed.",
			],
			"feed_light": [
				"Some hatchlings feed well, but others stay too nervous to eat much.",
				"The food helps, though the group remains jumpy.",
				"A few young gain strength while others wobble behind.",
				"The feeding is useful, but the start still feels thin.",
				"They eat a little, but not enough to feel truly safe.",
			],
			"feed_skip": [
				"Too little food leaves the hatchlings weak and quick to panic.",
				"The young stumble through the grass with hunger still pressing them.",
				"The clutch survives, but the first season begins with shaky strength.",
				"Hunger makes the hatchlings restless and harder to keep close.",
				"The start is poor, and every rustle feels more dangerous.",
			],
		},
	},
	{
		"intro": [
			"The hatchlings are quick on their feet now, but fear still outruns sense.",
			"Young Lesothosaurus graze nervously beneath low plants, ready to bolt at every sound.",
			"Each season teaches the little ones when to run and when to freeze.",
			"The group moves through grass and shadows, trying to keep the young close.",
			"The hatchlings are growing, but the world is full of sudden movement.",
		],
		"choices": [
			{ "label": "Guide them through the safest grazing paths", "icon": "attack", "sublabel": "Food −12%", "action": "feed_heavy"  },
			{ "label": "Keep them fed near cover",                    "icon": "bond",   "sublabel": "Food −7%",   "action": "feed_steady" },
			{ "label": "Teach them short warning calls",              "icon": "stalk",  "sublabel": "Food −4%",     "action": "feed_light"  },
			{ "label": "Let them follow their own fear",              "icon": "flee",   "sublabel": "",                                        "action": "feed_skip"   },
		],
		"outcomes": {
			"feed_heavy": [
				"The hatchlings feed well and learn to stay close when danger feels near.",
				"Your effort keeps the young calm, fed, and harder to surprise.",
				"They begin following warning calls with quick, useful reactions.",
				"The little group grows stronger without scattering too often.",
				"The hatchlings end the season faster, steadier, and less panicked.",
			],
			"feed_steady": [
				"The hatchlings graze enough to grow and stay mostly together.",
				"Your care helps them learn the safest movements.",
				"They still startle easily, but they recover faster.",
				"Most of the young finish the season healthier.",
				"The group remains nervous, but better prepared.",
			],
			"feed_light": [
				"Some hatchlings learn well, while others bolt too soon.",
				"Feeding helps, but fear keeps interrupting the lesson.",
				"The season is safe enough, though not calm.",
				"A few young grow strong while others remain jumpy and thin.",
				"The group survives, but the hatchlings stay difficult to guide.",
			],
			"feed_skip": [
				"The hatchlings scatter too often and waste energy fleeing shadows.",
				"Hunger and panic leave the young weaker than they should be.",
				"They learn to run, but not when to stop.",
				"The season ends with nervous bodies and poor growth.",
				"The young survive, but fear has shaped them badly.",
			],
		},
	},
]

func get_hatchling_events() -> Array:
	return HATCHLING_EVENTS
