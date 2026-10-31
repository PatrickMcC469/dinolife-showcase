extends "res://scripts/dinos/base_dino_ageup.gd"

const AGEUPS: Dictionary = {
	1: {
		"stage_label": "Age Up: Hatchling Complete",
		"title": "Fast Enough to Leave the Nest",
		"body": "Your hatchling seasons are behind you. The nest that once felt safe now feels too open, too still, and too easy for hungry eyes to find.\n\nAs a young Lesothosaurus, your greatest gifts are quick feet, sharp awareness, and knowing when to vanish into low plants before danger fully arrives. You are small, but you are not alone. Staying near others of your kind means more eyes watching the brush, more warning chirps, and a better chance that something else gets noticed first.\n\nThe world is large.\n\nSo you will have to be faster.",
		"choices": [
			{ "label": "The nest was never the finish line.", "best": true  },
			{ "label": "Fast feet, open eyes.",              "best": false },
			{ "label": "Stay close. Stay quick.",            "best": false },
			{ "label": "The grass won't hide me forever.",   "best": false },
			{ "label": "Bring it on, life.",                 "best": false },
		],
	},
	2: {
		"stage_label": "Age Up: Juvenile Complete",
		"title": "Quicker Than the Shadow",
		"body": "You are no longer a tiny hatchling stumbling between leaves. Your legs are stronger now, your turns are sharper, and your body knows how to disappear through ferns before danger commits to the chase.\n\nAs a sub-adult Lesothosaurus, the group becomes part of your survival. You listen for warning calls, follow sudden movement, and learn when to scatter with the others instead of freezing alone. You are not built to win a fight with teeth or horns.\n\nYou are built to make the fight never happen.",
		"choices": [
			{ "label": "Let danger chase dust.",          "best": true  },
			{ "label": "I move before fear catches me.",  "best": false },
			{ "label": "The herd runs as one.",           "best": false },
			{ "label": "Small does not mean slow.",       "best": false },
			{ "label": "Every shadow gets a head start.", "best": false },
		],
	},
	3: {
		"stage_label": "Age Up: Sub-Adult Complete",
		"title": "A Survivor on Quick Legs",
		"body": "You have reached adulthood. Your body is lean, your stride is sure, and every sound in the brush means something now.\n\nAs an adult Lesothosaurus, survival is a rhythm: graze, listen, move, scatter, return. You know when to trust the group, when to break away, and when stillness is more dangerous than running. Bigger creatures may tower over you, but size is not the only way to survive the wild.\n\nSome animals endure by being strong.\n\nYou endure by never being where danger lands.",
		"choices": [
			{ "label": "I survive between footsteps.",   "best": true  },
			{ "label": "Too quick to be dinner.",        "best": false },
			{ "label": "The wild has to catch me first.", "best": false },
			{ "label": "Run smart. Live long.",          "best": false },
			{ "label": "Small legs, big instincts.",     "best": false },
		],
	},
	4: {
		"stage_label": "Age Up: Adult Complete",
		"title": "Old Eyes in the Grass",
		"body": "Many seasons have passed beneath your feet. Your sprints are shorter now, but your instincts have become quiet and exact.\n\nYou are an elder Lesothosaurus. You know which bird calls mean nothing, which silences mean teeth, and which paths through the low plants stay safe after rain. Younger members of the group may outrun you, but they still benefit when you notice danger first.\n\nYou have survived by listening to the world before it speaks loudly.\n\nThat wisdom is its own kind of speed.",
		"choices": [
			{ "label": "I hear danger before it moves.",  "best": true  },
			{ "label": "Old feet know safe paths.",       "best": false },
			{ "label": "The group still needs my eyes.",  "best": false },
			{ "label": "I've outrun enough shadows.",     "best": false },
			{ "label": "One more season in the grass.",   "best": false },
		],
	},
}


func get_ageups() -> Dictionary:
	return AGEUPS
