extends "res://scripts/dinos/base_dino_start.gd"

const EVENTS: Array = [
	{
		"id": "comp_hatch_lizard",
		"title": "The Tiny Lizard",
		"flavor": "A tiny lizard freezes on a warm stone, flicking its tongue at you.",
		"shell_only": false,
		"choices": [
			{
				"label": "Chase it across the stone",
				"stat": "permanent_speed_mod",
				"result": "Your legs find a rhythm on the warm rock. Something clicks.",
			},
			{
				"label": "Snap at it before it escapes",
				"stat": "permanent_strength_mod",
				"result": "Your jaw closes faster than you expected. Satisfying.",
			},
			{
				"label": "Watch how it hides",
				"stat": "permanent_defense_mod",
				"result": "You study it until it vanishes. You remember every move.",
			},
			{
				"label": "Eat the leftover tail scrap",
				"stat": "permanent_health_mod",
				"result": "Small. Warm. Enough.",
			},
		],
	},
	{
		"id": "comp_hatch_shell",
		"title": "Cracked Shell Scramble",
		"flavor": "Pieces of your own eggshell still lie around the nest.",
		"shell_only": true,
		"choices": [
			{
				"label": "Push through the shell pieces",
				"stat": "permanent_strength_mod",
				"result": "The fragments give way. You are stronger than the thing that held you.",
			},
			{
				"label": "Duck under the largest shell shard",
				"stat": "permanent_defense_mod",
				"result": "You learn the shape of cover before you learn the shape of danger.",
			},
			{
				"label": "Nibble the membrane inside",
				"stat": "permanent_health_mod",
				"result": "It tastes like the beginning. You feel steadier.",
			},
			{
				"label": "Dart away from the nest quickly",
				"stat": "permanent_speed_mod",
				"result": "The nest falls behind you fast. The world opens up.",
			},
		],
	},
	{
		"id": "comp_hatch_beetle",
		"title": "Beetle Under the Leaf",
		"flavor": "A shiny beetle crawls beneath a curled leaf.",
		"shell_only": false,
		"choices": [
			{
				"label": "Pounce before it burrows",
				"stat": "permanent_speed_mod",
				"result": "You land exactly where it was going. It never had a chance.",
			},
			{
				"label": "Crunch through its hard shell",
				"stat": "permanent_strength_mod",
				"result": "Your teeth find the seam. It takes effort. You enjoy the effort.",
			},
			{
				"label": "Hide under the leaf with it",
				"stat": "permanent_defense_mod",
				"result": "Still and quiet, pressed flat. Nothing finds you here.",
			},
			{
				"label": "Eat it slowly and fully",
				"stat": "permanent_health_mod",
				"result": "Every piece of it becomes part of you. You feel full in a way that lasts.",
			},
		],
	},
	{
		"id": "comp_hatch_tremor",
		"title": "Giant Footstep Tremor",
		"flavor": "The ground shakes as something huge walks nearby.",
		"shell_only": false,
		"choices": [
			{
				"label": "Sprint away between roots",
				"stat": "permanent_speed_mod",
				"result": "The gap is narrow. You slip through it anyway.",
			},
			{
				"label": "Brace against the shaking ground",
				"stat": "permanent_defense_mod",
				"result": "You hold. The world shakes around you. You do not fall.",
			},
			{
				"label": "Climb over a fallen twig barrier",
				"stat": "permanent_strength_mod",
				"result": "Your legs push harder than they should be able to. You make it over.",
			},
			{
				"label": "Stay still and conserve energy",
				"stat": "permanent_health_mod",
				"result": "The footsteps pass. You saved yourself by doing nothing. Smart.",
			},
		],
	},
	{
		"id": "comp_hatch_sibling",
		"title": "Sibling Food Fight",
		"flavor": "Another hatchling finds a small scrap of meat and squeaks proudly.",
		"shell_only": false,
		"choices": [
			{
				"label": "Snatch it and run",
				"stat": "permanent_speed_mod",
				"result": "Gone before they can react. The scrap is yours.",
			},
			{
				"label": "Wrestle for the scrap",
				"stat": "permanent_strength_mod",
				"result": "They squeak louder. You hold tighter. You win.",
			},
			{
				"label": "Shield your face from pecks",
				"stat": "permanent_defense_mod",
				"result": "You take the hits. You do not drop what you are protecting.",
			},
			{
				"label": "Share and eat what remains",
				"stat": "permanent_health_mod",
				"result": "Half is still something. You eat calmly while they stare.",
			},
		],
	},
	{
		"id": "comp_hatch_fern",
		"title": "Fern Tunnel",
		"flavor": "A tiny tunnel beneath low ferns looks just big enough for you.",
		"shell_only": false,
		"choices": [
			{
				"label": "Dash through it fast",
				"stat": "permanent_speed_mod",
				"result": "Out the other side before the ferns stop moving.",
			},
			{
				"label": "Push through the thick stems",
				"stat": "permanent_strength_mod",
				"result": "The ferns resist. You push harder. They bend.",
			},
			{
				"label": "Crouch low and use it as cover",
				"stat": "permanent_defense_mod",
				"result": "Invisible to anything passing above. You stay until you are ready.",
			},
			{
				"label": "Rest safely in the shade",
				"stat": "permanent_health_mod",
				"result": "Cool and quiet. You wake up feeling sharper than before.",
			},
		],
	},
]


func get_events() -> Array:
	return EVENTS
