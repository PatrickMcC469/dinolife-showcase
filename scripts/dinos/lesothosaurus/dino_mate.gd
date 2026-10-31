extends "res://scripts/dinos/base_dino_mate.gd"

# Lesothosaurus — mating season events (Pattern B: tournament_speed + effort chain)
#
# ── TOURNAMENT EVENT (auto-fires at mating season start) ─────────────────────
# 2 choices: Enter the race / Step back
#   Enter → fight roll (win_chance ~0.40 + luck)
#       Win         → breed_effort_pending = true; effort event fires same turn
#       Loss        → health -0.10, no mate
#       Loss+injury → health -0.10, random Lesothosaurus injury, no mate
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
# "Twisted Tendon"  → speed    -0.08, 2 turns
# "Sharp Turn Cut"  → defense  -0.08, 2 turns
# "Sprint Strain"   → strength -0.08, 2 turns

# ── Legacy flat data ──────────────────────────────────────────────────────────
const MATE_DATA: Dictionary = {
	"seek_male":                 [],
	"seek_female":               [],
	"speed_sprint_won":          [],
	"speed_sprint_close":        [],
	"speed_sprint_overexerted":  [],
	"speed_pace_won":            [],
	"speed_pace_lost":           [],
	"speed_pass":                [],
	"speed_f_led":               [],
	"speed_f_chose":             [],
	"success":                   [],
	"no_mate":                   [],
}

func get_mate_data() -> Dictionary:
	return MATE_DATA


# ── TOURNAMENT EVENT ──────────────────────────────────────────────────────────

const LESO_TOURNAMENT_EVENT: Dictionary = {
	"intro": [
		"Mating season opens with a race. Males gather at the edge of the open plain and the fastest among them earns first right to mate.",
		"The breeding race draws males from across the territory. You can enter and push for the lead, or hold back and save yourself.",
		"The sprint contest is underway at the far end of the plain. The males who finish first will have the strongest claim this season.",
		"The race begins with a burst of movement and dust. You can enter and test your speed against the field, or let the season pass.",
		"Males are already jostling at the start of the breeding race. The fastest runner earns the season, and you have the speed to try.",
	],
	"choices": [
		{ "label": "Enter the race",      "sublabel": "Compete for the right to mate", "icon": "attack", "action": "enter"     },
		{ "label": "Step back this year", "sublabel": "Save your strength",            "icon": "flee",   "action": "step_back" },
	],
	"outcomes": {
		"step_back": [
			"You watch the race from the edge of the plain and let the season belong to faster males.",
			"You hold back from the contest and move through the season without mating.",
			"The race finishes without you. You save your legs and miss the breeding chance.",
			"You step away from the start line and let the others decide the season.",
			"You read the field and decide the cost of the race is higher than the prize.",
		],
		"enter": {
			"win": [
				"You push clear of the field in the final stretch and take the lead. The race is yours, and so is the season.",
				"Your pace holds longer than theirs, and you cross the finish with enough distance to make the win clear.",
				"The other males fall behind as you find your best stride. You win the race and earn the right to mate.",
				"You stay tight with the leaders through the middle stretch and break ahead near the end. First place is yours.",
				"You finish the race first, and your speed carries the season's claim with it.",
			],
			"loss": [
				"You give the race your best effort and fall short of the leaders. The season goes to a faster male.",
				"Your pace holds for most of the race, but the leaders separate before the end. No mate this season.",
				"You finish the race but not at the front. The breeding claim goes elsewhere.",
				"You push hard through the plain and come up short. The season belongs to the winner.",
				"The race ends without you in the first position. You tried and the season passes anyway.",
			],
			"loss_injured": [
				"You push too hard through a tight turn and feel something go wrong in your leg. You limp from the race without a mate.",
				"A stumble mid-race costs you both your position and your condition. You finish hurt and out of contention.",
				"You cannot hold the pace you need, and the effort to try leaves you with a minor injury.",
				"The race ends badly. You fall behind and take a knock that slows the following days.",
				"You push to keep pace with the leaders and pay for it with a strain. No mate and no easy recovery.",
			],
		},
	},
	"injuries": [
		{ "name": "Twisted Tendon", "stat": "speed",    "amount": -0.08, "turns": 2 },
		{ "name": "Sharp Turn Cut", "stat": "defense",  "amount": -0.08, "turns": 2 },
		{ "name": "Sprint Strain",  "stat": "strength", "amount": -0.08, "turns": 2 },
	],
}

func get_tournament_event() -> Dictionary:
	return LESO_TOURNAMENT_EVENT


