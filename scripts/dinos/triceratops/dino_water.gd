extends "res://scripts/dinos/base_dino_water.gd"

const WATER_DATA: Dictionary = {
	"clean": [
		"You find a clean stream and drink with your horns angled toward open ground.",
		"Fresh rainwater fills a broad hollow, calm enough for a safe drink.",
		"The herd gathers near clear water, and you drink from within its protection.",
	],
	"muddy": [
		"You drink from a muddy hollow near trampled grass, feet planted firm.",
		"A churned pool offers cloudy water, but it is enough for now.",
		"Mud clings to your mouth as you drink from a low basin beside the herd trail.",
	],
	"risky": [
		"You drink from an exposed pool while the herd shifts uneasily nearby.",
		"The water smells stale, but you take enough before moving away.",
		"Fresh tracks cross the bank, and you drink with your frill turned toward the wind.",
	],
	"danger": [
		"You reach water with the herd nearby, but a small hidden threat bites before you can pull back.",
		"You drink from a muddy bank, but the ground shifts and jars your foreleg.",
		"You lower your head to drink, but a sharp stone scrapes beneath your frill.",
		"You find water, but biting insects swarm around your eyes and horn bases.",
		"You drink from a trampled pool, but another animal's panic sends a shove through the herd.",
		"You get enough water, but thick mud grips your feet and strains your stance.",
		"You drink beside reeds, but something snaps at your nose and vanishes.",
		"You reach a pool, but the water tastes foul and leaves you unsettled.",
	],
	"dry": [
		"The herd tests the nearby water spots, but each one is dry.",
		"You find cracked mud where a pool should have been.",
		"The trail offers prints, dust, and old scent, but no water.",
	],
}

func get_water_data() -> Dictionary:
	return WATER_DATA
