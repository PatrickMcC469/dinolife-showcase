extends "res://scripts/dinos/base_dino_tend.gd"

const TEND_DATA: Dictionary = {
	"success": [
		"You settle near the herd path and tend your wounds while familiar footsteps pass nearby.",
		"You clean the damaged places and let your sturdy body recover in the herd's safety.",
		"You lower yourself beside broad leaves and give the worst wounds careful attention.",
		"You pause from the trail long enough to tend the pain and steady your breathing.",
		"You care for your wounds beneath soft cover, close enough to hear the herd move.",
	],
	"already_used": [
		"You have already tended your wounds this season, and more care will not mend them faster.",
		"You check the damage again, but time must do the rest.",
		"You settle near the herd, but the wounds have already been treated.",
		"The sore places remain, but nothing more can be done this season.",
		"Your body has already taken what help it can from tending wounds.",
	],
}

func get_tend_data() -> Dictionary:
	return TEND_DATA
