extends "res://scripts/dinos/base_dino_tend.gd"

const TEND_DATA: Dictionary = {
	"success": [
		"You pause beneath the herd's shadow and tend what wounds your massive body can reach.",
		"You lower your great body into stillness and let careful rest settle the damage.",
		"You stand with the herd nearby, slowly tending the pain before moving on.",
		"You give your enormous body time and care, letting the worst of the hurt quiet.",
		"You rest beneath open sky and tend your wounds as the herd shifts around you.",
	],
	"already_used": [
		"You have already tended your wounds this season, and your body needs time before more care will help.",
		"You pause again, but your wounds have already been treated as well as they can be.",
		"The pain remains heavy, but the season offers no more healing from tending it.",
		"You try to settle the damage again, but only time can carry it further.",
		"Your massive body has taken all the care it can this season.",
	],
}

func get_tend_data() -> Dictionary:
	return TEND_DATA
