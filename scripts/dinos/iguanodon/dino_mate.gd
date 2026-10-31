extends "res://scripts/dinos/base_dino_mate.gd"

# Iguanodon — mating season events (Pattern B: tournament_combat + effort chain)
#
# ── TOURNAMENT EVENT (auto-fires at mating season start) ─────────────────────
# 2 choices: Enter the tournament / Step back
#   Enter → fight roll (win_chance ~0.40 + luck)
#       Win         → breed_effort_pending = true; effort event fires same turn
#       Loss        → health -0.10, no mate
#       Loss+injury → health -0.10, random Iguanodon injury, no mate
#   Step back → no mate
#
# ── EFFORT EVENT (chains immediately after tournament win) ───────────────────
# 4 choices shaping nesting_score for the clutch.
# Hunger costs: full_support 0.12 / guard_path 0.07 / offer 0.04 / let 0.0
# Nesting score deltas (strong_success / success / mixed / fail):
#   full_support: +0.30 / +0.20 / +0.05 / -0.10
#   guard_path:   +0.20 / +0.15 / +0.05 / -0.05
#   offer:        +0.10 / +0.08 / +0.03 / 0.0
#   let:          +0.05 / +0.03 / -0.05 / -0.15
# has_mate + pending_egg set after effort event resolves.
#
# ── FEMALE EVENT ──────────────────────────────────────────────────────────────
# 4 choices shaping nesting_score.
# Hunger costs: strong_challenger 0.12 / test_patience 0.07 / safe_mate 0.04 / ignore 0.0
# Nesting score deltas (strong_success / success / mixed / fail):
#   strong_challenger: +0.35 / +0.25 / +0.05 / -0.15
#   test_patience:     +0.25 / +0.20 / +0.05 / -0.10
#   safe_mate:         +0.15 / +0.10 / +0.03 / -0.05
#   ignore:            +0.08 / +0.05 / -0.05 / -0.20
#
# ── FIGHT INJURIES ────────────────────────────────────────────────────────────
# "Thumb Spike Graze" → defense  -0.08, 2 turns
# "Shove Injury"      → strength -0.08, 2 turns
# "Leg Buckle"        → speed    -0.08, 2 turns

# ── Legacy flat data ──────────────────────────────────────────────────────────
const MATE_DATA: Dictionary = {
	"seek_male":                [],
	"seek_female":              [],
	"tournament_fight_won":     [],
	"tournament_fight_lost":    [],
	"tournament_display_good":  [],
	"tournament_display_fail":  [],
	"tournament_pass":          [],
	"tournament_f_waited":      [],
	"tournament_f_chose_won":   [],
	"tournament_f_chose_lost":  [],
	"tournament_f_left":        [],
	"success":                  [],
	"no_mate":                  [],
}

func get_mate_data() -> Dictionary:
	return MATE_DATA


# ── TOURNAMENT EVENT ──────────────────────────────────────────────────────────

