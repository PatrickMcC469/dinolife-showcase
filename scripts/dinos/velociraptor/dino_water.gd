extends "res://scripts/dinos/base_dino_water.gd"

const WATER_DATA: Dictionary = {
	"clean": [
		"You find a clear little pool between warm stones and drink from the shaded edge.",
		"A narrow stream slips beneath dry brush, hidden enough for a safe drink.",
		"Fresh water gathers in a stone hollow, untouched by dust for now.",
	],
	"muddy": [
		"You find thin muddy water beneath thornbrush and drink carefully.",
		"A damp hollow under dry roots holds just enough to matter.",
		"Mud and dust cloud the water, but it still takes the edge off your thirst.",
	],
	"risky": [
		"You drink from exposed water while the wind carries too many scents to trust.",
		"The pool is usable, but fresh tracks nearby make every sip tense.",
		"You find water in a shaded crack, though the strange taste tells you not to linger.",
	],
	"danger": [
		"You find a shallow water pocket in the dust, but a sting from the mud sends pain through your foot.",
		"You drink from a stone basin, but a hidden scorpion snaps at your toes before vanishing.",
		"You reach damp ground under thornbrush, but the branches scrape your side as you pull away.",
		"You sip from a narrow puddle, but a snake strikes nearby and grazes your leg before sliding off.",
		"You find water in a shaded crack, but sharp stones cut your feet while you drink.",
		"You drink quickly from a muddy hollow, but biting flies force you back into the brush.",
		"You follow damp tracks to water, but the ground collapses slightly and twists your ankle.",
		"You get enough water to help, but a bad taste leaves you uneasy and slower to settle.",
	],
	"dry": [
		"The dust holds no damp trail, and every promising hollow is dry.",
		"You follow old water marks through the brush, but find nothing.",
		"The land gives you tracks, stones, and silence, but no water.",
	],
}

func get_water_data() -> Dictionary:
	return WATER_DATA
