extends "res://scripts/dinos/base_dino_stats.gd"

const ATTACK_STYLE: String = "bulk"
const SIZE: int = 9
const BASE_STATS: Dictionary = {
	"power":      { "min": 0.30, "max": 0.50 },
	"resilience": { "min": 0.75, "max": 0.92 },
	"agility":    { "min": 0.08, "max": 0.18 },
	"instinct":   { "min": 0.40, "max": 0.55 },
}
