class_name BaseDinoJuvenile
extends Node

# Juvenile parental events — fire each season during life_stage 1 (Juvenile).
# Stops when life_stage reaches 2 (Sub-adult); outcome resolves the following turn.
#
# ── GENERIC system (choice actions: "follow" / "partial" / "ignore") ──────────
# juvenile_lesson_score accumulates; outcome at sub-adult:
#   score >= 0.5 → permanent_strength_mod +0.08  ("Raised Well")
#   score >= 0.3 → permanent_strength_mod +0.05  ("Well Raised")
#   score >= 0.1 → permanent_speed_mod    +0.04  ("Fair Start")
#   else         → no bonus
#
# Generic event structure:
# {
#     "intro":   ["intro text", ...],
#     "choices": [
#         { "label": "...", "sublabel": "...", "icon": "bond",  "action": "follow"  },
#         { "label": "...", "sublabel": "...", "icon": "stalk", "action": "partial" },
#         { "label": "...", "sublabel": "...", "icon": "flee",  "action": "ignore"  },
#     ],
#     "outcomes": {
#         "follow":  ["result text", ...],
#         "partial": ["result text", ...],
#         "ignore":  ["result text", ...],
#     }
# }
#
# ── MOTHER-BOND system (T-Rex / Allosaurus) ───────────────────────────────────
# 4 choices (choice_a/b/c/d), each with 4 outcome tiers (crit/success/mixed/fail).
# Tier rolled at resolve time — base odds + luck modifier.
# Bond deltas: Crit +0.25 / Success +0.15 / Mixed +0.05 / Fail -0.10
# Departure at sub-adult affects ALL 4 stats:
#   bond >= 1.0  → Great Bond  (+0.04 permanent each stat)
#   bond >= 0.5  → Strong Bond (+0.025 permanent each stat)
#   bond >= 0.1  → Neutral     (no change)
#   bond >= -0.2 → Weak Bond   (-0.02 permanent each stat)
#   bond <  -0.2 → Broken Bond (-0.04 permanent each stat)
#
# Mother-bond event structure:
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

func get_juvenile_events() -> Array:
	return []
