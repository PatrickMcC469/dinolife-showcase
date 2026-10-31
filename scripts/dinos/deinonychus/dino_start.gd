extends "res://scripts/dinos/base_dino_start.gd"

const EVENTS: Array = [
	{
		"id": "dein_hatch_sickle",
		"title": "First Sickle Claw",
		"flavor": "Your oversized toe claw catches against the nest floor as you take your first steps.",
		"shell_only": false,
		"choices": [
			{
				"label": "Scratch the ground with it",
				"stat": "permanent_strength_mod",
				"result": "The earth gives. The claw holds. You feel what it was made for.",
			},
			{
				"label": "Practice lifting your foot cleanly",
				"stat": "permanent_speed_mod",
				"result": "Each step gets lighter. By the tenth, you barely touch the ground.",
			},
			{
				"label": "Curl low and guard your belly",
				"stat": "permanent_defense_mod",
				"result": "Claw up, body low. Nothing can reach what you protect.",
			},
			{
				"label": "Rest after the effort",
				"stat": "permanent_health_mod",
				"result": "You breathe slowly. The claw settles. You feel ready.",
			},
		],
	},
	{
		"id": "dein_hatch_feather",
		"title": "Feather Shake",
		"flavor": "Your damp hatchling feathers cling to your body after breaking free from the egg.",
		"shell_only": false,
		"choices": [
			{
				"label": "Shake yourself dry quickly",
				"stat": "permanent_speed_mod",
				"result": "The motion spreads from neck to tail. Fast and decisive.",
			},
			{
				"label": "Puff up to look larger",
				"stat": "permanent_defense_mod",
				"result": "Your feathers rise. You look twice your size. It feels true.",
			},
			{
				"label": "Peck stubbornly at stuck shell",
				"stat": "permanent_strength_mod",
				"result": "Piece by piece. You do not stop until it is gone.",
			},
			{
				"label": "Settle under warm feathers or shade",
				"stat": "permanent_health_mod",
				"result": "The warmth seeps in. You dry slowly. You feel whole.",
			},
		],
	},
	{
		"id": "dein_hatch_grub",
		"title": "The Wriggling Grub",
		"flavor": "A fat grub twists in the nest bedding, just close enough to grab.",
		"shell_only": false,
		"choices": [
			{
				"label": "Snap it up fast",
				"stat": "permanent_speed_mod",
				"result": "Gone before it knew you were there.",
			},
			{
				"label": "Crush it in your jaws",
				"stat": "permanent_strength_mod",
				"result": "It stops wriggling immediately. Your bite is already something.",
			},
			{
				"label": "Pin it carefully with your foot",
				"stat": "permanent_defense_mod",
				"result": "Claw flat, patience steady. You hold it until you are ready.",
			},
			{
				"label": "Eat it slowly for energy",
				"stat": "permanent_health_mod",
				"result": "Every bite deliberate. You feel it settle into your bones.",
			},
		],
	},
	{
		"id": "dein_hatch_sibling",
		"title": "Sibling Pounce",
		"flavor": "Another hatchling bumps into you, then crouches like it wants to play-fight.",
		"shell_only": false,
		"choices": [
			{
				"label": "Pounce first",
				"stat": "permanent_speed_mod",
				"result": "You move before they finish crouching. They did not expect that.",
			},
			{
				"label": "Shove back harder",
				"stat": "permanent_strength_mod",
				"result": "They stumble. You stay planted. The lesson is clear.",
			},
			{
				"label": "Tuck your head and absorb the bump",
				"stat": "permanent_defense_mod",
				"result": "They bounce off. You barely move. They look confused.",
			},
			{
				"label": "Break away and rest",
				"stat": "permanent_health_mod",
				"result": "Not every fight is worth having. You know this already.",
			},
		],
	},
	{
		"id": "dein_hatch_shadow",
		"title": "Shadow at the Nest Edge",
		"flavor": "Something moves beyond the nest. You cannot tell if it is food, family, or danger.",
		"shell_only": false,
		"choices": [
			{
				"label": "Dart toward cover",
				"stat": "permanent_speed_mod",
				"result": "You are hidden before the shadow resolves. Smart instinct.",
			},
			{
				"label": "Raise your claws defensively",
				"stat": "permanent_defense_mod",
				"result": "Small but ready. Whatever it is, it sees you are not easy.",
			},
			{
				"label": "Snap your jaws at the shadow",
				"stat": "permanent_strength_mod",
				"result": "The sound of your bite surprises even you.",
			},
			{
				"label": "Stay close to the warm nest",
				"stat": "permanent_health_mod",
				"result": "The shadow passes. You conserved everything. Good call.",
			},
		],
	},
	{
		"id": "dein_hatch_stalk",
		"title": "First Stalk",
		"flavor": "A tiny insect crawls across a patch of light. Your body lowers without thinking.",
		"shell_only": false,
		"choices": [
			{
				"label": "Sneak closer step by step",
				"stat": "permanent_defense_mod",
				"result": "Each step placed softly. The insect never looks up.",
			},
			{
				"label": "Burst forward suddenly",
				"stat": "permanent_speed_mod",
				"result": "Zero to full speed in one breath. You were born knowing how.",
			},
			{
				"label": "Bite down hard when you reach it",
				"stat": "permanent_strength_mod",
				"result": "No hesitation. The strike is clean.",
			},
			{
				"label": "Eat it and stay near the nest",
				"stat": "permanent_health_mod",
				"result": "First catch. First meal. The nest feels like yours.",
			},
		],
	},
	{
		"id": "dein_hatch_shells",
		"title": "Climbing Over Shells",
		"flavor": "Broken eggshells and nest debris create a tiny obstacle field.",
		"shell_only": true,
		"choices": [
			{
				"label": "Scramble over quickly",
				"stat": "permanent_speed_mod",
				"result": "Feet barely touch each piece before you are past it.",
			},
			{
				"label": "Push through the biggest shell pieces",
				"stat": "permanent_strength_mod",
				"result": "You clear the path. The debris moves. You do not.",
			},
			{
				"label": "Move carefully without falling",
				"stat": "permanent_defense_mod",
				"result": "Slow and deliberate. Not a single stumble.",
			},
			{
				"label": "Pause between shell pieces to recover",
				"stat": "permanent_health_mod",
				"result": "Rest is not weakness. You finish the crossing stronger.",
			},
		],
	},
	{
		"id": "dein_hatch_chirp",
		"title": "Tiny Warning Chirp",
		"flavor": "An older Deinonychus gives a sharp call nearby, and every hatchling freezes.",
		"shell_only": false,
		"choices": [
			{
				"label": "Freeze low to the ground",
				"stat": "permanent_defense_mod",
				"result": "Flat and still. Whatever was looking finds nothing.",
			},
			{
				"label": "Sprint toward the safest shadow",
				"stat": "permanent_speed_mod",
				"result": "You move the instant the call ends. First to cover.",
			},
			{
				"label": "Bare your tiny teeth",
				"stat": "permanent_strength_mod",
				"result": "Small teeth. Real intention. You hold your ground.",
			},
			{
				"label": "Stay still and breathe slowly",
				"stat": "permanent_health_mod",
				"result": "Calm spreads through you. The danger passes. You saved your energy.",
			},
		],
	},
]


func get_events() -> Array:
	return EVENTS