# ── EFFORT EVENT ──────────────────────────────────────────────────────────────

const LESO_EFFORT_EVENT: Dictionary = {
	"intro": [
		"You won the race and earned the right to mate. Now the female is preparing the nest, and what you do next may shape the clutch's beginning.",
		"The race is behind you, and the female is ready. How you support the nesting from here will influence what the clutch starts with.",
		"You earned this season with your speed. The next step is how much of yourself you give to making the nesting work.",
		"The breeding season continues after the race. The female is present, and the choice of how much you invest is yours.",
		"You won, and the season is moving forward. What you offer now may be the difference between a strong start and a modest one.",
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
				"You stay close to the female through the entire nesting preparation, alert and present. The clutch begins with excellent promise.",
				"Your full attention to the nest keeps the area quiet and gives the female everything she needs. The season starts strongly.",
				"You give the nesting period every resource you have, and it shows in the clutch's condition.",
				"Staying fully present pays off. The female completes the nest in ideal conditions, and the future hatching benefits.",
				"You sacrifice your own comfort for the nest, and the result is a clutch that starts at its best.",
			],
			"success": [
				"Your full effort supports the nesting well. The clutch begins with solid promise.",
				"You stay close and help throughout. The season produces a good beginning.",
				"Full support gives the nest a strong start.",
				"You give everything, and the clutch reflects it.",
				"Your presence and effort carry the nesting period forward cleanly.",
			],
			"mixed": [
				"You give full effort, but the nesting encounters minor complications that reduce the benefit.",
				"Your support is strong, but the area draws brief predator attention that unsettles the nest.",
				"You do everything right, and the result is only moderate. Luck was not on your side.",
				"Full effort produces a middling outcome. The season could have gone better.",
				"You give the nest everything and receive a mixed result.",
			],
			"fail": [
				"Your full presence near the nest draws the wrong kind of attention, and the clutch's start suffers.",
				"Despite your best effort, the nesting period goes poorly. The future clutch begins at a disadvantage.",
				"You invest fully and the result is still disappointing. The season starts poorly.",
				"Your presence near the nest becomes a liability, and the effort costs more than it gives.",
				"Full support backfires. The clutch begins in worse condition than expected.",
			],
		},
		"guard_path": {
			"strong_success": [
				"You take position on the approaches to the nesting area and keep threats away. The clutch begins in excellent condition.",
				"Guarding the path keeps the nesting ground secure and gives the female the space she needs.",
				"Your patrol of the nesting approaches makes a real difference. The clutch starts well.",
				"You hold the perimeter throughout nesting, and the result is a strong beginning for the clutch.",
				"Steady guarding pays off with a clutch that starts at its best.",
			],
			"success": [
				"Your guard work keeps the nesting area safe. The season produces a good start.",
				"You patrol the approaches and the nest stays undisturbed. The clutch begins well.",
				"Guarding the path contributes meaningfully to the clutch's starting condition.",
				"You hold the perimeter, and the nesting proceeds cleanly.",
				"Steady guard effort gives the future clutch a solid beginning.",
			],
			"mixed": [
				"You guard the path but cannot keep every threat out. The nest is mostly secure, and the result is decent.",
				"A brief intrusion near the nesting area costs the clutch some of its early advantage.",
				"Your guarding is effective most of the time. The season's result reflects partial success.",
				"The perimeter holds for the most part. The clutch starts with modest improvement.",
				"You guard well enough, and the result is neither strong nor weak.",
			],
			"fail": [
				"A threat gets past your guard and disturbs the nest. The clutch begins at a disadvantage.",
				"Your patrol of the nesting approaches misses the right moment, and the cost follows.",
				"Guarding the path is not enough this season. The clutch suffers from a poorly protected nest.",
				"Something breaks through the perimeter, and the nesting period ends on bad terms.",
				"Your guard work fails to protect the nest. The future clutch starts poorly.",
			],
		},
		"offer": {
			"strong_success": [
				"You offer limited help, and the female uses it more effectively than you expected. The clutch starts well.",
				"A modest contribution lands at the right moment and improves the nesting more than your effort cost.",
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
				"Modest effort gives a modest result in either direction.",
			],
			"fail": [
				"Your limited effort is not enough to help the nesting succeed. The clutch begins poorly.",
				"Offering too little leaves the nest vulnerable to small problems that compound.",
				"The modest investment does not cover the season's needs, and the clutch suffers.",
				"A small effort in a difficult season is worse than no effort at a simpler time.",
				"Your limited support fails to make a difference, and the future clutch starts at a disadvantage.",
			],
		},
		"let": {
			"strong_success": [
				"You step back entirely, and the female handles the nesting well enough on her own. A lucky outcome.",
				"You give nothing and the season still manages a decent result. The female is more capable than her situation suggested.",
				"Stepping back costs you nothing, and luck fills the gap with a reasonable start.",
				"You let the female manage, and she does. The clutch begins with modest but real potential.",
				"The season continues without your involvement, and the result surprises you.",
			],
			"success": [
				"You leave the nesting entirely to the female, and it mostly works out.",
				"No involvement from you, and a passable start for the clutch.",
				"The female handles the nest well enough without your help.",
				"You step back and the season moves forward on its own.",
				"Letting go of the nesting costs you nothing and gives you a thin result.",
			],
			"mixed": [
				"You step back, and the nesting suffers somewhat without any support.",
				"No effort means no contribution. The clutch starts without much going for it.",
				"Letting the female handle everything leads to a mediocre start at best.",
				"The season passes without your involvement, and the result shows it.",
				"A weak result follows from no effort. The clutch's potential is limited.",
			],
			"fail": [
				"You give nothing to the nesting and the season reflects that. The clutch begins at a real disadvantage.",
				"Stepping back entirely leaves the nest poorly supported through a difficult period.",
				"No involvement from you means no buffer when things go wrong. The future clutch starts poorly.",
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
	return LESO_EFFORT_EVENT


# ── FEMALE EVENT ──────────────────────────────────────────────────────────────

const LESO_FEMALE_EVENT: Dictionary = {
	"intro": [
		"Mating season brings males sprinting across the open plain. The fastest ones are already circling, and your choice may shape the clutch that follows.",
		"The breeding race ends, and now the strongest runners move through your range. What you choose may decide more than just this season.",
		"The males that won the sprint contest are now available, and so are the ones who lost. Your instinct knows the difference.",
		"Speed is what the race measures, but fitness is what you are choosing. The two overlap, but not always.",
		"The mating season opens with open-ground races and the sound of small feet on dry dirt. The field narrows to what you are willing to pick.",
		"Males have been running circuits at the edge of the territory for days. The season is ready, and so are you.",
		"Breeding season fills the open plain with movement. You watch it for a while before deciding how much effort to put in.",
	],
	"choices": [
		{ "label": "Choose the fastest racer",    "sublabel": "Costs 12% food · best clutch chance · high risk", "icon": "attack", "action": "strong_challenger" },
		{ "label": "Test the male's endurance",   "sublabel": "Costs 7% food · good clutch chance",             "icon": "stalk",  "action": "test_patience"     },
		{ "label": "Choose the safest nearby male", "sublabel": "Costs 4% food · modest clutch chance",          "icon": "bond",   "action": "safe_mate"          },
		{ "label": "Ignore the breeding season",  "sublabel": "No cost · risk of poor start",              "icon": "flee",   "action": "ignore"             },
	],
	"outcomes": {
		"strong_challenger": {
			"strong_success": [
				"You choose the male that won the race by the clearest margin. His fitness is real and the clutch begins with strong promise.",
				"The fastest male is also composed. You choose him after watching him move through the post-race period without panic.",
				"You wait for the best racer to prove himself beyond the finish line, and he does. The clutch begins well.",
				"The winner of the sprint contest moves with purpose and no wasted energy. You choose him, and the season starts at its best.",
				"You pick the male whose speed comes from genuine fitness, not just panic. The clutch benefits from the distinction.",
			],
			"success": [
				"You choose the fastest male and the clutch begins with solid promise.",
				"The racer you select proves capable, and the season moves forward confidently.",
				"A fast, capable male gives the future clutch a meaningful advantage.",
				"The fastest male earns the mating, and the clutch starts well.",
				"You choose speed, and it pays off for the season.",
			],
			"mixed": [
				"The fastest male is also the most restless. His presence near the nest creates some instability.",
				"You choose the race winner, but his energy does not settle after the contest. The clutch gains and loses in turn.",
				"Speed is there. Composure is not. The season improves, but not cleanly.",
				"The fastest male is difficult to keep in the territory after the race. The clutch benefits some.",
				"The race winner proves useful in one way and problematic in another. The result is mixed.",
			],
			"fail": [
				"The fastest male is completely unable to settle after winning. His restlessness costs the clutch its best start.",
				"You choose raw speed, and the male has nothing else to offer the nest.",
				"The race winner turns out to be suited only for racing. The breeding season suffers.",
				"Speed without endurance means he is gone before the nesting period is done. The clutch starts poorly.",
				"The fastest choice was not the right one. The clutch begins at a disadvantage.",
			],
		},
		"test_patience": {
			"strong_success": [
				"You lead the male through the open ground for several passes and watch whether he keeps pace or pushes too hard. He keeps pace.",
				"His endurance proves deeper than his sprint speed. You test him at length and he earns the season with control.",
				"The male who passes your endurance test is steady in the way that matters most. The clutch benefits.",
				"You push the test long enough to see real patience, not just good behavior. He has both.",
				"His consistency across the full test gives you confidence in the choice. The clutch starts on excellent terms.",
			],
			"success": [
				"He passes the endurance test well enough. The season moves forward with good promise.",
				"You test his patience across the open ground and he earns it. The clutch starts solidly.",
				"Steady behavior through the test produces a steady beginning for the clutch.",
				"He shows real endurance, and you accept him. The future clutch starts well.",
				"The test produces a reliable result and a good breeding start.",
			],
			"mixed": [
				"He holds the test for most of it, then breaks near the end. Good enough, but not ideal.",
				"His endurance is present but inconsistent. The season moves forward on uncertain terms.",
				"The test reveals a male who can manage patience when he tries. The result is middling.",
				"He passes in part. The clutch gains something from the test, though not the most it could.",
				"An imperfect test result still moves the season forward, if not optimally.",
			],
			"fail": [
				"He breaks the endurance test early and becomes erratic. The season loses its best chance.",
				"The male cannot hold pace through the test and turns pushy before it finishes.",
				"Poor endurance reveals poor fitness. The test was right to doubt him.",
				"He gives up on the test before it gives up on him. The clutch's start suffers.",
				"The test fails, and the season carries the cost forward into the future.",
			],
		},
		"safe_mate": {
			"strong_success": [
				"The closest available male turns out to carry more fitness than his quiet presence suggested.",
				"You choose safety and the nearby male exceeds the expectation. The clutch begins better than planned.",
				"He is not the fastest, but he is steady and close, and the result is a surprisingly good start.",
				"Choosing the familiar nearby male pays off with a clutch that starts strongly.",
				"The safe option turns out to be the best one this season.",
			],
			"success": [
				"You choose a calm, nearby male. The clutch begins with modest but real promise.",
				"He is close and acceptable, and the season moves forward without complication.",
				"Safety gives the nest a stable beginning and the clutch a decent start.",
				"You accept the nearby male and the future clutch starts on adequate terms.",
				"The season moves forward cleanly with the safest available choice.",
			],
			"mixed": [
				"The nearby male is stable but not especially fit. The clutch gains safety more than strength.",
				"Safety serves the season, but the clutch's potential is limited.",
				"You choose caution, and the result is exactly what caution earns.",
				"He keeps the area quiet and offers little beyond that. The future is thin.",
				"A safe season produces a modest beginning.",
			],
			"fail": [
				"The safest nearby male turns out to have less fitness than he appeared. The clutch starts poorly.",
				"You choose proximity, and the result confirms that proximity was the wrong measure.",
				"He keeps the territory stable and contributes almost nothing to the clutch.",
				"The safe option offers no meaningful benefit. The future clutch starts below its potential.",
				"Safety and fitness did not come together this season. The clutch reflects the gap.",
			],
		},
		"ignore": {
			"strong_success": [
				"You give the season little attention, and luck delivers a passing male at the right moment.",
				"You save your energy and the season still manages a decent result. A small chance held.",
				"A suitable male crosses your path without you seeking one. The season continues.",
				"You ignore the contest noise and a capable male still appears.",
				"The chance was weaker for your lack of effort, but it did not disappear.",
			],
			"success": [
				"You give the season little effort, but a male still finds you at the right time.",
				"You ignore most of the race results, and the season moves forward anyway.",
				"A passing male proves good enough despite your limited engagement.",
				"The chance is modest, but not gone. The season continues.",
				"You save your strength, and luck fills part of the gap.",
			],
			"mixed": [
				"You ignore the season too long, and the best chances fade before you take them.",
				"The race finishes and the males disperse before you engage the season.",
				"You save your energy, but the future clutch gains little from this season.",
				"Breeding season moves around you while you remain separate from it.",
				"The opportunity weakens with every day you do not engage it.",
			],
			"fail": [
				"Ignoring the season leaves the timing poor and the clutch starting from behind.",
				"You let the race results pass unanswered, and the season turns thin.",
				"Your distance from the season weakens the chance of a strong beginning.",
				"The plains go quiet again. The missed effort carries a real cost.",
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
	return LESO_FEMALE_EVENT
