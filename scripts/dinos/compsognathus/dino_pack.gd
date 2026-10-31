extends "res://scripts/dinos/base_dino_pack.gd"

const PACK_DATA: Dictionary = {
	"fracture": [
		"The tiny calls around you have grown scattered and uncertain. The group is still near, but the pack feels ready to split.",
		"Other compies keep drifting farther from your hiding paths. Hunger and fear are pulling the group apart.",
		"The undergrowth feels quieter than it should. The pack's shared warning chirps are fading.",
		"You catch familiar scents moving in different directions. The pack may not stay together much longer.",
		"The group hesitates at every sound, each compi thinking more about itself than the others.",
	],
	"push_success": [
		"You share scraps, answer calls, and keep the group moving together. The pack holds for now.",
		"You keep close to the others, trading warning chirps until the scattered group settles again.",
		"A few quick calls and shared food scraps pull the pack back into rhythm.",
		"You stay visible in the ferns and the others begin following your movements again.",
		"The pack remains nervous, but it does not break today.",
	],
	"push_failure": [
		"You try to hold them close, but the others scatter into the leaves one by one.",
		"Your calls go unanswered. The pack breaks apart beneath the ferns.",
		"Hunger wins over safety, and the group splits in different directions.",
		"You chase after the fading chirps, but they vanish into the undergrowth.",
		"The pack is gone before you can pull it back together.",
	],
	"release": [
		"You let the others scatter into the leaves without chasing them.",
		"The pack fades into the undergrowth, and you do not call them back.",
		"One by one, the familiar chirps grow distant until you are alone.",
		"You watch the group split and save your energy for yourself.",
		"The small shadows vanish into the ferns, leaving only your own path.",
	],
}

func get_pack_data() -> Dictionary:
	return PACK_DATA
