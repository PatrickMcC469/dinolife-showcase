extends "res://scripts/dinos/base_dino_mate.gd"

# Triceratops — mating season events (Pattern B: tournament_combat + effort chain)
#
# ── TOURNAMENT EVENT (auto-fires at mating season start) ─────────────────────
# 2 choices: Enter the tournament / Step back
#   Enter → fight roll (win_chance ~0.40 + luck)
#       Win         → breed_effort_pending = true; effort event fires same turn
#       Loss        → health -0.10, no mate
#       Loss+injury → health -0.10, random Triceratops injury, no mate
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
# "Horn Clash Impact" → strength -0.08, 2 turns
# "Frill Strike"      → defense  -0.08, 2 turns
# "Brace Slip"        → speed    -0.08, 2 turns

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

const TRIC_TOURNAMENT_EVENT: Dictionary = {
	"intro": [
		"Mating season brings males into horn-to-horn contests across the open plain. The male who wins the locking match earns first right to the females.",
		"Rival males are already circling and clashing near the herd's edge. You can enter the horn contest or hold back and let the season pass.",
		"The tournament is underway, and the sound of locking horns carries across the territory. The winners stay in the field. The losers move off.",
		"Breeding season opens with a display of horns and frills. The male who holds his ground through the contest earns the season's claim.",
		"Males are forming into matched pairs at the center of the herd's range. The contest begins and you have the horns and the weight to compete.",
	],
	"choices": [
		{ "label": "Enter the tournament",    "sublabel": "Compete for the right to mate", "icon": "attack", "action": "enter"     },
		{ "label": "Step back this year",     "sublabel": "Save your strength",            "icon": "flee",   "action": "step_back" },
	],
	"outcomes": {
		"step_back": [
			"You watch the horn contest from the outside and let the season pass to the males who entered.",
			"You step back from the tournament and move through the season without mating.",
			"The horn contest finishes without you. You save your strength and miss the breeding claim.",
			"You read the competition and decide this year the contest is not worth entering.",
			"You let the other males clash and hold yourself back from the field.",
		],
		"enter": {
			"win": [
				"Your horns lock with the rival's and you push until his footing breaks. He pulls away and the season is yours.",
				"The horn contest goes to the male who holds longest. Your legs and your neck hold longer, and the field clears.",
				"You drive your opponent back step by step until he turns away. The tournament is decided in your favor.",
				"You win the locking contest with endurance and angle. The other males give ground, and you hold the claim.",
				"Your horns and your frill win the tournament. You earn the right to mate this season.",
			],
			"loss": [
				"Your opponent breaks your footing before you can recover, and you are pushed from the contest.",
				"The horn contest ends with you on the losing side. The breeding claim goes to a stronger male.",
				"You compete hard through the locking match, but the outcome turns against you.",
				"You give the contest everything you have and fall short. No mate this season.",
				"The field is stronger than you this time. You exit the tournament without a claim.",
			],
			"loss_injured": [
				"The horn clash catches you at a bad angle and something strains in your neck. You pull from the contest hurt.",
				"You slip at the critical moment and take the rival's horn across your frill. You leave with a minor injury.",
				"A hard lock that breaks suddenly throws your weight wrong. You limp away from the tournament.",
				"The contest costs you more than the season. You carry a fresh wound from the horn exchange.",
				"You are pushed from the contest with a knock that slows the days that follow.",
			],
		},
	},
	"injuries": [
		{ "name": "Horn Clash Impact", "stat": "strength", "amount": -0.08, "turns": 2 },
		{ "name": "Frill Strike",      "stat": "defense",  "amount": -0.08, "turns": 2 },
		{ "name": "Brace Slip",        "stat": "speed",    "amount": -0.08, "turns": 2 },
	],
}

func get_tournament_event() -> Dictionary:
	return TRIC_TOURNAMENT_EVENT


