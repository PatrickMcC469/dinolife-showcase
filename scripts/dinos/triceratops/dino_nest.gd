extends "res://scripts/dinos/base_dino_nest.gd"

# Triceratops — nesting phase flavor text

const NEST_DATA: Dictionary = {
	"tend": [
		"You move between the calves, keeping them in the tightest circle you can manage. The open grass can wait.",
		"A calf has drifted toward the edge of safe ground. You walk to it and turn it back toward the center. It follows.",
		"You stand at the edge of the group and face outward, watching the tree line. The calves rest behind you.",
		"Two calves are pushing each other in play. You move through them until they redirect their energy. Not now, not here.",
		"You lead the calves through a short loop of familiar ground, keeping their legs moving and their eyes busy.",
		"You make a low sound — come close, stay still, don't wander. The calves are starting to understand it.",
	],
	"already_used": [
		"The calves have the circle, the calls, and the safe loops. This season's tending is finished.",
		"You have kept them close and taught them the signals. More laps around the safe ground won't add to that.",
		"The calves know the center from the edge now. What they carry, they carry into next season.",
		"You have done your work with them. The herd holds the rest of what they need.",
	],
	"outcome_exceptional": [
		"The young leave with firm steps, strong bodies, and the first true shape of living walls.",
		"They carry the herd circle with them, brave, steady, and hard to frighten.",
		"Their small horns point toward the world with confidence earned through every season.",
	],
	"outcome_good": [
		"The calves move on with steadier legs and better instincts for the herd's defense.",
		"They know when to stay close, when to brace, and when to move.",
		"Their bodies are stronger now, and their courage has begun to settle.",
	],
	"outcome_okay": [
		"The calves move on with steadier legs and better instincts for the herd's defense.",
		"They know when to stay close, when to brace, and when to move.",
		"Their bodies are stronger now, and their courage has begun to settle.",
	],
	"outcome_neutral": [
		"The young Triceratops leave with fair strength and half-formed confidence.",
		"They can stand, feed, and follow, but danger will test every lesson.",
		"Their horns are small, their bodies growing, and their future undecided.",
	],
	"outcome_poor": [
		"The calves survive to leave, but their stance is uncertain and their strength uneven.",
		"They know the herd circle, but not enough of its discipline.",
		"Their first independent steps are heavy with hesitation.",
	],
	"outcome_failed": [
		"The calves leave the circle too weak, too nervous, and too slow to brace when danger shifts.",
		"Their soft frills and shaky courage make the open ground feel cruel.",
		"They step away from the herd's safety before they truly understand how to stand.",
	],
}

func get_nest_data() -> Dictionary:
	return NEST_DATA
