extends "res://scripts/dinos/base_dino_pack.gd"

const PACK_DATA: Dictionary = {
	"fracture": [
		"The herd's deep rhythm has weakened, and the great bodies around you drift apart.",
		"The trail no longer moves as one. Each giant step feels less connected to the next.",
		"Low rumbles pass through the herd, but the answers come late and uncertain.",
		"The young stay close while the older giants begin to choose separate paths.",
		"The herd's shadow feels thinner, and the open world presses in.",
	],
	"push_success": [
		"You follow the deep calls and help draw the herd back into a shared path.",
		"Slow, steady movement brings the giants closer again.",
		"The herd's rhythm returns one step at a time.",
		"Your effort helps the scattered bodies gather into one moving wall.",
		"The herd remains restless, but its great shadows overlap again.",
	],
	"push_failure": [
		"You try to follow and call, but the herd's rhythm breaks apart.",
		"The giants drift away, too slow to seem sudden but too far to stop.",
		"The old path divides, and no rumble brings the herd back together.",
		"One massive shape follows another away from the shared trail.",
		"Your effort fades beneath the weight of too many separate footsteps.",
	],
	"release": [
		"You let the herd's path divide and do not spend strength forcing it whole.",
		"The great shadows separate, and you accept the open space between them.",
		"The herd moves on in different directions, slow and final.",
		"You stop following the fading rumbles and choose your own trail.",
		"The giants drift apart beneath the sky, and you let the herd go.",
	],
}

func get_pack_data() -> Dictionary:
	return PACK_DATA
