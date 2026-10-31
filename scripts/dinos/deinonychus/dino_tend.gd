extends "res://scripts/dinos/base_dino_tend.gd"

const TEND_DATA: Dictionary = {
	"success": [
		"You settle low in the brush and clean your wounds with careful, practiced motions.",
		"You fold your feathers close and tend the damage before it can slow the next hunt too much.",
		"You crouch in cover, working dirt and blood away from the places that hurt.",
		"You hold still long enough to care for your wounds, even as your instincts pull you back toward movement.",
		"You tend yourself in the ferns, letting pain quiet beneath feathers and patience.",
	],
	"already_used": [
		"You have already tended your wounds this season, and more attention will not mend them faster.",
		"You check the wounds again, but they need time now.",
		"You settle briefly, but there is nothing more to treat this season.",
		"The damage has already been cleaned as well as it can be.",
		"Your body refuses more progress from tending wounds this season.",
	],
}

func get_tend_data() -> Dictionary:
	return TEND_DATA
