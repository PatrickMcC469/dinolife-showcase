class_name BaseDinoSharpen
extends Node

# Return a dict keyed by stat ("strength", "defense", "speed", "instinct").
# Each entry needs: "button" (String), "success" (String), "failure" (String).
# Return {} to use generic fallback text.
func get_sharpen_data() -> Dictionary:
	return {}
