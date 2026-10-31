extends "res://scripts/dinos/base_dino_pack.gd"

const PACK_DATA: Dictionary = {
	"fracture": [
		"The herd's path feels uneven. Too many bodies hesitate, and too few follow.",
		"Warning calls pass through the group, but no one seems sure where to move.",
		"The herd is drifting apart, each small cluster choosing its own direction.",
		"The old rhythm of travel, graze, and watch is breaking down.",
		"You feel the herd thinning around you, and the trail ahead no longer feels shared.",
	],
	"push_success": [
		"You keep moving with purpose, and the herd slowly gathers behind that certainty.",
		"Steady steps and familiar calls pull the scattered herd back together.",
		"You hold near the group until the nervous clusters rejoin.",
		"The herd regains its path, uneasy but moving as one again.",
		"Your effort steadies the group, and the shared trail continues.",
	],
	"push_failure": [
		"You try to guide the herd, but too many turn away.",
		"The group splits across the trail, and no call pulls it back.",
		"Familiar footsteps fade in different directions.",
		"The herd's rhythm breaks, leaving scattered paths where one trail should be.",
		"You push to hold them together, but the herd has already chosen to divide.",
	],
	"release": [
		"You let the herd split and follow your own path.",
		"The scattered groups move on without struggle, and you do not pull them back.",
		"The shared trail ends quietly beneath many fading footsteps.",
		"You watch the herd divide, saving your strength for the road ahead.",
		"The others move beyond your call, and you let them go.",
	],
}

func get_pack_data() -> Dictionary:
	return PACK_DATA
