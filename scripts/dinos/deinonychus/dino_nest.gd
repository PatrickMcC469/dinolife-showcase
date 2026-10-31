extends "res://scripts/dinos/base_dino_nest.gd"

# Deinonychus — nesting phase flavor text

const NEST_DATA: Dictionary = {
	"tend": [
		"You move through the young, stopping beside each one — checking weight, looking for anything that isn't right.",
		"Two of the young are testing each other too hard. You step between them before real injury happens. They back down.",
		"You bring a piece of kill back to the nest and divide it in front of the young. They watch how you do it.",
		"The young trail behind you in a loose formation for a short circuit of the territory. Early practice for pack movement.",
		"One has separated from the group and found a hiding spot. You coax it back. Pack behavior starts now.",
		"You hold still while the young take turns watching you — your claws, your posture, how you scan the edges. They are learning.",
	],
	"already_used": [
		"You have divided the kill, set the order, and run the circuit. The lessons are in them now.",
		"The young have learned what this season's tending can give. The rest comes on the trail.",
		"More time here won't build pack discipline the young haven't already started to carry.",
		"The nest has given what it can. The young take the pack's shape with them when they go.",
	],
	"outcome_exceptional": [
		"The young move like a rising pack, alert, coordinated, and hungry in the right way.",
		"They leave with strong bodies and clear instincts, already reading movement through the brush.",
		"Your care shows in every step. The young are ready to become dangerous.",
	],
	"outcome_good": [
		"The young move out with stronger bodies, sharper calls, and a real sense of pack rhythm.",
		"They leave the nest as young hunters, still learning but no longer easy prey.",
		"Their steps are steadier now, and their claws carry purpose.",
	],
	"outcome_okay": [
		"The young move out with stronger bodies, sharper calls, and a real sense of pack rhythm.",
		"They leave the nest as young hunters, still learning but no longer easy prey.",
		"Their steps are steadier now, and their claws carry purpose.",
	],
	"outcome_neutral": [
		"The young leave with some lessons learned and many still missing.",
		"They follow the edge of the pack for a while, then begin their own uncertain trails.",
		"They are not helpless anymore, but the world will test them hard.",
	],
	"outcome_poor": [
		"The young survive to leave, but their rhythm is broken and uncertain.",
		"They step away from the pack with thin bodies and clumsy instincts.",
		"They have claws and hunger, but not enough control to make the wild easy.",
	],
	"outcome_failed": [
		"The young leave too bold and too hungry, mistaking instinct for skill. The brush swallows their cries quickly.",
		"Their claws have grown, but discipline has not. They rush into the world before they understand it.",
		"The pack watches them go, but the young are scattered, noisy, and badly prepared for life beyond the nest.",
	],
}

func get_nest_data() -> Dictionary:
	return NEST_DATA
