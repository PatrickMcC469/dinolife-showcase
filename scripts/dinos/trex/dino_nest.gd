extends "res://scripts/dinos/base_dino_nest.gd"

# T-Rex — nesting phase flavor text

const NEST_DATA: Dictionary = {
	"tend": [
		"You move around the nest with slow, heavy steps. The young track you from inside the hollow. Everything nearby knows you are here.",
		"You drag what remains of a kill closer to the young and leave them to it. They eat loudly and without skill. That will change.",
		"The young are fighting over what little is left in the hollow. You lower your head between them. They scatter, then settle.",
		"One of the young won't stop vocalizing. You remain motionless nearby until it quiets. Noise costs too much out here.",
		"You scan the perimeter slowly, head moving in wide arcs. The young inside the hollow watch how you do it.",
		"The largest of the young has been pushing the others. You shoulder it aside once. The order of the nest shifts.",
	],
	"already_used": [
		"The nest is marked. The young have been fed. The season's care is done.",
		"You have set the order and kept the perimeter. What the young have now, they carry until they grow into it.",
		"More time at the nest changes nothing. The young know what they know.",
		"You have given them what this season allows. The rest is the world's work, and theirs.",
	],
	"outcome_exceptional": [
		"The young tyrants leave with power in their bodies and fire in their hunger.",
		"Their first independent steps shake with promise, small now, but not for long.",
		"They are ready to survive, grow, and one day make the world move aside.",
	],
	"outcome_good": [
		"The young leave heavier, steadier, and more dangerous than before.",
		"Their hunger remains huge, but now their bodies can begin to answer it.",
		"They step into the wild with stronger jaws and better instincts.",
	],
	"outcome_okay": [
		"The young leave heavier, steadier, and more dangerous than before.",
		"Their hunger remains huge, but now their bodies can begin to answer it.",
		"They step into the wild with stronger jaws and better instincts.",
	],
	"outcome_neutral": [
		"The young T-Rex leave the nest with enough strength to try and enough hunger to keep moving.",
		"They are not strong yet, but they are no longer helpless.",
		"Their future is uncertain, balanced between power and danger.",
	],
	"outcome_poor": [
		"They survive to leave, but their hunger has outgrown their strength.",
		"The young move on with rough instincts and uneven bodies.",
		"They are alive, but their first steps alone feel heavy with risk.",
	],
	"outcome_failed": [
		"The young tyrants leave thin, loud, and ruled by hunger. Even their courage feels dangerous.",
		"Their oversized heads and sharp cries cannot hide how weak their start has been.",
		"They stumble into independence desperate, noisy, and badly prepared for a world that bites back.",
	],
}

func get_nest_data() -> Dictionary:
	return NEST_DATA
