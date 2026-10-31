extends "res://scripts/dinos/base_dino_ageup.gd"

const AGEUPS: Dictionary = {
	1: {
		"stage_label": "Age Up: Hatchling Complete",
		"title": "First Steps of a Hunter",
		"body": "Your hatchling seasons are behind you. The nest no longer feels safe enough or large enough for your growing legs, hungry jaws, and restless instincts.\n\nAs a young Allosaurus, you are beginning to understand the world through movement, scent, and opportunity. You are not the biggest predator yet, but your bite is stronger, your feet are steadier, and every rustle in the brush feels like something worth investigating.\n\nThe wild will not protect you.\n\nSo you will learn to take what you need from it.",
		"choices": [
			{ "label": "The wild owes me nothing.",       "best": true  },
			{ "label": "Bring it on, life.",              "best": false },
			{ "label": "Teeth first. Fear later.",        "best": false },
			{ "label": "I'm done hiding in the nest.",    "best": false },
			{ "label": "Time to grow dangerous.",         "best": false },
		],
	},
	2: {
		"stage_label": "Age Up: Juvenile Complete",
		"title": "Bigger Prey, Bigger Risks",
		"body": "You are no longer a stumbling youngster snapping at beetles and scraps. Your body has stretched taller, your jaws have grown stronger, and your instincts now pull you farther from safety.\n\nAs a sub-adult Allosaurus, the easy meals are no longer enough. You begin testing larger prey, following blood trails, and learning when to lunge — and when to wait. Every hunt teaches you something. Every mistake leaves a mark.\n\nYou are still growing.\n\nSo are the dangers.",
		"choices": [
			{ "label": "I'll earn every bite.",       "best": true  },
			{ "label": "Bigger prey won't scare me.", "best": false },
			{ "label": "No more easy meals.",         "best": false },
			{ "label": "I learn with tooth and scar.", "best": false },
			{ "label": "The hunt is getting real.",   "best": false },
		],
	},
	3: {
		"stage_label": "Age Up: Sub-Adult Complete",
		"title": "Apex of the Jurassic",
		"body": "You have reached adulthood. Your legs are powerful, your jaws are built for tearing, and your presence changes the way smaller creatures move through the forest.\n\nAs an adult Allosaurus, you are no longer testing the wild — the wild is testing you. You can stalk, ambush, chase, and punish weakness when you find it. But power does not mean safety. Rivals, wounds, hunger, and giants with dangerous tails can still end a careless hunter.\n\nYou are strong enough to rule.\n\nNow you must be smart enough to keep living.",
		"choices": [
			{ "label": "Power is not permission to be careless.", "best": true  },
			{ "label": "I am the danger now.",                    "best": false },
			{ "label": "Let the valley hear me coming.",          "best": false },
			{ "label": "Every scar made me sharper.",             "best": false },
			{ "label": "The hunt belongs to me.",                 "best": false },
		],
	},
	4: {
		"stage_label": "Age Up: Adult Complete",
		"title": "The Old Blade",
		"body": "Seasons have carved their history into you. Old wounds pull at your stride, and younger predators may move with more fire, but they do not know the valley like you do.\n\nYou are an elder Allosaurus. You know which herds panic, which giants swing their tails first, and which trails carry the smell of an easy meal after rain. You may not waste energy on every chase anymore — but when you choose to strike, it is because experience has already found the opening.\n\nYour body has slowed.\n\nYour hunger has not.",
		"choices": [
			{ "label": "Old teeth still tear.",           "best": true  },
			{ "label": "I know where weakness walks.",    "best": false },
			{ "label": "The valley remembers my bite.",   "best": false },
			{ "label": "One more hunt. One more scar.",   "best": false },
			{ "label": "I survived by learning.",         "best": false },
		],
	},
}


func get_ageups() -> Dictionary:
	return AGEUPS
