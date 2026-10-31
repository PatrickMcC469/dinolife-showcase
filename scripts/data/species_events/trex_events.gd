# Tyrannosaurus encounter data — loaded by ActionResolver and EventsDB

const OUTCOME_EVENTS: Dictionary = {

	# ── JUVENILE ──────────────────────────────────────────────────────────────

	"trex_long_legs_chase": {
		"pass_flavor": "You let the prey go. Your legs aren't ready.",
		"buff":    { "stat": "speed", "amount": 0.10, "turns": 3, "source": "young_sprint", "flavor": "Young Sprint: your speed carries you farther than your size suggests." },
		"nothing": { "flavor": "The prey vanishes into brush before you can close the distance." },
		"food":    { "hunger": 0.18, "flavor": "You catch the small animal before it reaches cover. A clean run." },
		"health":  { "health": 0.08, "flavor": "Easy food and exercise leave you sharp and restored." },
		"debuff":  { "stat": "speed", "amount": -0.08, "turns": 2, "source": "stumbled_chase", "flavor": "You trip in mid-stride and land awkwardly, straining your legs." },
	},

	"trex_bone_pile_curiosity": {
		"pass_flavor": "Nothing here worth cracking. You leave it.",
		"buff":    { "stat": "type_stat", "amount": 0.10, "turns": 3, "source": "jaw_practice", "flavor": "Jaw Practice: working through bone toughens your bite." },
		"nothing": { "flavor": "Nothing edible remains. The bones are dry and stripped." },
		"food":    { "hunger": 0.12, "flavor": "You pry apart old scraps and dig insects from between the bones." },
		"health":  { "health": 0.07, "flavor": "Marrow fragments give your body what it needs." },
		"debuff":  { "stat": "type_stat", "amount": -0.08, "turns": 2, "source": "jaw_strain", "flavor": "You force your jaw against the bone until a sharp ache makes you stop." },
	},

	"trex_parent_shadow": {
		"pass_flavor": "You hold still and let the large rex pass without notice.",
		"buff":    { "stat": "defense", "amount": 0.10, "turns": 4, "source": "protected_presence", "flavor": "Protected Presence: you learn to stay near the larger rex, where other predators keep their distance." },
		"nothing": { "flavor": "The larger rex moves on without acknowledging you." },
		"food":    { "hunger": 0.14, "flavor": "It leaves scraps behind without looking back." },
		"health":  { "health": 0.10, "flavor": "Other predators avoid the area. You rest without watching." },
		"debuff":  { "health": -0.07, "flavor": "You move too close. A warning snap catches your flank." },
	},

	"trex_muddy_footprints": {
		"pass_flavor": "You study the tracks and move on. Nothing useful today.",
		"buff":    { "stat": "type_stat", "amount": 0.10, "turns": 3, "source": "track_reader", "flavor": "Track Reader: you know what came through here and which direction it went." },
		"nothing": { "flavor": "The trail is too old. The scent has gone flat." },
		"food":    { "hunger": 0.12, "flavor": "A small animal shelters near the print. It does not hear you coming." },
		"health":  { "health": 0.06, "flavor": "You drink clean water pooled in a deep print." },
		"debuff":  { "stat": "speed", "amount": -0.10, "turns": 2, "source": "bogged_down", "flavor": "The mud grabs your foot. You haul yourself out slower than you went in." },
	},

	"trex_fast_not_strong": {
		"pass_flavor": "The prey reaches cover. You let it go this time.",
		"buff":    { "stat": "strength", "amount": 0.10, "turns": 3, "source": "lean_hunter", "flavor": "Lean Hunter: you are learning to pick your moment against smaller prey." },
		"nothing": { "flavor": "It reaches the brush in time. The ground shakes behind it and it does not look back." },
		"food":    { "hunger": 0.20, "flavor": "You catch it before it hits the tree line." },
		"health":  { "health": 0.10, "flavor": "A clean hunt leaves your body working right." },
		"debuff":  { "health": -0.08, "flavor": "It kicks out mid-chase. The blow clips your jaw." },
	},

	# ── SUBADULT ──────────────────────────────────────────────────────────────

	"trex_blood_scent": {
		"pass_flavor": "You hold position. The scent could mean anything.",
		"buff":    { "stat": "type_stat", "amount": 0.11, "turns": 3, "source": "blood_nose", "flavor": "Blood Nose: you can read the difference between old blood and fresh from here." },
		"nothing": { "flavor": "The scent fades before you can get a direction from it." },
		"food":    { "hunger": 0.22, "flavor": "You follow the blood to something that will not last much longer on its own." },
		"health":  { "health": 0.10, "flavor": "Easy meat means no risk. Your body thanks you for it." },
		"debuff":  { "health": -0.08, "flavor": "The trail leads straight into a rival's range. You retreat with attention on you." },
	},

	"trex_edmonto_trail": {
		"pass_flavor": "You read the trail and leave it. Not today.",
		"buff":    { "stat": "type_stat", "amount": 0.10, "turns": 3, "source": "herd_follower", "flavor": "Herd Follower: you know how large prey moves and how far behind them you can stay." },
		"nothing": { "flavor": "The trail goes cold. The herd moved faster than it looked." },
		"food":    { "hunger": 0.24, "flavor": "A straggler has fallen too far behind to rejoin the herd." },
		"health":  { "health": 0.10, "flavor": "The herd route leads through shade and water." },
		"debuff":  { "stat": "type_stat", "amount": -0.08, "turns": 2, "source": "herd_spotted", "flavor": "The herd spots you before you get close. They close ranks and move as one." },
	},

	"trex_carcass_claim": {
		"pass_flavor": "You let the scavengers have it. Not worth the effort.",
		"buff":    { "stat": "strength", "amount": 0.12, "turns": 3, "source": "claiming_roar", "flavor": "Claiming Roar: everything here takes one look and decides it has somewhere else to be." },
		"nothing": { "flavor": "The carcass is picked over. You turn what is left into nothing worth eating." },
		"food":    { "hunger": 0.26, "flavor": "The scavengers scatter. What they left behind is still worth taking." },
		"health":  { "health": 0.12, "flavor": "Rich feeding without a chase. Your body recovers while it eats." },
		"debuff":  { "health": -0.10, "flavor": "A larger predator arrives and disputes the claim." },
	},

	"trex_young_horn": {
		"pass_flavor": "You read the posture and decide against it.",
		"buff":    { "stat": "defense", "amount": 0.10, "turns": 3, "source": "horn_respect", "flavor": "Horn Respect: you know how to read the angle before it matters." },
		"nothing": { "flavor": "You leave it. A small ceratopsian is not worth what it could cost." },
		"food":    { "hunger": 0.18, "flavor": "You circle the stand-off and find easier prey that moved away from the noise." },
		"health":  { "health": 0.08, "flavor": "You preserve your energy. The rest of the day goes better." },
		"debuff":  { "health": -0.12, "flavor": "The horn connects. You back away slower than you moved in." },
	},

	"trex_subadult_rival": {
		"pass_flavor": "You hold your ground and let the tension drain out on its own.",
		"buff":    { "stat": "strength", "amount": 0.11, "turns": 3, "source": "rival_confidence", "flavor": "Rival Confidence: you read these exchanges now. The posture tells you most of what you need." },
		"nothing": { "flavor": "Both of you hold long enough that the point becomes unclear. You both leave." },
		"food":    { "hunger": 0.14, "flavor": "It abandons the scraps it was guarding and moves off." },
		"health":  { "health": 0.08, "flavor": "Avoiding the fight costs you nothing. Your body is better for it." },
		"debuff":  { "health": -0.12, "flavor": "The bite is fast and targeted. You carry the mark for a while." },
	},

	# ── ADULT ─────────────────────────────────────────────────────────────────

	"trex_crushing_bite": {
		"pass_flavor": "The opening closes. You hold and wait for a better one.",
		"buff":    { "stat": "strength", "amount": 0.14, "turns": 4, "source": "bone_crusher", "flavor": "Bone-Crusher: the bite lands with the full weight of everything behind it." },
		"nothing": { "flavor": "The opening is gone before you can commit." },
		"food":    { "hunger": 0.32, "flavor": "The bite lands and does not let go. The prey does not go far." },
		"health":  { "health": 0.16, "flavor": "A clean decisive kill. Your body runs on it." },
		"debuff":  { "stat": "type_stat", "amount": -0.10, "turns": 2, "source": "jaw_strain", "flavor": "You bite at the wrong angle, straining your jaw and neck." },
	},

	"trex_trike_standoff": {
		"pass_flavor": "You read what is in front of you and leave it where it stands.",
		"w_debuff": 0.18,
		"w_nothing": 0.25,
		"w_buff": 0.10,
		"buff":    { "stat": "defense", "amount": 0.12, "turns": 4, "source": "horn_breakers_patience", "flavor": "Horn Breaker's Patience: you know what full commitment against a horned animal costs." },
		"nothing": { "flavor": "You do not commit. The Triceratops holds the ground and you leave it there." },
		"food":    { "hunger": 0.22, "flavor": "The standoff scatters smaller prey into the open." },
		"health":  { "health": 0.12, "flavor": "Avoiding the charge preserves everything. You recover while others take the risk." },
		"debuff":  { "health": -0.18, "flavor": "The horn finds you. You pull back but not fast enough." },
	},

	"trex_edmonto_panic": {
		"pass_flavor": "The herd moves too fast. You let it go.",
		"buff":    { "stat": "speed", "amount": 0.12, "turns": 3, "source": "panic_splitter", "flavor": "Panic Splitter: you read the break before it happens and you are already moving." },
		"nothing": { "flavor": "The herd regroups faster than the panic suggested. Nothing separates." },
		"food":    { "hunger": 0.34, "flavor": "One animal goes down before the rest reach speed." },
		"health":  { "health": 0.18, "flavor": "A large clean kill. Your body runs at full capacity." },
		"debuff":  { "health": -0.12, "flavor": "The stampede is louder than expected. You catch a tail or a shoulder on the way out." },
	},

	"trex_ankylo_warning": {
		"pass_flavor": "You watch the club and walk away. The math is wrong.",
		"w_debuff": 0.20,
		"w_nothing": 0.25,
		"w_buff": 0.10,
		"buff":    { "stat": "defense", "amount": 0.12, "turns": 4, "source": "club_caution", "flavor": "Club Caution: you know the reach now. You know where not to stand." },
		"nothing": { "flavor": "You leave it alone. The Ankylosaurus watches you go." },
		"food":    { "hunger": 0.18, "flavor": "Smaller prey flush from the area while the armored animal holds your attention." },
		"health":  { "health": 0.10, "flavor": "You wait out the stand-off safely. The rest does you good." },
		"debuff":  { "health": -0.20, "flavor": "The club catches you before you expect it. The impact travels through your entire side." },
	},

	"trex_waterhole_tyrant": {
		"pass_flavor": "Too many eyes on the water. You stay back.",
		"buff":    { "stat": "strength", "amount": 0.13, "turns": 3, "source": "waterhole_dominance", "flavor": "Waterhole Dominance: you arrive and everything here moves to the edges." },
		"nothing": { "flavor": "Too many eyes. The area is contested and you cannot get a clean position." },
		"food":    { "hunger": 0.28, "flavor": "A desperate animal comes to the water anyway. It does not make it back." },
		"health":  { "health": 0.14, "flavor": "You drink without challenge and feed from what was already there." },
		"debuff":  { "health": -0.12, "flavor": "A rival or a defensive herd punishes your advance." },
	},

	"trex_scented_breeze": {
		"pass_flavor": "You wait. The scent does not come back around.",
		"buff":    { "stat": "type_stat", "amount": 0.12, "turns": 4, "source": "far_nose", "flavor": "Far Nose: you can read the difference between near and far from the faintest thread of scent." },
		"nothing": { "flavor": "The wind shifts and it is gone before you get a direction." },
		"food":    { "hunger": 0.26, "flavor": "You follow the scent to something that has been dead long enough to stay put." },
		"health":  { "health": 0.12, "flavor": "Easy feeding without effort. Your body rebuilds." },
		"debuff":  { "stat": "hunger", "amount": -0.12, "flavor": "Another apex predator got there first. You leave empty." },
	},

	"trex_smaller_pred_scatter": {
		"pass_flavor": "You let it go. Not worth the energy.",
		"buff":    { "stat": "strength", "amount": 0.12, "turns": 3, "source": "apex_presence", "flavor": "Apex Presence: smaller predators do not stay to argue the point." },
		"nothing": { "flavor": "It leaves nothing useful. The site is stripped." },
		"food":    { "hunger": 0.24, "flavor": "You take the kill. It had already done the work." },
		"health":  { "health": 0.12, "flavor": "You secure the site without a contest. You feed and rest undisturbed." },
		"debuff":  { "health": -0.07, "flavor": "It lashes out on the way out. A parting bite that you did not expect." },
	},

	# ── WOUNDED ADULT ─────────────────────────────────────────────────────────

	"trex_broken_tooth": {
		"pass_flavor": "You do not bite down. The ache is not worth what it costs.",
		"buff":    { "stat": "type_stat", "amount": 0.10, "turns": 3, "source": "careful_bite", "flavor": "Careful Bite: you learn to place the load where it does not hurt." },
		"nothing": { "flavor": "The pain fades slowly. You rest and leave it alone." },
		"food":    { "hunger": 0.18, "flavor": "You find something soft enough that biting down does not cost you." },
		"health":  { "health": 0.10, "flavor": "Rest and careful feeding let the worst of it settle." },
		"debuff":  { "stat": "type_stat", "amount": -0.10, "turns": 3, "source": "broken_tooth", "flavor": "The damaged tooth takes the full load. Your bite is not what it was." },
	},

	"trex_limp_floodplain": {
		"pass_flavor": "You stay put. Moving the wrong way now costs too much.",
		"buff":    { "stat": "speed", "amount": 0.09, "turns": 3, "source": "measured_steps", "flavor": "Measured Steps: you find the route that does not punish the bad leg." },
		"nothing": { "flavor": "You move carefully and lose time. Nothing gained, nothing worsened." },
		"food":    { "hunger": 0.20, "flavor": "You find carrion close enough that the leg is not the problem." },
		"health":  { "health": 0.12, "flavor": "Careful movement through the right terrain preserves what you have." },
		"debuff":  { "stat": "speed", "amount": -0.12, "turns": 3, "source": "leg_wound", "flavor": "The old injury takes the step wrong. It is worse now than when you started." },
	},

	"trex_blood_in_mud": {
		"pass_flavor": "You stop moving. If something is following, let it come to you.",
		"buff":    { "stat": "speed", "amount": 0.09, "turns": 3, "source": "washed_trail", "flavor": "Washed Trail: the rain comes and the blood trail behind you stops reading." },
		"nothing": { "flavor": "Nothing picks up the trail. You move again when you are sure." },
		"food":    { "hunger": 0.18, "flavor": "Scavengers drawn to your blood lead you to a carcass nearby." },
		"health":  { "health": 0.10, "flavor": "You find water and clean the wound. The bleeding slows." },
		"debuff":  { "health": -0.10, "flavor": "Something follows the trail directly. The encounter does not go in your favor." },
	},

	"trex_fallen_giant_rest": {
		"pass_flavor": "The site is exposed. You keep moving.",
		"buff":    { "stat": "defense", "amount": 0.12, "turns": 4, "source": "massive_shelter", "flavor": "Massive Shelter: cover sized for something your size is rare. You use it." },
		"nothing": { "flavor": "The site is workable but exposed in places. You rest without advantage." },
		"food":    { "hunger": 0.14, "flavor": "Small scavengers nearby scatter when you arrive. You take what they had." },
		"health":  { "health": 0.18, "flavor": "Real shelter. Your body uses the quiet to rebuild." },
		"debuff":  { "health": -0.08, "flavor": "The ground underneath is worse than it looked. Recovery costs more than it should." },
	},

	"trex_hunger_vs_pain": {
		"pass_flavor": "You hold still. The hunger can wait.",
		"buff":    { "stat": "type_stat", "amount": 0.11, "turns": 3, "source": "pain_endurance", "flavor": "Pain Endurance: you run at reduced capacity and it costs you less than it should." },
		"nothing": { "flavor": "You conserve energy. The day passes and you stay where you are." },
		"food":    { "hunger": 0.22, "flavor": "Weakened prey or nearby carrion lets you feed without the full cost of a hunt." },
		"health":  { "health": 0.14, "flavor": "Rest is the right choice. Your body makes progress without being asked to fight." },
		"debuff":  { "health": -0.14, "flavor": "The wound reopens mid-chase. You finish the hunt worse than you started it." },
	},

	# ── SOCIAL / RIVAL ────────────────────────────────────────────────────────

	"trex_sibling_dispute": {
		"pass_flavor": "You back off. The scrap is not worth it.",
		"buff":    { "stat": "strength", "amount": 0.10, "turns": 3, "source": "food_assertive", "flavor": "Food Assertive: you hold your ground and the other one finds somewhere else to be." },
		"nothing": { "flavor": "You both posture until neither of you remembers what started it. You both move on." },
		"food":    { "hunger": 0.16, "flavor": "You win the scrap. Small, but yours." },
		"health":  { "health": 0.08, "flavor": "The dispute ends without injury. You rest better for it." },
		"debuff":  { "health": -0.10, "flavor": "The bite lands on your face or neck. A sibling means nothing in the moment it happens." },
	},

	"trex_shared_carcass": {
		"pass_flavor": "You feed at the edge and leave before it escalates.",
		"buff":    { "stat": "strength", "amount": 0.12, "turns": 3, "source": "feeding_rank", "flavor": "Feeding Rank: your position at the carcass is not contested." },
		"nothing": { "flavor": "You feed at a distance without incident and leave." },
		"food":    { "hunger": 0.34, "flavor": "You secure the better portion. The other rex takes what is left." },
		"health":  { "health": 0.16, "flavor": "Shared feeding, no fight. You leave with more than you came with." },
		"debuff":  { "health": -0.14, "flavor": "The fight over the carcass costs you more than the carcass was worth." },
	},

	"trex_mating_rival": {
		"pass_flavor": "You hold your ground but do not escalate.",
		"w_debuff": 0.16,
		"w_buff": 0.11,
		"buff":    { "stat": "strength", "amount": 0.13, "turns": 4, "source": "scar_display", "flavor": "Scar Display: the rival reads your history and decides against continuing." },
		"nothing": { "flavor": "The rival withdraws. The territory is yours without the cost of proving it." },
		"food":    { "hunger": 0.16, "flavor": "It abandons a feeding trail or recent kill site when it goes." },
		"health":  { "health": 0.10, "flavor": "No fight means no damage. You hold and recover." },
		"debuff":  { "health": -0.18, "flavor": "The dominance fight is short and serious. You both walk away with something to show for it." },
	},

	"trex_passing_tolerance": {
		"pass_flavor": "You watch it pass and do nothing.",
		"buff":    { "stat": "type_stat", "amount": 0.10, "turns": 3, "source": "territory_reader", "flavor": "Territory Reader: you know when to assert and when letting something pass is the stronger move." },
		"nothing": { "flavor": "It crosses your range and continues. Neither of you breaks the quiet." },
		"food":    { "hunger": 0.18, "flavor": "It leaves behind a kill site or a trail worth following." },
		"health":  { "health": 0.10, "flavor": "No confrontation means no cost. You spend the time recovering." },
		"debuff":  { "health": -0.10, "flavor": "The tolerance runs out faster than expected. The encounter turns before you are ready." },
	},

	"trex_young_following": {
		"pass_flavor": "You move on. It can follow or it cannot.",
		"buff":    { "stat": "strength", "amount": 0.10, "turns": 3, "source": "commanding_presence", "flavor": "Commanding Presence: scavengers and rivals think twice about contesting anything near you." },
		"nothing": { "flavor": "It eventually stops following. You continue alone." },
		"food":    { "hunger": 0.18, "flavor": "Its movements flush prey or draw your attention to a carcass nearby." },
		"health":  { "health": 0.10, "flavor": "It alerts you to something before you notice it yourself. You rest without the threat finding you." },
		"debuff":  { "health": -0.10, "flavor": "Its presence attracts exactly the kind of attention you did not want." },
	},

	# ── SEASONAL ──────────────────────────────────────────────────────────────

	"trex_spring_nesting": {
		"pass_flavor": "You leave the nesting grounds alone.",
		"buff":    { "stat": "speed", "amount": 0.10, "turns": 3, "source": "young_prey_sense", "flavor": "Young Prey Sense: you know where the easy food is before the protective adults notice you." },
		"nothing": { "flavor": "Protective adults keep everything out of reach. You leave without finding an opening." },
		"food":    { "hunger": 0.20, "flavor": "Something small and slow is too far from cover." },
		"health":  { "health": 0.12, "flavor": "Easy feeding without a real hunt. Your body uses the rest." },
		"debuff":  { "health": -0.10, "flavor": "A parent comes back before you finish. You get the aggressive end of a protective herbivore." },
	},

	"trex_spring_floodplain": {
		"pass_flavor": "Too much mud to commit to anything.",
		"buff":    { "stat": "type_stat", "amount": 0.11, "turns": 3, "source": "mud_reader", "flavor": "Mud Reader: the tracks here are like a map with timestamps." },
		"nothing": { "flavor": "Too many trails cross each other. The mud tells you everything and nothing." },
		"food":    { "hunger": 0.22, "flavor": "The tracks lead you directly to where the prey is still standing." },
		"health":  { "health": 0.10, "flavor": "Cool wet ground and clean water. Your body runs quieter for a while." },
		"debuff":  { "stat": "speed", "amount": -0.12, "turns": 2, "source": "bogged_down", "flavor": "The mud takes your weight and does not give it back easily. You haul yourself clear." },
	},

	"trex_summer_heat": {
		"pass_flavor": "You wait the heat out. Nothing moves until it cools.",
		"buff":    { "stat": "type_stat", "amount": 0.10, "turns": 3, "source": "shade_hunter", "flavor": "Shade Hunter: you find the angles where cover and position meet." },
		"nothing": { "flavor": "You rest through the worst of it. Nothing valuable moves in this heat." },
		"food":    { "hunger": 0.22, "flavor": "Heat-stressed prey is slow enough that patience becomes a hunting strategy." },
		"health":  { "health": 0.14, "flavor": "Deep shade and water. You come out of the heat better than you went in." },
		"debuff":  { "stat": "type_stat", "amount": -0.10, "turns": 2, "source": "overheated", "flavor": "You move too hard in the heat. Your body does not recover the way it should." },
	},

	"trex_summer_dry_crossing": {
		"pass_flavor": "Too many competing interests at the crossing.",
		"buff":    { "stat": "strength", "amount": 0.12, "turns": 3, "source": "crossing_control", "flavor": "Crossing Control: you own this choke point and everything that comes through it." },
		"nothing": { "flavor": "The crossing stays crowded but impossible to work cleanly." },
		"food":    { "hunger": 0.28, "flavor": "A desperate animal forces the crossing anyway. You are waiting." },
		"health":  { "health": 0.14, "flavor": "You drink without opposition and feed from what was already vulnerable." },
		"debuff":  { "health": -0.12, "flavor": "Rival predators have the same idea. The crossing becomes contested." },
	},

	"trex_fall_migration": {
		"pass_flavor": "You watch the herd move and do not commit.",
		"buff":    { "stat": "speed", "amount": 0.11, "turns": 4, "source": "migration_follower", "flavor": "Migration Follower: you know how to move with the flow instead of against it." },
		"nothing": { "flavor": "You lose the route. The herd moves faster than you anticipated." },
		"food":    { "hunger": 0.28, "flavor": "Weak or sick animals fall behind the main group. You do not have to chase." },
		"health":  { "health": 0.14, "flavor": "Migration routes have water and shelter along them. You use both." },
		"debuff":  { "health": -0.12, "flavor": "The herd's defensive action catches you during a bad approach." },
	},

	"trex_fall_carcass_season": {
		"pass_flavor": "You leave it. The risks at the carcass are not worth today.",
		"buff":    { "stat": "type_stat", "amount": 0.12, "turns": 4, "source": "carrion_lord", "flavor": "Carrion Lord: you can read the land for death now. The carcasses find you." },
		"nothing": { "flavor": "Scavengers were there first and there is nothing left to claim." },
		"food":    { "hunger": 0.30, "flavor": "A large carcass with no one else willing to contest it." },
		"health":  { "health": 0.18, "flavor": "A massive easy meal. Your body rebuilds itself without effort." },
		"debuff":  { "health": -0.12, "flavor": "The carcass comes with a disease risk or a rival willing to fight over it." },
	},

	"trex_winter_empty": {
		"pass_flavor": "You conserve energy. Moving costs too much today.",
		"buff":    { "stat": "type_stat", "amount": 0.10, "turns": 4, "source": "efficient_feeding", "flavor": "Efficient Feeding: you extract more from what little you find." },
		"nothing": { "flavor": "You spend the day conserving energy. Nothing gained, nothing spent." },
		"food":    { "hunger": 0.20, "flavor": "Hidden carrion or a weakened animal too slow to matter." },
		"health":  { "health": 0.14, "flavor": "Long quiet rest. Your body makes progress when you stop pushing it." },
		"debuff":  { "stat": "strength", "amount": -0.12, "turns": 3, "source": "hunger_weakness", "flavor": "The hunger is getting into your muscles. Your body is starting to answer for it." },
	},

	# ── RARE ──────────────────────────────────────────────────────────────────

	"trex_trike_mistake": {
		"pass_flavor": "You pull back at the last second. The horn passes close enough.",
		"w_debuff": 0.25,
		"w_buff": 0.08,
		"w_nothing": 0.20,
		"buff":    { "stat": "defense", "amount": 0.15, "turns": 0, "source": "horn_survivor", "perm": true, "perm_label": "Horn Survivor", "flavor": "Horn Survivor: you know exactly what full commitment against horns costs. You will not make that mistake again." },
		"nothing": { "flavor": "You pull away at the last second. The horn passes close enough that you hear it." },
		"food":    { "hunger": 0.18, "flavor": "The chaos flushes smaller prey into the open. You redirect." },
		"health":  { "health": 0.08, "flavor": "You survive unhurt. The lesson is enough." },
		"debuff":  { "health": -0.22, "flavor": "The horn finds the wrong angle. You carry that for a long time." },
	},

	"trex_ankylo_lesson": {
		"pass_flavor": "You keep your distance. You have seen what that club does.",
		"w_debuff": 0.25,
		"w_buff": 0.08,
		"w_nothing": 0.20,
		"buff":    { "stat": "defense", "amount": 0.15, "turns": 0, "source": "club_survivor", "perm": true, "perm_label": "Club Survivor", "flavor": "Club Survivor: the reach is locked in your body now. You know where not to stand." },
		"nothing": { "flavor": "You keep your distance. The club swings and finds nothing." },
		"food":    { "hunger": 0.16, "flavor": "Prey flushes from the area while the Ankylosaurus holds your attention." },
		"health":  { "health": 0.08, "flavor": "You stay out of range and walk away intact." },
		"debuff":  { "health": -0.24, "flavor": "The club connects with your leg or ribs. The impact is not something you walk off quickly." },
	},

	"trex_giant_carcass": {
		"pass_flavor": "Too many rivals. You leave the feast to the crowd.",
		"w_food": 0.34,
		"w_health": 0.22,
		"w_buff": 0.10,
		"w_debuff": 0.14,
		"buff":    { "stat": "strength", "amount": 0.14, "turns": 5, "source": "feast_claimant", "flavor": "Feast Claimant: everything else at this carcass learns what your presence means." },
		"nothing": { "flavor": "Too many rivals already surround it. You cannot get close enough to make it count." },
		"food":    { "hunger": 0.45, "flavor": "The largest meal you have had in memory." },
		"health":  { "health": 0.24, "flavor": "You feed until there is nothing left to want." },
		"debuff":  { "health": -0.14, "flavor": "The brawl over the carcass costs more than you expected." },
	},

	"trex_thunder_lowlands": {
		"pass_flavor": "You shelter and wait. The storm does the work of clearing everything.",
		"buff":    { "stat": "type_stat", "amount": 0.14, "turns": 3, "source": "storm_stalker", "flavor": "Storm Stalker: when everything else goes quiet, you move." },
		"nothing": { "flavor": "You shelter until it passes. The land is reset and empty when it clears." },
		"food":    { "hunger": 0.26, "flavor": "Panicked prey runs toward you through the noise and the dark." },
		"health":  { "health": 0.14, "flavor": "Cool rain and the quiet after. Your body uses the rest." },
		"debuff":  { "health": -0.12, "flavor": "The mud or the dark or something falling in the storm catches you before you catch anything." },
	},

	"trex_old_king": {
		"pass_flavor": "You watch from a distance and do not move.",
		"w_debuff": 0.16,
		"w_nothing": 0.30,
		"buff":    { "stat": "type_stat", "amount": 0.13, "turns": 5, "source": "old_hunters_lesson", "flavor": "Old Hunter's Lesson: watching something that has been doing this longer than you is its own kind of knowledge." },
		"nothing": { "flavor": "It vanishes into the distance without acknowledging you." },
		"food":    { "hunger": 0.22, "flavor": "It leaves behind a feeding route or kill site you can follow." },
		"health":  { "health": 0.12, "flavor": "You avoid the encounter entirely and spend the time recovering." },
		"debuff":  { "health": -0.16, "flavor": "It turns and challenges you before you can read what it intended. The encounter is not even." },
	},

	"trex_echoing_roar": {
		"pass_flavor": "You hold the call. No sense announcing yourself today.",
		"w_buff": 0.14,
		"w_debuff": 0.18,
		"buff":    { "stat": "strength", "amount": 0.14, "turns": 4, "source": "tyrants_roar", "flavor": "Tyrant's Roar: smaller predators clear the area before you finish the sound." },
		"nothing": { "flavor": "No answer comes back. The land absorbs it and returns nothing." },
		"food":    { "hunger": 0.22, "flavor": "Smaller predators abandon their kills when they hear you." },
		"health":  { "health": 0.12, "flavor": "The cleared area becomes yours. You rest without anything nearby to worry about." },
		"debuff":  { "health": -0.16, "flavor": "A rival apex predator answers. The response tells you it is not far." },
	},

}


