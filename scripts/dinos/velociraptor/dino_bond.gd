extends "res://scripts/dinos/base_dino_bond.gd"

const BOND_DATA: Dictionary = {
	"strong": [
		"You rebuild the quiet pattern, and the pack moves through dust like one thought.",
		"Small signals pass cleanly between you until the group feels sharp again.",
		"You share paths through thornbrush, and the others begin trusting your angles.",
		"The pack falls into silent motion, each raptor reading the next.",
		"You guide the group through cover, and the old rhythm returns.",
	],
	"useful": [
		"You trade subtle calls until the pack feels a little more settled.",
		"The group moves closer through the brush, careful but connected.",
		"You slow your pace, and the others begin matching your path.",
		"Shared cover and quiet signals bring some trust back.",
		"The pack still watches itself, but it moves together for now.",
	],
	"awkward": [
		"Your signal is understood late, but the group still follows.",
		"The pack's movement is messy, though a little closeness returns.",
		"You choose a shared path, but not everyone trusts it at first.",
		"A few raptors drift away, then circle back into the pattern.",
		"The group stays cautious, but the bond improves slightly.",
	],
	"misread": [
		"You give a quiet signal, but the others miss it completely.",
		"The wind carries your scent wrong, and the group keeps its distance.",
		"Your careful movement fails to pull the others into line.",
		"The pack watches the brush instead of watching you.",
		"Your attempt fades into silence and separate tracks.",
	],
	"friction": [
		"Your signal is mistaken for a challenge, and the pack bristles.",
		"A raptor cuts across your path too sharply, breaking the group's trust.",
		"Your push through the brush crowds the others and sparks snapping.",
		"The pack scatters when your movement feels too sudden.",
		"Quiet tension spreads through the group, making the bond weaker.",
	],
}

func get_bond_data() -> Dictionary:
	return BOND_DATA
