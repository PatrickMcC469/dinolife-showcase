class_name BaseDinoGraze
extends Node

# ── GRAZE DATA INTERFACE ──────────────────────────────────────────────────────
# Override get_graze_data() in per-species dino_graze.gd.
#
# Expected dict keys:
#
#   "crit_flavor"       Array[String]  — Big meal, no threat. 5-7 lines.
#   "success_flavor"    Array[String]  — Decent meal, no threat. 5 lines.
#   "no_food_flavor"    Array[String]  — Nothing found. 5 lines.
#
#   "mixed_encounters"  Array[Dict]    — Food found but a predator is present.
#     Each entry:
#       "flavor"          String  — Scene description naming the predator.
#       "predator"        Dict    — { "name", "size", "fight_power" }
#       "button_fight"    String  — Fight button label.
#       "sublabel_fight"  String  — Fight button sublabel.
#       "button_leave"    String  — Leave button label.
#       "sublabel_leave"  String  — Leave button sublabel.
#
#   "danger_encounters" Array[Dict]    — Predator attacks before food is reached.
#     Each entry:
#       "flavor"   String  — Scene description of the attack.
#       "predator" Dict    — { "name", "size", "fight_power" }
#
# hunger_value is set by the resolver (0.22 mixed win, 0.18 danger win).
# Do NOT set it in the predator dict here.
# ─────────────────────────────────────────────────────────────────────────────

func get_graze_data() -> Dictionary:
	return {}
