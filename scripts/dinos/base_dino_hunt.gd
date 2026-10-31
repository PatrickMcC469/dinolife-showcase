class_name BaseDinoHunt
extends Node

# Return a crit event dict with "flavor", "result", "button", and "hunger_gain" keys.
# Return {} to use the generic fallback.
func get_crit_event() -> Dictionary:
	return {}

# Return an array of encounter dicts for hunt success events.
# Each dict needs: "flavor", "button_fight", "sublabel_fight",
#                  "button_leave", "sublabel_leave", and "prey" (combat stats).
# Return [] to use the generic PREY_TIERS fallback.
func get_encounters() -> Array:
	return []

# Return an array of encounter dicts for hunt mixed-result events (prey sees you first).
# Each dict needs: "flavor", "combat_start", "button_fight", "sublabel_fight",
#                  "button_leave", "sublabel_leave", and "prey" (combat stats).
# Return [] to use the generic alerted fallback.
func get_mixed_encounters() -> Array:
	return []

# Return a dict with combat result flavor strings for this species.
# Keys: "win", "win_inj", "lose", "escape"
# Return {} to use generic fallback text.
func get_combat_flavors() -> Dictionary:
	return {}

# Return an array of scavenge find dicts for this species.
# Each dict needs: "flavor" (String) and "hunger_value" (float).
# Ordered rich → decent → scraps (0.25 / 0.18 / 0.12).
# Return [] to use the generic SCAVENGE_FINDS fallback.
func get_scavenge_finds() -> Array:
	return []

# Return the miss flavor string shown when scavenge finds nothing.
# Return "" to use the generic fallback miss text.
func get_scavenge_miss() -> String:
	return ""
