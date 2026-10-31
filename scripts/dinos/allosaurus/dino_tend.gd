extends "res://scripts/dinos/base_dino_tend.gd"

const TEND_DATA: Dictionary = {
	"success": [
		"You settle heavily beneath the trees and tend your wounds with slow, rough patience.",
		"You clean blood from your hide and let the pain dull under the forest shade.",
		"You lower yourself beside a fallen trunk and give the worst wounds careful attention.",
		"You pause long enough to tend the damage, jaws low and body still.",
		"You work dirt from your wounds and rise feeling steadier than before.",
	],
	"already_used": [
		"You have already tended your wounds this season, and more effort will not speed the healing.",
		"You lower yourself again, but the damage has already been treated.",
		"The wounds still ache, but there is nothing more to do this season.",
		"You check the sore places, but only time will help them now.",
		"Your body has taken all the care it can from tending wounds this season.",
	],
}

func get_tend_data() -> Dictionary:
	return TEND_DATA