# ── EFFORT EVENT ──────────────────────────────────────────────────────────────

const TRIC_EFFORT_EVENT: Dictionary = {
	"intro": [
		"You won the tournament and earned the right to mate. The female is preparing the nest, and what you offer from here may shape the clutch's beginning.",
		"The horn contest is behind you. The female is ready and the nesting period is starting. What you invest now may determine more than this season.",
		"You earned this season through the tournament. The next step is how much of yourself you give to making the nesting succeed.",
		"The breeding season continues after the contest. The female is present, and the choice of how much you contribute is yours.",
		"You won, and the season is moving forward. What you give to the nesting period may be the difference between a strong start and a modest one.",
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
				"You stay close throughout the nesting period, alert and steady. The female has everything she needs, and the clutch begins with excellent promise.",
				"Your full attention to the nest keeps the area undisturbed and the female composed. The season starts at its best.",
				"You give the nesting period everything you have, and the clutch reflects the investment.",
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
				"You give full effort, but the nesting encounters minor complications that reduce the benefit.",
				"Your support is strong, but a brief threat near the nest costs some of the advantage.",
				"You do everything right, and the result is only moderate. Luck was against you.",
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
				"You position yourself on the approaches to the nesting ground and keep threats away. The clutch begins in excellent condition.",
				"Guarding the path makes a real difference. The female works without interruption, and the nest starts strongly.",
				"Your patrol of the nesting approaches keeps the area secure throughout. The clutch starts at its best.",
				"Steady perimeter work pays off with a clutch that begins strongly.",
				"You hold the perimeter through the full nesting period and the result reflects it.",
			],
			"success": [
				"Your guard work keeps the nesting area safe. The season produces a good start.",
				"You patrol the approaches and the nest stays undisturbed. The clutch begins well.",
				"Guarding the path contributes meaningfully to the clutch's starting condition.",
				"You hold the perimeter and the nesting proceeds cleanly.",
				"Steady guard effort gives the future clutch a solid beginning.",
			],
			"mixed": [
				"You guard the path but cannot keep every small threat out. The result is decent but imperfect.",
				"A brief disturbance near the nest costs the clutch some of its early advantage.",
				"Your guarding is effective most of the time. The season's result reflects partial success.",
				"The perimeter holds mostly. The clutch starts with modest improvement.",
				"You guard well enough, and the result is neither strong nor weak.",
			],
			"fail": [
				"A threat gets past your guard and disturbs the nest at the wrong moment. The clutch begins at a disadvantage.",
				"Your patrol misses the critical moment, and the cost follows.",
				"Guarding the path is not enough this season. The clutch suffers.",
				"Something breaks through at the wrong time, and the nesting period ends badly.",
				"Your guard work fails to protect the nest when it matters.",
			],
		},
		"offer": {
			"strong_success": [
				"You offer limited help, and the female uses it better than expected. The clutch starts well.",
				"A modest contribution lands at the right moment and improves the nesting more than it cost.",
				"You offer what you can, and luck makes it enough for a strong beginning.",
				"Small but timely support gives the clutch an unexpectedly good start.",
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
				"Offering too little leaves the nest vulnerable to problems that grow.",
				"The modest investment does not cover what the season needs, and the clutch suffers.",
				"A small effort is not enough when the season is difficult.",
				"Your limited support fails to make a difference, and the future clutch starts at a disadvantage.",
			],
		},
		"let": {
			"strong_success": [
				"You step back entirely, and the female handles the nesting well enough on her own. A fortunate outcome.",
				"You give nothing and the season still manages a decent result. The female manages better than expected.",
				"Stepping back costs you nothing, and luck fills the gap with a reasonable start.",
				"You let the female manage, and she does. The clutch begins with modest but real potential.",
				"The season continues without your involvement, and the result surprises you.",
			],
			"success": [
				"You leave the nesting entirely to the female, and it mostly works out.",
				"No involvement, and a passable start for the clutch.",
				"The female handles the nest well enough without you.",
				"You step back and the season moves forward on its own.",
				"Letting go of the nesting costs you nothing and gives a thin result.",
			],
			"mixed": [
				"You step back, and the nesting suffers somewhat without support.",
				"No effort means no contribution. The clutch starts without much going for it.",
				"Letting the female handle everything leads to a mediocre start.",
				"The season passes without your involvement, and the result shows it.",
				"A weak result follows from no effort.",
			],
			"fail": [
				"You give nothing to the nesting and the season reflects that. The clutch begins at a real disadvantage.",
				"Stepping back entirely leaves the nest without a buffer when things go wrong.",
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
	return TRIC_EFFORT_EVENT


# ── FEMALE EVENT ──────────────────────────────────────────────────────────────

const TRIC_FEMALE_EVENT: Dictionary = {
	"intro": [
		"Mating season fills the plain with horn contests and frill displays. The strongest males in the herd are proving themselves, and your choice may shape the clutch.",
		"The tournament is underway at the center of the herd's range. You can watch who wins and how, and choose based on what you see.",
		"Horn clashes and backing matches carry across the territory. The males making the most noise are not always the best choice.",
		"Breeding season brings real competition to the surface. What the horn contest reveals may be exactly what you need to make a decision.",
		"Rival males are locking horns near the herd's edge. You have time to observe the field carefully before committing to a choice.",
		"The mating season opens with visible displays of strength and endurance. How you read those displays may determine more than just this season.",
		"Males are competing nearby, and the results of the contest are clear to anyone watching. What you do with that information is up to you.",
	],
	"choices": [
		{ "label": "Choose the tournament winner",   "sublabel": "Costs 12% food · best clutch chance · high risk", "icon": "attack", "action": "strong_challenger" },
		{ "label": "Test the male's composure",      "sublabel": "Costs 7% food · good clutch chance",             "icon": "stalk",  "action": "test_patience"     },
		{ "label": "Choose the safest nearby male",  "sublabel": "Costs 4% food · modest clutch chance",            "icon": "bond",   "action": "safe_mate"          },
		{ "label": "Ignore the breeding season",     "sublabel": "No cost · risk of poor start",              "icon": "flee",   "action": "ignore"             },
	],
	"outcomes": {
		"strong_challenger": {
			"strong_success": [
				"You choose the tournament winner after watching him hold steady through the final horn lock. His fitness is clear, and the clutch begins with excellent promise.",
				"The male you select won cleanly and without excessive cost. His strength and composure are both real. The season starts at its best.",
				"You wait until the contest is decided, then choose the winner based on how he carries himself after. The clutch benefits.",
				"The strongest male in the field turns out to be genuinely fit, not just loud. You choose him, and the future clutch starts well.",
				"You pick the tournament winner with full intent, and the season reflects the quality of that choice.",
			],
			"success": [
				"You choose the tournament winner and the clutch begins with solid promise.",
				"The winning male proves capable, and the season moves forward confidently.",
				"A strong tournament result gives the future clutch a meaningful advantage.",
				"The strongest male earns the mating, and the clutch starts well.",
				"You choose well, and the season reflects the effort.",
			],
			"mixed": [
				"The tournament winner is strong but does not settle after the contest. His restlessness creates friction near the nest.",
				"You choose the strongest male, but his aggression does not end with the horn contest.",
				"Strength is there. Composure is not. The season improves, but not cleanly.",
				"The winning male is useful in one way and difficult in another. The result is mixed.",
				"The strongest choice comes with complications. The net result is moderate.",
			],
			"fail": [
				"The tournament winner turns reckless after the contest and creates instability near the nest. The clutch starts poorly.",
				"You choose raw horn strength, and the male has nothing else to offer the nesting period.",
				"The contest winner turns out to be suited only for fighting. The breeding season suffers.",
				"Strength without composure leaves the nest poorly protected and the clutch worse off.",
				"The strongest choice was not the right one. The clutch begins at a disadvantage.",
			],
		},
		"test_patience": {
			"strong_success": [
				"You lead the male through the territory and watch whether he follows your pace without pushing. He follows.",
				"His composure under your test proves deeper than his horn contest result. You accept him, and the clutch starts on excellent terms.",
				"The male who passes your patience test is calm in a way that matters more than his tournament placement.",
				"You test him long enough to see real control, not just restrained behavior on a good day. He has it.",
				"His consistency through the full test gives you real confidence. The clutch starts strongly.",
			],
			"success": [
				"He passes the composure test well enough. The season moves forward with good promise.",
				"You observe him carefully and he earns the choice. The clutch starts solidly.",
				"A composed male produces a composed beginning for the clutch.",
				"He shows real patience, and you accept him. The future clutch starts well.",
				"The test produces a reliable result and a good breeding start.",
			],
			"mixed": [
				"He holds the test for most of it, then loses patience before it is done. Acceptable but not ideal.",
				"His composure is real but uneven. The season moves forward on uncertain terms.",
				"The test reveals a male who can hold patience when it suits him. The result is middling.",
				"He passes in part. The clutch gains something, though not the most it could.",
				"An imperfect test still moves the season forward, just not at its best.",
			],
			"fail": [
				"He breaks the patience test early and becomes pushy before it is finished. The season loses its best chance.",
				"The male cannot hold composure through the test and turns difficult.",
				"Poor patience reveals poor fitness. The test was right to question him.",
				"He gives up on the test before it gives up on him. The clutch suffers.",
				"The test fails, and the season carries the cost forward.",
			],
		},
		"safe_mate": {
			"strong_success": [
				"The nearest available male turns out to carry more fitness than his unassuming manner suggested.",
				"You choose safety and the nearby male exceeds the expectation. The clutch begins better than planned.",
				"He is not the strongest in the horn contest, but he is steady and close, and the result is surprisingly good.",
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
				"He keeps the area calm and offers little beyond that.",
				"A safe season produces a modest beginning.",
			],
			"fail": [
				"The safest nearby male turns out to have less fitness than his quiet manner suggested. The clutch starts poorly.",
				"You choose proximity over quality, and the result confirms the mistake.",
				"He keeps the territory undisturbed and contributes almost nothing to the clutch.",
				"The safe option offers no meaningful benefit. The future clutch starts below its potential.",
				"Safety and fitness did not come together this season.",
			],
		},
		"ignore": {
			"strong_success": [
				"You give the season little attention, and a passing male appears at the right moment anyway.",
				"You save your energy and the season still manages a decent result. Luck helped.",
				"A suitable male crosses your path without you seeking one. The season continues.",
				"You ignore the horn contest noise and a capable male still appears.",
				"The chance was weaker for your lack of effort, but it did not disappear entirely.",
			],
			"success": [
				"You give the season little effort, but a male still finds you at the right time.",
				"You ignore most of the tournament, and the season moves forward anyway.",
				"A passing male proves good enough despite your limited engagement.",
				"The chance is modest, but not gone. The season continues.",
				"You save your strength, and luck fills part of the gap.",
			],
			"mixed": [
				"You ignore the season too long, and the best chances pass before you take them.",
				"The horn contests end and the males disperse before you engage.",
				"You save your energy, but the future clutch gains little from this season.",
				"Breeding season moves around you while you stay apart from it.",
				"The opportunity weakens with every day you do not engage it.",
			],
			"fail": [
				"Ignoring the season leaves the timing poor and the clutch starting from behind.",
				"Too many signs pass unanswered, and the season turns thin.",
				"Your distance from the season weakens the chance of a strong beginning.",
				"The plain goes quiet again. The missed effort carries a real cost.",
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
	return TRIC_FEMALE_EVENT
