extends "res://scripts/dinos/base_dino_mate.gd"

# Ankylosaurus — mating season events (Pattern A: challenge/leave)
#
# ── MALE EVENT ────────────────────────────────────────────────────────────────
# Auto-fires at mating season start.
# 2 choices: Challenge rival / Leave
#   Challenge → fight roll (win_chance ~0.45 + luck)
#       Win        → has_mate, pending_egg, male_mating_streak++, check streak boost
#       Loss       → health -0.12, streak resets to 0
#       Loss+injury → health -0.12, random Ankylosaurus injury, streak resets to 0
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
# "Club Glance"    → strength -0.08, 2 turns
# "Armor Graze"    → defense  -0.08, 2 turns
# "Heavy Stumble"  → speed    -0.08, 2 turns

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

const ANKYL_MALE_EVENT: Dictionary = {
	"intro": [
		"Breeding season brings rival males through the lowlands. You find fresh tracks leading toward a receptive female, but another armored male is already there.",
		"The season shifts the territory. You follow a female's scent along a scrub trail until a rival male turns to face you, his club tail raised.",
		"You pick up the trail of a female moving along the flat ground near the forest edge. Before you can close in, a rival male settles across the path.",
		"A female's signs are clear in the mud and broken brush ahead. A rival male has been reading them too, and he does not intend to move.",
		"The season builds slowly through the lowlands, and you track a female to a wide clearing. A rival male stands near the center, already alert.",
		"You find the scent trail and follow it until the path narrows between low brush. A rival male stands in the gap, watching your approach.",
		"Mating season brings heavy movement through the territory. You find a female's signs and a rival male at the same time.",
	],
	"choices": [
		{ "label": "Challenge the rival male", "sublabel": "Win the right to mate", "icon": "attack", "action": "challenge" },
		{ "label": "Leave the pair alone",     "sublabel": "Save your strength",    "icon": "flee",   "action": "leave"     },
	],
	"outcomes": {
		"leave": [
			"You read the rival's armor and club and decide the cost of the fight outweighs the prize.",
			"The female's scent is strong, but the rival's posture is stronger. You step back from the clearing.",
			"You lower your head and back away from the trail. The season belongs to another male.",
			"You recognize the rival as a genuine threat and leave before the club decides the matter.",
			"The fight would cost too much. You turn from the trail and let the rival hold the season.",
			"You withdraw quietly before the contest begins and move back through the lowlands alone.",
			"This season has a better claim than yours. You save your strength and walk away.",
		],
		"challenge": {
			"win": [
				"You sweep your club into the rival's flank and force him off the trail. He retreats into the brush, and the season is yours.",
				"The contest turns hard and slow, but your endurance and armor outlast his nerve. The rival steps away from the clearing.",
				"Your club catches the rival at the right angle and drives him back. He does not return, and the female remains.",
				"You press the rival with your armored bulk until he gives ground and retreats into the lowlands.",
				"The fight is short and decided by your tail. The rival backs off, and you take the claim.",
				"Your club swing connects cleanly, and the rival decides the fight is not worth finishing.",
				"You drive the rival out of the clearing with patient, armored force. The season opens.",
			],
			"loss": [
				"The rival's club catches you before you can swing yours, and you retreat from the clearing.",
				"You lose the contest before your footing can give you the advantage. The rival keeps the female.",
				"He drives you back from the trail with heavier strikes and harder armor than you anticipated.",
				"Your challenge fails. The rival holds the clearing, and you move back through the lowlands alone.",
				"The other male's club wins the contest, and you pull away before the damage gets worse.",
				"You could not hold the ground. The rival keeps his claim and the season.",
				"The fight ends with you retreating through the brush, without a mate and without the season.",
			],
			"loss_injured": [
				"The rival's club connects before you can disengage. You leave the trail with a fresh injury and no claim.",
				"He catches your flank before you can turn. You escape, but the wound slows your next several days.",
				"The fight goes against you and you pull clear too late. You survive but carry the cost of the season.",
				"A clean hit from the rival's tail catches you near the end of the fight. You retreat, hurt.",
				"You escape the contest alive but not intact. The injury will linger, and the season is gone.",
				"The rival's club leaves you sore and beaten. You pull away from the clearing carrying both.",
				"Pain follows you from the clearing as the rival holds his claim over the lowland trail.",
			],
		},
	},
	"streak_flavor": [
		"Your armor and your record give you an edge before the fight even starts.",
		"The territory has seen your victories before, and you carry them into this season.",
		"Another successful mating season confirms the pattern. Your bloodline is proving itself.",
		"Consecutive wins give the contest a familiar feeling. You have done this before.",
		"Your streak follows you into the clearing, and the rival can sense the weight of it.",
	],
	"injuries": [
		{ "name": "Club Glance",   "stat": "strength", "amount": -0.08, "turns": 2 },
		{ "name": "Armor Graze",   "stat": "defense",  "amount": -0.08, "turns": 2 },
		{ "name": "Heavy Stumble", "stat": "speed",    "amount": -0.08, "turns": 2 },
	],
}

