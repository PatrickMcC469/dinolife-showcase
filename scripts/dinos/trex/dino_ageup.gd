extends "res://scripts/dinos/base_dino_ageup.gd"

const AGEUPS: Dictionary = {
	1: {
		"stage_label": "Age Up: Hatchling Complete",
		"title": "Too Big for the Nest",
		"body": "Your hatchling seasons are over. The nest that once held your whole world now feels cramped beneath your growing feet, heavy head, and restless hunger.\n\nAs a young T-Rex, you are still far from the giant you may become, but the signs are already there: a stronger bite, a sharper nose, and the stubborn will to keep moving even when the world towers over you. You are not safe yet. Not even close.\n\nBut you are growing into something the wild will one day fear.",
		"choices": [
			{ "label": "The nest can't hold me now.", "best": true  },
			{ "label": "Bring it on, life.",          "best": false },
			{ "label": "Bigger teeth. Bigger trouble.", "best": false },
			{ "label": "I was born hungry.",           "best": false },
			{ "label": "The world gets one warning.", "best": false },
		],
	},
	2: {
		"stage_label": "Age Up: Juvenile Complete",
		"title": "Hunger Finds Its Shape",
		"body": "You are no longer just a clumsy young predator with oversized feet and a dangerous mouth. Your body is stretching taller, your stride is stronger, and your senses pull you toward food before you even see it.\n\nAs a sub-adult T-Rex, the world begins to change around you. Smaller creatures flee sooner. Rivals watch you more carefully. Every meal matters, and every wound can decide whether you become a ruler — or a memory.\n\nYou are not king yet.\n\nBut the crown has teeth marks in it.",
		"choices": [
			{ "label": "I'll bite my way there.",  "best": true  },
			{ "label": "The crown can wait.",       "best": false },
			{ "label": "I smell my future.",        "best": false },
			{ "label": "No easy meals. No mercy.",  "best": false },
			{ "label": "Let them start running.",   "best": false },
		],
	},
	3: {
		"stage_label": "Age Up: Sub-Adult Complete",
		"title": "The Tyrant Stands",
		"body": "You have reached adulthood. Your footsteps carry weight, your jaws carry ruin, and the valley grows quieter when your scent moves through it.\n\nAs an adult T-Rex, you are no longer surviving beneath the shadow of larger threats. You are the shadow. Your bite can end fights quickly, your size demands space, and your hunger shapes every choice you make. But even kings bleed. Careless power invites broken bones, rival teeth, and desperate prey that fights harder than expected.\n\nYou are mighty now.\n\nStay alive long enough to prove it.",
		"choices": [
			{ "label": "Let the valley remember me.", "best": true  },
			{ "label": "I am the shadow now.",        "best": false },
			{ "label": "Long live the bite.",         "best": false },
			{ "label": "Power still has to survive.", "best": false },
			{ "label": "The crown is mine to keep.",  "best": false },
		],
	},
	4: {
		"stage_label": "Age Up: Adult Complete",
		"title": "King of Old Scars",
		"body": "Seasons have settled into your bones. Your stride is heavier now, your old wounds ache before storms, and younger challengers may mistake age for weakness.\n\nThey will learn.\n\nYou are an elder T-Rex. You know where herds break, where carrion waits, where rivals bluff, and when a single bite is worth more than a long chase. You may not rule by speed anymore. You rule by memory, patience, and the terrible certainty of jaws that have ended too many stories to count.\n\nThe world has survived you this long.\n\nThat was generous of you.",
		"choices": [
			{ "label": "Old kings still bite.",          "best": true  },
			{ "label": "My scars are warnings.",         "best": false },
			{ "label": "The valley still knows my name.", "best": false },
			{ "label": "One more reign.",                "best": false },
			{ "label": "Let the young ones try.",        "best": false },
		],
	},
}


func get_ageups() -> Dictionary:
	return AGEUPS
