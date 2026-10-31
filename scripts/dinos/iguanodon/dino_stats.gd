extends "res://scripts/dinos/base_dino_stats.gd"

const ATTACK_STYLE: String = "charge"
const SIZE: int = 5
const BASE_STATS: Dictionary = {
	"power":      { "min": 0.35, "max": 0.52 },
	"resilience": { "min": 0.45, "max": 0.62 },
	"agility":    { "min": 0.40, "max": 0.55 },
	"instinct":   { "min": 0.50, "max": 0.65 },
}
