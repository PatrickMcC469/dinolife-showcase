extends "res://scripts/dinos/base_dino_find_pack.gd"

const FIND_PACK_DATA: Dictionary = {
	"strong": [
		"You find a quick-footed group grazing near low cover, their warning calls clear and steady.",
		"A healthy group moves through the grass together, alert but calm.",
		"You find Lesothosaurus gathered in safe spacing, close enough to warn each other and far enough to move.",
		"The group shifts to make room as you approach, their movements steady and practiced.",
		"You find a herd that knows when to graze, when to freeze, and when to run.",
	],
	"small": [
		"You find a few Lesothosaurus moving nervously through the grass.",
		"A small group grazes near a patch of cover, thin but watchful.",
		"You find two or three others keeping close enough to share warning calls.",
		"The group is small, but their eyes and ears make the open ground feel safer.",
		"You find a modest herd moving carefully between low plants.",
	],
	"unstable": [
		"You find a scattered group that startles at every sound.",
		"The herd lets you stay close, but panic sits just beneath the surface.",
		"You find Lesothosaurus spread too far apart, each one ready to bolt alone.",
		"The warning calls are late, uneven, and nervous.",
		"The group exists, but fear keeps pulling it in different directions.",
	],
	"no_group": [
		"You search the grass for familiar movement, but every soft call fades into empty wind.",
		"The low plants rustle, but none of the shapes are your kind.",
		"You find old tracks in the dirt, but the herd has already moved on.",
		"The open ground feels too quiet, with no group nearby to share the danger.",
		"You follow faint calls until they vanish beneath the wind.",
	],
}

func get_find_pack_data() -> Dictionary:
	return FIND_PACK_DATA
