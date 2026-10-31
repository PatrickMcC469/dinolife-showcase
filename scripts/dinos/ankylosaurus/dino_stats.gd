extends "res://scripts/dinos/base_dino_stats.gd"

const ATTACK_STYLE: String = "bulk"
const SIZE: int = 7
const BASE_STATS: Dictionary = {
	"power":      { "min": 0.20, "max": 0.38 },
	"resilience": { "min": 0.80, "max": 0.95 },
	"agility":    { "min": 0.10, "max": 0.22 },
	"instinct":   { "min": 0.35, "max": 0.50 },
}
