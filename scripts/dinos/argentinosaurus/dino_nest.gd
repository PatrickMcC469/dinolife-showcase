extends "res://scripts/dinos/base_dino_nest.gd"

# Argentinosaurus — nesting phase flavor text

const NEST_DATA: Dictionary = {
	"tend": [
		"You move alongside the young with slow, careful steps. Your footfalls shake the ground. They learn to feel that rhythm.",
		"One young one has strayed wide. You call with a low rumble and feel the response ripple through the ground.",
		"The young are bunched too far ahead of the herd. You urge them back with soft sounds and steady movement. They slow.",
		"You place yourself between the young and the open edge of the range. The herd shifts around you and closes.",
		"You move through the young group once, slowly — flank to flank, neck against neck. Each one receives contact. They settle.",
		"The young gather under your shadow and rest. The sky above them is wide, but for now your body makes it smaller.",
	],
	"already_used": [
		"The young know your rhythm and your shadow. The herd has closed around them. More tending won't change what they carry.",
		"You have made the contacts, sounded the calls, and kept the young inside the herd's reach. The season's work is done.",
		"They have your rumble in their bones and the herd's shape around them. More time here is more than the season asks.",
		"The young take what the season has given them. The herd carries the rest.",
	],
	"outcome_exceptional": [
		"The young giants leave strong, calm, and deeply tuned to the rhythm of the herd.",
		"Their first independent steps are steady, promising, and full of future size.",
		"They move beneath the sky with strength in their legs and the herd's memory in their bones.",
	],
	"outcome_good": [
		"The young leave with steadier legs, stronger necks, and a better sense of the herd's deep calls.",
		"They move forward with enough strength to keep pace beneath the open sky.",
		"Their steps are slow but sure, carrying them toward the giants they may become.",
	],
	"outcome_okay": [
		"The young leave with steadier legs, stronger necks, and a better sense of the herd's deep calls.",
		"They move forward with enough strength to keep pace beneath the open sky.",
		"Their steps are slow but sure, carrying them toward the giants they may become.",
	],
	"outcome_neutral": [
		"The young Argentinosaurus leave with fair strength and a long road ahead.",
		"They can follow, feed, and move, though not always with confidence.",
		"Their future is enormous, but still fragile at the start.",
	],
	"outcome_poor": [
		"The young survive to leave, but they tire quickly and miss too many herd signals.",
		"Their steps are uncertain, and the open world feels too large around them.",
		"They move on with thin strength and uneven rhythm.",
	],
	"outcome_failed": [
		"The young giants leave weak beneath the wide sky, struggling to keep pace without the safest shadows.",
		"Their long necks droop with hunger, and their steps fall out of rhythm too easily.",
		"They are large with promise, but their start has left them dangerously fragile.",
	],
}

func get_nest_data() -> Dictionary:
	return NEST_DATA
