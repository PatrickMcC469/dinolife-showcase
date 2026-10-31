extends "res://scripts/dinos/base_dino_ageup.gd"

const AGEUPS: Dictionary = {
	1: {
		"stage_label": "Age Up: Hatchling Complete",
		"title": "Little Horns, Big World",
		"body": "Your hatchling seasons are behind you. The nest no longer feels large enough for your sturdy legs, growing frill, and tiny horn nubs that keep bumping into everything.\n\nAs a young Triceratops, survival means staying close to the herd and learning when to move, when to freeze, and when to lower your head. The adults are your wall against danger, but one day those horns will be yours to carry.\n\nThe world is full of teeth.\n\nGood. Let them learn you have points.",
		"choices": [
			{ "label": "The herd stands with me.",    "best": true  },
			{ "label": "Little horns, big attitude.", "best": false },
			{ "label": "Bring it on, life.",          "best": false },
			{ "label": "I'll grow into these horns.", "best": false },
			{ "label": "The nest is behind me.",      "best": false },
		],
	},
	2: {
		"stage_label": "Age Up: Juvenile Complete",
		"title": "Learning to Stand Ground",
		"body": "You are no longer a tiny calf hiding beneath larger bodies. Your frill is broader now, your horns are sharper, and your legs are strong enough to carry you farther with the herd.\n\nAs a sub-adult Triceratops, you begin learning the balance of survival: graze while the herd watches, move when the adults move, and stand firm when running is not enough. You are still growing, but predators can no longer look at you and see only an easy meal.\n\nYour courage is young.\n\nYour horns are catching up.",
		"choices": [
			{ "label": "I won't be pushed aside.",      "best": true  },
			{ "label": "Stand firm. Stay with the herd.", "best": false },
			{ "label": "Let danger think twice.",       "best": false },
			{ "label": "My horns are learning.",        "best": false },
			{ "label": "The herd moves like a wall.",   "best": false },
		],
	},
	3: {
		"stage_label": "Age Up: Sub-Adult Complete",
		"title": "The Living Shield",
		"body": "You have reached adulthood. Your horns are heavy, your frill is strong, and your body carries the kind of power that makes predators hesitate before stepping too close.\n\nAs an adult Triceratops, you are not just surviving with the herd — you are part of its defense. Calves shelter behind you. Rivals test you. Predators circle and wonder if hunger is worth the pain. You do not need to chase danger.\n\nYou only need to make it regret coming closer.",
		"choices": [
			{ "label": "Come closer and learn.",  "best": true  },
			{ "label": "I am the wall now.",       "best": false },
			{ "label": "The herd is behind me.",   "best": false },
			{ "label": "Let teeth meet horn.",     "best": false },
			{ "label": "I stand where others hide.", "best": false },
		],
	},
	4: {
		"stage_label": "Age Up: Adult Complete",
		"title": "Horns of the Old Guard",
		"body": "Seasons have carved marks into your frill and weight into your stride. Your charges may be slower now, but every scar tells the herd you have stood between life and danger before.\n\nYou are an elder Triceratops. You know when a predator is truly hunting, when a rival is only boasting, and when the herd must form tight before panic spreads. Younger adults may have fresher strength, but they still look to you when the ground starts to shake.\n\nAge has not made you soft.\n\nIt has made you certain.",
		"choices": [
			{ "label": "Old horns still hold the line.",      "best": true  },
			{ "label": "The herd remembers my stand.",        "best": false },
			{ "label": "I know when danger means it.",        "best": false },
			{ "label": "Scars are just warnings with history.", "best": false },
			{ "label": "One more season on the front line.",  "best": false },
		],
	},
}


func get_ageups() -> Dictionary:
	return AGEUPS
