extends "res://scripts/dinos/base_dino_water.gd"

const WATER_DATA: Dictionary = {
	"clean": [
		"You find clear water pooled in a curled leaf and drink before anything bigger notices.",
		"A thin trickle runs between roots, giving you a clean drink from perfect cover.",
		"You sip fresh rainwater from a stone hollow, quick and hidden.",
	],
	"muddy": [
		"You find a muddy pocket beneath a log and drink what little it offers.",
		"A shallow footprint holds murky water, but it is enough for something your size.",
		"You lap at damp mud between roots, taking what you can before it dries.",
	],
	"risky": [
		"You drink from a puddle surrounded by fresh tracks, staying ready to bolt.",
		"The water smells strange, but thirst wins and you drink fast.",
		"You find water near a busy trail and steal a quick drink between distant footsteps.",
	],
	"danger": [
		"You find rainwater pooled in a curled leaf, but a hidden insect bites your snout before you finish drinking.",
		"You sip from a tiny puddle between roots, but something sharp nips your foot and vanishes into the mud.",
		"You reach a damp hollow under a log, but a startled beetle pinches you before scurrying away.",
		"You drink from a shallow track, but a tiny leech clings to your jaw before you shake it loose.",
		"You find enough water to help, but a hidden thorn tears your side as you dart back into cover.",
		"You lap water from a stone crack, but a small frog snaps at your face before hopping away.",
		"You drink quickly beneath the ferns, but biting insects swarm your legs until you flee.",
		"You find a safe-looking puddle, but the sour taste burns your throat before you stop.",
	],
	"dry": [
		"You search roots, leaves, and old tracks, but find no drinkable water.",
		"Every damp scent fades before it leads anywhere useful.",
		"The ground is dry, and every leaf you check is empty.",
	],
}

func get_water_data() -> Dictionary:
	return WATER_DATA
