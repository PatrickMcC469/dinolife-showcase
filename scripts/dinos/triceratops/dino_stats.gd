extends "res://scripts/dinos/base_dino_stats.gd"

const ATTACK_STYLE: String = "charge"
const SIZE: int = 7
const BASE_STATS: Dictionary = {
	"power":      { "min": 0.55, "max": 0.72 },
	"resilience": { "min": 0.60, "max": 0.78 },
	"agility":    { "min": 0.25, "max": 0.40 },
	"instinct":   { "min": 0.45, "max": 0.60 },
}
