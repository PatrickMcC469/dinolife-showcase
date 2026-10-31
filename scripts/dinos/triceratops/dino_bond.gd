extends "res://scripts/dinos/base_dino_bond.gd"

const BOND_DATA: Dictionary = {
	"strong": [
		"You help tighten the herd circle until the defensive line feels whole again.",
		"Horns angle outward, bodies move closer, and the herd remembers its strength.",
		"Your steady stance draws the group into a stronger formation.",
		"The herd gathers around you, solid and ready to brace.",
		"You stand firm, and the others close ranks with renewed trust.",
	],
	"useful": [
		"A few warning snorts bring the herd closer together.",
		"The circle remains loose, but it feels safer than before.",
		"You step into position, and nearby herd members follow.",
		"The group steadies itself, horns turning toward the open ground.",
		"The herd still feels tense, but the defensive shape improves.",
	],
	"awkward": [
		"The herd tightens unevenly, but at least the gaps grow smaller.",
		"Some members respond to your stance while others hesitate.",
		"The circle reforms slowly, not perfect but better than before.",
		"Your warning snort is answered late, though the herd still shifts closer.",
		"The group feels stiff and uneasy, but the bond improves slightly.",
	],
	"misread": [
		"You try to tighten the circle, but the herd does not move with you.",
		"Your warning snort gets no clear answer.",
		"The others stay spread out, leaving the gaps unchanged.",
		"Your stance fails to pull the herd into formation.",
		"The group remains loose, uncertain, and slow to respond.",
	],
	"friction": [
		"Your push causes a shove through the herd, widening the circle instead.",
		"A tense adult lowers its horns at the wrong member, breaking trust.",
		"Your warning snort sparks alarm rather than unity.",
		"The herd crowds too tightly, then splits apart in irritation.",
		"Your attempt to lead the line causes confusion and sharper tempers.",
	],
}

func get_bond_data() -> Dictionary:
	return BOND_DATA
