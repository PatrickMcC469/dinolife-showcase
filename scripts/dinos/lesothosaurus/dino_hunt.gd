extends "res://scripts/dinos/base_dino_hunt.gd"

const COMBAT_FLAVORS: Dictionary = {
	"win":    "Small, fast, and smarter than it looked. You came out on top — not by power, but by not being where the strike landed.",
	"win_inj":"You survived the exchange, but something connected on the way out. For a creature your size, that's not nothing. Keep moving.",
	"lose":   "It was too big or too fast or both. You took a hit you couldn't avoid and disengaged before it finished the thought.",
	"escape": "That was too close. You're hurt, you're running, and every instinct you have is screaming the same thing: don't stop.",
}

func get_combat_flavors() -> Dictionary:
	return COMBAT_FLAVORS
