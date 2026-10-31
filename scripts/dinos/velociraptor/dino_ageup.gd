extends "res://scripts/dinos/base_dino_ageup.gd"

const AGEUPS: Dictionary = {
	1: {
		"stage_label": "Age Up: Hatchling Complete",
		"title": "Out of the Nest, Into the Dust",
		"body": "Your hatchling seasons are behind you. The nest no longer feels like the whole world — now there are dry roots, shifting sand, low brush, and quick little things that vanish if you blink.\n\nAs a young Velociraptor, survival is about speed, patience, and staying aware. You are not the strongest predator in the wild, but you are clever, light-footed, and dangerous when you choose your moment. If others of your kind are nearby, their calls and movements can help you spot danger before it finds you.\n\nThe world is wide, hungry, and full of shadows.\n\nGood thing you were born quick.",
		"choices": [
			{ "label": "Quick feet. Sharp eyes.",  "best": true  },
			{ "label": "The dust won't catch me.", "best": false },
			{ "label": "Bring it on, life.",       "best": false },
			{ "label": "Stay low. Move fast.",     "best": false },
			{ "label": "The nest is behind me.",   "best": false },
		],
	},
	2: {
		"stage_label": "Age Up: Juvenile Complete",
		"title": "A Hunter in the Brush",
		"body": "You are faster now. Your feathers sit smoother, your claws grip better, and your body knows how to move through dry grass without wasting motion.\n\nAs a sub-adult Velociraptor, you are learning that survival is not just chasing — it is choosing. Choose the right path. Choose the right cover. Choose the right moment to sprint, snap, or disappear. Other raptors may help you find food or avoid danger, but every mistake still belongs to you.\n\nYou are no longer just surviving near the nest.\n\nYou are learning the wild.",
		"choices": [
			{ "label": "Wait. Watch. Strike.",        "best": true  },
			{ "label": "I know the brush now.",       "best": false },
			{ "label": "Fast is good. Clever is better.", "best": false },
			{ "label": "No shadow surprises me.",     "best": false },
			{ "label": "The wild has my scent.",      "best": false },
		],
	},
	3: {
		"stage_label": "Age Up: Sub-Adult Complete",
		"title": "Small, Sharp, and Dangerous",
		"body": "You have reached adulthood. Your steps are quiet, your turns are quick, and your sickle claws no longer feel like weapons you carry — they feel like promises.\n\nAs an adult Velociraptor, you survive through precision. You are not built to overpower every threat, but you are built to outmaneuver them. You know how to use brush, dust, rocks, and timing. With your kind nearby, even a small hunter can become part of a deadly pattern.\n\nThe giants may own the open ground.\n\nYou own the spaces between.",
		"choices": [
			{ "label": "I own the spaces between.",    "best": true  },
			{ "label": "Small does not mean safe.",    "best": false },
			{ "label": "Let the giants look down.",    "best": false },
			{ "label": "I strike where they cannot turn.", "best": false },
			{ "label": "Fast teeth. Quiet feet.",      "best": false },
		],
	},
	4: {
		"stage_label": "Age Up: Adult Complete",
		"title": "Dust-Wise Survivor",
		"body": "Many seasons have passed beneath your feet. Your feathers are worn, your old scars tug when the air changes, and your bursts of speed are shorter than they once were — but your instincts have become razor-clean.\n\nYou are an elder Velociraptor. You know when the wind hides your scent, when dry grass will betray your steps, and when a larger predator is too focused to notice something small circling behind it. Younger raptors may be faster, but you waste less movement.\n\nThe wild has tried to swallow you for seasons.\n\nIt is still chewing.",
		"choices": [
			{ "label": "I've survived every shadow.",  "best": true  },
			{ "label": "Old tracks still lead to food.", "best": false },
			{ "label": "I know where danger sleeps.", "best": false },
			{ "label": "The dust remembers me.",       "best": false },
			{ "label": "One more clever season.",      "best": false },
		],
	},
}


func get_ageups() -> Dictionary:
	return AGEUPS
