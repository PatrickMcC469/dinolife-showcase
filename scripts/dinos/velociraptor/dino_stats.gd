extends "res://scripts/dinos/base_dino_stats.gd"

const ATTACK_STYLE: String = "speed"
const SIZE: int = 2
const BASE_STATS: Dictionary = {
	"power":      { "min": 0.25, "max": 0.45 },
	"resilience": { "min": 0.20, "max": 0.38 },
	"agility":    { "min": 0.65, "max": 0.80 },
	"instinct":   { "min": 0.60, "max": 0.75 },
}
