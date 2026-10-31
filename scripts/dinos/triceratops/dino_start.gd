extends "res://scripts/dinos/base_dino_start.gd"

const EVENTS: Array = [
	{
		"id": "trike_hatch_horn",
		"title": "First Horn Nudge",
		"flavor": "Your tiny horn nubs bump against a cracked piece of eggshell.",
		"shell_only": true,
		"choices": [
			{
				"label": "Shove the shell with your horn nubs",
				"stat": "permanent_strength_mod",
				"result": "The shell scrapes and shifts. Small horns. Real force behind them.",
			},
			{
				"label": "Lower your head behind your frill",
				"stat": "permanent_defense_mod",
				"result": "Frill forward, head tucked. Your first defensive stance comes naturally.",
			},
			{
				"label": "Step around the shell quickly",
				"stat": "permanent_speed_mod",
				"result": "Gap found, gap taken. You do not let obstacles slow you down.",
			},
			{
				"label": "Rest beside the warm shell pieces",
				"stat": "permanent_health_mod",
				"result": "Still warm from the inside. You lean in and feel whole.",
			},
		],
	},
	{
		"id": "trike_hatch_fern",
		"title": "Soft Fern Breakfast",
		"flavor": "A cluster of soft ferns grows close to the nest, low enough for you to reach.",
		"shell_only": false,
		"choices": [
			{
				"label": "Eat the softest fern tips",
				"stat": "permanent_health_mod",
				"result": "Tender and fresh. A proper first meal. Your body responds well.",
			},
			{
				"label": "Tug the thickest stem loose",
				"stat": "permanent_strength_mod",
				"result": "The roots hold. You hold longer. The stem tears free.",
			},
			{
				"label": "Grab a bite and hurry back",
				"stat": "permanent_speed_mod",
				"result": "In and out before the fern stops swaying.",
			},
			{
				"label": "Eat while tucked under the fern cover",
				"stat": "permanent_defense_mod",
				"result": "Hidden and fed. Nothing overhead can find you here.",
			},
		],
	},
	{
		"id": "trike_hatch_frill",
		"title": "Frill Flare",
		"flavor": "A breeze brushes your small frill, making you lift your head without thinking.",
		"shell_only": false,
		"choices": [
			{
				"label": "Spread your frill wide",
				"stat": "permanent_defense_mod",
				"result": "Frill out, head high. You look twice your size. Something in the distance pauses.",
			},
			{
				"label": "Stomp forward proudly",
				"stat": "permanent_strength_mod",
				"result": "Head up, feet firm. You walk into the wind like it belongs to you.",
			},
			{
				"label": "Turn quickly with the wind",
				"stat": "permanent_speed_mod",
				"result": "You spin with it before it pushes you. Fast and light on your feet.",
			},
			{
				"label": "Settle back into the warm nest",
				"stat": "permanent_health_mod",
				"result": "The breeze passes. You curl back in and rest well.",
			},
		],
	},
	{
		"id": "trike_hatch_herd",
		"title": "Herd Circle",
		"flavor": "Adult Triceratops stand nearby, forming a loose circle around the young.",
		"shell_only": false,
		"choices": [
			{
				"label": "Stay inside the safest part of the circle",
				"stat": "permanent_defense_mod",
				"result": "Surrounded on all sides by something enormous and protective. You learn what safety feels like.",
			},
			{
				"label": "Follow the nearest adult's steps",
				"stat": "permanent_speed_mod",
				"result": "Matching their pace takes everything you have. You keep up.",
			},
			{
				"label": "Push against another hatchling for space",
				"stat": "permanent_strength_mod",
				"result": "They give ground. You hold yours. Space claimed.",
			},
			{
				"label": "Rest beneath the protection of the herd",
				"stat": "permanent_health_mod",
				"result": "Warm, sheltered, and safe. You wake up ready.",
			},
		],
	},
	{
		"id": "trike_hatch_mud",
		"title": "Muddy Little Charge",
		"flavor": "Your feet sink into soft mud as you try to move toward a tasty plant.",
		"shell_only": false,
		"choices": [
			{
				"label": "Push forward through the mud",
				"stat": "permanent_strength_mod",
				"result": "Every step a fight. You win every one of them.",
			},
			{
				"label": "Step carefully along the firmer edge",
				"stat": "permanent_speed_mod",
				"result": "Light and quick on the solid ground. You reach the plant without sinking.",
			},
			{
				"label": "Lower your body and brace",
				"stat": "permanent_defense_mod",
				"result": "Low center of gravity. The mud cannot drag down what is already close to the ground.",
			},
			{
				"label": "Drink from a clean puddle nearby",
				"stat": "permanent_health_mod",
				"result": "Cool and clear between the prints. A good find. You feel steadier after.",
			},
		],
	},
	{
		"id": "trike_hatch_warning",
		"title": "Tail Tap Warning",
		"flavor": "An adult's tail thumps the ground, and the herd grows quiet.",
		"shell_only": false,
		"choices": [
			{
				"label": "Freeze low behind your frill",
				"stat": "permanent_defense_mod",
				"result": "Frill forward, body flat. You vanish into the quiet.",
			},
			{
				"label": "Hurry toward the adults",
				"stat": "permanent_speed_mod",
				"result": "Moving before the thump stops echoing. First to reach cover.",
			},
			{
				"label": "Stomp your tiny foot in response",
				"stat": "permanent_strength_mod",
				"result": "Small echo. Real intention. You answered the call.",
			},
			{
				"label": "Stay close and breathe slowly",
				"stat": "permanent_health_mod",
				"result": "Still and calm while others scatter. The danger passes. You never wasted energy.",
			},
		],
	},
	{
		"id": "trike_hatch_root",
		"title": "Tough Root Snack",
		"flavor": "A thick root pokes from the ground, chewy and stubborn.",
		"shell_only": false,
		"choices": [
			{
				"label": "Pull at it until it tears free",
				"stat": "permanent_strength_mod",
				"result": "Long and stubborn. You are longer and more stubborn. It tears.",
			},
			{
				"label": "Chew the softer outer layer",
				"stat": "permanent_health_mod",
				"result": "Rich and dense beneath the tough skin. Worth the patience.",
			},
			{
				"label": "Drag it quickly back toward the nest",
				"stat": "permanent_speed_mod",
				"result": "Claimed and moving before anything else notices the smell.",
			},
			{
				"label": "Eat it from behind a fallen log",
				"stat": "permanent_defense_mod",
				"result": "Cover first. You eat at your own pace without watching your back.",
			},
		],
	},
	{
		"id": "trike_hatch_standoff",
		"title": "Little Stand-Off",
		"flavor": "Another hatchling blocks your path and lowers its tiny head.",
		"shell_only": false,
		"choices": [
			{
				"label": "Nudge back with your horn nubs",
				"stat": "permanent_strength_mod",
				"result": "Horn meets horn. Yours push harder. The path is yours.",
			},
			{
				"label": "Plant your feet and hold your ground",
				"stat": "permanent_defense_mod",
				"result": "You do not lower your head. You do not move. Eventually they do.",
			},
			{
				"label": "Sidestep around them quickly",
				"stat": "permanent_speed_mod",
				"result": "Around and past before they realize you are not playing the game.",
			},
			{
				"label": "Back away and conserve energy",
				"stat": "permanent_health_mod",
				"result": "The path is not worth it today. You find another way. Smart.",
			},
		],
	},
]


func get_events() -> Array:
	return EVENTS
