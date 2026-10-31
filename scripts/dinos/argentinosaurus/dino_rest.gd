extends "res://scripts/dinos/base_dino_rest.gd"

const REST_FLAVORS: Dictionary = {
	"first": [
		"You pause beneath the herd's towering shadows, letting your giant body recover step by step.",
		"You rest where the herd gathers, breathing slowly above the ferns.",
		"You settle into stillness, letting your massive legs recover from the trail.",
		"You stand quietly in the herd's protection while your body mends.",
		"You lower your great neck and let the world move around you for a while.",
	],
	"second": [
		"You rest again, breathing slowly as the herd shifts around you.",
		"You pause once more, though your huge body recovers more slowly now.",
		"You take another season of stillness, gaining what healing remains.",
		"You rest beneath open sky, but the recovery comes weaker this time.",
		"You stand with the herd and use the last useful rest this season offers.",
	],
	"exhausted": [
		"You stand or settle in place, but no more healing comes from rest this season.",
		"You remain with the herd, but your body gains nothing more.",
		"You pause beneath the sky, safe but no stronger.",
		"You breathe slowly, but the season gives no further recovery.",
		"You rest your giant frame, but nothing more mends.",
	],
}

func get_rest_flavors() -> Dictionary:
	return REST_FLAVORS
