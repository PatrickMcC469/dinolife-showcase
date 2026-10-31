extends "res://scripts/dinos/base_dino_mate.gd"

# Allosaurus — mating season events (replaces tournament_combat flow)
#
# ── MALE EVENT (auto-fires at mating season start) ────────────────────────────
# 2 choices: Challenge rival / Leave
#   Challenge → fight roll (win_chance ~0.45 + luck)
#       Win        → has_mate, pending_egg, male_mating_streak++, check streak boost
#       Loss       → health -0.12, streak resets to 0
#       Loss+injury → health -0.12, random Allosaurus injury, streak resets to 0
#   Leave → no mate, streak resets to 0
#
# ── MALE STREAK BONUS ─────────────────────────────────────────────────────────
# Consecutive successful mating seasons build the streak.
# Streak  2 → permanent_strength_mod +0.03 (tier 1: "Proven Line")
# Streak  4 → permanent_strength_mod +0.03 (tier 2: "Dominant Line")
# Max total: +0.06. Resets to 0 on any season without a mate.
#
# ── FEMALE EVENT (replaces female_nesting_prep for Allosaurus) ───────────────
# 4 choices with varying selectivity; shapes nesting_score for the clutch.
# Hunger costs: strong_challenger 0.12 / test_patience 0.07 / safe_mate 0.04 / ignore 0.0
# Nesting score deltas (strong_success / success / mixed / fail):
#   strong_challenger: +0.35 / +0.25 / +0.05 / -0.15
#   test_patience:     +0.25 / +0.20 / +0.05 / -0.10
#   safe_mate:         +0.15 / +0.10 / +0.03 / -0.05
#   ignore:            +0.08 / +0.05 / -0.05 / -0.20
# Tier probability biases (ignore has higher fail chance; strong_challenger has higher ss chance)
#
# ── FIGHT INJURIES (random pick on male loss+injury) ─────────────────────────
# "Jaw Clash"  → strength -0.08, 2 turns
# "Flank Bite" → defense  -0.08, 2 turns
# "Hip Slam"   → speed    -0.08, 2 turns

# ── Legacy flat data (keep for _load_mate_data() compatibility) ───────────────
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


# ── MALE EVENT ────────────────────────────────────────────────────────────────

const ALLO_MALE_EVENT: Dictionary = {
	"intro": [
		"Breeding season moves through the forest with warm scent and distant calls. You find signs of a receptive female nearby, but another male is already following the same trail.",
		"The season pulls you toward a female's scent near the treeline. Before you can close the distance, a rival male steps from the brush and lowers his jaws.",
		"You catch the trail of a female moving through the territory. The scent is fresh, but so is the heavy mark of another male.",
		"A female's call carries through the forest, sharp and brief. When you answer the trail, another male answers too.",
		"You find broken branches, fresh scent, and the promise of breeding season. Then the rival appears, blocking the path with a warning growl.",
		"The forest feels tense with breeding-season energy. A female is near, but the male guarding the approach does not intend to share.",
		"You follow the scent through shade and mud until the trail opens into a clearing. A rival male stands there first.",
	],
	"choices": [
		{ "label": "Challenge the rival male", "sublabel": "Win the right to mate", "icon": "attack", "action": "challenge" },
		{ "label": "Leave the pair alone",     "sublabel": "Save your strength",    "icon": "flee",   "action": "leave"     },
	],
	"outcomes": {
		"leave": [
			"You read the rival's strength and turn away before blood decides the matter.",
			"The female's scent remains tempting, but survival pulls harder. You leave the trail.",
			"You avoid the challenge and move back into the forest alone.",
			"This season's chance belongs to another male. You save your strength and walk away.",
			"You lower your head, step aside, and let the rival keep the claim.",
			"You leave before the fight begins, carrying hunger instead of wounds.",
			"The breeding trail fades behind you as you choose survival over challenge.",
		],
		"challenge": {
			"win": [
				"You drive the rival back with heavy jaws and harder nerve. He retreats into the trees, and the female remains nearby.",
				"The fight tears through brush and broken branches. When the rival finally gives ground, the season is yours.",
				"You outlast the rival's strength and force him away from the trail. The female accepts your place for the season.",
				"Your bite lands first and your footing holds longer. The rival leaves the clearing, beaten.",
				"The challenger tries to stand between you and the season, but you break his claim with power and timing.",
				"The rival backs down after a brutal clash, leaving you with the right to mate this season.",
				"You win the contest, and the forest grows quiet around your claim.",
			],
			"loss": [
				"The rival holds the trail and drives you away before the fight can turn in your favor.",
				"Your challenge fails. The female's scent fades behind the rival as you retreat into the trees.",
				"The other male's strength wins the clearing, and you leave without mating this season.",
				"You lose the contest and pull away before pride becomes death.",
				"The rival forces you back with a final warning bite, keeping the season for himself.",
				"Your strength is not enough this time. The rival remains, and you move on alone.",
				"The fight ends with you pushed from the trail, hungry, tired, and without a mate.",
			],
			"loss_injured": [
				"The rival catches you hard before you escape. You leave the clearing hurt and without mating this season.",
				"The fight turns against you in a crash of teeth and brush. You survive, but the rival leaves you wounded.",
				"You retreat before the clash becomes fatal, carrying a minor injury and no claim.",
				"The rival's final strike forces you away from the female's trail, sore and beaten.",
				"You lose the contest badly enough to feel it for the rest of the season.",
				"Pain follows you into the trees as the rival keeps the breeding claim.",
				"You escape the fight alive, but not cleanly, and the season slips away behind you.",
			],
		},
	},
	"streak_flavor": [
		"This is not your first successful season. Your strength carries a familiar confidence now.",
		"The forest remembers your victories, and you move through breeding season with proven force.",
		"Another successful season adds weight to your claim and confidence to your bloodline.",
		"You have won this contest before, and that history sharpens every step.",
		"Your repeated success makes the season feel less like chance and more like earned dominance.",
	],
}

