extends "res://scripts/dinos/base_dino_mate.gd"

# T-Rex — mating season events (Pattern A: challenge/leave)
#
# ── MALE EVENT ────────────────────────────────────────────────────────────────
# Auto-fires at mating season start.
# 2 choices: Challenge rival / Leave
#   Challenge → fight roll (win_chance ~0.45 + luck)
#       Win        → has_mate, pending_egg, male_mating_streak++, check streak boost
#       Loss       → health -0.12, streak resets to 0
#       Loss+injury → health -0.12, random T-Rex injury, streak resets to 0
#   Leave → no mate, streak resets to 0
#
# ── MALE STREAK BONUS ─────────────────────────────────────────────────────────
# Streak 2 → permanent_strength_mod +0.03 ("Proven Line")
# Streak 4 → permanent_strength_mod +0.03 ("Dominant Line")
# Max +0.06. Resets on any season without a mate.
#
# ── FEMALE EVENT ──────────────────────────────────────────────────────────────
# 4 choices shaping nesting_score for the clutch.
# Hunger costs: strong_challenger 0.12 / test_patience 0.07 / safe_mate 0.04 / ignore 0.0
# Nesting score deltas (strong_success / success / mixed / fail):
#   strong_challenger: +0.35 / +0.25 / +0.05 / -0.15
#   test_patience:     +0.25 / +0.20 / +0.05 / -0.10
#   safe_mate:         +0.15 / +0.10 / +0.03 / -0.05
#   ignore:            +0.08 / +0.05 / -0.05 / -0.20
#
# ── FIGHT INJURIES ────────────────────────────────────────────────────────────
# "Jaw Crush"  → strength -0.08, 2 turns
# "Flank Ram"  → defense  -0.08, 2 turns
# "Tail Slam"  → speed    -0.08, 2 turns

# ── Legacy flat data ──────────────────────────────────────────────────────────
const MATE_DATA: Dictionary = {
	"seek_male":           [],
	"seek_female":         [],
	"stalk_m_found":       [],
	"stalk_m_trail_lost":  [],
	"stalk_m_waited_came": [],
	"stalk_m_waited_empty":[],
	"stalk_m_left":        [],
	"stalk_f_received":    [],
	"stalk_f_approached":  [],
	"stalk_f_range_empty": [],
	"stalk_f_rejected":    [],
	"success":             [],
	"no_mate":             [],
}

func get_mate_data() -> Dictionary:
	return MATE_DATA


# ── MALE EVENT ────────────────────────────────────────────────────────────────

