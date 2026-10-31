extends "res://scripts/dinos/base_dino_water.gd"

const WATER_DATA: Dictionary = {
	"clean": [
		"You find a clear stream along the herd path and drink while familiar bodies move nearby.",
		"Fresh water pools beside broad leaves, giving you a calm, steady drink.",
		"You lower your head to clean running water where the herd has passed safely.",
	],
	"muddy": [
		"You drink from a muddy hollow left by larger feet, taking what the trail offers.",
		"A low basin along the herd route holds cloudy water, but enough to help.",
		"Mud swirls around your mouth as you drink from a trampled pool.",
	],
	"risky": [
		"You drink from a pool near fresh predator scent, staying close to the herd's path.",
		"The water tastes strange, but you take what you need and move on.",
		"The bank feels unstable beneath your weight, so you drink carefully and leave.",
	],
	"danger": [
		"You drink from a muddy pool, but something in the reeds snaps at your forelimb before fleeing.",
		"You follow the herd to water, but the bank crumbles and scrapes your shoulder.",
		"You lower your head to drink, but hidden stones bruise your foot as you shift position.",
		"You drink enough to recover, but biting insects gather under your belly.",
		"You reach a shaded stream, but a sharp branch catches your thumb spike as you pull away.",
		"You drink beside thick ferns, but something small bites your leg and disappears into the plants.",
		"You find water, but the mud sucks around your feet and strains your stride.",
		"You drink from a shallow pool, but the water tastes wrong and leaves you uneasy.",
	],
	"dry": [
		"You follow the herd's water signs, but the trail leads to dry ground.",
		"The plants are wilted, the mud is cracked, and no drink waits nearby.",
		"You search the old route, but the water has already gone.",
	],
}

func get_water_data() -> Dictionary:
	return WATER_DATA
