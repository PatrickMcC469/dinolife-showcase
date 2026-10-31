extends "res://scripts/dinos/base_dino_water.gd"

const WATER_DATA: Dictionary = {
	"clean": [
		"You find a small clear stream and drink quickly with your body half-hidden in grass.",
		"Fresh rainwater waits in a shallow print, clean enough for a careful drink.",
		"Dewy leaves and a tiny pool give you a safe, quiet drink.",
	],
	"muddy": [
		"You drink from a muddy hollow beneath low plants, then hurry back to cover.",
		"A damp dip in the ground gives you just enough water to keep going.",
		"The water is cloudy, but the group is nearby and the drink is worth it.",
	],
	"risky": [
		"You drink from an exposed puddle, ears twitching at every sound.",
		"The water smells odd, but you take a few quick mouthfuls before retreating.",
		"Fresh predator scent crosses the damp ground, so you drink fast and leave.",
	],
	"danger": [
		"You find water beneath low plants, but a hidden bite catches you before you spring away.",
		"You drink from a tiny puddle, but a startled frog bumps into you and sends you stumbling.",
		"You sip from a muddy track, but sharp grass cuts your legs as you flee.",
		"You find damp leaves to lick clean, but biting insects swarm your face.",
		"You drink from a shallow pool, but something moves nearby and panic sends you crashing through thorns.",
		"You reach water with the group nearby, but a hidden thorn scrapes your belly as you duck low.",
		"You find enough water to help, but the mud pulls at your feet and strains your legs.",
		"You drink quickly, but a sour taste makes your stomach twist before you move on.",
	],
	"dry": [
		"You search the low plants and shallow prints, but no water remains.",
		"The group moves through dry grass, finding nothing to drink.",
		"Every safe puddle is empty by the time you reach it.",
	],
}

func get_water_data() -> Dictionary:
	return WATER_DATA