const IGUA_TOURNAMENT_EVENT: Dictionary = {
	"intro": [
		"Mating season brings males together near the tree line. The contest is close and physical, and the winner earns first right to approach a female.",
		"Rival males are already displaying at the edge of the feeding ground. You can enter the contest or let the season pass to someone stronger.",
		"The tournament is underway at the far end of the meadow. Males shove and press with their bulk and thumb spikes, and the winners stay in the field.",
		"Breeding season opens with males jostling for position near the water. You have the size and the spikes to compete if you choose to.",
		"The mating contest draws males from across the territory. The field is competitive, but you have won contests before.",
	],
	"choices": [
		{ "label": "Enter the tournament",    "sublabel": "Compete for the right to mate", "icon": "attack", "action": "enter"     },
		{ "label": "Step back this year",     "sublabel": "Save your strength",            "icon": "flee",   "action": "step_back" },
	],
	"outcomes": {
		"step_back": [
			"You observe the contest from a distance and let the season pass to the males who entered.",
			"You step away from the tournament and move through the season without mating.",
			"The contest finishes without you. You save your strength and lose the breeding chance.",
			"You read the competition and decide the risk is not worth taking this season.",
			"You let the other males fight for position and hold back from the field.",
		],
		"enter": {
			"win": [
				"You drive your opponent back with a combination of weight and well-timed thumb spike pressure. The season is yours.",
				"The contest goes to the male who can hold his footing the longest. You hold yours, and the field clears.",
				"Your thumb spikes and your bulk together win the tournament. The other males give ground, and you take the claim.",
				"You outlast the competition through sheer endurance and controlled pressure. First place is yours.",
				"You win the tournament decisively and earn the right to mate this season.",
			],
			"loss": [
				"Your opponent holds position better than you do, and you are pushed from the contest. No mate this season.",
				"The tournament ends with you on the outside of the winning group. The season belongs to another male.",
				"You enter and compete hard, but the outcome goes against you. The breeding claim is not yours.",
				"You give the contest your best effort and fall short of the winners.",
				"The field is stronger than you this season. You exit the tournament without a mate.",
			],
			"loss_injured": [
				"An opponent's thumb spike catches your side before you can disengage. You leave the contest hurt and out of contention.",
				"The shove comes harder than expected and bends your leg wrong. You limp out of the tournament.",
				"You take a clean hit near the end of the contest and cannot hold your ground. You retreat with a minor injury.",
				"The tournament costs you more than a missed season. You carry a fresh wound out of the field.",
				"You are pushed from the contest with a knock that slows the days following it.",
			],
		},
	},
	"injuries": [
		{ "name": "Thumb Spike Graze", "stat": "defense",  "amount": -0.08, "turns": 2 },
		{ "name": "Shove Injury",      "stat": "strength", "amount": -0.08, "turns": 2 },
		{ "name": "Leg Buckle",        "stat": "speed",    "amount": -0.08, "turns": 2 },
	],
}

func get_tournament_event() -> Dictionary:
	return IGUA_TOURNAMENT_EVENT


# ── EFFORT EVENT ──────────────────────────────────────────────────────────────