func get_male_event() -> Dictionary:
	return ANKYL_MALE_EVENT


# ── FEMALE EVENT ──────────────────────────────────────────────────────────────

const ANKYL_FEMALE_EVENT: Dictionary = {
	"intro": [
		"Breeding season moves across the lowlands. Male calls and club impacts carry through the scrub from rival contests nearby.",
		"The season brings armored males through your range. Some are heavy and careful. Some are heavy and clumsy.",
		"You can hear rival males contesting somewhere in the scrub. The season is underway, and your choice may shape the clutch that follows.",
		"Heavy footfalls and the sound of armor plates signal the start of breeding season. What you choose now may matter past this season.",
		"Males have been circling the territory for days. Some are large enough to be worth choosing. Some are large enough to be a problem.",
		"The lowlands fill with breeding-season movement, and you watch it without rushing. The right choice is worth more than the fast one.",
		"Mating season opens with the sound of rival contests in the brush. You have time to observe before you decide.",
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
				"You wait for the winner of the nearest contest, and the male who emerges is exactly what you were reading for. The clutch begins with strong potential.",
				"The strongest male in the territory is also the steadiest. You choose him, and the season starts at its best.",
				"You select the male who won the most recent contest with control and minimal damage. The future clutch benefits from the choice.",
				"He proves both strong and careful, which is rarer than strength alone. The breeding season starts well.",
				"You choose power with full intent, and the result matches the effort. The clutch begins with excellent promise.",
			],
			"success": [
				"You choose a strong male, and the clutch begins with solid promise.",
				"His strength is clear, and the season moves forward with confidence.",
				"The male you accept gives the future clutch a meaningful advantage.",
				"A capable pairing gives the breeding season a good beginning.",
				"You choose well, and the season reflects the effort.",
			],
			"mixed": [
				"The strongest male is also the most disruptive. The clutch gains something, but the territory feels less safe.",
				"You choose power, and it comes with noise and aggression that draws attention.",
				"His strength is useful, but his restlessness is not. The season gains and loses in roughly equal measure.",
				"The male wins contests but cannot quiet the territory afterward. The clutch's beginning is mixed.",
				"A strong choice with a difficult consequence. The net result is modest.",
			],
			"fail": [
				"The strongest male turns reckless once he wins the season. The clutch starts at a disadvantage.",
				"You choose power, and the male's aggression turns the territory into a problem.",
				"His fighting ability does not extend to keeping the nesting ground secure.",
				"The choice of the strongest male costs more than the strength is worth this season.",
				"The breeding season suffers from his inability to settle after the contest.",
			],
		},
		"test_patience": {
			"strong_success": [
				"You hold back and watch him track your movement. He waits without forcing the issue and proves steady when it matters.",
				"The male keeps pace with your caution and matches it with his own. The clutch benefits from a careful pairing.",
				"You test him over several passes, and he does not break the test. The season starts with excellent terms.",
				"His restraint is genuine, not just tactical. A patient male near armored ground is the right kind of mate.",
				"He passes the test cleanly and earns the season with it. The future clutch starts well.",
			],
			"success": [
				"He shows enough patience to earn the mating, and the season moves forward steadily.",
				"You accept him after a cautious test. The clutch's starting condition improves.",
				"The test produces a reliable result. The season begins with decent promise.",
				"His restraint carries the choice. The future clutch starts on solid terms.",
				"A patient male earns a patient female. The breeding season proceeds well.",
			],
			"mixed": [
				"He holds the test most of the way, then loses it near the end. Good enough, but not ideal.",
				"His patience is real but inconsistent. The season moves forward with uncertain quality.",
				"You learn what you need to know about him, and most of it is acceptable.",
				"He proves himself in parts. The clutch gains something, though not as much as full patience would give.",
				"The test reveals a male with limits. The season continues despite them.",
			],
			"fail": [
				"His patience breaks early and turns to aggression before you are ready to choose.",
				"The male mistakes your caution for weakness and pushes past the test before it is done.",
				"He cannot hold stillness long enough to prove what you were looking for.",
				"Poor patience costs the clutch a clean start. The test reveals the wrong kind of male.",
				"He fails the test, and the breeding season carries that cost into the future.",
			],
		},
		"safe_mate": {
			"strong_success": [
				"The nearest familiar male turns out to carry more fitness than his unassuming presence suggested.",
				"You choose safety, and the nearby male delivers a better start to the clutch than expected.",
				"He keeps the territory quiet and the season steady, and the result is stronger than you planned for.",
				"The closest available male proves worthy of the simple choice. The clutch begins on good terms.",
				"Safety and strength arrive in the same package this season. The clutch benefits.",
			],
			"success": [
				"You choose a nearby male who keeps the territory undisturbed. The season advances with modest promise.",
				"He is steady and close, and the clutch starts without complication.",
				"The safe choice serves the season well enough. The future begins with decent potential.",
				"A calm pairing gives the clutch a stable beginning.",
				"You accept the nearby male, and the season moves forward cleanly.",
			],
			"mixed": [
				"The nearby male is acceptable but not especially fit. The clutch gains stability more than strength.",
				"Safety keeps the season smooth but thin. The clutch's potential is limited.",
				"He avoids trouble and brings modest fitness. The future holds less than a harder choice would have given.",
				"The season stays quiet, which is worth something, but not enough to feel confident.",
				"You choose caution, and the result is exactly as cautious as the choice.",
			],
			"fail": [
				"The safe choice proves weaker than he appeared, and the clutch begins at a disadvantage.",
				"You choose the nearest male, and his fitness is too limited to make the season worthwhile.",
				"He keeps the territory stable and contributes almost nothing to the clutch's future.",
				"The choice avoids all risk and delivers very little reward.",
				"The safe option turns out to be the weak one. The future clutch starts below its potential.",
			],
		},
		"ignore": {
			"strong_success": [
				"You move through the season without engaging it, but a capable male crosses your path at the right moment.",
				"You give the season little attention, and luck delivers a better result than your effort warranted.",
				"A suitable male appears without seeking. The season continues despite your distance from it.",
				"You save your energy, and the season still manages to move forward.",
				"The chance was weaker for your lack of effort, but it did not disappear entirely.",
			],
			"success": [
				"You give the season little effort, but a male still crosses your path at the right time.",
				"You ignore most of the contest noise, and the season moves forward anyway.",
				"A passing male proves acceptable despite your limited involvement.",
				"The chance is modest, but not gone. The season continues.",
				"You save your strength, and luck fills part of the season's gap.",
			],
			"mixed": [
				"You ignore the season too long, and the best chance passes before you take it.",
				"Male calls move through the territory unanswered.",
				"You save your energy, but the future clutch gains little from this season.",
				"Breeding season moves around you while you remain apart from it.",
				"The opportunity narrows with every day you do not engage it.",
			],
			"fail": [
				"Ignoring the season leaves the timing poor and the future clutch starting from behind.",
				"Too many signs pass unanswered, and the season turns thin.",
				"Your distance from the season weakens the chance of a strong beginning.",
				"The lowlands go quiet again. The missed effort carries a real cost.",
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
	return ANKYL_FEMALE_EVENT
