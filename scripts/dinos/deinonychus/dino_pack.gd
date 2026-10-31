extends "res://scripts/dinos/base_dino_pack.gd"

const PACK_DATA: Dictionary = {
	"fracture": [
		"The pack's calls no longer line up. Every hunter seems to be listening for a different hunt.",
		"Tension moves through the feathers and glances around you. The pack is close to breaking.",
		"The hunting rhythm feels wrong. No one trusts the next step.",
		"Your packmates keep their distance, claws flexing whenever food or danger is near.",
		"The group still moves together, but only barely.",
	],
	"push_success": [
		"You answer the broken calls and force the pack back into a shared rhythm.",
		"A hard push, a shared trail, and steady movement bring the hunters back together.",
		"You hold your place until the others fall back into line.",
		"The pack snaps, circles, and settles, remembering how to move as one.",
		"The tension remains, but the pack does not fracture this season.",
	],
	"push_failure": [
		"You try to rally the pack, but sharp calls turn into silence.",
		"The hunters break away, each choosing its own trail.",
		"Your effort only sparks more tension, and the pack scatters.",
		"One by one, the others vanish through the brush, leaving no shared hunt behind.",
		"The pack's rhythm breaks completely, and no call brings it back.",
	],
	"release": [
		"You lower your head and let the others choose their own trails.",
		"The pack separates without a fight, each hunter disappearing into the brush.",
		"You do not challenge the fracture. The pack ends quietly.",
		"The shared hunt is over, and you let the silence settle.",
		"You watch the others leave and keep your claws for yourself.",
	],
}

func get_pack_data() -> Dictionary:
	return PACK_DATA
