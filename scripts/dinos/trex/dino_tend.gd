extends "res://scripts/dinos/base_dino_tend.gd"

const TEND_DATA: Dictionary = {
	"success": [
		"You lower your massive body into cover and tend your wounds with slow, heavy patience.",
		"You clean blood from your hide and let the forest grow quiet around your breathing.",
		"You pause beneath the trees, giving your damaged body time and care.",
		"You work at the worst wounds until the pain settles beneath your weight.",
		"You rest your jaws low and tend the damage before the next challenge finds you.",
	],
	"already_used": [
		"You have already tended your wounds this season, and your body needs time now.",
		"You settle again, but the wounds will not improve from more attention.",
		"The pain remains, but there is nothing more to treat this season.",
		"You check the damage, but even a tyrant cannot force healing twice.",
		"Your body has already taken what care it can this season.",
	],
}

func get_tend_data() -> Dictionary:
	return TEND_DATA
