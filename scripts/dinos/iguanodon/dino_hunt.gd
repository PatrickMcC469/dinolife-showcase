extends "res://scripts/dinos/base_dino_hunt.gd"

const COMBAT_FLAVORS: Dictionary = {
	"win":    "You didn't pick this fight — but you finished it. One well-placed thumb spike and the threat backed off for good.",
	"win_inj":"You drove it off, but it left a mark. You're bloodied and sore, and the herd is watching. You held. That's what matters.",
	"lose":   "You couldn't shake it. The attack lands harder than you could absorb, and you pull back before the situation gets fatal.",
	"escape": "You're moving on three good legs and praying the fourth holds. You got out. You don't know how. You're not stopping to find out.",
}

func get_combat_flavors() -> Dictionary:
	return COMBAT_FLAVORS
