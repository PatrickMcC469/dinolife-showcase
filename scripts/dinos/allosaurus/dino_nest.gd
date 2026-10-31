extends "res://scripts/dinos/base_dino_nest.gd"

# Allosaurus — nesting phase flavor text

const NEST_DATA: Dictionary = {
	"tend": [
		"You move along the edge of the nest, watching the trees. Anything that approaches will have to come through you.",
		"One of the young is testing its jaws on a branch too loudly. You nudge it back into the group. It quiets.",
		"You drag a portion of old kill closer to the nest. The young tear into it with more enthusiasm than skill.",
		"The hatchlings are restless. You lower yourself beside them and they press close and settle.",
		"A young one has wandered toward the brush edge. You cut off the path with your body. It turns back.",
		"You make a slow pass around the perimeter. No new scents. The nest is secure for now.",
	],
	"already_used": [
		"The nest is guarded and the young are fed. More attention here costs you the energy you need for the next hunt.",
		"You have put your time into this nest. What the young have now is what the season will test.",
		"The young know the perimeter and they know your presence. More passes won't sharpen what they already carry.",
		"This season's tending is done. The young take what they have into the world when the time comes.",
	],
	"outcome_exceptional": [
		"The young leave powerful for their age, calmer, heavier, and harder to push aside.",
		"Their jaws, instincts, and bodies all show the strength of a good start.",
		"They move from the nest like future hunters, loud enough to warn the forest and strong enough to mean it.",
	],
	"outcome_good": [
		"The young leave with stronger legs, steadier hunger, and jaws ready to work.",
		"They step into the forest as real young predators, still clumsy but capable.",
		"Their first independent season begins with weight, strength, and promise.",
	],
	"outcome_okay": [
		"The young leave with stronger legs, steadier hunger, and jaws ready to work.",
		"They step into the forest as real young predators, still clumsy but capable.",
		"Their first independent season begins with weight, strength, and promise.",
	],
	"outcome_neutral": [
		"The young Allosaurus leave the nest with growing jaws and uncertain judgment.",
		"They are strong enough to try, though the forest will not be gentle.",
		"Their bodies have grown, but their instincts still need hard lessons.",
	],
	"outcome_poor": [
		"They leave with enough strength to survive, but not enough discipline to thrive.",
		"The young stumble into independence still fighting hunger and each other.",
		"They carry predator blood, but their start has left them rough and uneven.",
	],
	"outcome_failed": [
		"The young leave loud, hungry, and poorly controlled, drawing trouble before they understand strength.",
		"Their jaws are ready before their instincts are. The forest will punish that.",
		"The hatchlings age out thin and restless, more desperate than dangerous.",
	],
}

func get_nest_data() -> Dictionary:
	return NEST_DATA
