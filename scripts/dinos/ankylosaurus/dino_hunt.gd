extends "res://scripts/dinos/base_dino_hunt.gd"

const COMBAT_FLAVORS: Dictionary = {
	"win":    "It tried. Your armor held, your tail connected, and the fight was over before it understood what it was dealing with.",
	"win_inj":"The club landed — but so did something else. A strike found a gap you didn't know you had. You won. The ache will remind you it was close.",
	"lose":   "It found the gap — under the armor, between the plates — and exploited it before you could reposition. You lumber off. Damaged, not defeated.",
	"escape": "Nothing should be able to do this to you. And yet here you are — stumbling away from something that found every weak point you have.",
}

func get_combat_flavors() -> Dictionary:
	return COMBAT_FLAVORS
