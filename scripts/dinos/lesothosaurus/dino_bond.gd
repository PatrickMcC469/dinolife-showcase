extends "res://scripts/dinos/base_dino_bond.gd"

const BOND_DATA: Dictionary = {
	"strong": [
		"You move calmly through the grass, and the nervous group gathers around you.",
		"Soft calls pass through the herd until scattered feet become one path.",
		"You stay close to the others, and the group settles into shared safety.",
		"The herd bunches together, alert but calmer than before.",
		"Your steady movement helps the group remember how to trust its numbers.",
	],
	"useful": [
		"A few soft calls bring the nearest herd members closer.",
		"The group stays uneasy, but it moves together more cleanly.",
		"You graze near the others until the spacing feels safer.",
		"Nervous steps slowly become a shared path through the grass.",
		"The herd remains jumpy, but the bond feels stronger.",
	],
	"awkward": [
		"The group startles twice before settling, but nobody fully scatters.",
		"Your calm movement helps a little, though fear still runs through the herd.",
		"A few members follow your lead while others hesitate.",
		"The herd gathers unevenly, but the distance between you shrinks.",
		"Your calls are shaky, but they bring some comfort.",
	],
	"misread": [
		"You call softly, but the others keep grazing too far apart.",
		"The herd misses your signal and continues drifting.",
		"You move closer, but nervous bodies shift away.",
		"Your attempt to calm the group does not take hold.",
		"The herd stays scattered, alert, and uncertain.",
	],
	"friction": [
		"Your movement startles the group, sending several bodies springing away.",
		"A nervous burst spreads through the herd and weakens trust.",
		"You crowd too close, and the others scatter in alarm.",
		"Your call comes at the wrong moment and feeds the panic.",
		"The group bunches too tightly, then breaks apart in fear.",
	],
}

func get_bond_data() -> Dictionary:
	return BOND_DATA