const TREX_MALE_EVENT: Dictionary = {
	"intro": [
		"Mating season shifts the air. You follow a female's trail through the floodplain until a rival male steps from the treeline, blocking the path.",
		"The season pulls you toward a female's scent drifting across open ground. Before you close the distance, another male rises from the basin ahead.",
		"You find the trail of a female cutting through dry brush. The scent is fresh, but a rival has been following the same path longer.",
		"A low call rolls through the territory from a nearby female. When you answer the direction, a rival male answers it too.",
		"You follow the most promising scent of the season to a ridge clearing. A rival male is already there, reading the same trail.",
		"The breeding season stretches across the lowlands with heat and weight. A female is near, and a rival stands between you and her claim.",
		"You move through the basin at the start of mating season. Another male crosses your path and does not step aside.",
	],
	"choices": [
		{ "label": "Challenge the rival male", "sublabel": "Win the right to mate", "icon": "attack", "action": "challenge" },
		{ "label": "Leave the pair alone",     "sublabel": "Save your strength",    "icon": "flee",   "action": "leave"     },
	],
	"outcomes": {
		"leave": [
			"You read the rival's weight and step off the trail before the fight begins.",
			"The female's scent pulls hard, but the rival's size pulls harder. You turn away.",
			"You move back from the encounter and let the season belong to the other male.",
			"This season has a stronger claim than yours. You leave the floodplain without pressing it.",
			"You lower your head and walk from the clearing. The rival watches you go.",
			"The trail goes dark behind you as you pull away from the contest.",
			"You leave the ridge before the challenge can sharpen into something that costs too much.",
		],
		"challenge": {
			"win": [
				"You drive the rival from the trail with weight and controlled force. He retreats into the basin, and the season is yours.",
				"The clash tears across the ridge in dust and noise. When it ends, the rival is backing away and the female is still close.",
				"Your power outlasts his nerve. The rival steps off the trail and does not return, and you take the claim.",
				"The fight is short and decided by your bite landing first. The rival pulls back hard, and the season opens.",
				"You force the rival out of the clearing with one decisive press. He gives ground, and the right to mate passes to you.",
				"The rival cannot match your endurance. He retreats before the fight turns against him, and you hold the ground.",
				"You win the season with force that leaves no doubt. The rival is gone, and the female remains.",
			],
			"loss": [
				"The rival holds the trail and pushes you back before the fight can turn your way.",
				"You lose the contest before your strength finds its rhythm. The female trails the rival into the floodplain.",
				"The other male's force wins the clearing. You pull away before the cost becomes worse.",
				"He drives you off the ridge with a final hard push. The season belongs to him.",
				"The rival holds stronger than you expected, and you retreat without mating this season.",
				"Your challenge fails. The rival keeps the trail, and you move back through the basin alone.",
				"The fight ends with you pushing away from the clearing, tired and without a claim.",
			],
			"loss_injured": [
				"The rival catches you cleanly before you can disengage. You leave the trail hurt and without a mate.",
				"The fight goes badly. You escape before the damage worsens, but you carry the season's loss with you.",
				"He lands a hard strike before you pull clear. You survive, but the injury slows you and the season is gone.",
				"You retreat too slowly, and the rival's final push leaves you sore and beaten.",
				"The contest costs you more than a missed season. You pull away from the clearing carrying a fresh wound.",
				"Pain follows you down from the ridge as the rival keeps his claim.",
				"You escape the fight alive, but not without damage, and the season closes behind you.",
			],
		},
	},
	"streak_flavor": [
		"Your record in this season is not new. You carry the confidence of proven wins.",
		"The territory has seen your strength before, and you move through mating season with that history behind you.",
		"Another successful season adds weight to your bloodline and purpose to your claim.",
		"You have won this fight before. The pattern is starting to feel like dominance rather than luck.",
		"Consecutive seasons give the contest a different quality. You are not guessing at the outcome.",
	],
	"injuries": [
		{ "name": "Jaw Crush",  "stat": "strength", "amount": -0.08, "turns": 2 },
		{ "name": "Flank Ram",  "stat": "defense",  "amount": -0.08, "turns": 2 },
		{ "name": "Tail Slam",  "stat": "speed",    "amount": -0.08, "turns": 2 },
	],
}

func get_male_event() -> Dictionary:
	return TREX_MALE_EVENT


# ── FEMALE EVENT ──────────────────────────────────────────────────────────────