const IGUA_EFFORT_EVENT: Dictionary = {
	"intro": [
		"You won the tournament and earned the right to mate. Now the female is preparing the nest, and how much you contribute may shape the clutch's beginning.",
		"The contest is behind you. The female is ready and the nesting period is starting. What you choose to give now may determine more than this season.",
		"You earned this season through the tournament. The next step is how much of yourself you invest in making the nesting succeed.",
		"The breeding season continues after the contest. The female is present, and the choice of how much you offer is yours.",
		"You won, and the season is moving forward. What you give to the nesting period may be the difference between a strong start and a weak one.",
	],
	"choices": [
		{ "label": "Give full support to the nest",  "sublabel": "Costs 12% food · best clutch chance", "icon": "bond",   "action": "full_support" },
		{ "label": "Guard the nesting area",         "sublabel": "Costs 7% food · good clutch chance",  "icon": "defend", "action": "guard_path"   },
		{ "label": "Offer what you can",             "sublabel": "Costs 4% food · modest clutch chance", "icon": "rest",   "action": "offer"        },
		{ "label": "Let the female manage",          "sublabel": "No cost · risk of poor start",   "icon": "flee",   "action": "let"          },
	],
	"outcomes": {
		"full_support": {
			"strong_success": [
				"You stay close throughout the nesting period, alert and present. The female has everything she needs, and the clutch begins with excellent promise.",
				"Your full attention to the nest keeps the area stable and the female calm. The season starts at its best.",
				"You give the nesting period every resource you have, and the clutch reflects the investment.",
				"Full presence pays off. The nesting completes in ideal conditions, and the future hatching benefits.",
				"You sacrifice comfort for the nest, and the result is a clutch that starts strongly.",
			],
			"success": [
				"Your full effort supports the nesting well. The clutch begins on solid terms.",
				"You stay close and contribute throughout. The season produces a good beginning.",
				"Full support gives the nest a strong start.",
				"You give everything, and the clutch reflects it.",
				"Your presence and effort carry the nesting period forward cleanly.",
			],
			"mixed": [
				"You give full effort, but the nesting period encounters minor problems that reduce the benefit.",
				"Your support is strong, but brief predator attention near the nest costs some of the advantage.",
				"You do everything right, and the result is only moderate. The season was not fully cooperative.",
				"Full effort leads to a middling outcome. The season could have gone better.",
				"You invest fully and receive a mixed result.",
			],
			"fail": [
				"Your constant presence near the nest draws the wrong kind of attention. The clutch's start suffers.",
				"Despite your best effort, the nesting period goes poorly. The future clutch begins at a disadvantage.",
				"Full investment produces a disappointing result. The season starts poorly.",
				"Your presence near the nest becomes a liability rather than a benefit.",
				"Full support backfires. The clutch begins in worse condition than expected.",
			],
		},
		"guard_path": {
			"strong_success": [
				"You take position on the approaches to the nesting ground and keep threats away. The clutch begins in excellent condition.",
				"Guarding the path makes a real difference. The female works without interruption, and the nest starts well.",
				"Your patrol of the nesting approaches keeps the area secure throughout. The clutch starts strongly.",
				"Steady perimeter work pays off with a clutch that begins at its best.",
				"You hold the perimeter through the full nesting period, and the result reflects that.",
			],
			"success": [
				"Your guard work keeps the nesting area safe. The season produces a good start.",
				"You patrol the approaches and the nest stays undisturbed. The clutch begins well.",
				"Guarding the path contributes meaningfully to the clutch's starting condition.",
				"You hold the perimeter, and the nesting proceeds cleanly.",
				"Steady guard effort gives the future clutch a solid beginning.",
			],
			"mixed": [
				"You guard the path but cannot keep every small threat out. The result is decent but imperfect.",
				"A brief disturbance near the nesting area costs the clutch some of its early advantage.",
				"Your guarding is effective most of the time. The season's result reflects partial success.",
				"The perimeter holds mostly. The clutch starts with modest improvement.",
				"You guard well enough, and the result is neither strong nor weak.",
			],
			"fail": [
				"A threat gets past your guard and disturbs the nest. The clutch begins at a disadvantage.",
				"Your patrol misses the right moment, and the cost follows.",
				"Guarding the path is not enough this season. The clutch suffers from a poorly protected nest.",
				"Something breaks through the perimeter at the wrong time, and the nesting period ends badly.",
				"Your guard work fails to protect the nest when it matters most.",
			],
		},
		"offer": {
			"strong_success": [
				"You offer limited help, and the female uses it better than you expected. The clutch starts well.",
				"A modest contribution lands at the right moment and improves the nesting more than the effort cost.",
				"You offer what you can, and luck makes it enough for a strong beginning.",
				"Small but well-timed support gives the clutch an unexpectedly good start.",
				"Your limited effort turns out to be exactly what was needed.",
			],
			"success": [
				"You offer modest support, and the nesting moves forward with decent promise.",
				"Limited help is still help. The clutch begins on adequate terms.",
				"You offer what you have, and the season benefits from it.",
				"Modest investment produces a modest but useful result.",
				"Your offer of support gives the nest a workable beginning.",
			],
			"mixed": [
				"You offer what you can, but it is not quite enough to make a real difference.",
				"Limited support leads to a limited result. The nesting continues on uncertain terms.",
				"You give a little and gain a little. The season produces a thin start.",
				"Your contribution is real but small. The clutch starts without much advantage.",
				"Modest effort gives a modest result.",
			],
			"fail": [
				"Your limited effort is not enough to support the nesting through a difficult period.",
				"Offering too little leaves the nest vulnerable to problems that compound.",
				"The modest investment does not cover what the season needs, and the clutch suffers.",
				"A small effort in a difficult season is not enough.",
				"Your limited support fails to make a difference, and the future clutch starts at a disadvantage.",
			],
		},
		"let": {
			"strong_success": [
				"You step back entirely, and the female handles the nesting well enough on her own. A fortunate result.",
				"You give nothing and the season still manages a decent outcome. The female is more capable than the situation suggested.",
				"Stepping back costs you nothing, and luck fills the gap with a reasonable start.",
				"You let the female manage, and she does. The clutch begins with modest but real potential.",
				"The season continues without your involvement, and the result surprises you.",
			],
			"success": [
				"You leave the nesting entirely to the female, and it mostly works out.",
				"No involvement, and a passable start for the clutch.",
				"The female handles the nest well enough without your help.",
				"You step back and the season moves forward on its own.",
				"Letting go of the nesting costs you nothing and gives a thin result.",
			],
			"mixed": [
				"You step back, and the nesting suffers somewhat without support.",
				"No effort means no contribution. The clutch starts without much going for it.",
				"Letting the female handle everything leads to a mediocre start at best.",
				"The season passes without your involvement, and the result shows it.",
				"A weak result follows from no effort.",
			],
			"fail": [
				"You give nothing to the nesting and the season reflects that clearly. The clutch begins at a real disadvantage.",
				"Stepping back entirely leaves the nest without any buffer when things go wrong.",
				"No involvement means no support when it counts. The future clutch starts poorly.",
				"You let the female handle everything, and the season produces the weakest possible beginning.",
				"The clutch pays the cost of your absence from the nesting period.",
			],
		},
	},
	"hunger": {
		"full_support": 0.12,
		"guard_path":   0.07,
		"offer":        0.04,
		"let":          0.0,
	},
	"nesting": {
		"full_support": { "strong_success":  0.30, "success":  0.20, "mixed":  0.05, "fail": -0.10 },
		"guard_path":   { "strong_success":  0.20, "success":  0.15, "mixed":  0.05, "fail": -0.05 },
		"offer":        { "strong_success":  0.10, "success":  0.08, "mixed":  0.03, "fail":  0.0  },
		"let":          { "strong_success":  0.05, "success":  0.03, "mixed": -0.05, "fail": -0.15 },
	},
}

