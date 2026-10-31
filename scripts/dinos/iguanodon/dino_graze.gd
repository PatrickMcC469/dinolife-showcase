extends "res://scripts/dinos/base_dino_graze.gd"

const GRAZE_DATA: Dictionary = {
	"crit_flavor": [
		"You find a rich stand of broad leaves along the herd path and feed deeply.",
		"Fresh plants crowd the shaded trail, giving you a strong, steady meal.",
		"You discover a safe feeding ground full of soft leaves and sturdy growth.",
		"The herd path leads you to excellent grazing — calm and plentiful.",
		"You feed well from broad plants, filling your hunger without trouble.",
		"A long stretch of untouched greenery waits along the trail. You eat until the hunger fades.",
		"The best growth of the season lines a quiet stretch of path, and nothing disturbs the meal.",
	],
	"success_flavor": [
		"You find enough leaves and shoots to make the search worthwhile.",
		"The plants here are decent, and you feed at a steady pace.",
		"You browse from safe greenery while staying near familiar paths.",
		"The meal is simple but useful.",
		"You find scattered leaves that help refill your strength.",
	],
	"no_food_flavor": [
		"The herd path leads only to stripped stems and dry leaves.",
		"You search the greenery, but the best plants are already gone.",
		"Every promising patch is either empty or too exposed.",
		"You find leaves too bitter or tough to help.",
		"The trail offers no useful food this season.",
	],
	"mixed_encounters": [
		{
			"flavor": "The feeding is good, but a Lone Deinonychus watches from the ferns.",
			"predator": { "name": "Lone Deinonychus", "size": 2, "fight_power": 0.35 },
			"button_fight":    "Drive it off",
			"sublabel_fight":  "Clear the ferns and eat",
			"button_leave":    "Leave the trail",
			"sublabel_leave":  "Walk away hungry",
		},
		{
			"flavor": "You find broad leaves, then hear an Aggressive Rival Iguanodon moving nearby.",
			"predator": { "name": "Aggressive Rival Iguanodon", "size": 3, "fight_power": 0.45 },
			"button_fight":    "Assert yourself",
			"sublabel_fight":  "Push the rival off",
			"button_leave":    "Yield the patch",
			"sublabel_leave":  "Leave the food",
		},
		{
			"flavor": "The plants are worth eating, but a Juvenile Allosaurus has noticed the same trail.",
			"predator": { "name": "Juvenile Allosaurus", "size": 3, "fight_power": 0.45 },
			"button_fight":    "Stand your ground",
			"sublabel_fight":  "Drive it away from the trail",
			"button_leave":    "Abandon the path",
			"sublabel_leave":  "Leave the food",
		},
		{
			"flavor": "You start feeding near the path, but a Deinonychus Pair waits at the edge of cover.",
			"predator": { "name": "Deinonychus Pair", "size": 2, "fight_power": 0.50 },
			"button_fight":    "Hold the position",
			"sublabel_fight":  "Fight them off",
			"button_leave":    "Move away",
			"sublabel_leave":  "Leave the food",
		},
		{
			"flavor": "You find food, but a Large Crocodyliform rests too close to the waterline.",
			"predator": { "name": "Large Crocodyliform", "size": 3, "fight_power": 0.55 },
			"button_fight":    "Push it back",
			"sublabel_fight":  "Clear the waterline",
			"button_leave":    "Stay away from the water",
			"sublabel_leave":  "Leave the food",
		},
	],
	"danger_encounters": [
		{
			"flavor": "You push through broad leaves and stumble straight into a Deinonychus Pair.",
			"predator": { "name": "Deinonychus Pair", "size": 2, "fight_power": 0.50 },
		},
		{
			"flavor": "The feeding patch hides an Adult Allosaurus until it is already moving.",
			"predator": { "name": "Adult Allosaurus", "size": 4, "fight_power": 0.65 },
		},
		{
			"flavor": "You lower your head to browse, and a Ceratosaurus Challenger rushes from the trees.",
			"predator": { "name": "Ceratosaurus Challenger", "size": 4, "fight_power": 0.60 },
		},
		{
			"flavor": "The herd path suddenly breaks into panic as a Large Crocodyliform attacks from the mud.",
			"predator": { "name": "Large Crocodyliform", "size": 3, "fight_power": 0.55 },
		},
		{
			"flavor": "The plants are fresh, but a Juvenile Allosaurus reaches you first.",
			"predator": { "name": "Juvenile Allosaurus", "size": 3, "fight_power": 0.45 },
		},
	],
}

func get_graze_data() -> Dictionary:
	return GRAZE_DATA
