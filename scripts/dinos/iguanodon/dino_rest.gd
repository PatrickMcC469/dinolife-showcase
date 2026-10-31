extends "res://scripts/dinos/base_dino_rest.gd"

const REST_FLAVORS: Dictionary = {
	"first": [
		"You settle near the herd's path, letting your sturdy body recover between safe shadows.",
		"You rest beneath broad leaves while the herd moves calmly nearby.",
		"You lower yourself into soft ground, letting your legs and shoulders mend.",
		"You pause beside thick ferns and let the quiet restore you.",
		"You rest close to familiar footsteps, recovering strength in the herd's safety.",
	],
	"second": [
		"You rest again, close enough to hear the herd move around you.",
		"You settle down once more, but your body recovers more slowly now.",
		"You take another careful rest while the herd watches the trail.",
		"You remain near the group, gaining only a little more healing.",
		"You rest in safe cover again, using the last recovery this season offers.",
	],
	"exhausted": [
		"You remain at rest, but your body gains no more healing this season.",
		"You stay near the herd, but no more wounds improve.",
		"You settle into the grass, safe but no stronger.",
		"You rest your legs, but the season gives nothing back.",
		"You breathe quietly beside the trail, but no further healing comes.",
	],
}

func get_rest_flavors() -> Dictionary:
	return REST_FLAVORS