func get_effort_event() -> Dictionary:
	return IGUA_EFFORT_EVENT


# ── FEMALE EVENT ──────────────────────────────────────────────────────────────

const IGUA_FEMALE_EVENT: Dictionary = {
	"intro": [
		"Mating season brings males to the edge of the feeding ground. The tournament is underway, and you have time to observe the field before choosing.",
		"Rival males are shoving and circling near the water. The winners will come looking for females, and you can choose how carefully you pick.",
		"The breeding contest fills the meadow with noise and movement. You watch from cover and consider your options before committing.",
		"Males are competing at the edge of the territory. Their fitness is visible in how they move through the contest, if you know what to watch for.",
		"The tournament separates the field into winners and losers. You can choose among the winners, test someone more carefully, or let the season pass.",
		"Breeding season brings male competition close enough to observe. What you choose now may shape more than just this hatching.",
		"The mating season opens with visible contests and clear winners. How much effort you put into choosing may decide the season's value.",
	],
	"choices": [
		{ "label": "Choose the tournament winner",   "sublabel": "Costs 12% food · best clutch chance · high risk", "icon": "attack", "action": "strong_challenger" },
		{ "label": "Test the male's steadiness",     "sublabel": "Costs 7% food · good clutch chance",             "icon": "stalk",  "action": "test_patience"     },
		{ "label": "Choose the safest nearby male",  "sublabel": "Costs 4% food · modest clutch chance",            "icon": "bond",   "action": "safe_mate"          },
		{ "label": "Ignore the breeding season",     "sublabel": "No cost · risk of poor start",              "icon": "flee",   "action": "ignore"             },
	],
	"outcomes": {
		"strong_challenger": {
			"strong_success": [
				"You choose the male who won the tournament with the most control. His strength is real and his fitness is clear. The clutch begins with excellent promise.",
				"The tournament winner you select is composed after the contest, not just powerful during it. The clutch benefits.",
				"You wait for the winner to prove himself past the fight, and he does. The season starts at its best.",
				"The strongest male in the field turns out to have genuine fitness behind his size. You choose him, and the clutch starts well.",
				"You pick the tournament winner with full intent, and the result matches the effort.",
			],
			"success": [
				"You choose the tournament winner and the clutch begins with solid promise.",
				"The winning male proves capable, and the season moves forward confidently.",
				"A strong tournament winner gives the future clutch a meaningful advantage.",
				"The strongest male earns the mating, and the clutch starts well.",
				"You choose well, and the season reflects the effort.",
			],
			"mixed": [
				"The tournament winner is also the most restless. His presence near the nest creates instability.",
				"You choose the strongest male, but his aggression does not stop after the contest.",
				"Strength is there. Composure is not. The season improves, but not cleanly.",
				"The winning male is useful in one way and disruptive in another. The result is mixed.",
				"The strongest choice comes with complications. The net result is moderate.",
			],
			"fail": [
				"The tournament winner turns reckless after the contest. His instability costs the clutch its best start.",
				"You choose raw strength, and the male has nothing else to offer the nest.",
				"The contest winner turns out to be suited only for fighting. The breeding season suffers.",
				"Strength without stability means the nesting period goes poorly. The clutch starts badly.",
				"The strongest choice was not the right one. The clutch begins at a disadvantage.",
			],
		},
		"test_patience": {
			"strong_success": [
				"You lead the male through the territory and observe whether he follows your pace or pushes past it. He follows.",
				"His steadiness proves real over the course of the test. You accept him, and the clutch starts on excellent terms.",
				"The male who passes your patience test is composed in a way that matters more than his contest result.",
				"You test him long enough to see genuine control, not just good behavior on a good day. He has it.",
				"His consistency across the full test gives you confidence. The clutch starts strongly.",
			],
			"success": [
				"He passes the steadiness test well enough. The season moves forward with good promise.",
				"You observe him carefully and he earns the choice. The clutch starts solidly.",
				"A steady male produces a steady beginning for the clutch.",
				"He shows real composure, and you accept him. The future clutch starts well.",
				"The test produces a reliable result and a good breeding start.",
			],
			"mixed": [
				"He holds the test for most of it, then loses patience near the end. Good enough, not ideal.",
				"His steadiness is real but inconsistent. The season moves forward on uncertain terms.",
				"The test reveals a male who can be patient when he tries. The result is middling.",
				"He passes in part. The clutch gains something, though not the most it could.",
				"An imperfect test still moves the season forward, just not optimally.",
			],
			"fail": [
				"He breaks the test early and turns aggressive before it is done. The season loses its best chance.",
				"The male cannot hold composure through the test and becomes difficult to manage.",
				"Poor steadiness reveals poor fitness. The test was right to be cautious.",
				"He gives up on patience before the test gives up on him. The clutch suffers.",
				"The test fails, and the season carries the cost forward.",
			],
		},
		"safe_mate": {
			"strong_success": [
				"The nearest available male turns out to carry more fitness than his quiet manner suggested.",
				"You choose safety and the nearby male exceeds the expectation. The clutch begins better than planned.",
				"He is not the strongest in the field, but he is steady and close, and the result is surprisingly good.",
				"Choosing the familiar nearby male pays off with a clutch that starts strongly.",
				"The safe option turns out to be the best one available this season.",
			],
			"success": [
				"You choose a calm nearby male. The clutch begins with modest but real promise.",
				"He is close and acceptable, and the season moves forward without complication.",
				"Safety gives the nest a stable beginning and the clutch a decent start.",
				"You accept the nearby male and the future clutch starts on adequate terms.",
				"The season moves forward cleanly with the safest available choice.",
			],
			"mixed": [
				"The nearby male is stable but not especially fit. The clutch gains stability more than strength.",
				"Safety serves the season, but the clutch's potential is limited.",
				"You choose caution, and the result is exactly as cautious as the choice.",
				"He keeps the area calm and offers little beyond that. The future is thin.",
				"A safe season produces a modest beginning.",
			],
			"fail": [
				"The safest nearby male turns out to have less fitness than he appeared. The clutch starts poorly.",
				"You choose proximity over quality, and the result confirms the mistake.",
				"He keeps the territory undisturbed and contributes almost nothing to the clutch.",
				"The safe option offers no meaningful benefit. The future clutch starts below its potential.",
				"Safety and fitness did not come together this season.",
			],
		},
		"ignore": {
			"strong_success": [
				"You give the season little attention, and luck delivers a passing male at the right moment.",
				"You save your energy and the season still manages a decent result.",
				"A suitable male crosses your path without you seeking one. The season continues.",
				"You ignore the tournament noise and a capable male still appears.",
				"The chance was weaker for your lack of effort, but it did not disappear.",
			],
			"success": [
				"You give the season little effort, but a male still finds you at the right time.",
				"You ignore most of the contest results, and the season moves forward anyway.",
				"A passing male proves good enough despite your limited engagement.",
				"The chance is modest, but not gone. The season continues.",
				"You save your strength, and luck fills part of the gap.",
			],
			"mixed": [
				"You ignore the season too long, and the best chances pass before you engage them.",
				"The tournament ends and the males disperse before you take the opportunity.",
				"You save your energy, but the future clutch gains little from this season.",
				"Breeding season moves around you while you remain apart from it.",
				"The opportunity weakens with every day you do not engage it.",
			],
			"fail": [
				"Ignoring the season leaves the timing poor and the clutch starting from behind.",
				"Too many signs pass unanswered, and the season turns thin.",
				"Your distance from the season weakens the chance of a strong beginning.",
				"The meadow goes quiet again. The missed effort carries a real cost.",
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
	return IGUA_FEMALE_EVENT
