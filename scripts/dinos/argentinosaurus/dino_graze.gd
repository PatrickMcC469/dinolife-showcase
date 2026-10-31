extends "res://scripts/dinos/base_dino_graze.gd"

const GRAZE_DATA: Dictionary = {
	"crit_flavor": [
		"You find a rich stand of tall soft leaves, enough to feed your huge body well.",
		"The herd reaches a grove heavy with fresh growth, and you eat deeply.",
		"Broad branches hang low with good leaves, giving you an excellent meal.",
		"You feed from tall greenery while the herd's shadows stretch around you.",
		"The land offers enough food for giants, and your hunger finally eases.",
		"A grove of dense, untouched trees waits ahead, laden with reachable leaves. You eat without rush.",
		"The herd finds the best browsing of the season, and you take more than your share.",
	],
	"success_flavor": [
		"You find enough leaves to make the search worthwhile.",
		"The browsing is steady, even if not abundant.",
		"You feed from reachable branches and regain some strength.",
		"The herd path brings you to useful greenery.",
		"You strip leaves from several trees before moving on.",
	],
	"no_food_flavor": [
		"The branches are stripped too high, too dry, or too bare to help.",
		"The herd reaches poor trees with little worth eating.",
		"You search for good leaves, but the grove is spent.",
		"Every reachable branch offers dry scraps and disappointment.",
		"The land feels too empty for something your size.",
	],
	"mixed_encounters": [
		{
			"flavor": "The trees offer food, but a Dromaeosaur Pack moves too close to the herd's edge.",
			"predator": { "name": "Dromaeosaur Pack", "size": 2, "fight_power": 0.30 },
			"button_fight":    "Drive them off",
			"sublabel_fight":  "Clear the pack from the edge",
			"button_leave":    "Move the herd on",
			"sublabel_leave":  "Leave the food",
		},
		{
			"flavor": "You find good leaves, then feel the ground shift as a Rival Young Sauropod pushes into the grove.",
			"predator": { "name": "Rival Young Sauropod", "size": 5, "fight_power": 0.25 },
			"button_fight":    "Hold the grove",
			"sublabel_fight":  "Push the rival out with your size",
			"button_leave":    "Let it share",
			"sublabel_leave":  "Leave the food",
		},
		{
			"flavor": "The feeding ground is useful, but an Adult Allosaurus watches from the treeline.",
			"predator": { "name": "Adult Allosaurus", "size": 4, "fight_power": 0.55 },
			"button_fight":    "Face it",
			"sublabel_fight":  "Use your size to back it off",
			"button_leave":    "Move away from the trees",
			"sublabel_leave":  "Leave the food",
		},
		{
			"flavor": "You begin to browse, but a Crocodyliform at River stirs near the water path.",
			"predator": { "name": "Crocodyliform at River", "size": 3, "fight_power": 0.40 },
			"button_fight":    "Clear the bank",
			"sublabel_fight":  "Push it away from the crossing",
			"button_leave":    "Stay away from the river",
			"sublabel_leave":  "Leave the food",
		},
		{
			"flavor": "You find food, but a Juvenile Tyrannosaur stalks the open ground nearby.",
			"predator": { "name": "Juvenile Tyrannosaur", "size": 4, "fight_power": 0.55 },
			"button_fight":    "Drive it back",
			"sublabel_fight":  "Use your size to push it off",
			"button_leave":    "Retreat into the herd",
			"sublabel_leave":  "Leave the food",
		},
	],
	"danger_encounters": [
		{
			"flavor": "You lower your long neck to feed, and an Adult Tyrannosaur moves beneath the trees.",
			"predator": { "name": "Adult Tyrannosaur", "size": 5, "fight_power": 0.75 },
		},
		{
			"flavor": "The herd's warning rumble comes too late. A Ceratosaurus Pair is already close.",
			"predator": { "name": "Ceratosaurus Pair", "size": 4, "fight_power": 0.45 },
		},
		{
			"flavor": "You reach for leaves as panic ripples through the herd around an Adult Allosaurus.",
			"predator": { "name": "Adult Allosaurus", "size": 4, "fight_power": 0.55 },
		},
		{
			"flavor": "The feeding ground turns dangerous as a Juvenile Tyrannosaur charges from cover.",
			"predator": { "name": "Juvenile Tyrannosaur", "size": 4, "fight_power": 0.55 },
		},
		{
			"flavor": "A Crocodyliform at River lunges near the grove, forcing the season into survival.",
			"predator": { "name": "Crocodyliform at River", "size": 3, "fight_power": 0.40 },
		},
	],
}

func get_graze_data() -> Dictionary:
	return GRAZE_DATA
