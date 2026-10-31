extends "res://scripts/dinos/base_dino_juvenile.gd"

# T-Rex — juvenile mother-bond events
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
	# ── EVENT 1: The Scent Trail Test ─────────────────────────────────────────
	{
		"intro": [
			"Your mother stops beside a trail heavy with old blood, fresh mud, and crushed plants. She lowers her snout once, then looks to you.",
		],
		"choices": [
			{ "label": "Study the scent before moving",      "sublabel": "", "icon": "bond",   "action": "choice_a" },
			{ "label": "Follow her first step",              "sublabel": "", "icon": "stalk",  "action": "choice_b" },
			{ "label": "Choose your own trail",              "sublabel": "", "icon": "flee",   "action": "choice_c" },
			{ "label": "Charge toward the strongest smell",  "sublabel": "", "icon": "attack", "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["You separate old blood from fresh movement and choose the correct trail."],
				"success": ["You follow the scent well enough to keep her approval."],
				"mixed":   ["You find part of the trail, but lose the freshest direction."],
				"fail":    ["You follow stale blood and waste the lesson."],
			},
			"choice_b": {
				"crit":    ["You match her choice perfectly and understand why she took it."],
				"success": ["You stay with her and learn the trail through her guidance."],
				"mixed":   ["You follow correctly, but rely too much on her lead."],
				"fail":    ["You follow her body, not the scent, and learn little."],
			},
			"choice_c": {
				"crit":    ["You choose correctly without help, earning a deep approving rumble."],
				"success": ["Your trail is not perfect, but it still leads somewhere useful."],
				"mixed":   ["You choose a risky path and have to turn back."],
				"fail":    ["You choose wrong and return frustrated."],
			},
			"choice_d": {
				"crit":    ["The strongest scent happens to be fresh, and your boldness pays off."],
				"success": ["You find something useful, but miss the finer lesson."],
				"mixed":   ["You rush into old blood and confusion."],
				"fail":    ["You crash through the brush, destroy the trail, and earn her displeasure."],
			},
		},
	},
	# ── EVENT 2: The Heavy Silence ────────────────────────────────────────────
	{
		"intro": [
			"Your mother brings you near prey, then does nothing. No growl. No signal. She waits to see whether you understand silence.",
		],
		"choices": [
			{ "label": "Stay still until she moves",     "sublabel": "", "icon": "bond",   "action": "choice_a" },
			{ "label": "Watch her breathing",            "sublabel": "", "icon": "stalk",  "action": "choice_b" },
			{ "label": "Crawl to a better angle",        "sublabel": "", "icon": "flee",   "action": "choice_c" },
			{ "label": "Force the prey to move",         "sublabel": "", "icon": "attack", "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["You hold perfectly still, and the prey passes close without noticing you."],
				"success": ["You stay quiet enough to learn the patience of a real stalk."],
				"mixed":   ["You shift once, but recover before the prey bolts."],
				"fail":    ["You move too soon and ruin the silence."],
			},
			"choice_b": {
				"crit":    ["You match her calm so well that your own body settles into the hunt."],
				"success": ["You use her rhythm to control your nerves."],
				"mixed":   ["You understand the lesson, but your excitement keeps breaking through."],
				"fail":    ["You miss the signal hidden in her stillness."],
			},
			"choice_c": {
				"crit":    ["You move slowly and find a stronger position without being seen."],
				"success": ["You improve your angle, though not as quietly as she would."],
				"mixed":   ["You gain a better spot but nearly alert the prey."],
				"fail":    ["Your movement snaps the moment apart."],
			},
			"choice_d": {
				"crit":    ["Your bold pressure flushes the prey exactly where your mother wanted it."],
				"success": ["You make the prey move, but the lesson becomes messier."],
				"mixed":   ["You create chaos and learn from the mistake."],
				"fail":    ["The prey scatters, and your mother's stare pins you harder than teeth."],
			},
		},
	},
	# ── EVENT 3: The Kill Claim ───────────────────────────────────────────────
	{
		"intro": [
			"Your mother leaves a fresh carcass in the clearing and steps away. The meat is there, but so are scavengers watching from the edge.",
		],
		"choices": [
			{ "label": "Wait for her approval",          "sublabel": "", "icon": "bond",   "action": "choice_a" },
			{ "label": "Stand over the carcass",         "sublabel": "", "icon": "stalk",  "action": "choice_b" },
			{ "label": "Chase off the scavengers",       "sublabel": "", "icon": "flee",   "action": "choice_c" },
			{ "label": "Eat first and ignore them",      "sublabel": "", "icon": "attack", "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["You wait, she rumbles once, and the scavengers retreat before you feed."],
				"success": ["You show control and earn a clean place at the carcass."],
				"mixed":   ["You wait too long and scavengers steal some scraps."],
				"fail":    ["You hesitate until your mother steps in and ends the test."],
			},
			"choice_b": {
				"crit":    ["Your posture alone drives the scavengers back."],
				"success": ["You hold the kill well enough to feed."],
				"mixed":   ["You keep the carcass, but one scavenger snaps close before fleeing."],
				"fail":    ["Your stance breaks, and your mother has to reclaim the kill."],
			},
			"choice_c": {
				"crit":    ["You scatter them with one controlled rush and return to the meat."],
				"success": ["You drive them away, though it costs energy."],
				"mixed":   ["You chase too far and leave the carcass exposed."],
				"fail":    ["You lose both time and food while your mother watches."],
			},
			"choice_d": {
				"crit":    ["You feed fast enough that the scavengers do not matter."],
				"success": ["You get meat, but the scavengers grow bolder nearby."],
				"mixed":   ["You eat some, but lose part of the carcass to the edges."],
				"fail":    ["The scavengers steal more than they should, and your mother corrects your carelessness."],
			},
		},
	},
	# ── EVENT 4: The Boundary Roar ────────────────────────────────────────────
	{
		"intro": [
			"At the edge of her territory, your mother roars into the distance. A rival answers faintly. Then she turns toward you.",
		],
		"choices": [
			{ "label": "Answer with restraint",          "sublabel": "", "icon": "bond",   "action": "choice_a" },
			{ "label": "Stand beside her silently",      "sublabel": "", "icon": "stalk",  "action": "choice_b" },
			{ "label": "Roar louder than you should",    "sublabel": "", "icon": "flee",   "action": "choice_c" },
			{ "label": "Move toward the rival sound",    "sublabel": "", "icon": "attack", "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["Your smaller roar carries steady and controlled, strengthening the bond between you."],
				"success": ["Your answer is good enough to show growing confidence."],
				"mixed":   ["Your roar cracks, but you hold your ground."],
				"fail":    ["Your sound comes out panicked, and the lesson slips away."],
			},
			"choice_b": {
				"crit":    ["You understand that presence can speak without sound. She accepts your quiet strength."],
				"success": ["You stand with her and feel the weight of territory."],
				"mixed":   ["You stay close, but fear shows in your posture."],
				"fail":    ["You shrink back when the rival answers again."],
			},
			"choice_c": {
				"crit":    ["Your bold roar shocks the distant rival into silence."],
				"success": ["Your roar carries, but strains your control."],
				"mixed":   ["It sounds strong at first, then breaks badly."],
				"fail":    ["The roar fails, and your mother cuts you off with a warning rumble."],
			},
			"choice_d": {
				"crit":    ["You take a few brave steps, then stop before foolishness becomes danger."],
				"success": ["Your courage shows, though your mother blocks you from going farther."],
				"mixed":   ["You push too far and are forced back sharply."],
				"fail":    ["You ignore the boundary and earn a hard correction."],
			},
		},
	},
	# ── EVENT 5: The First Night Alone ────────────────────────────────────────
	{
		"intro": [
			"For the first time, your mother does not sleep beside you. She settles somewhere nearby, but leaves a stretch of darkness between you.",
		],
		"choices": [
			{ "label": "Stay where she placed you",           "sublabel": "", "icon": "bond",   "action": "choice_a" },
			{ "label": "Move closer quietly",                 "sublabel": "", "icon": "stalk",  "action": "choice_b" },
			{ "label": "Keep watch from your own spot",       "sublabel": "", "icon": "flee",   "action": "choice_c" },
			{ "label": "Wander away to prove independence",   "sublabel": "", "icon": "attack", "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["You hold your place through the night and wake steadier than before."],
				"success": ["You manage the distance and keep the bond through trust."],
				"mixed":   ["You stay put, but fear keeps you from resting well."],
				"fail":    ["You panic and call for her before dawn."],
			},
			"choice_b": {
				"crit":    ["You close the distance without making noise, showing caution and control."],
				"success": ["You find a safer nearby spot and settle."],
				"mixed":   ["You move close, but she growls when you crowd her."],
				"fail":    ["You stumble noisily through the dark and break the lesson."],
			},
			"choice_c": {
				"crit":    ["You notice danger signs before they matter and earn her approval at sunrise."],
				"success": ["You stay alert and prove you can handle some distance."],
				"mixed":   ["You watch too much and sleep too little."],
				"fail":    ["You exhaust yourself and miss the lesson in rest."],
			},
			"choice_d": {
				"crit":    ["You explore briefly and return safely before she rises."],
				"success": ["You test the dark and learn something, though the risk was real."],
				"mixed":   ["You get frightened and return too quickly, shaken but wiser."],
				"fail":    ["You lose your way and your mother has to find you."],
			},
		},
	},
	# ── EVENT 6: The No-Help Chase ────────────────────────────────────────────
	{
		"intro": [
			"A small prey animal breaks from cover. You expect your mother to move with you, but she stays still. This chase is yours.",
		],
		"choices": [
			{ "label": "Choose the cleanest angle",      "sublabel": "", "icon": "bond",   "action": "choice_a" },
			{ "label": "Follow at steady pressure",      "sublabel": "", "icon": "stalk",  "action": "choice_b" },
			{ "label": "Explode into a full rush",       "sublabel": "", "icon": "flee",   "action": "choice_c" },
			{ "label": "Look back for her help",         "sublabel": "", "icon": "attack", "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["You cut the prey off perfectly and finish the chase with control."],
				"success": ["Your angle works well enough to catch or corner it."],
				"mixed":   ["You nearly succeed, but waste energy correcting your path."],
				"fail":    ["You misjudge the angle and lose the prey."],
			},
			"choice_b": {
				"crit":    ["You wear the prey down without panic, exactly as she intended."],
				"success": ["You keep pressure and learn the value of patience."],
				"mixed":   ["You stay on it, but tire yourself out."],
				"fail":    ["You fall behind and lose the chase."],
			},
			"choice_c": {
				"crit":    ["Your sudden burst catches the prey before it can turn."],
				"success": ["You nearly overpower the chase through force."],
				"mixed":   ["You get close, but crash through the brush too loudly."],
				"fail":    ["You burn your strength too fast and fail the lesson."],
			},
			"choice_d": {
				"crit":    ["You glance back once, then choose to act alone and recover the chase."],
				"success": ["You hesitate, but still finish part of the lesson."],
				"mixed":   ["Your hesitation costs the best opening."],
				"fail":    ["You wait too long, and your mother does not help."],
			},
		},
	},
]

func get_juvenile_events() -> Array:
	return JUVENILE_EVENTS
