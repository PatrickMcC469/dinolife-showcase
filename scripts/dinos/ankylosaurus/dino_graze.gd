extends "res://scripts/dinos/base_dino_graze.gd"

const GRAZE_DATA: Dictionary = {
	"crit_flavor": [
		"You find a quiet patch of sturdy plants beneath cover and feed without being rushed.",
		"Tough, useful greenery grows thick near the stones, giving you an excellent meal.",
		"You settle into a rich low feeding spot and eat steadily.",
		"The plants are dense, reachable, and safe enough for your slow pace.",
		"You find a strong patch of ground growth and feed until your hunger eases.",
		"A wide stretch of untouched low plants sits well away from open ground. You eat your fill.",
		"The season's best grazing waits in cover, close to stone and shadow. Nothing bothers you.",
	],
	"success_flavor": [
		"You find enough tough plants to make the search worthwhile.",
		"The grazing is slow, but it helps.",
		"You crop sturdy leaves from low cover and regain some strength.",
		"The patch is not rich, but your body can use it.",
		"You feed carefully from plants growing close to the ground.",
	],
	"no_food_flavor": [
		"You search the low plants, but the useful growth has already been stripped away.",
		"The ground offers only dry stems and stone.",
		"You find tough plants too poor to matter.",
		"The feeding patch is empty beneath the cover.",
		"You move slowly through poor ground and find nothing worth eating.",
	],
	"mixed_encounters": [
		{
			"flavor": "You find good plants, but a Juvenile Allosaurus has left fresh tracks nearby.",
			"predator": { "name": "Juvenile Allosaurus", "size": 3, "fight_power": 0.40 },
			"button_fight":    "Stand your ground",
			"sublabel_fight":  "Let the armor do its work",
			"button_leave":    "Move to different cover",
			"sublabel_leave":  "Leave the food",
		},
		{
			"flavor": "The food is useful, but a Rival Ankylosaurus is feeding from the same patch.",
			"predator": { "name": "Rival Ankylosaurus", "size": 4, "fight_power": 0.40 },
			"button_fight":    "Push it out",
			"sublabel_fight":  "Fight for the patch",
			"button_leave":    "Let it have the patch",
			"sublabel_leave":  "Leave the food",
		},
		{
			"flavor": "You settle to graze, then hear a Lone Deinonychus moving beyond the brush.",
			"predator": { "name": "Lone Deinonychus", "size": 2, "fight_power": 0.35 },
			"button_fight":    "Face it",
			"sublabel_fight":  "Drive it off with your club",
			"button_leave":    "Back into deeper cover",
			"sublabel_leave":  "Leave the food",
		},
		{
			"flavor": "The patch is worth eating, but a Crocodyliform Near Mud rests close to the water.",
			"predator": { "name": "Crocodyliform Near Mud", "size": 3, "fight_power": 0.45 },
			"button_fight":    "Clear the mud",
			"sublabel_fight":  "Push it away from the bank",
			"button_leave":    "Stay away from the water",
			"sublabel_leave":  "Leave the food",
		},
		{
			"flavor": "You find food, but a Ceratosaurus Challenger is circling the feeding ground.",
			"predator": { "name": "Ceratosaurus Challenger", "size": 4, "fight_power": 0.55 },
			"button_fight":    "Hold position",
			"sublabel_fight":  "Make it back off",
			"button_leave":    "Withdraw from the ground",
			"sublabel_leave":  "Leave the food",
		},
	],
	"danger_encounters": [
		{
			"flavor": "You lower yourself to graze, and an Adult Allosaurus rushes from cover.",
			"predator": { "name": "Adult Allosaurus", "size": 4, "fight_power": 0.65 },
		},
		{
			"flavor": "The plants hide a Juvenile Tyrannosaur until it is already too close.",
			"predator": { "name": "Juvenile Tyrannosaur", "size": 3, "fight_power": 0.50 },
		},
		{
			"flavor": "You start feeding, but a Rival Ankylosaurus crashes into the patch.",
			"predator": { "name": "Rival Ankylosaurus", "size": 4, "fight_power": 0.40 },
		},
		{
			"flavor": "A sudden attack turns the feeding ground into a defensive stand against a Ceratosaurus Challenger.",
			"predator": { "name": "Ceratosaurus Challenger", "size": 4, "fight_power": 0.55 },
		},
		{
			"flavor": "You find the food, but a Crocodyliform Near Mud finds you with it.",
			"predator": { "name": "Crocodyliform Near Mud", "size": 3, "fight_power": 0.45 },
		},
	],
}

func get_graze_data() -> Dictionary:
	return GRAZE_DATA
