extends "res://scripts/dinos/base_dino_find_pack.gd"

const FIND_PACK_DATA: Dictionary = {
	"no_male": [
		"You find a quiet raptor group moving through dust and thornbrush. They notice you quickly, but no male steps forward to challenge you.",
		"A few Velociraptors share a narrow hunting path ahead. Their signals are cautious, but there is room in the pattern.",
		"You find a group resting in dry cover. They watch you with sharp eyes, but none move to drive you away.",
		"The dust trail leads to raptors moving together in careful silence. Their formation shifts just enough for you to join.",
		"You catch the scent of a small group near the brushline. They are wary, but the path remains open.",
	],
	"dominant_male": [
		"You find a raptor group using a prime dust trail, but a dominant male steps forward with lifted feathers and a flexed sickle claw.",
		"The group's quiet pattern breaks as a male blocks your path, his eyes fixed on you instead of the others.",
		"You approach a useful pack, but the male at its center lowers his body and dares you to come closer.",
		"A strong scent marks the group before you reach them. The dominant male appears from the brush, ready to defend his place.",
		"You find a pack worth joining, but its male leader moves first, silent, sharp, and unwilling to share control.",
	],
	"no_group": [
		"You follow tracks through dust and thornbrush, but every trail ends alone.",
		"The wind carries old raptor scent, but no living group answers.",
		"You search the dry paths carefully, but the pattern never forms.",
		"You find claw marks and feather traces, but the pack has moved on.",
		"The brush stays silent, and the dust gives you no group to follow.",
	],
}

func get_find_pack_data() -> Dictionary:
	return FIND_PACK_DATA
