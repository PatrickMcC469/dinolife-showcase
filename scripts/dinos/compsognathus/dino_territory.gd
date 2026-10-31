extends "res://scripts/dinos/base_dino_territory.gd"

const TERRITORY_DATA: Dictionary = {
	"strong": [
		"Your tiny scratches and scent marks claim every root tunnel and leaf-shadow worth using.",
		"You mark the narrow paths so well that even other compies hesitate before crossing them.",
		"The undergrowth feels mapped by your feet, your scent, and your sharp little warnings.",
		"You leave quick signs across stones and roots, turning the small places into your hunting ground.",
		"Your marks settle into the leaf litter, warning rivals that this hidden path is taken.",
		"Every low tunnel and fern gap carries your scent by the time you finish.",
		"You claim the spaces too small for giants to understand.",
		"Your tiny territory feels secure, full of shortcuts, hiding spots, and familiar smells.",
		"You mark the best scrap routes and vanish before anything larger notices.",
		"The small world beneath the ferns feels like yours.",
	],
	"useful": [
		"You mark a few safe paths through the roots and leaves.",
		"Your scent settles lightly across the undergrowth.",
		"The area feels a little more familiar after your quick patrol.",
		"You leave enough signs to remember where the good hiding spots are.",
		"A few scratch marks help define your favorite routes.",
		"You claim the nearby leaf litter well enough for now.",
		"Your marks are small, but they may help you read the area next season.",
		"You mark a root tunnel and a fallen branch before slipping back into cover.",
		"The territory does not feel owned, but it does feel known.",
		"You leave just enough scent to make this patch easier to navigate.",
	],
	"contested": [
		"Another compi's scent cuts across your best root path.",
		"Fresh scratches on a stone tell you something else uses this route.",
		"You find tiny tracks crossing the area you tried to claim.",
		"A sharp chirp from the ferns warns that another scavenger is nearby.",
		"Your marks are interrupted by stronger scent from another small predator.",
		"The undergrowth is not empty, and something is already using your hiding spots.",
		"You smell rival compies near the same scrap trail.",
		"A small creature darts away before you can finish marking.",
		"Something has been sleeping under the same fallen log you wanted.",
		"Your claim holds, but you are not the only hungry thing here.",
	],
	"weak": [
		"Wind scatters your scent before it settles.",
		"Your scratches are too shallow to matter.",
		"You mark the area, but the undergrowth already smells too busy.",
		"Your tiny signs vanish beneath shifting leaves.",
		"The route feels no more yours than before.",
		"You leave marks, but nothing about the area changes.",
		"A passing breeze steals most of your scent.",
		"Your claim fades into the mud and leaf litter.",
		"The ferns swallow your signs almost immediately.",
		"You finish marking, but the territory feels just as uncertain.",
	],
}

func get_territory_data() -> Dictionary:
	return TERRITORY_DATA
