# Iguanodon encounter data — loaded by ActionResolver and EventsDB

const OUTCOME_EVENTS: Dictionary = {

	# ── JUVENILE ──────────────────────────────────────────────────────────────

	"igua_thumb_buds": {
		"pass_flavor": "You leave the bark alone. Your young thumb spikes are not ready for it yet.",
		"buff":    { "stat": "defense", "amount": 0.09, "turns": 3, "source": "spike_practice", "flavor": "Spike Practice: your body starts learning what those spikes are for." },
		"nothing": { "flavor": "You scrape bark and feel the resistance. Nothing gives." },
		"food":    { "hunger": 0.12, "flavor": "Scraping opens the bark enough to reach soft plant matter underneath." },
		"health":  { "health": 0.08, "flavor": "Stretching and practice leave your body looser than when you started." },
		"debuff":  { "stat": "defense", "amount": -0.08, "turns": 2, "source": "forelimb_strain", "flavor": "You stretch your forelimb too far. The strain makes it harder to use for a while." },
	},

	"igua_herd_shadow": {
		"pass_flavor": "You stay near the adults and let them handle it.",
		"buff":    { "stat": "defense", "amount": 0.11, "turns": 4, "source": "protected_young", "flavor": "Protected Young: the adults close around you, keeping danger outside the herd." },
		"nothing": { "flavor": "Whatever it was, it does not press the issue. The herd relaxes." },
		"food":    { "hunger": 0.14, "flavor": "The adults guide the young toward a safer grazing area." },
		"health":  { "health": 0.10, "flavor": "Inside the herd circle nothing finds you. You rest without watching." },
		"debuff":  { "stat": "defense", "amount": -0.09, "turns": 2, "source": "separated", "flavor": "Panic spreads before you can follow the adults. The moving herd cuts you off, leaving you exposed." },
	},

	"igua_soft_shoots": {
		"pass_flavor": "You move on. The best of it is already gone.",
		"buff":    { "stat": "type_stat", "amount": 0.10, "turns": 3, "source": "tender_grazer", "flavor": "Tender Grazer: you learn to seek out young shoots that sustain you longer than tough, dry plants." },
		"nothing": { "flavor": "The shoots are already stripped down to bare soil." },
		"food":    { "hunger": 0.16, "flavor": "Soft fresh plants with no resistance. Easy to eat quickly." },
		"health":  { "health": 0.09, "flavor": "Young growth is dense with what your body needs right now." },
		"debuff":  { "stat": "type_stat", "amount": -0.07, "turns": 2, "source": "sour_shoots", "flavor": "You swallow a few unfamiliar shoots. Soon, your stomach begins to churn." },
	},

	"igua_tail_signal": {
		"pass_flavor": "You watch and wait. Nothing comes of it.",
		"buff":    { "stat": "defense", "amount": 0.11, "turns": 3, "source": "herd_signal", "flavor": "Herd Signal: you read the tail-stiffen before the older ones even finish the motion." },
		"nothing": { "flavor": "False alarm. The herd settles and the signal never repeats." },
		"food":    { "hunger": 0.14, "flavor": "The herd moves toward better feeding ground and you move with it." },
		"health":  { "health": 0.09, "flavor": "You reach cover before whatever triggered the signal finds the herd." },
		"debuff":  { "stat": "speed", "amount": -0.09, "turns": 2, "source": "lagging_behind", "flavor": "You miss the signal and start moving too late. The herd is already ahead of you." },
	},

	"igua_learning_rear": {
		"pass_flavor": "You stay low. Not the right moment for that.",
		"buff":    { "stat": "defense", "amount": 0.10, "turns": 3, "source": "brace_stance", "flavor": "Brace Stance: you know how to distribute your weight now. Hard to knock down." },
		"nothing": { "flavor": "You wobble and drop back onto all fours. The attempt teaches you nothing yet." },
		"food":    { "hunger": 0.13, "flavor": "Standing higher puts leaves in reach that were not there a moment ago." },
		"health":  { "health": 0.09, "flavor": "The muscle practice leaves your body warmer and more ready." },
		"debuff":  { "health": -0.07, "flavor": "You go over sideways. Nothing is broken but something is bruised." },
	},

	# ── SUBADULT ──────────────────────────────────────────────────────────────

	"igua_brush_breaker": {
		"pass_flavor": "You go around. The shrubs are not worth forcing today.",
		"buff":    { "stat": "speed", "amount": 0.10, "turns": 3, "source": "brush_breaker", "flavor": "Brush Breaker: your weight is a tool. Dense plant growth is just slower ground now." },
		"nothing": { "flavor": "The brush is too thick to push through cleanly. You go around and lose time." },
		"food":    { "hunger": 0.15, "flavor": "The inside of the thicket has leaves and shoots untouched by anything that could not push through." },
		"health":  { "health": 0.09, "flavor": "The brush closes behind you. Nothing can see in from outside." },
		"debuff":  { "health": -0.07, "flavor": "The thorns catch your hide through most of the push." },
	},

	"igua_young_pred_test": {
		"pass_flavor": "You hold your position and watch it leave.",
		"buff":    { "stat": "defense", "amount": 0.11, "turns": 3, "source": "predator_read", "flavor": "Predator Read: you can tell a testing approach from a committed one now." },
		"nothing": { "flavor": "It circles once, reads your reaction, and moves on to something easier." },
		"food":    { "hunger": 0.13, "flavor": "Its movement pushes edible plants out of the undergrowth ahead of it." },
		"health":  { "health": 0.09, "flavor": "You stay calm. No wasted energy, no injury. Your body stays intact." },
		"debuff":  { "health": -0.10, "flavor": "It gets close enough to test before retreating. It leaves a mark." },
	},

	"igua_spike_warning": {
		"pass_flavor": "You hold the pose without committing. It reads the signal.",
		"buff":    { "stat": "strength", "amount": 0.11, "turns": 3, "source": "spike_threat", "flavor": "Spike Threat: smaller predators know what those spikes mean. Your body language does the work." },
		"nothing": { "flavor": "It backs away slowly without being convinced. You hold until it is gone." },
		"food":    { "hunger": 0.13, "flavor": "It abandons a food source when it backs away from you." },
		"health":  { "health": 0.09, "flavor": "You avoid the fight entirely. The energy you save becomes recovery." },
		"debuff":  { "health": -0.10, "flavor": "You raise the forelimb too late. The bite lands before your spike finds the right angle." },
	},

	"igua_riverbank_graze": {
		"pass_flavor": "The bank is picked over. You move on.",
		"buff":    { "stat": "type_stat", "amount": 0.11, "turns": 3, "source": "river_grazer", "flavor": "River Grazer: you know which plants grow thick near water and where to find them." },
		"nothing": { "flavor": "The bank is clean. Whoever was here before you did a thorough job." },
		"food":    { "hunger": 0.20, "flavor": "Lush river plants with real moisture in them. You eat steadily." },
		"health":  { "health": 0.11, "flavor": "Fresh water and good plants. Your body uses both." },
		"debuff":  { "stat": "speed", "amount": -0.10, "turns": 2, "source": "mud_trap", "flavor": "The riverbank mud takes your foot and does not give it back easily." },
	},

	"igua_deep_trackway": {
		"pass_flavor": "The trail is too old to be useful. You find your own route.",
		"buff":    { "stat": "speed", "amount": 0.10, "turns": 3, "source": "route_memory", "flavor": "Route Memory: you know where the herd went and why. That knowledge stays." },
		"nothing": { "flavor": "The prints have softened too much. The trail tells you nothing actionable." },
		"food":    { "hunger": 0.15, "flavor": "The herd trackway leads straight to a grazing area they found earlier." },
		"health":  { "health": 0.09, "flavor": "The trail ends at a sheltered rest site. You use it." },
		"debuff":  { "health": -0.10, "flavor": "Something else is following the same trail from the other direction." },
	},

	# ── ADULT ─────────────────────────────────────────────────────────────────

	"igua_herd_edge": {
		"pass_flavor": "You drift toward the center. Let someone else take the edge today.",
		"buff":    { "stat": "defense", "amount": 0.12, "turns": 4, "source": "edge_watcher", "flavor": "Edge Watcher: you know every angle from this position. Nothing approaches without you reading it first." },
		"nothing": { "flavor": "The day stays quiet. The edge stays uneventful." },
		"food":    { "hunger": 0.16, "flavor": "Watching the outside puts you next to plants the interior grazers miss." },
		"health":  { "health": 0.11, "flavor": "Standing guard earns its own kind of rest. The herd eats and so do you." },
		"debuff":  { "health": -0.12, "flavor": "The first probe comes your direction. You are where danger arrives first." },
	},

	"igua_thumb_spike_clash": {
		"pass_flavor": "You turn your body, raise the forelimb, and hold. It does not commit.",
		"w_buff": 0.14,
		"w_debuff": 0.16,
		"buff":    { "stat": "defense", "amount": 0.14, "turns": 4, "source": "spike_jab", "flavor": "Spike Jab: the predator learned what your forelimb is for. So did you." },
		"nothing": { "flavor": "Your posture changes the calculation before anything lands." },
		"food":    { "hunger": 0.18, "flavor": "It retreats and leaves the feeding ground open." },
		"health":  { "health": 0.12, "flavor": "Winning without fleeing costs nothing. Your stamina stays intact." },
		"debuff":  { "health": -0.14, "flavor": "It reaches your forelimb before the spike finds a clean angle." },
	},

	"igua_high_branch": {
		"pass_flavor": "The branches are too tough. Not worth the effort.",
		"buff":    { "stat": "type_stat", "amount": 0.11, "turns": 3, "source": "tall_browser", "flavor": "Tall Browser: you know where the better leaves hang and how to reach them." },
		"nothing": { "flavor": "The branches are too stiff. You cannot strip anything useful." },
		"food":    { "hunger": 0.18, "flavor": "The leaves up here are richer than what the lower grazers can reach." },
		"health":  { "health": 0.11, "flavor": "High-quality browsing leaves your body running well." },
		"debuff":  { "stat": "speed", "amount": -0.09, "turns": 2, "source": "mud_trap", "flavor": "You overbalance reaching for the branch. The recovery twist goes wrong." },
	},

	"igua_herd_wall": {
		"pass_flavor": "The herd holds and the predators do not test it.",
		"buff":    { "stat": "defense", "amount": 0.13, "turns": 4, "source": "defensive_line", "flavor": "Defensive Line: this many bodies, this many spikes, all facing the same direction. It works." },
		"nothing": { "flavor": "The predators circle once and decide against it. The herd holds without breaking." },
		"food":    { "hunger": 0.16, "flavor": "Once they leave, the herd moves to a fresh grazing patch safely." },
		"health":  { "health": 0.12, "flavor": "Group safety is genuine safety. You rest and your body uses it." },
		"debuff":  { "health": -0.13, "flavor": "The line breaks in the panic. In the confusion you take a hit meant for the formation." },
	},

	"igua_push_through": {
		"pass_flavor": "The herd changes path. Easier than forcing it.",
		"buff":    { "stat": "strength", "amount": 0.12, "turns": 3, "source": "heavy_push", "flavor": "Heavy Push: your weight is not a liability here. The obstacle is." },
		"nothing": { "flavor": "The herd finds another route. The obstacle stays where it is." },
		"food":    { "hunger": 0.16, "flavor": "The push exposes untouched plants that nothing else could reach through the blockage." },
		"health":  { "health": 0.10, "flavor": "The path beyond the obstruction opens into a clear, safe space." },
		"debuff":  { "health": -0.08, "flavor": "The shoulder takes the wrong angle on the push." },
	},

	# ── WOUNDED ADULT ─────────────────────────────────────────────────────────

	"igua_sore_forelimb": {
		"pass_flavor": "You favor the limb. Do not ask it to do what it cannot.",
		"buff":    { "stat": "defense", "amount": 0.10, "turns": 3, "source": "careful_guard", "flavor": "Careful Guard: you know how to position your body to protect the bad arm." },
		"nothing": { "flavor": "You favor the limb and continue. It aches but does not worsen." },
		"food":    { "hunger": 0.14, "flavor": "Low plants within reach. You do not need the forelimb to graze." },
		"health":  { "health": 0.11, "flavor": "Resting the arm reduces the ache enough to matter." },
		"debuff":  { "stat": "defense", "amount": -0.10, "turns": 3, "source": "forelimb_strain", "flavor": "The forelimb takes a load it was not ready for. The spike defense is compromised." },
	},

	"igua_limp_herd": {
		"pass_flavor": "You keep moving. The herd does not wait.",
		"buff":    { "stat": "speed", "amount": 0.09, "turns": 3, "source": "steady_pace", "flavor": "Steady Pace: you find the rhythm that keeps you with the herd without punishing the leg." },
		"nothing": { "flavor": "You keep up barely. The herd moves and so do you." },
		"food":    { "hunger": 0.16, "flavor": "The herd slows near a grazing patch. You eat while you can." },
		"health":  { "health": 0.11, "flavor": "The herd's protection buys you real healing time even while moving." },
		"debuff":  { "stat": "defense", "amount": -0.10, "turns": 2, "source": "lagging_behind", "flavor": "You fall behind and the herd's protection no longer covers you." },
	},

	"igua_mud_pack": {
		"pass_flavor": "You leave the wound as it is. The mud is not worth the risk.",
		"buff":    { "stat": "defense", "amount": 0.10, "turns": 3, "source": "mud_cover", "flavor": "Mud Cover: the wound is sealed from scent. Whatever was following the blood loses the trail." },
		"nothing": { "flavor": "The mud dries quickly and flakes away. It helped for a moment and then stopped." },
		"food":    { "hunger": 0.14, "flavor": "River plants grow near where you treated the wound." },
		"health":  { "health": 0.12, "flavor": "Cool mud draws the heat from the injury. The improvement is real." },
		"debuff":  { "stat": "type_stat", "amount": -0.08, "turns": 2, "source": "sour_shoots", "flavor": "The mud was not as clean as it looked. The wound is angrier than before." },
	},

	"igua_tall_ferns": {
		"pass_flavor": "The ferns move too much in the wind. No use today.",
		"buff":    { "stat": "type_stat", "amount": 0.11, "turns": 3, "source": "broken_silhouette", "flavor": "Broken Silhouette: in the ferns your outline is wrong. Something hunting you by shape loses you." },
		"nothing": { "flavor": "The ferns sway too visibly. You wait for the wind to stop and it does not." },
		"food":    { "hunger": 0.14, "flavor": "Fern shoots are edible and there are many of them within reach." },
		"health":  { "health": 0.12, "flavor": "Covered from above and sides. Your body uses the genuine quiet." },
		"debuff":  { "stat": "type_stat", "amount": -0.08, "turns": 2, "source": "sour_shoots", "flavor": "Hidden insects find the wound while you are still. The healing cost rises." },
	},

	# ── HERD / GROUP ──────────────────────────────────────────────────────────

	"igua_many_eyes": {
		"pass_flavor": "You drift to the edge and watch independently.",
		"buff":    { "stat": "defense", "amount": 0.12, "turns": 4, "source": "many_eyes", "flavor": "Many Eyes: this many animals watching this many directions. Nothing gets close without being seen." },
		"nothing": { "flavor": "The herd feeds quietly. Nothing disturbs it." },
		"food":    { "hunger": 0.16, "flavor": "The herd's spread uncovers good plants across the whole feeding ground." },
		"health":  { "health": 0.11, "flavor": "Real group safety. You sleep deeply and your body makes use of it." },
		"debuff":  { "stat": "type_stat", "amount": -0.08, "turns": 2, "source": "sour_shoots", "flavor": "Competition at the best patches pushes you to the edge of what is worth eating." },
	},

	"igua_young_center": {
		"pass_flavor": "You stay where you are. Let others take the outside positions.",
		"buff":    { "stat": "defense", "amount": 0.12, "turns": 4, "source": "protective_instinct", "flavor": "Protective Instinct: you know when to close ranks and where to place yourself to make it count." },
		"nothing": { "flavor": "No threat appears. The young remain in the center and nothing tests the formation." },
		"food":    { "hunger": 0.15, "flavor": "The herd reaches a safe feeding area and the young eat well." },
		"health":  { "health": 0.11, "flavor": "Social safety at its most effective. Rest that actually restores." },
		"debuff":  { "health": -0.10, "flavor": "Positioning yourself near the young puts you in line when the probe comes." },
	},

	"igua_dominance_shove": {
		"pass_flavor": "You yield. The feeding spot is not worth injury.",
		"buff":    { "stat": "strength", "amount": 0.11, "turns": 3, "source": "shoulder_check", "flavor": "Shoulder Check: you know how to use your mass in these encounters." },
		"nothing": { "flavor": "You step aside without making it a contest. The other adult moves on." },
		"food":    { "hunger": 0.17, "flavor": "You hold the spot and eat well from it." },
		"health":  { "health": 0.10, "flavor": "You find another patch rather than spend energy on a shove." },
		"debuff":  { "health": -0.09, "flavor": "The shove catches you wrong or the social stress bleeds into your stamina." },
	},

	"igua_warning_stamp": {
		"pass_flavor": "You listen and wait. Nothing confirms the signal.",
		"buff":    { "stat": "defense", "amount": 0.12, "turns": 3, "source": "stamp_alert", "flavor": "Stamp Alert: when the ground speaks that way, you are already moving before you decide to." },
		"nothing": { "flavor": "False alarm. The herd settles and the stamp does not repeat." },
		"food":    { "hunger": 0.14, "flavor": "The herd moves toward safer grazing and the plants there are untouched." },
		"health":  { "health": 0.10, "flavor": "You reach cover ahead of whatever triggered the warning." },
		"debuff":  { "stat": "type_stat", "amount": -0.08, "turns": 2, "source": "sour_shoots", "flavor": "The panic burns energy that you cannot get back quickly." },
	},

	"igua_herd_split": {
		"pass_flavor": "You watch both groups leave and follow the nearer one.",
		"buff":    { "stat": "speed", "amount": 0.11, "turns": 3, "source": "path_judge", "flavor": "Path Judge: you know how to read which route has the better outcome without having walked it yet." },
		"nothing": { "flavor": "Both groups move slowly. The choice does not matter much today." },
		"food":    { "hunger": 0.18, "flavor": "The food-rich path was the right call. You eat well." },
		"health":  { "health": 0.12, "flavor": "The safe path ends at a sheltered spot with water. You rest fully." },
		"debuff":  { "health": -0.11, "flavor": "The path you chose turns out to be the one with the predator waiting along it." },
	},

	# ── SEASONAL ──────────────────────────────────────────────────────────────

	"igua_spring_fern": {
		"pass_flavor": "Other herbivores have already taken the best of it.",
		"buff":    { "stat": "type_stat", "amount": 0.12, "turns": 4, "source": "fern_feast", "flavor": "Fern Feast: the fresh ferns sustain you better than the dry plants you have been eating." },
		"nothing": { "flavor": "The other grazers have been through already. You find what they left." },
		"food":    { "hunger": 0.20, "flavor": "Full, fresh fern beds with no competition. You eat until you are satisfied." },
		"health":  { "health": 0.12, "flavor": "Spring growth is dense with what the lean season took from you." },
		"debuff":  { "stat": "type_stat", "amount": -0.08, "turns": 2, "source": "sour_shoots", "flavor": "Some of the new growth is wrong. Spring toxic plants look exactly like the safe ones." },
	},

	"igua_spring_nesting": {
		"pass_flavor": "No safe site today. The herd keeps moving.",
		"buff":    { "stat": "defense", "amount": 0.12, "turns": 4, "source": "nest_defender", "flavor": "Nest Defender: when the herd settles around young, you know where to be." },
		"nothing": { "flavor": "No suitable site is found. The herd continues without settling." },
		"food":    { "hunger": 0.16, "flavor": "The search passes through a good plant area. You eat while looking." },
		"health":  { "health": 0.12, "flavor": "A safe nesting ground is also a safe resting ground. You use it fully." },
		"debuff":  { "health": -0.11, "flavor": "Predators follow a nesting herd. The grouping that should help becomes a target." },
	},

	"igua_summer_dry_browse": {
		"pass_flavor": "You conserve energy. The dry shrubs are not worth pushing through.",
		"buff":    { "stat": "type_stat", "amount": 0.10, "turns": 3, "source": "tough_browser", "flavor": "Tough Browser: you know how to process the dry stuff now. Less hunger for the same amount of work." },
		"nothing": { "flavor": "You eat slowly and gain little. The plants are past their point of real nutrition." },
		"food":    { "hunger": 0.15, "flavor": "Edible shrubs in the tougher growth. Not the best, but real food." },
		"health":  { "health": 0.10, "flavor": "Shade browsing without exertion. Your body holds steady." },
		"debuff":  { "stat": "type_stat", "amount": -0.09, "turns": 2, "source": "sour_shoots", "flavor": "Dry plants give less energy than they cost to digest in this heat." },
	},

	"igua_summer_waterhole": {
		"pass_flavor": "You drink carefully and leave before anything commits.",
		"buff":    { "stat": "defense", "amount": 0.12, "turns": 3, "source": "waterhole_watch", "flavor": "Waterhole Watch: you know what the bank looks like when something is waiting in the grass nearby." },
		"nothing": { "flavor": "You drink and leave without incident. The water does what it needs to." },
		"food":    { "hunger": 0.16, "flavor": "Moist plants grow along the edge where the water has not fully retreated." },
		"health":  { "health": 0.12, "flavor": "Water and shade. Your body runs better for both." },
		"debuff":  { "health": -0.13, "flavor": "The ambush comes from the grass or the panic from the herd catches you wrong." },
	},

	"igua_fall_root_season": {
		"pass_flavor": "The ground is too hard. You leave the roots where they are.",
		"buff":    { "stat": "type_stat", "amount": 0.11, "turns": 4, "source": "root_puller", "flavor": "Root Puller: you know which ground gives and where the roots come up clean." },
		"nothing": { "flavor": "The ground does not give. You move on without eating." },
		"food":    { "hunger": 0.18, "flavor": "Roots and seeds pulled from loosened earth. Dense, energy-rich food." },
		"health":  { "health": 0.11, "flavor": "High-energy fall food. Your body stores what the lean season will take back." },
		"debuff":  { "stat": "defense", "amount": -0.09, "turns": 2, "source": "forelimb_strain", "flavor": "The digging puts load on the forelimbs that accumulates wrong." },
	},

	"igua_fall_migration": {
		"pass_flavor": "The herd delays. You wait with it.",
		"buff":    { "stat": "speed", "amount": 0.11, "turns": 4, "source": "migration_memory", "flavor": "Migration Memory: you have been this route before, or something in you knows it. Movement comes easier." },
		"nothing": { "flavor": "The herd delays the move. The migration begins but slowly." },
		"food":    { "hunger": 0.17, "flavor": "New plant patches appear along the route that no one has grazed yet." },
		"health":  { "health": 0.11, "flavor": "The route leads to water and protection. You arrive in better shape than you left." },
		"debuff":  { "stat": "speed", "amount": -0.10, "turns": 2, "source": "lagging_behind", "flavor": "Long migration across hard terrain drains what the season has not restored yet." },
	},

	"igua_winter_stems": {
		"pass_flavor": "You eat as little as possible and conserve the rest.",
		"buff":    { "stat": "type_stat", "amount": 0.10, "turns": 4, "source": "hard_chewer", "flavor": "Hard Chewer: you have learned to process fibrous material with less waste." },
		"nothing": { "flavor": "You eat slowly and gain little. The woody stems give almost nothing back." },
		"food":    { "hunger": 0.14, "flavor": "You find enough tough stems to take the edge off the hunger." },
		"health":  { "health": 0.09, "flavor": "Slow, steady feeding keeps your body from sliding further." },
		"debuff":  { "stat": "type_stat", "amount": -0.09, "turns": 3, "source": "sour_shoots", "flavor": "Poor diet compounds. Stamina recovery slows." },
	},

	"igua_winter_herd_rest": {
		"pass_flavor": "You stay at the edge of the group. Crowding is its own risk.",
		"buff":    { "stat": "defense", "amount": 0.12, "turns": 4, "source": "herd_warmth", "flavor": "Herd Warmth: the cold matters less with this many bodies generating heat in the same space." },
		"nothing": { "flavor": "The night passes without incident. Cold but intact." },
		"food":    { "hunger": 0.14, "flavor": "Morning reveals plants the herd's movement uncovered." },
		"health":  { "health": 0.13, "flavor": "Group rest in cold conditions restores more than resting alone." },
		"debuff":  { "stat": "type_stat", "amount": -0.08, "turns": 2, "source": "sour_shoots", "flavor": "Crowding this long in one place brings its own problems. Something spreads." },
	},

	# ── RARE ──────────────────────────────────────────────────────────────────

	"igua_thumb_spike_save": {
		"pass_flavor": "The predator breaks off before you have to test it.",
		"w_buff": 0.14,
		"w_health": 0.20,
		"buff":    { "stat": "defense", "amount": 0.15, "turns": 0, "source": "spike_veteran", "perm": true, "perm_label": "Spike Veteran", "flavor": "Spike Veteran: the spike found the right angle at the right moment. Your body will not forget that." },
		"nothing": { "flavor": "The predator breaks off before contact. You hold the spike raised for longer than necessary." },
		"food":    { "hunger": 0.18, "flavor": "It leaves the feeding area entirely. You graze without competition." },
		"health":  { "health": 0.14, "flavor": "You survive without a scratch. The encounter leaves you sharpened, not damaged." },
		"debuff":  { "health": -0.18, "flavor": "The spike lands but so does the bite. You wound it and it wounds you." },
	},

	"igua_broken_herd": {
		"pass_flavor": "You find the nearest cover and wait for the herd to regroup.",
		"w_debuff": 0.18,
		"w_nothing": 0.25,
		"buff":    { "stat": "speed", "amount": 0.13, "turns": 4, "source": "calm_in_panic", "flavor": "Calm in Panic: when the herd breaks, you know which direction to go and you go without hesitation." },
		"nothing": { "flavor": "The herd regroups faster than expected. The panic was brief and survivable." },
		"food":    { "hunger": 0.15, "flavor": "You stumble through untouched plants in the confusion." },
		"health":  { "health": 0.11, "flavor": "You find a hollow and wait until the danger passes." },
		"debuff":  { "health": -0.16, "flavor": "Separated in a broken herd with a predator still active nearby. The math is not in your favor." },
	},

	"igua_sauro_trail": {
		"pass_flavor": "The trail is too disturbed to be useful. You leave it.",
		"buff":    { "stat": "speed", "amount": 0.13, "turns": 5, "source": "giant_trail", "flavor": "Giant Trail: where something that large has walked, smaller things find easier passage." },
		"nothing": { "flavor": "The trail leads nowhere useful. The clearing ends before your destination." },
		"food":    { "hunger": 0.22, "flavor": "Exposed leaves, crushed roots, and broken branches. A giant's path leaves food everywhere." },
		"health":  { "health": 0.13, "flavor": "Predators do not hunt near where a sauropod herd recently walked." },
		"debuff":  { "health": -0.12, "flavor": "The giant trail attracts the kinds of predators that follow giant prey. You are here instead." },
	},

	"igua_old_bull_route": {
		"pass_flavor": "You lose the old one in the brush before you can follow.",
		"buff":    { "stat": "speed", "amount": 0.12, "turns": 5, "source": "elder_route", "flavor": "Elder Route: the old one has walked this land long enough that its path is the right path." },
		"nothing": { "flavor": "You lose it in dense brush. The route remains unknown." },
		"food":    { "hunger": 0.20, "flavor": "The route ends at a feeding ground that nothing has found yet this season." },
		"health":  { "health": 0.14, "flavor": "The route leads to a sheltered hollow with water. You rest and recover." },
		"debuff":  { "stat": "speed", "amount": -0.11, "turns": 2, "source": "lagging_behind", "flavor": "The route is long and the old one moves faster than it looks. You arrive exhausted." },
	},

	"igua_pred_learns_respect": {
		"pass_flavor": "It circles and moves on before you finish assessing it.",
		"w_buff": 0.14,
		"w_nothing": 0.30,
		"buff":    { "stat": "defense", "amount": 0.14, "turns": 5, "source": "respected_herd", "flavor": "Respected Herd: the predator has marked your herd as a calculation that does not favor its side." },
		"nothing": { "flavor": "It disappears into cover. You never know if it made a decision or just moved on." },
		"food":    { "hunger": 0.17, "flavor": "The herd feeds calmly once it is gone. You eat with your full attention on the plants." },
		"health":  { "health": 0.13, "flavor": "No threat, no stress. The rest afterward is deep." },
		"debuff":  { "health": -0.14, "flavor": "Respect is learned. The predator comes back at a better time with a better angle." },
	},

}


