extends "res://scripts/dinos/base_dino_juvenile.gd"

# Allosaurus — juvenile mother-bond events
# Fires each season during life_stage 1 (Juvenile). Ends at sub-adult.
# 4 choices per event, each with 4 outcome tiers: crit / success / mixed / fail
# Bond delta per tier: Crit +0.25 / Success +0.15 / Mixed +0.05 / Fail -0.10
# Departure at sub-adult:
#   bond >= 1.0  → Great Bond     (all 4 stats +0.04 permanent)
#   bond >= 0.5  → Strong Bond    (all 4 stats +0.025 permanent)
#   bond >= 0.1  → Neutral        (no change)
#   bond >= -0.2 → Weak Bond      (all 4 stats -0.02 permanent)
#   bond <  -0.2 → Broken Bond    (all 4 stats -0.04 permanent)

const JUVENILE_EVENTS: Array = [
	# ── EVENT 1: The Kill-Site Lesson ─────────────────────────────────────────
	{
		"intro": [
			"Your mother brings you to an old kill site where bones, scent, and torn ground tell the story of what happened. She lowers her head to the tracks and waits for you to understand.",
		],
		"choices": [
			{ "label": "Study the signs beside her",      "sublabel": "", "icon": "bond",   "action": "choice_a" },
			{ "label": "Follow the strongest scent",      "sublabel": "", "icon": "stalk",  "action": "choice_b" },
			{ "label": "Search the kill site alone",      "sublabel": "", "icon": "flee",   "action": "choice_c" },
			{ "label": "Ignore the signs, look for meat", "sublabel": "", "icon": "attack", "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["You read the broken plants, drag marks, and bite signs almost perfectly. Your mother gives a low approving rumble."],
				"success": ["You understand enough of the lesson, and your bond with her strengthens."],
				"mixed":   ["You learn part of the story, but miss the final direction of the trail."],
				"fail":    ["You stare at the signs too long without understanding, and your mother moves on without waiting."],
			},
			"choice_b": {
				"crit":    ["You pick the right trail quickly, surprising her with your nose for blood and movement."],
				"success": ["You find a useful scent and follow it well enough."],
				"mixed":   ["You follow the trail for a while, but lose it in trampled ground."],
				"fail":    ["You choose the wrong scent and waste energy chasing old blood."],
			},
			"choice_c": {
				"crit":    ["You find a hidden scrap and a useful track, proving you can learn without being led."],
				"success": ["You discover enough to make the search worthwhile."],
				"mixed":   ["You find scraps, but your mother has to pull you away from a bad trail."],
				"fail":    ["You wander too far from the lesson and return with nothing but confusion."],
			},
			"choice_d": {
				"crit":    ["You find a small piece of food and still notice one important clue by accident."],
				"success": ["You get a bite, but learn little."],
				"mixed":   ["You find food, but your mother growls when you miss the lesson completely."],
				"fail":    ["You tear at useless bones while she leaves the site behind."],
			},
		},
	},
	# ── EVENT 2: The Warning Growl ────────────────────────────────────────────
	{
		"intro": [
			"While you rest near a shaded hollow, your mother suddenly gives a low warning growl. You do not see the danger yet, but she clearly does.",
		],
		"choices": [
			{ "label": "Freeze and listen",               "sublabel": "", "icon": "bond",   "action": "choice_a" },
			{ "label": "Move closer to her",              "sublabel": "", "icon": "stalk",  "action": "choice_b" },
			{ "label": "Try to spot the danger yourself", "sublabel": "", "icon": "flee",   "action": "choice_c" },
			{ "label": "Growl back at the unseen threat", "sublabel": "", "icon": "attack", "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["You go still at once, catching the faint sound of movement before it reaches you."],
				"success": ["You obey quickly, and your mother's trust in you grows."],
				"mixed":   ["You freeze late, but not too late to avoid real trouble."],
				"fail":    ["You shift at the wrong moment and draw a sharper warning from her."],
			},
			"choice_b": {
				"crit":    ["You slip beside her without noise, using her posture to understand the threat."],
				"success": ["You stay close enough to remain safe and learn from her response."],
				"mixed":   ["You get close, but your movement snaps a twig."],
				"fail":    ["You crowd her space and earn a shove away."],
			},
			"choice_c": {
				"crit":    ["You find the threat before it moves and feel your instincts sharpen."],
				"success": ["You spot enough signs to understand why she warned you."],
				"mixed":   ["You look in the right direction, but too slowly."],
				"fail":    ["You stare the wrong way and miss what she was teaching."],
			},
			"choice_d": {
				"crit":    ["Your bold answer startles the danger away, and your mother allows it."],
				"success": ["The threat retreats, but your mother's posture tells you that luck helped."],
				"mixed":   ["Your growl works, but it was louder than it needed to be."],
				"fail":    ["Your noise makes the danger clearer, and your mother has to step between you and it."],
			},
		},
	},
	# ── EVENT 3: The Half-Shared Hunt ─────────────────────────────────────────
	{
		"intro": [
			"Your mother wounds a small prey animal, then steps back. It is not a full hunt. It is a test.",
		],
		"choices": [
			{ "label": "Wait for the clean opening",   "sublabel": "", "icon": "bond",   "action": "choice_a" },
			{ "label": "Chase it down carefully",      "sublabel": "", "icon": "stalk",  "action": "choice_b" },
			{ "label": "Use your own ambush angle",    "sublabel": "", "icon": "flee",   "action": "choice_c" },
			{ "label": "Rush it with raw hunger",      "sublabel": "", "icon": "attack", "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["You strike at the perfect moment, finishing the lesson with control."],
				"success": ["You wait long enough and bring the prey down."],
				"mixed":   ["You hesitate too long, but still manage to recover."],
				"fail":    ["The prey escapes while you wait for a better chance."],
			},
			"choice_b": {
				"crit":    ["You control the chase and finish without wasting much energy."],
				"success": ["You catch it after a messy but useful pursuit."],
				"mixed":   ["You win, but burn too much strength doing it."],
				"fail":    ["You overrun the angle and lose the prey."],
			},
			"choice_c": {
				"crit":    ["Your chosen angle works beautifully, and your mother watches without interrupting."],
				"success": ["Your idea works well enough to finish the hunt."],
				"mixed":   ["You almost ruin the lesson, but still learn something from the mistake."],
				"fail":    ["Your angle exposes you, and the prey bolts."],
			},
			"choice_d": {
				"crit":    ["Your sudden charge overwhelms the prey before it can react."],
				"success": ["You bring it down, but not cleanly."],
				"mixed":   ["You hit hard but clumsy, earning food and a warning growl."],
				"fail":    ["The prey escapes, and your mother's silence feels worse than a growl."],
			},
		},
	},
	# ── EVENT 4: Sleeping Near the Den ────────────────────────────────────────
	{
		"intro": [
			"Night settles over the den. Your mother chooses a resting place with clear sightlines and heavy cover, then watches where you decide to sleep.",
		],
		"choices": [
			{ "label": "Sleep where she chose",           "sublabel": "", "icon": "bond",   "action": "choice_a" },
			{ "label": "Sleep nearby but separate",       "sublabel": "", "icon": "stalk",  "action": "choice_b" },
			{ "label": "Take the higher lookout spot",    "sublabel": "", "icon": "flee",   "action": "choice_c" },
			{ "label": "Sleep wherever you want",         "sublabel": "", "icon": "attack", "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["You settle in the safest spot and wake rested, calm, and trusted."],
				"success": ["You choose well and strengthen the quiet bond between you."],
				"mixed":   ["You rest safely, but crowd her space more than she likes."],
				"fail":    ["You settle poorly and are nudged awake until you move."],
			},
			"choice_b": {
				"crit":    ["You choose a good nearby spot, showing independence without disrespect."],
				"success": ["You rest close enough to stay safe and far enough to show control."],
				"mixed":   ["Your spot is decent, but the wind shifts your scent badly."],
				"fail":    ["You choose a poor angle, and she forces you closer before danger finds it."],
			},
			"choice_c": {
				"crit":    ["Your bold choice works, and you notice movement before dawn."],
				"success": ["You stay alert enough to make the spot useful."],
				"mixed":   ["You keep watch, but sleep poorly."],
				"fail":    ["You tire yourself out and miss the point of resting safely."],
			},
			"choice_d": {
				"crit":    ["Luck favors you, and the spot turns out safer than expected."],
				"success": ["You rest, but learn little from her careful choice."],
				"mixed":   ["You sleep poorly and wake stiff."],
				"fail":    ["Your careless choice earns a sharp correction before the night is over."],
			},
		},
	},
	# ── EVENT 5: The Last Shared Trail ────────────────────────────────────────
	{
		"intro": [
			"Your mother leads you along a long trail at the edge of her territory. She is not hunting. She is showing you boundaries.",
		],
		"choices": [
			{ "label": "Memorize the trail markers",    "sublabel": "", "icon": "bond",   "action": "choice_a" },
			{ "label": "Walk beside her",               "sublabel": "", "icon": "stalk",  "action": "choice_b" },
			{ "label": "Range ahead and test the path", "sublabel": "", "icon": "flee",   "action": "choice_c" },
			{ "label": "Mark over her trail",           "sublabel": "", "icon": "attack", "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["You remember scent marks, landmarks, and danger signs with unusual clarity."],
				"success": ["You learn the shape of the territory and earn her trust."],
				"mixed":   ["You remember the main path but miss several warning signs."],
				"fail":    ["The trail blurs together, and your mother grows impatient."],
			},
			"choice_b": {
				"crit":    ["You match her pace and read the trail through her movements."],
				"success": ["You stay close and understand the lesson well enough."],
				"mixed":   ["You keep up, but miss why she avoids certain places."],
				"fail":    ["You stumble into her path too often and break the rhythm."],
			},
			"choice_c": {
				"crit":    ["You find a useful side route and return before she calls you back."],
				"success": ["You explore without losing the trail."],
				"mixed":   ["You find something useful, but worry her by staying away too long."],
				"fail":    ["You lose the path and return only after she comes looking."],
			},
			"choice_d": {
				"crit":    ["Your bold marking is tolerated — a small sign that independence is coming."],
				"success": ["She allows it, but makes it clear the territory is still hers."],
				"mixed":   ["She corrects you sharply, but the lesson sticks."],
				"fail":    ["She drives you off the mark and leaves you behind for a while."],
			},
		},
	},
]

func get_juvenile_events() -> Array:
	return JUVENILE_EVENTS
