extends "res://scripts/dinos/base_dino_stats.gd"

const ATTACK_STYLE: String = "pack"
const SIZE: int = 3
const BASE_STATS: Dictionary = {
	"power":      { "min": 0.35, "max": 0.55 },
	"resilience": { "min": 0.30, "max": 0.50 },
	"agility":    { "min": 0.55, "max": 0.70 },
	"instinct":   { "min": 0.55, "max": 0.70 },
}
