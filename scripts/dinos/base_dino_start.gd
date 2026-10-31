class_name BaseDinoStart
extends Node

# Small permanent boost applied by a hatchling choice.
# Intentionally tiny — sets tone, not power level.
const BOOST_AMOUNT: float = 0.04


# Override in each dino's file to return their event list.
func get_events() -> Array:
	return []


# Returns only events eligible for the current moment.
# shell_only events are locked to seasons_elapsed == 0.
func get_eligible_events() -> Array:
	var first_season: bool = GameState.seasons_elapsed == 0
	return get_events().filter(func(e: Dictionary) -> bool:
		return first_season or not e.get("shell_only", false)
	)


# Applies the chosen stat boost, clamped to 1.0.
func apply_boost(stat: String) -> void:
	var current: float = GameState.get(stat) as float
	GameState.set(stat, minf(current + BOOST_AMOUNT, 1.0))
