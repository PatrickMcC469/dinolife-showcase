extends "res://scripts/dinos/base_dino_mate.gd"

# Argentinosaurus — mating season events (Pattern B: tournament_combat + effort chain)
#
# ── TOURNAMENT EVENT (auto-fires at mating season start) ─────────────────────
# 2 choices: Enter the tournament / Step back
#   Enter → fight roll (win_chance ~0.40 + luck)
#       Win         → breed_effort_pending = true; effort event fires same turn
#       Loss        → health -0.10, no mate
#       Loss+injury → health -0.10, random Argentinosaurus injury, no mate
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
# "Neck Strain"        → strength -0.08, 2 turns
# "Ground Impact"      → defense  -0.08, 2 turns
# "Heavy Step Bruise"  → speed    -0.08, 2 turns

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

const ARGE_TOURNAMENT_EVENT: Dictionary = {
	"intro": [
		"Mating season brings males into neck-to-neck contests across the wide plain. The male who holds his ground through the weight exchange earns first right to mate.",
		"Rival males are already circling and pressing along the herd's edge. You can enter the size contest or hold back and let the season pass.",
		"The tournament is underway. Males measure each other in slow, heavy exchanges that shake the ground. The winners stay. The losers move off.",
		"Breeding season opens with neck wrestling and ground-shaking displays of size and endurance. The largest and most durable male earns the claim.",
		"Males are moving into position at the center of the herd's range. The weight contest is starting and you have the size and neck to compete.",
	],
	"choices": [
		{ "label": "Enter the tournament",    "sublabel": "Compete for the right to mate", "icon": "attack", "action": "enter"     },
		{ "label": "Step back this year",     "sublabel": "Save your strength",            "icon": "flee",   "action": "step_back" },
	],
	"outcomes": {
		"step_back": [
			"You watch the neck contest from the edge and let the season pass to the males who entered.",
			"You step back from the tournament and move through the season without mating.",
			"The weight exchange finishes without you. You save yourself and miss the breeding claim.",
			"You read the competition and decide this year the contest is not worth entering.",
			"You let the other males press and hold back from the field.",
		],
		"enter": {
			"win": [
				"You lean your full mass into the rival's neck and hold until he gives ground. The season is yours.",
				"The weight contest goes to the male who endures longest. You endure longer, and the field clears.",
				"You press the rival back across the plain in slow, grinding steps until he turns away. The tournament is yours.",
				"You win the neck exchange with patience and mass. The other males give ground, and you hold the claim.",
				"Your size and your endurance win the tournament. You earn the right to mate this season.",
			],
			"loss": [
				"The rival's mass and leverage outlast yours, and you are pressed from the contest.",
				"The weight exchange ends with you on the losing side. The breeding claim goes to a heavier male.",
				"You compete through the full contest, but the outcome turns against you.",
				"You give the contest everything and fall short. No mate this season.",
				"The field is stronger than you this time. You exit the tournament without a claim.",
			],
			"loss_injured": [
				"The rival's neck catches yours at a bad angle and something strains deep in the muscle. You pull from the contest hurt.",
				"You lose your footing in a hard exchange and come down wrong. You leave the tournament with a minor injury.",
				"The weight contest ends badly. You are pressed to the ground before you can recover cleanly.",
				"The contest costs you more than the season. You carry a fresh strain from the weight exchange.",
				"You are pushed from the contest with a knock that slows the days that follow.",
			],
		},
	},
	"injuries": [
		{ "name": "Neck Strain",       "stat": "strength", "amount": -0.08, "turns": 2 },
		{ "name": "Ground Impact",     "stat": "defense",  "amount": -0.08, "turns": 2 },
		{ "name": "Heavy Step Bruise", "stat": "speed",    "amount": -0.08, "turns": 2 },
	],
}

func get_tournament_event() -> Dictionary:
	return ARGE_TOURNAMENT_EVENT


# ── EFFORT EVENT ──────────────────────────────────────────────────────────────

