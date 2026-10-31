# Triceratops encounter data — loaded by ActionResolver and EventsDB

const OUTCOME_EVENTS: Dictionary = {

	# ── JUVENILE ──────────────────────────────────────────────────────────────

	"trike_between_giants": {
		"pass_flavor": "You fall into the center of the herd and let the legs move around you.",
		"buff":    { "stat": "defense", "amount": 0.11, "turns": 4, "source": "protected_calf", "flavor": "Protected Calf: inside this herd, nothing reaches you. The adults make sure of that." },
		"nothing": { "flavor": "The herd keeps moving. You keep pace and reach the other side intact." },
		"food":    { "hunger": 0.14, "flavor": "The adults lead toward tender plants and the young follow." },
		"health":  { "health": 0.10, "flavor": "Sheltered among the adults, you rest without keeping watch. Your strength begins to return." },
		"debuff":  { "stat": "defense", "amount": -0.09, "turns": 2, "source": "panic_separation", "flavor": "You slow without noticing until the herd moves ahead. The closing ranks leave you behind." },
	},

	"trike_first_horn_bumps": {
		"pass_flavor": "You leave the bush alone. The horns are not ready for that yet.",
		"buff":    { "stat": "defense", "amount": 0.10, "turns": 3, "source": "horn_practice", "flavor": "Horn Practice: your body starts learning the weight behind this motion." },
		"nothing": { "flavor": "You press against the bush, but it barely bends. Your young horns are not strong enough yet." },
		"food":    { "hunger": 0.12, "flavor": "The shove knocks loose some edible leaves you would not have found otherwise." },
		"health":  { "health": 0.09, "flavor": "Practicing the motion warms your neck and leaves your body looser." },
		"debuff":  { "health": -0.07, "flavor": "The horn bud hits at the wrong angle. Your nose takes most of it." },
	},

	"trike_soft_fern": {
		"pass_flavor": "The older herbivores already ate the best of it. You move on.",
		"buff":    { "stat": "type_stat", "amount": 0.10, "turns": 3, "source": "tender_grazer", "flavor": "Tender Grazer: you learn which soft plants sustain you longer than the tough growth." },
		"nothing": { "flavor": "The older herbivores already stripped the fern. You find the edges and nothing more." },
		"food":    { "hunger": 0.16, "flavor": "Low, soft greens with no resistance. You fill up without effort." },
		"health":  { "health": 0.09, "flavor": "Young growth is dense with what your body needs right now." },
		"debuff":  { "stat": "type_stat", "amount": -0.07, "turns": 2, "source": "sour_greens", "flavor": "The greens taste harmless at first. Before long, your stomach begins to hurt." },
	},

	"trike_warning_snort": {
		"pass_flavor": "You hold still and wait. The signal does not repeat.",
		"buff":    { "stat": "defense", "amount": 0.11, "turns": 3, "source": "herd_alarm", "flavor": "Herd Alarm: you read the snort before the adult finishes making it. You are already moving." },
		"nothing": { "flavor": "False alarm. The herd relaxes and nothing comes of it." },
		"food":    { "hunger": 0.14, "flavor": "The herd shifts toward safer grazing and the plants there are untouched." },
		"health":  { "health": 0.09, "flavor": "You reach cover before the danger resolves. Your body stays intact." },
		"debuff":  { "stat": "speed", "amount": -0.09, "turns": 2, "source": "panic_separation", "flavor": "You panic in the wrong direction. By the time you stop, the herd is somewhere else." },
	},

	"trike_frill_sun": {
		"pass_flavor": "The clouds hold. You find shade instead.",
		"buff":    { "stat": "type_stat", "amount": 0.11, "turns": 3, "source": "warm_blood", "flavor": "Warm Blood: the sun works into you in a way that lasts past the morning." },
		"nothing": { "flavor": "Clouds cover the sun before anything settles into your body." },
		"food":    { "hunger": 0.12, "flavor": "Sunlit ground stays warm enough that fresh shoots push through early." },
		"health":  { "health": 0.10, "flavor": "The warmth improves everything. Rest comes easier when your body is not fighting the cold." },
		"debuff":  { "stat": "defense", "amount": -0.08, "turns": 2, "source": "panic_separation", "flavor": "You stay in the open too long. Something notices before you do." },
	},

	# ── SUBADULT ──────────────────────────────────────────────────────────────

	"trike_young_bull": {
		"pass_flavor": "You hold your ground and let the tension drain out without committing.",
		"buff":    { "stat": "strength", "amount": 0.11, "turns": 3, "source": "head_lock_practice", "flavor": "Head-Lock Practice: you know how to brace and angle now. The next encounter starts from a better position." },
		"nothing": { "flavor": "You both bluff and walk away. Nobody wins and nobody loses." },
		"food":    { "hunger": 0.15, "flavor": "You win the ground. The feeding patch it was guarding is yours." },
		"health":  { "health": 0.10, "flavor": "You win the posture contest without contact. Your body stays intact." },
		"debuff":  { "stat": "strength", "amount": -0.09, "turns": 2, "source": "neck_strain", "flavor": "The lock goes sideways. Your neck takes the wrong load." },
	},

	"trike_testing_charge": {
		"pass_flavor": "You hold back. The stump is not worth the energy.",
		"buff":    { "stat": "strength", "amount": 0.12, "turns": 3, "source": "charge_control", "flavor": "Charge Control: you know how to start it and, more importantly, how to stop it." },
		"nothing": { "flavor": "You decide against it. The stump stands and you move around it." },
		"food":    { "hunger": 0.14, "flavor": "The impact splits the stump and exposes what was inside. Worth the collision." },
		"health":  { "health": 0.10, "flavor": "The exercise warms your muscles and your body responds well." },
		"debuff":  { "stat": "defense", "amount": -0.09, "turns": 2, "source": "chipped_horn", "flavor": "The angle is wrong. Something chips and the horn stings for a long time after." },
	},

	"trike_pred_edge": {
		"pass_flavor": "You keep pace with the herd and do not give it a reason to test.",
		"buff":    { "stat": "defense", "amount": 0.11, "turns": 3, "source": "predator_watch", "flavor": "Predator Watch: you know how far it is staying behind and what it means when that distance changes." },
		"nothing": { "flavor": "It follows for a while and then gives up. The herd is too much trouble." },
		"food":    { "hunger": 0.14, "flavor": "Its movement pushes the herd toward new ground and the plants there are untouched." },
		"health":  { "health": 0.09, "flavor": "Staying calm costs nothing. You arrive at the next grazing patch in better shape than if you had run." },
		"debuff":  { "stat": "defense", "amount": -0.09, "turns": 2, "source": "panic_separation", "flavor": "A nip at the edge causes enough panic to break the formation temporarily." },
	},

	"trike_mud_wallow": {
		"pass_flavor": "The mud is too dry to be useful. You move on.",
		"buff":    { "stat": "defense", "amount": 0.10, "turns": 4, "source": "mud_shield", "flavor": "Mud Shield: the coating covers the skin and keeps the biting insects and the blood-scent trackers from reading you clearly." },
		"nothing": { "flavor": "The mud has dried out. It cracks underfoot and gives nothing." },
		"food":    { "hunger": 0.14, "flavor": "The wet ground beneath the wallow still holds roots." },
		"health":  { "health": 0.11, "flavor": "The cooling mud works into every sore place. Your body rests more deeply for it." },
		"debuff":  { "stat": "speed", "amount": -0.10, "turns": 2, "source": "mud_slow", "flavor": "The mud is thicker than it looked. Every step costs more than it should." },
	},

	"trike_frill_display": {
		"pass_flavor": "No one reacts. You lower your head and continue grazing.",
		"buff":    { "stat": "strength", "amount": 0.11, "turns": 3, "source": "frill_display", "flavor": "Frill Display: you know how to make your size read as larger than it is." },
		"nothing": { "flavor": "No one notices or nobody cares. The moment passes." },
		"food":    { "hunger": 0.14, "flavor": "A smaller herbivore backs off from a food patch when you face it." },
		"health":  { "health": 0.09, "flavor": "Avoiding the clash costs nothing. You graze in peace." },
		"debuff":  { "stat": "strength", "amount": -0.09, "turns": 2, "source": "neck_strain", "flavor": "A rival reads the display as an invitation. The response is more than you wanted." },
	},

	# ── ADULT ─────────────────────────────────────────────────────────────────

	"trike_horns_down": {
		"pass_flavor": "You hold position and let the herd formation do the work.",
		"buff":    { "stat": "defense", "amount": 0.13, "turns": 4, "source": "horns_down", "flavor": "Horns Down: the posture says everything that needs to be said." },
		"nothing": { "flavor": "The threat keeps its distance and eventually moves on." },
		"food":    { "hunger": 0.16, "flavor": "Once it leaves, the herd moves to a clean grazing patch." },
		"health":  { "health": 0.11, "flavor": "Holding formation costs less than a fight. You preserve everything." },
		"debuff":  { "stat": "type_stat", "amount": -0.09, "turns": 2, "source": "sour_greens", "flavor": "The tension holds too long. By the time it breaks, you have burned what you could not afford." },
	},

	"trike_trex_standoff": {
		"pass_flavor": "You lower your head. Your horns point forward. You do not move first.",
		"w_debuff": 0.20,
		"w_nothing": 0.25,
		"w_buff": 0.10,
		"buff":    { "stat": "defense", "amount": 0.14, "turns": 5, "source": "rex_breakers_nerve", "flavor": "Rex Breaker's Nerve: you held when everything in you said to run. That does not leave you." },
		"nothing": { "flavor": "It reads the horns, reads the herd behind you, and backs into the brush." },
		"food":    { "hunger": 0.18, "flavor": "The herd moves to safer grazing once the tension breaks." },
		"health":  { "health": 0.12, "flavor": "You survive the standoff intact. Your body does not know how lucky that is." },
		"debuff":  { "health": -0.20, "flavor": "It lunges before the standoff resolves. Something hits before the horn finds the right angle." },
	},

	"trike_defensive_circle": {
		"pass_flavor": "You hold the outer ring and do not commit to the center.",
		"w_buff": 0.14,
		"w_debuff": 0.16,
		"buff":    { "stat": "defense", "amount": 0.15, "turns": 5, "source": "herd_wall", "flavor": "Herd Wall: a ring of horns pointing outward is one of the most effective things alive has ever made." },
		"nothing": { "flavor": "The predators refuse to test it. The circle holds and nothing comes of it." },
		"food":    { "hunger": 0.17, "flavor": "After the danger passes, the herd moves safely to fresh plants." },
		"health":  { "health": 0.13, "flavor": "The formation holds and nothing reaches the center. Real safety, real rest." },
		"debuff":  { "health": -0.13, "flavor": "Panic breaks the circle from inside. In the chaos something lands before the horns can answer." },
	},

	"trike_root_breaker": {
		"pass_flavor": "The ground is too hard. You leave the roots where they are.",
		"buff":    { "stat": "type_stat", "amount": 0.12, "turns": 4, "source": "root_breaker", "flavor": "Root Breaker: you know how to read the ground for what is underneath it." },
		"nothing": { "flavor": "The ground does not give. You move on without eating." },
		"food":    { "hunger": 0.20, "flavor": "The horn and beak work through the soil together. The roots come up dense and rich." },
		"health":  { "health": 0.12, "flavor": "Root matter restores slowly but provides real nutrition." },
		"debuff":  { "stat": "defense", "amount": -0.09, "turns": 2, "source": "chipped_horn", "flavor": "The horn catches a buried rock wrong. The beak takes some of the shock too." },
	},

	"trike_rival_scarface": {
		"pass_flavor": "You read the size and the scars and find somewhere else to graze.",
		"buff":    { "stat": "strength", "amount": 0.12, "turns": 3, "source": "scar_display", "flavor": "Scar Display: your history is written in your body. The rival reads it and recalculates." },
		"nothing": { "flavor": "You avoid the contest and graze elsewhere. Your body stays intact." },
		"food":    { "hunger": 0.18, "flavor": "You hold the patch. The rival moves off and the food is yours." },
		"health":  { "health": 0.11, "flavor": "Winning by display costs almost nothing. Your body makes use of what it saved." },
		"debuff":  { "health": -0.13, "flavor": "The horns clash before the display resolves. Old scars do not prevent new ones." },
	},

	"trike_sudden_charge": {
		"pass_flavor": "You hold the impulse. The predator backs off before you have to use it.",
		"buff":    { "stat": "strength", "amount": 0.13, "turns": 3, "source": "explosive_charge", "flavor": "Explosive Charge: when it happens, it happens without a decision in between." },
		"nothing": { "flavor": "The predator flees before contact. You stop yourself mid-stride." },
		"food":    { "hunger": 0.17, "flavor": "The charge clears the feeding ground completely." },
		"health":  { "health": 0.12, "flavor": "The predator leaves and the herd settles. Your confidence improves everything else." },
		"debuff":  { "stat": "type_stat", "amount": -0.10, "turns": 2, "source": "sour_greens", "flavor": "You commit and the target is gone before you reach it. The recovery leaves you worse than the start." },
	},

	"trike_frill_wound": {
		"pass_flavor": "You hold still and let the wound settle on its own.",
		"buff":    { "stat": "strength", "amount": 0.11, "turns": 4, "source": "scarred_frill", "flavor": "Scarred Frill: old scars show that you have survived a fight. Your warning carries more weight now." },
		"nothing": { "flavor": "The wound is stable. It aches but does not worsen." },
		"food":    { "hunger": 0.15, "flavor": "You stay near easy plants while the wound settles." },
		"health":  { "health": 0.11, "flavor": "Rest closes the wound faster than movement would." },
		"debuff":  { "stat": "defense", "amount": -0.10, "turns": 3, "source": "blood_scent", "flavor": "The wound carries scent into open air. Something downwind has already found it." },
	},

	# ── WOUNDED ADULT ─────────────────────────────────────────────────────────

	"trike_cracked_horn": {
		"pass_flavor": "You favor the horn. Do not ask it to absorb what it cannot.",
		"buff":    { "stat": "defense", "amount": 0.10, "turns": 3, "source": "careful_aim", "flavor": "Careful Aim: you know how to angle the good horn without leading with the damaged one." },
		"nothing": { "flavor": "The crack holds. You move carefully and it does not worsen." },
		"food":    { "hunger": 0.15, "flavor": "You avoid the clash and find plants instead. Easy feeding with no load on the horn." },
		"health":  { "health": 0.11, "flavor": "Resting the damaged horn reduces the ache enough to matter." },
		"debuff":  { "stat": "defense", "amount": -0.11, "turns": 3, "source": "damaged_horn", "flavor": "The cracked horn takes load it cannot handle. Your defensive options narrow." },
	},

	"trike_limp_dangerous": {
		"pass_flavor": "You keep pace. The horns still point forward regardless of the leg.",
		"buff":    { "stat": "defense", "amount": 0.12, "turns": 3, "source": "stand_ground", "flavor": "Stand Ground: a wounded Triceratops that does not run is still three horns pointing at something." },
		"nothing": { "flavor": "You move slowly and safely. The herd accommodates your pace." },
		"food":    { "hunger": 0.16, "flavor": "The herd slows near a patch and you eat while you can." },
		"health":  { "health": 0.12, "flavor": "The herd's protection gives you time the leg needs." },
		"debuff":  { "stat": "defense", "amount": -0.10, "turns": 2, "source": "lagging_behind", "flavor": "The limp falls behind the herd faster than you expected. The protection is no longer around you." },
	},

	"trike_blood_frill": {
		"pass_flavor": "You hold still and wait. The blood dries and the scent fades.",
		"buff":    { "stat": "strength", "amount": 0.12, "turns": 3, "source": "bloody_display", "flavor": "Bloody Display: a wound on a Triceratops that did not run reads as more dangerous, not less." },
		"nothing": { "flavor": "No challenger approaches. The blood on the frill does its own work." },
		"food":    { "hunger": 0.15, "flavor": "Rivals avoid your feeding spot entirely." },
		"health":  { "health": 0.11, "flavor": "You clean the wound in mud or water. The blood scent reduces." },
		"debuff":  { "stat": "defense", "amount": -0.10, "turns": 2, "source": "blood_scent", "flavor": "The wound's smell carries. Something patient has been following it." },
	},

	"trike_herd_space": {
		"pass_flavor": "You rest where the herd gives you room. Your body uses the quiet.",
		"buff":    { "stat": "defense", "amount": 0.12, "turns": 4, "source": "guarded_recovery", "flavor": "Guarded Recovery: the herd circles loosely. Nothing comes close while you are down." },
		"nothing": { "flavor": "You rest but heal slowly. The herd keeps watch." },
		"food":    { "hunger": 0.15, "flavor": "Herd movement is calmer now. Plants appear at the edges of the rest site." },
		"health":  { "health": 0.15, "flavor": "Real safety and real rest. Your body makes significant progress." },
		"debuff":  { "stat": "type_stat", "amount": -0.08, "turns": 2, "source": "sour_greens", "flavor": "Too long in one place. The ground around you becomes a problem." },
	},

	"trike_last_warning_charge": {
		"pass_flavor": "You hold still. The predator reads the horns and decides against it.",
		"w_buff": 0.13,
		"w_debuff": 0.17,
		"buff":    { "stat": "strength", "amount": 0.15, "turns": 3, "source": "wounded_fury", "flavor": "Wounded Fury: a hurt animal that charges anyway is a different kind of threat entirely." },
		"nothing": { "flavor": "The predator reads the posture and the horns and decides against it." },
		"food":    { "hunger": 0.16, "flavor": "The charge drives it entirely out of your grazing area." },
		"health":  { "health": 0.11, "flavor": "You avoid combat and the wound does not worsen. Your body gets the time it needed." },
		"debuff":  { "health": -0.15, "flavor": "The charge puts load on the wound that it was not ready for. You finish the encounter worse than you started it." },
	},

	# ── HERD / GROUP ──────────────────────────────────────────────────────────

	"trike_horn_line": {
		"pass_flavor": "You hold position inside the formation and let the front rank work.",
		"buff":    { "stat": "defense", "amount": 0.14, "turns": 5, "source": "horn_line", "flavor": "Horn Line: a wall of horns all pointing the same direction is a statement that reads clearly from any distance." },
		"nothing": { "flavor": "The threat reads the line and leaves. The formation holds without being tested." },
		"food":    { "hunger": 0.16, "flavor": "The herd moves safely to food once the line disperses." },
		"health":  { "health": 0.12, "flavor": "Group confidence after a successful display settles everyone. Rest improves." },
		"debuff":  { "health": -0.12, "flavor": "Panic inside the formation causes a collision before anyone on the outside does anything." },
	},

	"trike_calf_trouble": {
		"pass_flavor": "The calf finds its way back before anything commits.",
		"buff":    { "stat": "defense", "amount": 0.12, "turns": 4, "source": "protector_instinct", "flavor": "Protector Instinct: you know how to place your body between the young and the threat." },
		"nothing": { "flavor": "The calf navigates back without incident. No one had to commit." },
		"food":    { "hunger": 0.15, "flavor": "The rescue moves the herd toward a safer area and the plants there are good." },
		"health":  { "health": 0.11, "flavor": "Protecting the calf tightens the herd. That safety extends to you." },
		"debuff":  { "health": -0.12, "flavor": "Saving the calf puts you between it and whatever separated it in the first place." },
	},

	"trike_dominance_rut": {
		"pass_flavor": "Displays settle the tension. You hold rank without a clash.",
		"buff":    { "stat": "strength", "amount": 0.13, "turns": 4, "source": "rut_strength", "flavor": "Rut Strength: you found the right angle and held it. The rank you earn in these moments compounds." },
		"nothing": { "flavor": "Displays settle the conflict before it becomes physical. Both parties move on." },
		"food":    { "hunger": 0.18, "flavor": "You win access to a prime plant area." },
		"health":  { "health": 0.11, "flavor": "You hold rank without injury. The energy you saved becomes recovery." },
		"debuff":  { "health": -0.14, "flavor": "The clash is real. Horn against horn, neck against neck. You carry the result." },
	},

	"trike_old_matriarch": {
		"pass_flavor": "The route is slow. You move at the elder's pace and arrive safe.",
		"buff":    { "stat": "speed", "amount": 0.11, "turns": 4, "source": "ancient_route", "flavor": "Ancient Route: the matriarch has walked this land longer than the predators that hunt it. The path is right." },
		"nothing": { "flavor": "The route is slow but nothing happens along it." },
		"food":    { "hunger": 0.17, "flavor": "The path leads to reliable plants that the elder has found before." },
		"health":  { "health": 0.12, "flavor": "The route includes a sheltered rest site. You use it and your body recovers." },
		"debuff":  { "stat": "defense", "amount": -0.09, "turns": 2, "source": "lagging_behind", "flavor": "The route is known to more than just the herd. Something is waiting along it." },
	},

	"trike_alarm_stampede": {
		"pass_flavor": "You hold your ground and do not add to the panic.",
		"w_debuff": 0.18,
		"w_nothing": 0.25,
		"buff":    { "stat": "defense", "amount": 0.12, "turns": 3, "source": "calm_bulk", "flavor": "Calm Bulk: your size means panic moves through you instead of moving you." },
		"nothing": { "flavor": "The herd settles faster than expected. The scare was brief." },
		"food":    { "hunger": 0.15, "flavor": "The movement reveals new grazing ground that the stampede exposed." },
		"health":  { "health": 0.10, "flavor": "You avoid injury in the chaos and your body recovers afterward." },
		"debuff":  { "health": -0.14, "flavor": "The collision happens before you hear it coming. Your own kind is the thing that hits you." },
	},

	# ── SEASONAL ──────────────────────────────────────────────────────────────

	"trike_spring_calving": {
		"pass_flavor": "The season is quiet. The calves are safe without extra effort.",
		"buff":    { "stat": "defense", "amount": 0.13, "turns": 4, "source": "calf_guardian", "flavor": "Calf Guardian: you know where to be and how to use your body when the young need protection." },
		"nothing": { "flavor": "The calving grounds stay peaceful. No threat appears." },
		"food":    { "hunger": 0.18, "flavor": "Spring plants are abundant in the calving territory." },
		"health":  { "health": 0.12, "flavor": "Safe herd grounds in spring are some of the best rest available." },
		"debuff":  { "health": -0.11, "flavor": "Predators patrol the edges of calving herds because that is where the vulnerable are." },
	},

	"trike_spring_frill_display": {
		"pass_flavor": "No rival challenges. You lower the display and continue grazing.",
		"buff":    { "stat": "strength", "amount": 0.12, "turns": 4, "source": "display_power", "flavor": "Display Power: the frill works before the horns have to." },
		"nothing": { "flavor": "No rival challenges the display. The season stays calm." },
		"food":    { "hunger": 0.16, "flavor": "Winning the display grants access to a prime feeding patch." },
		"health":  { "health": 0.11, "flavor": "Social success without injury leaves your body in better shape than a fight would." },
		"debuff":  { "health": -0.12, "flavor": "A rival reads the display as a challenge and escalates before you intended." },
	},

	"trike_summer_dry": {
		"pass_flavor": "You conserve energy. Dry plants are not worth forcing.",
		"buff":    { "stat": "type_stat", "amount": 0.11, "turns": 3, "source": "tough_grazer", "flavor": "Tough Grazer: your beak and teeth handle the dry material better than most. You extract more." },
		"nothing": { "flavor": "You eat slowly and gain little. The plants are past their point of real nutrition." },
		"food":    { "hunger": 0.16, "flavor": "Hardy shrubs and roots remain when the softer plants have gone." },
		"health":  { "health": 0.10, "flavor": "Shade feeding without exertion. Your body holds steady." },
		"debuff":  { "stat": "type_stat", "amount": -0.09, "turns": 2, "source": "sour_greens", "flavor": "Poor food compounds in the heat. Stamina recovery slows." },
	},

	"trike_summer_waterhole": {
		"pass_flavor": "You drink carefully and leave before the tension builds.",
		"buff":    { "stat": "defense", "amount": 0.12, "turns": 3, "source": "waterhole_guard", "flavor": "Waterhole Guard: you know what the bank looks like when something is waiting to use the crowding against the herd." },
		"nothing": { "flavor": "The herd drinks and leaves without incident." },
		"food":    { "hunger": 0.16, "flavor": "Moist bank plants still hold water in them." },
		"health":  { "health": 0.13, "flavor": "Water and shade together. Your body uses both." },
		"debuff":  { "health": -0.14, "flavor": "The ambush comes from the grass or the rival herd pushes in and the tension breaks wrong." },
	},

	"trike_fall_horn_clash": {
		"pass_flavor": "Displays settle the tension before it needs to go further.",
		"buff":    { "stat": "strength", "amount": 0.13, "turns": 4, "source": "clash_veteran", "flavor": "Clash Veteran: you know which angle gives and which holds. The horn contests go your way now." },
		"nothing": { "flavor": "Displays settle the aggression without contact." },
		"food":    { "hunger": 0.17, "flavor": "You claim the feeding route without having to defend it with your body." },
		"health":  { "health": 0.11, "flavor": "You hold rank and avoid injury. The season does not take anything from you." },
		"debuff":  { "health": -0.13, "flavor": "Fall aggression is real and the clash leaves its mark." },
	},

	"trike_fall_heavy_feed": {
		"pass_flavor": "Too much competition at the best patches. You take what you can.",
		"buff":    { "stat": "type_stat", "amount": 0.12, "turns": 4, "source": "fat_reserve", "flavor": "Fat Reserve: the extra feeding carries forward. The lean season starts from a better position." },
		"nothing": { "flavor": "Competition is too high. You eat well but not as well as the season offers." },
		"food":    { "hunger": 0.22, "flavor": "You eat a full heavy meal. Your body stores what the lean months will take." },
		"health":  { "health": 0.14, "flavor": "Strong feeding before scarcity is real preparation. Your body shows it." },
		"debuff":  { "stat": "speed", "amount": -0.09, "turns": 2, "source": "mud_slow", "flavor": "Overeating in the fall leaves your body less ready to move quickly." },
	},

	"trike_winter_roots": {
		"pass_flavor": "The ground is too hard. You leave the roots where they are.",
		"buff":    { "stat": "type_stat", "amount": 0.12, "turns": 4, "source": "hard_root_breaker", "flavor": "Hard Root Breaker: you know which ground gives when you push the horn into it and which does not." },
		"nothing": { "flavor": "The ground does not give. You move on with nothing to show for the attempt." },
		"food":    { "hunger": 0.17, "flavor": "Root or bark matter uncovered from the frozen or dry ground. Dense and slow but real." },
		"health":  { "health": 0.10, "flavor": "Slow steady feeding keeps your body from sliding further." },
		"debuff":  { "stat": "strength", "amount": -0.10, "turns": 2, "source": "neck_strain", "flavor": "Poor diet in the lean season takes your strength first. Defense suffers for it." },
	},

	"trike_winter_tight_herd": {
		"pass_flavor": "You stay at the edge. The warmth is real but the crowding is its own risk.",
		"buff":    { "stat": "defense", "amount": 0.13, "turns": 4, "source": "herd_warmth", "flavor": "Herd Warmth: in the cold, this many bodies sharing heat is a survival advantage nothing else provides." },
		"nothing": { "flavor": "The night passes cold but intact." },
		"food":    { "hunger": 0.15, "flavor": "Morning movement reveals plants uncovered by the herd's rest." },
		"health":  { "health": 0.14, "flavor": "Group rest in the cold recovers more than resting alone ever would." },
		"debuff":  { "stat": "type_stat", "amount": -0.09, "turns": 2, "source": "sour_greens", "flavor": "Something spreads in the close quarters. The crowding that saved you from the cold brings its own problem." },
	},

	# ── RARE ──────────────────────────────────────────────────────────────────

	"trike_rex_scar": {
		"pass_flavor": "It keeps its distance. You keep yours. The recognition is mutual.",
		"w_buff": 0.14,
		"w_nothing": 0.28,
		"buff":    { "stat": "defense", "amount": 0.14, "turns": 5, "source": "predator_memory", "flavor": "Predator Memory: you recognize this hunter, and it remembers the price of attacking you. Neither of you approaches carelessly." },
		"nothing": { "flavor": "It keeps its distance. You watch each other and nothing is decided." },
		"food":    { "hunger": 0.18, "flavor": "It avoids the herd's feeding path entirely." },
		"health":  { "health": 0.13, "flavor": "The tension leaves without costing you anything. Your body recovers in the quiet after." },
		"debuff":  { "health": -0.16, "flavor": "It has learned from the last encounter too. It attacks more carefully and from a better angle." },
	},

	"trike_perfect_charge": {
		"pass_flavor": "The moment passes. The opportunity was there and then it was not.",
		"w_buff": 0.14,
		"w_health": 0.20,
		"buff":    { "stat": "strength", "amount": 0.16, "turns": 0, "source": "perfect_charge", "perm": true, "perm_label": "Perfect Charge", "flavor": "Perfect Charge: your body remembers what that moment felt like. Head low, legs driving, horns forward, all of it right at once." },
		"nothing": { "flavor": "The moment was there and then it closed. You hold the impulse and move on." },
		"food":    { "hunger": 0.18, "flavor": "The threat retreats entirely and leaves your grazing area clear." },
		"health":  { "health": 0.14, "flavor": "You win without injury. The confidence carries forward." },
		"debuff":  { "stat": "type_stat", "amount": -0.11, "turns": 2, "source": "sour_greens", "flavor": "You commit before the moment is right. The miss leaves you worse off than staying still would have." },
	},

	"trike_horn_locked": {
		"pass_flavor": "You separate before the lock settles. No winner, no loser.",
		"w_debuff": 0.18,
		"w_nothing": 0.25,
		"buff":    { "stat": "strength", "amount": 0.14, "turns": 4, "source": "neck_power", "flavor": "Neck Power: you found the angle that breaks a lock rather than holds it." },
		"nothing": { "flavor": "You separate cleanly. Both of you walk away intact." },
		"food":    { "hunger": 0.16, "flavor": "You win the lock and the feeding access that follows." },
		"health":  { "health": 0.11, "flavor": "You escape injury in the lock and your body recovers from the effort." },
		"debuff":  { "health": -0.17, "flavor": "The lock twists before you find the right angle. Neck, horn, and frill all take something." },
	},

	"trike_broken_frill_elder": {
		"pass_flavor": "You observe from a distance. It does not acknowledge you.",
		"w_buff": 0.14,
		"w_nothing": 0.28,
		"buff":    { "stat": "defense", "amount": 0.14, "turns": 5, "source": "elder_courage", "flavor": "Elder Courage: standing alone with a torn frill and showing nothing. That is a lesson carried by sight." },
		"nothing": { "flavor": "It watches you pass without changing its posture. The encounter asks nothing of either of you." },
		"food":    { "hunger": 0.17, "flavor": "Following it leads to an old feeding ground it has used through seasons you have not lived through yet." },
		"health":  { "health": 0.13, "flavor": "It leads to a safe hollow. The rest there is unusually deep." },
		"debuff":  { "health": -0.13, "flavor": "The elder's route takes you into predator territory. It knows the risk. You did not." },
	},

	"trike_bones_horned": {
		"pass_flavor": "The bones are silent. You leave them where the land put them.",
		"buff":    { "stat": "defense", "amount": 0.12, "turns": 5, "source": "ancestral_ground", "flavor": "Ancestral Ground: old Triceratops bones in a quiet basin. The land here remembers something." },
		"nothing": { "flavor": "The bones give nothing. The basin is quiet and stays that way." },
		"food":    { "hunger": 0.16, "flavor": "Mineral-rich plants grow where old bones have long decomposed into the soil." },
		"health":  { "health": 0.13, "flavor": "The basin is sheltered and quiet. Nothing is moving here. You rest fully." },
		"debuff":  { "health": -0.12, "flavor": "Predators know this basin. The bones drew them here long before you arrived." },
	},

}


