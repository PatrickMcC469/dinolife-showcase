extends "res://scripts/dinos/base_dino_graze.gd"

const GRAZE_DATA: Dictionary = {
	"crit_flavor": [
		"You find a hidden patch of soft shoots beneath tall grass and feed quickly before anything notices.",
		"Fresh green growth waits in a safe pocket of cover, giving you a full, easy meal.",
		"You discover tender plants tucked between roots, close enough to cover to eat without panic.",
		"The grass opens into a perfect feeding spot — quiet, soft, and rich with new growth.",
		"You graze well in hidden cover, filling your belly without leaving safety.",
		"A thick stand of young shoots sits undisturbed beneath the tree line. You eat until the hunger eases.",
		"You find the best feeding spot of the season tucked out of sight, and nothing disturbs you.",
	],
	"success_flavor": [
		"You find enough soft plants to quiet your hunger.",
		"A small patch of fresh grass gives you a useful meal.",
		"You feed from low plants while keeping one ear turned toward danger.",
		"The grazing is not perfect, but it is enough to help.",
		"You find safe bites scattered through the grass.",
	],
	"no_food_flavor": [
		"You search the grass, but every safe patch has already been picked clean.",
		"The plants are dry, bitter, or too exposed to risk.",
		"You find tracks, dust, and chewed stems — nothing worth eating.",
		"The feeding ground is empty by the time you reach it.",
		"You move through the grass hungry, finding no safe meal.",
	],
	"mixed_encounters": [
		{
			"flavor": "You find good grass, but a Hungry Compsognathus Pair watches from the edge of the plants.",
			"predator": { "name": "Hungry Compsognathus Pair", "size": 1, "fight_power": 0.20 },
			"button_fight":    "Hold your ground",
			"sublabel_fight":  "Drive them off and eat",
			"button_leave":    "Leave the food",
			"sublabel_leave":  "Walk away hungry",
		},
		{
			"flavor": "The plants are fresh, but a Large Ground Lizard blocks the easiest escape path.",
			"predator": { "name": "Large Ground Lizard", "size": 1, "fight_power": 0.15 },
			"button_fight":    "Scatter it",
			"sublabel_fight":  "Clear the path and eat",
			"button_leave":    "Find another route",
			"sublabel_leave":  "Leave the food",
		},
		{
			"flavor": "You lower your head to feed, then spot a Young Velociraptor moving through cover nearby.",
			"predator": { "name": "Young Velociraptor", "size": 2, "fight_power": 0.35 },
			"button_fight":    "Stand your ground",
			"sublabel_fight":  "Fight it off before it closes",
			"button_leave":    "Slip away",
			"sublabel_leave":  "Leave the food",
		},
		{
			"flavor": "The grazing spot is useful, but a Small Raptor Pack is circling the open grass.",
			"predator": { "name": "Small Raptor Pack", "size": 2, "fight_power": 0.45 },
			"button_fight":    "Face them",
			"sublabel_fight":  "Drive the pack off",
			"button_leave":    "Back into cover",
			"sublabel_leave":  "Leave the food",
		},
		{
			"flavor": "You find food, but an Ambush Snake lies coiled near the safest patch.",
			"predator": { "name": "Ambush Snake", "size": 1, "fight_power": 0.30 },
			"button_fight":    "Clear it out",
			"sublabel_fight":  "Drive it off and eat",
			"button_leave":    "Leave it alone",
			"sublabel_leave":  "Leave the food",
		},
	],
	"danger_encounters": [
		{
			"flavor": "You step into the feeding patch just as a Young Velociraptor bursts from the grass.",
			"predator": { "name": "Young Velociraptor", "size": 2, "fight_power": 0.35 },
		},
		{
			"flavor": "You lower your head to graze, and a Small Raptor Pack rushes before you can react.",
			"predator": { "name": "Small Raptor Pack", "size": 2, "fight_power": 0.45 },
		},
		{
			"flavor": "The grass hides more than food. An Ambush Snake strikes from cover.",
			"predator": { "name": "Ambush Snake", "size": 1, "fight_power": 0.30 },
		},
		{
			"flavor": "You find the plants too late to notice the Juvenile Deinonychus waiting nearby.",
			"predator": { "name": "Juvenile Deinonychus", "size": 2, "fight_power": 0.50 },
		},
		{
			"flavor": "A sudden rush of movement turns grazing into survival as an Opportunistic Pterosaur dives toward you.",
			"predator": { "name": "Opportunistic Pterosaur", "size": 2, "fight_power": 0.30 },
		},
	],
}

func get_graze_data() -> Dictionary:
	return GRAZE_DATA
