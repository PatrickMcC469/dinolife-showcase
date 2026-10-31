extends "res://scripts/dinos/base_dino_maternal.gd"

# Allosaurus — maternal bond events (female player raising juvenile offspring)
# Fires one event per season while offspring is in juvenile phase.
# 4 choices per event, each with 4 outcome tiers: crit / success / mixed / fail
# Bond delta per tier: Crit +0.25 / Success +0.15 / Mixed +0.05 / Fail -0.10

const MATERNAL_EVENTS: Array = [
	# ── EVENT 1: Reading the Herd ─────────────────────────────────────────────────
	{
		"intro": [
			"A sauropod group has moved into your hunting ground. Your offspring is watching you. They want to see which animal you choose. They have not yet learned that the choosing is the whole hunt.",
			"The prey herd is ahead of you, grazing and moving. Your offspring stands beside you and reads your stillness as a signal. You are not still for no reason.",
			"You have the herd in front of you and your juvenile behind you. They have watched you hunt. They have not yet watched you decide not to.",
		],
		"choices": [
			{ "label": "Move to show the weak animal with your body",   "sublabel": "", "icon": "bond",   "action": "choice_a" },
			{ "label": "Circle the herd edge slowly — let them read it", "sublabel": "", "icon": "stalk", "action": "choice_b" },
			{ "label": "Pass this herd and find better conditions",     "sublabel": "", "icon": "flee",   "action": "choice_c" },
			{ "label": "Commit to the best-looking animal and show them how", "sublabel": "", "icon": "attack", "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["You angle toward the weak animal without rushing, and your offspring reads your body before they understand why. When the animal separates, they already knew it would."],
				"success": ["Your positioning teaches the selection before you name it. They learn to see the herd the way you do."],
				"mixed":   ["You show them the target but your angle is unclear. They watch but do not take away the lesson you intended."],
				"fail":    ["You orient toward the wrong animal and your offspring learns the wrong read. The error compounds rather than teaches."],
			},
			"choice_b": {
				"crit":    ["The slow circuit around the herd edge teaches them to read the whole group before committing to any part of it. They are quiet and attentive the full way around."],
				"success": ["Circling first shows them patience as skill. They hold the pace alongside you and begin to read what you're reading."],
				"mixed":   ["The circuit is too slow and the herd moves away before you close the distance. You demonstrate patience at the cost of the hunt."],
				"fail":    ["The long approach spooks a herd edge animal early and the group closes ranks. The best window is gone before you showed them what it was."],
			},
			"choice_c": {
				"crit":    ["You read the conditions correctly — terrain, herd density, positioning — and move on. Your offspring follows without questioning. They are learning when not to commit."],
				"success": ["Passing this herd teaches selectivity. They see you leave a hunt and begin to understand that choosing nothing is also a choice."],
				"mixed":   ["They push forward slightly as you leave. They do not understand the pass. You redirect them but the reason is not fully clear to them."],
				"fail":    ["Passing the herd reads as hesitation rather than judgment. They hang at the edge, unwilling to follow, and you have to retrieve them."],
			},
			"choice_d": {
				"crit":    ["You commit fully and bring it down cleanly. The combination of speed, angle, and decisive contact is the whole lesson in action. They watch a good hunt."],
				"success": ["A clean committed strike works and they see it. Not every hunt needs patience — sometimes the execution is the teaching."],
				"mixed":   ["You commit but the hunt takes longer than it should. The prey fights back and the juvenile sees more struggle than technique."],
				"fail":    ["The commitment doesn't land cleanly and the prey escapes. Your offspring watched a failed hunt without learning what to do differently."],
			},
		},
	},
	# ── EVENT 2: The Interrupted Hunt ────────────────────────────────────────────
	{
		"intro": [
			"You brought prey down, but it cost you more than it should have. You took a hit in the approach. You are not badly injured, but you are winded and the juvenile watched all of it.",
			"The hunt worked. The prey is down. But the effort showed — your gait is different, your breathing harder than usual. Your offspring has not seen you come back from a hunt like this.",
			"A successful kill that required a second approach and a closer contact than you planned. You are at the carcass. Your offspring is close. They are reading what they just watched.",
		],
		"choices": [
			{ "label": "Feed together and let them observe the kill",  "sublabel": "", "icon": "bond",   "action": "choice_a" },
			{ "label": "Send them away while you recover",             "sublabel": "", "icon": "flee",   "action": "choice_b" },
			{ "label": "Let them approach the carcass alone first",    "sublabel": "", "icon": "stalk",  "action": "choice_c" },
			{ "label": "Walk them through the approach afterward",     "sublabel": "", "icon": "attack", "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["You feed together and they read the effort in your body without you naming it. They understand that a successful hunt is not always clean. The observation sticks."],
				"success": ["Feeding together after a hard hunt normalizes the cost of it. They see you eat and recover without drama."],
				"mixed":   ["They feed but keep checking your injury rather than eating. The concern is real but they will not learn to manage it well today."],
				"fail":    ["They will not approach the kill while you are visibly winded. The worry overtakes the lesson and neither of you feeds properly."],
			},
			"choice_b": {
				"crit":    ["You send them to a clear distance and they go. When you rejoin them later, rested and full, your steadiness after struggle teaches more than any explanation would have."],
				"success": ["Recovery done privately is the right call today. You return to them in better shape and they see the restoration without witnessing the full cost."],
				"mixed":   ["They watch from further than you sent them and the separation reads as something more serious than it is."],
				"fail":    ["They do not go to the distance you indicated. You spend recovery time repositioning them rather than resting."],
			},
			"choice_c": {
				"crit":    ["They approach the carcass alone and claim it for the first time. You recover at distance and let them have the moment. It is a good trade."],
				"success": ["Giving them the first approach while you recover is the right balance. They get the independence and you get the rest you need."],
				"mixed":   ["They approach but keep looking back at you. The focus is split. They are eating and worrying at the same time."],
				"fail":    ["They will not approach alone while you are injured. The opportunity collapses and neither of you feeds."],
			},
			"choice_d": {
				"crit":    ["You walk them through what just happened — where the first approach was wrong, where the second was necessary. They receive it and retain it. You feel better for having said it."],
				"success": ["Reviewing the hunt teaches them to think about what they observe. They are learning to process hunts, not just watch them."],
				"mixed":   ["The review is real but you are still winded and they can feel it. The lesson competes with their attention to your state."],
				"fail":    ["You are too tired to make the review land. It comes out fragmented and they are more focused on your injury than your words."],
			},
		},
	},
	# ── EVENT 3: Territory Marking Together ──────────────────────────────────────
	{
		"intro": [
			"You need to mark the boundary this season. Your offspring is old enough to follow the full circuit. You are deciding whether they observe or participate.",
			"The territory edge has not been marked in two seasons. Your offspring knows the core range but has not walked the full claim. Today could change that.",
			"Time to mark the territory. Your offspring is at your side and watching how you begin. What you do next will show them what holding ground actually means.",
		],
		"choices": [
			{ "label": "Mark the full boundary with them watching",     "sublabel": "", "icon": "bond",   "action": "choice_a" },
			{ "label": "Show them the key approaches, then mark those", "sublabel": "", "icon": "stalk",  "action": "choice_b" },
			{ "label": "Have them mark beside you at each point",       "sublabel": "", "icon": "attack", "action": "choice_c" },
			{ "label": "Mark the interior and leave the edge for later", "sublabel": "", "icon": "flee",  "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["The full circuit with them observing every mark gives them a mental map they will carry. They understand the shape of what you hold."],
				"success": ["Watching the complete marking teaches them where the territory ends and what that means. They are quieter when you finish than when you started."],
				"mixed":   ["They watch but lose focus partway through the circuit. The later marks go in without their attention."],
				"fail":    ["They stop observing after the first few marks. The rest of the circuit is done without any teaching benefit."],
			},
			"choice_b": {
				"crit":    ["Showing only the key approaches gives them the most important information without requiring the whole circuit. Efficient and well-read."],
				"success": ["Prioritizing the entry points is the right call. They learn where the contested edges are and why those marks matter most."],
				"mixed":   ["Focusing only on the key points leaves gaps in their understanding of the full shape. They know the edge but not the whole."],
				"fail":    ["The selection of key points is incomplete. You mark the approaches they saw but miss one that is actually the most used entry."],
			},
			"choice_c": {
				"crit":    ["They mark alongside you and each point becomes theirs as much as yours. When the circuit is done, they have staked something real for the first time."],
				"success": ["Shared marking builds ownership. They contributed to the territory claim and the investment is visible in how they hold themselves at the edge."],
				"mixed":   ["They mark but lightly, without conviction. You have to redo most of it. The lesson was real but the result is weak."],
				"fail":    ["They mark incorrectly at several points and the claim is inconsistent. You will need to redo the circuit without them."],
			},
			"choice_d": {
				"crit":    ["Marking the interior first and returning to the edge later is a sound tactical read. They learn to prioritize the core before the boundary."],
				"success": ["The inside-out approach works. The core territory is secured and the edge can wait. They see a strategy, not just a habit."],
				"mixed":   ["The edge gets marked too late in the day and the quality is lower. The interior is strong but the message at the boundary is weak."],
				"fail":    ["You never return to mark the edge. The interior is marked but the claim is incomplete and the delay shows."],
			},
		},
	},
	# ── EVENT 4: Rest Discipline ──────────────────────────────────────────────────
	{
		"intro": [
			"Your offspring wants to move. You have been still for two hours reading the morning air and they are restless. The conditions are not right to hunt yet and they cannot feel that.",
			"The midday heat is wrong for an approach. Your offspring has already tested your patience twice today. They do not understand why the waiting matters.",
			"You have read something in the light and the wind that tells you this is not the time to move. Your offspring does not share your read. They are ready to go.",
		],
		"choices": [
			{ "label": "Hold them in place — make the waiting clear",     "sublabel": "", "icon": "bond",   "action": "choice_a" },
			{ "label": "Let them move a short range and recall them",     "sublabel": "", "icon": "flee",   "action": "choice_b" },
			{ "label": "Match their pace and redirect gradually",         "sublabel": "", "icon": "stalk",  "action": "choice_c" },
			{ "label": "Name what you are reading — give them the reason", "sublabel": "", "icon": "attack", "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["They accept the stillness eventually. When the conditions shift and you move, they feel the difference. The waiting becomes legible in the result."],
				"success": ["Holding them in place teaches discipline even if the reason isn't clear to them yet. They hold."],
				"mixed":   ["They hold, but barely. The tension between their restlessness and your instruction leaves both of you less focused."],
				"fail":    ["They do not hold. The instruction fails and you move before the conditions are right to prevent them from going alone."],
			},
			"choice_b": {
				"crit":    ["You let them exhaust the restlessness in a short range and when you recall them they come back settled. They hold the stillness that follows."],
				"success": ["A managed release works. The short movement gives them something and the recall lands."],
				"mixed":   ["They move further than the range you gave and the recall brings them back unsettled rather than ready."],
				"fail":    ["They do not come back at the recall. The short range becomes a problem that costs you the full waiting window."],
			},
			"choice_c": {
				"crit":    ["Matching their pace and redirecting gradually brings them to stillness without a direct confrontation. They do not know you just managed them and that is the point."],
				"success": ["The gradual redirect works. They are still without feeling held down."],
				"mixed":   ["The gradual approach takes longer than the stillness was worth. By the time they settle, the window has partly passed."],
				"fail":    ["Matching their pace reads as permission to move. The redirect is too subtle and they take it as agreement."],
			},
			"choice_d": {
				"crit":    ["You name the wind direction and the light position and the heat. They cannot read all of it yet, but they understand you are reading something. The next time conditions change they will look for what you looked for."],
				"success": ["Giving the reason builds a framework they can use later even if it doesn't fully land today."],
				"mixed":   ["You explain but they cannot follow all of it. The explanation keeps them engaged but they are waiting for you to finish rather than learning."],
				"fail":    ["The explanation goes nowhere. They are not at the stage where the reasoning translates. They are still restless when you are done."],
			},
		},
	},
	# ── EVENT 5: The Rival's Young ────────────────────────────────────────────────
	{
		"intro": [
			"Another Allosaurus juvenile — not yours, not under your protection — has wandered into your territory. It is not an adult. It is not threatening. It is just here, and your offspring is looking at it.",
			"A juvenile from another range has entered your ground. It appears to be alone. Your offspring has seen it. They are not sure what it means. Neither are you yet.",
			"Your offspring found the intruder first. They have not moved toward it yet. They are watching it and watching you, unsure which direction to take their cue from.",
		],
		"choices": [
			{ "label": "Drive it out while your offspring watches",     "sublabel": "", "icon": "attack", "action": "choice_a" },
			{ "label": "Ignore it and move your group away",            "sublabel": "", "icon": "flee",   "action": "choice_b" },
			{ "label": "Let your offspring decide how close to get",    "sublabel": "", "icon": "stalk",  "action": "choice_c" },
			{ "label": "Intercept before they meet",                    "sublabel": "", "icon": "bond",   "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["You drive the intruder out with minimum effort and your offspring reads the whole signal: this ground is yours and the cost of crossing it is real."],
				"success": ["The drive is clean and your offspring watches a territorial boundary be enforced. The lesson is simple and clear."],
				"mixed":   ["The drive takes more effort than the intruder warranted. Your offspring reads more alarm than assertion in the response."],
				"fail":    ["The drive is too aggressive for the situation and your offspring backs away from the intensity rather than learning from it."],
			},
			"choice_b": {
				"crit":    ["Moving away from a juvenile intruder reads as territorial confidence — not worth engaging, not worth acknowledging. Your offspring follows the signal."],
				"success": ["Ignoring the intruder and moving away is the right call. Not every presence requires a response."],
				"mixed":   ["Your offspring follows but keeps looking back at the intruder. They are not sure the ignore was intentional or a miss."],
				"fail":    ["They do not move away with you. They stay and investigate the intruder while you are already gone."],
			},
			"choice_c": {
				"crit":    ["You give them the decision and they hold back with good instinct — watching, reading, not approaching. They chose correctly without being told."],
				"success": ["They approach carefully and the interaction is neutral. You let them navigate a real situation and they do reasonably well."],
				"mixed":   ["They approach too quickly and the intruder bolts. Your offspring gave away everything before reading anything."],
				"fail":    ["They move in without any caution and the interaction escalates into something you have to step in and stop."],
			},
			"choice_d": {
				"crit":    ["You intercept before they meet and the message is clean: you manage the territory boundary, not the juvenile. Your offspring holds back and watches you do it."],
				"success": ["Intercepting early keeps control of the situation. Your offspring sees the boundary maintained without drama."],
				"mixed":   ["You intercept but your offspring moves around you to reach the intruder anyway. The interception was the wrong move."],
				"fail":    ["You intercept and the situation becomes more complicated than if you had let them meet briefly and move on."],
			},
		},
	},
	# ── EVENT 6: Failed Hunt Return ───────────────────────────────────────────────
	{
		"intro": [
			"The hunt failed. You tracked for three hours and came back empty. Your offspring has been waiting. They are hungry and they can see from your approach that you did not bring anything back.",
			"Nothing. A long hunt in the wrong conditions and nothing to show for it. You are returning to a juvenile who has been still and waiting and is now watching you come back empty.",
			"You left this morning expecting to return with prey. The prey read you first and the approach never landed. Your offspring sees you from a distance and begins to understand something from your posture before you arrive.",
		],
		"choices": [
			{ "label": "Lead them immediately toward secondary prey",   "sublabel": "", "icon": "bond",   "action": "choice_a" },
			{ "label": "Settle them down — rest before trying again",  "sublabel": "", "icon": "flee",   "action": "choice_b" },
			{ "label": "Show them what you found and why it failed",   "sublabel": "", "icon": "stalk",  "action": "choice_c" },
			{ "label": "Let the hunger drive the next hunt together",  "sublabel": "", "icon": "attack", "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["You find secondary prey quickly and the failed hunt becomes unremarkable in the result. They learn that a missed hunt does not end the day."],
				"success": ["Immediate redirection keeps momentum. The failure is not dwelled on and the solution is practical."],
				"mixed":   ["The secondary prey is poor and the second attempt exhausts more than it gains. The failure compounds."],
				"fail":    ["You push immediately into a second hunt in bad condition and it fails. The offspring is now hungrier and watching a second empty return."],
			},
			"choice_b": {
				"crit":    ["Rest before retrying is the right read. You both recover and the second attempt is fresher. They learn that pausing is not quitting."],
				"success": ["Resting first produces a better second hunt. The lesson that recovery precedes performance is one they needed."],
				"mixed":   ["The rest takes longer than the hunger allows. They are restless and anxious by the time you try again."],
				"fail":    ["The rest delays too long. The best hunting window passes and the second attempt also fails."],
			},
			"choice_c": {
				"crit":    ["You take them to where the hunt failed and read it together — the wind line, the terrain, where the error was made. They ask nothing but they absorb everything."],
				"success": ["Reviewing the failure is the honest version of the lesson. They learn that a T-Rex reads what went wrong."],
				"mixed":   ["The review is attempted but too much of it was instinctive for you to put into terms they can follow. It does not land."],
				"fail":    ["You cannot explain the failure clearly because you do not fully understand it yourself. The review teaches nothing and produces no food."],
			},
			"choice_d": {
				"crit":    ["You let the shared hunger sharpen both of you. When you hunt together the edge is real, the approach is faster, and the kill goes down cleanly. Hunger as fuel."],
				"success": ["Hunting together from a position of need works. The cooperation is messy but effective. They contributed to a real result."],
				"mixed":   ["Hunting together hungry produces something but the effort is disorganized. They learn to work alongside you but not yet how."],
				"fail":    ["Hunting together while exhausted and hungry makes the failure worse. The disorganization costs the attempt."],
			},
		},
	},
]

func get_maternal_events() -> Array:
	return MATERNAL_EVENTS
