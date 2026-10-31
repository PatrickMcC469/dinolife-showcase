extends "res://scripts/dinos/base_dino_nest.gd"

# Velociraptor — nesting phase flavor text

const NEST_DATA: Dictionary = {
	"tend": [
		"You lead the young through the low brush in silence. No calls, no noise. They are learning what quiet movement looks like.",
		"A young one steps out of cover into open ground. You call it back immediately. It hesitates, then returns.",
		"You press against the scrub and disappear almost entirely. The young watch, then try to follow your example.",
		"You move through the group, pausing at the ones that have been quietest. Quiet can mean scared. You stay close to those.",
		"You scan — eyes to the ridge, nose to the wind, back down. You repeat it until the young begin mirroring it.",
		"One has been running where it should be walking. You cut in front of it twice. By the third time, it slows on its own.",
	],
	"already_used": [
		"The young know the cover. They know how to stay still and when to move. This season's teaching is done.",
		"You have drilled silence and cover into them. The dust holds what was practiced here.",
		"They carry what you showed them. More instruction won't change what this season has already set.",
		"The lessons are in them. The rest depends on how well they hold them when the ground is unfamiliar.",
	],
	"outcome_exceptional": [
		"The young vanish into dust and thornbrush like they belong there.",
		"They leave with quiet steps, steady hunger, and the first true shape of hunters.",
		"The pack's pattern lives in them now, silent, sharp, and ready.",
	],
	"outcome_good": [
		"The young move through the brush with careful feet and sharper instincts.",
		"They leave the nest quieter than before, reading scent, wind, and shadow.",
		"Their first independent steps are cautious, controlled, and promising.",
	],
	"outcome_okay": [
		"The young move through the brush with careful feet and sharper instincts.",
		"They leave the nest quieter than before, reading scent, wind, and shadow.",
		"Their first independent steps are cautious, controlled, and promising.",
	],
	"outcome_neutral": [
		"The young raptors leave with uneven skills, some quiet, some careless.",
		"They step into the dust with a fair chance, though the trail ahead is sharp.",
		"They have learned enough to try, but not enough to be safe.",
	],
	"outcome_poor": [
		"They survive long enough to leave, but hunger and poor timing follow them.",
		"The young move into the brush with more boldness than sense.",
		"They know how to run, but not yet when to hide.",
	],
	"outcome_failed": [
		"The young raptors leave too exposed, leaving tracks and noise where silence should be.",
		"Their first steps into independence are restless and confused. The dust keeps their mistakes.",
		"They slip from the nest with weak bodies and poor caution, easy for the world to notice.",
	],
}

func get_nest_data() -> Dictionary:
	return NEST_DATA
