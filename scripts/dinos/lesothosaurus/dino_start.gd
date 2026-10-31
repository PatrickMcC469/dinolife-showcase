extends "res://scripts/dinos/base_dino_start.gd"

const EVENTS: Array = [
	{
		"id": "leso_hatch_leaf",
		"title": "First Leaf Nibble",
		"flavor": "A soft green sprout pokes through the dirt near the nest.",
		"shell_only": false,
		"choices": [
			{
				"label": "Stretch up and nibble it",
				"stat": "permanent_health_mod",
				"result": "Fresh and soft. The first real food. Your body welcomes it.",
			},
			{
				"label": "Tug the stem loose",
				"stat": "permanent_strength_mod",
				"result": "The root holds longer than expected. You hold longer. You win.",
			},
			{
				"label": "Dart back after each bite",
				"stat": "permanent_speed_mod",
				"result": "Bite, retreat, bite again. Quick and cautious. A good habit.",
			},
			{
				"label": "Crouch low while eating",
				"stat": "permanent_defense_mod",
				"result": "Head down, body small. You eat and stay invisible at the same time.",
			},
		],
	},
	{
		"id": "leso_hatch_pebble",
		"title": "Pebble Path",
		"flavor": "Small warm stones form a bumpy path away from the nest.",
		"shell_only": false,
		"choices": [
			{
				"label": "Hop quickly from stone to stone",
				"stat": "permanent_speed_mod",
				"result": "Light on each stone, already moving to the next. Good feet.",
			},
			{
				"label": "Push a pebble aside with your snout",
				"stat": "permanent_strength_mod",
				"result": "It scrapes and rolls. You cleared the path yourself.",
			},
			{
				"label": "Step carefully to avoid slipping",
				"stat": "permanent_defense_mod",
				"result": "Each foot placed with intention. Not one stumble.",
			},
			{
				"label": "Rest on the warmest stone",
				"stat": "permanent_health_mod",
				"result": "Heat rises through your feet. You soak it in and feel steadier.",
			},
		],
	},
	{
		"id": "leso_hatch_fern",
		"title": "Fern Curtain",
		"flavor": "A low curtain of ferns sways gently in the breeze.",
		"shell_only": false,
		"choices": [
			{
				"label": "Dash through the fern gap",
				"stat": "permanent_speed_mod",
				"result": "Through and out the other side before the ferns stop swaying.",
			},
			{
				"label": "Push through the thick stems",
				"stat": "permanent_strength_mod",
				"result": "The stems bend. You push until they give. You make your own gap.",
			},
			{
				"label": "Hide beneath the leaves",
				"stat": "permanent_defense_mod",
				"result": "Still and green-covered. The world walks past without seeing you.",
			},
			{
				"label": "Nibble the soft fern tips",
				"stat": "permanent_health_mod",
				"result": "Mild and cool. A small meal. Exactly what you needed.",
			},
		],
	},
	{
		"id": "leso_hatch_chirp",
		"title": "Sudden Chirp",
		"flavor": "A sharp chirp echoes nearby, and the other hatchlings freeze.",
		"shell_only": false,
		"choices": [
			{
				"label": "Sprint toward cover",
				"stat": "permanent_speed_mod",
				"result": "First to move, first to hide. You were under cover before the echo faded.",
			},
			{
				"label": "Stomp your tiny foot in alarm",
				"stat": "permanent_strength_mod",
				"result": "The sound of your stomp surprises even you. A small warning back.",
			},
			{
				"label": "Flatten yourself against the ground",
				"stat": "permanent_defense_mod",
				"result": "Pressed flat, invisible. The chirp means nothing to something it cannot find.",
			},
			{
				"label": "Stay close to the warm nest",
				"stat": "permanent_health_mod",
				"result": "The nest is still safe. You breathe slowly. The danger passes.",
			},
		],
	},
	{
		"id": "leso_hatch_seed",
		"title": "Dry Seed Pod",
		"flavor": "A cracked seed pod lies half-buried in soft dirt.",
		"shell_only": false,
		"choices": [
			{
				"label": "Peck out the seeds carefully",
				"stat": "permanent_health_mod",
				"result": "One by one, patient and thorough. Every seed accounted for.",
			},
			{
				"label": "Crack the pod open",
				"stat": "permanent_strength_mod",
				"result": "One good bite splits it wide. Everything inside is yours.",
			},
			{
				"label": "Snatch a seed and run",
				"stat": "permanent_speed_mod",
				"result": "Grabbed and gone before anything else notices.",
			},
			{
				"label": "Carry it beneath cover before eating",
				"stat": "permanent_defense_mod",
				"result": "Safe spot found first. You eat without watching over your shoulder.",
			},
		],
	},
	{
		"id": "leso_hatch_tail",
		"title": "Tiny Tail Balance",
		"flavor": "Your long tail sways behind you as you try to stand tall.",
		"shell_only": false,
		"choices": [
			{
				"label": "Use it to balance while running",
				"stat": "permanent_speed_mod",
				"result": "Tail out, body forward. You find the rhythm. Running feels natural.",
			},
			{
				"label": "Hold your body steady and firm",
				"stat": "permanent_defense_mod",
				"result": "Tail low, stance wide. Solid. You will not be knocked off balance.",
			},
			{
				"label": "Push yourself upright again",
				"stat": "permanent_strength_mod",
				"result": "Legs push, tail counterbalances. Up again. You remember how.",
			},
			{
				"label": "Sit down and recover",
				"stat": "permanent_health_mod",
				"result": "Rest first. The running can wait. You stand again feeling ready.",
			},
		],
	},
	{
		"id": "leso_hatch_tracks",
		"title": "Bigger Footprints",
		"flavor": "Large tracks pass near the nest, pressed deep into the mud.",
		"shell_only": false,
		"choices": [
			{
				"label": "Follow the edge of the tracks quickly",
				"stat": "permanent_speed_mod",
				"result": "Light and fast along the rim. The mud never catches you.",
			},
			{
				"label": "Climb out of a muddy print",
				"stat": "permanent_strength_mod",
				"result": "The mud pulls. You pull harder. Out and moving again.",
			},
			{
				"label": "Hide inside the deepest track",
				"stat": "permanent_defense_mod",
				"result": "Walls of mud around you. Invisible and sheltered.",
			},
			{
				"label": "Drink from a clean puddle inside one",
				"stat": "permanent_health_mod",
				"result": "Cool and still. You drink your fill and feel steadier.",
			},
		],
	},
	{
		"id": "leso_hatch_branch",
		"title": "Low Branch Snack",
		"flavor": "A leafy branch hangs just barely within reach.",
		"shell_only": false,
		"choices": [
			{
				"label": "Stretch and eat the softest leaves",
				"stat": "permanent_health_mod",
				"result": "Sweet and fresh at the tips. Your best meal yet.",
			},
			{
				"label": "Pull the branch lower",
				"stat": "permanent_strength_mod",
				"result": "Neck straining, legs pushing. The branch bends. You eat well.",
			},
			{
				"label": "Grab a bite and dart away",
				"stat": "permanent_speed_mod",
				"result": "In and out before the branch springs back. Clean.",
			},
			{
				"label": "Eat from beneath the branch cover",
				"stat": "permanent_defense_mod",
				"result": "Hidden under the leaves while you eat. Nothing sees you from above.",
			},
		],
	},
]


func get_events() -> Array:
	return EVENTS
