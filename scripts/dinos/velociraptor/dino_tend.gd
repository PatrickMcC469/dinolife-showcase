extends "res://scripts/dinos/base_dino_tend.gd"

const TEND_DATA: Dictionary = {
	"success": [
		"You slip into dry cover and clean your wounds while the wind hides your scent.",
		"You crouch beneath thornbrush, carefully tending the damage before moving on.",
		"You work grit and blood from your wounds, staying low and silent.",
		"You rest in the dust long enough to make the pain less sharp.",
		"You tend yourself in shallow shade, careful not to leave too much scent behind.",
	],
	"already_used": [
		"You have already tended your wounds this season, and the rest must come with time.",
		"You check the sore places again, but nothing more can be done now.",
		"You settle in cover, but the wounds have already been treated.",
		"You try to clean away more pain, but the season offers no further relief.",
		"Your body has already taken what help it can from this care.",
	],
}

func get_tend_data() -> Dictionary:
	return TEND_DATA
