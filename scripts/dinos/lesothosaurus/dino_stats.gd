extends "res://scripts/dinos/base_dino_stats.gd"

const ATTACK_STYLE: String = "speed"
const SIZE: int = 1
const BASE_STATS: Dictionary = {
	"power":      { "min": 0.08, "max": 0.18 },
	"resilience": { "min": 0.15, "max": 0.28 },
	"agility":    { "min": 0.70, "max": 0.85 },
	"instinct":   { "min": 0.55, "max": 0.70 },
}