const EVENTS: Dictionary = {

	# ── JUVENILE ──────────────────────────────────────────────────────────────

	"trex_long_legs_chase": {
		"id": "trex_long_legs_chase",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"max_stage": 1,
		"rarity": "common",
		"passive": false,
		"flavor": "A small prey animal breaks from cover. Your body wants to run.",
		"choices": [
			{ "label": "Give chase",      "icon": "attack", "sublabel": "Run it down",           "action": "engage" },
			{ "label": "Let it go",       "icon": "flee",   "sublabel": "Save your energy",      "action": "pass" },
		],
		"resolve_key": "trex_long_legs_chase",
	},

	"trex_bone_pile_curiosity": {
		"id": "trex_bone_pile_curiosity",
		"seasons": ["spring", "summer", "fall", "winter"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"max_stage": 1,
		"rarity": "common",
		"passive": false,
		"flavor": "You find an old carcass site with scattered bones and dried hide.",
		"choices": [
			{ "label": "Crack the bones", "icon": "attack", "sublabel": "Work through it",       "action": "engage" },
			{ "label": "Move on",         "icon": "flee",   "sublabel": "Nothing left here",     "action": "pass" },
		],
		"resolve_key": "trex_bone_pile_curiosity",
	},

	"trex_parent_shadow": {
		"id": "trex_parent_shadow",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"max_stage": 1,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "A much larger tyrannosaur passes nearby. You feel safer, but also very small.",
		"choices": [
			{ "label": "Stay close",      "icon": "stalk",  "sublabel": "Use the protection",   "action": "engage" },
			{ "label": "Keep distance",   "icon": "flee",   "sublabel": "Don't draw attention", "action": "pass" },
		],
		"resolve_key": "trex_parent_shadow",
	},

	"trex_muddy_footprints": {
		"id": "trex_muddy_footprints",
		"seasons": ["spring", "fall"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"max_stage": 1,
		"rarity": "common",
		"passive": false,
		"flavor": "Huge tracks fill with rainwater and scent. Something came through here.",
		"choices": [
			{ "label": "Read the trail",  "icon": "stalk",  "sublabel": "Follow the scent",     "action": "engage" },
			{ "label": "Leave it",        "icon": "flee",   "sublabel": "Not worth the mud",    "action": "pass" },
		],
		"resolve_key": "trex_muddy_footprints",
	},

	"trex_fast_not_strong": {
		"id": "trex_fast_not_strong",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"max_stage": 1,
		"rarity": "common",
		"passive": false,
		"flavor": "A juvenile herbivore stands just a little too long in the open.",
		"choices": [
			{ "label": "Run it down",     "icon": "attack", "sublabel": "Go now",               "action": "engage" },
			{ "label": "Hold off",        "icon": "flee",   "sublabel": "Wait for better odds", "action": "pass" },
		],
		"resolve_key": "trex_fast_not_strong",
	},

	# ── SUBADULT ──────────────────────────────────────────────────────────────

	"trex_blood_scent": {
		"id": "trex_blood_scent",
		"seasons": ["spring", "summer", "fall", "winter"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 1,
		"max_stage": 2,
		"rarity": "common",
		"passive": false,
		"flavor": "A bloody smell drifts over the floodplain. Something is hurt or dead not far from here.",
		"choices": [
			{ "label": "Follow it",       "icon": "stalk",  "sublabel": "Track the source",     "action": "engage" },
			{ "label": "Ignore it",       "icon": "flee",   "sublabel": "Could be a trap",      "action": "pass" },
		],
		"resolve_key": "trex_blood_scent",
	},

	"trex_edmonto_trail": {
		"id": "trex_edmonto_trail",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 1,
		"max_stage": 2,
		"rarity": "common",
		"passive": false,
		"flavor": "A herd of Edmontosaurus has passed recently. Trampled plants and dung mark the route.",
		"choices": [
			{ "label": "Follow the herd", "icon": "stalk",  "sublabel": "Trail behind them",    "action": "engage" },
			{ "label": "Leave it",        "icon": "flee",   "sublabel": "Not worth the risk",   "action": "pass" },
		],
		"resolve_key": "trex_edmonto_trail",
	},

	"trex_carcass_claim": {
		"id": "trex_carcass_claim",
		"seasons": ["spring", "summer", "fall", "winter"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 1,
		"max_stage": 2,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "A carcass lies in open ground. Scavengers and smaller predators already feed.",
		"choices": [
			{ "label": "Claim it",        "icon": "attack", "sublabel": "Drive them off",       "action": "engage" },
			{ "label": "Leave it",        "icon": "flee",   "sublabel": "Let them have it",     "action": "pass" },
		],
		"resolve_key": "trex_carcass_claim",
	},

	"trex_young_horn": {
		"id": "trex_young_horn",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 1,
		"max_stage": 2,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "A small ceratopsian lowers its head rather than flee.",
		"choices": [
			{ "label": "Press the attack","icon": "attack", "sublabel": "Call its bluff",       "action": "engage" },
			{ "label": "Walk away",       "icon": "flee",   "sublabel": "Not worth the risk",   "action": "pass" },
		],
		"resolve_key": "trex_young_horn",
	},

	"trex_subadult_rival": {
		"id": "trex_subadult_rival",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 1,
		"max_stage": 2,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "Another young tyrannosaur tests you with posture, tail stiffness, and head movement.",
		"choices": [
			{ "label": "Hold your ground","icon": "attack", "sublabel": "Don't back down",      "action": "engage" },
			{ "label": "Back off",        "icon": "flee",   "sublabel": "Not worth a fight",    "action": "pass" },
		],
		"resolve_key": "trex_subadult_rival",
	},

	# ── ADULT ─────────────────────────────────────────────────────────────────

	"trex_crushing_bite": {
		"id": "trex_crushing_bite",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "A large prey animal presents a brief opening.",
		"choices": [
			{ "label": "Commit the bite", "icon": "attack", "sublabel": "Full force",           "action": "engage" },
			{ "label": "Wait",            "icon": "stalk",  "sublabel": "Watch for better",     "action": "pass" },
		],
		"resolve_key": "trex_crushing_bite",
	},

	"trex_trike_standoff": {
		"id": "trex_trike_standoff",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "A full-grown Triceratops faces you instead of running. Three horns, low head, and nowhere to circle.",
		"choices": [
			{ "label": "Commit",          "icon": "attack", "sublabel": "Force the issue",      "action": "engage" },
			{ "label": "Back off",        "icon": "flee",   "sublabel": "Read the odds",        "action": "pass" },
		],
		"resolve_key": "trex_trike_standoff",
	},

	"trex_edmonto_panic": {
		"id": "trex_edmonto_panic",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "A herd of Edmontosaurus erupts into motion. One animal falls behind the main body.",
		"choices": [
			{ "label": "Cut it off",      "icon": "attack", "sublabel": "Go for the straggler", "action": "engage" },
			{ "label": "Let it go",       "icon": "flee",   "sublabel": "Stampede risk",        "action": "pass" },
		],
		"resolve_key": "trex_edmonto_panic",
	},

	"trex_ankylo_warning": {
		"id": "trex_ankylo_warning",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "An Ankylosaurus swings its tail club slowly, watching you. It is not running.",
		"choices": [
			{ "label": "Press in",        "icon": "attack", "sublabel": "Force a mistake",      "action": "engage" },
			{ "label": "Walk away",       "icon": "flee",   "sublabel": "The math is wrong",    "action": "pass" },
		],
		"resolve_key": "trex_ankylo_warning",
	},

	"trex_waterhole_tyrant": {
		"id": "trex_waterhole_tyrant",
		"seasons": ["summer", "fall"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "A muddy water source draws herbivores, scavengers, and danger in equal measure.",
		"choices": [
			{ "label": "Move in",         "icon": "attack", "sublabel": "Take the waterhole",   "action": "engage" },
			{ "label": "Hang back",       "icon": "stalk",  "sublabel": "Watch for openings",   "action": "pass" },
		],
		"resolve_key": "trex_waterhole_tyrant",
	},

	"trex_scented_breeze": {
		"id": "trex_scented_breeze",
		"seasons": ["spring", "summer", "fall", "winter"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "You smell something dead far away. The wind is telling you something.",
		"choices": [
			{ "label": "Follow the scent","icon": "stalk",  "sublabel": "Track it down",        "action": "engage" },
			{ "label": "Stay put",        "icon": "rest",   "sublabel": "Could be nothing",     "action": "pass" },
		],
		"resolve_key": "trex_scented_breeze",
	},

	"trex_smaller_pred_scatter": {
		"id": "trex_smaller_pred_scatter",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "A medium predator abandons its feeding site the moment it sees you.",
		"choices": [
			{ "label": "Move in",         "icon": "attack", "sublabel": "Take the kill",        "action": "engage" },
			{ "label": "Leave it",        "icon": "flee",   "sublabel": "Not worth the time",   "action": "pass" },
		],
		"resolve_key": "trex_smaller_pred_scatter",
	},

	# ── WOUNDED ADULT ─────────────────────────────────────────────────────────

	"trex_broken_tooth": {
		"id": "trex_broken_tooth",
		"seasons": ["spring", "summer", "fall", "winter"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 2,
		"require_injured": true,
		"rarity": "common",
		"passive": false,
		"flavor": "A damaged tooth throbs when you bite down. You can work around it or make it worse.",
		"choices": [
			{ "label": "Work through it", "icon": "attack", "sublabel": "Bite down anyway",     "action": "engage" },
			{ "label": "Rest it",         "icon": "rest",   "sublabel": "Let it settle",        "action": "pass" },
		],
		"resolve_key": "trex_broken_tooth",
	},

	"trex_limp_floodplain": {
		"id": "trex_limp_floodplain",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 2,
		"require_injured": true,
		"rarity": "common",
		"passive": false,
		"flavor": "Your weight makes every bad step matter. The floodplain ahead is uneven.",
		"choices": [
			{ "label": "Cross carefully", "icon": "stalk",  "sublabel": "Watch every step",     "action": "engage" },
			{ "label": "Find another way","icon": "flee",   "sublabel": "Too much risk",        "action": "pass" },
		],
		"resolve_key": "trex_limp_floodplain",
	},

	"trex_blood_in_mud": {
		"id": "trex_blood_in_mud",
		"seasons": ["spring", "fall"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 2,
		"require_injured": true,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "Your injury leaves scent and blood where you pass. You are leaving a trail.",
		"choices": [
			{ "label": "Keep moving",     "icon": "stalk",  "sublabel": "Get clear of the area","action": "engage" },
			{ "label": "Go to ground",    "icon": "rest",   "sublabel": "Wait it out",          "action": "pass" },
		],
		"resolve_key": "trex_blood_in_mud",
	},

	"trex_fallen_giant_rest": {
		"id": "trex_fallen_giant_rest",
		"seasons": ["spring", "summer", "fall", "winter"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 2,
		"require_injured": true,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "A toppled tree or eroded bank offers cover. For a body your size, that is not nothing.",
		"choices": [
			{ "label": "Use the shelter", "icon": "rest",   "sublabel": "Rest here",            "action": "engage" },
			{ "label": "Keep moving",     "icon": "flee",   "sublabel": "Site is too exposed",  "action": "pass" },
		],
		"resolve_key": "trex_fallen_giant_rest",
	},

	"trex_hunger_vs_pain": {
		"id": "trex_hunger_vs_pain",
		"seasons": ["spring", "summer", "fall", "winter"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 2,
		"require_injured": true,
		"rarity": "common",
		"passive": false,
		"flavor": "You are hungry and still wounded. One of those things has to give.",
		"choices": [
			{ "label": "Hunt anyway",     "icon": "attack", "sublabel": "Push through the pain","action": "engage" },
			{ "label": "Rest first",      "icon": "rest",   "sublabel": "Let the wound settle", "action": "pass" },
		],
		"resolve_key": "trex_hunger_vs_pain",
	},

	# ── SOCIAL / RIVAL ────────────────────────────────────────────────────────

	"trex_sibling_dispute": {
		"id": "trex_sibling_dispute",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 1,
		"max_stage": 2,
		"rarity": "common",
		"passive": false,
		"flavor": "Another young tyrannosaur wants the same scrap of food.",
		"choices": [
			{ "label": "Hold it",         "icon": "attack", "sublabel": "Don't give ground",    "action": "engage" },
			{ "label": "Let it go",       "icon": "flee",   "sublabel": "Not worth a fight",    "action": "pass" },
		],
		"resolve_key": "trex_sibling_dispute",
	},

	"trex_shared_carcass": {
		"id": "trex_shared_carcass",
		"seasons": ["spring", "summer", "fall", "winter"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "Another T. rex feeds from a huge carcass. There may be room for both. Maybe.",
		"choices": [
			{ "label": "Move in",         "icon": "attack", "sublabel": "Claim your share",     "action": "engage" },
			{ "label": "Feed at the edge","icon": "stalk",  "sublabel": "Take no risks",        "action": "pass" },
		],
		"resolve_key": "trex_shared_carcass",
	},

	"trex_mating_rival": {
		"id": "trex_mating_rival",
		"seasons": ["spring"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "A rival adult challenges your presence during mating season.",
		"choices": [
			{ "label": "Stand your ground","icon": "attack","sublabel": "Don't yield",          "action": "engage" },
			{ "label": "Withdraw",         "icon": "flee",  "sublabel": "Not the time",         "action": "pass" },
		],
		"resolve_key": "trex_mating_rival",
	},

	"trex_passing_tolerance": {
		"id": "trex_passing_tolerance",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "Another T. rex crosses your range but does not immediately challenge you.",
		"choices": [
			{ "label": "Watch it pass",   "icon": "stalk",  "sublabel": "Let it go",            "action": "engage" },
			{ "label": "Challenge it",    "icon": "attack", "sublabel": "Assert your range",    "action": "pass" },
		],
		"resolve_key": "trex_passing_tolerance",
	},

	"trex_young_following": {
		"id": "trex_young_following",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "A smaller tyrannosaur shadows you at a distance, hoping for scraps.",
		"choices": [
			{ "label": "Allow it",        "icon": "rest",   "sublabel": "Let it trail behind",  "action": "engage" },
			{ "label": "Drive it off",    "icon": "attack", "sublabel": "You hunt alone",       "action": "pass" },
		],
		"resolve_key": "trex_young_following",
	},

	# ── SEASONAL ──────────────────────────────────────────────────────────────

	"trex_spring_nesting": {
		"id": "trex_spring_nesting",
		"seasons": ["spring"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "Eggs, hatchlings, and young herbivores appear more often. The season makes everything easy — and defensive.",
		"choices": [
			{ "label": "Move in",         "icon": "attack", "sublabel": "Easy targets",         "action": "engage" },
			{ "label": "Stay back",       "icon": "flee",   "sublabel": "Protective adults",    "action": "pass" },
		],
		"resolve_key": "trex_spring_nesting",
	},

	"trex_spring_floodplain": {
		"id": "trex_spring_floodplain",
		"seasons": ["spring"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "Wet season mud preserves scents and tracks perfectly. Everything that passed here left a record.",
		"choices": [
			{ "label": "Read the mud",    "icon": "stalk",  "sublabel": "Follow the trail",     "action": "engage" },
			{ "label": "Avoid the mud",   "icon": "flee",   "sublabel": "Weight is the problem","action": "pass" },
		],
		"resolve_key": "trex_spring_floodplain",
	},

	"trex_summer_heat": {
		"id": "trex_summer_heat",
		"seasons": ["summer"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "The day grows brutally hot. Everything still moving is slower than it wants to be.",
		"choices": [
			{ "label": "Hunt the heat",   "icon": "stalk",  "sublabel": "Prey moves poorly",    "action": "engage" },
			{ "label": "Wait it out",     "icon": "rest",   "sublabel": "Rest through the worst","action": "pass" },
		],
		"resolve_key": "trex_summer_heat",
	},

	"trex_summer_dry_crossing": {
		"id": "trex_summer_dry_crossing",
		"seasons": ["summer"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "Animals bunch up at river crossings and shrinking water. Everything comes to the same three places.",
		"choices": [
			{ "label": "Control the crossing","icon": "attack","sublabel": "Hold the position", "action": "engage" },
			{ "label": "Stay back",           "icon": "flee", "sublabel": "Too contested",      "action": "pass" },
		],
		"resolve_key": "trex_summer_dry_crossing",
	},

	"trex_fall_migration": {
		"id": "trex_fall_migration",
		"seasons": ["fall"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "Edmontosaurus and other herbivores move in larger numbers. The most food you will see all year.",
		"choices": [
			{ "label": "Follow the herds","icon": "stalk",  "sublabel": "Trail behind them",    "action": "engage" },
			{ "label": "Hold position",   "icon": "rest",   "sublabel": "Let them come to you", "action": "pass" },
		],
		"resolve_key": "trex_fall_migration",
	},

	"trex_fall_carcass_season": {
		"id": "trex_fall_carcass_season",
		"seasons": ["fall"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "Old, sick, or injured animals die during migration. The season does your hunting for you.",
		"choices": [
			{ "label": "Find a carcass",  "icon": "stalk",  "sublabel": "The season provides",  "action": "engage" },
			{ "label": "Hunt instead",    "icon": "attack", "sublabel": "Fresh is better",      "action": "pass" },
		],
		"resolve_key": "trex_fall_carcass_season",
	},

	"trex_winter_empty": {
		"id": "trex_winter_empty",
		"seasons": ["winter"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "Food becomes less reliable. The range is almost empty and the cold makes everything harder.",
		"choices": [
			{ "label": "Search anyway",   "icon": "stalk",  "sublabel": "Something is out there","action": "engage" },
			{ "label": "Conserve energy", "icon": "rest",   "sublabel": "Wait for conditions",  "action": "pass" },
		],
		"resolve_key": "trex_winter_empty",
	},

	# ── RARE ──────────────────────────────────────────────────────────────────

	"trex_trike_mistake": {
		"id": "trex_trike_mistake",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "rare",
		"passive": false,
		"flavor": "You committed too far. The Triceratops is faster than you read it and you are already inside its range.",
		"choices": [
			{ "label": "Push through",    "icon": "attack", "sublabel": "Finish what you started","action": "engage" },
			{ "label": "Pull back",       "icon": "flee",   "sublabel": "Get clear now",          "action": "pass" },
		],
		"resolve_key": "trex_trike_mistake",
	},

	"trex_ankylo_lesson": {
		"id": "trex_ankylo_lesson",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "rare",
		"passive": false,
		"flavor": "You underestimated the reach of the tail club. It is already moving.",
		"choices": [
			{ "label": "Try to dodge",    "icon": "flee",   "sublabel": "Get out of range",     "action": "engage" },
			{ "label": "Absorb it",       "icon": "rest",   "sublabel": "Take the hit and hold","action": "pass" },
		],
		"resolve_key": "trex_ankylo_lesson",
	},

	"trex_giant_carcass": {
		"id": "trex_giant_carcass",
		"seasons": ["spring", "summer", "fall", "winter"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "rare",
		"passive": false,
		"flavor": "A massive herbivore has died. The carcass is enormous and rivals are already converging.",
		"choices": [
			{ "label": "Claim it",        "icon": "attack", "sublabel": "Assert dominance",     "action": "engage" },
			{ "label": "Leave it",        "icon": "flee",   "sublabel": "Too many rivals",      "action": "pass" },
		],
		"resolve_key": "trex_giant_carcass",
	},

	"trex_thunder_lowlands": {
		"id": "trex_thunder_lowlands",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "rare",
		"passive": false,
		"flavor": "A storm masks sound, smell, and movement. Everything becomes different in the noise.",
		"choices": [
			{ "label": "Hunt the storm",  "icon": "stalk",  "sublabel": "Use the cover",        "action": "engage" },
			{ "label": "Shelter",         "icon": "rest",   "sublabel": "Wait it out",          "action": "pass" },
		],
		"resolve_key": "trex_thunder_lowlands",
	},

	"trex_old_king": {
		"id": "trex_old_king",
		"seasons": ["spring", "summer", "fall", "winter"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "rare",
		"passive": false,
		"flavor": "An ancient scarred rex appears on the edge of sight. Every scar on it has a story the land remembers.",
		"choices": [
			{ "label": "Observe it",      "icon": "stalk",  "sublabel": "Watch and learn",      "action": "engage" },
			{ "label": "Move away",       "icon": "flee",   "sublabel": "Don't get drawn in",   "action": "pass" },
		],
		"resolve_key": "trex_old_king",
	},

	"trex_echoing_roar": {
		"id": "trex_echoing_roar",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["predator"],
		"species": ["tyrannosaurus"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "rare",
		"passive": false,
		"flavor": "Your roar carries farther than expected. The open land takes the sound and spreads it everywhere.",
		"choices": [
			{ "label": "Let it carry",    "icon": "attack", "sublabel": "Announce yourself",    "action": "engage" },
			{ "label": "Stay quiet",      "icon": "stalk",  "sublabel": "No point in the risk", "action": "pass" },
		],
		"resolve_key": "trex_echoing_roar",
	},

}
