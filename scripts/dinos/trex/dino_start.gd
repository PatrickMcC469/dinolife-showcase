extends "res://scripts/dinos/base_dino_start.gd"

const EVENTS: Array = [
	{
		"id": "trex_hatch_head",
		"title": "Heavy Head Wobble",
		"flavor": "Your head feels too large for your tiny body as you lift it for the first time.",
		"shell_only": false,
		"choices": [
			{
				"label": "Hold your head up proudly",
				"stat": "permanent_strength_mod",
				"result": "Your neck strains. You hold it anyway. The weight becomes yours to carry.",
			},
			{
				"label": "Correct your balance quickly",
				"stat": "permanent_speed_mod",
				"result": "A wobble, then a correction. You find the rhythm fast.",
			},
			{
				"label": "Lower yourself into a stable stance",
				"stat": "permanent_defense_mod",
				"result": "Wide and low. Unshakeable. You will not be knocked down easily.",
			},
			{
				"label": "Rest your head and breathe deeply",
				"stat": "permanent_health_mod",
				"result": "The weight can wait. You breathe. When you lift it again it feels lighter.",
			},
		],
	},
	{
		"id": "trex_hatch_bite",
		"title": "First Tiny Bite",
		"flavor": "A strip of egg membrane clings to your broken shell.",
		"shell_only": true,
		"choices": [
			{
				"label": "Bite down with your new jaws",
				"stat": "permanent_strength_mod",
				"result": "The membrane tears clean. Your jaws already know what they are for.",
			},
			{
				"label": "Snap at it quickly before it falls",
				"stat": "permanent_speed_mod",
				"result": "Caught mid-air. Faster than you expected. Good.",
			},
			{
				"label": "Pin the shell beneath your foot",
				"stat": "permanent_defense_mod",
				"result": "Foot flat, body steady. You control the situation before acting.",
			},
			{
				"label": "Eat the soft membrane slowly",
				"stat": "permanent_health_mod",
				"result": "Rich and warm. The first meal from the shell that made you.",
			},
		],
	},
	{
		"id": "trex_hatch_footstep",
		"title": "Oversized Footstep",
		"flavor": "Your large hatchling feet slap clumsily against the nest floor.",
		"shell_only": false,
		"choices": [
			{
				"label": "Stomp harder to steady yourself",
				"stat": "permanent_strength_mod",
				"result": "Each stomp more deliberate. The ground feels yours.",
			},
			{
				"label": "Take quick little steps",
				"stat": "permanent_speed_mod",
				"result": "Short and fast. You figure out how to move the big feet quickly.",
			},
			{
				"label": "Spread your feet wide and brace",
				"stat": "permanent_defense_mod",
				"result": "Planted. Stable. Nothing is moving you from this spot.",
			},
			{
				"label": "Sit back and recover",
				"stat": "permanent_health_mod",
				"result": "The feet can wait. You rest. When you stand again it feels natural.",
			},
		],
	},
	{
		"id": "trex_hatch_sibling",
		"title": "Sibling Jaw Test",
		"flavor": "Another hatchling bumps your shoulder and opens its mouth in a tiny challenge.",
		"shell_only": false,
		"choices": [
			{
				"label": "Bite the air back at them",
				"stat": "permanent_strength_mod",
				"result": "Your jaws snap loud. They close their mouth and step back.",
			},
			{
				"label": "Dodge sideways around them",
				"stat": "permanent_speed_mod",
				"result": "Gone before they can press the challenge. You are already elsewhere.",
			},
			{
				"label": "Plant your feet and hold your space",
				"stat": "permanent_defense_mod",
				"result": "You do not move. Eventually they do. Space claimed.",
			},
			{
				"label": "Back off and save your energy",
				"stat": "permanent_health_mod",
				"result": "Not today. You conserve. The right moment will come.",
			},
		],
	},
	{
		"id": "trex_hatch_meat",
		"title": "Strange Meat Smell",
		"flavor": "A small scrap of meat lies near the edge of the nest, carrying a strong scent.",
		"shell_only": false,
		"choices": [
			{
				"label": "Tear at it with your jaws",
				"stat": "permanent_strength_mod",
				"result": "The scrap comes apart easily. Your bite is already something to fear.",
			},
			{
				"label": "Rush over before another hatchling sees it",
				"stat": "permanent_speed_mod",
				"result": "First there. First to eat. The others did not even look up in time.",
			},
			{
				"label": "Guard it with your body",
				"stat": "permanent_defense_mod",
				"result": "Body between the scrap and everyone else. Nobody tests you.",
			},
			{
				"label": "Eat it carefully",
				"stat": "permanent_health_mod",
				"result": "Deliberate and thorough. Not a scrap wasted. You feel strong after.",
			},
		],
	},
	{
		"id": "trex_hatch_arms",
		"title": "Tiny Arms, Big Problem",
		"flavor": "Your small arms twitch uselessly as you try to push yourself over a nest ridge.",
		"shell_only": false,
		"choices": [
			{
				"label": "Push with your legs instead",
				"stat": "permanent_strength_mod",
				"result": "The legs do the work the arms cannot. You crest the ridge.",
			},
			{
				"label": "Scramble over quickly",
				"stat": "permanent_speed_mod",
				"result": "Fast enough that the arms barely matter. You are over before you notice.",
			},
			{
				"label": "Roll low and protect your belly",
				"stat": "permanent_defense_mod",
				"result": "You find another way. Low and controlled. No belly exposed.",
			},
			{
				"label": "Pause and gather energy",
				"stat": "permanent_health_mod",
				"result": "You breathe. You think. The second attempt is easy.",
			},
		],
	},
	{
		"id": "trex_hatch_shadow",
		"title": "Shadow Over the Nest",
		"flavor": "A shape passes above, and the nest suddenly feels much smaller.",
		"shell_only": false,
		"choices": [
			{
				"label": "Snap upward at the shadow",
				"stat": "permanent_strength_mod",
				"result": "Tiny jaws aimed at something enormous. The instinct is already there.",
			},
			{
				"label": "Run beneath a root",
				"stat": "permanent_speed_mod",
				"result": "Cover found before the shadow finishes crossing. Smart and fast.",
			},
			{
				"label": "Flatten low and stay still",
				"stat": "permanent_defense_mod",
				"result": "Invisible from above. The shadow passes. You were never seen.",
			},
			{
				"label": "Tuck close to the warm shell pieces",
				"stat": "permanent_health_mod",
				"result": "The shell still holds heat. You rest against it until the danger passes.",
			},
		],
	},
	{
		"id": "trex_hatch_scent",
		"title": "First Warning Scent",
		"flavor": "A strange smell drifts in from beyond the nest — predator, carrion, or danger.",
		"shell_only": false,
		"choices": [
			{
				"label": "Follow the scent boldly",
				"stat": "permanent_strength_mod",
				"result": "You move toward it without flinching. Whatever it is, you want to know.",
			},
			{
				"label": "Move quickly toward cover",
				"stat": "permanent_speed_mod",
				"result": "Hidden before the smell gets stronger. Cover first, curiosity later.",
			},
			{
				"label": "Stay low and watch the nest edge",
				"stat": "permanent_defense_mod",
				"result": "Low and alert. Nothing crosses the edge without you seeing it first.",
			},
			{
				"label": "Remain near the safest warmth",
				"stat": "permanent_health_mod",
				"result": "The nest is safe. You know your limits. You wait it out.",
			},
		],
	},
]


func get_events() -> Array:
	return EVENTS
