# Deinonychus encounter data — loaded by ActionResolver and EventsDB

const OUTCOME_EVENTS: Dictionary = {

	# ── DEINONYCHUS EVENTS ────────────────────────────────────────────────────
	# Juvenile (stages 0–1)

	"dein_sickle_step": {
		"pass_flavor": "You flex the claw once, feel the pull in the toe joint, and decide not to push it today.",
		"w_buff": 0.16, "w_health": 0.20,
		"buff":    { "stat": "type_stat", "amount": 0.10, "turns": 2, "source": "claw_practice",
		             "flavor": "On the fifth try, your claw cuts a clean groove through the bark. You are beginning to understand the angle." },
		"nothing": { "flavor": "You scrape bark, then dirt, then bark again. The feedback is inconsistent. The learning isn't there today." },
		"food":    { "hunger": 0.14,
		             "flavor": "Scratching under the bark edge, you pull loose a section and find the underside alive — grubs, beetles, one pale thing that moves slowly. Enough." },
		"health":  { "health": 0.07,
		             "flavor": "The practice stretches muscles you didn't know were tense. The warm-up is real. You feel more mobile after than before." },
		"debuff":  { "stat": "speed", "amount": -0.08, "turns": 2, "source": "toe_strain",
		             "flavor": "You pull the toe too far on a downstroke and feel the pop immediately. The claw works, but not at full extension today." },
	},

	"dein_beetle_log": {
		"pass_flavor": "You circle the log and step away. Too much competing smell — you can't read what's actually in there.",
		"w_food": 0.32,
		"buff":    { "stat": "speed", "amount": 0.08, "turns": 2, "source": "quick_snatch",
		             "flavor": "The technique comes quickly: peel, snap, peel, snap. You're efficient at this. The small prey rhythm is fast now." },
		"nothing": { "flavor": "The bark falls away in dry slabs. The inside is hollow and powdered — long dead, picked over, nothing left." },
		"food":    { "hunger": 0.18,
		             "flavor": "The log is dense with grubs. You work through it methodically, eating faster than you were hungry. More than you expected." },
		"health":  { "health": 0.07,
		             "flavor": "An easy meal off the log, then flat on the bark for a while. The position is good. You rest off the sun and the early morning exertion." },
		"debuff":  { "stat": "type_stat", "amount": -0.08, "turns": 2, "source": "termite_bite",
		             "flavor": "There were termites deeper in than you went, and now they're on your muzzle and in the feather-skin at your nose. The irritation lasts and focus is worse for it." },
	},

	"dein_adult_shadow": {
		"pass_flavor": "You hold position at the edge of its sight line and wait until it moves away. Correct decision.",
		"w_buff": 0.16, "w_health": 0.22,
		"buff":    { "stat": "type_stat", "amount": 0.10, "turns": 3, "source": "copied_stance",
		             "flavor": "It drops into a low hunting posture, perfectly still, and you watch the whole thing — the weight shift, the neck angle, the claw placement. You file it away." },
		"nothing": { "flavor": "The adult holds eye contact for a long moment, then moves off into the brush without signaling anything. It was just watching." },
		"food":    { "hunger": 0.12,
		             "flavor": "It leaves a piece behind when it moves on — not intentionally, just dropped. Small. Yours now." },
		"health":  { "health": 0.08,
		             "flavor": "While it's nearby, everything smaller keeps a wide distance. You rest in the margin it creates without fully understanding why." },
		"debuff":  { "health": -0.07,
		             "flavor": "You move closer than it wanted. The snap is fast — teeth on your side, a warning, not a bite. You back away with the message received." },
	},

	"dein_wrong_nest": {
		"pass_flavor": "The scent is wrong. You circle once and leave. Some nests come with consequences that aren't worth the food.",
		"w_food": 0.28, "w_buff": 0.12,
		"buff":    { "stat": "type_stat", "amount": 0.08, "turns": 3, "source": "nest_sense",
		             "flavor": "You read the nest without touching it — species, age, distance of the parent. The reading is getting faster." },
		"nothing": { "flavor": "You back away slowly when the scent registers fully. You leave before anything happens." },
		"food":    { "hunger": 0.14,
		             "flavor": "One cracked egg at the outer edge — already open, cold, abandoned. You take it quickly and move." },
		"health":  { "health": 0.07,
		             "flavor": "The nest site itself is soft and dry and well-hidden. After the parent leaves, you find the empty side and rest." },
		"debuff":  { "stat": "speed", "amount": -0.08, "turns": 2, "source": "nest_chase",
		             "flavor": "The parent comes back while you're still deciding. It is faster than you and knows the terrain. You run hard and arrive somewhere else worse off." },
	},

	"dein_tall_grass": {
		"pass_flavor": "You hold still and let the sound die. Whatever it is, you don't have enough information yet.",
		"w_food": 0.28, "w_health": 0.20,
		"buff":    { "stat": "type_stat", "amount": 0.10, "turns": 3, "source": "grass_stalker",
		             "flavor": "You move through the grass perfectly — weight forward, slow and level, no rustling. By the time the grass settled again you were somewhere else and undetected." },
		"nothing": { "flavor": "The sound fades. You search the grass for a long stretch and find nothing — no track, no scent, no sign of what moved through." },
		"food":    { "hunger": 0.20,
		             "flavor": "Small prey, moving fast but in the wrong direction. You cut the angle before it realized the grass was no longer safe." },
		"health":  { "health": 0.08,
		             "flavor": "The grass hides a dry hollow behind a root cluster. You rest in it fully concealed, body temperature settling." },
		"debuff":  { "health": -0.09,
		             "flavor": "A larger animal was in the grass — you startled it at close range and it kicked out before fleeing. You take the blow on your shoulder." },
	},

	# Subadult (stages 1–2)

	"dein_practice_pounce": {
		"pass_flavor": "You lower your body and hold the crouch, then let the moment pass. Not yet. The approach wasn't right.",
		"w_buff": 0.16, "w_health": 0.20,
		"buff":    { "stat": "type_stat", "amount": 0.12, "turns": 3, "source": "pounce_timing",
		             "flavor": "You slow the movement and feel each step of it. The timing becomes easier to repeat." },
		"nothing": { "flavor": "The herbivore drifts back toward the herd before you can commit. You're left crouched in the brush with a clear view of animals you can't reach." },
		"food":    { "hunger": 0.22,
		             "flavor": "The pounce lands. You stayed controlled — not maximum force, just enough — and the prey was yours." },
		"health":  { "health": 0.08,
		             "flavor": "A careful crouch, coil, and leap loosen your stiff muscles. You move more freely afterward." },
		"debuff":  { "stat": "speed", "amount": -0.08, "turns": 2, "source": "missed_pounce",
		             "flavor": "You push into the jump and the angle is wrong. You hit the ground instead of the target. The landing takes more out of you than the prey would have given." },
	},

	"dein_tenonto_trail": {
		"pass_flavor": "The trail is big and you follow it only long enough to read the herd size. Then you stop. Not for today.",
		"w_buff": 0.16, "w_food": 0.30,
		"buff":    { "stat": "type_stat", "amount": 0.12, "turns": 4, "source": "big_prey_track",
		             "flavor": "You track the trail the full way — reading gait changes, stress behaviors, the places where the herd slowed. This prey species is familiar now." },
		"nothing": { "flavor": "The trail is cold by the time you find it. Two days old at least. You follow it for a while and then stop at the crossing." },
		"food":    { "hunger": 0.16,
		             "flavor": "The insects and small things that follow a Tenontosaurus herd are thick along the route. Easy picking." },
		"health":  { "health": 0.08,
		             "flavor": "The trail leads you to a river crossing where the water is clear and still after the herd moved through. You drink properly." },
		"debuff":  { "stat": "defense", "amount": -0.10, "turns": 2, "source": "herd_spotted",
		             "flavor": "You follow the trail too closely into the herd's back edge. They've been watched before — they know the approach. You get spotted before you're ready." },
	},

	"dein_tail_lash": {
		"pass_flavor": "You hold at distance. A tail like that doesn't need to aim well to do damage.",
		"w_buff": 0.16,
		"buff":    { "stat": "defense", "amount": 0.10, "turns": 3, "source": "tail_dodge",
		             "flavor": "The tail swings and you read it before it arrives — weight shift, hip rotation, the tell in the haunches. You step the right direction. You won't miss that read again." },
		"nothing": { "flavor": "You keep outside the swing radius. The herbivore moves off when it decides you've stopped being interesting." },
		"food":    { "hunger": 0.14,
		             "flavor": "The tail swing sends smaller animals in all directions. One of them doesn't find cover fast enough." },
		"health":  { "health": 0.08,
		             "flavor": "You find the cleared area the herbivore left behind and rest in the quiet. Nothing stays near a nervous animal that size." },
		"debuff":  { "health": -0.10,
		             "flavor": "The tail connects. You were reading the wrong signal — the hip, not the shoulder — and the blow lands across your ribs. You move differently for the next two days." },
	},

	"dein_loose_pack_scent": {
		"pass_flavor": "You note the direction and stay out of their range. Unknown Deinonychus are unpredictable. You hunt alone today.",
		"w_buff": 0.14, "w_health": 0.20,
		"buff":    { "stat": "defense", "amount": 0.10, "turns": 3, "source": "pack_awareness",
		             "flavor": "You read the pack from the scent alone — size, direction, cohesion, how long ago they passed. You're getting better at reading your own kind." },
		"nothing": { "flavor": "The pack moves on before you close the distance. You find the scent trail going cold in the opposite direction." },
		"food":    { "hunger": 0.14,
		             "flavor": "Their hunt left scraps. Not much — but clean and recent." },
		"health":  { "health": 0.08,
		             "flavor": "You move close enough to benefit from their perimeter without entering it. Predators are avoiding the whole area. You rest in the margin." },
		"debuff":  { "stat": "speed", "amount": -0.08, "turns": 2, "source": "pack_chase",
		             "flavor": "You misread the pack's edge and a dominant subadult runs you off hard. You leave with the clear message that you read the situation wrong." },
	},

	"dein_creek_crossing": {
		"pass_flavor": "You set the ambush and wait. Nothing comes to the crossing. You leave before the wait costs more than the reward.",
		"w_buff": 0.16, "w_food": 0.30,
		"buff":    { "stat": "type_stat", "amount": 0.10, "turns": 3, "source": "crossing_ambush",
		             "flavor": "You hold the bank perfectly, reading the crossing point — where animals slow, where the footing is worst for them. The geometry of this ambush is exact now." },
		"nothing": { "flavor": "You wait at the crossing for a full stretch of the morning. Nothing uses it while you're there." },
		"food":    { "hunger": 0.18,
		             "flavor": "A small animal comes to drink at the bank, unhurried, unaware. The creek made it careless." },
		"health":  { "health": 0.08,
		             "flavor": "You drink from the creek and clean the scrapes you've been carrying. The cold water on the skin is right." },
		"debuff":  { "stat": "speed", "amount": -0.08, "turns": 2, "source": "creek_stones",
		             "flavor": "You shift your weight on the crossing stones and the wrong one gives. The leg strain isn't bad — but it's there, and it affects the sprint." },
	},

	# Adult (stage 2+)

	"dein_sickle_strike": {
		"pass_flavor": "The opening appears and closes. You didn't move. Good. The moment wasn't right.",
		"w_buff": 0.14, "w_food": 0.30,
		"buff":    { "stat": "strength", "amount": 0.10, "turns": 2, "source": "raking_claw",
		             "flavor": "The strike is perfect — angle, depth, retraction. The claw worked exactly as it's supposed to. That sequence is sharper for the repetition." },
		"nothing": { "flavor": "The prey turns back before the window fully opens. The flank never quite presents itself. You wait for another moment that doesn't come." },
		"food":    { "hunger": 0.28,
		             "flavor": "The wound is deep and placed well. The prey runs but not far." },
		"health":  { "health": 0.10,
		             "flavor": "The clean takedown costs nothing. You eat without injury and rest after." },
		"debuff":  { "stat": "type_stat", "amount": -0.10, "turns": 2, "source": "claw_drag",
		             "flavor": "The angle was wrong at commitment — the claw drags instead of raking and you feel the pull immediately. The toe is workable but wrong." },
	},

	"dein_tenonto_calf": {
		"pass_flavor": "You read the herd formation and the calf's distance from the edge. Not isolated enough. You move on.",
		"w_food": 0.32, "w_debuff": 0.16,
		"buff":    { "stat": "type_stat", "amount": 0.12, "turns": 3, "source": "herd_edge_hunter",
		             "flavor": "You read the whole herd — which animals monitor the edge, where the calf will lag if you push. The hunt architecture is clear." },
		"nothing": { "flavor": "The calf closes the distance to the herd before you can move. It sensed something. You lost the window." },
		"food":    { "hunger": 0.40,
		             "flavor": "You isolate it at the herd edge and commit before it can return. The kill is large." },
		"health":  { "health": 0.12,
		             "flavor": "The hunt works and you feed fully. Rich food and real recovery." },
		"debuff":  { "health": -0.15,
		             "flavor": "The adults react before you expect. Two of them turn back and their intervention is fast and direct. You take damage getting clear." },
	},

	"dein_grapple_flank": {
		"pass_flavor": "You decide not to commit to the grapple. The position isn't right and a grapple gone wrong leaves you dragged.",
		"w_food": 0.30, "w_debuff": 0.14,
		"buff":    { "stat": "strength", "amount": 0.10, "turns": 2, "source": "grip_strength",
		             "flavor": "You hook in and hold — the grip is controlled, the weight is distributed, and the prey can't shake you. The hold technique is sharper after this." },
		"nothing": { "flavor": "You approach the grapple point and something in the read tells you the moment isn't right. You stop before committing." },
		"food":    { "hunger": 0.30,
		             "flavor": "You hold on through the panic and the running. Eventually the prey stops. You were still there." },
		"health":  { "health": 0.10,
		             "flavor": "The grapple and takedown are clean. No dragging, no bad landing. You recover quickly after eating." },
		"debuff":  { "health": -0.10,
		             "flavor": "The prey's momentum is more than you accounted for. You're thrown, land badly, and the breath takes a moment to come back." },
	},

	"dein_ambush_scrub": {
		"pass_flavor": "The wind shifts before you can use the position. You retreat before your scent does it for you.",
		"w_buff": 0.16, "w_food": 0.30,
		"buff":    { "stat": "type_stat", "amount": 0.12, "turns": 3, "source": "brush_ambush",
		             "flavor": "You hold the position in the brush for the full wait. Nothing detects you. Everything works as it's supposed to." },
		"nothing": { "flavor": "The wind shifts before prey arrives. The scent is moving the wrong direction. The position is useless." },
		"food":    { "hunger": 0.26,
		             "flavor": "The prey crosses the brush gap and you're already in motion. It never had an angle on you." },
		"health":  { "health": 0.09,
		             "flavor": "You hold in the brush long enough that the area settles into your presence. Safe rest in full concealment." },
		"debuff":  { "health": -0.07,
		             "flavor": "The brush edge is denser than you read. Moving through it quickly costs you — thorns open lines along the feather-skin at your shoulders." },
	},

	"dein_carrion_teeth": {
		"pass_flavor": "The carcass lies in an uneasy patch of ground. You check the perimeter, then leave it untouched.",
		"w_food": 0.30, "w_buff": 0.14,
		"buff":    { "stat": "type_stat", "amount": 0.10, "turns": 3, "source": "bold_scavenger",
		             "flavor": "You read the site — kill type, time since death, whether the killer came back. You eat with your back covered and leave clean." },
		"nothing": { "flavor": "The carcass has been down long enough that nothing worth the risk of a bad meal remains." },
		"food":    { "hunger": 0.26,
		             "flavor": "There's good meat still in it. You take what you can and move." },
		"health":  { "health": 0.10,
		             "flavor": "The bone marrow is intact. You work it out methodically. Dense, rich." },
		"debuff":  { "health": -0.12,
		             "flavor": "You're mid-feed when the original killer comes back. It's larger than the carcass suggested and not interested in sharing." },
	},

	# Wounded adult (require_injured)

	"dein_bent_claw": {
		"pass_flavor": "You take the weight off the toe and adjust how you move. You've been compensating already without deciding to.",
		"w_health": 0.30, "w_buff": 0.14,
		"buff":    { "stat": "defense", "amount": 0.08, "turns": 3, "source": "careful_footing",
		             "flavor": "You work through the pain carefully, finding the footing that protects the claw without sacrificing the stride. The adaptation becomes instinct." },
		"nothing": { "flavor": "The pain is manageable. You move through the day more carefully than usual and nothing worsens." },
		"food":    { "hunger": 0.16,
		             "flavor": "You switch method — scavenging instead of stalking — and find something worth eating." },
		"health":  { "health": 0.12,
		             "flavor": "Rest and reduced weight-bearing gives the claw joint time to stop inflaming. Better by the end of the day." },
		"debuff":  { "stat": "type_stat", "amount": -0.10, "turns": 3, "source": "damaged_claw",
		             "flavor": "You forget the claw for a moment — one normal stride, one full extension — and the pain is sharp enough to change how you move for the next two days." },
	},

	"dein_blood_feathers": {
		"pass_flavor": "You find water and work through the bloodied feathers until the smell is gone. It takes time. It's worth it.",
		"w_buff": 0.14, "w_health": 0.24, "w_debuff": 0.14,
		"buff":    { "stat": "defense", "amount": 0.10, "turns": 3, "source": "washed_clean",
		             "flavor": "The creek runs clean and you stay in it longer than you need to. Everything that was tracking you by scent lost the trail before you cleared the far bank." },
		"nothing": { "flavor": "The scent trail you left disperses before anything follows it. The wound was not as revealing as it felt." },
		"food":    { "hunger": 0.12,
		             "flavor": "The insects drawn to blood are thick near the bloodied area. You eat them before moving." },
		"health":  { "health": 0.10,
		             "flavor": "You find a deep creek section and clean the wound properly — cold water, pressure, time. The infection risk drops." },
		"debuff":  { "health": -0.10,
		             "flavor": "Something tracked the feather-scent to you before you cleared it. The encounter costs you more than the wound already had." },
	},

	"dein_safe_hollow": {
		"pass_flavor": "The hollow is good but the entrance faces the wrong direction for the wind. You keep moving.",
		"w_health": 0.34, "w_debuff": 0.10,
		"buff":    { "stat": "type_stat", "amount": 0.12, "turns": 3, "source": "hidden_rest",
		             "flavor": "You fit into the hollow and disappear. Nothing moves on the outside for hours. Whatever was near you lost the track entirely." },
		"nothing": { "flavor": "The hollow is too exposed from one angle. You can't rest here safely. You leave it." },
		"food":    { "hunger": 0.14,
		             "flavor": "The roots house small life — slow, easy. You eat before resting." },
		"health":  { "health": 0.15,
		             "flavor": "The hollow is dry and still. You sleep in it long and wake with the wound further along than it should be." },
		"debuff":  { "stat": "defense", "amount": -0.10, "turns": 3, "source": "hollow_parasites",
		             "flavor": "The hollow was already occupied by something small but persistent. The bites it delivers to the wound margin are not significant on their own — but they're not helpful." },
	},

	"dein_limping_hunt": {
		"pass_flavor": "You conserve. You're not in condition for a full hunt. Patience is the right choice.",
		"w_buff": 0.16, "w_health": 0.26, "w_debuff": 0.10,
		"buff":    { "stat": "type_stat", "amount": 0.12, "turns": 3, "source": "patient_hunter",
		             "flavor": "You can't sprint so you don't. You watch for twice as long as usual before moving. The ambush that results is the best you've run this season." },
		"nothing": { "flavor": "You hold your range and move carefully and the day passes without food or injury. The wound is no worse." },
		"food":    { "hunger": 0.18,
		             "flavor": "Moving slowly, you find something slow enough to match. The catch doesn't require what you don't have." },
		"health":  { "health": 0.12,
		             "flavor": "Choosing rest over hunting pays off. The wound closes faster than it would have otherwise." },
		"debuff":  { "health": -0.12,
		             "flavor": "You push into a chase and the wound opens. Everything that was improving reverses." },
	},

	# Pack / Group (require_pack)

	"dein_two_claw": {
		"pass_flavor": "You read the other hunter and decide the coordination isn't there. Two predators circling the same prey without agreement is worse than hunting alone.",
		"w_food": 0.30, "w_buff": 0.16,
		"buff":    { "stat": "strength", "amount": 0.10, "turns": 2, "source": "flank_partner",
		             "flavor": "You read each other without signaling. You take the left when it takes the right. The prey had nowhere to go and you both knew it." },
		"nothing": { "flavor": "The other hunter loses confidence and backs away before you both commit. You're left alone with prey that now knows it's being watched." },
		"food":    { "hunger": 0.30,
		             "flavor": "The kill goes clean. You both eat." },
		"health":  { "health": 0.10,
		             "flavor": "The coordination is fast enough that neither of you takes damage. You eat and rest in position." },
		"debuff":  { "health": -0.08,
		             "flavor": "After the kill, the contest starts. The other hunter has a different read on who earned the better share. You leave with less and a bite on your flank." },
	},

	"dein_dominance_display": {
		"pass_flavor": "You lower your feathers and look away. Not worth it. This isn't your territory.",
		"w_buff": 0.18, "w_health": 0.20,
		"buff":    { "stat": "strength", "amount": 0.10, "turns": 2, "source": "intimidating_display",
		             "flavor": "You match the display — feathers up, claws clicking, full height — and hold it until the other one reads the response and drops first." },
		"nothing": { "flavor": "You both display for a long time. Eventually the energy runs out. You go separate directions." },
		"food":    { "hunger": 0.14,
		             "flavor": "It backs down before fully committing and abandons what it was standing over." },
		"health":  { "health": 0.08,
		             "flavor": "You hold the display until the rival drops its posture. No contact, no energy spent beyond the display. Clean win." },
		"debuff":  { "health": -0.10,
		             "flavor": "The display becomes a fight. The other animal is faster than its posture suggested. You leave with a bite that will stiffen over the next few days." },
	},

	"dein_pack_trial": {
		"pass_flavor": "You watch the group from outside and decide the terms are wrong. You hunt better alone than as the lowest animal in a temporary hierarchy.",
		"w_buff": 0.14, "w_health": 0.20,
		"buff":    { "stat": "defense", "amount": 0.10, "turns": 3, "source": "accepted_hunter",
		             "flavor": "You run the flank role well — not too close, not too far. The group accepts the contribution. You've found a position in it." },
		"nothing": { "flavor": "They move through your area and file past without acknowledging you. The trial, if there was one, was inconclusive." },
		"food":    { "hunger": 0.22,
		             "flavor": "They allow you to feed after the kill. Not the best cut, but real food." },
		"health":  { "health": 0.09,
		             "flavor": "You rest in the perimeter of the group and the night is safer than it would have been alone." },
		"debuff":  { "stat": "speed", "amount": -0.08, "turns": 2, "source": "trial_failed",
		             "flavor": "You misread the hierarchy and position yourself wrong. The correction is immediate and physical. You run before it escalates further." },
	},

	"dein_group_ambush": {
		"pass_flavor": "The herd's position is wrong for the ambush. You wait and the moment passes. Better to not start it.",
		"w_food": 0.32, "w_buff": 0.16, "w_debuff": 0.14,
		"buff":    { "stat": "strength", "amount": 0.12, "turns": 2, "source": "coord_ambush",
		             "flavor": "The group moves in the right sequence. You take your position and it holds. The hunt that results is exactly what this species does at its best." },
		"nothing": { "flavor": "The herd turns before the ambush triggers. They smelled something, or heard something, or one of the group moved early. The moment closes." },
		"food":    { "hunger": 0.38,
		             "flavor": "The isolation works. The prey is cut and the group brings it down." },
		"health":  { "health": 0.12,
		             "flavor": "The clean coordinated hunt costs nothing. You eat fully and recover." },
		"debuff":  { "health": -0.15,
		             "flavor": "The herd panics into the ambush line. You get the panic instead of the isolation — movement in every direction, and one of them runs through where you're standing." },
	},

	"dein_share_snap": {
		"pass_flavor": "You step back from the kill and let the other animal establish its claim. Not every kill is worth a fight.",
		"w_food": 0.30, "w_buff": 0.14,
		"buff":    { "stat": "strength", "amount": 0.08, "turns": 2, "source": "food_assertive",
		             "flavor": "You hold your position over the kill — not aggressive, just clear. The other animal reads it correctly and backs off." },
		"nothing": { "flavor": "You both eat from opposite sides with careful attention to where the other animal is. The meal finishes without incident." },
		"food":    { "hunger": 0.24,
		             "flavor": "You win the better position and the better cut. The other animal takes what remains." },
		"health":  { "health": 0.09,
		             "flavor": "The shared feeding is calm enough that you both recover. Territory over food isn't always the right calculation." },
		"debuff":  { "health": -0.08,
		             "flavor": "The contest becomes physical. You win the food. You lose something else." },
	},

	"dein_warning_feather": {
		"pass_flavor": "You freeze and read the direction of the packmate's attention. Whatever it saw, you're watching the same space now.",
		"w_buff": 0.18, "w_health": 0.22,
		"buff":    { "stat": "defense", "amount": 0.12, "turns": 2, "source": "pack_signals",
		             "flavor": "The signal reaches you clearly — direction, urgency, the difference between this warning and a lesser one. You move before the threat develops." },
		"nothing": { "flavor": "The packmate settles after a moment. Whatever it noticed turns out to be nothing significant." },
		"food":    { "hunger": 0.14,
		             "flavor": "The signal reveals the direction of prey movement. You were watching the wrong edge." },
		"health":  { "health": 0.09,
		             "flavor": "You read the signal and move clear of the developing situation. You rest well on the far side of it." },
		"debuff":  { "health": -0.10,
		             "flavor": "You don't catch the signal in time. By the time you react, the situation has already developed against you." },
	},

	# Seasonal

	"dein_spring_nesting": {
		"pass_flavor": "The nesting ground is too active. Parents are everywhere. You move through quickly.",
		"w_food": 0.32, "w_buff": 0.14,
		"buff":    { "stat": "type_stat", "amount": 0.12, "turns": 4, "source": "nest_raider",
		             "flavor": "You read the nest patterns — which species, where they're concentrated, the approach angles that don't trigger alarm. The nest season is yours." },
		"nothing": { "flavor": "Every nest you approach has been defended too recently to try. The parents are alert and close." },
		"food":    { "hunger": 0.24,
		             "flavor": "You find a nest that's unguarded for a window. You eat and move before the window closes." },
		"health":  { "health": 0.08,
		             "flavor": "Easy calories spread across the nesting ground. The effort is low and the yield is real." },
		"debuff":  { "health": -0.10,
		             "flavor": "The parent reaches you before you're clear. The defense is fierce and close. You leave with a wound." },
	},

	"dein_muddy_tracks": {
		"pass_flavor": "The prints are everywhere and they're confusing. You step back and use a different method.",
		"w_buff": 0.16, "w_food": 0.30,
		"buff":    { "stat": "type_stat", "amount": 0.12, "turns": 3, "source": "mud_tracker",
		             "flavor": "The mud holds every print perfectly. You read the whole morning's movement in twenty minutes. The trail you choose is correct." },
		"nothing": { "flavor": "Too many animals passed through in too many directions. The information is there but too dense to use." },
		"food":    { "hunger": 0.22,
		             "flavor": "The trail leads you directly to active prey — animals following a route you can now predict." },
		"health":  { "health": 0.08,
		             "flavor": "The fresh water that softened the mud is still running. You find it and drink." },
		"debuff":  { "stat": "speed", "amount": -0.08, "turns": 2, "source": "mud_slow",
		             "flavor": "The soft ground is as bad for you as it is good for tracking. You lose speed in it and the sprint that follows is shorter than you needed." },
	},

	"dein_heat_chase": {
		"pass_flavor": "You rest through the worst of the heat. The prey isn't going anywhere you can't find it cooler.",
		"w_buff": 0.16, "w_health": 0.22,
		"buff":    { "stat": "speed", "amount": 0.10, "turns": 2, "source": "short_burst",
		             "flavor": "You don't chase — you position and wait. The heat works against the prey's panic response and in favor of your stillness. The ambush is better than the sprint would have been." },
		"nothing": { "flavor": "You rest through the heat and emerge with nothing. The day cost you nothing and gave you nothing." },
		"food":    { "hunger": 0.20,
		             "flavor": "The heat has slowed the prey's reaction. The catch is easier than it would have been in good conditions." },
		"health":  { "health": 0.09,
		             "flavor": "You rest in the shade through the worst of the heat, giving yourself time to recover." },
		"debuff":  { "stat": "speed", "amount": -0.12, "turns": 2, "source": "overheated",
		             "flavor": "You push the chase past the point where the heat allows it. The prey escapes because you slow first. You come back worse." },
	},

	"dein_dry_river": {
		"pass_flavor": "You read the crossing and note the larger predators already working it. You find another route.",
		"w_buff": 0.16, "w_food": 0.32,
		"buff":    { "stat": "type_stat", "amount": 0.12, "turns": 3, "source": "funnel_hunter",
		             "flavor": "You find the bottleneck where the river is narrowest and most awkward for crossing prey. The geometry of the trap is exact now." },
		"nothing": { "flavor": "The crossing stays empty while you're there. Whatever moved through did it before you arrived." },
		"food":    { "hunger": 0.26,
		             "flavor": "A crossing animal slows for the footing and you're already in position. The distance was short." },
		"health":  { "health": 0.08,
		             "flavor": "The dry riverbed holds a hidden pool behind a stone shelf. You drink from it undisturbed." },
		"debuff":  { "health": -0.12,
		             "flavor": "A larger predator was already working the crossing. It had a stronger claim and it made that clear." },
	},

	"dein_herd_movement": {
		"pass_flavor": "You observe the herd movement and mark the direction. Following it now is premature.",
		"w_buff": 0.14, "w_food": 0.30,
		"buff":    { "stat": "type_stat", "amount": 0.12, "turns": 4, "source": "migration_follow",
		             "flavor": "You follow the migration route far enough to read the pattern — where the herd weakens, where the vulnerable animals lag, where the route narrows. The season is mapped." },
		"nothing": { "flavor": "You lose the trail when the herd crosses a wide section. The route goes cold." },
		"food":    { "hunger": 0.24,
		             "flavor": "The migration produces stragglers. You find one." },
		"health":  { "health": 0.08,
		             "flavor": "The herd trail leads to water that the herd opened up on its route." },
		"debuff":  { "health": -0.10,
		             "flavor": "You work the herd's flank and the rear guard responds. The defense is coordinated and you take damage before you clear it." },
	},

	"dein_rival_pack": {
		"pass_flavor": "You read the rival pack's direction and change your route. This is not a fight worth having.",
		"w_buff": 0.14, "w_health": 0.20, "w_debuff": 0.14,
		"buff":    { "stat": "defense", "amount": 0.10, "turns": 3, "source": "territory_claim",
		             "flavor": "You hold your ground without aggression — just visible, present, clearly not moving. The rivals route around you. The territory is yours for today." },
		"nothing": { "flavor": "The rival pack moves through your range on a trajectory that doesn't intersect. They pass without incident." },
		"food":    { "hunger": 0.18,
		             "flavor": "Their hunt left something behind. You find it after they move on." },
		"health":  { "health": 0.09,
		             "flavor": "You locate a den site far enough from the rival pack's route that the rest is undisturbed." },
		"debuff":  { "health": -0.12,
		             "flavor": "The rival pack's edge animal finds you before you find them. The encounter is fast and does more damage than a single animal should." },
	},

	"dein_winter_scarcity": {
		"pass_flavor": "You hunt minimally and rest maximally. The winter math demands it.",
		"w_food": 0.28, "w_health": 0.22, "w_debuff": 0.14,
		"buff":    { "stat": "type_stat", "amount": 0.10, "turns": 3, "source": "efficient_hunter",
		             "flavor": "You catch less but waste nothing. The efficiency is learned from necessity." },
		"nothing": { "flavor": "You survive the day on what you have. The cold costs something. Nothing gained." },
		"food":    { "hunger": 0.24,
		             "flavor": "The weakened prey is easier to catch than anything you've hunted this season. The cold did the work." },
		"health":  { "health": 0.12,
		             "flavor": "A full meal when you needed one most. The recovery is real." },
		"debuff":  { "stat": "speed", "amount": -0.12, "turns": 2, "source": "exhaustion",
		             "flavor": "The hunt fails and the effort cost more than you had. The exhaustion is physical and it lingers." },
	},

	# Rare

	"dein_tenonto_stand": {
		"pass_flavor": "You read the posture and make the correct decision. A Tenontosaurus that won't run has already made its calculation. You weren't part of it.",
		"w_buff": 0.18, "w_health": 0.22, "w_debuff": 0.18,
		"buff":    { "stat": "defense", "amount": 0.14, "turns": 3, "source": "respect_the_tail",
		             "flavor": "The tail comes at you and you move exactly the right direction. Not luck — you read the weight shift correctly. You won't miss that read again." },
		"nothing": { "flavor": "You circle the animal twice and both times the tail stays forward. It will not run. You leave." },
		"food":    { "hunger": 0.22,
		             "flavor": "The standoff reveals a smaller, panicked animal nearby that broke cover while you were both occupied with each other." },
		"health":  { "health": 0.10,
		             "flavor": "You retreat before the tail swing arrives. Preserving health today is the right calculation." },
		"debuff":  { "health": -0.18,
		             "flavor": "The tail connects. A Tenontosaurus tail is substantial and it travels fast. You are on the ground before you register having been hit." },
	},

	"dein_broken_claw_scar": {
		"pass_flavor": "Old marks. You read them and move on. The information is dated.",
		"w_buff": 0.18, "w_health": 0.20,
		"buff":    { "stat": "type_stat", "amount": 0.14, "turns": 4, "source": "territory_reader",
		             "flavor": "You read the marks — depth, height, spacing, the angle of the carve. You know who left these and roughly when. The territory makes more sense now." },
		"nothing": { "flavor": "The marks are too old to tell you anything useful. The territory has reorganized since they were made." },
		"food":    { "hunger": 0.18,
		             "flavor": "Following the territory marks leads you to an old hunting route — and the prey that still uses it." },
		"health":  { "health": 0.10,
		             "flavor": "The marks lead you to a known den site — used and abandoned, but still sheltered. You rest in it." },
		"debuff":  { "health": -0.10,
		             "flavor": "The marks lead you into a boundary you didn't know was active. The animal that made them comes to investigate." },
	},

	"dein_feather_display": {
		"pass_flavor": "You hold still and don't respond. An unreturned display ends faster than a returned one.",
		"w_buff": 0.18, "w_health": 0.22,
		"buff":    { "stat": "strength", "amount": 0.10, "turns": 2, "source": "display_confidence",
		             "flavor": "You raise your feathers and stand at full height. The rival reads your steady posture and hesitates." },
		"nothing": { "flavor": "The display runs its course and nothing resolves. Both animals eventually lower their feathers and move on." },
		"food":    { "hunger": 0.14,
		             "flavor": "The display flushes small prey from the cover between you." },
		"health":  { "health": 0.09,
		             "flavor": "The rival backs down before the display escalates. No energy spent, no damage taken." },
		"debuff":  { "health": -0.10,
		             "flavor": "The rival doesn't back down. The display becomes a fight faster than you expected." },
	},

	"dein_cliffside": {
		"pass_flavor": "You stop at the base of the rock formation. The footing above is unpredictable and you don't know the terrain.",
		"w_buff": 0.16, "w_food": 0.28, "w_debuff": 0.14,
		"buff":    { "stat": "speed", "amount": 0.10, "turns": 3, "source": "rock_scramble",
		             "flavor": "You find the route up quickly — weight forward, claws on every purchase, reading the surface one step ahead. The rough terrain is yours now." },
		"nothing": { "flavor": "The prey reaches a section you can't follow without committing to dangerous footing. You stop." },
		"food":    { "hunger": 0.24,
		             "flavor": "You corner it against a vertical face. Above is nothing. Behind is you." },
		"health":  { "health": 0.10,
		             "flavor": "The elevated rest point is completely hidden from below. You sleep without a sound reaching you." },
		"debuff":  { "stat": "speed", "amount": -0.12, "turns": 3, "source": "rock_fall",
		             "flavor": "The rock gives way under your rear foot. The fall is short but the landing is wrong. The leg is not broken. It is very wrong, though." },
	},

	"dein_last_bite": {
		"pass_flavor": "You read the wound pattern on the prey and the approach angle of what made it. You leave before the original predator returns.",
		"w_buff": 0.16, "w_food": 0.30, "w_debuff": 0.14,
		"buff":    { "stat": "type_stat", "amount": 0.12, "turns": 3, "source": "cautious_scav",
		             "flavor": "You eat and watch the site perimeter simultaneously. When you leave, you leave clean — no trace, and the original predator has no reason to track you." },
		"nothing": { "flavor": "The prey is still alive and the original predator is still near. You decide neither is worth it." },
		"food":    { "hunger": 0.28,
		             "flavor": "The prey is too weak to resist and too close to the end for the original predator to be angry about. You take it." },
		"health":  { "health": 0.10,
		             "flavor": "You feed while the opportunity lasts, then rest nearby. The easy meal restores some of your strength." },
		"debuff":  { "health": -0.12,
		             "flavor": "The original predator returns faster than the wound pattern suggested. You leave less fed and more hurt." },
	},

}

