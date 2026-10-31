extends "res://scripts/dinos/base_dino_rest.gd"

const REST_FLAVORS: Dictionary = {
	"first": [
		"You lower your massive body into cover, letting the forest go quiet around your breathing.",
		"You settle heavily beneath the trees, giving your muscles time to recover.",
		"You rest in deep shade, jaws slack and body still.",
		"You lie near the brushline, letting pain dull beneath your weight.",
		"You stop moving long enough for your huge body to mend.",
	],
	"second": [
		"You rest again, heavy and watchful, but your body recovers more slowly now.",
		"You settle down once more, gaining only what healing remains.",
		"You lie still in the shade, but the recovery feels weaker this time.",
		"You breathe deeply and rest again, though hunger keeps you uneasy.",
		"You give your wounds one last useful season of quiet.",
	],
	"exhausted": [
		"You try to rest, but this season has no more healing to give.",
		"You lie still, but your wounds do not improve.",
		"You lower your head and wait, gaining no recovery.",
		"You remain in cover, but rest no longer helps.",
		"You breathe heavily in the shade, but nothing mends further.",
	],
}

func get_rest_flavors() -> Dictionary:
	return REST_FLAVORS
