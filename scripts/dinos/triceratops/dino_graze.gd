extends "res://scripts/dinos/base_dino_graze.gd"

const GRAZE_DATA: Dictionary = {
	"crit_flavor": [
		"You find a dense patch of rich low plants, enough to feed well within the herd's reach.",
		"Fresh growth spreads across the ground, safe enough for a long, steady meal.",
		"The herd uncovers a strong grazing spot, and you take your fill.",
		"You feed from a thick bed of plants while the herd stands nearby.",
		"The ground is full of good forage, and your hunger fades with every bite.",
		"A low, wide stretch of undisturbed plants waits at the center of the herd's range. You eat well.",
		"The best forage of the season sits quiet and uncontested. You feed until the hunger is gone.",
	],
	"success_flavor": [
		"You find enough low growth to feed steadily.",
		"The grazing is decent, and the herd's presence keeps the moment calm.",
		"You crop useful plants from the ground and regain some strength.",
		"The patch is not rich, but it is enough.",
		"You feed on scattered growth while keeping your horns angled outward.",
	],
	"no_food_flavor": [
		"The ground has been stripped down to tough stems and dust.",
		"You find only dry plants that are not worth the effort.",
		"The herd moves across poor grazing with little to eat.",
		"Every low patch has already been chewed down.",
		"You search the feeding ground, but nothing useful remains.",
	],
	"mixed_encounters": [
		{
			"flavor": "The grazing patch is good, but a Dromaeosaur Pack tests the edge of the herd.",
			"predator": { "name": "Dromaeosaur Pack", "size": 2, "fight_power": 0.30 },
			"button_fight":    "Drive them back",
			"sublabel_fight":  "Push the pack off the edge",
			"button_leave":    "Move to a different patch",
			"sublabel_leave":  "Leave the food",
		},
		{
			"flavor": "You find food, but a Juvenile Tyrannosaur watches from broken cover.",
			"predator": { "name": "Juvenile Tyrannosaur", "size": 3, "fight_power": 0.45 },
			"button_fight":    "Face it head-on",
			"sublabel_fight":  "Make it back off with your horns",
			"button_leave":    "Keep the herd between you",
			"sublabel_leave":  "Leave the food",
		},
		{
			"flavor": "You lower your head to feed, then hear warning snorts around a Rival Triceratops Bull.",
			"predator": { "name": "Rival Triceratops Bull", "size": 4, "fight_power": 0.55 },
			"button_fight":    "Lock horns",
			"sublabel_fight":  "Claim the patch",
			"button_leave":    "Yield the patch",
			"sublabel_leave":  "Leave the food",
		},
		{
			"flavor": "The plants are useful, but a Crocodyliform Near Water lies too close to the bank.",
			"predator": { "name": "Crocodyliform Near Water", "size": 3, "fight_power": 0.50 },
			"button_fight":    "Push it back",
			"sublabel_fight":  "Clear the bank",
			"button_leave":    "Move away from the water",
			"sublabel_leave":  "Leave the food",
		},
		{
			"flavor": "You find good forage, but a Torosaurus Challenger refuses to move from the patch.",
			"predator": { "name": "Torosaurus Challenger", "size": 4, "fight_power": 0.45 },
			"button_fight":    "Challenge for the patch",
			"sublabel_fight":  "Force the rival out",
			"button_leave":    "Let it have this one",
			"sublabel_leave":  "Leave the food",
		},
	],
	"danger_encounters": [
		{
			"flavor": "You step into the grazing patch as an Adult Tyrannosaur charges from the edge of cover.",
			"predator": { "name": "Adult Tyrannosaur", "size": 5, "fight_power": 0.75 },
		},
		{
			"flavor": "The herd's warning comes too late. A Juvenile Tyrannosaur is already moving.",
			"predator": { "name": "Juvenile Tyrannosaur", "size": 3, "fight_power": 0.45 },
		},
		{
			"flavor": "You lower your head to feed, and a Rival Triceratops Bull slams toward you.",
			"predator": { "name": "Rival Triceratops Bull", "size": 4, "fight_power": 0.55 },
		},
		{
			"flavor": "A Dromaeosaur Pack breaks toward the herd before you can finish your first bites.",
			"predator": { "name": "Dromaeosaur Pack", "size": 2, "fight_power": 0.30 },
		},
		{
			"flavor": "The meal disappears beneath the sudden need to brace against a Crocodyliform Near Water.",
			"predator": { "name": "Crocodyliform Near Water", "size": 3, "fight_power": 0.50 },
		},
	],
}

func get_graze_data() -> Dictionary:
	return GRAZE_DATA