const ARGE_EFFORT_EVENT: Dictionary = {
	"intro": [
		"You won the tournament and earned the right to mate. The female is preparing the nest, and what you offer from here may shape the clutch's beginning.",
		"The weight contest is behind you. The female is ready and the nesting period is starting. What you invest now may determine more than this season.",
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
				"You remain close throughout the nesting period. Your sheer presence keeps most threats away without effort. The clutch begins with excellent promise.",
				"Your full attention to the nest gives the female everything she needs. The season starts at its best.",
				"You give the nesting period everything you have, and the clutch reflects the investment.",
				"Full presence pays off. The nesting completes in ideal conditions, and the future hatching benefits.",
				"You sacrifice comfort and range for the nest, and the result is a clutch that starts strongly.",
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
				"Your support is strong, but a brief disturbance near the nest costs some of the advantage.",
				"You do everything right, and the result is only moderate. Luck was against you.",
				"Full effort leads to a middling outcome. The season could have gone better.",
				"You invest fully and receive a mixed result.",
			],
			"fail": [
				"Your constant presence near the nesting ground draws more attention than it discourages. The clutch's start suffers.",
				"Despite your best effort, the nesting period goes poorly. The future clutch begins at a disadvantage.",
				"Full investment produces a disappointing result. The season starts poorly.",
				"Your mass near the nest becomes a problem rather than a protection.",
				"Full support backfires. The clutch begins in worse condition than expected.",
			],
		},
		"guard_path": {
			"strong_success": [
				"You station yourself on the approaches to the nesting ground. Nothing large enough to matter comes close. The clutch begins in excellent condition.",
				"Guarding the path makes a real difference at this scale. The female works without interruption, and the nest starts strongly.",
				"Your patrol of the nesting approaches keeps the area secure throughout. The clutch starts at its best.",
				"Steady perimeter work at your size is worth more than most guards. The clutch begins strongly.",
				"You hold the approaches through the full nesting period and the result reflects it.",
			],
			"success": [
				"Your guard work keeps the nesting area safe. The season produces a good start.",
				"You hold position near the approaches and the nest stays undisturbed. The clutch begins well.",
				"Guarding the path contributes meaningfully to the clutch's starting condition.",
				"You hold the perimeter and the nesting proceeds cleanly.",
				"Steady guard effort gives the future clutch a solid beginning.",
			],
			"mixed": [
				"You guard the approaches but cannot account for everything. The result is decent but imperfect.",
				"A brief disturbance near the nest costs the clutch some of its early advantage.",
				"Your guarding is effective most of the time. The season's result reflects partial success.",
				"The perimeter holds mostly. The clutch starts with modest improvement.",
				"You guard well enough, and the result is neither strong nor weak.",
			],
			"fail": [
				"Something moves past your guard at the wrong moment and disturbs the nest. The clutch begins at a disadvantage.",
				"Your patrol misses the critical moment, and the cost follows.",
				"Guarding the approaches is not enough this season. The clutch suffers.",
				"A threat finds the gap in your coverage, and the nesting period ends badly.",
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
				"Offering too little leaves the nest vulnerable to problems that compound.",
				"The modest investment does not cover what the season needs, and the clutch suffers.",
				"A small effort is not enough when the season is difficult.",
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
				"You give nothing to the nesting and the season reflects that clearly. The clutch begins at a real disadvantage.",
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
	return ARGE_EFFORT_EVENT


# ── FEMALE EVENT ──────────────────────────────────────────────────────────────

const ARGE_FEMALE_EVENT: Dictionary = {
	"intro": [
		"Mating season brings males into slow, heavy contests along the herd's range. The weight exchanges carry across the plain, and your choice may shape the clutch.",
		"The tournament is underway nearby. Males press and hold in neck contests that last for long, grinding minutes. The outcome is visible from a distance.",
		"The ground shakes with the movement of competing males. The season is underway, and there is time to observe before you decide.",
		"Breeding season opens with size contests that can be read from far off. The male who wins without excessive cost is worth choosing.",
		"Rival males are pressing along the herd's edge. You can choose the winner, test someone more carefully, or let the season pass at a distance.",
		"The mating season opens with visible, physical competition. What you read in those contests may tell you more than any display.",
		"Males are competing nearby, and the results are obvious. How much effort you put into your own choice may decide the quality of the season.",
	],
	"choices": [
		{ "label": "Choose the tournament winner",   "sublabel": "Costs 12% food · best clutch chance · high risk", "icon": "attack", "action": "strong_challenger" },
		{ "label": "Test the male's endurance",      "sublabel": "Costs 7% food · good clutch chance",             "icon": "stalk",  "action": "test_patience"     },
		{ "label": "Choose the safest nearby male",  "sublabel": "Costs 4% food · modest clutch chance",            "icon": "bond",   "action": "safe_mate"          },
		{ "label": "Ignore the breeding season",     "sublabel": "No cost · risk of poor start",              "icon": "flee",   "action": "ignore"             },
	],
	"outcomes": {
		"strong_challenger": {
			"strong_success": [
				"You choose the tournament winner after watching him hold through the final weight exchange without visible cost. The clutch begins with excellent promise.",
				"The male you select won clearly and recovered quickly. His size and endurance are both real. The season starts at its best.",
				"You wait for the contest to finish and choose the winner based on how he looks after. The clutch benefits from the patience.",
				"The largest male in the field turns out to be genuinely durable, not just heavy. You choose him, and the future clutch starts well.",
				"You pick the tournament winner with full intent, and the season reflects the quality of that choice.",
			],
			"success": [
				"You choose the tournament winner and the clutch begins with solid promise.",
				"The winning male proves capable, and the season moves forward confidently.",
				"A strong tournament result gives the future clutch a meaningful advantage.",
				"The largest male earns the mating, and the clutch starts well.",
				"You choose well, and the season reflects the effort.",
			],
			"mixed": [
				"The tournament winner is large but does not settle after the contest. His movement near the nest creates friction.",
				"You choose the strongest male, but his restlessness does not end when the contest does.",
				"Size is there. Steadiness is not. The season improves, but not cleanly.",
				"The winning male is useful in one way and difficult in another. The result is mixed.",
				"The strongest choice comes with complications. The net result is moderate.",
			],
			"fail": [
				"The tournament winner becomes disruptive after the contest and draws attention to the nesting area. The clutch starts poorly.",
				"You choose raw size, and the male has nothing else to offer the nesting period.",
				"The contest winner turns out to be suited only for contests. The breeding season suffers.",
				"Size without steadiness means the nesting area stays unsettled. The clutch starts badly.",
				"The strongest choice was not the right one. The clutch begins at a disadvantage.",
			],
		},
		"test_patience": {
			"strong_success": [
				"You move at your own pace near the male and watch whether he matches it or pushes past it. He matches it, steadily.",
				"His endurance through your test proves deeper than his contest result. You accept him, and the clutch starts on excellent terms.",
				"The male who passes your test is calm in a way that matters more than his tournament placement.",
				"You test him long enough to see genuine endurance, not just composure on a calm day. He has it.",
				"His consistency through the full test gives you real confidence. The clutch starts strongly.",
			],
			"success": [
				"He passes the endurance test well enough. The season moves forward with good promise.",
				"You observe him carefully and he earns the choice. The clutch starts solidly.",
				"A measured male produces a measured beginning for the clutch.",
				"He shows real patience, and you accept him. The future clutch starts well.",
				"The test produces a reliable result and a good breeding start.",
			],
			"mixed": [
				"He holds the test for most of it, then loses patience near the end. Acceptable but not ideal.",
				"His endurance is real but uneven. The season moves forward on uncertain terms.",
				"The test reveals a male who can hold patience when he tries. The result is middling.",
				"He passes in part. The clutch gains something, though not the most it could.",
				"An imperfect test still moves the season forward, just not at its best.",
			],
			"fail": [
				"He breaks the test early and becomes too aggressive before it is finished. The season loses its best chance.",
				"The male cannot hold endurance through the test and turns restless.",
				"Poor patience reveals poor fitness. The test was right to question him.",
				"He gives up on the test before it gives up on him. The clutch suffers.",
				"The test fails, and the season carries the cost forward.",
			],
		},
		"safe_mate": {
			"strong_success": [
				"The nearest available male turns out to carry more durability than his quiet presence suggested.",
				"You choose safety and the nearby male exceeds the expectation. The clutch begins better than planned.",
				"He is not the largest in the field, but he is steady and close, and the result is surprisingly good.",
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
				"The nearby male is stable but not especially large or durable. The clutch gains stability more than strength.",
				"Safety serves the season, but the clutch's potential is limited.",
				"You choose caution, and the result is exactly as cautious as the choice.",
				"He keeps the area calm and offers little beyond that.",
				"A safe season produces a modest beginning.",
			],
			"fail": [
				"The safest nearby male turns out to have less fitness than his presence suggested. The clutch starts poorly.",
				"You choose proximity over quality, and the result confirms the mistake.",
				"He keeps the territory undisturbed and contributes almost nothing to the clutch.",
				"The safe option offers no meaningful benefit. The future clutch starts below its potential.",
				"Safety and fitness did not come together this season.",
			],
		},
		"ignore": {
			"strong_success": [
				"You give the season little attention, and a suitable male appears at the right moment without you seeking one.",
				"You save your energy and the season still manages a decent result. Luck helped.",
				"A capable male crosses your path without you seeking one. The season continues.",
				"You ignore the contest noise and a reasonable male still appears.",
				"The chance was weaker for your lack of effort, but it did not disappear entirely.",
			],
			"success": [
				"You give the season little effort, but a male still finds you at the right time.",
				"You ignore most of the weight contests, and the season moves forward anyway.",
				"A passing male proves good enough despite your limited engagement.",
				"The chance is modest, but not gone. The season continues.",
				"You save your strength, and luck fills part of the gap.",
			],
			"mixed": [
				"You ignore the season too long, and the best chances pass before you take them.",
				"The contests end and the males disperse before you engage.",
				"You save your energy, but the future clutch gains little from this season.",
				"Breeding season moves around you while you stay apart from it.",
				"The opportunity weakens with every day you do not engage it.",
			],
			"fail": [
				"Ignoring the season leaves the timing poor and the clutch starting from behind.",
				"Too many signs pass unanswered, and the season turns thin.",
				"Your distance from the season weakens the chance of a strong beginning.",
				"The plain grows quiet again. The missed effort carries a real cost.",
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
	return ARGE_FEMALE_EVENT
