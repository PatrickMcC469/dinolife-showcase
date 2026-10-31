extends "res://scripts/dinos/base_dino_start.gd"

const EVENTS: Array = [
	{
		"id": "igua_hatch_thumb",
		"title": "First Thumb Bump",
		"flavor": "Your tiny thumb spike bumps against a broken piece of shell as you wobble forward.",
		"shell_only": true,
		"choices": [
			{
				"label": "Push the shell aside with your thumb",
				"stat": "permanent_strength_mod",
				"result": "The spike finds the shell's edge and shoves. Your thumb already knows its job.",
			},
			{
				"label": "Brace your body behind the shell",
				"stat": "permanent_defense_mod",
				"result": "Shell as cover. Body low. You learn the value of what surrounds you.",
			},
			{
				"label": "Step around it quickly",
				"stat": "permanent_speed_mod",
				"result": "Gap found and taken before the wobble catches up. Clean footwork.",
			},
			{
				"label": "Rest beside the warm shell pieces",
				"stat": "permanent_health_mod",
				"result": "Still warm from the inside. You rest against it and feel steady.",
			},
		],
	},
	{
		"id": "igua_hatch_leaf",
		"title": "Soft Leaf Patch",
		"flavor": "A patch of broad, soft leaves grows just low enough for you to reach.",
		"shell_only": false,
		"choices": [
			{
				"label": "Eat the biggest leaf slowly",
				"stat": "permanent_health_mod",
				"result": "Wide and fresh. You take your time. Every bite counts.",
			},
			{
				"label": "Pull a tough stem loose",
				"stat": "permanent_strength_mod",
				"result": "The stem resists. You pull longer. It gives. You win.",
			},
			{
				"label": "Nip a leaf and hurry back",
				"stat": "permanent_speed_mod",
				"result": "Quick grab, quick retreat. In and out before the breeze settles.",
			},
			{
				"label": "Eat while tucked beneath the leaves",
				"stat": "permanent_defense_mod",
				"result": "Covered and calm. You eat the whole patch without being seen.",
			},
		],
	},
	{
		"id": "igua_hatch_shadow",
		"title": "Herd Shadow",
		"flavor": "A large adult steps nearby, casting a huge safe shadow over the nest.",
		"shell_only": false,
		"choices": [
			{
				"label": "Stay close beneath the shadow",
				"stat": "permanent_defense_mod",
				"result": "Safe and unseen. You learn what protection feels like.",
			},
			{
				"label": "Follow the adult's footsteps",
				"stat": "permanent_speed_mod",
				"result": "You keep pace longer than expected. Your legs find a confident rhythm.",
			},
			{
				"label": "Push against the adult's leg for balance",
				"stat": "permanent_strength_mod",
				"result": "Solid and immovable. You push and feel your own legs firm up in response.",
			},
			{
				"label": "Rest in the warm protected space",
				"stat": "permanent_health_mod",
				"result": "Sheltered and still. You wake up feeling like part of something larger.",
			},
		],
	},
	{
		"id": "igua_hatch_hindlegs",
		"title": "Wobbly Hind Legs",
		"flavor": "You rise briefly on your back legs, wobbling as your tail swings behind you.",
		"shell_only": false,
		"choices": [
			{
				"label": "Hold yourself upright longer",
				"stat": "permanent_strength_mod",
				"result": "Legs shaking, tail counterbalancing. You hold. The wobble fades.",
			},
			{
				"label": "Drop low into a stable stance",
				"stat": "permanent_defense_mod",
				"result": "Four legs down, body wide. Solid ground under all of you.",
			},
			{
				"label": "Take quick balancing steps",
				"stat": "permanent_speed_mod",
				"result": "Moving is easier than standing still. You find that out immediately.",
			},
			{
				"label": "Sit back down and recover",
				"stat": "permanent_health_mod",
				"result": "Not yet. But soon. You rest and try again with more success.",
			},
		],
	},
	{
		"id": "igua_hatch_mud",
		"title": "Muddy Nest Edge",
		"flavor": "Soft mud squishes beneath your feet near the edge of the nest.",
		"shell_only": false,
		"choices": [
			{
				"label": "Pull your feet free with effort",
				"stat": "permanent_strength_mod",
				"result": "One foot at a time. Slow and strong. You pull free.",
			},
			{
				"label": "Step lightly across the mud",
				"stat": "permanent_speed_mod",
				"result": "Barely touching the surface. You cross before the mud notices.",
			},
			{
				"label": "Lower your body to avoid slipping",
				"stat": "permanent_defense_mod",
				"result": "Low and wide. Every step deliberate. Not a single slip.",
			},
			{
				"label": "Drink from a clean little puddle",
				"stat": "permanent_health_mod",
				"result": "Cool and still between the footprints. You drink and feel sharper.",
			},
		],
	},
	{
		"id": "igua_hatch_fern",
		"title": "Fern Wall",
		"flavor": "A thick wall of ferns blocks your view of the herd.",
		"shell_only": false,
		"choices": [
			{
				"label": "Push through the fern stems",
				"stat": "permanent_strength_mod",
				"result": "Stems bend and part. You step through into open air.",
			},
			{
				"label": "Slip through a narrow opening",
				"stat": "permanent_speed_mod",
				"result": "Just wide enough. You find it fast and you are through.",
			},
			{
				"label": "Hide beneath the fern cover",
				"stat": "permanent_defense_mod",
				"result": "You stop looking for the herd and become part of the green instead.",
			},
			{
				"label": "Nibble the tender fern tips",
				"stat": "permanent_health_mod",
				"result": "Soft and mild. The wall feeds you before you find a way through it.",
			},
		],
	},
	{
		"id": "igua_hatch_thump",
		"title": "Warning Tail Thump",
		"flavor": "An adult Iguanodon thumps its tail against the ground, warning the hatchlings to pay attention.",
		"shell_only": false,
		"choices": [
			{
				"label": "Hurry toward the herd",
				"stat": "permanent_speed_mod",
				"result": "You move the instant the thump lands. First to reach safety.",
			},
			{
				"label": "Brace low and freeze",
				"stat": "permanent_defense_mod",
				"result": "Down and still before the vibration stops. Nothing can target what cannot be seen.",
			},
			{
				"label": "Stomp your tiny foot back",
				"stat": "permanent_strength_mod",
				"result": "Small but deliberate. You answer the warning with one of your own.",
			},
			{
				"label": "Stay close and breathe slowly",
				"stat": "permanent_health_mod",
				"result": "Calm in the middle of alarm. The herd moves around you. You remain steady.",
			},
		],
	},
	{
		"id": "igua_hatch_stem",
		"title": "Tough Stem Test",
		"flavor": "A chewy plant stem bends but does not break when you bite it.",
		"shell_only": false,
		"choices": [
			{
				"label": "Tug until it snaps",
				"stat": "permanent_strength_mod",
				"result": "Longer than it should take. You do not let go. It finally snaps.",
			},
			{
				"label": "Chew the softer leaves instead",
				"stat": "permanent_health_mod",
				"result": "Work smarter. The leaves are better anyway. You eat well.",
			},
			{
				"label": "Carry it quickly back to the nest",
				"stat": "permanent_speed_mod",
				"result": "Grabbed and moving before anything else gets close.",
			},
			{
				"label": "Eat from behind thicker plants",
				"stat": "permanent_defense_mod",
				"result": "Hidden while you work at it. Patient and covered.",
			},
		],
	},
]


func get_events() -> Array:
	return EVENTS
