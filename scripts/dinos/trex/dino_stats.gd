extends "res://scripts/dinos/base_dino_stats.gd"

const ATTACK_STYLE: String = "bite"
const SIZE: int = 8
const BASE_STATS: Dictionary = {
	"power":      { "min": 0.75, "max": 0.95 },
	"resilience": { "min": 0.65, "max": 0.85 },
	"agility":    { "min": 0.20, "max": 0.38 },
	"instinct":   { "min": 0.45, "max": 0.62 },
}
