extends "res://scripts/dinos/base_dino_hatchling.gd"

# Mating style: pack_alpha  |  nesting_seasons: 2  →  2 hatchling events per cycle

const HATCHLING_EVENTS: Array = [
	{
		"intro": [
			"Tiny cracks appear beneath the roots as soft chirps rise from the hidden clutch.",
			"The leaf litter twitches with new life as your eggs hatch into the dangerous green world.",
			"Tiny hatchlings push from their shells, hungry, fragile, and small enough to disappear beneath a leaf.",
			"The hidden nest comes alive with quick little cries and trembling bodies.",
			"One shell breaks, then another, until the root hollow fills with newborn chirps.",
		],
		"choices": [
			{ "label": "Give them every scrap you can spare", "icon": "attack", "sublabel": "Food −12%", "action": "feed_heavy"  },
			{ "label": "Give them a steady first feeding",    "icon": "bond",   "sublabel": "Food −7%", "action": "feed_steady" },
			{ "label": "Give them a few tiny bites",          "icon": "stalk",  "sublabel": "Food −4%",       "action": "feed_light"  },
			{ "label": "Hold back and save your hunger",      "icon": "flee",   "sublabel": "",          "action": "feed_skip"   },
		],
		"outcomes": {
			"feed_heavy": [
				"The hatchlings feed eagerly and settle into the roots with surprising strength.",
				"Every tiny body perks up after the meal, chirping softer and steadier.",
				"Your sacrifice gives the clutch a bright start beneath the hidden leaves.",
				"The weakest hatchlings gain strength, and the nest feels calmer afterward.",
				"The first feeding goes perfectly, leaving the clutch lively and ready to survive.",
			],
			"feed_steady": [
				"The hatchlings eat enough to steady their tiny bodies.",
				"The clutch settles after feeding, still fragile but stronger than before.",
				"Your food gives them a real chance at the season ahead.",
				"Most of the hatchlings feed well and quiet down beneath the roots.",
				"Their first meal helps the nest feel less desperate.",
			],
			"feed_light": [
				"Some hatchlings eat well, but others are pushed aside in the tiny scramble.",
				"The food helps, but the nest grows loud and messy before it settles.",
				"A few hatchlings gain strength while the weakest still struggle.",
				"The feeding works, but not as cleanly as you hoped.",
				"The clutch survives the moment, but the start feels uneven.",
			],
			"feed_skip": [
				"Holding back leaves the hatchlings restless, noisy, and weaker than they should be.",
				"The smallest hatchlings struggle to feed, and the nest fills with nervous chirps.",
				"The first feeding fails to settle them, making the clutch feel fragile.",
				"Hunger spreads through the nest, and the hatchlings begin their lives at a disadvantage.",
				"The clutch survives, but the weak start may follow them into the next season.",
			],
		},
	},
	{
		"intro": [
			"The hatchlings are quick now, but still tiny enough for every shadow to matter.",
			"The young compies follow your chirps through roots, ferns, and dangerous scraps of sunlight.",
			"Your hatchlings scatter and regroup constantly, learning the world one frightened dash at a time.",
			"The season tests the little ones with hunger, noise, and hiding places that are never safe for long.",
			"The nest is no longer enough. The hatchlings must learn to move, hide, and feed.",
		],
		"choices": [
			{ "label": "Guide every tiny step",           "icon": "attack", "sublabel": "Food −12%", "action": "feed_heavy"  },
			{ "label": "Lead them through safe root paths","icon": "bond",   "sublabel": "Food −7%",   "action": "feed_steady" },
			{ "label": "Give quick warning chirps",        "icon": "stalk",  "sublabel": "Food −4%",     "action": "feed_light"  },
			{ "label": "Let them scatter and learn",       "icon": "flee",   "sublabel": "",                                        "action": "feed_skip"   },
		],
		"outcomes": {
			"feed_heavy": [
				"The hatchlings learn fast, vanishing into cover whenever your warning chirps sound.",
				"Your careful guidance keeps the little group fed, hidden, and calmer than before.",
				"The young compies follow your signals with surprising speed.",
				"Every tiny body makes it through the season stronger and harder to catch.",
				"The hatchlings begin moving like a real little pack.",
			],
			"feed_steady": [
				"The hatchlings stay mostly together and learn enough to survive the season.",
				"Your guidance helps them find food and avoid the worst dangers.",
				"A few mistakes happen, but the young make real progress.",
				"The group remains fragile, but it is learning.",
				"The hatchlings end the season quicker and more aware than before.",
			],
			"feed_light": [
				"Some hatchlings learn well, while others keep wandering too far.",
				"The season goes unevenly, with moments of safety and sudden panic.",
				"Your help works sometimes, but the little ones remain difficult to control.",
				"A few hatchlings grow stronger while others lag behind.",
				"The group survives, but the start feels messy.",
			],
			"feed_skip": [
				"Too much distance spreads through the hatchlings, making them harder to protect.",
				"The young grow loud, hungry, and scattered beneath the ferns.",
				"Your lack of guidance leaves the little group nervous and weaker.",
				"Several hatchlings learn the wrong lesson and bolt at the worst moments.",
				"The season ends with the hatchlings alive, but less prepared than they should be.",
			],
		},
	},
]

func get_hatchling_events() -> Array:
	return HATCHLING_EVENTS
