extends "res://scripts/dinos/base_dino_tend.gd"

const TEND_DATA: Dictionary = {
	"success": [
		"You press into the darkest part of a root hollow and work through the wounds carefully — licking, nudging, pulling at the edges of the worst ones until the sharp sting dulls into something you can carry.\n\nThe undergrowth shifts around you the whole time. You do not stop.",
		"You tuck your sore side against a warm stone and spend a long time on the parts that still ache. Your tongue finds every scrape and cut your body can reach.\n\nNot healed. Better.",
		"You retreat deep into the leaf litter, where the world feels far enough away to breathe. The pain is still there when you finish, but it sits differently now — duller, less sharp, more like something that will pass.",
		"You clean the damage quickly, one eye always on the tree line. Every distant sound makes you pause mid-motion.\n\nIt is not restful. But the wounds are tended, and that is what matters.",
		"You find a narrow gap between roots that nothing larger than you could reach and stay there until the sting in your side fades.\n\nSmall as you are, the forest gives you hiding spots that most things cannot use. Today that is enough.",
	],
	"already_used": [
		"You find the sore places again and try to work at them, but your body is done accepting help for now.\n\nWhat is left needs time, not tending.",
		"You press your tongue against the worst of the wounds, but the ache no longer responds to care.\n\nRest is what comes next. Not this.",
		"There is nothing more you can do this season. You have already given your wounds the attention they will take.\n\nThe rest is waiting.",
		"You nudge at the sore patches out of habit, but they have already been cleaned as well as they can be.\n\nYour body will close the rest on its own.",
	],
}

func get_tend_data() -> Dictionary:
	return TEND_DATA
