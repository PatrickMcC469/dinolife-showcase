class_name BaseDinoRest
extends Node

# Return a dict with rest flavor pools for this species.
# Keys: "first" (use 1), "second" (use 2), "exhausted" (use 3+)
# Each value is an Array of strings — one is picked randomly each use.
# Return {} to use generic fallback text.
func get_rest_flavors() -> Dictionary:
	return {}
