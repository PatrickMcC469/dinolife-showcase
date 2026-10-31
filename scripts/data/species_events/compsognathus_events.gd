# Compsognathus encounter data — loaded by ActionResolver and EventsDB

const OUTCOME_EVENTS: Dictionary = {

	# ── JUVENILE (stages 0–1) ─────────────────────────────────────────────────

	"compi_lizard_sun": {
		"pass_flavor": "You pause at the rock's edge. The lizard is still spread on the stone, unaware. You turn away. Some hunts aren't worth the risk.",
		"w_food": 0.32,
		"buff":    { "stat": "speed", "amount": 0.10, "turns": 2, "source": "sun_warm",
		             "flavor": "The stone has been holding heat since sunrise. You press your belly flat and let it in — muscles loosening, legs feeling quick in a way they weren't this morning." },
		"nothing": { "flavor": "You edge closer and the lizard registers you in the last half-second. It's into the crack in the rock before you complete the movement. Gone without a sound." },
		"food":    { "hunger": 0.20,
		             "flavor": "One quick snap catches the lizard before it can turn. It is a small meal, but a welcome one." },
		"health":  { "health": 0.07,
		             "flavor": "You catch the lizard and eat on the sun-warmed stone. Then you stay a while, letting the heat ease your tired muscles." },
		"debuff":  { "stat": "speed", "amount": -0.08, "turns": 2, "source": "lizard_bite",
		             "flavor": "The lizard turns the moment you reach for it and bites the end of your snout. Small teeth, wrong place. Your next few movements are more cautious than they should be." },
	},

	"compi_shadow_sand": {
		"pass_flavor": "You flatten into cover and wait. The shadow makes another pass, then nothing. Whatever was up there moved on.",
		"w_buff": 0.16, "w_debuff": 0.10,
		"buff":    { "stat": "speed", "amount": 0.12, "turns": 2, "source": "panic_sprint",
		             "flavor": "The shadow passes overhead, and you sprint low into the brush. You reach cover before fear has time to slow you." },
		"nothing": { "flavor": "The shadow sweeps through once more and drifts north. A thermal, maybe. A cloud edge. Nothing comes down." },
		"food":    { "hunger": 0.16,
		             "flavor": "The shadow startles a small reptile from the brush. It runs straight into your path, and you catch it before it can turn." },
		"health":  { "health": 0.08,
		             "flavor": "The shadow sends you under the tangled root bank. In the dark and quiet, your breathing evens out. The wounds from this week aren't done healing, but they're further along now." },
		"debuff":  { "health": -0.08,
		             "flavor": "The flyer swoops lower on its second pass. A talon rakes your back before it climbs away, leaving a painful cut across your shoulder." },
	},

	"compi_egg_cache": {
		"pass_flavor": "You circle the nest once and step back. The parent has been gone a short time. You don't want to be here when it returns.",
		"w_food": 0.32, "w_buff": 0.10,
		"buff":    { "stat": "type_stat", "amount": 0.08, "turns": 3, "source": "nest_read",
		             "flavor": "Reading this nest — the species, the smell, the structure — tells you something about where these animals hide their eggs. That knowledge will surface again." },
		"nothing": { "flavor": "The shells are dry. Whatever hatched here did so days ago. The nest has been cold since. You find nothing worth the crouch." },
		"food":    { "hunger": 0.22,
		             "flavor": "One egg, sealed, unhatched — wedged under the shell rim where the parent wouldn't have seen it. Cool and dense. You eat quickly before anything changes." },
		"health":  { "health": 0.06,
		             "flavor": "You work carefully over the inside of the broken shell. The mineral-rich fragments help restore your strength." },
		"debuff":  { "stat": "speed", "amount": -0.08, "turns": 2, "source": "nest_chase",
		             "flavor": "You're still in the nest when you hear the parent land. You run immediately, and it pursues for longer than you expected. You leave the area faster and more spent than you arrived." },
	},

	"compi_big_footprint": {
		"pass_flavor": "You study the print for a moment, then keep moving. Something large enough to make this isn't something you want to be near.",
		"w_buff": 0.16, "w_debuff": 0.08,
		"buff":    { "stat": "type_stat", "amount": 0.10, "turns": 3, "source": "track_read",
		             "flavor": "The print tells you the stride length, the direction, the weight distribution — a full picture of what moved through here and when. You'll read the next set faster." },
		"nothing": { "flavor": "The print is old and the edges have collapsed. Whatever pattern it held has softened out. You learn nothing." },
		"food":    { "hunger": 0.12,
		             "flavor": "The insects that gathered in the water have nowhere to go. You eat slowly around the rim — not elegant, but effective." },
		"health":  { "health": 0.06,
		             "flavor": "Clean, cold rainwater fills the hollow. You drink until your thirst eases." },
		"debuff":  { "stat": "speed", "amount": -0.08, "turns": 2, "source": "mud_feet",
		             "flavor": "You step too close to the soft edge and one foot goes into the mud past the ankle. Pulling it free takes longer than it should and the sound is wrong." },
	},

	"compi_giant_cover": {
		"pass_flavor": "You let the herbivore pass. The insects it flushes drift back into the grass. You wait until the ground stops shaking.",
		"w_health": 0.22,
		"buff":    { "stat": "defense", "amount": 0.08, "turns": 3, "source": "giant_shadow",
		             "flavor": "You move in the herbivore's shadow and nothing predatory comes near. Whatever is hunting today doesn't want to deal with something that size. You are briefly invisible within it." },
		"nothing": { "flavor": "The herbivore changes direction and the insects scatter before you're positioned. The cover moves away." },
		"food":    { "hunger": 0.14,
		             "flavor": "The insects rise from the grass ahead of every step — you move through the flushed cloud, snapping continuously. It adds up." },
		"health":  { "health": 0.08,
		             "flavor": "You tuck in close to the herbivore's flank — not touching, just near enough that the shadow falls over you. Everything predatory is routing around the giant. You rest in that margin." },
		"debuff":  { "health": -0.10,
		             "flavor": "The herbivore's foot comes down on the spot where you were standing a second before. You get away, but the near miss has rattled something. You don't move right for a while." },
	},

	# ── SUBADULT (stages 1–2) ─────────────────────────────────────────────────

	"compi_skittering_hunt": {
		"pass_flavor": "You track the movement to the waterline brush and stop. Whatever it is has settled in thick cover. Not worth the push.",
		"w_food": 0.32, "w_buff": 0.14,
		"buff":    { "stat": "speed", "amount": 0.10, "turns": 2, "source": "quick_turn",
		             "flavor": "The chase is short, tight, and you turn with it every time. That kind of quick cut stays in the legs for a while." },
		"nothing": { "flavor": "The prey doubles back, goes under a root you can't follow, and is gone. You circle once, then stop." },
		"food":    { "hunger": 0.22,
		             "flavor": "You read its second cut before it made it. The interception was clean — right place, right moment. It didn't have the speed you did." },
		"health":  { "health": 0.08,
		             "flavor": "A clean catch on healthy prey. The meal is good and the effort was low. You eat fully." },
		"debuff":  { "stat": "speed", "amount": -0.08, "turns": 2, "source": "root_stumble",
		             "flavor": "You catch your foot on a root and tumble. The fall is short, but you land badly and hurt your leg." },
	},

	"compi_scraps_kill": {
		"pass_flavor": "The kill is recent. Recent means the hunter may still be nearby. You move past it.",
		"w_food": 0.34, "w_health": 0.20,
		"buff":    { "stat": "type_stat", "amount": 0.08, "turns": 3, "source": "scav_nerve",
		             "flavor": "You've eaten off kills like this before. The nerves settle. The smell is just food now, not danger. You move through it calmly and take what you need." },
		"nothing": { "flavor": "You work the carcass for a while and find nothing — bones picked down to white, every joint opened. Nothing for your size remains." },
		"food":    { "hunger": 0.26,
		             "flavor": "There's a section under the ribcage that was folded away from view — dark, soft, still good. You eat quickly and move." },
		"health":  { "health": 0.10,
		             "flavor": "Marrow remains inside the long bones. You work it loose carefully, finding a rich meal where others left only scraps." },
		"debuff":  { "stat": "speed", "amount": -0.10, "turns": 2, "source": "predator_return",
		             "flavor": "You're in the carcass when you hear the footsteps — heavy, unhurried, confident. You run without waiting to see what's coming. You run longer and harder than you planned." },
	},

	"compi_rival_jaws": {
		"pass_flavor": "You stop and watch it. It watches you. After a moment you both decide the territory is large enough and leave in separate directions.",
		"w_buff": 0.14, "w_food": 0.26,
		"buff":    { "stat": "strength", "amount": 0.08, "turns": 2, "source": "scrap_fighter",
		             "flavor": "The posturing lasts longer than it should. By the end of it, you know exactly how this kind of contest resolves — and you won this one." },
		"nothing": { "flavor": "You square off. Neither of you commits. It eventually turns and goes. You both got nothing." },
		"food":    { "hunger": 0.18,
		             "flavor": "It misjudges your speed and you take the food out of the gap it leaves. Small but yours." },
		"health":  { "health": 0.06,
		             "flavor": "The other Compsognathus retreats. With the contest over, you relax and catch your breath." },
		"debuff":  { "health": -0.07,
		             "flavor": "It bites your tail when you don't immediately back off. The grip is brief but it finds something real. You leave with a limp you'll feel for two days." },
	},

	"compi_watchpost": {
		"pass_flavor": "You climb up, look, come down. Nothing justifies staying exposed that long.",
		"w_buff": 0.18, "w_health": 0.20, "w_debuff": 0.10,
		"buff":    { "stat": "type_stat", "amount": 0.12, "turns": 3, "source": "high_alert",
		             "flavor": "From up here the whole territory makes sense — movement patterns, routes, the direction things travel at what hour. You'll move through today like you know where everything is. Because now you do." },
		"nothing": { "flavor": "The flat rock is warm and the view is good. Nothing moves below. You come down having seen a lot of empty land." },
		"food":    { "hunger": 0.16,
		             "flavor": "From altitude you catch a movement in the scrub below — a lizard trail, breaking south. You know the intercept angle." },
		"health":  { "health": 0.08,
		             "flavor": "From the warm rock, you can see the ground all around you. An undisturbed rest leaves you refreshed." },
		"debuff":  { "stat": "defense", "amount": -0.10, "turns": 2, "source": "sky_exposure",
		             "flavor": "You're up there longer than you should be and something below spots you against the sky. It starts moving toward the rock. You come down fast and spend the rest of the day on edge." },
	},

	"compi_insect_bloom": {
		"pass_flavor": "You watch the swarm drift south and let it go. Too scattered to chase, too brief to follow.",
		"w_food": 0.32,
		"buff":    { "stat": "speed", "amount": 0.08, "turns": 2, "source": "fast_snaps",
		             "flavor": "The swarm is dense enough to snap continuously without tracking individuals. You learn the rhythm — quick, brief, efficient. That speed carries over." },
		"nothing": { "flavor": "The swarm drifts north faster than you can follow. It's gone before you can close." },
		"food":    { "hunger": 0.16,
		             "flavor": "You get underneath the thickest part and snap upward, continuously, for several minutes. Not elegant, but the hunger eases." },
		"health":  { "health": 0.07,
		             "flavor": "Insects swarm within easy reach. You barely need to move to fill your belly." },
		"debuff":  { "stat": "type_stat", "amount": -0.10, "turns": 2, "source": "biting_insects",
		             "flavor": "The outer edge of the swarm includes something with teeth. Small and persistent — it finds the skin around your eye and doesn't let go immediately. The irritation lingers for hours." },
	},

	# ── ADULT (stage 2+) ──────────────────────────────────────────────────────

	"compi_lagoon_patrol": {
		"pass_flavor": "The mudflat is good but exposed. You watch from the scrub edge and decide the risk isn't right today.",
		"w_food": 0.30, "w_health": 0.20,
		"buff":    { "stat": "speed", "amount": 0.08, "turns": 3, "source": "mudstepper",
		             "flavor": "The mud is soft enough to sink into but firm enough to run on if you know how. You figure it out. This ground stops other hunters." },
		"nothing": { "flavor": "The tide took more than you expected. What looked like a productive flat is stripped bare — shells and mud and nothing that moves." },
		"food":    { "hunger": 0.28,
		             "flavor": "A small fish is beached in a shrinking pool, too far into the flat to escape. You reach it before the water does." },
		"health":  { "health": 0.10,
		             "flavor": "You drink from the pools and eat what the tide has left behind. The easy meal helps you recover." },
		"debuff":  { "stat": "speed", "amount": -0.10, "turns": 2, "source": "mud_trap",
		             "flavor": "You step into a section that looks firm and sink past the ankle. By the time you're back on solid ground you've spent something you needed." },
	},

	"compi_stolen_mouthful": {
		"pass_flavor": "You look at it for a long moment. Then you look at the surrounding ground one more time. Then you leave.",
		"w_food": 0.30, "w_debuff": 0.16,
		"buff":    { "stat": "type_stat", "amount": 0.10, "turns": 3, "source": "bold_thief",
		             "flavor": "You take it and it works. You're bolder near kills after this. The hesitation is smaller next time." },
		"nothing": { "flavor": "You approach the meat, but its scent and the exposed ground make you uneasy. You back away without feeding." },
		"food":    { "hunger": 0.30,
		             "flavor": "You take it in one movement — in and gone before anything changes. The meat is rich and you're already a hundred paces away before you eat it." },
		"health":  { "health": 0.10,
		             "flavor": "You pull free a rich strip of meat. It is more nourishing than anything you have caught this week." },
		"debuff":  { "health": -0.12,
		             "flavor": "The hunter came back faster than you calculated. The snap it makes doesn't connect, but you run harder than you've run this season and there's a cost to that." },
	},

	"compi_crevice_runner": {
		"pass_flavor": "You crouch at the entrance and read the depth. Too narrow, too committed. You step back.",
		"w_food": 0.30, "w_health": 0.20,
		"buff":    { "stat": "type_stat", "amount": 0.10, "turns": 3, "source": "crevice_run",
		             "flavor": "The chase ends in your favor because nothing else could follow you in here. The crevice is a tool now — you know what that means for every hunt that follows." },
		"nothing": { "flavor": "You push in and find an empty space. Whatever went in has another exit. You back out with nothing." },
		"food":    { "hunger": 0.20,
		             "flavor": "The lizard ran into a dead end. You're at the entrance and it's at the back and there is nothing left for it to do." },
		"health":  { "health": 0.10,
		             "flavor": "The crevice is dry and sheltered and nothing can reach you. You sleep here for a few hours without a sound from outside." },
		"debuff":  { "health": -0.07,
		             "flavor": "You squeeze through the crack too quickly. Rough stone scrapes your side, leaving a shallow cut." },
	},

	"compi_dust_tracker": {
		"pass_flavor": "You read the tracks, note the direction, and move past. Interesting. Not useful yet.",
		"w_buff": 0.16, "w_nothing": 0.26,
		"buff":    { "stat": "type_stat", "amount": 0.12, "turns": 3, "source": "dust_track",
		             "flavor": "You study the tracks in the dust, learning where animals feed and which paths they follow." },
		"nothing": { "flavor": "The wind comes up before you've made anything of it. The surface swirls and the records smooth over." },
		"food":    { "hunger": 0.22,
		             "flavor": "One set of tiny tracks leads you to a lizard that hasn't moved since dawn — heat-stunned, flat on a dark stone. You read the trail to the stone." },
		"health":  { "health": 0.08,
		             "flavor": "You follow the shade line in the dust — animals always stop in the shade — and find a flat, protected spot on the shaded side of a rock. You rest in it until the light changes." },
		"debuff":  { "stat": "type_stat", "amount": -0.10, "turns": 2, "source": "dust_eyes",
		             "flavor": "Dust stings your eyes and clogs your nose. You found the trail, but following it will be harder until the irritation fades." },
	},

	"compi_bigger_hunter": {
		"pass_flavor": "You read the situation and back out of it. Let the bigger one have the prey. You'll find another.",
		"w_buff": 0.14, "w_health": 0.22,
		"buff":    { "stat": "type_stat", "amount": 0.08, "turns": 3, "source": "patience",
		             "flavor": "You wait. The bigger hunter flushes the prey wrong. You note the movement patterns before it does. The patience is worth something — the ambush next time will be sharper." },
		"nothing": { "flavor": "You both hold position long enough that the prey notices the total stillness and chooses a third direction. You watch it go." },
		"food":    { "hunger": 0.22,
		             "flavor": "The bigger hunter commits too early, flushes the prey wrong, and the small animal runs directly toward your intercept position." },
		"health":  { "health": 0.09,
		             "flavor": "You withdraw before the bigger hunter detects you. In the safe distance, you rest in good cover while it takes the kill. You lose the food. You gain the rest." },
		"debuff":  { "health": -0.08,
		             "flavor": "The bigger hunter finally detects you and doesn't ignore it. It runs you off the territory at speed. You run until you're sure it's done following." },
	},

	# ── WOUNDED ADULT (require_injured) ──────────────────────────────────────

	"compi_quiet_hollow": {
		"pass_flavor": "You crouch at the entrance and smell the air inside. Something feels wrong. You leave it.",
		"w_health": 0.34, "w_debuff": 0.10,
		"buff":    { "stat": "type_stat", "amount": 0.12, "turns": 3, "source": "hidden_rest",
		             "flavor": "The hollow is perfect. You fit. Nothing else does. Whatever is tracking you by scent will pass this opening and keep walking." },
		"nothing": { "flavor": "The hollow smells occupied — old urine, old musk. You're not willing to share the space. You find somewhere else." },
		"food":    { "hunger": 0.14,
		             "flavor": "The hollow is busy with small life — beetles, tiny lizards, something soft under the root edge. You eat before you rest." },
		"health":  { "health": 0.15,
		             "flavor": "You fit into the hollow exactly. You sleep heavily for the first time since you were hurt. Something in the wound has knit closer by the time you wake." },
		"debuff":  { "stat": "defense", "amount": -0.10, "turns": 3, "source": "parasites",
		             "flavor": "You sleep in the hollow and wake with new discomfort — bites in the wound margins, something that was already there before you arrived. The wound is worse." },
	},

	"compi_blood_scent": {
		"pass_flavor": "You change direction, cross water, press into the brush. You can't outrun the scent, so you change the trail.",
		"w_buff": 0.14, "w_debuff": 0.16,
		"buff":    { "stat": "speed", "amount": 0.14, "turns": 2, "source": "desperation",
		             "flavor": "The threat behind you turns something sharp. You're moving faster than you thought you could in this condition. The urgency becomes speed." },
		"nothing": { "flavor": "Whatever was following the scent trail loses it at the water crossing. The pursuit ends without contact." },
		"food":    { "hunger": 0.18,
		             "flavor": "Running from the scent trail leads you through an area you wouldn't have crossed. You find a cold carcass on the route — uncontested, recently dead." },
		"health":  { "health": 0.10,
		             "flavor": "You find standing water and go in. Clean, cold, moving slightly. You hold the wound in the current until the bleeding stops properly." },
		"debuff":  { "health": -0.15,
		             "flavor": "The thing following the scent trail finds you. It's faster than you in this state and it commits. The damage it does before you get away is real." },
	},

	"compi_limping_rain": {
		"pass_flavor": "You get under cover and wait out the rain. When it stops the ground is clean and the trail behind you is gone.",
		"w_buff": 0.16, "w_health": 0.22,
		"buff":    { "stat": "defense", "amount": 0.10, "turns": 3, "source": "washed_scent",
		             "flavor": "The rain is erasing everything behind you. Whatever was tracking you by smell is now working blind. The margin you gain is worth the wet." },
		"nothing": { "flavor": "You wait in the rain. It passes. You're wetter than before and no better positioned." },
		"food":    { "hunger": 0.14,
		             "flavor": "The rain drives everything small to the surface. Worms and soft insects near the waterlogged roots — easy pickings while you wait." },
		"health":  { "health": 0.10,
		             "flavor": "The cold rain hits the wound directly for a while and somehow it helps — cleaner afterward, the inflammation less. Rest in the wet scrub does the rest." },
		"debuff":  { "health": -0.12,
		             "flavor": "The wet ground betrays you. You land wrong and feel the wound pull open. The progress from the last few days reverses." },
	},

	"compi_old_bite": {
		"pass_flavor": "You keep moving. The stiffness will work out. The wound is closing. That's what matters.",
		"w_buff": 0.14, "w_health": 0.28, "w_debuff": 0.10,
		"buff":    { "stat": "defense", "amount": 0.06, "turns": 0, "source": "scar_tissue", "perm": true,
		             "perm_label": "Scarred Survivor",
		             "flavor": "The scar tissue that forms at a wound site is denser than what was there before — harder to open again. You've been through this. You'll go through it differently next time." },
		"nothing": { "flavor": "The wound aches throughout the day and you move more carefully than usual because of it. You end the day unchanged." },
		"food":    { "hunger": 0.16,
		             "flavor": "You move slowly and that turns out to be right — you get closer to prey than your usual approach allows, because there's no fast movement to read. Slow today is effective." },
		"health":  { "health": 0.14,
		             "flavor": "The ache begins to ease. By evening, you can move more comfortably than you could this morning." },
		"debuff":  { "stat": "speed", "amount": -0.10, "turns": 2, "source": "stiffness",
		             "flavor": "The stiffness from the closing wound has shortened your stride. You misjudge a gap and land badly. The scar holds, but the leg is worse." },
	},

	# ── PACK / GROUP (require_pack) ───────────────────────────────────────────

	"compi_loose_foragers": {
		"pass_flavor": "You let the group move through without joining. They pass. You follow the same direction at your own pace.",
		"w_food": 0.30, "w_health": 0.20,
		"buff":    { "stat": "type_stat", "amount": 0.10, "turns": 3, "source": "forager_chain",
		             "flavor": "You fall in with the group and the chain works. What one flushes, another catches. You eat better when the movement is shared." },
		"nothing": { "flavor": "You move to join and the group scatters before you reach it — something startled them, or they just moved on. You're alone with the same territory." },
		"food":    { "hunger": 0.24,
		             "flavor": "The foraging group flushes a lizard toward you. You were already in position from watching their approach." },
		"health":  { "health": 0.08,
		             "flavor": "The group forages slowly through a safe section of territory. Nothing comes near. You rest in the moving cover of the group." },
		"debuff":  { "hunger": -0.08,
		             "flavor": "You arrive and the food is already being contested. The group is too tight and nobody's sharing. You get bitten twice and leave with nothing." },
	},

	"compi_many_eyes": {
		"pass_flavor": "You freeze with the group. Hold position. Whatever it detected, it doesn't develop. The call was right.",
		"w_buff": 0.18, "w_health": 0.20,
		"buff":    { "stat": "defense", "amount": 0.12, "turns": 2, "source": "warning_calls",
		             "flavor": "The call tells you where to look before you see anything. You get the picture two full seconds before you would have on your own. Today you'll be harder to surprise." },
		"nothing": { "flavor": "The caller settles after a minute. Whatever triggered it turns out to be nothing. A falling branch. Something harmless." },
		"food":    { "hunger": 0.14,
		             "flavor": "The alarm sent everything small into motion. You catch one of them in the confusion before it finds cover." },
		"health":  { "health": 0.08,
		             "flavor": "You follow the alarm and find safe distance before the threat — whatever it was — passes through. You rest in the gap." },
		"debuff":  { "health": -0.10,
		             "flavor": "You don't react fast enough to the call. By the time you move, the situation has already developed. You take the consequence you could have avoided." },
	},

	"compi_scramble_feast": {
		"pass_flavor": "You hold back and watch. The scramble looks like it will hurt the last one to arrive. You wait until it's done.",
		"w_food": 0.32, "w_nothing": 0.26,
		"buff":    { "stat": "speed", "amount": 0.08, "turns": 2, "source": "fast_mouth",
		             "flavor": "You get in early and get out fast. The feeding was quick but clean. You know how to read that kind of contest now." },
		"nothing": { "flavor": "You arrive and the carcass is gone — picked to nothing in the time it took you to close the distance. The group disperses." },
		"food":    { "hunger": 0.22,
		             "flavor": "You get there fast and grab a portion before the competition tightens. Not a full meal, but real." },
		"health":  { "health": 0.10,
		             "flavor": "You find a section of the carcass that the scramble missed. You eat it alone, quickly, properly. Rich food. Good recovery." },
		"debuff":  { "health": -0.08,
		             "flavor": "You're in the middle of it when someone bites you — not maliciously, just the chaos of the scramble. You leave with a bite on your flank." },
	},

	"compi_bold_one": {
		"pass_flavor": "You watch it go and decide not to follow. It may know something. It may be wrong.",
		"w_food": 0.30, "w_debuff": 0.14,
		"buff":    { "stat": "type_stat", "amount": 0.10, "turns": 3, "source": "learned_route",
		             "flavor": "Following it teaches you a route you've never taken — the angles, the distances, the cover pattern. You know this territory better now." },
		"nothing": { "flavor": "It leads you a long way out before the confidence falters. You come back from further away with nothing." },
		"food":    { "hunger": 0.24,
		             "flavor": "It goes exactly where it seemed to be going. The rock field is full of lizards. You both eat." },
		"health":  { "health": 0.10,
		             "flavor": "It leads you somewhere small and hidden and clearly safe. You don't know how it found this. You rest here fully." },
		"debuff":  { "health": -0.10,
		             "flavor": "The bold one leads you too close to something it didn't see. You both run in different directions. You come out worse than you went in." },
	},

	"compi_pack_split": {
		"pass_flavor": "You hold still. The scrub around you is silent. You wait until you're certain of the direction of threat.",
		"w_buff": 0.14, "w_health": 0.20,
		"buff":    { "stat": "type_stat", "amount": 0.10, "turns": 3, "source": "independent",
		             "flavor": "Alone, you find you read your own range better than you do in the group. You move through it with more precision. The solo instinct is sharper." },
		"nothing": { "flavor": "You wait a while and the group drifts back together. The trigger for the scatter was nothing significant. Everybody's fine." },
		"food":    { "hunger": 0.16,
		             "flavor": "On your own, moving quietly, you find a feeding spot the group would have flattened. A lizard in the leaf litter. Easy." },
		"health":  { "health": 0.08,
		             "flavor": "Solo means no competition and no attention. You find a quiet place and rest properly until the group reassembles." },
		"debuff":  { "stat": "defense", "amount": -0.10, "turns": 2, "source": "lost_cover",
		             "flavor": "Without the group, the territory feels different. Something you wouldn't have encountered in a group comes close. You leave without cover." },
	},

	# ── SEASONAL ─────────────────────────────────────────────────────────────

	"compi_spring_hatchlings": {
		"pass_flavor": "The parents are too close and too alert. You circle the area and don't stop.",
		"w_food": 0.32, "w_buff": 0.14,
		"buff":    { "stat": "type_stat", "amount": 0.12, "turns": 4, "source": "nest_finder",
		             "flavor": "You learn the nest structure — where they hide them, how to approach without triggering the parent. This skill persists into the season." },
		"nothing": { "flavor": "Every nest you find has a parent within sight. You can't get close to anything. The timing is wrong." },
		"food":    { "hunger": 0.24,
		             "flavor": "A nest at the scrub edge, unguarded for a single window of time. You eat quickly. The parent returns to nothing." },
		"health":  { "health": 0.08,
		             "flavor": "Easy calories across the whole morning. Hatchlings everywhere, slow and small. You eat well with almost no effort." },
		"debuff":  { "health": -0.10,
		             "flavor": "The parent came back faster than you expected and it's bigger than the nest suggested. You run. It follows further than it should have." },
	},

	"compi_baked_stones": {
		"pass_flavor": "You stay in the shade. The heat is genuinely dangerous for something your size. You rest instead.",
		"w_buff": 0.14, "w_food": 0.30,
		"buff":    { "stat": "speed", "amount": 0.10, "turns": 2, "source": "heat_skitter",
		             "flavor": "The heat has slowed everything down to your speed. You sprint, then stop. The intervals work in your favor when nothing else can sustain them." },
		"nothing": { "flavor": "The heat is real and the prey is hidden. You spend the day moving slowly between patches of shade." },
		"food":    { "hunger": 0.18,
		             "flavor": "A lizard has pressed itself flat on a dark rock and hasn't moved in hours. Heat-stunned. You walk up to it." },
		"health":  { "health": 0.08,
		             "flavor": "You find a wide flat stone in full sun and spread out across it. The warmth goes deep. You feel genuinely recovered after." },
		"debuff":  { "stat": "speed", "amount": -0.12, "turns": 2, "source": "overheat",
		             "flavor": "You push further into the heat than you should looking for prey. The sun does something to your movement — slower, heavier. You stop before you mean to." },
	},

	"compi_rot_patch": {
		"pass_flavor": "The smell is warning enough. You circle the patch and move on.",
		"w_food": 0.32, "w_debuff": 0.14,
		"buff":    { "stat": "type_stat", "amount": 0.08, "turns": 2, "source": "bug_feast",
		             "flavor": "The insects here are thick and slow and you eat through the swarm efficiently. The method stays with you." },
		"nothing": { "flavor": "The insect bloom was yesterday. The patch is stripped to mud and smell. You leave with nothing." },
		"food":    { "hunger": 0.20,
		             "flavor": "The rot has drawn everything in. You eat through insects, grubs, and two slow beetles without moving more than a few steps." },
		"health":  { "health": 0.07,
		             "flavor": "You pick insects from the rotting plants. The easy meal helps restore your strength." },
		"debuff":  { "health": -0.10,
		             "flavor": "You eat something from the rot that shouldn't have been eaten. By the time you register the wrong taste it's already past. The rest of the day is worse." },
	},

	"compi_winter_shore": {
		"pass_flavor": "You read the tide line for a long moment and decide the exposure isn't worth it. You stay back.",
		"w_health": 0.24, "w_debuff": 0.10,
		"buff":    { "stat": "defense", "amount": 0.10, "turns": 3, "source": "cold_caution",
		             "flavor": "The cold has made you slower, so you've made yourself quieter. You move through the empty shore like you're part of it." },
		"nothing": { "flavor": "The winter shore is empty. Truly empty. You find nothing and no one finds you." },
		"food":    { "hunger": 0.14,
		             "flavor": "Under a slab of rock at the tide line — preserved, cold-stored, something that died before the freeze and stayed intact. You eat." },
		"health":  { "health": 0.12,
		             "flavor": "You find a hollow in the stone seawall, sheltered from the wind on all sides, and sleep in it. The warmth you generate doesn't escape. You wake more recovered than expected." },
		"debuff":  { "stat": "speed", "amount": -0.10, "turns": 2, "source": "cold_stiff",
		             "flavor": "The cold gets into you before you're back under cover. The exposure costs something — movement is stiffer, recovery is slower." },
	},

	# ── RARE ─────────────────────────────────────────────────────────────────

	"compi_giant_dragonfly": {
		"pass_flavor": "You watch it for a long moment, genuinely uncertain. Then it lifts off and makes the decision for you.",
		"w_buff": 0.20, "w_food": 0.30, "w_debuff": 0.08,
		"buff":    { "stat": "speed", "amount": 0.12, "turns": 3, "source": "snap_reflex",
		             "flavor": "The catch requires timing you normally only approach. For a moment you operate at the absolute edge of your reflex capability. That ceiling feels a little higher now." },
		"nothing": { "flavor": "It was still for thirty seconds, which felt like forever. Then it lifted off in one motion and was thirty feet away before you'd finished your approach." },
		"food":    { "hunger": 0.18,
		             "flavor": "You snap it before it registers the danger. It's the size of your foreleg and dense with protein. You've never eaten something this good this easily." },
		"health":  { "health": 0.10,
		             "flavor": "You eat slowly and stay still afterward. The unusually rich meal restores some of your strength." },
		"debuff":  { "health": -0.06,
		             "flavor": "It scratches you across the foreleg with its legs as it escapes — fine lines, like thorns. They sting out of proportion to their size." },
	},

	"compi_falling_feather": {
		"pass_flavor": "You watch the feather land. You look up once. Then you move on.",
		"w_buff": 0.18, "w_health": 0.22,
		"buff":    { "stat": "type_stat", "amount": 0.14, "turns": 4, "source": "nest_sense",
		             "flavor": "The feather means a nest somewhere above. You know the structure, the smell signature, what to look for in the canopy. The knowledge opens a food source." },
		"nothing": { "flavor": "You follow the feather's drift to where it settled. The ground below it tells you nothing. Whatever dropped it is gone." },
		"food":    { "hunger": 0.14,
		             "flavor": "The feather led you to the tree base. The tree has a hollow. The hollow has something small in it." },
		"health":  { "health": 0.10,
		             "flavor": "The feather leads you to a deep nest hollow in the roots — lined with similar material, hidden, dry, warm. You sleep there until you're done." },
		"debuff":  { "health": -0.10,
		             "flavor": "You follow the feather's drift into a territory you don't know. The resident was already watching your approach." },
	},

	"compi_salt_shore": {
		"pass_flavor": "The crust makes too much noise. You step back and leave the flat alone.",
		"w_food": 0.30, "w_buff": 0.16,
		"buff":    { "stat": "speed", "amount": 0.10, "turns": 3, "source": "shore_run",
		             "flavor": "You learn how to move across the salt crust without breaking it — weight distribution, pace, where to put each foot. This ground type is yours now." },
		"nothing": { "flavor": "The crust is too thick and too uniform. The pools beneath are sealed. Whatever was trapped is inaccessible." },
		"food":    { "hunger": 0.22,
		             "flavor": "The shallow pools have sealed over some small animals — fish, a tiny crustacean, something soft. Still alive and easy to reach." },
		"health":  { "health": 0.10,
		             "flavor": "You drink from the mineral pools and rest on the flat stone above. The minerals do something. You feel the difference." },
		"debuff":  { "stat": "speed", "amount": -0.12, "turns": 2, "source": "salt_cut",
		             "flavor": "The crust breaks under one foot and the edge is sharper than stone. You cut the underside of your foot on the salt crystal. The sting is wrong." },
	},

	"compi_wrong_chirp": {
		"pass_flavor": "You freeze, read the sound again, then move away from it. Something is wrong with that call.",
		"w_buff": 0.18, "w_debuff": 0.14,
		"buff":    { "stat": "type_stat", "amount": 0.12, "turns": 3, "source": "call_sense",
		             "flavor": "The slight wrongness in the call teaches you what right sounds like. You'll hear the next fake before anyone else does." },
		"nothing": { "flavor": "You investigate carefully and find nothing. The call was an echo off the rock face, shaped into a recognizable pattern by accident." },
		"food":    { "hunger": 0.16,
		             "flavor": "Another Compsognathus was here and abandoned a meal to flee the area. You take what it left." },
		"health":  { "health": 0.10,
		             "flavor": "The call was from a distressed group member that went still near a safe hollow. You find it. You find the hollow." },
		"debuff":  { "health": -0.12,
		             "flavor": "Something was following the call to see what would respond. You responded. It was waiting." },
	},
}

