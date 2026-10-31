extends "res://scripts/dinos/base_dino_tend.gd"

const TEND_DATA: Dictionary = {
	"success": [
		"You lower yourself within the herd's protection and tend your wounds with steady patience.",
		"You clean the damaged places while keeping your horns angled toward open ground.",
		"You settle into the grass and give your body the care it needs before standing again.",
		"You tend your wounds beneath the watch of the herd, breathing slow and heavy.",
		"You pause inside the herd's safety and work the pain into something you can carry.",
	],
	"already_used": [
		"You have already tended your wounds this season, and more care will not help yet.",
		"You lower yourself again, but the damage has already been treated.",
		"The wounds still ache, but the season offers no more recovery from tending them.",
		"You check the sore places, but only time can finish the healing now.",
		"Your body has already taken all the care it can this season.",
	],
}

func get_tend_data() -> Dictionary:
	return TEND_DATA
