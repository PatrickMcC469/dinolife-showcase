extends "res://scripts/dinos/base_dino_ageup.gd"

const AGEUPS: Dictionary = {
	1: {
		"stage_label": "Age Up: Hatchling Complete",
		"title": "First Steps with the Herd",
		"body": "Your hatchling seasons are behind you. The nest no longer feels like enough shelter for your growing body, stronger legs, and curious appetite.\n\nAs a young Iguanodon, survival means learning the rhythm of the herd. Their footsteps show safe paths. Their warning calls teach when to freeze, flee, or press close. You are still small, but your body is already preparing for a future of sturdy strength, steady travel, and thumb-spiked defense.\n\nThe world is wide, green, and dangerous.\n\nStay close. Keep moving. Grow strong.",
		"choices": [
			{ "label": "The herd moves on. So do I.", "best": true  },
			{ "label": "Bring it on, life.",          "best": false },
			{ "label": "Stay close. Grow strong.",    "best": false },
			{ "label": "My first trail begins.",      "best": false },
			{ "label": "The nest is behind me.",      "best": false },
		],
	},
	2: {
		"stage_label": "Age Up: Juvenile Complete",
		"title": "Finding Your Footing",
		"body": "You are no longer a tiny follower stumbling after larger shadows. Your stride is steadier now, your body stronger, and your thumb spikes are becoming more than strange little tools at your sides.\n\nAs a sub-adult Iguanodon, you begin learning when to browse, when to travel, and when to stand your ground. The herd still protects you, but it also expects you to keep up. Every trail teaches endurance. Every warning call teaches judgment.\n\nYou are not helpless anymore.\n\nBut you are not safe enough to be careless.",
		"choices": [
			{ "label": "I'll keep pace.",                  "best": true  },
			{ "label": "Strong legs. Sharper instincts.",  "best": false },
			{ "label": "The herd won't wait forever.",     "best": false },
			{ "label": "I know when to run.",              "best": false },
			{ "label": "I know when to stand.",            "best": false },
		],
	},
	3: {
		"stage_label": "Age Up: Sub-Adult Complete",
		"title": "Sturdy as the Trail",
		"body": "You have reached adulthood. Your body is powerful, your steps are sure, and your thumb spikes are ready to remind predators that not every meal is worth the cost.\n\nAs an adult Iguanodon, you are a reliable survivor of the herd: strong enough to travel far, alert enough to sense danger, and tough enough to defend yourself when fleeing is no longer enough. You are not built for pointless fights, but you are no easy target.\n\nThe wild may test you.\n\nLet it learn slowly.",
		"choices": [
			{ "label": "I am no easy meal.",            "best": true  },
			{ "label": "The trail belongs to the strong.", "best": false },
			{ "label": "Let danger think twice.",       "best": false },
			{ "label": "My herd walks with me.",        "best": false },
			{ "label": "Steady feet. Sharper spikes.",  "best": false },
		],
	},
	4: {
		"stage_label": "Age Up: Adult Complete",
		"title": "The Old Trailkeeper",
		"body": "Seasons have worn familiar paths beneath your feet. Your stride is slower now, but your memory is deep: where the best plants grow after rain, where predators wait near narrow passes, and when the herd should move before danger appears.\n\nYou are an elder Iguanodon. Younger herd members may have more strength, but you carry the knowledge that keeps them alive. You know which trails are safe, which sounds are warnings, and when a quiet forest is no longer peaceful.\n\nYour body has aged.\n\nYour instincts have not.",
		"choices": [
			{ "label": "I know the old paths.",           "best": true  },
			{ "label": "The herd still follows wisdom.",  "best": false },
			{ "label": "Old spikes still warn predators.", "best": false },
			{ "label": "I remember where danger waits.",  "best": false },
			{ "label": "One more trail. One more season.", "best": false },
		],
	},
}


func get_ageups() -> Dictionary:
	return AGEUPS
