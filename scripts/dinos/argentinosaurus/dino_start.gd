extends "res://scripts/dinos/base_dino_start.gd"

const EVENTS: Array = [
	{
		"id": "arge_hatch_neck",
		"title": "First Neck Stretch",
		"flavor": "A soft cluster of leaves hangs just above your tiny head.",
		"shell_only": false,
		"choices": [
			{
				"label": "Stretch your neck to reach them",
				"stat": "permanent_health_mod",
				"result": "Barely within reach. You stretch further. The leaves are worth it.",
			},
			{
				"label": "Pull the branch lower",
				"stat": "permanent_strength_mod",
				"result": "The branch bends slowly. You hold it down. You eat everything on it.",
			},
			{
				"label": "Step quickly beneath the leaves",
				"stat": "permanent_speed_mod",
				"result": "Positioned before the branch stops swaying. Good instinct.",
			},
			{
				"label": "Eat from under the branch cover",
				"stat": "permanent_defense_mod",
				"result": "Hidden beneath the canopy while you eat. Safe and unhurried.",
			},
		],
	},
	{
		"id": "arge_hatch_steps",
		"title": "Giant Herd Steps",
		"flavor": "Massive adult feet move slowly nearby, shaking the ground with each step.",
		"shell_only": false,
		"choices": [
			{
				"label": "Stay close between the safest footsteps",
				"stat": "permanent_defense_mod",
				"result": "You find the gaps between the feet and hold them. Protected on all sides.",
			},
			{
				"label": "Hurry after the nearest adult",
				"stat": "permanent_speed_mod",
				"result": "Short legs, long strides ahead. You keep up. Just barely. It counts.",
			},
			{
				"label": "Push through the shaking ground",
				"stat": "permanent_strength_mod",
				"result": "Every step a small battle against the tremors. You do not fall.",
			},
			{
				"label": "Rest in the warm shadow of the herd",
				"stat": "permanent_health_mod",
				"result": "Enormous shadows. Perfect warmth. You rest better than you ever have.",
			},
		],
	},
	{
		"id": "arge_hatch_tail",
		"title": "Long Tail Trouble",
		"flavor": "Your little tail drags through the grass and catches on a twig.",
		"shell_only": false,
		"choices": [
			{
				"label": "Pull yourself free",
				"stat": "permanent_strength_mod",
				"result": "The twig holds. You pull harder. The twig loses.",
			},
			{
				"label": "Flick your tail loose",
				"stat": "permanent_speed_mod",
				"result": "One sharp motion. The twig flies. You keep moving.",
			},
			{
				"label": "Lower your body to avoid stumbling",
				"stat": "permanent_defense_mod",
				"result": "Low and controlled. The tug barely registers when you are already this stable.",
			},
			{
				"label": "Pause and recover your breath",
				"stat": "permanent_health_mod",
				"result": "Still. Calm. You work the twig free gently and carry on stronger.",
			},
		],
	},
	{
		"id": "arge_hatch_fern",
		"title": "Fern Breakfast Path",
		"flavor": "A trail of soft ferns leads away from the nest toward brighter sunlight.",
		"shell_only": false,
		"choices": [
			{
				"label": "Eat the biggest fern clump",
				"stat": "permanent_health_mod",
				"result": "Rich and wide. Your first real meal. The sunlight makes it better.",
			},
			{
				"label": "Push through the thick fern stems",
				"stat": "permanent_strength_mod",
				"result": "The trail widens behind you. You made the path easier for whoever follows.",
			},
			{
				"label": "Follow the trail quickly",
				"stat": "permanent_speed_mod",
				"result": "Short legs find a rhythm. You reach the sunlight ahead of the others.",
			},
			{
				"label": "Stay under the fern cover while eating",
				"stat": "permanent_defense_mod",
				"result": "Hidden and fed. The sunlight can wait. Safety eats first.",
			},
		],
	},
	{
		"id": "arge_hatch_pool",
		"title": "Muddy Footprint Pool",
		"flavor": "A huge adult footprint has filled with clean rainwater.",
		"shell_only": false,
		"choices": [
			{
				"label": "Drink deeply from the pool",
				"stat": "permanent_health_mod",
				"result": "Cool and clean. The best water you have found. You feel it.",
			},
			{
				"label": "Climb over the muddy rim",
				"stat": "permanent_strength_mod",
				"result": "The mud pulls at your feet. You climb free anyway.",
			},
			{
				"label": "Step around the slippery edge",
				"stat": "permanent_speed_mod",
				"result": "Quick feet on the firm ground. Not a single slip.",
			},
			{
				"label": "Hide low inside the footprint",
				"stat": "permanent_defense_mod",
				"result": "Deep and hidden. The walls of mud are higher than you. Nothing finds you here.",
			},
		],
	},
	{
		"id": "arge_hatch_call",
		"title": "Herd Call",
		"flavor": "A deep rumble passes through the adults, and the hatchlings begin moving together.",
		"shell_only": false,
		"choices": [
			{
				"label": "Follow the call quickly",
				"stat": "permanent_speed_mod",
				"result": "Moving before the rumble fades. You are already with the herd.",
			},
			{
				"label": "Press close to the group",
				"stat": "permanent_defense_mod",
				"result": "Surrounded on all sides. The herd moves around you and with you.",
			},
			{
				"label": "Push forward through the crowd",
				"stat": "permanent_strength_mod",
				"result": "Small but determined. You find the front before the march begins.",
			},
			{
				"label": "Stay calm and breathe with the herd",
				"stat": "permanent_health_mod",
				"result": "The rumble becomes a rhythm. You breathe with it. You feel enormous and steady.",
			},
		],
	},
	{
		"id": "arge_hatch_branch",
		"title": "Low Branch Test",
		"flavor": "A young tree bends under the weight of fresh leaves.",
		"shell_only": false,
		"choices": [
			{
				"label": "Tug the branch downward",
				"stat": "permanent_strength_mod",
				"result": "The tree is young but stubborn. You are stubborn longer. The branch bends.",
			},
			{
				"label": "Stretch up for the tender leaves",
				"stat": "permanent_health_mod",
				"result": "Fresh at the tips. Worth every bit of the stretch.",
			},
			{
				"label": "Move around to the easiest side",
				"stat": "permanent_speed_mod",
				"result": "The far side hangs lower. You find it fast. Smarter than forcing it.",
			},
			{
				"label": "Stand beneath the branch like cover",
				"stat": "permanent_defense_mod",
				"result": "Leaves overhead, body hidden. You eat in peace.",
			},
		],
	},
	{
		"id": "arge_hatch_balance",
		"title": "Tiny Giant Balance",
		"flavor": "Your long neck, long tail, and oversized feet all seem to move at different times.",
		"shell_only": false,
		"choices": [
			{
				"label": "Plant your feet and steady yourself",
				"stat": "permanent_defense_mod",
				"result": "Wide base. Everything else settles around it. You find your center.",
			},
			{
				"label": "Push your body upright again",
				"stat": "permanent_strength_mod",
				"result": "Everything strains at once. Everything holds. You stand.",
			},
			{
				"label": "Take quick careful steps",
				"stat": "permanent_speed_mod",
				"result": "Moving is the answer. All the parts find agreement when you are in motion.",
			},
			{
				"label": "Sit down and regain energy",
				"stat": "permanent_health_mod",
				"result": "Rest first. The balance will come. You stand again and it already has.",
			},
		],
	},
]


func get_events() -> Array:
	return EVENTS
