extends "res://scripts/dinos/base_dino_maternal.gd"

# Ankylosaurus — maternal bond events (female player raising juvenile offspring)
# Fires one event per season while offspring is in juvenile phase.
# 4 choices per event, each with 4 outcome tiers: crit / success / mixed / fail
# Bond delta per tier: Crit +0.25 / Success +0.15 / Mixed +0.05 / Fail -0.10

const MATERNAL_EVENTS: Array = [
	# ── EVENT 1: The Club Correction ─────────────────────────────────────────────
	{
		"intro": [
			"Your offspring has been practicing the club swing. The motion is close but the arc is pulling short and too low. They have repeated the wrong movement enough that it is beginning to settle into habit.",
			"You watch your juvenile attempt the swing for the third time today. The effort is real. The angle is wrong. You have let it go twice already.",
			"The swing is happening in front of you. Your offspring is working at it without asking for help. The problem is visible and they cannot see it from where they are.",
		],
		"choices": [
			{ "label": "Demonstrate the correct arc again",             "sublabel": "", "icon": "bond",   "action": "choice_a" },
			{ "label": "Use your tail to physically guide theirs",      "sublabel": "", "icon": "stalk",  "action": "choice_b" },
			{ "label": "Let them work through it — repetition teaches", "sublabel": "", "icon": "flee",   "action": "choice_c" },
			{ "label": "Stop them and redirect to a different target",  "sublabel": "", "icon": "attack", "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["You demonstrate the full arc slowly, twice, and they watch the loading point and release with full attention. Their next swing carries it. The visual was all they needed."],
				"success": ["Your demonstration gives them a reference point. Their swing improves immediately on the next attempt."],
				"mixed":   ["You demonstrate but they read the speed rather than the angle. Their next attempt is faster but still wrong."],
				"fail":    ["You demonstrate but they are already back to practicing before you finish. The model is ignored."],
			},
			"choice_b": {
				"crit":    ["You use your tail to guide theirs through the full arc. The physical sensation of the correct path teaches them something a visual never could. They repeat it correctly afterward without help."],
				"success": ["Guiding them through it physically gives the correction a body memory. The improvement holds."],
				"mixed":   ["They resist the physical guidance and pull their tail away before completing the arc. The lesson is incomplete."],
				"fail":    ["The attempt to physically guide them produces more resistance than correction. They step away and stop practicing entirely."],
			},
			"choice_c": {
				"crit":    ["You hold back and they find the correction themselves after eight more attempts. It takes longer but it belongs to them entirely now."],
				"success": ["Repetition finds the right arc eventually. The self-correction is slower but it sticks."],
				"mixed":   ["More repetition locks in the wrong motion. By the time you intervene the habit is deeper than before."],
				"fail":    ["Letting them repeat without correction ingrains the error. The wrong arc is now the practiced one."],
			},
			"choice_d": {
				"crit":    ["A different target reveals the problem — the arc was being adjusted to the previous target, not practiced correctly. The new target produces the right swing immediately."],
				"success": ["Changing the target breaks the pattern. They find the right arc on the new surface and can bring it back."],
				"mixed":   ["The different target does not change anything. The wrong arc follows them to the new object."],
				"fail":    ["Stopping them and moving targets reads as failure and they do not return to the practice with any confidence."],
			},
		},
	},
	# ── EVENT 2: The Approaching Predator ────────────────────────────────────────
	{
		"intro": [
			"A mid-size predator has entered the feeding ground at a testing distance — not committed, not retreating. Your offspring has seen it. You are between them.",
			"Something is at the tree line. It has been there long enough that you have read its pattern and know it is working up a decision. Your offspring is still eating and has not fully processed what is standing at the edge.",
			"The predator is there and your offspring knows it. What neither of them knows yet is what you are going to do, and the predator is reading that.",
		],
		"choices": [
			{ "label": "Stop feeding and face toward it together",        "sublabel": "", "icon": "bond",   "action": "choice_a" },
			{ "label": "Press flat with offspring — full armor response", "sublabel": "", "icon": "stalk",  "action": "choice_b" },
			{ "label": "Move offspring between two large rock faces",     "sublabel": "", "icon": "flee",   "action": "choice_c" },
			{ "label": "Continue feeding — present full armor, ignore it", "sublabel": "", "icon": "attack", "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["You stop and face together — two armored bodies, oriented, unmoving. The predator reads too much cost and leaves. Your offspring learns what a united front looks like."],
				"success": ["Facing together works. The predator circles once and moves on. Your offspring held the position alongside you."],
				"mixed":   ["Your offspring faces correctly but keeps shifting weight. The posture is close but not convincing. The predator tests a little longer than it should have."],
				"fail":    ["They turn away from the predator while you are facing it. The split orientation gives it a read on the gap."],
			},
			"choice_b": {
				"crit":    ["Both of you go down fast and clean. The predator approaches once, reads two locked plates, and retreats. Your offspring held the press without instruction."],
				"success": ["The flat armor response from both of you is the right read. The predator does not find an angle worth committing to."],
				"mixed":   ["Your offspring presses but their tail keeps moving. It is enough — barely. The predator retreats but they learned a partial version of the lesson."],
				"fail":    ["They do not press flat with you. They stay upright beside you and the gap between your postures gives the predator information."],
			},
			"choice_c": {
				"crit":    ["You place your offspring between the rock faces perfectly — flanked, armored, no approach angle available. The predator cannot reach them and loses interest."],
				"success": ["The terrain placement works. Your offspring understands they have been positioned, not just moved."],
				"mixed":   ["The placement works but takes time you needed to be facing the predator. You manage both and neither is optimal."],
				"fail":    ["The move to cover reads as flight. The predator tracks the movement and begins to close."],
			},
			"choice_d": {
				"crit":    ["Continued feeding from two armored bodies radiates certainty. The predator cannot find an opening that justifies the cost. Your offspring feeds calmly beside you. The indifference is the armor."],
				"success": ["Your continued feeding communicates that you are not afraid, which is what the predator needed to read."],
				"mixed":   ["Your offspring stops feeding even though you continue. Their change in behavior draws the predator's focus to them."],
				"fail":    ["Your offspring freezes instead of feeding and the contrast between your responses gives the predator a weaker target to test."],
			},
		},
	},
	# ── EVENT 3: Crowded Feeding Ground ──────────────────────────────────────────
	{
		"intro": [
			"Another ankylosaurus — adult, not aggressive — has settled into the feeding area you have been using. There is enough plant cover for both of you but the proximity is new for your offspring.",
			"You find your usual feeding ground occupied by a solitary ankylosaurus. It is not in your face. It is simply there. Your offspring does not know yet what this presence means or how to behave in it.",
			"The other ankylosaurus arrived before you today. It has its head in the low plants and is not watching you. Your offspring is watching it, then watching you, waiting.",
		],
		"choices": [
			{ "label": "Move offspring to a separate patch and feed apart", "sublabel": "", "icon": "flee",   "action": "choice_a" },
			{ "label": "Hold ground — let both feed at the same site",    "sublabel": "", "icon": "bond",   "action": "choice_b" },
			{ "label": "Move between offspring and the other ankylo",     "sublabel": "", "icon": "stalk",  "action": "choice_c" },
			{ "label": "Drive the other ankylosaurus away",               "sublabel": "", "icon": "attack", "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["You move your offspring to a clean separate patch and both of you feed well. The lesson is that feeding ground management is not always about standing your ground."],
				"success": ["Moving to a separate patch avoids unnecessary proximity. Your offspring feeds without stress and learns that alternatives exist."],
				"mixed":   ["The separate patch is thinner. You both feed but less than the contested site would have offered."],
				"fail":    ["The separate patch you move to is not viable. You end up returning to the original site anyway, having lost ground for nothing."],
			},
			"choice_b": {
				"crit":    ["Both ankylosauruses feed without incident. Your offspring learns that shared space with a non-aggressive animal is not a crisis — it is an assessment that resolves quietly."],
				"success": ["Holding ground and feeding normally works. The other ankylosaurus reads the confidence correctly and stays in its area."],
				"mixed":   ["Your offspring positions too close to the other animal and the tension increases before you redirect them."],
				"fail":    ["The proximity escalates into a minor confrontation that disrupts both feeding sessions. You held ground when you should have read the space better."],
			},
			"choice_c": {
				"crit":    ["You position yourself between them and both animals continue feeding. Your offspring sees the buffer without feeling restricted, and the other ankylosaurus has a clear signal about where the boundary is."],
				"success": ["Placing yourself as a buffer works cleanly. The feeding continues and the boundary is maintained without conflict."],
				"mixed":   ["The positioning works but your offspring moves past you twice, requiring correction. Managing them and the other animal at the same time halves your feeding."],
				"fail":    ["Your buffer position is read by the other animal as aggression rather than boundary-setting. It stands its ground and the situation becomes more complicated."],
			},
			"choice_d": {
				"crit":    ["The drive is brief and clear. The other ankylosaurus moves off without escalation and your offspring learns what a territorial assertion looks like when it is warranted."],
				"success": ["You drive them off and the feeding ground returns to yours. The response was appropriate to the situation."],
				"mixed":   ["Driving off a non-aggressive animal was unnecessary and your offspring watches a complicated interaction — you were right to hold the ground, wrong about the threat level."],
				"fail":    ["The drive escalates because the other animal was closer to equal than you read. The confrontation is longer and harder than it should have been."],
			},
		},
	},
	# ── EVENT 4: The Hollow Ground ───────────────────────────────────────────────
	{
		"intro": [
			"Your offspring is moving toward unstable ground. The surface looks solid from their position. You are reading it differently — the color, the way the vegetation sits on it, the absence of animal tracks across it.",
			"The path your offspring is choosing goes over ground that will not hold their weight. They cannot see what you can see from your angle. They are three steps from committing.",
			"You see it before they do. The terrain ahead is wrong. Light rain has hidden the worst of it and your juvenile has not learned to read this yet.",
		],
		"choices": [
			{ "label": "Block their path physically and redirect",      "sublabel": "", "icon": "bond",   "action": "choice_a" },
			{ "label": "Stop and read the ground with them",            "sublabel": "", "icon": "stalk",  "action": "choice_b" },
			{ "label": "Let them discover the instability themselves",  "sublabel": "", "icon": "flee",   "action": "choice_c" },
			{ "label": "Move ahead to safer ground without explaining", "sublabel": "", "icon": "attack", "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["You move into their path and turn them before they step on the bad ground. Then you stand beside it and let them look. The nearness of the mistake makes the lesson real."],
				"success": ["The physical block works. They stop, read your posture, and understand that stopping mattered."],
				"mixed":   ["The block stops them but they do not understand why. They look at the ground you blocked and see nothing that would have told them."],
				"fail":    ["They push past your block before you complete it. They step onto the unstable surface and sink before you can intervene."],
			},
			"choice_b": {
				"crit":    ["You stop beside the ground and they stop with you. You look down at it and they follow your attention. They find what you are reading — the color shift, the way it gives under a step. They name it before you do."],
				"success": ["Reading the ground together gives them the analytical framework. They identify the instability with help and that matters more than being told."],
				"mixed":   ["You read it together but they only partially understand what you are pointing to. They would have caught it too late on their own."],
				"fail":    ["They stop with you but cannot identify what you are reading. You explain and they nod but you are not sure it landed."],
			},
			"choice_c": {
				"crit":    ["They step on the edge of it, feel it give, and step back immediately. Not deep enough to be dangerous — just enough to be real. They read the full patch from a safe distance afterward."],
				"success": ["The light sink before they pull back teaches in a way no amount of explanation would. They are more careful after this."],
				"mixed":   ["They sink deeper than you intended before they recognize the problem. You pull them out without injury but the lesson was rougher than necessary."],
				"fail":    ["They commit fully before reading the give and are in it up to their legs before you reach them."],
			},
			"choice_d": {
				"crit":    ["You move to safe ground without explaining and they follow your path exactly — because they always watch your steps. The route teaches without narration."],
				"success": ["They follow your line without needing to know why. Learning to track your movement is its own lesson."],
				"mixed":   ["They follow your path but drift off it halfway through and step onto the bad ground despite the example."],
				"fail":    ["They do not track your path. They choose their own line and step directly onto the ground you avoided."],
			},
		},
	},
	# ── EVENT 5: Armor Response Training ─────────────────────────────────────────
	{
		"intro": [
			"Your offspring is resting, not paying full attention to the edges of the space. You are considering whether to create a test. The response time has been slow lately and a slow press-flat is a dangerous press-flat.",
			"The juvenile has grown comfortable in the home range and their alarm response has gotten slower. You have seen it twice this week. A controlled test would address it before something else does.",
			"You have been watching your offspring's response to sudden sounds and movement. It needs work. They are old enough now that the adjustment has to happen deliberately.",
		],
		"choices": [
			{ "label": "Make a sudden loud sound nearby and observe",    "sublabel": "", "icon": "attack", "action": "choice_a" },
			{ "label": "Approach them fast from outside their sightline", "sublabel": "", "icon": "stalk", "action": "choice_b" },
			{ "label": "Move a heavy object at the edge of their range", "sublabel": "", "icon": "flee",   "action": "choice_c" },
			{ "label": "Wait for a real event to test the response",     "sublabel": "", "icon": "bond",   "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["They drop immediately, fast and flat. The response is better than you expected. You hold still afterward to signal safety and they release. The drill is already a memory."],
				"success": ["The sound produces a press-flat quickly enough. They hold it and look for you before releasing. The response works."],
				"mixed":   ["They drop, but slowly. The problem you identified is real and one test has not fixed it."],
				"fail":    ["They startle upright instead of pressing flat. The instinct is still wrong. The test revealed more than you expected."],
			},
			"choice_b": {
				"crit":    ["They hear you before you arrive and drop before you reach them. The perimeter awareness has improved on its own. The test confirms what you hoped."],
				"success": ["The fast approach from outside their sightline produces a correct response. They press and hold until you signal."],
				"mixed":   ["They detect you too early — because they know it is you — and the response is half-formed rather than reflexive."],
				"fail":    ["They see you coming and the test becomes play rather than drill. The response you needed to see does not happen."],
			},
			"choice_c": {
				"crit":    ["The movement at the edge produces an immediate response and they track the source without exposing themselves. The ambiguity of the stimulus makes the test more real than the obvious ones."],
				"success": ["Indirect stimulus produces a clean response. They press and orient toward the movement correctly."],
				"mixed":   ["They investigate the sound instead of pressing flat. The instinct to look before dropping is still overriding the armor response."],
				"fail":    ["The ambiguous stimulus confuses rather than tests. They freeze between investigation and armor response and do neither."],
			},
			"choice_d": {
				"crit":    ["The real event that comes is small enough to be useful — a minor predator passing through — and they respond correctly on their own. You did not need to manufacture the test."],
				"success": ["Waiting for real conditions means the test has no artificiality. They respond to the actual situation and the response is what you needed to see."],
				"mixed":   ["The real event that arrives is larger than a good training scenario and the stakes are higher than you wanted for this lesson."],
				"fail":    ["Nothing useful comes in the window you wait. The slow response remains unaddressed for another season."],
			},
		},
	},
	# ── EVENT 6: Separation ───────────────────────────────────────────────────────
	{
		"intro": [
			"Your offspring is gone from your immediate range. Not far — you can read their direction from the tracks and the disturbed brush — but further than is comfortable for where they are.",
			"You have not seen your offspring for two hours. The home range is large enough to lose them in and they have been exploring the edges more as the season goes on. This time they went further.",
			"Your juvenile has moved beyond visual range for the first time. The direction they went is not dangerous, but the distance is larger than it should be at their stage.",
		],
		"choices": [
			{ "label": "Move steadily toward their last position",     "sublabel": "", "icon": "bond",   "action": "choice_a" },
			{ "label": "Hold your position — let them find their way back", "sublabel": "", "icon": "stalk", "action": "choice_b" },
			{ "label": "Use a low call to bring them back",            "sublabel": "", "icon": "flee",   "action": "choice_c" },
			{ "label": "Increase your own movement to intercept early", "sublabel": "", "icon": "attack", "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["You move at a steady pace without alarm and find them within the range you expected. They see you arrive and read the steadiness as safety rather than panic. You both return together."],
				"success": ["Moving toward them brings you together without drama. The reunion is uneventful and that is the right version of it."],
				"mixed":   ["You move toward their position but they have moved again. The search takes longer than a steadier tracking read would have."],
				"fail":    ["You move toward their last position but the tracking is wrong and you search in the wrong direction before correcting."],
			},
			"choice_b": {
				"crit":    ["They find their way back on their own. When they arrive they are not alarmed — just returning. The independence they just exercised was real and successful."],
				"success": ["Holding your position lets them navigate back. They arrive knowing the range a little better than they did."],
				"mixed":   ["They take longer than the distance should require. When they return, something unplanned happened during the navigation and it was close."],
				"fail":    ["They cannot find their way back from this distance. You eventually have to go to them rather than waiting any longer."],
			},
			"choice_c": {
				"crit":    ["The call reaches them and they return without any other information given. The recall response is clean and will be there the next time you need it."],
				"success": ["The low call brings them back. The signal works and the bond behind it is clear in how quickly they respond."],
				"mixed":   ["They hear the call and return, but slowly. The recall instinct is there but not sharp."],
				"fail":    ["The call does not reach them at this distance or they do not recognize it as a recall. You have to go to them."],
			},
			"choice_d": {
				"crit":    ["You intercept them before the distance becomes a concern. The interception is calm and you reroute them back without alarm. They do not know they were being retrieved."],
				"success": ["Intercepting early keeps the situation from becoming anything. You find them in time and return together cleanly."],
				"mixed":   ["You move fast enough to find them but the urgency in your approach reads as alarm to them. They become anxious for the rest of the day."],
				"fail":    ["You push your movement to intercept and miss them — they have circled back and you are now the one who is further from the home range."],
			},
		},
	},
]

func get_maternal_events() -> Array:
	return MATERNAL_EVENTS
