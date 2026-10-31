extends "res://scripts/dinos/base_dino_tend.gd"

const TEND_DATA: Dictionary = {
	"success": [
		"You crouch low beside stone and brush, tending the sore places beneath your armor.",
		"You settle into the earth and carefully care for the wounds your plates could not stop.",
		"You clean the damaged spots between armor and let your body rest under its own weight.",
		"You tuck your tail close and tend your wounds in slow, stubborn silence.",
		"You lower yourself into cover and work pain away from the places that still feel exposed.",
	],
	"already_used": [
		"You have already tended your wounds this season, and more care will not help yet.",
		"You settle low again, but the damage has already been treated.",
		"The sore places remain beneath your armor, but nothing more can be done this season.",
		"You check the wounds between your plates, but they need time now.",
		"Your body has already taken all the care it can from tending wounds.",
	],
}

func get_tend_data() -> Dictionary:
	return TEND_DATA
