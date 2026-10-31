extends "res://scripts/dinos/base_dino_bond.gd"

const BOND_DATA: Dictionary = {
	"strong": [
		"You share scraps and warning chirps until the tiny group moves like one quick shadow.",
		"You guide the others through root tunnels, and the pack gathers close behind you.",
		"You trade sharp little calls in the ferns until the scattered group settles.",
		"You lead the pack toward safe hiding paths, and the others follow your movements again.",
		"You share a lucky food find, and the pack's nervous energy turns into trust.",
	],
	"useful": [
		"A few answered chirps bring the nearby compies closer.",
		"You stay near the others long enough for the group to feel steadier.",
		"You share space beneath the ferns, and the pack feels a little less scattered.",
		"You move with the group through familiar roots, rebuilding some trust.",
		"The pack remains nervous, but the calls between you sound clearer.",
	],
	"awkward": [
		"Your chirps are answered unevenly, but a few compies stay close.",
		"The group bumps, snaps, and settles into uneasy closeness.",
		"You try to share scraps, though not every compi seems impressed.",
		"The pack follows for a while, then drifts, but not as far as before.",
		"Your effort is messy, but the group feels slightly less broken.",
	],
	"misread": [
		"You call to the others, but they keep their distance in the leaves.",
		"Your attempt to gather the pack fades into unanswered chirps.",
		"You offer scraps, but the group is too nervous to come closer.",
		"The pack watches you from cover without moving in.",
		"Your signals miss the moment, and the group stays scattered.",
	],
	"friction": [
		"Your push for closeness sparks sharp squeaks and snapping teeth.",
		"Two compies fight over a scrap, and the group feels more tense than before.",
		"Your calls come too strong, and the others scatter from the noise.",
		"The pack crowds too tightly, then breaks apart in irritation.",
		"A nervous bite ruins the moment, leaving the group less trusting.",
	],
}

func get_bond_data() -> Dictionary:
	return BOND_DATA
