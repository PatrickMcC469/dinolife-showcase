extends "res://scripts/dinos/base_dino_start.gd"

const EVENTS: Array = [
	{
		"id": "allo_hatch_jaw",
		"title": "First Jaw Snap",
		"flavor": "Your jaws feel too big for your head as you test your first bite on a broken eggshell.",
		"shell_only": true,
		"choices": [
			{
				"label": "Bite down hard on the shell",
				"stat": "permanent_strength_mod",
				"result": "The shell cracks. Your jaw remembers what it was built for.",
			},
			{
				"label": "Snap quickly again and again",
				"stat": "permanent_speed_mod",
				"result": "Faster each time. The rhythm becomes yours.",
			},
			{
				"label": "Hold the shell in your jaws like a shield",
				"stat": "permanent_defense_mod",
				"result": "Jaw locked, head low. Nothing gets past what you are holding.",
			},
			{
				"label": "Chew the soft egg membrane inside",
				"stat": "permanent_health_mod",
				"result": "Soft and rich. The first real thing you have tasted. You feel it settle.",
			},
		],
	},
	{
		"id": "allo_hatch_wobble",
		"title": "Nest Edge Wobble",
		"flavor": "You stumble toward the edge of the nest, legs shaking under your new weight.",
		"shell_only": false,
		"choices": [
			{
				"label": "Push yourself forward anyway",
				"stat": "permanent_strength_mod",
				"result": "Shaking legs and all. You make it. The weight becomes something you carry easily.",
			},
			{
				"label": "Catch your balance quickly",
				"stat": "permanent_speed_mod",
				"result": "One foot finds solid ground before the other slips. Fast recovery.",
			},
			{
				"label": "Lower your body to avoid falling",
				"stat": "permanent_defense_mod",
				"result": "Low and wide. Stable. You will not be knocked over easily.",
			},
			{
				"label": "Sit back and recover your breath",
				"stat": "permanent_health_mod",
				"result": "The edge can wait. You breathe. You stand again stronger.",
			},
		],
	},
	{
		"id": "allo_hatch_beetle",
		"title": "The Crawling Beetle",
		"flavor": "A thick beetle crawls across the nest floor, its shell clicking softly.",
		"shell_only": false,
		"choices": [
			{
				"label": "Crush it in your jaws",
				"stat": "permanent_strength_mod",
				"result": "The clicking stops. Clean and decisive.",
			},
			{
				"label": "Lunge before it escapes",
				"stat": "permanent_speed_mod",
				"result": "You cover the distance before it reaches the edge. Easy.",
			},
			{
				"label": "Pin it carefully under one foot",
				"stat": "permanent_defense_mod",
				"result": "Controlled. Patient. It is not going anywhere.",
			},
			{
				"label": "Eat it whole",
				"stat": "permanent_health_mod",
				"result": "Shell and all. Dense and satisfying. You feel it.",
			},
		],
	},
	{
		"id": "allo_hatch_footprints",
		"title": "Sauropod Footprints",
		"flavor": "Huge footprints filled with rainwater dot the ground near the nest.",
		"shell_only": false,
		"choices": [
			{
				"label": "Climb out of one muddy print",
				"stat": "permanent_strength_mod",
				"result": "The mud pulls back. You pull harder. You climb out.",
			},
			{
				"label": "Hop between the edges quickly",
				"stat": "permanent_speed_mod",
				"result": "Edge to edge without sinking. Light and fast.",
			},
			{
				"label": "Hide low inside the footprint",
				"stat": "permanent_defense_mod",
				"result": "Walls of mud on all sides. Nothing sees you down here.",
			},
			{
				"label": "Drink from the cleanest puddle",
				"stat": "permanent_health_mod",
				"result": "Cool and still. The best water you have had. You feel steadier.",
			},
		],
	},
	{
		"id": "allo_hatch_sibling",
		"title": "Sibling Shove",
		"flavor": "Another hatchling bumps into you while trying to reach a scrap of meat.",
		"shell_only": false,
		"choices": [
			{
				"label": "Shove back harder",
				"stat": "permanent_strength_mod",
				"result": "They stumble. You do not. The scrap is yours.",
			},
			{
				"label": "Dart around them first",
				"stat": "permanent_speed_mod",
				"result": "Around them before they know you moved. You reach the scrap first.",
			},
			{
				"label": "Brace and hold your place",
				"stat": "permanent_defense_mod",
				"result": "They push. You stand. Eventually they stop pushing.",
			},
			{
				"label": "Share the scrap and eat slowly",
				"stat": "permanent_health_mod",
				"result": "Half is enough. You eat without rushing. You finish feeling full.",
			},
		],
	},
	{
		"id": "allo_hatch_ambush",
		"title": "First Ambush Instinct",
		"flavor": "A small lizard pauses near a fallen branch. Something in you says to wait.",
		"shell_only": false,
		"choices": [
			{
				"label": "Burst out and snap at it",
				"stat": "permanent_speed_mod",
				"result": "The branch blurs past. You are already there.",
			},
			{
				"label": "Bite down with all your weight",
				"stat": "permanent_strength_mod",
				"result": "No holding back. The lizard learns what Allosaurus jaws mean.",
			},
			{
				"label": "Stay hidden behind the branch",
				"stat": "permanent_defense_mod",
				"result": "Still and invisible. You let it come to you. The ambush is clean.",
			},
			{
				"label": "Eat the leftovers near the branch",
				"stat": "permanent_health_mod",
				"result": "Small scraps. Enough. You eat everything and leave nothing.",
			},
		],
	},
	{
		"id": "allo_hatch_thorn",
		"title": "Thorn Scratch",
		"flavor": "A sharp plant scratches your side as you explore outside the nest.",
		"shell_only": false,
		"choices": [
			{
				"label": "Push through the plant",
				"stat": "permanent_strength_mod",
				"result": "It scratches. You push harder. The plant bends. You do not.",
			},
			{
				"label": "Slip around it quickly",
				"stat": "permanent_speed_mod",
				"result": "Gap found and through it before another thorn catches you.",
			},
			{
				"label": "Turn your side away from the thorns",
				"stat": "permanent_defense_mod",
				"result": "You angle yourself cleanly. Minimal contact. Smart movement.",
			},
			{
				"label": "Rest in a safer patch of shade",
				"stat": "permanent_health_mod",
				"result": "The scratch stings less in the cool. You leave it behind and move on.",
			},
		],
	},
	{
		"id": "allo_hatch_roar",
		"title": "Distant Roar",
		"flavor": "A deep roar rolls across the forest. The nest goes quiet.",
		"shell_only": false,
		"choices": [
			{
				"label": "Stand tall despite the sound",
				"stat": "permanent_strength_mod",
				"result": "Every other hatchling crouches. You do not. The roar fades. You are still standing.",
			},
			{
				"label": "Hurry beneath nearby roots",
				"stat": "permanent_speed_mod",
				"result": "Under cover before the second echo. You move without thinking.",
			},
			{
				"label": "Crouch still and make yourself small",
				"stat": "permanent_defense_mod",
				"result": "Flat and quiet. The roar sweeps over you. You were never there.",
			},
			{
				"label": "Stay close to the warmth of the nest",
				"stat": "permanent_health_mod",
				"result": "The nest is safe. You know this. You wait it out and leave stronger.",
			},
		],
	},
]


func get_events() -> Array:
	return EVENTS
