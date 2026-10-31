extends "res://scripts/dinos/base_dino_hunt.gd"

const COMBAT_FLAVORS: Dictionary = {
	"win":    "You lowered your head and you didn't stop. Whatever came at you is gone now — gored, scattered, or smart enough to flee. You stand.",
	"win_inj":"You won the clash, but the impact took something out of you. A horn nicked, a leg jarred, muscles screaming. You're still standing. That's the job.",
	"lose":   "It got inside your reach — past the horns, past the frill — and the damage it did there was real. You retreat. Bloodied but breathing.",
	"escape": "You've fought bigger than this and won. Not today. Today something broke and you don't have a word for the pain. You run anyway.",
}

func get_combat_flavors() -> Dictionary:
	return COMBAT_FLAVORS
