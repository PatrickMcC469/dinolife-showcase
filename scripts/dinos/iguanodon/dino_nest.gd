extends "res://scripts/dinos/base_dino_nest.gd"

# Iguanodon — nesting phase flavor text

const NEST_DATA: Dictionary = {
	"tend": [
		"You move along the feed line slowly and the young follow. Teaching them to walk and eat at the same time.",
		"A young one is drifting toward the edge of the group. You use your body to redirect it back toward the center.",
		"You call softly and listen for answers from the young. When one doesn't call back, you find it and bring it close again.",
		"You feed alongside the young from the same patch, at the same pace. Showing them what safe plants look like.",
		"Two of the young have moved too far in opposite directions. You place yourself between them and wait until they drift back.",
		"You stand guard while the young feed, scanning the brush with steady attention. They eat better when they feel the watch.",
	],
	"already_used": [
		"The young have fed beside you and learned the watch. More attention here is more than this season can use.",
		"They know the calls, the safe patches, and the pace. The season's tending is done.",
		"You have done your passes and kept your watch. What the young carry now is all this season can give.",
		"More time on the trail together won't change what the young already hold.",
	],
	"outcome_exceptional": [
		"The young leave strong, calm, and well-taught, ready to follow or form safe trails of their own.",
		"They carry the herd's rhythm in their movement and the season's care in their strength.",
		"They are ready for the world, sturdy, aware, and hard to startle.",
	],
	"outcome_good": [
		"The young move on with stronger bodies and a clearer sense of the herd's rhythm.",
		"They know safe plants, warning calls, and the comfort of shared movement.",
		"Their steps are steady as they leave the old path behind.",
	],
	"outcome_okay": [
		"The young move on with stronger bodies and a clearer sense of the herd's rhythm.",
		"They know safe plants, warning calls, and the comfort of shared movement.",
		"Their steps are steady as they leave the old path behind.",
	],
	"outcome_neutral": [
		"The young Iguanodon leave with enough strength to follow a path of their own.",
		"They understand some calls, miss others, and step forward into an uncertain future.",
		"They are sturdy enough to try, though not yet steady enough to trust fully.",
	],
	"outcome_poor": [
		"The young survive to leave, but they are slow to react and uneven in strength.",
		"They follow the trail with weak confidence and tired bodies.",
		"The herd's lessons did not fully settle, leaving them vulnerable.",
	],
	"outcome_failed": [
		"The young leave the herd path weak and confused, struggling to keep pace with safety.",
		"They drift too easily, missing signals they should have learned by now.",
		"Their first steps into independence feel uncertain, with hunger and fear pulling them apart.",
	],
}

func get_nest_data() -> Dictionary:
	return NEST_DATA
