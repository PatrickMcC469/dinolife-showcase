extends "res://scripts/dinos/base_dino_maternal.gd"

# T-Rex — maternal bond events (female player raising juvenile offspring)
# Fires one event per season while offspring is in juvenile phase.
# 4 choices per event, each with 4 outcome tiers: crit / success / mixed / fail
# Bond delta per tier: Crit +0.25 / Success +0.15 / Mixed +0.05 / Fail -0.10

const MATERNAL_EVENTS: Array = [
	# ── EVENT 1: The Practice Strike ─────────────────────────────────────────────
	{
		"intro": [
			"Your offspring circles the carcass slowly. They have been watching you bring things down since they could walk. Now they want to try. You have not told them to stop.",
			"The juvenile approaches the kill you left and tests it with their mouth — wrong angle, wrong grip, no real bite. They do not know that yet. You are deciding how much to let them learn on their own.",
			"Your offspring is attempting something at the carcass. The effort is real. The result is not right. You are close enough to step in or far enough to watch.",
		],
		"choices": [
			{ "label": "Watch from distance — let them work it",   "sublabel": "", "icon": "bond",   "action": "choice_a" },
			{ "label": "Move in and show the angle directly",      "sublabel": "", "icon": "stalk",  "action": "choice_b" },
			{ "label": "Move them to a smaller piece first",       "sublabel": "", "icon": "flee",   "action": "choice_c" },
			{ "label": "Take the kill back — wrong time for this", "sublabel": "", "icon": "attack", "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["They find the right angle themselves after several tries. You did not have to say anything. They look up and you are still there."],
				"success": ["They get something close to right eventually. The independence will serve them. You gave them space when they needed it."],
				"mixed":   ["They struggle longer than you should have allowed. The effort was real but the lesson was incomplete."],
				"fail":    ["They give up before finding anything. You waited too long and they walked away frustrated without learning what the carcass had to teach."],
			},
			"choice_b": {
				"crit":    ["Your positioning shows them exactly where the grip should go. They mirror it immediately and the contact is clean."],
				"success": ["You guide them into a better angle and the improvement is obvious. The lesson lands."],
				"mixed":   ["You step in too quickly and they pull back rather than watch. You do the work and they observe without participating."],
				"fail":    ["You move in and they move away. Too much presence too soon. They do not try again while you are standing over the kill."],
			},
			"choice_c": {
				"crit":    ["The smaller piece gives them a success they can feel. When they return to the larger carcass the angle is already different."],
				"success": ["Starting smaller builds the right foundation. They move to the full kill with something they did not have before."],
				"mixed":   ["The small piece is enough to satisfy them. They do not go back to the larger one today. The harder lesson waits."],
				"fail":    ["They dismiss the smaller piece and return to the original problem unchanged. The redirect did not take."],
			},
			"choice_d": {
				"crit":    ["You reclaim the kill cleanly and they read the signal correctly — this is not the time. They will be readier when you give it back."],
				"success": ["Taking the kill back sets a clear boundary. They do not push it. The patience you require will pay into something later."],
				"mixed":   ["They resist briefly before backing off. The message landed but without the lesson you wanted them to take from it."],
				"fail":    ["Taking the kill back produces only frustration. They do not understand why and you give them no answer."],
			},
		},
	},
	# ── EVENT 2: The Rival Scent ──────────────────────────────────────────────────
	{
		"intro": [
			"You pick it up at the edge of your territory — another T-Rex, adult, has marked the tree line within the last day. Your offspring is close behind you. They have not read it yet.",
			"The marks are fresh. A rival has tested your boundary while you were away from this edge. Your offspring stands beside you, reads your stillness, and waits.",
			"Something large was here. The signs are clear to you and becoming clear to your offspring. They look between the marks and you, trying to read what you will do.",
		],
		"choices": [
			{ "label": "Mark over it immediately — let them watch",  "sublabel": "", "icon": "attack", "action": "choice_a" },
			{ "label": "Read the depth of the intrusion before acting", "sublabel": "", "icon": "stalk", "action": "choice_b" },
			{ "label": "Move your offspring away from the boundary",  "sublabel": "", "icon": "flee",   "action": "choice_c" },
			{ "label": "Hold still and listen before deciding",       "sublabel": "", "icon": "bond",   "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["You mark over it completely and deliberately. Your offspring watches the whole process and understands: this is how territory is answered."],
				"success": ["Your marks go down clean and the response is clear. The rival will read the counter when they return."],
				"mixed":   ["You mark quickly but your offspring reads your urgency as alarm rather than assertion. The lesson is partly wrong."],
				"fail":    ["You respond before you've read how serious the intrusion is. Your offspring mirrors your haste and learns the wrong speed."],
			},
			"choice_b": {
				"crit":    ["You read the full situation — age, direction, how recently — and respond with exactly the right weight. Your offspring sees measured judgment in action."],
				"success": ["The pause before action teaches something about reading rather than reacting. Your offspring holds still beside you."],
				"mixed":   ["The extra time costs you the scent trail. You read less than you would have if you'd moved sooner."],
				"fail":    ["You take too long reading and the rival has already pushed further in from another angle you weren't watching."],
			},
			"choice_c": {
				"crit":    ["You place your offspring well back from the edge and handle the boundary alone. They learn that some things are done without them — for now."],
				"success": ["Moving them back is the right call. They watch from a safe distance and understand where the boundary is."],
				"mixed":   ["They resist being moved and you have to push them back twice. The moment is divided by the management of them."],
				"fail":    ["Moving them backward reads as retreat to both of you. The lesson you give is the wrong one."],
			},
			"choice_d": {
				"crit":    ["Your complete stillness reads the situation fully before any action. When you finally move your offspring, they have learned what waiting sounds like."],
				"success": ["Listening first teaches that presence is information. You identify what you needed before committing to a response."],
				"mixed":   ["You hold still long enough that your offspring gets restless and moves forward before you're ready. You have to intervene."],
				"fail":    ["Holding still reads as hesitation. Your offspring tests the boundary on their own while you're still deciding."],
			},
		},
	},
	# ── EVENT 3: First Full Absence ───────────────────────────────────────────────
	{
		"intro": [
			"The prey range has pushed further than a half-day circle. Your offspring is old enough to hold territory alone. This is the first time they will need to.",
			"A good hunt requires distance. You have been choosing prey inside your range to avoid leaving the juvenile alone, but the nearby options are thinning. Today that changes.",
			"Your offspring watches you prepare to leave. They know you are going further than usual. You know it too. How you leave matters.",
		],
		"choices": [
			{ "label": "Mark the full territory boundary before you go", "sublabel": "", "icon": "bond",   "action": "choice_a" },
			{ "label": "Leave without ceremony — distance is normal",    "sublabel": "", "icon": "stalk",  "action": "choice_b" },
			{ "label": "Shorten the hunt and return before dark",        "sublabel": "", "icon": "flee",   "action": "choice_c" },
			{ "label": "Take them to the edge of the range before you leave", "sublabel": "", "icon": "attack", "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["You mark every approach before you leave. When you return, your offspring is exactly where you left them. They held the ground cleanly."],
				"success": ["The marked boundary gives them something clear to protect while you're gone. The territory holds."],
				"mixed":   ["The marks take long enough that you miss the prey window. You return without a kill but the juvenile managed fine."],
				"fail":    ["Even with all approaches marked they still wandered too far. The marks weren't what they needed."],
			},
			"choice_b": {
				"crit":    ["You leave as if it is nothing, and they take the signal correctly — this is routine. When you return they have held the space without anxiety."],
				"success": ["The casual departure steadies them. They spend the day normally rather than waiting in place."],
				"mixed":   ["Your lack of ceremony reads as indifference rather than confidence. They spend the day watching the direction you left."],
				"fail":    ["They follow you for the first stretch before you redirect them. The 'normal' departure only works if they believe it."],
			},
			"choice_c": {
				"crit":    ["You find a faster kill at closer range and return by midday. The short absence is enough to test and pass without strain."],
				"success": ["Returning early works this time. The juvenile held well and you got something from the hunt."],
				"mixed":   ["You compromise the hunt for the return time and come back with less. The juvenile was fine — but your judgment cost you food."],
				"fail":    ["Shortening the hunt gets you nothing. You return without a kill and your offspring sees you come back empty."],
			},
			"choice_d": {
				"crit":    ["You walk them to the range edge and show them where the boundary lies. They return to the core territory on their own and hold it well."],
				"success": ["Showing them the edge gives them a mental map. They understand what they're holding and do it well."],
				"mixed":   ["Taking them to the edge uses time you needed for the hunt. You arrive at the prey range late and miss the best window."],
				"fail":    ["Walking them to the boundary takes so long the hunt produces nothing. They saw the edge but learned it at cost."],
			},
		},
	},
	# ── EVENT 4: Feeding Order ────────────────────────────────────────────────────
	{
		"intro": [
			"You have a fresh kill. Your offspring is right behind you and they are hungry — but a T-Rex does not share a kill. A T-Rex learns to claim one.",
			"The carcass is down. Your offspring moves toward it immediately, the way they have been when smaller. At their current size and age, that is no longer the right lesson.",
			"Fresh prey, your effort, your kill. Your offspring reads entitlement in your return. You brought it down. They watched. How this goes now sets something for every kill after this one.",
		],
		"choices": [
			{ "label": "Yield the first approach so they learn to claim", "sublabel": "", "icon": "bond",   "action": "choice_a" },
			{ "label": "Feed together — they are still your young",       "sublabel": "", "icon": "flee",   "action": "choice_b" },
			{ "label": "Feed first fully, then move aside",               "sublabel": "", "icon": "stalk",  "action": "choice_c" },
			{ "label": "Drive them to the edges to feed on scraps",       "sublabel": "", "icon": "attack", "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["They approach the kill with proper weight for the first time — head up, posture correct. They are claiming, not waiting for permission. The lesson takes."],
				"success": ["They approach and feed. The independence is rough but real. You gave them the space to learn how a T-Rex moves to a kill."],
				"mixed":   ["They approach but then look back at you before feeding. The claim is still conditional. The habit will need more seasons."],
				"fail":    ["They approach but panic when you don't follow. They back off and circle rather than claiming. The moment was wasted."],
			},
			"choice_b": {
				"crit":    ["They are still young enough that feeding together builds something. The closeness today becomes security tomorrow."],
				"success": ["Feeding together works for now. There will be time for the harder lesson when they are older."],
				"mixed":   ["They feed beside you but expect this every kill. You have delayed a lesson they will need before they are ready for it."],
				"fail":    ["They read togetherness as permanence. The expectation of shared kills is setting in harder than it should."],
			},
			"choice_c": {
				"crit":    ["You feed fully and move aside cleanly. They approach without any hesitation when the space opens. The right order is established."],
				"success": ["Feeding first and yielding afterward teaches the hierarchy clearly. They get food and a real lesson in the same turn."],
				"mixed":   ["You feed first but stay too close when you move aside. They hang back rather than claiming. The space was not really given."],
				"fail":    ["You feed so long there is little left worth claiming. They approach a poor remainder and learn nothing useful."],
			},
			"choice_d": {
				"crit":    ["The relegation to scraps sharpens their hunger into something useful. Next time they will be faster to the edge of any kill, working harder for what they can reach."],
				"success": ["Hard conditions produce real effort. They work the edges and get something. The lesson is blunt but it lands."],
				"mixed":   ["The relegation is too severe for where they are. They do not understand it as a lesson. They understand it as rejection."],
				"fail":    ["Driving them away reads only as abandonment. The hunger and the confusion sit together and teach nothing."],
			},
		},
	},
	# ── EVENT 5: The Overcommit ───────────────────────────────────────────────────
	{
		"intro": [
			"Your offspring has spotted something too large for them and started moving. They have not hunted this before. They do not know the size difference yet.",
			"The juvenile has committed to a pursuit. You see immediately what they do not — this prey will hurt them before it goes down, if it goes down at all.",
			"They go before you can redirect them. The prey ahead is genuinely dangerous for an animal their size. You have a few seconds to decide what to do.",
		],
		"choices": [
			{ "label": "Step in ahead of them before contact",       "sublabel": "", "icon": "bond",   "action": "choice_a" },
			{ "label": "Intercept the prey from a flanking angle",   "sublabel": "", "icon": "stalk",  "action": "choice_b" },
			{ "label": "Let them commit and intervene if they take damage", "sublabel": "", "icon": "flee", "action": "choice_c" },
			{ "label": "Call them off immediately",                  "sublabel": "", "icon": "attack", "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["You move in clean and the prey responds to your presence instead of theirs. They watch you take down something they could not have. They will remember this scale."],
				"success": ["Stepping ahead stops the mistake before it costs them. They stand back and watch you work."],
				"mixed":   ["Your intervention reads as taking the hunt from them. They back off but are frustrated rather than taught."],
				"fail":    ["You step in but the prey's attention splits between you and the juvenile. The contact is messy and one of you takes damage."],
			},
			"choice_b": {
				"crit":    ["Your flanking angle brings the prey down cleanly. Your offspring made the start. You finished it together. They learn what addition looks like."],
				"success": ["Flanking turns their poor commitment into a working hunt. They contributed without taking the full risk alone."],
				"mixed":   ["The flank angle is late and the prey has already turned on them. You reach it in time but the lesson is damage absorbed."],
				"fail":    ["You flank but the timing is off. The prey is fully committed to the juvenile before you reach its flank."],
			},
			"choice_c": {
				"crit":    ["They take a glancing hit and back off on their own. You do not have to intervene. They learned the size limit themselves without serious damage."],
				"success": ["They get knocked back before contact and retreat. The experience is enough. They will read this prey class differently now."],
				"mixed":   ["They take real damage before they back off. The lesson is real but it cost something it didn't have to."],
				"fail":    ["They don't back off on their own. You have to intervene after they have already taken serious damage."],
			},
			"choice_d": {
				"crit":    ["Your call stops them exactly. They respond to you instead of the prey. You show them the size of what they were pursuing and the message lands clearly."],
				"success": ["They pull off the target at your signal. The recall takes but they don't fully understand why yet."],
				"mixed":   ["They hesitate rather than stopping clean. The delay means the prey gets a half-charge off before they disengage."],
				"fail":    ["They do not respond to the call. You are already too far away and they are already committed."],
			},
		},
	},
	# ── EVENT 6: The Night Sound ──────────────────────────────────────────────────
	{
		"intro": [
			"Something at the edge of territory, after dark. You do not know yet what it is. Your offspring heard it too — they are already oriented toward it.",
			"A sound from outside the known range. Not loud. Not repeated. But real. Your offspring is awake and looking in that direction.",
			"The night produces something you cannot immediately place. It could be nothing. It could be another adult testing your edge. Your offspring is watching you decide.",
		],
		"choices": [
			{ "label": "Face toward it with offspring behind you",     "sublabel": "", "icon": "bond",   "action": "choice_a" },
			{ "label": "Hold completely still and read it",            "sublabel": "", "icon": "stalk",  "action": "choice_b" },
			{ "label": "Move your offspring to the dense cover first", "sublabel": "", "icon": "flee",   "action": "choice_c" },
			{ "label": "Investigate the direction alone",              "sublabel": "", "icon": "attack", "action": "choice_d" },
		],
		"outcomes": {
			"choice_a": {
				"crit":    ["You orient cleanly and your offspring falls in behind without instruction. The sound resolves to nothing dangerous. They learned a positioning drill without it being a drill."],
				"success": ["You face the sound and they read your posture and move behind you. The lesson in positioning is clean."],
				"mixed":   ["You orient toward it but they move beside you instead of behind. You reposition them once and hold."],
				"fail":    ["They crowd your flank rather than falling behind and you have to manage their position while reading the sound."],
			},
			"choice_b": {
				"crit":    ["You hold still long enough that the sound resolves fully without movement. Your offspring learns what patience in the dark actually costs — nothing, this time."],
				"success": ["Complete stillness gives you everything the sound has to offer. Your offspring holds alongside you."],
				"mixed":   ["You hold still but they do not. Their movement changes what the sound source can read about you."],
				"fail":    ["You hold still but they move toward it before you've finished reading. You have to retrieve them from the wrong position."],
			},
			"choice_c": {
				"crit":    ["You place them in cover quickly and cleanly, then read the sound from a better position. They understand separation as protection, not abandonment."],
				"success": ["Moving them to cover first gives you freedom to read the situation without managing their safety at the same time."],
				"mixed":   ["Moving them to cover takes long enough that you lose the sound window. You end the night knowing less than you would have."],
				"fail":    ["They resist being placed in cover and you spend the decisive moment managing them rather than reading the sound."],
			},
			"choice_d": {
				"crit":    ["You move alone toward the sound and your offspring stays. You find the source, read it, and return. They learn that you can leave and come back."],
				"success": ["Investigating alone gives them a real separation event with a resolution. You return and the lesson holds."],
				"mixed":   ["They follow you despite the implicit direction to stay. The investigation becomes complicated by their presence."],
				"fail":    ["They follow you and the source of the sound picks up two sets of movement. What might have been nothing becomes something."],
			},
		},
	},
]

func get_maternal_events() -> Array:
	return MATERNAL_EVENTS
