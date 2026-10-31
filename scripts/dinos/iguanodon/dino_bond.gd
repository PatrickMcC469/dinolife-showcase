extends "res://scripts/dinos/base_dino_bond.gd"

const BOND_DATA: Dictionary = {
	"strong": [
		"You steady the herd's path until the group moves with shared purpose again.",
		"Familiar calls and even steps bring the herd back into rhythm.",
		"You keep pace beside the others, and the herd gathers around the trail.",
		"The group settles into steady travel, safer together than alone.",
		"Your calm presence helps the herd trust the path ahead.",
	],
	"useful": [
		"You follow the herd's pace and help nearby members fall back into line.",
		"The group remains unsettled, but the trail feels more shared.",
		"A few steady calls bring scattered bodies closer.",
		"You move near the herd's edge until the formation feels stronger.",
		"The herd still drifts, but not as badly as before.",
	],
	"awkward": [
		"The herd responds slowly, but some of the scattered members return.",
		"Your effort helps a little, though the group's rhythm stays uneven.",
		"You try to guide the trail, but only part of the herd follows.",
		"The herd bunches, spreads, then settles into a rough pattern.",
		"Your signal is not perfect, but it brings some steadiness back.",
	],
	"misread": [
		"Your call fails to reach the nervous clusters ahead.",
		"The herd keeps moving in uneven pieces despite your effort.",
		"You try to steady the trail, but the others do not follow.",
		"Your movement is ignored as the herd continues to drift.",
		"The moment passes, and the group remains divided.",
	],
	"friction": [
		"Your push crowds the herd, and several members pull away.",
		"A nervous shove ripples through the group, weakening trust.",
		"Your attempt to guide the trail causes confusion instead.",
		"The herd splits around your movement, less certain than before.",
		"Your call comes too forcefully, and the group resists it.",
	],
}

func get_bond_data() -> Dictionary:
	return BOND_DATA