const EVENTS: Dictionary = {
	# ── COMPSOGNATHUS EVENTS ──────────────────────────────────────────────────
	# Juvenile (stages 0–1)

	"compi_lizard_sun": {
		"seasons": ["any"], "trees": ["predator"], "species": ["compsognathus"],
		"min_stage": 0, "max_stage": 1, "rarity": "common", "passive": false,
		"flavor": "A small lizard lies flat on a warm stone at the lagoon edge, body spread wide, eyes half-closed. It hasn't seen you. The stone is still warm from the morning sun.",
		"choices": [
			{ "label": "Approach slowly", "icon": "stalk", "sublabel": "Move in carefully", "action": "engage" },
			{ "label": "Move on",         "icon": "flee",  "sublabel": "Leave it alone",    "action": "pass" },
		],
		"resolve_key": "compi_lizard_sun",
	},
	"compi_shadow_sand": {
		"seasons": ["any"], "trees": ["predator"], "species": ["compsognathus"],
		"min_stage": 0, "max_stage": 1, "rarity": "common", "passive": false,
		"flavor": "A shadow crosses the ground in one smooth arc — too large for a small flyer, too fast for a cloud. Something above is circling. You don't know yet whether it noticed you.",
		"choices": [
			{ "label": "Take cover",  "icon": "stalk", "sublabel": "Get out of the open", "action": "engage" },
			{ "label": "Stay still", "icon": "flee",   "sublabel": "Don't draw attention", "action": "pass" },
		],
		"resolve_key": "compi_shadow_sand",
	},
	"compi_egg_cache": {
		"seasons": ["spring", "summer"], "trees": ["predator"], "species": ["compsognathus"],
		"min_stage": 0, "max_stage": 1, "rarity": "common", "passive": false,
		"flavor": "A shallow scrape in the brush, ringed with broken shell. Something hatched here recently — the pieces are still damp at the edges. The nest is unguarded. The parent may not have gone far.",
		"choices": [
			{ "label": "Search the nest", "icon": "stalk", "sublabel": "See what's left",        "action": "engage" },
			{ "label": "Leave it",        "icon": "flee",  "sublabel": "The parent will return", "action": "pass" },
		],
		"resolve_key": "compi_egg_cache",
	},
	"compi_big_footprint": {
		"seasons": ["any"], "trees": ["predator"], "species": ["compsognathus"],
		"min_stage": 0, "max_stage": 1, "rarity": "common", "passive": false,
		"flavor": "A single footprint has collected rainwater overnight. The depression is wider than you are long. Beetles and water insects move across the surface. Whatever made this passed through in the dark.",
		"choices": [
			{ "label": "Read the sign",  "icon": "stalk", "sublabel": "Study the track",    "action": "engage" },
			{ "label": "Keep moving",   "icon": "flee",   "sublabel": "Not your territory", "action": "pass" },
		],
		"resolve_key": "compi_big_footprint",
	},
	"compi_giant_cover": {
		"seasons": ["any"], "trees": ["predator"], "species": ["compsognathus"],
		"min_stage": 0, "max_stage": 1, "rarity": "common", "passive": false,
		"flavor": "A large herbivore moves through the scrub toward you — not quickly, just following its course. Insects rise from the grass ahead of every step. The ground shakes in a low, steady rhythm.",
		"choices": [
			{ "label": "Move with it", "icon": "stalk", "sublabel": "Use its shadow for cover",  "action": "engage" },
			{ "label": "Wait it out", "icon": "flee",   "sublabel": "Let it pass by",            "action": "pass" },
		],
		"resolve_key": "compi_giant_cover",
	},

	# Subadult (stages 1–2)

	"compi_skittering_hunt": {
		"seasons": ["any"], "trees": ["predator"], "species": ["compsognathus"],
		"min_stage": 1, "max_stage": 2, "rarity": "common", "passive": false,
		"flavor": "Something bolts through dry leaves twenty paces ahead — fast, low to the ground, heading for the dense cover near the waterline. You caught the movement before your mind named it.",
		"choices": [
			{ "label": "Give chase",    "icon": "attack", "sublabel": "Sprint and cut it off",  "action": "engage" },
			{ "label": "Let it go",     "icon": "flee",   "sublabel": "Not worth the effort",   "action": "pass" },
		],
		"resolve_key": "compi_skittering_hunt",
	},
	"compi_scraps_kill": {
		"seasons": ["any"], "trees": ["predator"], "species": ["compsognathus"],
		"min_stage": 1, "max_stage": 2, "rarity": "common", "passive": false,
		"flavor": "A larger predator fed here and left. The carcass is ragged, bones pulled free of the socket, flesh dark on the exposed rib. Enough remains for something your size. The kill is cooling.",
		"choices": [
			{ "label": "Move in quickly", "icon": "attack", "sublabel": "Take what you can",    "action": "engage" },
			{ "label": "Walk past",       "icon": "flee",   "sublabel": "Owner may return",     "action": "pass" },
		],
		"resolve_key": "compi_scraps_kill",
	},
	"compi_rival_jaws": {
		"seasons": ["any"], "trees": ["predator"], "species": ["compsognathus"],
		"min_stage": 1, "max_stage": 2, "rarity": "common", "passive": false,
		"flavor": "Another young Compsognathus is working the same strip of scrub you are. It has found something and knows you're watching. It turns to face you with its find still in its mouth.",
		"choices": [
			{ "label": "Stand your ground", "icon": "attack", "sublabel": "Make it defend its claim", "action": "engage" },
			{ "label": "Move off",          "icon": "flee",   "sublabel": "Not worth fighting over",  "action": "pass" },
		],
		"resolve_key": "compi_rival_jaws",
	},
	"compi_watchpost": {
		"seasons": ["any"], "trees": ["predator"], "species": ["compsognathus"],
		"min_stage": 1, "max_stage": 2, "rarity": "uncommon", "passive": false,
		"flavor": "A flat rock overlooks the tidal flat and the low brush below. From here you can see movement before anything sees you. You have not yet decided what to do with that advantage.",
		"choices": [
			{ "label": "Climb up and watch", "icon": "stalk", "sublabel": "Read the territory",       "action": "engage" },
			{ "label": "Stay low",           "icon": "flee",  "sublabel": "Exposed up there",         "action": "pass" },
		],
		"resolve_key": "compi_watchpost",
	},
	"compi_insect_bloom": {
		"seasons": ["summer"], "trees": ["predator"], "species": ["compsognathus"],
		"min_stage": 1, "max_stage": 2, "rarity": "common", "passive": false,
		"flavor": "Rain hit the low vegetation last night and the warmth this morning brought everything out. The air above the wet scrub is thick with flying insects — a cloud of movement just above reach, drifting south.",
		"choices": [
			{ "label": "Work the swarm", "icon": "hunt",  "sublabel": "Snap continuously",      "action": "engage" },
			{ "label": "Let it pass",    "icon": "flee",  "sublabel": "Too scattered to bother", "action": "pass" },
		],
		"resolve_key": "compi_insect_bloom",
	},

	# Adult (stage 2+)

	"compi_lagoon_patrol": {
		"seasons": ["any"], "trees": ["predator"], "species": ["compsognathus"],
		"min_stage": 2, "rarity": "common", "passive": false,
		"flavor": "The tide pulled back further than usual this morning, leaving a wide band of mud, stranded pools, and exposed shell beds. Small shapes move in the shallows. Nothing large is nearby.",
		"choices": [
			{ "label": "Work the mudflat", "icon": "hunt",  "sublabel": "See what the tide left",  "action": "engage" },
			{ "label": "Stay back",        "icon": "flee",  "sublabel": "Too exposed out there",   "action": "pass" },
		],
		"resolve_key": "compi_lagoon_patrol",
	},
	"compi_stolen_mouthful": {
		"seasons": ["any"], "trees": ["predator"], "species": ["compsognathus"],
		"min_stage": 2, "rarity": "uncommon", "passive": false,
		"flavor": "A strip of meat still hangs from the exposed rib of a kill too large for you to have made. Something left this and has not returned yet. The meat is fresh. You can see the surrounding ground — nothing moving.",
		"choices": [
			{ "label": "Take it fast", "icon": "attack", "sublabel": "In and out before anything changes", "action": "engage" },
			{ "label": "Leave it",     "icon": "flee",   "sublabel": "Too risky",                         "action": "pass" },
		],
		"resolve_key": "compi_stolen_mouthful",
	},
	"compi_crevice_runner": {
		"seasons": ["any"], "trees": ["predator"], "species": ["compsognathus"],
		"min_stage": 2, "rarity": "common", "passive": false,
		"flavor": "A small animal vanished into a crack in the rock face — a narrow horizontal split that nothing larger than you could enter. You heard it go in. What's inside may not have another way out.",
		"choices": [
			{ "label": "Follow it in", "icon": "stalk", "sublabel": "You fit — it may not escape", "action": "engage" },
			{ "label": "Move on",      "icon": "flee",  "sublabel": "Too committed in a crack",    "action": "pass" },
		],
		"resolve_key": "compi_crevice_runner",
	},
	"compi_dust_tracker": {
		"seasons": ["summer", "fall"], "trees": ["predator"], "species": ["compsognathus"],
		"min_stage": 2, "rarity": "common", "passive": false,
		"flavor": "The dust has settled thick on the ground after days without rain. Every creature that crossed this area left a record — pressed footprints, tail drag lines, claw marks in the fine surface.",
		"choices": [
			{ "label": "Read the trails", "icon": "stalk", "sublabel": "Follow the best track",   "action": "engage" },
			{ "label": "Keep moving",     "icon": "flee",  "sublabel": "Dust slows you down too", "action": "pass" },
		],
		"resolve_key": "compi_dust_tracker",
	},
	"compi_bigger_hunter": {
		"seasons": ["any"], "trees": ["predator"], "species": ["compsognathus"],
		"min_stage": 2, "rarity": "uncommon", "passive": false,
		"flavor": "A juvenile predator from a larger species is crouched in the scrub twenty paces away, watching the same small animal you've been tracking. It is bigger than you. It doesn't know you're here.",
		"choices": [
			{ "label": "Hold position",  "icon": "stalk", "sublabel": "Wait for it to move first",   "action": "engage" },
			{ "label": "Back away",      "icon": "flee",  "sublabel": "Let the bigger one have it",  "action": "pass" },
		],
		"resolve_key": "compi_bigger_hunter",
	},

	# Wounded adult (stage 2+, injured)

	"compi_quiet_hollow": {
		"seasons": ["any"], "trees": ["predator"], "species": ["compsognathus"],
		"min_stage": 2, "require_injured": true, "rarity": "uncommon", "passive": false,
		"flavor": "The roots of a fallen tree have made a low chamber in the bank — dry, hidden on three sides, barely visible from outside. The entrance is narrow. Inside: darkness and quiet. Your wound is slowing you down.",
		"choices": [
			{ "label": "Go inside",   "icon": "stalk", "sublabel": "Rest in the hollow",      "action": "engage" },
			{ "label": "Keep moving", "icon": "flee",  "sublabel": "Something may be in it",  "action": "pass" },
		],
		"resolve_key": "compi_quiet_hollow",
	},
	"compi_blood_scent": {
		"seasons": ["any"], "trees": ["predator"], "species": ["compsognathus"],
		"min_stage": 2, "require_injured": true, "rarity": "common", "passive": false,
		"flavor": "The wound you're carrying has left a scent trail behind you — you can tell by the way the scrub has gone quiet in your wake. Something behind you may have already found it.",
		"choices": [
			{ "label": "Change direction", "icon": "flee",  "sublabel": "Break the trail at water", "action": "engage" },
			{ "label": "Hold still",       "icon": "stalk", "sublabel": "Maybe they pass by",       "action": "pass" },
		],
		"resolve_key": "compi_blood_scent",
	},
	"compi_limping_rain": {
		"seasons": ["fall", "winter"], "trees": ["predator"], "species": ["compsognathus"],
		"min_stage": 2, "require_injured": true, "rarity": "common", "passive": false,
		"flavor": "Rain has come and it's heavy. The ground is soaking, turning to soft mud under your feet. Every step costs something. The rain is washing everything, including the scent trail you've been leaving.",
		"choices": [
			{ "label": "Use the rain", "icon": "stalk", "sublabel": "Move while the trail is masked", "action": "engage" },
			{ "label": "Find shelter", "icon": "flee",  "sublabel": "Wait it out in cover",           "action": "pass" },
		],
		"resolve_key": "compi_limping_rain",
	},
	"compi_old_bite": {
		"seasons": ["any"], "trees": ["predator"], "species": ["compsognathus"],
		"min_stage": 2, "require_injured": true, "rarity": "uncommon", "passive": false,
		"flavor": "The wound is closing, its edges firm and itchy. Healing brings relief, though the stiff skin still changes the way you move.",
		"choices": [
			{ "label": "Rest today",    "icon": "stalk", "sublabel": "Let the healing finish",  "action": "engage" },
			{ "label": "Push through", "icon": "flee",   "sublabel": "Keep your range active",  "action": "pass" },
		],
		"resolve_key": "compi_old_bite",
	},

	# Pack / Group (require_pack)

	"compi_loose_foragers": {
		"seasons": ["any"], "trees": ["predator"], "species": ["compsognathus"],
		"require_pack": true, "rarity": "common", "passive": false,
		"flavor": "Three other Compsognathus are working the scrub ahead — not coordinated, just overlapping in the same direction. They flush insects and small lizards as they go. The movement is spreading toward you.",
		"choices": [
			{ "label": "Join the group", "icon": "hunt", "sublabel": "Work the same strip",   "action": "engage" },
			{ "label": "Hunt alone",     "icon": "flee", "sublabel": "Your own pace, your own food", "action": "pass" },
		],
		"resolve_key": "compi_loose_foragers",
	},
	"compi_many_eyes": {
		"seasons": ["any"], "trees": ["predator"], "species": ["compsognathus"],
		"require_pack": true, "rarity": "common", "passive": false,
		"flavor": "One of the others in your loose group has stopped moving and gone very still. Then it makes a short, sharp call — not a hunting sound. Something in the direction it's facing is wrong.",
		"choices": [
			{ "label": "React to the call",  "icon": "flee",  "sublabel": "Trust the warning",       "action": "engage" },
			{ "label": "Check it yourself", "icon": "stalk",  "sublabel": "Maybe it overreacted",    "action": "pass" },
		],
		"resolve_key": "compi_many_eyes",
	},
	"compi_scramble_feast": {
		"seasons": ["any"], "trees": ["predator"], "species": ["compsognathus"],
		"require_pack": true, "rarity": "uncommon", "passive": false,
		"flavor": "Something small and dead has been found — not enough for one of you but enough for the scramble already forming. They're converging from three directions.",
		"choices": [
			{ "label": "Get in fast",  "icon": "attack", "sublabel": "Grab what you can",   "action": "engage" },
			{ "label": "Let it pass", "icon": "flee",    "sublabel": "Not worth the fight",  "action": "pass" },
		],
		"resolve_key": "compi_scramble_feast",
	},
	"compi_bold_one": {
		"seasons": ["any"], "trees": ["predator"], "species": ["compsognathus"],
		"require_pack": true, "rarity": "uncommon", "passive": false,
		"flavor": "An older Compsognathus leaves the group with a purposeful stride. You have seen it take this route before and return with food.",
		"choices": [
			{ "label": "Follow it",    "icon": "stalk", "sublabel": "It seems to know something", "action": "engage" },
			{ "label": "Stay behind", "icon": "flee",   "sublabel": "Could be leading anywhere",  "action": "pass" },
		],
		"resolve_key": "compi_bold_one",
	},
	"compi_pack_split": {
		"seasons": ["any"], "trees": ["predator"], "species": ["compsognathus"],
		"require_pack": true, "rarity": "common", "passive": false,
		"flavor": "Something startled the group — sound, shadow, smell — and they scattered in four directions before you registered what happened. The scrub is still. You are alone. The direction they went is not obvious.",
		"choices": [
			{ "label": "Find your own route", "icon": "stalk", "sublabel": "Hunt solo for now",    "action": "engage" },
			{ "label": "Wait here",           "icon": "flee",  "sublabel": "Let them regroup",     "action": "pass" },
		],
		"resolve_key": "compi_pack_split",
	},

	# Seasonal

	"compi_spring_hatchlings": {
		"seasons": ["spring"], "trees": ["predator"], "species": ["compsognathus"],
		"rarity": "common", "passive": false,
		"flavor": "Spring has brought everything out at once. Small nests are tucked into every thicket — broken open, still damp, occupied by things too young to be fast. The scrub is full of opportunity and guarded parents.",
		"choices": [
			{ "label": "Work the nests",  "icon": "stalk", "sublabel": "Find one unguarded",   "action": "engage" },
			{ "label": "Leave it alone", "icon": "flee",   "sublabel": "Too many angry parents", "action": "pass" },
		],
		"resolve_key": "compi_spring_hatchlings",
	},
	"compi_baked_stones": {
		"seasons": ["summer"], "trees": ["predator"], "species": ["compsognathus"],
		"rarity": "common", "passive": false,
		"flavor": "The rocks are holding heat from yesterday. Nothing large is moving — the day has driven everything into shade. The ground radiates warmth. In the heat-stunned quiet, small things have stopped being careful.",
		"choices": [
			{ "label": "Hunt the heat",  "icon": "hunt", "sublabel": "Find what's too slow to move", "action": "engage" },
			{ "label": "Rest in shade", "icon": "flee",  "sublabel": "Save energy for evening",      "action": "pass" },
		],
		"resolve_key": "compi_baked_stones",
	},
	"compi_rot_patch": {
		"seasons": ["fall"], "trees": ["predator"], "species": ["compsognathus"],
		"rarity": "common", "passive": false,
		"flavor": "A thick patch of rotting vegetation at the waterline is generating heat and drawing insects. The smell is bad. The food opportunity is real. The vegetation is soft and unstable underfoot.",
		"choices": [
			{ "label": "Work the patch",  "icon": "hunt", "sublabel": "Eat what it's drawn in", "action": "engage" },
			{ "label": "Pass it by",      "icon": "flee", "sublabel": "Smells wrong",            "action": "pass" },
		],
		"resolve_key": "compi_rot_patch",
	},
	"compi_winter_shore": {
		"seasons": ["winter"], "trees": ["predator"], "species": ["compsognathus"],
		"rarity": "uncommon", "passive": false,
		"flavor": "The lagoon shore is quiet in the cold. Most large animals have retreated inland. The tidal edge is yours — exposed, clear of cover, but no competition. The cold bites but nothing else has come out yet.",
		"choices": [
			{ "label": "Work the shoreline", "icon": "hunt", "sublabel": "Yours for now",          "action": "engage" },
			{ "label": "Stay inland",        "icon": "flee", "sublabel": "Too exposed in the cold", "action": "pass" },
		],
		"resolve_key": "compi_winter_shore",
	},

	# Rare

	"compi_giant_dragonfly": {
		"seasons": ["spring", "summer"], "trees": ["predator"], "species": ["compsognathus"],
		"rarity": "rare", "passive": false,
		"flavor": "A dragonfly the length of your foreleg has landed on a stem at the waterline — wings flat, completely still, apparently unaware of the world. You've never seen one sit still this long.",
		"choices": [
			{ "label": "Strike now",   "icon": "attack", "sublabel": "Before it registers you", "action": "engage" },
			{ "label": "Watch it go", "icon": "flee",    "sublabel": "Something that big fights back", "action": "pass" },
		],
		"resolve_key": "compi_giant_dragonfly",
	},
	"compi_falling_feather": {
		"seasons": ["any"], "trees": ["predator"], "species": ["compsognathus"],
		"rarity": "rare", "passive": false,
		"flavor": "A large feather drifts down through the canopy gap — longer than your body, pale along the shaft with a dark tip. It came from something flying high. It settles in the brush ahead of you.",
		"choices": [
			{ "label": "Follow it",   "icon": "stalk", "sublabel": "See where it leads",        "action": "engage" },
			{ "label": "Leave it",   "icon": "flee",   "sublabel": "Could lead anywhere",       "action": "pass" },
		],
		"resolve_key": "compi_falling_feather",
	},
	"compi_salt_shore": {
		"seasons": ["any"], "trees": ["predator"], "species": ["compsognathus"],
		"rarity": "rare", "passive": false,
		"flavor": "A section of the lagoon edge has dried down to crystallized salt — white crust on the mud, shallow pools still holding warm mineral water. Tiny animals are trapped where the crust sealed over them.",
		"choices": [
			{ "label": "Cross the crust", "icon": "stalk", "sublabel": "Work the sealed pools", "action": "engage" },
			{ "label": "Stay back",       "icon": "flee",  "sublabel": "Too noisy to hunt on",  "action": "pass" },
		],
		"resolve_key": "compi_salt_shore",
	},
	"compi_wrong_chirp": {
		"seasons": ["any"], "trees": ["predator"], "species": ["compsognathus"],
		"rarity": "rare", "passive": false,
		"flavor": "A Compsognathus call comes from the low scrub to your left — close, clear, the right frequency. But the rhythm is wrong. Either the animal is distressed, confused, or something else is using the sound.",
		"choices": [
			{ "label": "Investigate",    "icon": "stalk", "sublabel": "Find out what made it",   "action": "engage" },
			{ "label": "Move away",      "icon": "flee",  "sublabel": "Something's wrong there", "action": "pass" },
		],
		"resolve_key": "compi_wrong_chirp",
	},

}
