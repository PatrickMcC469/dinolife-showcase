extends "res://scripts/dinos/base_dino_ageup.gd"

const AGEUPS: Dictionary = {
	1: {
		"stage_label": "Age Up: Hatchling Complete",
		"title": "You Survived the Nest",
		"body": "Your first fragile seasons are behind you. No longer just a hatchling hiding beneath leaves and eggshells, you have learned the first rules of life: move fast, eat what you can, and never ignore a shadow overhead.\n\nAs a young Compsognathus, survival will not come from strength alone. You are small, quick, and clever — and there is safety in numbers. Other compies nearby may mean shared warning calls, stolen scraps, and a better chance of slipping away when larger predators come hunting.\n\nThe world is bigger now. Food will be harder to claim. Danger will notice you sooner. But your feet are quicker, your bite is sharper, and your instincts are waking up.",
		"choices": [
			{ "label": "The easy days are behind me.",     "best": true  },
			{ "label": "Bring it on, life.",               "best": false },
			{ "label": "Time to run faster.",              "best": false },
			{ "label": "I was born for this.",             "best": false },
			{ "label": "Stay small. Stay quick. Survive.", "best": false },
		],
	},
	2: {
		"stage_label": "Age Up: Juvenile Complete",
		"title": "Quick Feet, Sharper Teeth",
		"body": "You are no longer stumbling through the undergrowth as a fresh juvenile. Your body is leaner now, your movements quicker, your instincts cleaner. You know which sounds mean food, which shadows mean danger, and which scraps are worth risking your neck for.\n\nAs a growing Compsognathus, the pack matters more than ever. A lone compi is a snack. A clever group is a swarm of eyes, teeth, and warning calls. Stay close when it helps, dart away when you must, and never be the slowest thing in the ferns.\n\nThe world has not become safer. You have simply become harder to catch.",
		"choices": [
			{ "label": "Catch me if you can.",           "best": true  },
			{ "label": "The ferns are mine now.",        "best": false },
			{ "label": "Small, fast, and still alive.",  "best": false },
			{ "label": "Keep moving. Keep eating.",      "best": false },
			{ "label": "I hear every shadow.",           "best": false },
		],
	},
	3: {
		"stage_label": "Age Up: Sub-Adult Complete",
		"title": "A Survivor in Full",
		"body": "You have reached adulthood — not by being the biggest, but by being faster, sharper, and smarter than everything that tried to end your story early.\n\nYour bite is stronger now. Your legs know the quickest paths through roots and fallen branches. You can read the pack's chirps, stolen glances, and sudden silences. Together, you can harass larger prey, steal from kills, and vanish before danger fully understands what happened.\n\nYou are still small in a world of giants. But now, small does not mean helpless. Small means hard to hit.",
		"choices": [
			{ "label": "Small does not mean weak.",         "best": true  },
			{ "label": "I made it this far.",               "best": false },
			{ "label": "Time to steal dinner.",             "best": false },
			{ "label": "Let the giants stomp. I'll survive.", "best": false },
			{ "label": "Fast teeth, faster feet.",          "best": false },
		],
	},
	4: {
		"stage_label": "Age Up: Adult Complete",
		"title": "Old Bones, Quick Mind",
		"body": "Seasons have worn into your bones, but they have sharpened your instincts. You have seen nests fail, packs scatter, predators strike, and storms turn safe ground into death traps.\n\nYou are an elder Compsognathus now. Your speed may not be what it once was, but you know where insects hide, where scraps are left behind, and when the pack should run before anyone else smells danger. Younger compies may survive because you notice what they do not.\n\nThe world is still hungry. But you have been hungry longer.",
		"choices": [
			{ "label": "I've outrun worse than this.",  "best": true  },
			{ "label": "Old instincts bite deepest.",   "best": false },
			{ "label": "The pack still needs me.",      "best": false },
			{ "label": "One more season. One more meal.", "best": false },
			{ "label": "I know where danger walks.",   "best": false },
		],
	},
}


func get_ageups() -> Dictionary:
	return AGEUPS
