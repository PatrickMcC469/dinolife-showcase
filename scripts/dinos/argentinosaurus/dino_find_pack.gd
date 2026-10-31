extends "res://scripts/dinos/base_dino_find_pack.gd"

const FIND_PACK_DATA: Dictionary = {
	"strong": [
		"You find a great herd moving like a slow wall beneath the sky.",
		"Deep calls roll through the ground as the giants make room in their rhythm.",
		"You find a herd so large its shadows overlap across the trail.",
		"The giants move together with ancient patience, steady enough to trust.",
		"You join a herd whose footsteps make the open world feel smaller.",
	],
	"small": [
		"You find a few giants traveling together across the open land.",
		"A small herd moves slowly along the trail, fewer than you hoped but still comforting.",
		"You find several Argentinosaurus gathered near tall trees, their shadows long and useful.",
		"The herd is small, but even a few giants are better than facing the horizon alone.",
		"You find a modest group whose low calls offer direction and safety.",
	],
	"unstable": [
		"You find a scattered herd drifting across the trail in uneven groups.",
		"The giants accept you, but the deep rhythm feels weak.",
		"You find a herd that moves in the same direction without truly moving together.",
		"Low rumbles pass through the group, but the answers come late.",
		"The herd's shadows are wide apart, leaving too much open space between them.",
	],
	"no_group": [
		"You follow distant rumbles and old giant tracks, but the horizon stays empty.",
		"The trail is broad and trampled, but the herd has already passed.",
		"You search for deep calls across the open land and hear none.",
		"The sky feels too wide without other giants nearby.",
		"You find old footprints filled with dust, but no living herd.",
	],
}

func get_find_pack_data() -> Dictionary:
	return FIND_PACK_DATA
