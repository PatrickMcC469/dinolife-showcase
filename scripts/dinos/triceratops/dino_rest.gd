extends "res://scripts/dinos/base_dino_rest.gd"

const REST_FLAVORS: Dictionary = {
	"first": [
		"You lower yourself within the herd's protection, letting your legs and frill recover.",
		"You rest with your horns angled outward while safety gathers around you.",
		"You settle into the grass, guarded by the steady presence of the herd.",
		"You lower your heavy head and let your body mend in the quiet.",
		"You rest behind larger bodies, letting the pressure of the fight fade.",
	],
	"second": [
		"You rest again, horns angled outward even as your body settles.",
		"You take another quiet pause, though your recovery comes more slowly now.",
		"You remain within the herd, gaining only what healing is left.",
		"You lower yourself once more, using the last useful rest of the season.",
		"You rest with steady breath, but your body is nearly done mending.",
	],
	"exhausted": [
		"You hold still and breathe, but no further healing comes this season.",
		"You remain protected, but your wounds do not improve.",
		"You rest in the herd's shadow, gaining no more recovery.",
		"You lower your head, but the season offers nothing more.",
		"You stay grounded and safe, but rest no longer heals you.",
	],
}

func get_rest_flavors() -> Dictionary:
	return REST_FLAVORS
