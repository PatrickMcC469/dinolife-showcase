extends "res://scripts/dinos/base_dino_pack.gd"

const PACK_DATA: Dictionary = {
	"fracture": [
		"The little signals are wrong. Too many glances, too much distance, not enough trust.",
		"The group moves through the dust in broken lines instead of one quiet pattern.",
		"Your packmates keep drifting toward different cover, each following its own instincts.",
		"The wind carries scattered scent marks. The pack is losing its shape.",
		"The silence between calls feels sharper than the calls themselves.",
	],
	"push_success": [
		"You keep low, answer the signals, and guide the group back into quiet motion.",
		"A few careful calls and shared paths bring the pack's rhythm back.",
		"You slow your steps until the others match your movement again.",
		"The group settles into the brush, cautious but together.",
		"The pack bends, but it does not break.",
	],
	"push_failure": [
		"Your calls vanish into the dust, and no one answers.",
		"The others slip away through separate paths, silent and final.",
		"You try to pull the pattern together, but the pack has already lost it.",
		"One raptor turns away, then another, until the trail is empty.",
		"The group dissolves into the brush without a final cry.",
	],
	"release": [
		"You let the others vanish into the dust without following.",
		"The pack separates quietly, each raptor trusting its own feet.",
		"You stop calling and allow the silence to decide.",
		"The shared path ends, and you turn toward your own.",
		"The brush closes behind the others, leaving you alone with the wind.",
	],
}

func get_pack_data() -> Dictionary:
	return PACK_DATA
