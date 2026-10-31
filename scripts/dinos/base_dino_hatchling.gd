class_name BaseDinoHatchling
extends Node

# ── KEY REFERENCE ──────────────────────────────────────────────────────────────
# get_hatchling_events() returns an Array of event Dictionaries.
# One event is picked at random each season the young are present.
#
# Each event Dictionary:
#   "intro"    — Array[String]  one line picked at random for the event flavor
#   "choices"  — Array[Dictionary]  shown as choice buttons; each entry:
#                  { "label": String, "sublabel": String, "icon": String, "action": String }
#                  action MUST be one of: "positive" | "neutral" | "negative"
#   "outcomes" — Dictionary  result text pools keyed by action:
#                  { "positive": Array[String], "neutral": Array[String], "negative": Array[String] }
#
# Score deltas applied automatically by the resolver:
#   "positive"  → nesting_score +0.15
#   "neutral"   → nesting_score  0.00
#   "negative"  → nesting_score −0.15
#
# The final nesting_score drives the pack_bond outcome when the young grow up:
#   >= 0.75  exceptional  pack_bond +0.25
#   >= 0.50  good         pack_bond +0.15
#   >= 0.25  okay         pack_bond +0.05
#   >= 0.00  neutral      pack_bond  0.00
#   >= -0.25 poor         pack_bond −0.10
#   <  -0.25 failed       pack_bond −0.20
# ─────────────────────────────────────────────────────────────────────────────

func get_hatchling_events() -> Array:
	return []
