extends "res://scripts/dinos/base_dino_pack.gd"

const PACK_DATA: Dictionary = {
	"fracture": [
		"The group is restless, scattering too quickly at every sound.",
		"Warning chirps come late, uneven, and uncertain.",
		"The others graze farther apart than usual, and the safety between you feels thin.",
		"The group's movement has lost its rhythm. Fear is pulling everyone in different directions.",
		"Familiar bodies drift away through the grass, each one looking ready to bolt alone.",
	],
	"push_success": [
		"You stay close and steady, helping the group settle before panic spreads.",
		"A few soft calls bring the nervous group back together.",
		"You move with the others until their scattered steps become one path again.",
		"The group bunches closer, and the danger feels easier to read.",
		"The herd remains uneasy, but it stays together.",
	],
	"push_failure": [
		"You try to keep close, but fear scatters the group into the grass.",
		"Your calls are lost beneath sudden movement and fleeing feet.",
		"The group breaks apart before you can calm it.",
		"One nervous burst becomes many, and the herd vanishes in every direction.",
		"You are left in the grass as the others run beyond reach.",
	],
	"release": [
		"You let the group scatter and do not chase the panic.",
		"The others flee into the grass, and you choose your own cover.",
		"The herd breaks cleanly, each survivor trusting its own legs.",
		"You stop calling and let the distance grow.",
		"The familiar shapes vanish through the plants, leaving you alone.",
	],
}

func get_pack_data() -> Dictionary:
	return PACK_DATA