const EVENTS: Dictionary = {

	# ── JUVENILE ──────────────────────────────────────────────────────────────

	"trike_between_giants": {
		"id": "trike_between_giants",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"max_stage": 1,
		"rarity": "common",
		"passive": false,
		"flavor": "You walk beneath the bodies of adults, surrounded by legs, horns, and rumbling breaths.",
		"choices": [
			{ "label": "Stay in the herd","icon": "rest",   "sublabel": "Let them surround you","action": "engage" },
			{ "label": "Move to edge",    "icon": "flee",   "sublabel": "Find more space",     "action": "pass" },
		],
		"resolve_key": "trike_between_giants",
	},

	"trike_first_horn_bumps": {
		"id": "trike_first_horn_bumps",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"max_stage": 1,
		"rarity": "common",
		"passive": false,
		"flavor": "Your small horns are barely useful, but you lower your head and shove at a bush.",
		"choices": [
			{ "label": "Shove the bush",  "icon": "attack", "sublabel": "Practice the motion","action": "engage" },
			{ "label": "Leave it",        "icon": "flee",   "sublabel": "Not ready yet",      "action": "pass" },
		],
		"resolve_key": "trike_first_horn_bumps",
	},

	"trike_soft_fern": {
		"id": "trike_soft_fern",
		"seasons": ["spring", "summer"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"max_stage": 1,
		"rarity": "common",
		"passive": false,
		"flavor": "Tender plants grow low to the ground, perfect for a young beak.",
		"choices": [
			{ "label": "Graze here",      "icon": "rest",   "sublabel": "Eat the soft greens","action": "engage" },
			{ "label": "Move on",         "icon": "flee",   "sublabel": "Better patches ahead","action": "pass" },
		],
		"resolve_key": "trike_soft_fern",
	},

	"trike_warning_snort": {
		"id": "trike_warning_snort",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"max_stage": 1,
		"rarity": "common",
		"passive": false,
		"flavor": "An adult suddenly snorts and freezes. Every calf nearby goes still.",
		"choices": [
			{ "label": "React with it",   "icon": "flee",   "sublabel": "Trust the signal",  "action": "engage" },
			{ "label": "Hold still",      "icon": "rest",   "sublabel": "Wait and see",      "action": "pass" },
		],
		"resolve_key": "trike_warning_snort",
	},

	"trike_frill_sun": {
		"id": "trike_frill_sun",
		"seasons": ["spring", "summer"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"max_stage": 1,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "You angle your small frill toward the morning sun.",
		"choices": [
			{ "label": "Bask a while",    "icon": "rest",   "sublabel": "Warm your blood",   "action": "engage" },
			{ "label": "Stay in shade",   "icon": "flee",   "sublabel": "Too exposed",        "action": "pass" },
		],
		"resolve_key": "trike_frill_sun",
	},

	# ── SUBADULT ──────────────────────────────────────────────────────────────

	"trike_young_bull": {
		"id": "trike_young_bull",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 1,
		"max_stage": 2,
		"rarity": "common",
		"passive": false,
		"flavor": "Another young Triceratops lowers its head at you.",
		"choices": [
			{ "label": "Lower yours",     "icon": "attack", "sublabel": "Answer the challenge","action": "engage" },
			{ "label": "Back away",       "icon": "flee",   "sublabel": "Not worth a fight",  "action": "pass" },
		],
		"resolve_key": "trike_young_bull",
	},

	"trike_testing_charge": {
		"id": "trike_testing_charge",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 1,
		"max_stage": 2,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "A dead stump stands in your path. Your legs tense.",
		"choices": [
			{ "label": "Charge it",       "icon": "attack", "sublabel": "Practice the motion","action": "engage" },
			{ "label": "Go around",       "icon": "flee",   "sublabel": "Save the energy",   "action": "pass" },
		],
		"resolve_key": "trike_testing_charge",
	},

	"trike_pred_edge": {
		"id": "trike_pred_edge",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 1,
		"max_stage": 2,
		"rarity": "common",
		"passive": false,
		"flavor": "A medium predator follows the herd from a distance.",
		"choices": [
			{ "label": "Watch it",        "icon": "stalk",  "sublabel": "Track its distance", "action": "engage" },
			{ "label": "Move inward",     "icon": "flee",   "sublabel": "Get inside the herd","action": "pass" },
		],
		"resolve_key": "trike_pred_edge",
	},

	"trike_mud_wallow": {
		"id": "trike_mud_wallow",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 1,
		"max_stage": 2,
		"rarity": "common",
		"passive": false,
		"flavor": "A muddy depression offers relief from heat and biting insects.",
		"choices": [
			{ "label": "Wallow in it",    "icon": "rest",   "sublabel": "Cool down, cover up","action": "engage" },
			{ "label": "Move on",         "icon": "flee",   "sublabel": "Mud slows you down", "action": "pass" },
		],
		"resolve_key": "trike_mud_wallow",
	},

	"trike_frill_display": {
		"id": "trike_frill_display",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 1,
		"max_stage": 2,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "You flare your body posture, angle your frill, and make yourself look bigger.",
		"choices": [
			{ "label": "Hold the display","icon": "attack", "sublabel": "Make it read the signal","action": "engage" },
			{ "label": "Back down",       "icon": "flee",   "sublabel": "Not worth the risk","action": "pass" },
		],
		"resolve_key": "trike_frill_display",
	},

	# ── ADULT ─────────────────────────────────────────────────────────────────

	"trike_horns_down": {
		"id": "trike_horns_down",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "Something dangerous moves near the herd. You lower your head.",
		"choices": [
			{ "label": "Hold the posture","icon": "attack", "sublabel": "Let the horns speak","action": "engage" },
			{ "label": "Move the herd",   "icon": "flee",   "sublabel": "Get clear of it",   "action": "pass" },
		],
		"resolve_key": "trike_horns_down",
	},

	"trike_trex_standoff": {
		"id": "trike_trex_standoff",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "A massive predator watches from the brush. Neither of you moves first.",
		"choices": [
			{ "label": "Hold the line",   "icon": "attack", "sublabel": "Don't break first",  "action": "engage" },
			{ "label": "Back the herd",   "icon": "flee",   "sublabel": "Move away slowly",  "action": "pass" },
		],
		"resolve_key": "trike_trex_standoff",
	},

	"trike_defensive_circle": {
		"id": "trike_defensive_circle",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "The herd turns inward, placing calves in the center and horns outward.",
		"choices": [
			{ "label": "Take the ring",   "icon": "attack", "sublabel": "Join the formation", "action": "engage" },
			{ "label": "Guard the center","icon": "rest",   "sublabel": "Protect what's inside","action": "pass" },
		],
		"resolve_key": "trike_defensive_circle",
	},

	"trike_root_breaker": {
		"id": "trike_root_breaker",
		"seasons": ["fall", "winter"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "Tough plants hide thick edible roots underground.",
		"choices": [
			{ "label": "Dig for roots",   "icon": "attack", "sublabel": "Use horn and beak",  "action": "engage" },
			{ "label": "Browse instead",  "icon": "rest",   "sublabel": "Protect the horn",   "action": "pass" },
		],
		"resolve_key": "trike_root_breaker",
	},

	"trike_rival_scarface": {
		"id": "trike_rival_scarface",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "An older, scarred Triceratops blocks access to a prime feeding patch.",
		"choices": [
			{ "label": "Challenge it",    "icon": "attack", "sublabel": "Show your own scars","action": "engage" },
			{ "label": "Find other food", "icon": "flee",   "sublabel": "Avoid the fight",   "action": "pass" },
		],
		"resolve_key": "trike_rival_scarface",
	},

	"trike_sudden_charge": {
		"id": "trike_sudden_charge",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "A predator steps too close, and your body reacts before thought catches up.",
		"choices": [
			{ "label": "Let it go",       "icon": "attack", "sublabel": "Commit the charge",  "action": "engage" },
			{ "label": "Hold back",       "icon": "rest",   "sublabel": "Control the impulse","action": "pass" },
		],
		"resolve_key": "trike_sudden_charge",
	},

	"trike_frill_wound": {
		"id": "trike_frill_wound",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "A previous fight left scratches or punctures near your frill.",
		"choices": [
			{ "label": "Display it",      "icon": "attack", "sublabel": "Let rivals read it", "action": "engage" },
			{ "label": "Rest the wound",  "icon": "rest",   "sublabel": "Keep it covered",   "action": "pass" },
		],
		"resolve_key": "trike_frill_wound",
	},

	# ── WOUNDED ADULT ─────────────────────────────────────────────────────────

	"trike_cracked_horn": {
		"id": "trike_cracked_horn",
		"seasons": ["spring", "summer", "fall", "winter"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 2,
		"require_injured": true,
		"rarity": "common",
		"passive": false,
		"flavor": "One horn has chipped from a clash.",
		"choices": [
			{ "label": "Work around it",  "icon": "attack", "sublabel": "Angle the good horn","action": "engage" },
			{ "label": "Avoid clashes",   "icon": "rest",   "sublabel": "Let it heal",        "action": "pass" },
		],
		"resolve_key": "trike_cracked_horn",
	},

	"trike_limp_dangerous": {
		"id": "trike_limp_dangerous",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 2,
		"require_injured": true,
		"rarity": "common",
		"passive": false,
		"flavor": "Your leg hurts, but your horns still point forward.",
		"choices": [
			{ "label": "Keep moving",     "icon": "stalk",  "sublabel": "Don't fall behind",  "action": "engage" },
			{ "label": "Hold position",   "icon": "rest",   "sublabel": "Let the herd circle","action": "pass" },
		],
		"resolve_key": "trike_limp_dangerous",
	},

	"trike_blood_frill": {
		"id": "trike_blood_frill",
		"seasons": ["spring", "fall"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 2,
		"require_injured": true,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "Your wound marks you as vulnerable, but also more intimidating.",
		"choices": [
			{ "label": "Display the wound","icon": "attack","sublabel": "Use it as a warning","action": "engage" },
			{ "label": "Cover it",        "icon": "rest",   "sublabel": "Reduce the blood scent","action": "pass" },
		],
		"resolve_key": "trike_blood_frill",
	},

	"trike_herd_space": {
		"id": "trike_herd_space",
		"seasons": ["spring", "summer", "fall", "winter"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 2,
		"require_injured": true,
		"rarity": "common",
		"passive": false,
		"flavor": "The herd gives your wounded body room to rest.",
		"choices": [
			{ "label": "Rest in place",   "icon": "rest",   "sublabel": "Use the space given","action": "engage" },
			{ "label": "Keep moving",     "icon": "flee",   "sublabel": "Stay with the herd","action": "pass" },
		],
		"resolve_key": "trike_herd_space",
	},

	"trike_last_warning_charge": {
		"id": "trike_last_warning_charge",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 2,
		"require_injured": true,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "You are hurt, but a predator tests you anyway.",
		"choices": [
			{ "label": "Charge it",       "icon": "attack", "sublabel": "Make it regret the test","action": "engage" },
			{ "label": "Hold position",   "icon": "rest",   "sublabel": "Let the horns be enough","action": "pass" },
		],
		"resolve_key": "trike_last_warning_charge",
	},

	# ── HERD / GROUP ──────────────────────────────────────────────────────────

	"trike_horn_line": {
		"id": "trike_horn_line",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "Several adults form a wall of horns facing the same direction.",
		"choices": [
			{ "label": "Hold the line",   "icon": "attack", "sublabel": "Take a place in it", "action": "engage" },
			{ "label": "Guard the rear",  "icon": "rest",   "sublabel": "Protect the calves","action": "pass" },
		],
		"resolve_key": "trike_horn_line",
	},

	"trike_calf_trouble": {
		"id": "trike_calf_trouble",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "A young Triceratops is separated from the herd.",
		"choices": [
			{ "label": "Go get it",       "icon": "attack", "sublabel": "Bring it back",      "action": "engage" },
			{ "label": "Hold position",   "icon": "rest",   "sublabel": "It may find its way","action": "pass" },
		],
		"resolve_key": "trike_calf_trouble",
	},

	"trike_dominance_rut": {
		"id": "trike_dominance_rut",
		"seasons": ["spring", "fall"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "Adults clash for rank, mates, or feeding priority.",
		"choices": [
			{ "label": "Enter the contest","icon": "attack","sublabel": "Compete for rank",   "action": "engage" },
			{ "label": "Let it settle",   "icon": "flee",   "sublabel": "Avoid injury",       "action": "pass" },
		],
		"resolve_key": "trike_dominance_rut",
	},

	"trike_old_matriarch": {
		"id": "trike_old_matriarch",
		"seasons": ["spring", "summer", "fall", "winter"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "An elder leads the herd along an old path.",
		"choices": [
			{ "label": "Follow the elder","icon": "stalk",  "sublabel": "Trust the route",   "action": "engage" },
			{ "label": "Go your own way", "icon": "flee",   "sublabel": "Faster if alone",   "action": "pass" },
		],
		"resolve_key": "trike_old_matriarch",
	},

	"trike_alarm_stampede": {
		"id": "trike_alarm_stampede",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "A scare moves through the herd like lightning.",
		"choices": [
			{ "label": "Hold your ground","icon": "rest",   "sublabel": "Don't add to the panic","action": "engage" },
			{ "label": "Move with it",    "icon": "flee",   "sublabel": "Trust the herd",    "action": "pass" },
		],
		"resolve_key": "trike_alarm_stampede",
	},

	# ── SEASONAL ──────────────────────────────────────────────────────────────

	"trike_spring_calving": {
		"id": "trike_spring_calving",
		"seasons": ["spring"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "The herd gathers in safer feeding territory for young.",
		"choices": [
			{ "label": "Guard the edge",  "icon": "attack", "sublabel": "Protect the calves","action": "engage" },
			{ "label": "Graze within",    "icon": "rest",   "sublabel": "Let others guard",  "action": "pass" },
		],
		"resolve_key": "trike_spring_calving",
	},

	"trike_spring_frill_display": {
		"id": "trike_spring_frill_display",
		"seasons": ["spring"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "Adults display health, size, and strength as the season shifts.",
		"choices": [
			{ "label": "Display fully",   "icon": "attack", "sublabel": "Make your case",    "action": "engage" },
			{ "label": "Hold back",       "icon": "flee",   "sublabel": "Avoid escalation",  "action": "pass" },
		],
		"resolve_key": "trike_spring_frill_display",
	},

	"trike_summer_dry": {
		"id": "trike_summer_dry",
		"seasons": ["summer"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "Soft plants vanish, leaving tougher shrubs and roots.",
		"choices": [
			{ "label": "Eat the shrubs",  "icon": "rest",   "sublabel": "Tough food is still food","action": "engage" },
			{ "label": "Conserve energy", "icon": "flee",   "sublabel": "Wait for better conditions","action": "pass" },
		],
		"resolve_key": "trike_summer_dry",
	},

	"trike_summer_waterhole": {
		"id": "trike_summer_waterhole",
		"seasons": ["summer"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "The herd must drink at a crowded waterhole.",
		"choices": [
			{ "label": "Drink and guard", "icon": "attack", "sublabel": "Claim the bank",    "action": "engage" },
			{ "label": "Drink fast and leave","icon": "flee","sublabel": "Minimize exposure","action": "pass" },
		],
		"resolve_key": "trike_summer_waterhole",
	},

	"trike_fall_horn_clash": {
		"id": "trike_fall_horn_clash",
		"seasons": ["fall"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "Rivals become more aggressive as herds shift and compete.",
		"choices": [
			{ "label": "Accept the clash","icon": "attack", "sublabel": "Hold your rank",     "action": "engage" },
			{ "label": "Display instead", "icon": "stalk",  "sublabel": "Avoid the contact",  "action": "pass" },
		],
		"resolve_key": "trike_fall_horn_clash",
	},

	"trike_fall_heavy_feed": {
		"id": "trike_fall_heavy_feed",
		"seasons": ["fall"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "The herd eats heavily before scarcity.",
		"choices": [
			{ "label": "Eat as much as possible","icon": "rest","sublabel": "Build reserves","action": "engage" },
			{ "label": "Eat steady",      "icon": "stalk",  "sublabel": "No need to rush",   "action": "pass" },
		],
		"resolve_key": "trike_fall_heavy_feed",
	},

	"trike_winter_roots": {
		"id": "trike_winter_roots",
		"seasons": ["winter"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "Food is harder, buried, or woody.",
		"choices": [
			{ "label": "Dig for roots",   "icon": "attack", "sublabel": "Use the horn",      "action": "engage" },
			{ "label": "Browse what is here","icon": "rest", "sublabel": "Protect the horn","action": "pass" },
		],
		"resolve_key": "trike_winter_roots",
	},

	"trike_winter_tight_herd": {
		"id": "trike_winter_tight_herd",
		"seasons": ["winter"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "The herd rests close together through cold or lean nights.",
		"choices": [
			{ "label": "Press in close",  "icon": "rest",   "sublabel": "Share the warmth",  "action": "engage" },
			{ "label": "Stay at the edge","icon": "flee",   "sublabel": "Less crowding risk", "action": "pass" },
		],
		"resolve_key": "trike_winter_tight_herd",
	},

	# ── RARE ──────────────────────────────────────────────────────────────────

	"trike_rex_scar": {
		"id": "trike_rex_scar",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "rare",
		"passive": false,
		"flavor": "You recognize a large predator with an old horn wound across its face.",
		"choices": [
			{ "label": "Hold the stare",  "icon": "attack", "sublabel": "Remind it what you cost","action": "engage" },
			{ "label": "Move the herd",   "icon": "flee",   "sublabel": "Don't test it again","action": "pass" },
		],
		"resolve_key": "trike_rex_scar",
	},

	"trike_perfect_charge": {
		"id": "trike_perfect_charge",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "rare",
		"passive": false,
		"flavor": "You find the exact moment: head low, legs driving, horns forward, everything aligned.",
		"choices": [
			{ "label": "Commit",          "icon": "attack", "sublabel": "This is the moment",  "action": "engage" },
			{ "label": "Hold back",       "icon": "rest",   "sublabel": "Wait for certainty",  "action": "pass" },
		],
		"resolve_key": "trike_perfect_charge",
	},

	"trike_horn_locked": {
		"id": "trike_horn_locked",
		"seasons": ["spring", "fall"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "rare",
		"passive": false,
		"flavor": "Your horns lock with a rival's during a dominance clash.",
		"choices": [
			{ "label": "Drive through",   "icon": "attack", "sublabel": "Find the angle",     "action": "engage" },
			{ "label": "Disengage fast",  "icon": "flee",   "sublabel": "Separate cleanly",   "action": "pass" },
		],
		"resolve_key": "trike_horn_locked",
	},

	"trike_broken_frill_elder": {
		"id": "trike_broken_frill_elder",
		"seasons": ["spring", "summer", "fall", "winter"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "rare",
		"passive": false,
		"flavor": "An elderly Triceratops with a torn frill stands alone but unafraid.",
		"choices": [
			{ "label": "Observe it",      "icon": "stalk",  "sublabel": "Watch and learn",    "action": "engage" },
			{ "label": "Move away",       "icon": "flee",   "sublabel": "Don't follow it",    "action": "pass" },
		],
		"resolve_key": "trike_broken_frill_elder",
	},

	"trike_bones_horned": {
		"id": "trike_bones_horned",
		"seasons": ["spring", "summer", "fall", "winter"],
		"trees": ["herbivore"],
		"species": ["triceratops"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "rare",
		"passive": false,
		"flavor": "Old Triceratops bones lie weathered in a dry basin.",
		"choices": [
			{ "label": "Stay in the basin","icon": "rest",  "sublabel": "Rest in quiet ground","action": "engage" },
			{ "label": "Move on",          "icon": "flee",  "sublabel": "Predators know this place","action": "pass" },
		],
		"resolve_key": "trike_bones_horned",
	},

}
