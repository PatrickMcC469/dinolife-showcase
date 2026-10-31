extends "res://scripts/dinos/base_dino_start.gd"

const EVENTS: Array = [
	{
		"id": "velo_hatch_sand",
		"title": "Warm Sand Wiggle",
		"flavor": "The nest sand is still warm beneath your tiny feet, shifting every time you move.",
		"shell_only": false,
		"choices": [
			{
				"label": "Scramble quickly across it",
				"stat": "permanent_speed_mod",
				"result": "The sand tries to slow you. You learn to move faster than it can shift.",
			},
			{
				"label": "Dig your claws in for balance",
				"stat": "permanent_strength_mod",
				"result": "Your claws sink deep. You pull yourself forward. The sand does not win.",
			},
			{
				"label": "Flatten low against the sand",
				"stat": "permanent_defense_mod",
				"result": "Pressed flat and still. The warmth rises around you. Nothing sees you here.",
			},
			{
				"label": "Rest in the warmth",
				"stat": "permanent_health_mod",
				"result": "The heat seeps in from below. You wake up sharper.",
			},
		],
	},
	{
		"id": "velo_hatch_beetle",
		"title": "Beetle in the Dust",
		"flavor": "A dark beetle scuttles through a patch of dry dirt near the nest.",
		"shell_only": false,
		"choices": [
			{
				"label": "Chase it in quick zigzags",
				"stat": "permanent_speed_mod",
				"result": "Left, right, left. You match every turn. It runs out of moves before you do.",
			},
			{
				"label": "Pin it with your tiny foot claws",
				"stat": "permanent_strength_mod",
				"result": "One clean step. It stops. Your claws already know their purpose.",
			},
			{
				"label": "Wait until it comes closer",
				"stat": "permanent_defense_mod",
				"result": "Still as the dirt around you. It walks right to you. Patience works.",
			},
			{
				"label": "Eat it carefully",
				"stat": "permanent_health_mod",
				"result": "Slow and thorough. Nothing wasted. You feel it.",
			},
		],
	},
	{
		"id": "velo_hatch_feather",
		"title": "First Feather Fluff",
		"flavor": "Your soft hatchling feathers puff up in a sudden breeze.",
		"shell_only": false,
		"choices": [
			{
				"label": "Shake and steady yourself",
				"stat": "permanent_speed_mod",
				"result": "Head to tail in one motion. The wind does not catch you twice.",
			},
			{
				"label": "Puff up to look bigger",
				"stat": "permanent_defense_mod",
				"result": "Your feathers rise. You look twice your size. Something in the distance turns away.",
			},
			{
				"label": "Peck stubbornly at stuck shell bits",
				"stat": "permanent_strength_mod",
				"result": "Piece by piece until they are gone. You do not leave things unfinished.",
			},
			{
				"label": "Curl into your feathers for warmth",
				"stat": "permanent_health_mod",
				"result": "Soft and close. You rest well. You wake up ready.",
			},
		],
	},
	{
		"id": "velo_hatch_lizard",
		"title": "The Lizard Dash",
		"flavor": "A tiny lizard darts between two dry roots, almost too fast to follow.",
		"shell_only": false,
		"choices": [
			{
				"label": "Sprint after it",
				"stat": "permanent_speed_mod",
				"result": "You keep up. Barely. But you keep up. That matters.",
			},
			{
				"label": "Snap at its tail",
				"stat": "permanent_strength_mod",
				"result": "Your jaws close on something. You pulled it back. That is enough.",
			},
			{
				"label": "Slip behind the roots for cover",
				"stat": "permanent_defense_mod",
				"result": "You use the same gap the lizard used. Smart. The roots hide you both.",
			},
			{
				"label": "Eat a dropped tail scrap",
				"stat": "permanent_health_mod",
				"result": "Small and warm. Left behind in the panic. Yours now.",
			},
		],
	},
	{
		"id": "velo_hatch_brush",
		"title": "Thorny Brush Gap",
		"flavor": "A small gap opens beneath a thorny desert shrub. It smells safe, but tight.",
		"shell_only": false,
		"choices": [
			{
				"label": "Dart through before the branches sway",
				"stat": "permanent_speed_mod",
				"result": "Clean through before a single thorn grazes you.",
			},
			{
				"label": "Push the dry stems aside",
				"stat": "permanent_strength_mod",
				"result": "They scratch. You push harder. The gap opens.",
			},
			{
				"label": "Crouch beneath the thorns",
				"stat": "permanent_defense_mod",
				"result": "Low and careful. Not a scratch. You know how to use tight spaces.",
			},
			{
				"label": "Nap in the shaded dust",
				"stat": "permanent_health_mod",
				"result": "Cool and hidden. The best rest you have had since hatching.",
			},
		],
	},
	{
		"id": "velo_hatch_slip",
		"title": "Sickle Claw Slip",
		"flavor": "Your curved toe claw catches on a small pebble, making you stumble.",
		"shell_only": false,
		"choices": [
			{
				"label": "Recover with a quick hop",
				"stat": "permanent_speed_mod",
				"result": "Off balance for half a heartbeat. Then gone. Never slowing down again.",
			},
			{
				"label": "Scratch the pebble away",
				"stat": "permanent_strength_mod",
				"result": "The pebble moves. The claw is fine. You made it clear who wins.",
			},
			{
				"label": "Lower your body to stay balanced",
				"stat": "permanent_defense_mod",
				"result": "Low center. Steady legs. The stumble teaches you something permanent.",
			},
			{
				"label": "Stop and regain your breath",
				"stat": "permanent_health_mod",
				"result": "No shame in pausing. You step forward again with more intention.",
			},
		],
	},
	{
		"id": "velo_hatch_shadow",
		"title": "Distant Wing Shadow",
		"flavor": "A flying shadow passes over the nest, and the light disappears for a heartbeat.",
		"shell_only": false,
		"choices": [
			{
				"label": "Dash beneath a root",
				"stat": "permanent_speed_mod",
				"result": "Under cover before the shadow finishes crossing. Nothing found you.",
			},
			{
				"label": "Freeze flat against the ground",
				"stat": "permanent_defense_mod",
				"result": "Still as a stone. The shadow moves on. You were never there.",
			},
			{
				"label": "Snap upward at the shadow",
				"stat": "permanent_strength_mod",
				"result": "Small jaws. Real intention. The instinct is already sharp.",
			},
			{
				"label": "Stay tucked beside the warm eggshells",
				"stat": "permanent_health_mod",
				"result": "The shell still holds warmth. You borrow it a little longer.",
			},
		],
	},
	{
		"id": "velo_hatch_bone",
		"title": "Dry Bone Discovery",
		"flavor": "You find a tiny dry bone half-buried near the nest.",
		"shell_only": false,
		"choices": [
			{
				"label": "Drag it free quickly",
				"stat": "permanent_speed_mod",
				"result": "One sharp pull. It comes loose. You claim it.",
			},
			{
				"label": "Gnaw and crack it",
				"stat": "permanent_strength_mod",
				"result": "Your teeth find the weak point. The crack is loud for something so small.",
			},
			{
				"label": "Hide behind it like cover",
				"stat": "permanent_defense_mod",
				"result": "Small shield. Good instinct. You understand what cover is for.",
			},
			{
				"label": "Lick marrow from the cracks",
				"stat": "permanent_health_mod",
				"result": "Rich and deep. Every last bit. You feel it immediately.",
			},
		],
	},
]


func get_events() -> Array:
	return EVENTS
