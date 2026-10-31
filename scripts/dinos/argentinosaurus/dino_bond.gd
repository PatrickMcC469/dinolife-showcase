extends "res://scripts/dinos/base_dino_bond.gd"

const BOND_DATA: Dictionary = {
	"strong": [
		"You follow the deep calls until the herd's rhythm returns beneath every step.",
		"The giants gather closer, and their shadows overlap across the trail.",
		"Slow steps, low rumbles, and shared direction bring the herd together.",
		"You move with the herd's ancient pace, and the group steadies around you.",
		"The herd becomes one moving wall again, calm, massive, and connected.",
	],
	"useful": [
		"You answer the low rumbles and help the herd stay on a shared path.",
		"The giants remain spread out, but their movement feels more connected.",
		"You keep pace with the nearest bodies, strengthening the herd's rhythm.",
		"The herd's calls come clearer as the group settles.",
		"The trail feels less lonely as the great bodies draw closer.",
	],
	"awkward": [
		"Your steps do not match at first, but the herd slowly adjusts.",
		"A few giants drift closer, though the rhythm remains uneven.",
		"Your rumble is answered late, but at least it is answered.",
		"The herd shifts awkwardly, then settles into a rough shared pace.",
		"The bond strengthens slightly, carried by slow steps and patient movement.",
	],
	"misread": [
		"Your call sinks into the open air without a strong answer.",
		"The herd keeps drifting, too spread out to feel connected.",
		"You try to follow the rhythm, but the rhythm is not there.",
		"The nearest giants continue on separate paths.",
		"Your effort fades beneath too many distant footsteps.",
	],
	"friction": [
		"Your movement crowds a smaller herd member, causing the group to spread wider.",
		"A low warning rumble passes through the herd instead of comfort.",
		"The giants shift uneasily, and the shared rhythm weakens.",
		"Your attempt to close the distance makes the herd more restless.",
		"Heavy bodies move apart, leaving the trail feeling less connected than before.",
	],
}

func get_bond_data() -> Dictionary:
	return BOND_DATA
