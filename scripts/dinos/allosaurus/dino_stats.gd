extends "res://scripts/dinos/base_dino_stats.gd"

const ATTACK_STYLE: String = "bite"
const SIZE: int = 6
const BASE_STATS: Dictionary = {
	"power":      { "min": 0.60, "max": 0.80 },
	"resilience": { "min": 0.58, "max": 0.74 },
	"agility":    { "min": 0.35, "max": 0.50 },
	"instinct":   { "min": 0.45, "max": 0.60 },
}
