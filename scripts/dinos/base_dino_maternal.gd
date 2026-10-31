class_name BaseDinoMaternal
extends Node

# Maternal bond events — fire each season while has_juvenile is true (female player, Pattern A species).
# One event drawn randomly per season. Phase lasts MATERNAL_JUVENILE_SEASONS seasons (see turn_manager).
#
# Offspring bond score accumulates from event outcomes; resolves when juvenile departs at sub-adult.
# Bond deltas: Crit +0.25 / Success +0.15 / Mixed +0.05 / Fail -0.10
#
# Departure outcomes (random stat from health / strength / speed / defense):
#   bond >= 1.0  → Great Maternal Bond  (chosen stat +0.04 permanent; offspring_bond_start += 0.20)
#   bond >= 0.5  → Strong Maternal Bond (chosen stat +0.025 permanent; offspring_bond_start += 0.10)
#   bond >= 0.1  → Neutral              (no change)
#   bond >= -0.2 → Weak Bond            (chosen stat -0.02 permanent)
#   bond <  -0.2 → Broken Bond          (chosen stat -0.04 permanent; offspring_bond_start -= 0.05)
#
# offspring_bond_start carries over within a run — experienced mothers begin the next juvenile phase
# at a non-zero bond value (capped at 0.60).
#
# Event structure (same as mother-bond child events, mirrored from the parent side):
# {
#     "intro":   ["intro text", ...],
#     "choices": [
#         { "label": "...", "sublabel": "...", "icon": "bond",   "action": "choice_a" },
#         { "label": "...", "sublabel": "...", "icon": "stalk",  "action": "choice_b" },
#         { "label": "...", "sublabel": "...", "icon": "flee",   "action": "choice_c" },
#         { "label": "...", "sublabel": "...", "icon": "attack", "action": "choice_d" },
#     ],
#     "outcomes": {
#         "choice_a": { "crit": ["..."], "success": ["..."], "mixed": ["..."], "fail": ["..."] },
#         "choice_b": { ... },
#         "choice_c": { ... },
#         "choice_d": { ... },
#     }
# }

func get_maternal_events() -> Array:
	return []
