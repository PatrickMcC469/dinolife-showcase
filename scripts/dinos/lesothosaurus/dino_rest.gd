extends "res://scripts/dinos/base_dino_rest.gd"

const REST_FLAVORS: Dictionary = {
	"first": [
		"You fold into low grass with the group nearby, letting your quick legs recover.",
		"You rest beneath soft plants, hidden by stems and quiet movement.",
		"You settle close to others of your kind, letting safety calm your body.",
		"You tuck into the grass and let your tired feet loosen.",
		"You lie low in the greenery, recovering while warning calls stay close.",
	],
	"second": [
		"You rest again beneath soft cover, ears alert for warning calls.",
		"You stay low with the group nearby, gaining what healing you still can.",
		"You settle into the grass once more, though your body mends less now.",
		"You take another quiet rest, but your legs only recover a little.",
		"You breathe softly under cover, using the last useful rest of the season.",
	],
	"exhausted": [
		"You stay hidden and still, but your body will not heal further this season.",
		"You rest in the grass, but no more recovery comes.",
		"You keep low and quiet, gaining safety but no healing.",
		"You lie near the group, but your aches remain.",
		"You wait beneath the plants, but the season gives nothing more.",
	],
}

func get_rest_flavors() -> Dictionary:
	return REST_FLAVORS
