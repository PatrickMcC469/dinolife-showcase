extends "res://scripts/dinos/base_dino_rest.gd"

const REST_FLAVORS: Dictionary = {
	"first": [
		"You drop into heavy shade, jaws low, giving your wounds time to quiet.",
		"You settle beneath the trees and let your breathing slow through your ribs.",
		"You rest near a fallen trunk, muscles heavy but finally still.",
		"You lower your body into cool earth and let pain fade by inches.",
		"You lie in the shadow of the forest, recovering strength for the next hunt.",
	],
	"second": [
		"You rest again, but hunger and old pain keep your sleep light.",
		"You settle back into shade, gaining what little healing still comes.",
		"You lie still a second time, though your body recovers less now.",
		"You let your jaws rest and your legs loosen, but only slightly.",
		"You take one more useful rest before the season stops giving back.",
	],
	"exhausted": [
		"You remain still, but no more healing comes from rest this season.",
		"You lie in the shade, but your wounds refuse to quiet further.",
		"You rest your heavy body, gaining nothing but time.",
		"You breathe slowly, but the season gives no more recovery.",
		"You stay down, but rest no longer mends you.",
	],
}

func get_rest_flavors() -> Dictionary:
	return REST_FLAVORS
