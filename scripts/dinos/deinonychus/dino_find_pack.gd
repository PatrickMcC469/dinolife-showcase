extends "res://scripts/dinos/base_dino_find_pack.gd"

const FIND_PACK_DATA: Dictionary = {
	"strong": [
		"You hear coordinated calls moving through the brush and find a pack already hunting in rhythm.",
		"A strong pack emerges from the ferns, tense and focused, with room for another hunter.",
		"You find Deinonychus moving together in clean formation, each one reading the others without wasted motion.",
		"The pack's scent is fresh, their calls are sharp, and their hunting rhythm feels steady.",
		"You find a group that moves like a trap closing, dangerous and organized.",
	],
	"small": [
		"You find two Deinonychus following an old prey trail, cautious but willing to let you near.",
		"A small pack watches you from the ferns, thin but alert enough to survive together.",
		"You find a few hunters sharing calls beside a muddy path, not strong in number but better than being alone.",
		"A small group moves through the brush with careful steps, leaving space for you to follow.",
		"You find a pair of Deinonychus resting beneath cover, guarded but not hostile.",
	],
	"unstable": [
		"You find a tense pack with raised feathers and broken timing.",
		"The group lets you approach, but every hunter seems one bad moment away from snapping.",
		"You find a pack that moves together only because none of them wants to be alone.",
		"The calls are uneven, the spacing is wrong, and trust feels thin.",
		"You join a group with useful numbers, but the bond already feels fragile.",
	],
	"no_group": [
		"Your calls pass through the trees without answer.",
		"You follow prey trails and old scent, but no pack waits at the end.",
		"Every claw mark you find is old, weathered, and useless.",
		"You search the brush for familiar calls, but the forest stays silent.",
		"The trails split too many ways, and none lead to your kind.",
	],
}

func get_find_pack_data() -> Dictionary:
	return FIND_PACK_DATA
