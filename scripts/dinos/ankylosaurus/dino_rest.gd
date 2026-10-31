extends "res://scripts/dinos/base_dino_rest.gd"

const REST_FLAVORS: Dictionary = {
	"first": [
		"You crouch low beside stone and brush, letting your armor-covered body recover.",
		"You settle into the earth, plates rising and falling with each slow breath.",
		"You rest beneath thick cover, tail tucked close and body still.",
		"You lower yourself near cool stone, letting your heavy frame mend.",
		"You stay low and quiet, recovering beneath the safety of your armor.",
	],
	"second": [
		"You rest again, tail tucked close and plates rising with each slow breath.",
		"You settle low once more, though your body recovers less this time.",
		"You take another stubborn rest, gaining what little healing remains.",
		"You stay sheltered behind stone and brush, but the recovery is fading.",
		"You rest heavily, using the last useful healing this season can offer.",
	],
	"exhausted": [
		"You remain sheltered, but your body cannot recover any more this season.",
		"You crouch low, safe but no stronger.",
		"You rest beneath your plates, but nothing mends further.",
		"You stay still in cover, gaining no more healing.",
		"You breathe slowly near the stone, but the season gives nothing back.",
	],
}

func get_rest_flavors() -> Dictionary:
	return REST_FLAVORS
