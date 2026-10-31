extends "res://scripts/dinos/base_dino_water.gd"

const WATER_DATA: Dictionary = {
	"clean": [
		"You find a shaded stream beneath the trees and drink deeply from the bank.",
		"Clear water runs over stone, giving you a solid drink before you move on.",
		"A storm-fed pool sits beneath broken rock, fresh enough to satisfy your thirst.",
	],
	"muddy": [
		"You drink from a muddy pool near trampled plants, ignoring the heavy taste.",
		"A churned hollow beside a prey trail holds enough water to be useful.",
		"The water is thick with mud, but it keeps your body moving.",
	],
	"risky": [
		"You drink at a river bend heavy with rival scent and leave before testing the owner.",
		"The bank is unstable and the water smells old, but you drink what you can.",
		"Fresh tracks crowd the pool, making every mouthful feel watched.",
	],
	"danger": [
		"You drink from the riverbank, but sharp movement in the water catches your jaw before slipping away.",
		"You find a muddy pool, but the bank collapses under your weight and scrapes your leg.",
		"You lower your head to drink, but a hidden creature bites your snout and disappears into the reeds.",
		"You drink enough to recover, but jagged stones cut your foot as you step back.",
		"You find water near a trampled trail, but biting insects gather around old wounds.",
		"You drink from a shaded stream, but the mud sucks at your legs and strains your movement.",
		"You reach a pool, but a startled animal kicks mud and stones into your face before fleeing.",
		"You drink from the bank, but a rival scent forces you away before you can fully settle.",
	],
	"dry": [
		"You search the brush and dry streambeds, but every scent is too old.",
		"The trail promises water, then ends in cracked mud.",
		"You find only dust, dry stones, and old footprints.",
	],
}

func get_water_data() -> Dictionary:
	return WATER_DATA
