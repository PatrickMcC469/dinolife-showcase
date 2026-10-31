extends "res://scripts/dinos/base_dino_rest.gd"

const REST_FLAVORS: Dictionary = {
	"first": [
		"You find a gap in the roots just wide enough to squeeze into and stay there until your breathing slows.\n\nThe forest keeps moving around you. You keep still. Slowly, the ache settles.",
		"You tuck into the shadow beneath a broad leaf cluster, somewhere no larger foot would think to look.\n\nYour side rises and falls. The worst of the fatigue drains away with it.",
		"You press into warm leaf litter, nose tucked under your tail, and let the quiet do what rest is supposed to do.\n\nBy the time you stir, you feel it — something restored.",
		"You crawl beneath a hollow log and fold yourself small. The dark holds the sound out.\n\nYour body uses the stillness well.",
		"You rest in a shallow scrape beneath tangled fern roots, invisible to anything passing overhead.\n\nBeing small has its uses. You sleep lightly, recover quietly, and wake sharper than you went in.",
	],
	"second": [
		"You return to the same cover and settle back in. Your body is slower to respond this time — the easy recovery already spent.\n\nIt helps some. Less than before, but not nothing.",
		"You press into the leaves again, but the deep tiredness has already been addressed. What remains is the kind that only time can touch.\n\nYou rest anyway. The season is not over.",
		"You find the same hollow and stay longer, trying to pull more from the rest than your body has left to give.\n\nA little comes. The ache is still there, but it is quieter now.",
		"You tuck back into cover, listening to every sound in the undergrowth while your body does what it can with the time you are giving it.\n\nThe recovery is smaller than the first rest. It still counts.",
		"You curl up a second time, though your body has already taken most of what sleep can offer this season.\n\nThe remaining ache stays — dulled, not gone.",
	],
	"exhausted": [
		"You find cover and stay in it, but your body has already taken everything the season will allow.\n\nThe stillness is good. The healing is done for now.",
		"You curl beneath the leaves more from habit than hope. Nothing changes.\n\nYour body has reached its limit for this season. Rest has become waiting.",
		"You press into the roots, still and quiet. No recovery comes.\n\nSomething will have to hurt a little longer.",
		"You stay hidden and breathe slowly, but the aches no longer respond to care.\n\nThe season has given you what it will give. The rest is time.",
	],
}

func get_rest_flavors() -> Dictionary:
	return REST_FLAVORS