func get_allo_male_event() -> Dictionary:
	return ALLO_MALE_EVENT

func get_male_event() -> Dictionary:
	return ALLO_MALE_EVENT


# ── FEMALE EVENT ──────────────────────────────────────────────────────────────

const ALLO_FEMALE_EVENT: Dictionary = {
	"intro": [
		"Breeding season moves through the forest, and male calls echo between the trees. You can choose carefully, because the strength of this season may shape the clutch that follows.",
		"The scent of rival males hangs near your territory. Some are strong, some reckless, some only loud. Your choice matters before eggs ever touch the ground.",
		"The season brings males to the edge of your range. You watch their movement, their scars, and the way they carry hunger.",
		"Heavy footsteps and distant calls mark the start of breeding season. The mate you accept may influence how strong the hatchlings begin.",
		"You are solitary, but not untouched by the season. Males pass through your territory, and each one offers a different chance for the clutch.",
		"The forest fills with breeding-season tension. You can seek strength, safety, patience, or let the season pass with little effort.",
		"A male's call rolls through the trees. Another answers farther off. This season gives you a choice before the future begins.",
	],
	"choices": [
		{ "label": "Choose the strongest challenger", "sublabel": "Costs 12% food · best clutch chance · high risk", "icon": "attack", "action": "strong_challenger" },
		{ "label": "Test the male's patience",        "sublabel": "Costs 7% food · good clutch chance",             "icon": "stalk",  "action": "test_patience"     },
		{ "label": "Choose the safest nearby mate",   "sublabel": "Costs 4% food · modest clutch chance",            "icon": "bond",   "action": "safe_mate"          },
		{ "label": "Ignore the breeding season",      "sublabel": "No cost · risk of poor start",              "icon": "flee",   "action": "ignore"             },
	],
	"outcomes": {
		"strong_challenger": {
			"strong_success": [
				"You choose the strongest male after watching him drive off a rival. His power gives the season a strong beginning.",
				"The male you accept is scarred, steady, and proven. The future clutch begins with excellent promise.",
				"You wait for the strongest challenger to stand alone, and he does. This season starts with powerful blood behind it.",
				"You choose strength, and the choice feels right. The male carries force without panic, and the clutch's future improves.",
				"The strongest male proves more than loudness. He has control, endurance, and the power you wanted.",
			],
			"success": [
				"You choose a strong male, giving the season a solid start.",
				"The male proves capable enough to improve the clutch's chance.",
				"His strength is clear, and the season moves forward with confidence.",
				"You accept a mate with enough power to make the choice worthwhile.",
				"The season begins well under the weight of a strong pairing.",
			],
			"mixed": [
				"The male is strong, but reckless. His presence improves the clutch's promise while making the territory feel tense.",
				"You choose power, but power brings noise, broken brush, and attention.",
				"The male is impressive, but not careful. The future improves, though danger feels closer.",
				"His strength is useful, but his aggression leaves the area unsettled.",
				"The season gains from his power, but the choice is not clean.",
			],
			"fail": [
				"The strongest male is too reckless. His fighting draws danger and leaves the season less secure than you hoped.",
				"You choose power, but the male's aggression turns the territory unstable.",
				"His strength comes with chaos, and the future clutch may pay for that.",
				"The male wins attention, not trust. The season starts under strain.",
				"You choose the loudest power, and it proves less useful than patience would have been.",
			],
		},
		"test_patience": {
			"strong_success": [
				"You keep your distance and watch how he follows. He waits, reads your movement, and proves steady enough for a strong start.",
				"The male does not rush or rage. His patience gives the season a safer kind of strength.",
				"You test him across trail and cover, and he keeps pace without pushing too hard.",
				"His control impresses you more than his bite. The clutch's beginning improves because of it.",
				"The male proves he can endure tension without turning reckless.",
			],
			"success": [
				"The male shows enough patience to make the season feel promising.",
				"He follows without forcing the moment, and your choice feels steady.",
				"You accept him after a cautious test, giving the clutch a solid beginning.",
				"His restraint helps the season move forward cleanly.",
				"He proves calm enough to be worth choosing.",
			],
			"mixed": [
				"He waits at first, then grows restless. The choice still helps, but not as much as it could have.",
				"The test reveals patience and impatience in equal measure.",
				"He follows well enough, though his control breaks more than once.",
				"The season moves forward, but the male's steadiness remains uncertain.",
				"You learn enough to choose him, but not enough to fully trust the result.",
			],
			"fail": [
				"The test unsettles him, and his frustration turns the season tense.",
				"He mistakes caution for rejection and becomes too aggressive.",
				"The male fails the test, but the season has already lost time and energy.",
				"His patience breaks early, leaving the choice weaker than hoped.",
				"The test reveals poor control, and the clutch's start suffers for it.",
			],
		},
		"safe_mate": {
			"strong_success": [
				"You choose a nearby male who knows the territory and keeps the season quiet. Safety gives the clutch a strong start.",
				"The male is not the strongest, but he is careful, healthy, and close. The choice works better than expected.",
				"You choose stability over spectacle, and the forest stays calm around the season.",
				"His familiar scent and careful movement make the territory feel secure.",
				"The safest choice gives the future clutch a surprisingly strong beginning.",
			],
			"success": [
				"You choose a safe nearby mate, giving the season a modest but steady start.",
				"The male is close, calm, and good enough for the season.",
				"The choice does not dazzle, but it supports the clutch well.",
				"You accept a mate who keeps the territory quiet and the season stable.",
				"Safety carries the season forward without trouble.",
			],
			"mixed": [
				"The mate is safe, but not especially strong. The clutch gains stability more than power.",
				"The season stays calm, though the future does not feel especially improved.",
				"You choose caution, and it helps, but only a little.",
				"The nearby male is acceptable, though not impressive.",
				"The start is steady, but not strong.",
			],
			"fail": [
				"The safe choice proves weaker than expected, and the clutch gains little from the season.",
				"The nearby male avoids trouble, but also brings little strength.",
				"You choose safety, but the season begins too quietly, almost thin.",
				"The mate's caution borders on weakness, leaving the future less promising.",
				"The choice avoids danger, but it does not give the clutch much of a boost.",
			],
		},
		"ignore": {
			"strong_success": [
				"You give the season little effort, but a suitable male still crosses your path at the right time.",
				"You ignore most of the calls, yet the season manages to continue.",
				"A passing male proves acceptable despite your distance from the season.",
				"The chance is weaker, but not lost. The season moves forward anyway.",
				"You save your strength, and luck carries part of the season for you.",
			],
			"success": [
				"You give the season little effort, but a suitable male still crosses your path at the right time.",
				"You ignore most of the calls, yet the season manages to continue.",
				"A passing male proves acceptable despite your distance from the season.",
				"The chance is weaker, but not lost. The season moves forward anyway.",
				"You save your strength, and luck carries part of the season for you.",
			],
			"mixed": [
				"You ignore the season too long, and the chance for a strong clutch fades.",
				"The male calls pass through the trees unanswered.",
				"You save your energy, but the future clutch gains no advantage from this season.",
				"Breeding season moves around you while you remain apart from it.",
				"The opportunity weakens, leaving the next stage less promising.",
			],
			"fail": [
				"Ignoring the season leaves the timing poor and the future clutch starting at a disadvantage.",
				"You let too many signs pass unanswered, and the season turns thin.",
				"Your distance from the season weakens the chance of a strong beginning.",
				"The forest grows quiet again, and the missed effort leaves the future less certain.",
				"The season passes poorly, and the clutch's starting condition suffers.",
			],
		},
	},
}

func get_allo_female_event() -> Dictionary:
	return ALLO_FEMALE_EVENT

func get_female_event() -> Dictionary:
	return ALLO_FEMALE_EVENT
