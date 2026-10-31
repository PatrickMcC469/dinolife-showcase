class_name BaseDinoMate
extends Node

# ── KEY REFERENCE ──────────────────────────────────────────────────────────────
# Opening flavor / auto-event context:
#   "seek_male"                  — all male styles except pack_alpha / pack_coalition
#   "seek_male_alpha"            — intro flavor for the alpha breeding-season display event
#                                  (fires automatically at mating season start when is_alpha)
#   "alpha_display_show_label"   — String (not Array): button label for the show-off choice
#   "alpha_display_show"         — result lines when alpha showed off (costs hunger, mate_bond 0.80)
#   "alpha_display_guard"        — result lines when alpha guarded (neutral, mate_bond 0.60)
#   "alpha_display_ignore"       — result lines when alpha ignored the season (mate_bond 0.35)
#
#   Rival challenge (fires instead of display when a rival appears):
#   "rival_challenge_intro"      — rival appears this mating season
#   "rival_fight_won"            — alpha defended and won (auto-mates at 0.80 bond)
#   "rival_fight_lost"           — alpha lost the defence, no injury
#   "rival_fight_lost_injured"   — alpha lost the defence with minor injury
#   "rival_left"                 — alpha chose to leave rather than fight
#
#   "seek_male_sub"              — pack_alpha / pack_coalition male who is subordinate
#   "seek_female"                — all female styles except pack_alpha / pack_coalition
#   "seek_female_pack"           — Find Mate opening flavor for pack_alpha / pack_coalition female
#
#   Female nesting prep event (fires automatically at mating season start before Find Mate):
#   "female_season_intro"        — opening flavor for the female prep event
#   "female_prep_nest_label"     — String: button label for prepare-nest choice
#   "female_prep_food_label"     — String: button label for seek-food choice
#   "female_prep_group_label"    — String: button label for stay-close choice
#   "female_prep_nest"           — result lines: prepared the nest (hunger –0.10, nesting_score 0.25)
#   "female_prep_food"           — result lines: sought extra food (hunger –0.08, nesting_score 0.15)
#   "female_prep_group"          — result lines: stayed close (no cost, nesting_score 0.0)
#   "female_prep_ignore"         — result lines: ignored the season (no cost, nesting_score –0.15)
#
# Outcome pools (resolver picks one randomly; falls back to "success" / "no_mate"):
#   "success"                    — generic catch-all for any successful mating
#   "no_mate"                    — season passed without mating
#
#   pack_alpha / pack_coalition:
#   "alpha_chose_bold"           — alpha chose the boldest female
#   "alpha_chose_strong"         — alpha chose the strongest female
#   "sub_fight_won"              — subordinate won alpha challenge
#   "sub_fight_lost"             — subordinate lost alpha challenge (no injury)
#   "sub_fight_lost_injured"     — subordinate lost and came away with a minor injury
#   "sub_submitted"              — subordinate backed down
#   "sub_left_pack"              — subordinate left rather than fight
#   "female_accept_alpha"        — female accepted alpha pairing
#   "female_evade_success"       — female escaped territory to choose freely
#   "female_evade_caught"        — tried to evade but alpha found her anyway
#   "female_chose_sub_success"   — female sneaked a mating with subordinate
#   "female_chose_sub_caught"    — alpha caught the attempt, bond penalty
#
#   pack_coalition (deinonychus):
#   "coalition_alpha"            — alpha mates normally within coalition
#   "coalition_sub_permitted"    — alpha permits a subordinate (event-driven)
#   "coalition_sub_sneak"        — subordinate sneaked a mating
#
#   tournament_combat:
#   "tournament_fight_won"       — male won the fight
#   "tournament_fight_lost"      — male lost the fight
#   "tournament_display_good"    — display at edge worked (defense >= 0.45)
#   "tournament_display_fail"    — display did not earn attention
#   "tournament_pass"            — male observed, skipped season
#   "tournament_f_waited"        — female waited for winner
#   "tournament_f_chose_won"     — female chose one who won
#   "tournament_f_chose_lost"    — female chose one who lost but he still came
#   "tournament_f_left"          — female left the area
#
#   tournament_speed:
#   "speed_sprint_won"           — male sprinted and won
#   "speed_sprint_close"         — near the front, good enough
#   "speed_sprint_overexerted"   — pushed past limit, didn't finish well
#   "speed_pace_won"             — paced smart and won
#   "speed_pace_lost"            — paced but others ran smarter
#   "speed_pass"                 — held back, season passed
#   "speed_f_led"                — female ran with males, fastest followed
#   "speed_f_chose"              — female waited and picked
#
#   solitary_stalk:
#   "stalk_m_found"              — male followed trail, found her
#   "stalk_m_trail_lost"         — male followed but she had moved on
#   "stalk_m_waited_came"        — male marked territory, she came
#   "stalk_m_waited_empty"       — male marked, nothing came
#   "stalk_m_left"               — male left the trail alone
#   "stalk_f_received"           — female waited, he came on his timing
#   "stalk_f_approached"         — female moved toward him
#   "stalk_f_range_empty"        — female moved toward him, range was empty
#   "stalk_f_rejected"           — female drove him off (+ type_stat)
#
#   solitary_court (future dinos):
#   "court_m_signal"             — male left sign, she read it
#   "court_m_demonstrate"        — male hunted visibly
#   "court_m_waited"             — male was patient enough
#   "court_f_investigated"       — female followed sign to him
#   "court_f_approached"         — female walked straight to treeline
# ─────────────────────────────────────────────────────────────────────────────

func get_mate_data() -> Dictionary:
	return {}

# ── GENERIC EVENT ACCESSORS ───────────────────────────────────────────────────
# Override in per-species dino_mate.gd.
# Pattern A species (challenge/leave): implement get_male_event + get_female_event
# Pattern B species (tournament + effort): implement get_tournament_event + get_effort_event + get_female_event

func get_male_event() -> Dictionary:
	return {}

func get_female_event() -> Dictionary:
	return {}

func get_tournament_event() -> Dictionary:
	return {}

func get_effort_event() -> Dictionary:
	return {}
