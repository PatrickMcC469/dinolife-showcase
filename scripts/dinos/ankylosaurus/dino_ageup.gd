extends "res://scripts/dinos/base_dino_ageup.gd"

const AGEUPS: Dictionary = {
	1: {
		"stage_label": "Age Up: Hatchling Complete",
		"title": "Armor Beneath the Shell",
		"body": "Your hatchling seasons are behind you. The nest no longer feels large enough for your wide little body, sturdy legs, and the tiny armor plates hardening across your back.\n\nAs a young Ankylosaurus, survival is not about chasing the world. It is about enduring it. You are learning when to stay low, when to brace, when to shuffle toward cover, and when to trust the armor growing with you.\n\nThe world is full of teeth.\n\nLet them find out you are difficult to chew.",
		"choices": [
			{ "label": "Let life try to bite me.",   "best": true  },
			{ "label": "Bring it on, life.",          "best": false },
			{ "label": "Low, tough, and moving on.",  "best": false },
			{ "label": "The shell days are over.",    "best": false },
			{ "label": "I was built to endure.",      "best": false },
		],
	},
	2: {
		"stage_label": "Age Up: Juvenile Complete",
		"title": "Harder to Hurt",
		"body": "You are no longer a soft little hatchling hiding beside stones and roots. Your body is broader now, your armor is stronger, and your tail is beginning to feel less like a burden and more like a warning.\n\nAs a sub-adult Ankylosaurus, you learn that surviving does not always mean running. Sometimes it means planting your feet, lowering your body, and making danger work harder than it expected. Every season adds weight, patience, and protection.\n\nYou are still growing.\n\nBut already, you are becoming inconvenient.",
		"choices": [
			{ "label": "I am not worth the bite.",    "best": true  },
			{ "label": "Let predators think twice.",  "best": false },
			{ "label": "My armor is learning.",       "best": false },
			{ "label": "I stand low and stubborn.",   "best": false },
			{ "label": "Harder every season.",        "best": false },
		],
	},
	3: {
		"stage_label": "Age Up: Sub-Adult Complete",
		"title": "The Living Bunker",
		"body": "You have reached adulthood. Your armor is thick, your stance is solid, and your tail club carries a message even the hungriest predators understand.\n\nAs an adult Ankylosaurus, you are not fast, flashy, or easy to move. You survive by making every attack costly. Teeth meet plates. Claws meet patience. Anything foolish enough to circle behind you risks learning why your tail is feared.\n\nYou do not need to chase danger.\n\nYou only need to outlast it.",
		"choices": [
			{ "label": "I outlast what hunts me.", "best": true  },
			{ "label": "Come closer. Regret it.",  "best": false },
			{ "label": "Armor first. Tail second.", "best": false },
			{ "label": "I am the problem now.",    "best": false },
			{ "label": "The ground holds with me.", "best": false },
		],
	},
	4: {
		"stage_label": "Age Up: Adult Complete",
		"title": "Stoneback Elder",
		"body": "Seasons have settled heavily into your bones. Your steps are slower now, your plates are worn, and old scars hide between the ridges of your armor.\n\nYou are an elder Ankylosaurus. You know which paths save energy, which shadows mean teeth, and when stillness is stronger than panic. Younger creatures may move faster, but few have learned the quiet power of simply refusing to fall.\n\nThe wild has tried to break you for many seasons.\n\nIt is still waiting.",
		"choices": [
			{ "label": "I have not broken yet.",            "best": true  },
			{ "label": "Old armor still holds.",            "best": false },
			{ "label": "The wild can keep trying.",         "best": false },
			{ "label": "I know when to stand still.",       "best": false },
			{ "label": "One more season beneath my plates.", "best": false },
		],
	},
}


func get_ageups() -> Dictionary:
	return AGEUPS
