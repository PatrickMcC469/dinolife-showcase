extends "res://scripts/dinos/base_dino_rest.gd"

const REST_FLAVORS: Dictionary = {
	"first": [
		"You settle low in the brush, folding your feathers close while your muscles recover.",
		"You rest beneath tangled ferns, letting your legs and claws loosen after the hunt.",
		"You tuck into cover, breathing slowly as your body mends.",
		"You crouch in the shade, feathers ruffling softly while pain begins to fade.",
		"You rest where the pack's distant calls still reach you through the trees.",
	],
	"second": [
		"You rest again, alert to pack calls and danger while your body recovers what it can.",
		"You stay low in cover, but your muscles heal more slowly now.",
		"You fold your claws beneath you and take one last useful rest this season.",
		"You settle down again, though your body has less recovery left to offer.",
		"You rest with one eye open, gaining only what little healing remains.",
	],
	"exhausted": [
		"You lie still, but no more healing comes this season.",
		"You rest in the brush, though your body refuses to mend further.",
		"You stay tucked away, but the aches remain where they are.",
		"You wait in silence, gaining safety but no recovery.",
		"You settle your feathers, but this season's healing has already run dry.",
	],
}

func get_rest_flavors() -> Dictionary:
	return REST_FLAVORS