const TREX_FEMALE_EVENT: Dictionary = {
	"intro": [
		"Mating season settles across the floodplain. Males have been moving through the territory for days, and the strongest ones are still circling.",
		"The season brings rivals to the edge of your range. You can hear them reading the same signs you left, deciding whether to press toward you.",
		"Heavy footsteps and distant calls mark the beginning of breeding season. What you choose now may shape the strength of the clutch that follows.",
		"The air carries the scent of more than one male. Some are confident. Some are cautious. Some are only loud.",
		"You are solitary, but the season finds you anyway. The choice is whether to meet it with effort or let it pass on its own terms.",
		"Males have been pressing through the lowlands for the last several days. The strongest ones leave the clearest signs.",
		"The mating season opens with distant calls and fresh trails. How you move through it may determine more than just this year.",
	],
	"choices": [
		{ "label": "Choose the strongest challenger", "sublabel": "Costs 12% food · best clutch chance · high risk", "icon": "attack", "action": "strong_challenger" },
		{ "label": "Test the male's patience",        "sublabel": "Costs 7% food · good clutch chance",             "icon": "stalk",  "action": "test_patience"     },
		{ "label": "Choose the safest nearby male",   "sublabel": "Costs 4% food · modest clutch chance",            "icon": "bond",   "action": "safe_mate"          },
		{ "label": "Ignore the breeding season",      "sublabel": "No cost · risk of poor start",              "icon": "flee",   "action": "ignore"             },
	],
	"outcomes": {
		"strong_challenger": {
			"strong_success": [
				"The male you choose has driven off two rivals already. His power is real and his control is clear. The clutch begins with strong promise.",
				"You wait until only the most proven male remains in the territory, then you move toward him. The season starts with excellent potential.",
				"He is exactly what you were reading for: strength without recklessness, force without panic. The future clutch benefits.",
				"You choose the heaviest, most measured male of the season, and the choice holds up. The breeding starts on strong terms.",
				"The strongest challenger proves worthy of the wait. The clutch carries his fitness forward.",
			],
			"success": [
				"You choose a strong male, and the season begins with solid promise.",
				"He proves capable, and the clutch's starting condition improves.",
				"The male you accept has enough strength to make the choice worthwhile.",
				"A capable pairing gives the season a confident beginning.",
				"The choice holds up. The breeding produces a good result.",
			],
			"mixed": [
				"The male is strong, but he brings aggression that unsettles the territory. The clutch gains something, though not cleanly.",
				"You choose power, and it is useful, but his noise and movement attract attention to the nesting ground.",
				"He is impressive and difficult to manage. The season improves, but the territory feels less safe after.",
				"His strength is real. His judgment is not. The future clutch benefits from one and suffers slightly from the other.",
				"The pairing is promising in some ways and costly in others. The net result is modest.",
			],
			"fail": [
				"The strongest male turns reckless and draws danger toward the nesting area. The season starts badly.",
				"You chose power without caution, and his aggression makes the territory unsafe.",
				"He wins every fight and loses every instinct for stillness. The clutch begins at a disadvantage.",
				"The breeding season suffers from his inability to keep the territory quiet.",
				"You chose the loudest male, and the breeding season pays for it.",
			],
		},
		"test_patience": {
			"strong_success": [
				"You hold back and watch how he reads your movement. He waits, follows without pressing, and earns the season.",
				"The male does not rush or push. His patience proves deeper than his strength, and the clutch benefits from both.",
				"You test him across several days, and he matches your pace without breaking. The season begins with a solid foundation.",
				"His control is more impressive than his size. A male who can wait is one worth mating with.",
				"He passes the test cleanly, and the clutch starts with the benefit of careful selection.",
			],
			"success": [
				"The male shows enough patience to earn the mating. The season moves forward steadily.",
				"He follows without forcing the moment, and the clutch's starting condition improves.",
				"A cautious test produces a reliable result. The season proceeds well.",
				"You accept him after the test, and the future clutch starts with decent promise.",
				"His restraint wins the season, and the breeding produces a solid beginning.",
			],
			"mixed": [
				"He starts steady and loses it before the test is done. The result is acceptable but not clean.",
				"The male holds patience for most of the test, then breaks it. Useful enough, though not ideal.",
				"He proves himself in part. The season moves forward with uncertain promise.",
				"You learn enough about him to proceed, but not enough to feel confident.",
				"The test reveals a male capable of patience when it suits him, which is close enough.",
			],
			"fail": [
				"He breaks the test early and becomes aggressive before you are ready. The season suffers for his impatience.",
				"The male mistakes your caution for rejection and turns the test into a confrontation.",
				"His patience runs out before it should, and the season loses value because of it.",
				"Poor control costs the clutch its best possible start. The test proves him unsuitable.",
				"He fails the test, and the breeding season carries that forward into the future.",
			],
		},
		"safe_mate": {
			"strong_success": [
				"The nearby male knows the territory well and keeps his movement careful. The season turns out stronger than expected.",
				"You choose safety, and the familiar male delivers more than his size suggested. The clutch begins well.",
				"He is not the largest or the loudest, but he keeps the ground steady and the territory quiet.",
				"Choosing the closest reliable male pays off. The future clutch starts with unexpected strength.",
				"The safe choice proves better than the gamble would have. The season starts with calm and confidence.",
			],
			"success": [
				"You choose a nearby male who causes no trouble. The season advances with modest promise.",
				"He is close, steady, and good enough. The clutch starts without excitement but without risk.",
				"The choice keeps the territory quiet and the future breeding stable.",
				"You accept a mate who gives the clutch a decent beginning without complications.",
				"Safety carries the season forward cleanly.",
			],
			"mixed": [
				"The nearby male is acceptable but not especially fit. The clutch gains stability more than strength.",
				"You choose caution, and it serves the season, though not as well as a harder choice might have.",
				"The pairing is steady but thin. The clutch's future holds less than it could.",
				"He avoids trouble, but his contribution to the clutch is modest at best.",
				"The season stays quiet, which is worth something, though not everything.",
			],
			"fail": [
				"The safe male proves weaker than he seemed, and the clutch begins at a disadvantage.",
				"You choose caution, but the nearby male lacks the fitness to make it worthwhile.",
				"His presence keeps the season stable without giving the clutch any real improvement.",
				"The choice avoids danger but offers very little in return.",
				"The safe option turns out to be the thin one. The future clutch starts below its potential.",
			],
		},
		"ignore": {
			"strong_success": [
				"You move through the season with little effort, but a capable male crosses your path at the right moment.",
				"You give the season only passing attention, and luck provides what deliberate choice might have.",
				"A suitable male appears without you seeking one. The season continues despite your distance from it.",
				"You save your energy and the season still manages to move forward.",
				"The chance was weaker for your lack of effort, but it did not disappear entirely.",
			],
			"success": [
				"You give the season little effort, but a male still crosses your path at the right time.",
				"You ignore most of the calls, but the season moves forward anyway.",
				"A passing male proves acceptable despite your limited engagement.",
				"The chance is modest, but not gone. The season continues.",
				"You save your strength, and luck fills part of the season's gap.",
			],
			"mixed": [
				"You ignore the season too long, and the best chance fades before you take it.",
				"The male calls pass through the territory unanswered.",
				"You save your energy, but the future clutch gains little from this season.",
				"Breeding season moves around you while you stay apart from it.",
				"The opportunity weakens with every day you do not engage it.",
			],
			"fail": [
				"Ignoring the season leaves the timing poor and the future clutch starting from behind.",
				"You let the signs pass unanswered too long, and the season turns thin.",
				"Your distance from the season weakens the chance of a strong beginning.",
				"The forest grows quiet again. The missed effort carries a real cost.",
				"The season passes without good terms, and the clutch's starting condition suffers.",
			],
		},
	},
	"hunger": {
		"strong_challenger": 0.12,
		"test_patience":     0.07,
		"safe_mate":         0.04,
		"ignore":            0.0,
	},
	"nesting": {
		"strong_challenger": { "strong_success":  0.35, "success":  0.25, "mixed":  0.05, "fail": -0.15 },
		"test_patience":     { "strong_success":  0.25, "success":  0.20, "mixed":  0.05, "fail": -0.10 },
		"safe_mate":         { "strong_success":  0.15, "success":  0.10, "mixed":  0.03, "fail": -0.05 },
		"ignore":            { "strong_success":  0.08, "success":  0.05, "mixed": -0.05, "fail": -0.20 },
	},
}

func get_female_event() -> Dictionary:
	return TREX_FEMALE_EVENT
