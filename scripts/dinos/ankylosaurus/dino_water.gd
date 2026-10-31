extends "res://scripts/dinos/base_dino_water.gd"

const WATER_DATA: Dictionary = {
	"clean": [
		"You find a slow clear stream and drink from the low bank without rushing.",
		"Rainwater rests in a shallow stone hollow, cool and easy to reach.",
		"You drink from clean water where the mud supports your heavy stance.",
	],
	"muddy": [
		"You find a muddy hollow and drink while your armor rests close to the damp ground.",
		"A low wet basin gives you cloudy water and a little relief.",
		"You drink from the safest edge of a muddy dip beneath thick cover.",
	],
	"risky": [
		"You drink from stagnant water and keep your tail ready behind you.",
		"The mud grips at your feet while you drink, making the stop feel unsafe.",
		"Something has passed through recently, but the water is still worth taking.",
	],
	"danger": [
		"You drink from a muddy hollow, but something slips between your plates and bites before vanishing.",
		"You lower yourself near water, but the mud pulls at your legs and strains your slow steps.",
		"You find a shallow pool, but sharp stones scrape beneath your armor.",
		"You drink enough to help, but biting insects gather around the softer gaps near your plates.",
		"You reach water under thick cover, but a hidden creature snaps at your snout and disappears.",
		"You settle near a wet bank, but your tail drags through thorny roots.",
		"You drink from a cool hollow, but the ground shifts and bruises your belly.",
		"You find water, but its stagnant taste leaves your body feeling heavy.",
	],
	"dry": [
		"You check the low pools and muddy hollows, but they have dried out.",
		"The ground is damp in places, but never enough to drink.",
		"Your slow search finds mud, stones, and shade, but no water.",
	],
}

func get_water_data() -> Dictionary:
	return WATER_DATA
