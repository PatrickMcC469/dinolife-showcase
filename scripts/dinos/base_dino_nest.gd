class_name BaseDinoNest
extends Node

# Keys:
#   "tend"          — success pool for Tend Nest action (5 lines, shown each season used)
#   "already_used"  — already tended this season pool (5 lines)
#   "outcome_exceptional"  — nesting_score >= 0.75 (5 lines)
#   "outcome_good"         — nesting_score >= 0.50 (5 lines)
#   "outcome_okay"         — nesting_score >= 0.25 (5 lines)
#   "outcome_neutral"      — nesting_score >= 0.0  (5 lines)
#   "outcome_poor"         — nesting_score >= -0.25 (5 lines)
#   "outcome_failed"       — nesting_score  < -0.25 (5 lines)

func get_nest_data() -> Dictionary:
	return {}
