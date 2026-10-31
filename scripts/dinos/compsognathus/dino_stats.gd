extends "res://scripts/dinos/base_dino_stats.gd"

const ATTACK_STYLE: String = "speed"
const SIZE: int = 1
const BASE_STATS: Dictionary = {
	"power":      { "min": 0.10, "max": 0.25 },
	"resilience": { "min": 0.10, "max": 0.22 },
	"agility":    { "min": 0.65, "max": 0.82 },
	"instinct":   { "min": 0.55, "max": 0.72 },
}
