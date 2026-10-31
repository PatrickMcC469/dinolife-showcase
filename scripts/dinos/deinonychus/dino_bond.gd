extends "res://scripts/dinos/base_dino_bond.gd"

const BOND_DATA: Dictionary = {
	"strong": [
		"Your calls align with the others, and the pack falls back into hunting rhythm.",
		"You move together through the brush, each step answered by another hunter.",
		"You practice circling and feinting until the pack feels dangerous again.",
		"You share the trail, the scent, and the silence until trust sharpens.",
		"The pack settles around you, tense, focused, and ready to hunt as one.",
	],
	"useful": [
		"You call and wait until the others begin matching your pace.",
		"The group remains guarded, but the hunting rhythm starts to return.",
		"You move through the ferns together, rebuilding trust one step at a time.",
		"A few clean signals bring the pack closer than before.",
		"The pack still feels rough, but it no longer feels ready to split.",
	],
	"awkward": [
		"Your timing is uneven, but the group stays near enough to matter.",
		"A few warning snaps interrupt the practice, though nobody leaves.",
		"The pack circles poorly at first, then slowly finds a shared pace.",
		"Your signals come late, but some of the hunters still answer.",
		"The group feels tense, but the bond strengthens a little.",
	],
	"misread": [
		"Your call lands wrong, and the others keep their distance.",
		"The pack ignores your signal and follows separate trails.",
		"You try to set the rhythm, but no one matches it.",
		"Raised feathers and quiet stares answer your effort.",
		"The moment passes before the pack can come together.",
	],
	"friction": [
		"Your effort turns into a dominance snap, and the pack pulls apart.",
		"A packmate challenges your place, breaking the rhythm you tried to rebuild.",
		"The group bristles at your push and scatters into the brush.",
		"Your call comes too sharp, and another hunter answers with teeth.",
		"The pack stays together, but only with more tension than before.",
	],
}

func get_bond_data() -> Dictionary:
	return BOND_DATA
