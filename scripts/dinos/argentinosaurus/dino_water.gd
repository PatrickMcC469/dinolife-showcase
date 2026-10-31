extends "res://scripts/dinos/base_dino_water.gd"

const WATER_DATA: Dictionary = {
	"clean": [
		"You find a clear stream and drink for a long while as the herd shifts around you.",
		"A broad rain pool holds enough water for even your growing body.",
		"You lower your long neck to clean water while the herd waits nearby.",
	],
	"muddy": [
		"You drink from a wide muddy basin pressed into the earth by giant feet.",
		"A trampled hollow holds cloudy water left by the herd's passage.",
		"Mud swirls beneath your mouth, but the basin still gives enough to help.",
	],
	"risky": [
		"You drink from a deep pool while the herd watches the bank for movement.",
		"The water tastes stale, but your massive body needs what it can get.",
		"The soft ground shifts beneath your feet, so you drink carefully and move on.",
	],
	"danger": [
		"You drink from a deep pool, but a small waterline predator bites at your leg before retreating.",
		"You follow the herd to water, but soft mud strains one of your giant steps.",
		"You lower your long neck to drink, but sharp branches scrape along your throat.",
		"You drink enough to recover, but biting insects swarm around your legs.",
		"You step near a muddy bank, and the ground pulls hard at your foot before you break free.",
		"You reach a wide river bend, but something hidden snaps at your lower leg and vanishes.",
		"You drink from a shallow floodplain pool, but the sour water leaves you uneasy.",
		"You find water with the herd, but a sudden shove nearby jars your massive body before things settle.",
	],
	"dry": [
		"The herd crosses the old water route, but the basin has gone dry.",
		"You find only cracked mud where the herd expected water.",
		"Your long search ends with dust, wilted plants, and no drinkable water.",
	],
}

func get_water_data() -> Dictionary:
	return WATER_DATA
