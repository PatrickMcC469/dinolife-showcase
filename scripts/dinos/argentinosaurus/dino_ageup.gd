extends "res://scripts/dinos/base_dino_ageup.gd"

const AGEUPS: Dictionary = {
	1: {
		"stage_label": "Age Up: Hatchling Complete",
		"title": "Small Steps Toward Giant Days",
		"body": "Your hatchling seasons are behind you. The nest no longer feels big enough for your stretching neck, heavy feet, and growing need to follow the herd.\n\nAs a young Argentinosaurus, survival means staying close to the massive bodies around you. The herd is shade, warning, protection, and direction. You are still small enough for danger to notice, but every season adds height, weight, and promise.\n\nOne day, the world will feel small beneath you.\n\nFor now, keep up.",
		"choices": [
			{ "label": "The herd moves. I follow.",      "best": true  },
			{ "label": "Bring it on, life.",             "best": false },
			{ "label": "Small now. Giant later.",        "best": false },
			{ "label": "One step closer to enormous.",   "best": false },
			{ "label": "Stay close. Grow tall.",         "best": false },
		],
	},
	2: {
		"stage_label": "Age Up: Juvenile Complete",
		"title": "Growing Beyond the Grass",
		"body": "You are no longer a tiny long-neck stumbling between adult footsteps. Your stride is longer now, your neck reaches higher, and the herd's path begins to feel like something you can truly follow.\n\nAs a sub-adult Argentinosaurus, your size is becoming protection, but not safety. Predators still watch for the separated, the weak, and the careless. Your best defense is movement with the herd, steady eating, and growing too large to threaten easily.\n\nYou are not a giant yet.\n\nBut the ground is starting to believe you.",
		"choices": [
			{ "label": "Keep growing. Keep moving.",    "best": true  },
			{ "label": "The ground knows my steps.",   "best": false },
			{ "label": "I will not fall behind.",      "best": false },
			{ "label": "Higher leaves are waiting.",   "best": false },
			{ "label": "The herd carries me forward.", "best": false },
		],
	},
	3: {
		"stage_label": "Age Up: Sub-Adult Complete",
		"title": "The Giant Walks",
		"body": "You have reached adulthood. Your neck rises above the trees, your steps shake the earth, and the world must make room when you move.\n\nAs an adult Argentinosaurus, survival is no longer about hiding. It is about endurance, herd strength, and the sheer power of being enormous. Predators may still test the edges, but few things dare challenge the full weight of a grown giant surrounded by others.\n\nYou do not rule with teeth or claws.\n\nYou rule by being impossible to ignore.",
		"choices": [
			{ "label": "Make room for the giant.", "best": true  },
			{ "label": "The earth moves with me.", "best": false },
			{ "label": "I am beyond easy prey.",   "best": false },
			{ "label": "The herd stands tall.",    "best": false },
			{ "label": "Let the world look up.",   "best": false },
		],
	},
	4: {
		"stage_label": "Age Up: Adult Complete",
		"title": "Ancient as the Trail",
		"body": "Many seasons have passed beneath your massive feet. Your steps are slower now, but each one carries the memory of rivers crossed, forests emptied, storms endured, and herds kept moving.\n\nYou are an elder Argentinosaurus. Younger giants may have fresher strength, but you know the old paths: where the tallest trees recover, where water waits after drought, and where danger gathers before it shows itself. The herd still benefits from your memory.\n\nYou are not just large.\n\nYou are living history.",
		"choices": [
			{ "label": "The old paths remember me.",      "best": true  },
			{ "label": "I still move mountains.",         "best": false },
			{ "label": "The herd follows ancient steps.", "best": false },
			{ "label": "One more season beneath the sky.", "best": false },
			{ "label": "I have carried many years.",      "best": false },
		],
	},
}


func get_ageups() -> Dictionary:
	return AGEUPS
