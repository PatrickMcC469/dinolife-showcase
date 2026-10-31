extends "res://scripts/dinos/base_dino_pack.gd"

const PACK_DATA: Dictionary = {
	"fracture": [
		"The herd circle feels loose, with too much space between horns.",
		"The group no longer braces together when danger moves nearby.",
		"Warning snorts pass through the herd, but the response is slow and uncertain.",
		"The young press close while adults drift apart, and the herd's wall feels weaker.",
		"The ground between you feels open in a way it should not.",
	],
	"push_success": [
		"You stand firm and the herd tightens around your presence.",
		"A few strong steps and warning snorts bring the circle back together.",
		"The herd reforms, horns outward and bodies close.",
		"Your effort steadies the group until the defensive line feels whole again.",
		"The herd remains tense, but it holds its shape.",
	],
	"push_failure": [
		"You try to tighten the herd, but the circle breaks apart.",
		"The warning snorts scatter instead of gathering strength.",
		"One group moves away, then another, until the line is gone.",
		"The herd refuses to brace together, and the shared defense collapses.",
		"Your push fails, and the herd divides beyond your control.",
	],
	"release": [
		"You let the herd separate without forcing the circle closed.",
		"The defensive line breaks cleanly, and you do not call it back.",
		"The others move away in smaller groups, horns still lowered but no longer together.",
		"You watch the herd split and choose not to spend strength holding it.",
		"The wall of bodies opens, and you let the gap remain.",
	],
}

func get_pack_data() -> Dictionary:
	return PACK_DATA