const EVENTS: Dictionary = {

	# ── JUVENILE ──────────────────────────────────────────────────────────────

	"igua_thumb_buds": {
		"id": "igua_thumb_buds",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"max_stage": 1,
		"rarity": "common",
		"passive": false,
		"flavor": "Your thumb spikes are still small, but you scrape them against bark instinctively.",
		"choices": [
			{ "label": "Keep scraping",   "icon": "attack", "sublabel": "Practice the motion",  "action": "engage" },
			{ "label": "Leave it",        "icon": "flee",   "sublabel": "Not worth the strain", "action": "pass" },
		],
		"resolve_key": "igua_thumb_buds",
	},

	"igua_herd_shadow": {
		"id": "igua_herd_shadow",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"max_stage": 1,
		"rarity": "common",
		"passive": false,
		"flavor": "Adult Iguanodons gather around the young as something moves nearby.",
		"choices": [
			{ "label": "Stay close",      "icon": "rest",   "sublabel": "Use the protection",   "action": "engage" },
			{ "label": "Move to center",  "icon": "stalk",  "sublabel": "Get deeper into herd", "action": "pass" },
		],
		"resolve_key": "igua_herd_shadow",
	},

	"igua_soft_shoots": {
		"id": "igua_soft_shoots",
		"seasons": ["spring", "summer"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"max_stage": 1,
		"rarity": "common",
		"passive": false,
		"flavor": "Fresh shoots poke through trampled ground.",
		"choices": [
			{ "label": "Graze here",      "icon": "rest",   "sublabel": "Eat the new growth",   "action": "engage" },
			{ "label": "Move on",         "icon": "flee",   "sublabel": "Better patches ahead",  "action": "pass" },
		],
		"resolve_key": "igua_soft_shoots",
	},

	"igua_tail_signal": {
		"id": "igua_tail_signal",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"max_stage": 1,
		"rarity": "common",
		"passive": false,
		"flavor": "An older herd member stiffens its tail and stops chewing.",
		"choices": [
			{ "label": "React to it",     "icon": "flee",   "sublabel": "Trust the signal",     "action": "engage" },
			{ "label": "Keep grazing",    "icon": "rest",   "sublabel": "Could be nothing",     "action": "pass" },
		],
		"resolve_key": "igua_tail_signal",
	},

	"igua_learning_rear": {
		"id": "igua_learning_rear",
		"seasons": ["spring", "summer"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"max_stage": 1,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "You lift your chest and balance back briefly, testing your weight.",
		"choices": [
			{ "label": "Hold the pose",   "icon": "attack", "sublabel": "Practice the stance",  "action": "engage" },
			{ "label": "Stay down",       "icon": "rest",   "sublabel": "Too risky yet",        "action": "pass" },
		],
		"resolve_key": "igua_learning_rear",
	},

	# ── SUBADULT ──────────────────────────────────────────────────────────────

	"igua_brush_breaker": {
		"id": "igua_brush_breaker",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 1,
		"max_stage": 2,
		"rarity": "common",
		"passive": false,
		"flavor": "Dense shrubs block the herd path.",
		"choices": [
			{ "label": "Push through",    "icon": "attack", "sublabel": "Use your weight",      "action": "engage" },
			{ "label": "Go around",       "icon": "flee",   "sublabel": "Safer but slower",     "action": "pass" },
		],
		"resolve_key": "igua_brush_breaker",
	},

	"igua_young_pred_test": {
		"id": "igua_young_pred_test",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 1,
		"max_stage": 2,
		"rarity": "common",
		"passive": false,
		"flavor": "A medium predator stalks near the herd edge, testing your reaction.",
		"choices": [
			{ "label": "Stand your ground","icon": "attack","sublabel": "Don't show weakness",  "action": "engage" },
			{ "label": "Drift inward",    "icon": "flee",   "sublabel": "Move toward the herd", "action": "pass" },
		],
		"resolve_key": "igua_young_pred_test",
	},

	"igua_spike_warning": {
		"id": "igua_spike_warning",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 1,
		"max_stage": 2,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "A smaller predator gets too close. You turn your body and raise your forelimb.",
		"choices": [
			{ "label": "Hold the stance", "icon": "attack", "sublabel": "Make it read the spike","action": "engage" },
			{ "label": "Back toward herd","icon": "flee",   "sublabel": "Don't commit alone",   "action": "pass" },
		],
		"resolve_key": "igua_spike_warning",
	},

	"igua_riverbank_graze": {
		"id": "igua_riverbank_graze",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 1,
		"max_stage": 2,
		"rarity": "common",
		"passive": false,
		"flavor": "Rich plants grow along a muddy riverbank.",
		"choices": [
			{ "label": "Graze the bank",  "icon": "rest",   "sublabel": "Rich food near water", "action": "engage" },
			{ "label": "Stay on firm ground","icon": "flee", "sublabel": "Mud risk",            "action": "pass" },
		],
		"resolve_key": "igua_riverbank_graze",
	},

	"igua_deep_trackway": {
		"id": "igua_deep_trackway",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 1,
		"max_stage": 2,
		"rarity": "common",
		"passive": false,
		"flavor": "Large footprints show where the herd passed earlier.",
		"choices": [
			{ "label": "Follow the prints","icon": "stalk", "sublabel": "Trust the route",      "action": "engage" },
			{ "label": "Find your own way","icon": "flee",  "sublabel": "Trail could attract predators","action": "pass" },
		],
		"resolve_key": "igua_deep_trackway",
	},

	# ── ADULT ─────────────────────────────────────────────────────────────────

	"igua_herd_edge": {
		"id": "igua_herd_edge",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "You find yourself walking on the outer edge of the herd.",
		"choices": [
			{ "label": "Hold the edge",   "icon": "attack", "sublabel": "Watch the perimeter",  "action": "engage" },
			{ "label": "Drift inward",    "icon": "flee",   "sublabel": "Let someone else guard","action": "pass" },
		],
		"resolve_key": "igua_herd_edge",
	},

	"igua_thumb_spike_clash": {
		"id": "igua_thumb_spike_clash",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "A predator lunges too close. Your thumb spike becomes the difference between escape and injury.",
		"choices": [
			{ "label": "Spike it",        "icon": "attack", "sublabel": "Make the strike count","action": "engage" },
			{ "label": "Turn and flee",   "icon": "flee",   "sublabel": "Don't stand and fight","action": "pass" },
		],
		"resolve_key": "igua_thumb_spike_clash",
	},

	"igua_high_branch": {
		"id": "igua_high_branch",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "A cluster of leaves hangs just above easy reach.",
		"choices": [
			{ "label": "Reach for it",    "icon": "attack", "sublabel": "Worth the stretch",    "action": "engage" },
			{ "label": "Leave it",        "icon": "flee",   "sublabel": "Not worth the balance risk","action": "pass" },
		],
		"resolve_key": "igua_high_branch",
	},

	"igua_herd_wall": {
		"id": "igua_herd_wall",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "Predators approach, and the herd tightens into a defensive line.",
		"choices": [
			{ "label": "Hold the line",   "icon": "attack", "sublabel": "Stand with the herd",  "action": "engage" },
			{ "label": "Find an opening", "icon": "flee",   "sublabel": "Get the young clear",  "action": "pass" },
		],
		"resolve_key": "igua_herd_wall",
	},

	"igua_push_through": {
		"id": "igua_push_through",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "A fallen tree or thick growth blocks the path.",
		"choices": [
			{ "label": "Push through",    "icon": "attack", "sublabel": "Force the obstacle",   "action": "engage" },
			{ "label": "Find another way","icon": "flee",   "sublabel": "Go around",            "action": "pass" },
		],
		"resolve_key": "igua_push_through",
	},

	# ── WOUNDED ADULT ─────────────────────────────────────────────────────────

	"igua_sore_forelimb": {
		"id": "igua_sore_forelimb",
		"seasons": ["spring", "summer", "fall", "winter"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 2,
		"require_injured": true,
		"rarity": "common",
		"passive": false,
		"flavor": "Your defensive forelimb aches after a previous clash.",
		"choices": [
			{ "label": "Work through it", "icon": "attack", "sublabel": "Push past the ache",   "action": "engage" },
			{ "label": "Rest the limb",   "icon": "rest",   "sublabel": "Let it settle",        "action": "pass" },
		],
		"resolve_key": "igua_sore_forelimb",
	},

	"igua_limp_herd": {
		"id": "igua_limp_herd",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 2,
		"require_injured": true,
		"rarity": "common",
		"passive": false,
		"flavor": "The herd keeps moving, but your leg slows you down.",
		"choices": [
			{ "label": "Keep up",         "icon": "stalk",  "sublabel": "Don't fall behind",    "action": "engage" },
			{ "label": "Find a rest spot","icon": "rest",   "sublabel": "Wait and rejoin later","action": "pass" },
		],
		"resolve_key": "igua_limp_herd",
	},

	"igua_mud_pack": {
		"id": "igua_mud_pack",
		"seasons": ["spring", "fall"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 2,
		"require_injured": true,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "Wet mud can cool and cover your wound, but it may also irritate it.",
		"choices": [
			{ "label": "Apply the mud",   "icon": "rest",   "sublabel": "Seal the wound",       "action": "engage" },
			{ "label": "Leave it alone",  "icon": "flee",   "sublabel": "Risk of infection",    "action": "pass" },
		],
		"resolve_key": "igua_mud_pack",
	},

	"igua_tall_ferns": {
		"id": "igua_tall_ferns",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 2,
		"require_injured": true,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "You are too large to disappear fully, but tall ferns break up your outline.",
		"choices": [
			{ "label": "Rest in the ferns","icon": "rest",  "sublabel": "Break your silhouette","action": "engage" },
			{ "label": "Keep moving",     "icon": "flee",   "sublabel": "Ferns attract insects","action": "pass" },
		],
		"resolve_key": "igua_tall_ferns",
	},

	# ── HERD / GROUP ──────────────────────────────────────────────────────────

	"igua_many_eyes": {
		"id": "igua_many_eyes",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "The herd spreads across a feeding ground, watching in every direction.",
		"choices": [
			{ "label": "Join the spread",  "icon": "rest",  "sublabel": "Safety in numbers",    "action": "engage" },
			{ "label": "Feed separately",  "icon": "flee",  "sublabel": "Less competition",     "action": "pass" },
		],
		"resolve_key": "igua_many_eyes",
	},

	"igua_young_center": {
		"id": "igua_young_center",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "The herd moves the smallest members into the middle.",
		"choices": [
			{ "label": "Guard the flank", "icon": "attack", "sublabel": "Protect the formation","action": "engage" },
			{ "label": "Stay central",    "icon": "rest",   "sublabel": "Let others guard",     "action": "pass" },
		],
		"resolve_key": "igua_young_center",
	},

	"igua_dominance_shove": {
		"id": "igua_dominance_shove",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "Another adult pushes you away from a prime feeding spot.",
		"choices": [
			{ "label": "Push back",       "icon": "attack", "sublabel": "Hold your ground",     "action": "engage" },
			{ "label": "Yield",           "icon": "flee",   "sublabel": "Not worth injury",     "action": "pass" },
		],
		"resolve_key": "igua_dominance_shove",
	},

	"igua_warning_stamp": {
		"id": "igua_warning_stamp",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "An adult stomps hard, signaling danger.",
		"choices": [
			{ "label": "React immediately","icon": "flee",  "sublabel": "Trust the stamp",      "action": "engage" },
			{ "label": "Wait and confirm","icon": "rest",   "sublabel": "Could be false alarm", "action": "pass" },
		],
		"resolve_key": "igua_warning_stamp",
	},

	"igua_herd_split": {
		"id": "igua_herd_split",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "The herd divides: one path is safer, the other has better food.",
		"choices": [
			{ "label": "Follow the food",  "icon": "rest",  "sublabel": "Hunger is real",       "action": "engage" },
			{ "label": "Follow the safe path","icon": "flee","sublabel": "Safety over food",    "action": "pass" },
		],
		"resolve_key": "igua_herd_split",
	},

	# ── SEASONAL ──────────────────────────────────────────────────────────────

	"igua_spring_fern": {
		"id": "igua_spring_fern",
		"seasons": ["spring"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "Fresh ferns and shoots fill the lowlands.",
		"choices": [
			{ "label": "Graze heavily",   "icon": "rest",   "sublabel": "Make the most of it",  "action": "engage" },
			{ "label": "Eat carefully",   "icon": "stalk",  "sublabel": "Watch for toxic plants","action": "pass" },
		],
		"resolve_key": "igua_spring_fern",
	},

	"igua_spring_nesting": {
		"id": "igua_spring_nesting",
		"seasons": ["spring"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "The herd searches for safer nesting and resting grounds.",
		"choices": [
			{ "label": "Join the search", "icon": "stalk",  "sublabel": "Find a safe site",     "action": "engage" },
			{ "label": "Stay in place",   "icon": "rest",   "sublabel": "Risk the current site","action": "pass" },
		],
		"resolve_key": "igua_spring_nesting",
	},

	"igua_summer_dry_browse": {
		"id": "igua_summer_dry_browse",
		"seasons": ["summer"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "Low plants are dry, but tougher shrubs remain.",
		"choices": [
			{ "label": "Eat the shrubs",  "icon": "rest",   "sublabel": "Tough food is still food","action": "engage" },
			{ "label": "Wait for better", "icon": "flee",   "sublabel": "Conserve energy",      "action": "pass" },
		],
		"resolve_key": "igua_summer_dry_browse",
	},

	"igua_summer_waterhole": {
		"id": "igua_summer_waterhole",
		"seasons": ["summer"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "Many animals gather at shrinking water.",
		"choices": [
			{ "label": "Drink carefully", "icon": "stalk",  "sublabel": "Watch the grass",      "action": "engage" },
			{ "label": "Come back later", "icon": "flee",   "sublabel": "Too crowded",          "action": "pass" },
		],
		"resolve_key": "igua_summer_waterhole",
	},

	"igua_fall_root_season": {
		"id": "igua_fall_root_season",
		"seasons": ["fall"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "Plants toughen, but roots and seeds become more useful.",
		"choices": [
			{ "label": "Dig for roots",   "icon": "attack", "sublabel": "Use the forelimbs",    "action": "engage" },
			{ "label": "Browse instead",  "icon": "rest",   "sublabel": "Protect the forelimbs","action": "pass" },
		],
		"resolve_key": "igua_fall_root_season",
	},

	"igua_fall_migration": {
		"id": "igua_fall_migration",
		"seasons": ["fall"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "The herd begins moving toward better feeding grounds.",
		"choices": [
			{ "label": "Move with herd",  "icon": "stalk",  "sublabel": "Follow the route",     "action": "engage" },
			{ "label": "Stay behind",     "icon": "rest",   "sublabel": "Conserve energy",      "action": "pass" },
		],
		"resolve_key": "igua_fall_migration",
	},

	"igua_winter_stems": {
		"id": "igua_winter_stems",
		"seasons": ["winter"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "Only woody, fibrous plants remain.",
		"choices": [
			{ "label": "Chew through it", "icon": "rest",   "sublabel": "Something is better than nothing","action": "engage" },
			{ "label": "Keep searching",  "icon": "flee",   "sublabel": "Find anything better", "action": "pass" },
		],
		"resolve_key": "igua_winter_stems",
	},

	"igua_winter_herd_rest": {
		"id": "igua_winter_herd_rest",
		"seasons": ["winter"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "The herd bunches together during cold nights.",
		"choices": [
			{ "label": "Press in close",  "icon": "rest",   "sublabel": "Share the warmth",     "action": "engage" },
			{ "label": "Stay at the edge","icon": "flee",   "sublabel": "Less risk of sickness","action": "pass" },
		],
		"resolve_key": "igua_winter_herd_rest",
	},

	# ── RARE ──────────────────────────────────────────────────────────────────

	"igua_thumb_spike_save": {
		"id": "igua_thumb_spike_save",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "rare",
		"passive": false,
		"flavor": "A predator commits too close, and your spike lands perfectly.",
		"choices": [
			{ "label": "Drive the spike", "icon": "attack", "sublabel": "Commit the strike",    "action": "engage" },
			{ "label": "Turn and run",    "icon": "flee",   "sublabel": "Don't stand and fight","action": "pass" },
		],
		"resolve_key": "igua_thumb_spike_save",
	},

	"igua_broken_herd": {
		"id": "igua_broken_herd",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "rare",
		"passive": false,
		"flavor": "A predator attack scatters the herd in every direction.",
		"choices": [
			{ "label": "Move decisively", "icon": "flee",   "sublabel": "Pick a direction and go","action": "engage" },
			{ "label": "Find cover fast", "icon": "stalk",  "sublabel": "Get small and hidden", "action": "pass" },
		],
		"resolve_key": "igua_broken_herd",
	},

	"igua_sauro_trail": {
		"id": "igua_sauro_trail",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "rare",
		"passive": false,
		"flavor": "A sauropod herd has cleared a path through thick growth.",
		"choices": [
			{ "label": "Follow the trail","icon": "stalk",  "sublabel": "Use the giant's work", "action": "engage" },
			{ "label": "Avoid it",        "icon": "flee",   "sublabel": "Giants attract hunters","action": "pass" },
		],
		"resolve_key": "igua_sauro_trail",
	},

	"igua_old_bull_route": {
		"id": "igua_old_bull_route",
		"seasons": ["spring", "summer", "fall", "winter"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "rare",
		"passive": false,
		"flavor": "An old scarred Iguanodon follows a route only elders seem to know.",
		"choices": [
			{ "label": "Follow it",       "icon": "stalk",  "sublabel": "Trust the elder",      "action": "engage" },
			{ "label": "Go your own way", "icon": "flee",   "sublabel": "Long routes cost energy","action": "pass" },
		],
		"resolve_key": "igua_old_bull_route",
	},

	"igua_pred_learns_respect": {
		"id": "igua_pred_learns_respect",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["iguanodon"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "rare",
		"passive": false,
		"flavor": "A predator circles, remembers your herd, and chooses easier prey.",
		"choices": [
			{ "label": "Hold the line",   "icon": "attack", "sublabel": "Make the calculation clear","action": "engage" },
			{ "label": "Move away",       "icon": "flee",   "sublabel": "Let it leave",         "action": "pass" },
		],
		"resolve_key": "igua_pred_learns_respect",
	},

}
