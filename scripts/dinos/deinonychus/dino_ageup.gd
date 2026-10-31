extends "res://scripts/dinos/base_dino_ageup.gd"

const AGEUPS: Dictionary = {
	1: {
		"stage_label": "Age Up: Hatchling Complete",
		"title": "The Claw Awakens",
		"body": "Your hatchling seasons are over. The nest that once sheltered you now feels too small for your growing legs, sharper teeth, and oversized sickle claws.\n\nAs a young Deinonychus, you are not built to survive by hiding forever. You are built to learn, stalk, leap, and strike with others at your side. The pack is more than company — it is warning calls, shared hunts, practice fights, and protection when something larger comes too close.\n\nYou are still young. Still vulnerable. But the world is no longer just something to fear.\n\nIt is something to chase.",
		"choices": [
			{ "label": "The hunt begins.",              "best": true  },
			{ "label": "Bring it on, life.",            "best": false },
			{ "label": "Stay with the pack. Strike fast.", "best": false },
			{ "label": "Claws ready. Eyes open.",       "best": false },
			{ "label": "The nest is behind me.",        "best": false },
		],
	},
	2: {
		"stage_label": "Age Up: Juvenile Complete",
		"title": "Learning the Leap",
		"body": "You have grown beyond clumsy pounces and practice bites. Your legs carry you farther now, your balance is steadier, and your sickle claws no longer feel like strange tools — they feel like part of you.\n\nAs a sub-adult Deinonychus, the pack begins to test you harder. You will chase, flank, and learn when to strike and when to wait. Strength matters, but timing matters more. A reckless hunter gets hurt. A patient one eats.\n\nThe easy lessons are over. Now you learn the dangerous ones.",
		"choices": [
			{ "label": "No more practice hunts.",          "best": true  },
			{ "label": "I'll earn my place.",              "best": false },
			{ "label": "Leap fast. Strike true.",          "best": false },
			{ "label": "The pack is watching.",            "best": false },
			{ "label": "I am ready to chase bigger prey.", "best": false },
		],
	},
	3: {
		"stage_label": "Age Up: Sub-Adult Complete",
		"title": "A Hunter in Full",
		"body": "You have reached adulthood. Your body is lean, your claws are deadly, and your instincts now move faster than thought.\n\nAs an adult Deinonychus, you are no longer only following the pack — you are part of what makes it dangerous. You know how to circle prey, how to read a stumble, how to strike where fear has already opened a path. Alone, you are a threat. With the pack, you are a problem the whole valley remembers.\n\nThe world is still full of giants.\n\nGood. Giants leave bigger meals.",
		"choices": [
			{ "label": "Let the giants run.",       "best": true  },
			{ "label": "The pack hunts with me.",   "best": false },
			{ "label": "Claws first. Fear second.", "best": false },
			{ "label": "I was made for this.",      "best": false },
			{ "label": "No prey is safe forever.",  "best": false },
		],
	},
	4: {
		"stage_label": "Age Up: Adult Complete",
		"title": "Scars of the Pack",
		"body": "Seasons have carved their lessons into you. Your feathers are rougher now, your old wounds ache in cold rain, and your fastest days may be behind you — but your mind is sharper than ever.\n\nYou are an elder Deinonychus. You know which prey will break, which rival will bluff, and which silence means danger. Younger hunters may leap first, but you know where the prey will run before it moves. In the pack, that knowledge is worth more than speed.\n\nYour claws still remember.\n\nAnd so does everything that survived you.",
		"choices": [
			{ "label": "Old claws still cut.",           "best": true  },
			{ "label": "I know where prey runs.",        "best": false },
			{ "label": "The pack still listens.",        "best": false },
			{ "label": "Scars teach better than teeth.", "best": false },
			{ "label": "One more hunt.",                 "best": false },
		],
	},
}


func get_ageups() -> Dictionary:
	return AGEUPS
