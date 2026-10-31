class_name BaseDinoTerritory
extends Node

# Return a dict keyed by claim result ("strong", "useful", "contested", "weak").
# Each value is an Array of flavor strings — one is picked randomly.
# Return {} to use generic fallback text.
func get_territory_data() -> Dictionary:
	return {}
