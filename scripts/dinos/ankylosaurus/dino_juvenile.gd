extends "res://scripts/dinos/base_dino_juvenile.gd"

# Ankylosaurus — juvenile mother-bond events
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
	# ── EVENT 1: The Predator at Distance ─────────────────────────────────────
	{
		"intro": [
			"A predator appears at the far edge of the feeding ground. Your mother stops moving. She does not run. She does not lower her head. She watches.",
			"Something large breaks the treeline across the flat. Your mother's tail lifts slightly off the ground, then stills. She is reading the threat. She waits to see if you will too.",
			"A theropod pauses at the edge of your feeding ground and looks across the distance. Your mother already knows it is there. She stopped before you noticed.",
		],
		"choices": [
			{ "label": "Watch the predator's path and direction",  "sublabel": "", "icon": "bond",   "action": "choice_a" },
			{ "label": "Match your mother's stillness exactly",    "sublabel": "", "icon": "stalk",  "action": "choice_b" },
			{ "label": "Move behind her body",                     "sublabel": "", "icon": "flee",   "action": "choice_c" },
			{ "label": "Lower your head and keep feeding",         "sublabel": "", "icon": "attack", "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["You read its gait and angle and know it is not committed before it knows that itself. Your mother glances at you once."],
				"success": ["You track its movement and learn that distance is information before it becomes danger."],
				"mixed":   ["You watch, but focus on the wrong details and miss what your mother was reading."],
				"fail":    ["You stare without learning anything, and your mother has to redirect your attention."],
			},
			"choice_b": {
				"crit":    ["You find the exact weight and stillness she carries and hold it without shaking. The predator moves on."],
				"success": ["You mirror her posture well enough that you both disappear into the distance together."],
				"mixed":   ["You try to match her but shift too much, and she moves between you and the predator."],
				"fail":    ["You cannot hold her stillness, and she has to nudge you flat with her side."],
			},
			"choice_c": {
				"crit":    ["You find cover behind her without crowding and understand that you chose the right position."],
				"success": ["You use her size well, even if the choice was instinct rather than thought."],
				"mixed":   ["You press too close and she has to push you off to keep her range of movement."],
				"fail":    ["You crowd her badly at the wrong moment and she has to swing wide to protect both of you."],
			},
			"choice_d": {
				"crit":    ["You keep feeding with deliberate calm and the predator reads two armored shapes as too much effort."],
				"success": ["Your stillness while eating is enough that the predator loses interest."],
				"mixed":   ["Your movement while feeding draws attention and your mother has to step forward."],
				"fail":    ["You ignore the threat completely and the predator reads your carelessness as an opening."],
			},
		},
	},
	# ── EVENT 2: Learning the Club ────────────────────────────────────────────
	{
		"intro": [
			"Your mother swings her tail club into a rotting log. The sound is heavy and final. She does it twice — once fast, once slow — and then looks at you.",
			"A downed tree lies across the path. Your mother pauses beside it, swings her tail in a slow deliberate arc, and waits. The lesson does not need words.",
			"The morning is quiet when your mother demonstrates the arc. Twice. Three times. She is not doing it for herself.",
		],
		"choices": [
			{ "label": "Watch the full arc before you try",        "sublabel": "", "icon": "bond",   "action": "choice_a" },
			{ "label": "Practice the swing slowly and controlled", "sublabel": "", "icon": "stalk",  "action": "choice_b" },
			{ "label": "Swing with full force immediately",        "sublabel": "", "icon": "attack", "action": "choice_c" },
			{ "label": "Test it on something smaller first",       "sublabel": "", "icon": "flee",   "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["You read the arc completely — the setup, the load, the release point — and when you swing, it connects correctly."],
				"success": ["Watching first gives your body a map to follow. The swing is rough but carries the right idea."],
				"mixed":   ["You watch well but translate it poorly. The arc is short and too low."],
				"fail":    ["You watch without absorbing anything and swing blind."],
			},
			"choice_b": {
				"crit":    ["Slow practice finds the angle. When you speed it up, the contact is exactly right."],
				"success": ["The controlled swing teaches your tail where the weight should land."],
				"mixed":   ["You find the arc but lose the timing when you add speed."],
				"fail":    ["Slow and controlled becomes slow and wrong. The arc never settles."],
			},
			"choice_c": {
				"crit":    ["Pure force finds something solid through luck, and your mother reads the contact as real."],
				"success": ["You connect, but the technique is all muscle and no precision."],
				"mixed":   ["You swing hard and miss by enough that your mother looks away."],
				"fail":    ["You overcommit and fall sideways. The club drags through empty air."],
			},
			"choice_d": {
				"crit":    ["You find the right arc on a smaller target and carry it cleanly into the log."],
				"success": ["Small practice gives your tail a sense of the weight and the swing transfers."],
				"mixed":   ["Small success doesn't translate. The larger target changes the arc and you adjust too late."],
				"fail":    ["You practice the wrong swing on the wrong target and learn nothing useful."],
			},
		},
	},
	# ── EVENT 3: The Soft Ground ──────────────────────────────────────────────
	{
		"intro": [
			"Heavy rain has turned the lowland path into mud. Your mother picks her steps with unusual care and pauses to let you watch before she continues.",
			"The ground ahead has gone soft after the rains. Your weight is not the same as hers yet, but it is already enough to make the wrong step costly.",
			"The flat between you and the tree line has gone dark with water. You are heavy for your age. Your mother takes a slow step forward, and stops.",
		],
		"choices": [
			{ "label": "Step exactly where she steps",          "sublabel": "", "icon": "bond",   "action": "choice_a" },
			{ "label": "Read the ground color and texture",     "sublabel": "", "icon": "stalk",  "action": "choice_b" },
			{ "label": "Move quickly to cross before sinking",  "sublabel": "", "icon": "flee",   "action": "choice_c" },
			{ "label": "Go around the long way",                "sublabel": "", "icon": "attack", "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["Her tested path carries you clean across. You understand exactly what she was reading."],
				"success": ["Following her steps gets you through safely and you begin to understand why each one was placed where it was."],
				"mixed":   ["You follow most of the path correctly but drift off it at the end and sink briefly before recovering."],
				"fail":    ["You lose the line of her steps and sink deep enough that she has to wait while you drag yourself clear."],
			},
			"choice_b": {
				"crit":    ["You read the paler, firmer patches correctly and cross with no help."],
				"success": ["Your path is not as clean as hers but you make it through reading the surface."],
				"mixed":   ["You misread one patch and sink briefly, learning from the mistake before it becomes serious."],
				"fail":    ["You read nothing correctly and sink to your chest before your mother redirects you."],
			},
			"choice_c": {
				"crit":    ["Speed works here — your momentum carries you over the worst sections before your weight can settle."],
				"success": ["You get through but churn the ground badly and have no idea if luck or judgment carried you."],
				"mixed":   ["Speed gets you most of the way and panic gets you the rest. She watches without approval."],
				"fail":    ["Speed makes the sinking faster and you are stuck before you process what happened."],
			},
			"choice_d": {
				"crit":    ["You find the long route and arrive at the same place without the lesson, but safe and clean."],
				"success": ["You avoid the problem entirely, though your mother notes your avoidance."],
				"mixed":   ["The long way around leads through worse ground. You did not read far enough ahead."],
				"fail":    ["You choose the long route and it is longer and worse than the crossing you avoided."],
			},
		},
	},
	# ── EVENT 4: Press Flat ───────────────────────────────────────────────────
	{
		"intro": [
			"A predator comes close — too close for distance to matter. Your mother drops without hesitation. All armor up. Body flat. Legs folded beneath her. She has done this before.",
			"The brush parts and something large is already inside your space. Your mother sinks in one motion — low and wide and still. Her tail does not move.",
			"There is no time to read it or plan it. Your mother's body is suddenly lower than it was, pressed into the ground, and she is looking at you.",
		],
		"choices": [
			{ "label": "Press flat alongside her immediately",    "sublabel": "", "icon": "bond",   "action": "choice_a" },
			{ "label": "Hold still but stay upright",             "sublabel": "", "icon": "stalk",  "action": "choice_b" },
			{ "label": "Swing your tail toward the predator",     "sublabel": "", "icon": "attack", "action": "choice_c" },
			{ "label": "Try to back away slowly",                 "sublabel": "", "icon": "flee",   "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["You drop clean and fast and disappear into the same armored mass as your mother. The predator circles once and reads too much armor."],
				"success": ["You press flat and stay flat. The predator loses interest in what has become a pile of locked plates."],
				"mixed":   ["You get down but your tail keeps moving. Your mother's body blocks the worst of it."],
				"fail":    ["You drop slowly and your soft underside is exposed before you complete the press."],
			},
			"choice_b": {
				"crit":    ["You hold absolute stillness upright and the predator reads you as stone rather than prey."],
				"success": ["Your stillness is convincing enough to buy time without the full press."],
				"mixed":   ["Upright and still draws attention that flat armor would not have. Your mother shifts to cover you."],
				"fail":    ["Standing upright leaves your legs visible and the predator tests exactly that."],
			},
			"choice_c": {
				"crit":    ["The predator is exactly at club range and the swing connects before it can respond."],
				"success": ["Your swing doesn't land cleanly but it communicates enough that the predator reassesses."],
				"mixed":   ["Your tail swings wide and misses, and the motion draws the predator closer to what it can reach."],
				"fail":    ["The swing exposes your flank and the predator targets the gap your movement opened."],
			},
			"choice_d": {
				"crit":    ["You step back so slowly and silently that the predator never resolves you from the surroundings."],
				"success": ["Slow retreat creates enough distance that the predator chooses not to pursue."],
				"mixed":   ["Your backward movement catches its eye and your mother has to intercept."],
				"fail":    ["Movement triggers the chase instinct and your mother has to put herself between you."],
			},
		},
	},
	# ── EVENT 5: Feeding Watch ────────────────────────────────────────────────
	{
		"intro": [
			"Your mother is feeding from low plants along the tree line when a small predator appears in the brush beyond the clearing. She does not stop eating.",
			"A lean predator circles the edge of the feeding ground at a cautious distance. Your mother's head stays low. Her tail rises slightly, enough to say she already knows.",
			"Something watches from the brush while you feed. Your mother can feel it without looking. She adjusts her position once, slightly, and continues.",
		],
		"choices": [
			{ "label": "Track its position while you keep eating",      "sublabel": "", "icon": "bond",   "action": "choice_a" },
			{ "label": "Turn your armored back toward the predator",    "sublabel": "", "icon": "stalk",  "action": "choice_b" },
			{ "label": "Stop eating and wait for it to leave",          "sublabel": "", "icon": "flee",   "action": "choice_c" },
			{ "label": "Keep eating without adjusting your position",   "sublabel": "", "icon": "attack", "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["You track it at the edge of your attention without letting it take the whole of your focus. You eat well and it moves on."],
				"success": ["You maintain awareness without giving the predator your full attention, which is the right balance."],
				"mixed":   ["You split your focus unevenly and miss some food while not watching the predator closely enough."],
				"fail":    ["You try to watch it and eat at the same time and do neither well."],
			},
			"choice_b": {
				"crit":    ["You angle yourself without making it obvious and the predator reads only locked plates from its position."],
				"success": ["Your armored back faces the threat while your head stays in the plants. Your mother approves the adjustment."],
				"mixed":   ["You turn too sharply and the repositioning draws the predator's attention before the armor discourages it."],
				"fail":    ["You turn your back fully and lose all visibility of the predator's movement."],
			},
			"choice_c": {
				"crit":    ["You stop without panic and your stillness combined with your armor convinces it to find easier ground."],
				"success": ["Stopping and watching drives it away, though you lose the feeding time."],
				"mixed":   ["Stopping doesn't drive it away faster. You sacrifice the feeding for no gain."],
				"fail":    ["You stop eating and freeze and the predator reads your stillness as uncertainty rather than armor."],
			},
			"choice_d": {
				"crit":    ["Your complete indifference to the predator communicates a confidence that reads as armored certainty."],
				"success": ["You keep feeding and the predator circles once more before determining you are not worth the approach."],
				"mixed":   ["Your inattention reads as unawareness rather than confidence and the predator moves closer before your mother redirects it."],
				"fail":    ["You miss the moment the predator commits and your mother has to step in before you have noticed the change."],
			},
		},
	},
	# ── EVENT 6: The Wind Read ────────────────────────────────────────────────
	{
		"intro": [
			"Your mother stops walking and raises her head. She stands still for a long moment with her nostrils wide. Then she turns and walks back the way you came without explanation.",
			"You are moving through the scrub when your mother's pace changes — one deliberate step slower, then a full stop. She reads the wind. You did not smell whatever she smelled.",
			"Without warning your mother reverses direction. The path ahead looks clear. The air does not yet tell you why she changed course.",
		],
		"choices": [
			{ "label": "Stop and try to read the air yourself",     "sublabel": "", "icon": "bond",   "action": "choice_a" },
			{ "label": "Follow her immediately without question",   "sublabel": "", "icon": "stalk",  "action": "choice_b" },
			{ "label": "Keep moving in the original direction",     "sublabel": "", "icon": "flee",   "action": "choice_c" },
			{ "label": "Move upwind to find what she detected",     "sublabel": "", "icon": "attack", "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["You hold still long enough that the air gives you what she was reading. You find it before she turns back to check."],
				"success": ["You slow down and catch part of the scent — enough to understand why she turned."],
				"mixed":   ["You try to read it and miss it, but the effort earns her patience while you catch up."],
				"fail":    ["You stand still smelling nothing useful until she comes back to retrieve you."],
			},
			"choice_b": {
				"crit":    ["You follow without hesitation and she glances back once with something close to approval."],
				"success": ["You trust her read and turn clean, which is the right response even if it isn't the deepest lesson."],
				"mixed":   ["You follow but slowly, and she has to pause to let you keep pace."],
				"fail":    ["You follow, but too far behind, and she reads your hesitation as distrust rather than learning."],
			},
			"choice_c": {
				"crit":    ["You continue and find nothing dangerous. The lesson is that sometimes the air was wrong — but you did not learn to read it."],
				"success": ["You pass through safely but prove only that you got lucky, not that you understood the warning."],
				"mixed":   ["You continue and find exactly what she smelled. You back away slowly, which is the slower version of correct."],
				"fail":    ["You walk directly into what she was steering you around."],
			},
			"choice_d": {
				"crit":    ["You move upwind and find the source before it is dangerous, learning the scent from a safe distance."],
				"success": ["You confirm the threat without entering its range. Your mother reads the initiative correctly."],
			 	"mixed":   ["You get close enough to find it but not close enough to understand what you should have learned to avoid it earlier."],
				"fail":    ["You move toward the danger to investigate it, which is the opposite of the lesson."],
			},
		},
	},
]

func get_juvenile_events() -> Array:
	return JUVENILE_EVENTS
