extends "res://scripts/dinos/base_dino_start.gd"

const EVENTS: Array = [
	{
		"id": "anky_hatch_armor",
		"title": "First Armor Bump",
		"flavor": "Tiny bony plates along your back scrape against a broken eggshell.",
		"shell_only": true,
		"choices": [
			{
				"label": "Push through the shell pieces",
				"stat": "permanent_strength_mod",
				"result": "The plates scrape and hold. You push until the shell moves. You do not.",
			},
			{
				"label": "Tuck low beneath your little armor bumps",
				"stat": "permanent_defense_mod",
				"result": "Low and covered. The shell scrapes across your plates and not your skin.",
			},
			{
				"label": "Shuffle around the shell quickly",
				"stat": "permanent_speed_mod",
				"result": "Wide arc, quick feet. You find the way around before it becomes a problem.",
			},
			{
				"label": "Rest beside the warm shell fragments",
				"stat": "permanent_health_mod",
				"result": "Still warm from the inside. You settle against them and feel whole.",
			},
		],
	},
	{
		"id": "anky_hatch_moss",
		"title": "Soft Moss Patch",
		"flavor": "A patch of soft moss grows beside the nest, damp and easy to chew.",
		"shell_only": false,
		"choices": [
			{
				"label": "Eat the thickest moss",
				"stat": "permanent_health_mod",
				"result": "Cool and dense. Your first real meal. You feel it settle in.",
			},
			{
				"label": "Pull up the roots underneath",
				"stat": "permanent_strength_mod",
				"result": "The roots resist. You pull harder. The whole patch comes loose.",
			},
			{
				"label": "Hurry over before another hatchling reaches it",
				"stat": "permanent_speed_mod",
				"result": "Surprisingly quick for a wide little body. You get there first.",
			},
			{
				"label": "Eat while crouched against a stone",
				"stat": "permanent_defense_mod",
				"result": "Stone at your back, moss in your mouth. Nothing approaches from behind.",
			},
		],
	},
	{
		"id": "anky_hatch_tail",
		"title": "Tail Drag",
		"flavor": "Your tiny tail feels heavy as it drags through the dirt behind you.",
		"shell_only": false,
		"choices": [
			{
				"label": "Drag it forward with effort",
				"stat": "permanent_strength_mod",
				"result": "Heavy and stubborn. You move it anyway. It will not always feel like this.",
			},
			{
				"label": "Swing it slightly for balance",
				"stat": "permanent_defense_mod",
				"result": "Low and steady. The tail becomes an anchor. You do not tip.",
			},
			{
				"label": "Shuffle faster across the nest",
				"stat": "permanent_speed_mod",
				"result": "Quick short steps beat a heavy drag. You find your pace.",
			},
			{
				"label": "Stop and recover your energy",
				"stat": "permanent_health_mod",
				"result": "The tail can wait. You breathe. When you move again it feels lighter.",
			},
		],
	},
	{
		"id": "anky_hatch_pebble",
		"title": "Pebble Shield",
		"flavor": "A flat stone lies beside the nest, just big enough to hide behind.",
		"shell_only": false,
		"choices": [
			{
				"label": "Crouch behind the stone",
				"stat": "permanent_defense_mod",
				"result": "Pressed flat, invisible. You fit perfectly. The stone is yours.",
			},
			{
				"label": "Push the stone aside",
				"stat": "permanent_strength_mod",
				"result": "Wide and stubborn. It scrapes across the dirt. You moved it.",
			},
			{
				"label": "Scurry around it quickly",
				"stat": "permanent_speed_mod",
				"result": "Around the edge and past it before it can slow you down.",
			},
			{
				"label": "Rest in the cool shade it makes",
				"stat": "permanent_health_mod",
				"result": "Cool and dark. Perfect. You wake up feeling rested.",
			},
		],
	},
	{
		"id": "anky_hatch_root",
		"title": "Tough Little Root",
		"flavor": "A stubborn root sticks out of the dirt near your feet.",
		"shell_only": false,
		"choices": [
			{
				"label": "Tug until it loosens",
				"stat": "permanent_strength_mod",
				"result": "It holds for a long time. So do you. Eventually it gives.",
			},
			{
				"label": "Chew the soft outer bark",
				"stat": "permanent_health_mod",
				"result": "Rich and earthy. Better than it looks. You finish every bit.",
			},
			{
				"label": "Carry a piece back quickly",
				"stat": "permanent_speed_mod",
				"result": "Grabbed and moving before anything else picks up the smell.",
			},
			{
				"label": "Eat from behind a clump of grass",
				"stat": "permanent_defense_mod",
				"result": "Hidden while you chew. Patient and unhurried.",
			},
		],
	},
	{
		"id": "anky_hatch_wobble",
		"title": "Heavy Foot Wobble",
		"flavor": "Your short legs wobble under your wide little body.",
		"shell_only": false,
		"choices": [
			{
				"label": "Plant your feet and brace",
				"stat": "permanent_defense_mod",
				"result": "Wide and low. The wobble stops. You are harder to move than you look.",
			},
			{
				"label": "Push yourself upright again",
				"stat": "permanent_strength_mod",
				"result": "Legs strain and lock. You straighten. The weight becomes familiar.",
			},
			{
				"label": "Take quick careful steps",
				"stat": "permanent_speed_mod",
				"result": "Small and fast is more stable than slow and wide. You figure this out quickly.",
			},
			{
				"label": "Sit down and breathe",
				"stat": "permanent_health_mod",
				"result": "Not yet. You rest. When you stand again the ground feels solid.",
			},
		],
	},
	{
		"id": "anky_hatch_shadow",
		"title": "Shadow Between Ferns",
		"flavor": "A shadow moves through the ferns near the nest.",
		"shell_only": false,
		"choices": [
			{
				"label": "Flatten yourself against the ground",
				"stat": "permanent_defense_mod",
				"result": "Plates down, body wide. You become part of the ground. Nothing sees you.",
			},
			{
				"label": "Shuffle toward cover",
				"stat": "permanent_speed_mod",
				"result": "Quick and low. You reach the cover before the shadow resolves.",
			},
			{
				"label": "Swing your tiny tail at the air",
				"stat": "permanent_strength_mod",
				"result": "Small warning. Real intention. The shadow does not come closer.",
			},
			{
				"label": "Stay still and conserve energy",
				"stat": "permanent_health_mod",
				"result": "Still as a stone. The shadow moves on. You saved everything.",
			},
		],
	},
	{
		"id": "anky_hatch_mud",
		"title": "Muddy Armor Coat",
		"flavor": "Wet mud clings to your back plates, making you feel heavier but hidden.",
		"shell_only": false,
		"choices": [
			{
				"label": "Let the mud harden over your plates",
				"stat": "permanent_defense_mod",
				"result": "Heavy and sealed. Nothing gets through mud-hardened armor.",
			},
			{
				"label": "Push through despite the weight",
				"stat": "permanent_strength_mod",
				"result": "Heavier with every step. You do not slow down. You get stronger.",
			},
			{
				"label": "Wiggle free and move faster",
				"stat": "permanent_speed_mod",
				"result": "Shaken loose and moving before the mud settles again.",
			},
			{
				"label": "Cool off in the damp mud",
				"stat": "permanent_health_mod",
				"result": "Cool and still. The mud feels like rest. You emerge refreshed.",
			},
		],
	},
]


func get_events() -> Array:
	return EVENTS
