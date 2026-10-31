extends "res://scripts/dinos/base_dino_rest.gd"

const REST_FLAVORS: Dictionary = {
	"first": [
		"You tuck into dry brush and warm dust, letting your breathing slow.",
		"You rest beneath thorny cover where the wind hides your scent.",
		"You curl into shallow shade, letting your small body recover.",
		"You settle near warm stones, feathers shifting gently in the breeze.",
		"You hide low in the dust and let your tired legs loosen.",
	],
	"second": [
		"You rest again in shallow cover, alert to every shift of wind and sand.",
		"You tuck back into the brush, but your body heals more slowly now.",
		"You settle low once more, taking the last recovery this season can offer.",
		"You rest beneath the thorns again, though the comfort is wearing thin.",
		"You breathe slowly in the dust, gaining only a little more strength.",
	],
	"exhausted": [
		"You try to recover, but your body gains nothing more from rest this season.",
		"You stay hidden in the brush, but no healing follows.",
		"You curl into the dust, safe but no stronger.",
		"You rest your legs, but the season offers no more recovery.",
		"You wait beneath cover, but your wounds do not improve.",
	],
}

func get_rest_flavors() -> Dictionary:
	return REST_FLAVORS
