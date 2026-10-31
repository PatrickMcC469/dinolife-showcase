extends "res://scripts/dinos/base_dino_tend.gd"

const TEND_DATA: Dictionary = {
	"success": [
		"You fold into low grass and carefully tend your wounds while the group stays nearby.",
		"You clean the sore places and let your quick legs rest beneath soft cover.",
		"You hide among the plants and give your small body time to settle.",
		"You tend your wounds quietly, ears twitching at every sound around you.",
		"You rest beneath greenery and care for the damage before it worsens.",
	],
	"already_used": [
		"You have already tended your wounds this season, and more care will not help yet.",
		"You check the sore places again, but your body needs time now.",
		"You stay low in the grass, but the wounds have already been treated.",
		"You try to settle the pain again, but no more healing comes from it.",
		"Your body has taken all the care it can this season.",
	],
}

func get_tend_data() -> Dictionary:
	return TEND_DATA
