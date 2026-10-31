extends "res://scripts/dinos/base_dino_water.gd"

const WATER_DATA: Dictionary = {
	"clean": [
		"You find a clear stream and drink until the water trembles around your jaws.",
		"A deep rain pool waits between broken stones, large enough to be worth the stop.",
		"You lower your massive head to fresh water and drink long enough to quiet the thirst.",
	],
	"muddy": [
		"You drink from a churned hollow beside a herd trail, taking what remains.",
		"Mud clouds the pool beneath your jaws, but there is enough to use.",
		"A trampled water pocket holds a heavy, dirty drink.",
	],
	"risky": [
		"You drink from a pool rich with strange scent, ready to pull back at the first movement.",
		"The riverbank feels watched, but you take enough water before moving on.",
		"The water tastes foul, yet your body needs it badly enough to drink.",
	],
	"danger": [
		"You lower your head to drink, but something bites from the shallows and disappears before it becomes a fight.",
		"You find a deep pool, but the muddy bank gives way beneath your weight and jars your leg.",
		"You drink from a river bend, but a hidden snap from the water catches your lower jaw.",
		"You get enough water to help, but sharp stones cut into one heavy foot.",
		"You drink from a trampled water hole, but biting insects swarm around your face and wounds.",
		"You step into soft mud for water, but pulling free strains your leg.",
		"You drink deeply, but the water tastes foul and leaves your body unsettled.",
		"You find water, but the scent of another large predator pushes you away before you can drink your fill.",
	],
	"dry": [
		"Old blood, old tracks, and dry mud lead you nowhere useful.",
		"You cross the water paths, but the season has emptied them.",
		"The ground cracks beneath your feet, offering no water.",
	],
}

func get_water_data() -> Dictionary:
	return WATER_DATA