const EVENTS: Dictionary = {
	# ── DEINONYCHUS EVENTS ────────────────────────────────────────────────────
	# Juvenile (stages 0–1)

	"dein_sickle_step": {
		"seasons": ["any"], "trees": ["predator"], "species": ["deinonychus"],
		"min_stage": 0, "max_stage": 1, "rarity": "common", "passive": false,
		"flavor": "You flex the curved claw on your second toe, testing it against bark and then dirt. The joint is still new. The mechanics of it are still being learned.",
		"choices": [
			{ "label": "Work the technique", "icon": "stalk", "sublabel": "Practice the motion", "action": "engage" },
			{ "label": "Leave it",           "icon": "flee",  "sublabel": "Don't risk the joint", "action": "pass" },
		],
		"resolve_key": "dein_sickle_step",
	},
	"dein_beetle_log": {
		"seasons": ["any"], "trees": ["predator"], "species": ["deinonychus"],
		"min_stage": 0, "max_stage": 1, "rarity": "common", "passive": false,
		"flavor": "A fallen log smells alive with insects, grubs, and small hiding things. The bark is loose at one end and something pale moves just inside the gap.",
		"choices": [
			{ "label": "Work the log", "icon": "hunt",  "sublabel": "Pull it open and eat",    "action": "engage" },
			{ "label": "Move past",    "icon": "flee",  "sublabel": "Not worth the crouch",    "action": "pass" },
		],
		"resolve_key": "dein_beetle_log",
	},
	"dein_adult_shadow": {
		"seasons": ["any"], "trees": ["predator"], "species": ["deinonychus"],
		"min_stage": 0, "max_stage": 1, "rarity": "uncommon", "passive": false,
		"flavor": "An adult Deinonychus watches you from the brush. It has not moved. It has not threatened. It is simply watching.",
		"choices": [
			{ "label": "Watch it back",  "icon": "stalk", "sublabel": "Learn from its posture", "action": "engage" },
			{ "label": "Back away",      "icon": "flee",  "sublabel": "Don't push it",          "action": "pass" },
		],
		"resolve_key": "dein_adult_shadow",
	},
	"dein_wrong_nest": {
		"seasons": ["spring", "summer"], "trees": ["predator"], "species": ["deinonychus"],
		"min_stage": 0, "max_stage": 1, "rarity": "common", "passive": false,
		"flavor": "You find eggs hidden in brush, but something about the scent is wrong — too sharp, unfamiliar. Something nested here that you haven't encountered before.",
		"choices": [
			{ "label": "Investigate",   "icon": "stalk", "sublabel": "Could still be food",     "action": "engage" },
			{ "label": "Leave it",      "icon": "flee",  "sublabel": "The scent is a warning",  "action": "pass" },
		],
		"resolve_key": "dein_wrong_nest",
	},
	"dein_tall_grass": {
		"seasons": ["any"], "trees": ["predator"], "species": ["deinonychus"],
		"min_stage": 0, "max_stage": 1, "rarity": "common", "passive": false,
		"flavor": "Something moves through tall grass nearby — a low, quick displacement, the sound of something neither large nor slow. It could be prey. It could be something else.",
		"choices": [
			{ "label": "Move through it", "icon": "stalk", "sublabel": "Find out what's in there", "action": "engage" },
			{ "label": "Hold position",   "icon": "flee",  "sublabel": "Wait for it to show",      "action": "pass" },
		],
		"resolve_key": "dein_tall_grass",
	},

	# Subadult (stages 1–2)

	"dein_practice_pounce": {
		"seasons": ["any"], "trees": ["predator"], "species": ["deinonychus"],
		"min_stage": 1, "max_stage": 2, "rarity": "common", "passive": false,
		"flavor": "A young herbivore wanders from the herd. Not far — just far enough. Your body lowers on instinct before your mind makes the decision.",
		"choices": [
			{ "label": "Commit to it",   "icon": "attack", "sublabel": "Go for the pounce",     "action": "engage" },
			{ "label": "Hold back",      "icon": "flee",   "sublabel": "Not the right moment",  "action": "pass" },
		],
		"resolve_key": "dein_practice_pounce",
	},
	"dein_tenonto_trail": {
		"seasons": ["any"], "trees": ["predator"], "species": ["deinonychus"],
		"min_stage": 1, "max_stage": 2, "rarity": "uncommon", "passive": false,
		"flavor": "Wide tracks and torn vegetation. A Tenontosaurus herd passed through recently — the prints are clear and the broken growth is still bleeding sap.",
		"choices": [
			{ "label": "Follow the trail", "icon": "stalk", "sublabel": "Learn where they go",   "action": "engage" },
			{ "label": "Stay back",        "icon": "flee",  "sublabel": "Too big for now",        "action": "pass" },
		],
		"resolve_key": "dein_tenonto_trail",
	},
	"dein_tail_lash": {
		"seasons": ["any"], "trees": ["predator"], "species": ["deinonychus"],
		"min_stage": 1, "max_stage": 2, "rarity": "common", "passive": false,
		"flavor": "A medium herbivore notices you nearby and turns broadside, tail raised. It knows what you are. It is deciding whether to run or stand its ground.",
		"choices": [
			{ "label": "Read the tail",   "icon": "stalk", "sublabel": "Stay close and watch",  "action": "engage" },
			{ "label": "Back off",        "icon": "flee",  "sublabel": "That tail has range",   "action": "pass" },
		],
		"resolve_key": "dein_tail_lash",
	},
	"dein_loose_pack_scent": {
		"seasons": ["any"], "trees": ["predator"], "species": ["deinonychus"],
		"min_stage": 1, "max_stage": 2, "rarity": "uncommon", "passive": false,
		"flavor": "You smell several Deinonychus nearby. Not family — the scent is wrong for that. They are hunting in the same general direction you are.",
		"choices": [
			{ "label": "Track them",     "icon": "stalk", "sublabel": "Learn their position",   "action": "engage" },
			{ "label": "Avoid them",     "icon": "flee",  "sublabel": "Unknown pack is a risk", "action": "pass" },
		],
		"resolve_key": "dein_loose_pack_scent",
	},
	"dein_creek_crossing": {
		"seasons": ["any"], "trees": ["predator"], "species": ["deinonychus"],
		"min_stage": 1, "max_stage": 2, "rarity": "common", "passive": false,
		"flavor": "A narrow creek cuts through the scrub. Anything crossing it has to slow down and watch its footing. The bank on your side is flat and covered.",
		"choices": [
			{ "label": "Set an ambush",  "icon": "stalk", "sublabel": "Wait for a crossing",    "action": "engage" },
			{ "label": "Move past",      "icon": "flee",  "sublabel": "Too much time to wait",  "action": "pass" },
		],
		"resolve_key": "dein_creek_crossing",
	},

	# Adult (stage 2+)

	"dein_sickle_strike": {
		"seasons": ["any"], "trees": ["predator"], "species": ["deinonychus"],
		"min_stage": 2, "rarity": "common", "passive": false,
		"flavor": "A distracted animal turns its flank toward you for one brief, clear moment. The position is exactly what you've been waiting for. The window is short.",
		"choices": [
			{ "label": "Strike now",    "icon": "attack", "sublabel": "Take the opening",       "action": "engage" },
			{ "label": "Wait for more", "icon": "stalk",  "sublabel": "Better window may come", "action": "pass" },
		],
		"resolve_key": "dein_sickle_strike",
	},
	"dein_tenonto_calf": {
		"seasons": ["spring", "summer"], "trees": ["predator"], "species": ["deinonychus"],
		"min_stage": 2, "rarity": "uncommon", "passive": false,
		"flavor": "A young Tenontosaurus lags behind the herd. Not by much — but the gap is there. The herd has not noticed the gap yet. The calf has not noticed you.",
		"choices": [
			{ "label": "Isolate it",     "icon": "attack", "sublabel": "High risk, large meal",  "action": "engage" },
			{ "label": "Leave it",       "icon": "flee",   "sublabel": "Herd will close fast",   "action": "pass" },
		],
		"resolve_key": "dein_tenonto_calf",
	},
	"dein_grapple_flank": {
		"seasons": ["any"], "trees": ["predator"], "species": ["deinonychus"],
		"min_stage": 2, "rarity": "uncommon", "passive": false,
		"flavor": "You have the angle on the prey's flank. The grapple option is there — hook the claws in, hold on, outlast the panic. Or you commit to a cleaner, faster approach.",
		"choices": [
			{ "label": "Grapple and hold", "icon": "attack", "sublabel": "Claws in, ride it out",  "action": "engage" },
			{ "label": "Don't commit",     "icon": "flee",   "sublabel": "Too risky if thrown",    "action": "pass" },
		],
		"resolve_key": "dein_grapple_flank",
	},
	"dein_ambush_scrub": {
		"seasons": ["any"], "trees": ["predator"], "species": ["deinonychus"],
		"min_stage": 2, "rarity": "common", "passive": false,
		"flavor": "Dense brush runs along a natural travel corridor. Anything moving through will pass within striking range of the scrub edge. The wind is right. The position is good.",
		"choices": [
			{ "label": "Hold position", "icon": "stalk", "sublabel": "Wait for prey to pass",   "action": "engage" },
			{ "label": "Move through",  "icon": "flee",  "sublabel": "Too long to wait here",   "action": "pass" },
		],
		"resolve_key": "dein_ambush_scrub",
	},
	"dein_carrion_teeth": {
		"seasons": ["any"], "trees": ["predator"], "species": ["deinonychus"],
		"min_stage": 2, "rarity": "common", "passive": false,
		"flavor": "A carcass lies half-hidden at the scrub edge, already opened. Something made this kill and left. The marks suggest something larger than you.",
		"choices": [
			{ "label": "Move in",    "icon": "hunt",  "sublabel": "Take what remains",         "action": "engage" },
			{ "label": "Leave it",  "icon": "flee",  "sublabel": "The maker may return",       "action": "pass" },
		],
		"resolve_key": "dein_carrion_teeth",
	},

	# Wounded adult (stage 2+, injured)

	"dein_bent_claw": {
		"seasons": ["any"], "trees": ["predator"], "species": ["deinonychus"],
		"min_stage": 2, "require_injured": true, "rarity": "common", "passive": false,
		"flavor": "Your killing claw aches after a bad strike — something pulled wrong at the joint. You're still walking on it. The question is how much you push it today.",
		"choices": [
			{ "label": "Work through it", "icon": "stalk", "sublabel": "Adapt the movement",    "action": "engage" },
			{ "label": "Rest the toe",    "icon": "flee",  "sublabel": "Give it time",          "action": "pass" },
		],
		"resolve_key": "dein_bent_claw",
	},
	"dein_blood_feathers": {
		"seasons": ["any"], "trees": ["predator"], "species": ["deinonychus"],
		"min_stage": 2, "require_injured": true, "rarity": "common", "passive": false,
		"flavor": "Blood has matted through your feathers near the wound. The scent it carries is moving ahead of you through the brush. Something may already be following it.",
		"choices": [
			{ "label": "Find water", "icon": "flee",  "sublabel": "Clean it before it spreads", "action": "engage" },
			{ "label": "Keep moving", "icon": "stalk", "sublabel": "Outpace whatever follows",  "action": "pass" },
		],
		"resolve_key": "dein_blood_feathers",
	},
	"dein_safe_hollow": {
		"seasons": ["any"], "trees": ["predator"], "species": ["deinonychus"],
		"min_stage": 2, "require_injured": true, "rarity": "uncommon", "passive": false,
		"flavor": "A shallow hollow beneath tangled roots offers cover from above and from either side. It smells clean. The entrance is narrow enough that nothing larger can follow.",
		"choices": [
			{ "label": "Go inside",   "icon": "stalk", "sublabel": "Rest and recover",         "action": "engage" },
			{ "label": "Keep going",  "icon": "flee",  "sublabel": "Too committed in a hollow", "action": "pass" },
		],
		"resolve_key": "dein_safe_hollow",
	},
	"dein_limping_hunt": {
		"seasons": ["any"], "trees": ["predator"], "species": ["deinonychus"],
		"min_stage": 2, "require_injured": true, "rarity": "common", "passive": false,
		"flavor": "You are hungry, but a full sprint risks reopening the wound. You have two approaches: push through and hunt hard, or adjust the method entirely.",
		"choices": [
			{ "label": "Hunt slow",   "icon": "stalk", "sublabel": "Ambush instead of chase",  "action": "engage" },
			{ "label": "Rest today",  "icon": "flee",  "sublabel": "The wound needs more time", "action": "pass" },
		],
		"resolve_key": "dein_limping_hunt",
	},

	# Pack / Group (require_pack)

	"dein_two_claw": {
		"seasons": ["any"], "trees": ["predator"], "species": ["deinonychus"],
		"require_pack": true, "rarity": "common", "passive": false,
		"flavor": "Another Deinonychus has circled to the opposite side of the same prey. You are both in position. Neither of you has moved yet.",
		"choices": [
			{ "label": "Coordinate",  "icon": "attack", "sublabel": "Match its timing",         "action": "engage" },
			{ "label": "Back off",    "icon": "flee",   "sublabel": "Uncoordinated is dangerous", "action": "pass" },
		],
		"resolve_key": "dein_two_claw",
	},
	"dein_dominance_display": {
		"seasons": ["any"], "trees": ["predator"], "species": ["deinonychus"],
		"require_pack": true, "rarity": "common", "passive": false,
		"flavor": "A rival Deinonychus raises its feathers to full height and begins clicking its claws against the ground in a slow, deliberate rhythm. It is looking directly at you.",
		"choices": [
			{ "label": "Display back",  "icon": "attack", "sublabel": "Answer it in full",      "action": "engage" },
			{ "label": "Look away",     "icon": "flee",   "sublabel": "Concede the ground",     "action": "pass" },
		],
		"resolve_key": "dein_dominance_display",
	},
	"dein_pack_trial": {
		"seasons": ["any"], "trees": ["predator"], "species": ["deinonychus"],
		"require_pack": true, "rarity": "uncommon", "passive": false,
		"flavor": "A loose hunting group tests whether you are worth including. They move past you, watching. If you can hold position and read their behavior, there may be a place in it.",
		"choices": [
			{ "label": "Hold and read",  "icon": "stalk", "sublabel": "Show you know the game",  "action": "engage" },
			{ "label": "Walk away",      "icon": "flee",  "sublabel": "Hunt alone",               "action": "pass" },
		],
		"resolve_key": "dein_pack_trial",
	},
	"dein_group_ambush": {
		"seasons": ["any"], "trees": ["predator"], "species": ["deinonychus"],
		"require_pack": true, "rarity": "uncommon", "passive": false,
		"flavor": "Several Deinonychus have positioned near a herd's weak side. The ambush is forming. Your position is at the edge of it — close enough to contribute, close enough to get caught in the chaos.",
		"choices": [
			{ "label": "Take position",  "icon": "attack", "sublabel": "Join the ambush",        "action": "engage" },
			{ "label": "Watch only",     "icon": "flee",   "sublabel": "Stay out of the push",   "action": "pass" },
		],
		"resolve_key": "dein_group_ambush",
	},
	"dein_share_snap": {
		"seasons": ["any"], "trees": ["predator"], "species": ["deinonychus"],
		"require_pack": true, "rarity": "common", "passive": false,
		"flavor": "A kill lies between you and another hungry Deinonychus. You both arrived at roughly the same time. Nobody has moved yet.",
		"choices": [
			{ "label": "Claim your share", "icon": "attack", "sublabel": "Hold position on it",  "action": "engage" },
			{ "label": "Step back",        "icon": "flee",   "sublabel": "Let them take it",     "action": "pass" },
		],
		"resolve_key": "dein_share_snap",
	},
	"dein_warning_feather": {
		"seasons": ["any"], "trees": ["predator"], "species": ["deinonychus"],
		"require_pack": true, "rarity": "common", "passive": false,
		"flavor": "A nearby packmate has flicked its tail feathers and gone absolutely still. No sound. Just the signal and the stillness. Something is wrong in the direction it's facing.",
		"choices": [
			{ "label": "React to it",    "icon": "flee",  "sublabel": "Trust the signal",       "action": "engage" },
			{ "label": "Check yourself", "icon": "stalk", "sublabel": "Maybe it overreacted",   "action": "pass" },
		],
		"resolve_key": "dein_warning_feather",
	},

	# Seasonal

	"dein_spring_nesting": {
		"seasons": ["spring"], "trees": ["predator"], "species": ["deinonychus"],
		"rarity": "common", "passive": false,
		"flavor": "The floodplain is full of hidden nests. Every depression in the brush, every sheltered root gap — something has nested in it. Parents are close. The eggs and hatchlings are closer.",
		"choices": [
			{ "label": "Work the nests",   "icon": "stalk", "sublabel": "Find one unguarded",   "action": "engage" },
			{ "label": "Leave them alone", "icon": "flee",  "sublabel": "Too many defenders",   "action": "pass" },
		],
		"resolve_key": "dein_spring_nesting",
	},
	"dein_muddy_tracks": {
		"seasons": ["spring"], "trees": ["predator"], "species": ["deinonychus"],
		"rarity": "common", "passive": false,
		"flavor": "Rain has turned the ground soft and every animal that crossed this area left a perfect record. The tracks overlap and the story is dense. The right trail is in here somewhere.",
		"choices": [
			{ "label": "Read the tracks", "icon": "stalk", "sublabel": "Find the right trail",  "action": "engage" },
			{ "label": "Keep moving",     "icon": "flee",  "sublabel": "Too much noise to read", "action": "pass" },
		],
		"resolve_key": "dein_muddy_tracks",
	},
	"dein_heat_chase": {
		"seasons": ["summer"], "trees": ["predator"], "species": ["deinonychus"],
		"rarity": "common", "passive": false,
		"flavor": "The day is brutally hot. The air above the scrub shimmers. A long sprint in this heat costs more than the prey may be worth — but the prey is also slower than usual.",
		"choices": [
			{ "label": "Hunt now",    "icon": "attack", "sublabel": "Use the window",           "action": "engage" },
			{ "label": "Rest first",  "icon": "flee",   "sublabel": "Wait for cooler hours",    "action": "pass" },
		],
		"resolve_key": "dein_heat_chase",
	},
	"dein_dry_river": {
		"seasons": ["summer"], "trees": ["predator"], "species": ["deinonychus"],
		"rarity": "uncommon", "passive": false,
		"flavor": "A drying river has narrowed to a series of crossings. Prey moving between the two sides must slow down and commit to the footing. The banks are a natural funnel.",
		"choices": [
			{ "label": "Work the crossing", "icon": "stalk", "sublabel": "Ambush at the bank",   "action": "engage" },
			{ "label": "Move on",           "icon": "flee",  "sublabel": "Others hunt here too", "action": "pass" },
		],
		"resolve_key": "dein_dry_river",
	},
	"dein_herd_movement": {
		"seasons": ["fall"], "trees": ["predator"], "species": ["deinonychus"],
		"rarity": "common", "passive": false,
		"flavor": "Herbivores are shifting feeding grounds before the cold season. The movement is slow but directional. The herd edges are less organized during transition than at rest.",
		"choices": [
			{ "label": "Follow the herd", "icon": "stalk", "sublabel": "Work the moving edge",  "action": "engage" },
			{ "label": "Hold territory",  "icon": "flee",  "sublabel": "Let the herd pass",     "action": "pass" },
		],
		"resolve_key": "dein_herd_movement",
	},
	"dein_rival_pack": {
		"seasons": ["fall"], "trees": ["predator"], "species": ["deinonychus"],
		"rarity": "uncommon", "passive": false,
		"flavor": "Other Deinonychus groups are moving into your hunting route. The scent is recent. They are not a long way off.",
		"choices": [
			{ "label": "Hold your route",  "icon": "stalk", "sublabel": "Make your presence clear", "action": "engage" },
			{ "label": "Reroute",          "icon": "flee",  "sublabel": "Not worth the conflict",   "action": "pass" },
		],
		"resolve_key": "dein_rival_pack",
	},
	"dein_winter_scarcity": {
		"seasons": ["winter"], "trees": ["predator"], "species": ["deinonychus"],
		"rarity": "common", "passive": false,
		"flavor": "Food is harder to find. What prey remains is thinner and less cautious than usual — the cold has done something to its alertness. Your own energy budget is tight.",
		"choices": [
			{ "label": "Hunt carefully", "icon": "stalk", "sublabel": "Work with what the cold left", "action": "engage" },
			{ "label": "Conserve",       "icon": "flee",  "sublabel": "Rest and wait it out",         "action": "pass" },
		],
		"resolve_key": "dein_winter_scarcity",
	},

	# Rare

	"dein_tenonto_stand": {
		"seasons": ["any"], "trees": ["predator"], "species": ["deinonychus"],
		"rarity": "rare", "passive": false,
		"flavor": "A Tenontosaurus has stopped and turned to face you. It is not running. It has planted its feet in a wide stance and its tail is raised. It has made a decision.",
		"choices": [
			{ "label": "Test it",    "icon": "attack", "sublabel": "Find the opening",         "action": "engage" },
			{ "label": "Back away",  "icon": "flee",   "sublabel": "That stance is serious",   "action": "pass" },
		],
		"resolve_key": "dein_tenonto_stand",
	},
	"dein_broken_claw_scar": {
		"seasons": ["any"], "trees": ["predator"], "species": ["deinonychus"],
		"rarity": "rare", "passive": false,
		"flavor": "You find old claw marks raked deep into a tree trunk — higher than your reach, wider than your span. Another Deinonychus marked this tree and had more weight behind it than you do.",
		"choices": [
			{ "label": "Read the marks",   "icon": "stalk", "sublabel": "Understand the territory", "action": "engage" },
			{ "label": "Move past",        "icon": "flee",  "sublabel": "Leave the claim alone",    "action": "pass" },
		],
		"resolve_key": "dein_broken_claw_scar",
	},
	"dein_feather_display": {
		"seasons": ["spring"], "trees": ["predator"], "species": ["deinonychus"],
		"rarity": "rare", "passive": false,
		"flavor": "Another Deinonychus stands in the morning light and fans its feathers to full display — every color visible, every feather extended. It is looking at you.",
		"choices": [
			{ "label": "Display back",   "icon": "attack", "sublabel": "Match it or exceed it",  "action": "engage" },
			{ "label": "Walk away",      "icon": "flee",   "sublabel": "Not the right moment",   "action": "pass" },
		],
		"resolve_key": "dein_feather_display",
	},
	"dein_cliffside": {
		"seasons": ["any"], "trees": ["predator"], "species": ["deinonychus"],
		"rarity": "rare", "passive": false,
		"flavor": "Prey has fled up a broken rock formation — uneven, angled, requiring balance over speed. The terrain neutralizes your sprint advantage. Your claws, however, were built for exactly this.",
		"choices": [
			{ "label": "Follow it up",  "icon": "attack", "sublabel": "Claws over terrain",     "action": "engage" },
			{ "label": "Let it go",     "icon": "flee",   "sublabel": "Footing is unpredictable", "action": "pass" },
		],
		"resolve_key": "dein_cliffside",
	},
	"dein_last_bite": {
		"seasons": ["any"], "trees": ["predator"], "species": ["deinonychus"],
		"rarity": "rare", "passive": false,
		"flavor": "A wounded prey animal has collapsed nearby. The wound pattern on it is not yours — something else brought it down and has not finished. The original predator may still be close.",
		"choices": [
			{ "label": "Claim it fast", "icon": "attack", "sublabel": "Take it before they return", "action": "engage" },
			{ "label": "Leave it",      "icon": "flee",   "sublabel": "Not worth the confrontation", "action": "pass" },
		],
		"resolve_key": "dein_last_bite",
	},

}
