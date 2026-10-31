extends "res://scripts/dinos/base_dino_hunt.gd"

const COMBAT_FLAVORS: Dictionary = {
	"win":    "It tested you. Once. You shifted your weight and the problem stopped being a problem. The earth remembers the sound.",
	"win_inj":"Even something your size can get hurt by enough of the right kind of persistence. You ended it — but they left a mark first.",
	"lose":   "You are not invincible. You know this now. Something coordinated, something patient, found the angle and made you feel it.",
	"escape": "You don't flee. You have never fled. But you are moving — fast, desperate, and hurt in ways you don't have a name for yet.",
}

func get_combat_flavors() -> Dictionary:
	return COMBAT_FLAVORS
