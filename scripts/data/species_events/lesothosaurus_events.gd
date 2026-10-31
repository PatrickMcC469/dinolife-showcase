# Lesothosaurus encounter data — loaded by ActionResolver and EventsDB

const OUTCOME_EVENTS: Dictionary = {

	# ── JUVENILE ──────────────────────────────────────────────────────────────

	"leso_first_scatter": {
		"pass_flavor": "You freeze and wait. Whatever it was, it passes.",
		"buff":    { "stat": "speed", "amount": 0.11, "turns": 3, "source": "scatter_reflex", "flavor": "Scatter Reflex: your body decides before you do." },
		"nothing": { "flavor": "It was only a passing cloud. The shadow moves on and the world goes quiet again." },
		"food":    { "hunger": 0.12, "flavor": "You sprint into a patch of tender shoots and eat while your heart slows." },
		"health":  { "health": 0.08, "flavor": "You reach a hollow under a root and stay still until everything feels right again." },
		"debuff":  { "stat": "speed", "amount": -0.08, "turns": 2, "source": "panic_trip", "flavor": "You go down on the third stride. Your legs tangle and you hit the ground wrong." },
	},

	"leso_green_shoots": {
		"pass_flavor": "You leave the patch behind, hoping to find better feeding nearby.",
		"buff":    { "stat": "type_stat", "amount": 0.10, "turns": 3, "source": "fresh_grazer", "flavor": "Fresh Grazer: you learn which young shoots offer more nourishment than the dry growth." },
		"nothing": { "flavor": "The shoots are already eaten down to the soil. Something else found this first." },
		"food":    { "hunger": 0.16, "flavor": "Soft new plants with no resistance. You eat well." },
		"health":  { "health": 0.08, "flavor": "You feed on tender new growth. The nourishing meal helps you recover." },
		"debuff":  { "stat": "type_stat", "amount": -0.07, "turns": 2, "source": "sour_stomach", "flavor": "Some of the new growth does not agree with you. Your stomach makes itself known." },
	},

	"leso_ant_trail": {
		"pass_flavor": "You leave the insects to their work.",
		"buff":    { "stat": "type_stat", "amount": 0.10, "turns": 3, "source": "sharp_forager", "flavor": "Sharp Forager: small signs in the soil begin to tell you where to look for food." },
		"nothing": { "flavor": "The ants vanish underground at the first vibration. Whatever they were tracking is gone." },
		"food":    { "hunger": 0.12, "flavor": "The seed pod has split and the contents are still good." },
		"health":  { "health": 0.07, "flavor": "An easy meal restores your strength without a tiring search." },
		"debuff":  { "stat": "speed", "amount": -0.07, "turns": 2, "source": "bitten_feet", "flavor": "The ants do not appreciate your curiosity. Your feet sting for a while." },
	},

	"leso_fern_arch": {
		"pass_flavor": "The shelter is too exposed. You move on.",
		"buff":    { "stat": "defense", "amount": 0.10, "turns": 3, "source": "tiny_cover", "flavor": "Tiny Cover: you learn to hide your small outline among the low plants." },
		"nothing": { "flavor": "The fern looks good from outside but the angle is wrong. Too visible." },
		"food":    { "hunger": 0.12, "flavor": "The underside of the arch is full of soft leaves and small edible growth." },
		"health":  { "health": 0.09, "flavor": "You hide and stay still. No threats find you. Your body uses the quiet." },
		"debuff":  { "health": -0.08, "flavor": "Something small and fast is already in the arch. It comes out faster than you expected." },
	},

	"leso_big_feet": {
		"pass_flavor": "You hold still and let the herd pass. Better than guessing.",
		"buff":    { "stat": "defense", "amount": 0.09, "turns": 3, "source": "footfall_sense", "flavor": "Footfall Sense: you can read the ground vibrations now. You know which way the weight is moving." },
		"nothing": { "flavor": "The herd passes without incident. The ground shakes and then it does not." },
		"food":    { "hunger": 0.14, "flavor": "Their passing stirs up seeds and roots you would not have found otherwise." },
		"health":  { "health": 0.08, "flavor": "Predators do not come near. You rest in the shadow of something much larger." },
		"debuff":  { "health": -0.09, "flavor": "You do not move fast enough. A foot comes down close enough that you feel it." },
	},

	# ── SUBADULT ──────────────────────────────────────────────────────────────

	"leso_open_sprint": {
		"pass_flavor": "You decide to wait. The open ground stays open.",
		"buff":    { "stat": "speed", "amount": 0.11, "turns": 3, "source": "open_ground_dash", "flavor": "Open-Ground Dash: you know how to commit now. Your body finds the pace and holds it." },
		"nothing": { "flavor": "You wait and decide against it. The cover is not worth the risk today." },
		"food":    { "hunger": 0.14, "flavor": "The grazing on the other side is worth the crossing." },
		"health":  { "health": 0.09, "flavor": "You reach shade on the far side and your body settles." },
		"debuff":  { "stat": "speed", "amount": -0.10, "turns": 2, "source": "fearful", "flavor": "Halfway across, something moves at the edge of the ground. You finish the sprint wrong." },
	},

	"leso_pebble_slope": {
		"pass_flavor": "You go around. The slope is not worth testing today.",
		"buff":    { "stat": "speed", "amount": 0.10, "turns": 3, "source": "sure_footed", "flavor": "Sure-Footed: rough ground does not read the same to you now. You know where to place your weight." },
		"nothing": { "flavor": "You look at the slope and leave it. The time cost is not worth it." },
		"food":    { "hunger": 0.13, "flavor": "Plants grow between the rocks where nothing else can reach them." },
		"health":  { "health": 0.08, "flavor": "There is a safe ledge partway up. You rest above the ground and nothing finds you." },
		"debuff":  { "stat": "speed", "amount": -0.10, "turns": 2, "source": "leg_strain", "flavor": "A stone slides under your foot. Your leg takes the wrong angle on the way down." },
	},

	"leso_bitter_leaves": {
		"pass_flavor": "You refuse to eat them. Your instincts say no.",
		"buff":    { "stat": "defense", "amount": 0.09, "turns": 4, "source": "bitter_tolerance", "flavor": "Bitter Tolerance: you know which plants bite back now." },
		"nothing": { "flavor": "You smell them and back away. Not every plant is food." },
		"food":    { "hunger": 0.12, "flavor": "You manage to eat enough. It is not pleasant but it reduces hunger." },
		"health":  { "health": 0.07, "flavor": "Some of the bitterness carries something useful in it." },
		"debuff":  { "stat": "type_stat", "amount": -0.08, "turns": 2, "source": "sour_stomach", "flavor": "The bitter compounds do not suit you. Your digestion makes that clear." },
	},

	"leso_warning_chirp": {
		"pass_flavor": "You hold still and listen. Nothing follows the call.",
		"buff":    { "stat": "defense", "amount": 0.11, "turns": 3, "source": "warning_call", "flavor": "Warning Call: when the next alarm sounds you are already moving." },
		"nothing": { "flavor": "False alarm. The brush settles and the caller goes quiet." },
		"food":    { "hunger": 0.13, "flavor": "The call draws you toward others and the patch they were feeding in." },
		"health":  { "health": 0.09, "flavor": "You react correctly and reach cover before anything arrives." },
		"debuff":  { "stat": "speed", "amount": -0.09, "turns": 2, "source": "fearful", "flavor": "You misread the direction and run across open ground instead of into cover." },
	},

	"leso_dry_streambed": {
		"pass_flavor": "The path leads nowhere useful. You leave it.",
		"buff":    { "stat": "speed", "amount": 0.10, "turns": 3, "source": "streambed_runner", "flavor": "Streambed Runner: the gully keeps you below the sightline. You know how to use it." },
		"nothing": { "flavor": "The streambed loops back on itself. You waste time and gain nothing." },
		"food":    { "hunger": 0.14, "flavor": "The damp soil at the base still holds roots and seeds." },
		"health":  { "health": 0.08, "flavor": "A shallow pocket of collected water. Your body needed that." },
		"debuff":  { "health": -0.09, "flavor": "Something else uses this route. You round a bend and it is already there." },
	},

	# ── ADULT ─────────────────────────────────────────────────────────────────

	"leso_loose_herd": {
		"pass_flavor": "The group moves off. You continue alone.",
		"buff":    { "stat": "defense", "amount": 0.12, "turns": 4, "source": "many_eyes", "flavor": "Many Eyes: with this many watching different directions, nothing approaches without being seen first." },
		"nothing": { "flavor": "The group scatters before you integrate. You are alone again." },
		"food":    { "hunger": 0.16, "flavor": "The group is moving toward a grazing patch. You follow." },
		"health":  { "health": 0.10, "flavor": "Shared watchfulness means genuine rest. Your body uses it." },
		"debuff":  { "stat": "type_stat", "amount": -0.08, "turns": 2, "source": "sour_stomach", "flavor": "The competition at the grazing patch leaves you with scraps or pushed to the edge." },
	},

	"leso_brush_maze": {
		"pass_flavor": "Too tangled. You find another way around.",
		"buff":    { "stat": "speed", "amount": 0.12, "turns": 3, "source": "brush_runner", "flavor": "Brush Runner: dense plant cover is yours now. Nothing big can follow you into it." },
		"nothing": { "flavor": "The brush closes in after two body lengths. Impossible to navigate." },
		"food":    { "hunger": 0.14, "flavor": "The interior has untouched leaves and seeds that nothing larger can reach." },
		"health":  { "health": 0.10, "flavor": "The brush walls block anything looking for you. You rest in genuine quiet." },
		"debuff":  { "health": -0.06, "flavor": "The thorns catch you repeatedly. Your sides sting." },
	},

	"leso_seed_drop": {
		"pass_flavor": "The seeds are scattered too far. Not worth the exposure.",
		"buff":    { "stat": "type_stat", "amount": 0.11, "turns": 3, "source": "seed_finder", "flavor": "Seed Finder: you know where the dry pods crack and when." },
		"nothing": { "flavor": "Birds or insects got here before you. Nothing edible remains." },
		"food":    { "hunger": 0.16, "flavor": "Scattered seeds across sun-baked ground. You work through them quickly." },
		"health":  { "health": 0.09, "flavor": "High-energy seeds. Your body runs better for the rest of the day." },
		"debuff":  { "stat": "type_stat", "amount": -0.07, "turns": 2, "source": "sour_stomach", "flavor": "Some seeds are too hard or too old. Your digestion registers its disagreement." },
	},

	"leso_predator_grass": {
		"pass_flavor": "You do not wait to confirm what you heard. You move.",
		"w_debuff": 0.18,
		"w_nothing": 0.25,
		"w_buff": 0.10,
		"buff":    { "stat": "speed", "amount": 0.12, "turns": 3, "source": "early_spook", "flavor": "Early Spook: you read the wrong grass movement before it becomes the right one." },
		"nothing": { "flavor": "The sound fades. Whatever was there has gone or was never there." },
		"food":    { "hunger": 0.12, "flavor": "Your sprint flushes insects and seeds from the grass ahead of you." },
		"health":  { "health": 0.09, "flavor": "You reach a hollow before anything commits to the chase." },
		"debuff":  { "health": -0.14, "flavor": "Something nips you before you get clear. Fast and low and very deliberate." },
	},

	"leso_sun_baked_rest": {
		"pass_flavor": "The stone is too exposed. You find cover instead.",
		"buff":    { "stat": "speed", "amount": 0.10, "turns": 3, "source": "warm_muscles", "flavor": "Warm Muscles: the heat works into your legs. Your next movement is faster than usual." },
		"nothing": { "flavor": "The stone is inviting but too visible. You rest nearby in shade instead." },
		"food":    { "hunger": 0.10, "flavor": "Small plants grow in the cracks at the stone's edge." },
		"health":  { "health": 0.11, "flavor": "The stored warmth works through you. You wake up ready." },
		"debuff":  { "stat": "type_stat", "amount": -0.09, "turns": 2, "source": "heat_exhaustion", "flavor": "You stay too long. The heat takes more than the warmth gave." },
	},

	# ── WOUNDED ADULT ─────────────────────────────────────────────────────────

	"leso_limping_cover": {
		"pass_flavor": "You stay where you are. Moving now costs too much.",
		"buff":    { "stat": "speed", "amount": 0.09, "turns": 3, "source": "careful_steps", "flavor": "Careful Steps: you find the path that does not demand what your leg cannot give." },
		"nothing": { "flavor": "You move slowly and reach the next cover without incident. Slow, but safe." },
		"food":    { "hunger": 0.13, "flavor": "Edible plants within reach. You do not have to travel far." },
		"health":  { "health": 0.11, "flavor": "The brush hides you well enough for real rest. Your body uses it." },
		"debuff":  { "stat": "speed", "amount": -0.11, "turns": 3, "source": "leg_strain", "flavor": "The leg takes a bad step through the cover. Whatever was healing is not anymore." },
	},

	"leso_parasite_patch": {
		"pass_flavor": "You keep moving. Do not give them a chance to settle.",
		"buff":    { "stat": "defense", "amount": 0.09, "turns": 4, "source": "grooming_habit", "flavor": "Grooming Habit: you know how to keep this from becoming a problem." },
		"nothing": { "flavor": "You shake them off and move. They do not follow far." },
		"food":    { "hunger": 0.11, "flavor": "You stop to groom and find scattered seeds while standing still." },
		"health":  { "health": 0.09, "flavor": "Grooming cleans the wound better than leaving it alone would have." },
		"debuff":  { "stat": "type_stat", "amount": -0.09, "turns": 3, "source": "parasites", "flavor": "The insects settle into the wound. Healing from this point will take longer." },
	},

	"leso_root_pocket": {
		"pass_flavor": "The hollow is occupied. You back away quietly.",
		"buff":    { "stat": "defense", "amount": 0.11, "turns": 4, "source": "root_shelter", "flavor": "Root Shelter: cover this good while wounded is worth every step it took to find." },
		"nothing": { "flavor": "Something else is already using the hollow. You look for another option." },
		"food":    { "hunger": 0.15, "flavor": "Roots and soft shoots inside the hollow. You eat without moving." },
		"health":  { "health": 0.13, "flavor": "You settle into quiet cover, hidden from passing eyes. Safe enough to relax, you recover some strength." },
		"debuff":  { "health": -0.12, "flavor": "Something lunges from inside before you see it. You back out fast and worse than before." },
	},

	"leso_blood_scent_breeze": {
		"pass_flavor": "You go still and wait. The wind carries your scent and there is nothing you can do about that.",
		"buff":    { "stat": "type_stat", "amount": 0.11, "turns": 3, "source": "wind_sense", "flavor": "Wind Sense: you know which way the air is moving now. You use it." },
		"nothing": { "flavor": "Nothing picks up the scent. You move again when the wind shifts." },
		"food":    { "hunger": 0.13, "flavor": "Following the wind takes you toward fresher plants and away from the danger." },
		"health":  { "health": 0.10, "flavor": "You find water. Cleaning the wound makes the scent trail less of a problem." },
		"debuff":  { "health": -0.12, "flavor": "Something has been following the smell. It comes from downwind and you do not hear it in time." },
	},

	# ── HERD / GROUP ──────────────────────────────────────────────────────────

	"leso_scatter_line": {
		"pass_flavor": "The group drifts away before you settle into it.",
		"buff":    { "stat": "defense", "amount": 0.11, "turns": 3, "source": "scatter_formation", "flavor": "Scatter Formation: when something comes, everyone goes a different direction. Predators cannot track all of them." },
		"nothing": { "flavor": "The group moves off before the event resolves. You are alone again." },
		"food":    { "hunger": 0.15, "flavor": "The spread-out feeding uncovers more edible ground than you would find alone." },
		"health":  { "health": 0.09, "flavor": "Shared watching means you can actually rest. You do." },
		"debuff":  { "stat": "speed", "amount": -0.09, "turns": 2, "source": "fearful", "flavor": "The panic scatters everyone including you. You run the wrong direction and end up too far out." },
	},

	"leso_follow_fast_one": {
		"pass_flavor": "It disappears into brush before you can follow.",
		"buff":    { "stat": "speed", "amount": 0.10, "turns": 3, "source": "learned_route", "flavor": "Learned Route: it knew something you did not. Now you know it too." },
		"nothing": { "flavor": "It moves too fast. You lose it after two turns and navigate alone." },
		"food":    { "hunger": 0.15, "flavor": "The route leads straight to a dense seed patch. It knew exactly where it was going." },
		"health":  { "health": 0.10, "flavor": "The destination is a sheltered spot well away from anything that hunts." },
		"debuff":  { "stat": "speed", "amount": -0.09, "turns": 2, "source": "fearful", "flavor": "It bolts for no reason you can read. Your panic response fires anyway and you run too far." },
	},

	"leso_alarm_chorus": {
		"pass_flavor": "You wait. The calls settle and nothing comes.",
		"buff":    { "stat": "defense", "amount": 0.12, "turns": 3, "source": "alarm_chorus", "flavor": "Alarm Chorus: when every voice says the same thing at once, you do not wait to confirm it." },
		"nothing": { "flavor": "The calls drop off one by one. Whatever triggered them did not follow through." },
		"food":    { "hunger": 0.14, "flavor": "The group moves toward safer ground and there is better grazing there." },
		"health":  { "health": 0.10, "flavor": "The alarm moves everyone away from the danger zone. You rest where nothing is looking." },
		"debuff":  { "stat": "type_stat", "amount": -0.08, "turns": 2, "source": "heat_exhaustion", "flavor": "The mass panic costs more energy than the original threat would have." },
	},

	"leso_crowded_grazing": {
		"pass_flavor": "Not worth fighting over. You find another patch.",
		"buff":    { "stat": "type_stat", "amount": 0.10, "turns": 3, "source": "quick_nibbler", "flavor": "Quick Nibbler: crowded conditions teach you to eat fast and move before the competition catches up." },
		"nothing": { "flavor": "Too many bodies at the same patch. You get pushed to the edge and find nothing." },
		"food":    { "hunger": 0.16, "flavor": "You move fast and eat before the crowd strips the best of it." },
		"health":  { "health": 0.09, "flavor": "Easy food in good company. Your body gets what it needed." },
		"debuff":  { "health": -0.07, "flavor": "A shove or a snap from another. The competition becomes physical briefly." },
	},

	"leso_lost_from_group": {
		"pass_flavor": "You stay still and wait. Eventually you regroup.",
		"buff":    { "stat": "speed", "amount": 0.11, "turns": 3, "source": "solo_skitter", "flavor": "Solo Skitter: alone you move differently. Faster, lower, without the noise of others." },
		"nothing": { "flavor": "You wait and eventually rejoin. Nothing found you while you were separated." },
		"food":    { "hunger": 0.14, "flavor": "Alone and quiet, you find untouched plants that the group would have passed over." },
		"health":  { "health": 0.09, "flavor": "You find a small hidden spot and stay until the others regroup near you." },
		"debuff":  { "stat": "defense", "amount": -0.10, "turns": 2, "source": "exposed_grazer", "flavor": "Without other eyes, the next threat finds you before you find it." },
	},

	# ── SEASONAL ──────────────────────────────────────────────────────────────

	"leso_spring_green_flush": {
		"pass_flavor": "The larger grazers have already stripped the best of it.",
		"buff":    { "stat": "type_stat", "amount": 0.12, "turns": 4, "source": "fresh_growth_boost", "flavor": "Fresh Growth Boost: new spring growth gives more than it costs to eat. Your body stores the extra." },
		"nothing": { "flavor": "The largest grazers found the flush before you. What remains is already trodden." },
		"food":    { "hunger": 0.18, "flavor": "Tender young growth that has not been touched yet. You eat well." },
		"health":  { "health": 0.12, "flavor": "Nutritious new growth is exactly what your body needed after the dry season." },
		"debuff":  { "stat": "type_stat", "amount": -0.08, "turns": 2, "source": "sour_stomach", "flavor": "Some of the new growth is toxic. Spring brings the wrong plants alongside the right ones." },
	},

	"leso_spring_mud_prints": {
		"pass_flavor": "The rain washes everything away before you can read it.",
		"buff":    { "stat": "type_stat", "amount": 0.11, "turns": 3, "source": "print_reader", "flavor": "Print Reader: the ground tells you what came through and roughly when. You use that." },
		"nothing": { "flavor": "Too much rain. Every print is washed into the same formless mud." },
		"food":    { "hunger": 0.14, "flavor": "Herbivore tracks lead you straight to where they were feeding." },
		"health":  { "health": 0.09, "flavor": "A muddy pool holds clean water. You drink and your body rights itself." },
		"debuff":  { "stat": "speed", "amount": -0.09, "turns": 2, "source": "fearful", "flavor": "The mud grabs your feet differently than dry ground. You lose time on every stride." },
	},

	"leso_summer_dry_grass": {
		"pass_flavor": "You conserve energy. Dry food is not worth fighting for.",
		"buff":    { "stat": "type_stat", "amount": 0.10, "turns": 4, "source": "dry_grazer", "flavor": "Dry Grazer: you know how to extract enough from the tough stuff. The hunger does not hit as hard." },
		"nothing": { "flavor": "You eat slowly and carefully but gain little. The plants are past their point." },
		"food":    { "hunger": 0.13, "flavor": "A hidden green patch where something collects water underneath. Worth the search." },
		"health":  { "health": 0.10, "flavor": "Shade and stillness. You stop trying to find food and your body catches up." },
		"debuff":  { "stat": "type_stat", "amount": -0.09, "turns": 2, "source": "sour_stomach", "flavor": "The dry plants give less than you spent finding them. Hunger and fatigue compound." },
	},

	"leso_summer_heat_shimmer": {
		"pass_flavor": "You wait in shade. The heat makes everything uncertain.",
		"buff":    { "stat": "type_stat", "amount": 0.11, "turns": 3, "source": "heat_caution", "flavor": "Heat Caution: the shimmer makes distance unreliable. You know how to adjust." },
		"nothing": { "flavor": "You wait in shade until the worst of it passes. Nothing moves in this heat." },
		"food":    { "hunger": 0.13, "flavor": "Heat-wilted seed pods split and drop their contents into the open." },
		"health":  { "health": 0.10, "flavor": "Shade and stillness. The heat passes and you are no worse for it." },
		"debuff":  { "stat": "speed", "amount": -0.10, "turns": 2, "source": "heat_exhaustion", "flavor": "The heat takes your legs. You move slower than the predators count on." },
	},

	"leso_fall_seed_season": {
		"pass_flavor": "The seeds are scattered too widely. Not worth the exposure.",
		"buff":    { "stat": "type_stat", "amount": 0.11, "turns": 4, "source": "seed_fat", "flavor": "Seed Fat: high-energy food when the season is still giving it. Your body makes use of the extra." },
		"nothing": { "flavor": "The seeds are too scattered to make a meal of. You move on." },
		"food":    { "hunger": 0.18, "flavor": "A concentrated drop from a large dry plant. Dense and easy." },
		"health":  { "health": 0.11, "flavor": "Extra calories at the right time. You carry it into the next lean stretch." },
		"debuff":  { "stat": "type_stat", "amount": -0.08, "turns": 2, "source": "sour_stomach", "flavor": "The grit from dry seed cases does not go down well." },
	},

	"leso_fall_moving_herds": {
		"pass_flavor": "The trail is too trampled. You find your own way.",
		"buff":    { "stat": "defense", "amount": 0.11, "turns": 4, "source": "giant_path_follower", "flavor": "Giant Path Follower: large animals leave a trail that smaller predators avoid. You use the wake." },
		"nothing": { "flavor": "The herd trail is churned beyond use. You cannot read anything from it." },
		"food":    { "hunger": 0.15, "flavor": "The passing herd has exposed roots and turned up buried plant matter." },
		"health":  { "health": 0.10, "flavor": "Predators keep their distance from the herd corridor. You rest without watching." },
		"debuff":  { "health": -0.09, "flavor": "The herd is moving faster than it looks. You misjudge the gap and end up too close to the edge." },
	},

	"leso_winter_hidden_roots": {
		"pass_flavor": "The ground is too hard. You cannot get to anything below the surface.",
		"buff":    { "stat": "type_stat", "amount": 0.12, "turns": 4, "source": "root_finder", "flavor": "Root Finder: you know where underground food survives when the surface has nothing." },
		"nothing": { "flavor": "The ground does not give. You move on with nothing to show for the effort." },
		"food":    { "hunger": 0.16, "flavor": "The roots give slowly but they give. You eat below ground level where the frost has not reached." },
		"health":  { "health": 0.10, "flavor": "Root matter restores slowly but steadily. Better than nothing by a large margin." },
		"debuff":  { "stat": "defense", "amount": -0.10, "turns": 2, "source": "exposed_grazer", "flavor": "Digging keeps your head down and your focus narrow. You do not see what approaches until it is close." },
	},

	"leso_winter_cold_dawn": {
		"pass_flavor": "You stay still until the sun does more of the work.",
		"buff":    { "stat": "speed", "amount": 0.10, "turns": 3, "source": "warm_up_routine", "flavor": "Warm-Up Routine: you know how to find the warmth before committing to movement." },
		"nothing": { "flavor": "You wait and the cold eventually loosens. The day costs you time but nothing else." },
		"food":    { "hunger": 0.13, "flavor": "Plants near sun-warmed rocks stay greener longer. You find them." },
		"health":  { "health": 0.11, "flavor": "Basking in early sun works into your muscles. Your body is ready when you finally move." },
		"debuff":  { "stat": "speed", "amount": -0.11, "turns": 2, "source": "cold_stiffness", "flavor": "Your legs do not cooperate. The cold morning makes escape options much worse than usual." },
	},

	# ── RARE ──────────────────────────────────────────────────────────────────

	"leso_perfect_hide": {
		"pass_flavor": "You leave before committing to it. The ground near here does not feel right.",
		"w_buff": 0.14,
		"w_health": 0.22,
		"buff":    { "stat": "defense", "amount": 0.14, "turns": 5, "source": "tiny_refuge", "flavor": "Tiny Refuge: the gap between those roots is the exact right size. Nothing that hunts you can follow." },
		"nothing": { "flavor": "You leave before using it. The space was there but the moment felt wrong." },
		"food":    { "hunger": 0.15, "flavor": "Edible roots line the inside of the hollow. You eat while hidden." },
		"health":  { "health": 0.18, "flavor": "Genuine safety. Nothing finds you here. Your body makes full use of the quiet." },
		"debuff":  { "stat": "speed", "amount": -0.09, "turns": 2, "source": "fearful", "flavor": "The space is tighter than it looked. You get stuck briefly and lose more than you gained." },
	},

	"leso_false_safe_meadow": {
		"pass_flavor": "Something about the openness is wrong. You do not go in.",
		"w_debuff": 0.20,
		"w_nothing": 0.25,
		"w_buff": 0.09,
		"buff":    { "stat": "type_stat", "amount": 0.13, "turns": 4, "source": "suspicious_grazer", "flavor": "Suspicious Grazer: you read the too-good places now. The obvious patches are never just obvious." },
		"nothing": { "flavor": "You stay at the edge and then back away. The meadow stays peaceful and you never know why." },
		"food":    { "hunger": 0.17, "flavor": "You graze quickly at the edge and pull back before anything commits to the open." },
		"health":  { "health": 0.10, "flavor": "The rich food restores you and you leave before anything happens." },
		"debuff":  { "health": -0.18, "flavor": "The patch was exactly what it looked like: a place where predators wait for things that want easy food." },
	},

	"leso_lightning_tree": {
		"pass_flavor": "The area still feels wrong. You give it distance.",
		"buff":    { "stat": "type_stat", "amount": 0.12, "turns": 4, "source": "storm_forager", "flavor": "Storm Forager: after big weather there is always something exposed that was not before." },
		"nothing": { "flavor": "The tree is split but the area feels unstable. You observe from a distance and leave." },
		"food":    { "hunger": 0.17, "flavor": "Soft inner wood, exposed seeds, and insects displaced by the strike. All of it is yours." },
		"health":  { "health": 0.12, "flavor": "Rainwater pools in the split wood and the shelter from the canopy remains. You rest well." },
		"debuff":  { "health": -0.11, "flavor": "A branch is still falling when you arrive. You do not see it in time." },
	},

	"leso_chase_failed": {
		"pass_flavor": "You escape cleanly without needing to test your limits.",
		"w_buff": 0.14,
		"w_health": 0.20,
		"buff":    { "stat": "speed", "amount": 0.15, "turns": 0, "source": "sharp_turn", "perm": true, "perm_label": "Sharp Turn", "flavor": "Sharp Turn: your body learned something in that moment it will not forget. You turn faster than anything expects." },
		"nothing": { "flavor": "You escape cleanly. The predator breaks off before testing its speed against yours." },
		"food":    { "hunger": 0.14, "flavor": "The chase drives you directly into a hidden patch you would never have found otherwise." },
		"health":  { "health": 0.12, "flavor": "You reach shelter and your heart rate drops. You are unhurt and safe." },
		"debuff":  { "health": -0.14, "flavor": "You escape, but not before something fast gets close enough to leave a mark." },
	},

	"leso_nesting_scrape": {
		"pass_flavor": "The site is abandoned and you leave it that way.",
		"buff":    { "stat": "defense", "amount": 0.11, "turns": 4, "source": "nest_sense", "flavor": "Nest Sense: you read shelter sites differently now. You know what makes one safe versus what makes it obvious." },
		"nothing": { "flavor": "The site is abandoned. Nothing useful remains." },
		"food":    { "hunger": 0.14, "flavor": "Edible plant matter lines the scrape. Someone else prepared this and you benefit from it." },
		"health":  { "health": 0.12, "flavor": "Soft prepared ground. You rest better here than you would have anywhere else nearby." },
		"debuff":  { "stat": "defense", "amount": -0.10, "turns": 2, "source": "exposed_grazer", "flavor": "A predator has also noticed the nest area. It was looking for the same thing you were." },
	},

}


const EVENTS: Dictionary = {

	# ── JUVENILE ──────────────────────────────────────────────────────────────

	"leso_first_scatter": {
		"id": "leso_first_scatter",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"max_stage": 1,
		"rarity": "common",
		"passive": false,
		"flavor": "A shadow moves across the ground. Every instinct screams: run.",
		"choices": [
			{ "label": "Run",             "icon": "flee",   "sublabel": "Go now",               "action": "engage" },
			{ "label": "Freeze",          "icon": "rest",   "sublabel": "Don't move",            "action": "pass" },
		],
		"resolve_key": "leso_first_scatter",
	},

	"leso_green_shoots": {
		"id": "leso_green_shoots",
		"seasons": ["spring", "summer"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"max_stage": 1,
		"rarity": "common",
		"passive": false,
		"flavor": "Fresh young plants push through the soil after rain.",
		"choices": [
			{ "label": "Graze here",      "icon": "rest",   "sublabel": "Eat the new growth",   "action": "engage" },
			{ "label": "Move on",         "icon": "flee",   "sublabel": "Better patches ahead",  "action": "pass" },
		],
		"resolve_key": "leso_green_shoots",
	},

	"leso_ant_trail": {
		"id": "leso_ant_trail",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"max_stage": 1,
		"rarity": "common",
		"passive": false,
		"flavor": "A line of insects leads toward a fallen seed pod.",
		"choices": [
			{ "label": "Investigate",     "icon": "stalk",  "sublabel": "Follow the trail",     "action": "engage" },
			{ "label": "Leave it",        "icon": "flee",   "sublabel": "Not worth the risk",   "action": "pass" },
		],
		"resolve_key": "leso_ant_trail",
	},

	"leso_fern_arch": {
		"id": "leso_fern_arch",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"max_stage": 1,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "A curved fern makes a tiny shelter just your size.",
		"choices": [
			{ "label": "Slip inside",     "icon": "stalk",  "sublabel": "Use the cover",        "action": "engage" },
			{ "label": "Keep moving",     "icon": "flee",   "sublabel": "Too exposed",           "action": "pass" },
		],
		"resolve_key": "leso_fern_arch",
	},

	"leso_big_feet": {
		"id": "leso_big_feet",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"max_stage": 1,
		"rarity": "common",
		"passive": false,
		"flavor": "A larger herbivore herd moves nearby, shaking the ground.",
		"choices": [
			{ "label": "Stay near them",  "icon": "stalk",  "sublabel": "Use their shadow",     "action": "engage" },
			{ "label": "Move away",       "icon": "flee",   "sublabel": "Trampling risk",        "action": "pass" },
		],
		"resolve_key": "leso_big_feet",
	},

	# ── SUBADULT ──────────────────────────────────────────────────────────────

	"leso_open_sprint": {
		"id": "leso_open_sprint",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 1,
		"max_stage": 2,
		"rarity": "common",
		"passive": false,
		"flavor": "A clear patch of earth separates you from better cover.",
		"choices": [
			{ "label": "Sprint across",   "icon": "flee",   "sublabel": "Commit and go",        "action": "engage" },
			{ "label": "Wait",            "icon": "rest",   "sublabel": "Stay where you are",   "action": "pass" },
		],
		"resolve_key": "leso_open_sprint",
	},

	"leso_pebble_slope": {
		"id": "leso_pebble_slope",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 1,
		"max_stage": 2,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "A rocky slope offers a shortcut, but loose stones slide underfoot.",
		"choices": [
			{ "label": "Take the slope",  "icon": "stalk",  "sublabel": "Faster route",         "action": "engage" },
			{ "label": "Go around",       "icon": "flee",   "sublabel": "Safer but slower",     "action": "pass" },
		],
		"resolve_key": "leso_pebble_slope",
	},

	"leso_bitter_leaves": {
		"id": "leso_bitter_leaves",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 1,
		"max_stage": 2,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "A patch of tough, bitter plants remains untouched by other grazers.",
		"choices": [
			{ "label": "Try eating them", "icon": "rest",   "sublabel": "Something is better than nothing","action": "engage" },
			{ "label": "Leave them",      "icon": "flee",   "sublabel": "Your instincts say no","action": "pass" },
		],
		"resolve_key": "leso_bitter_leaves",
	},

	"leso_warning_chirp": {
		"id": "leso_warning_chirp",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 1,
		"max_stage": 2,
		"rarity": "common",
		"passive": false,
		"flavor": "Another Lesothosaurus makes a sharp warning call from the brush.",
		"choices": [
			{ "label": "React to it",     "icon": "flee",   "sublabel": "Trust the call",       "action": "engage" },
			{ "label": "Ignore it",       "icon": "rest",   "sublabel": "Could be nothing",     "action": "pass" },
		],
		"resolve_key": "leso_warning_chirp",
	},

	"leso_dry_streambed": {
		"id": "leso_dry_streambed",
		"seasons": ["spring", "summer", "fall", "winter"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 1,
		"max_stage": 2,
		"rarity": "common",
		"passive": false,
		"flavor": "A cracked streambed winds through the land like a hidden path.",
		"choices": [
			{ "label": "Follow it",       "icon": "stalk",  "sublabel": "Stay below the sightline","action": "engage" },
			{ "label": "Stay on ground",  "icon": "flee",   "sublabel": "Too enclosed",         "action": "pass" },
		],
		"resolve_key": "leso_dry_streambed",
	},

	# ── ADULT ─────────────────────────────────────────────────────────────────

	"leso_loose_herd": {
		"id": "leso_loose_herd",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "Several Lesothosaurus feed together, each watching a different direction.",
		"choices": [
			{ "label": "Join them",       "icon": "rest",   "sublabel": "Safety in numbers",    "action": "engage" },
			{ "label": "Feed alone",      "icon": "stalk",  "sublabel": "Less competition",     "action": "pass" },
		],
		"resolve_key": "leso_loose_herd",
	},

	"leso_brush_maze": {
		"id": "leso_brush_maze",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "Dense low brush creates tunnels only small animals can use.",
		"choices": [
			{ "label": "Enter the brush",  "icon": "stalk",  "sublabel": "Predators can't follow","action": "engage" },
			{ "label": "Stay in the open", "icon": "flee",   "sublabel": "Too tangled inside",  "action": "pass" },
		],
		"resolve_key": "leso_brush_maze",
	},

	"leso_seed_drop": {
		"id": "leso_seed_drop",
		"seasons": ["fall", "summer"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "Dry seed pods crack open in the heat. The ground beneath them is covered.",
		"choices": [
			{ "label": "Eat the seeds",   "icon": "rest",   "sublabel": "High-energy food",     "action": "engage" },
			{ "label": "Move on",         "icon": "flee",   "sublabel": "Too exposed here",     "action": "pass" },
		],
		"resolve_key": "leso_seed_drop",
	},

	"leso_predator_grass": {
		"id": "leso_predator_grass",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "The grass bends wrong. Something low and hungry is stalking nearby.",
		"choices": [
			{ "label": "Move now",        "icon": "flee",   "sublabel": "Don't wait to confirm","action": "engage" },
			{ "label": "Hold still",      "icon": "rest",   "sublabel": "Maybe it won't see you","action": "pass" },
		],
		"resolve_key": "leso_predator_grass",
	},

	"leso_sun_baked_rest": {
		"id": "leso_sun_baked_rest",
		"seasons": ["spring", "summer"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 2,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "A warm flat stone holds the day's heat.",
		"choices": [
			{ "label": "Rest on it",      "icon": "rest",   "sublabel": "Warm your muscles",    "action": "engage" },
			{ "label": "Find shade",      "icon": "flee",   "sublabel": "Too visible up there", "action": "pass" },
		],
		"resolve_key": "leso_sun_baked_rest",
	},

	# ── WOUNDED ADULT ─────────────────────────────────────────────────────────

	"leso_limping_cover": {
		"id": "leso_limping_cover",
		"seasons": ["spring", "summer", "fall", "winter"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 2,
		"require_injured": true,
		"rarity": "common",
		"passive": false,
		"flavor": "Your leg aches, but low brush hides your movement.",
		"choices": [
			{ "label": "Move through it", "icon": "stalk",  "sublabel": "Stay in cover",        "action": "engage" },
			{ "label": "Stay still",      "icon": "rest",   "sublabel": "Rest where you are",   "action": "pass" },
		],
		"resolve_key": "leso_limping_cover",
	},

	"leso_parasite_patch": {
		"id": "leso_parasite_patch",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 2,
		"require_injured": true,
		"rarity": "common",
		"passive": false,
		"flavor": "Tiny biting insects gather around your wound.",
		"choices": [
			{ "label": "Groom carefully", "icon": "rest",   "sublabel": "Clean the wound",      "action": "engage" },
			{ "label": "Keep moving",     "icon": "flee",   "sublabel": "Don't stop here",      "action": "pass" },
		],
		"resolve_key": "leso_parasite_patch",
	},

	"leso_root_pocket": {
		"id": "leso_root_pocket",
		"seasons": ["spring", "summer", "fall", "winter"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 2,
		"require_injured": true,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "A hollow near exposed roots offers food and cover.",
		"choices": [
			{ "label": "Take shelter",    "icon": "rest",   "sublabel": "Rest and eat here",    "action": "engage" },
			{ "label": "Check it first",  "icon": "stalk",  "sublabel": "Make sure it's empty", "action": "pass" },
		],
		"resolve_key": "leso_root_pocket",
	},

	"leso_blood_scent_breeze": {
		"id": "leso_blood_scent_breeze",
		"seasons": ["spring", "fall"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 2,
		"require_injured": true,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "Your wound carries scent into the open air. You are leaving a trail you cannot see.",
		"choices": [
			{ "label": "Find water",      "icon": "stalk",  "sublabel": "Clean the wound",      "action": "engage" },
			{ "label": "Move fast",       "icon": "flee",   "sublabel": "Get out of the area",  "action": "pass" },
		],
		"resolve_key": "leso_blood_scent_breeze",
	},

	# ── HERD / GROUP ──────────────────────────────────────────────────────────

	"leso_scatter_line": {
		"id": "leso_scatter_line",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "A group of Lesothosaurus spreads out while feeding, each watching a different direction.",
		"choices": [
			{ "label": "Spread with them","icon": "rest",   "sublabel": "Join the formation",   "action": "engage" },
			{ "label": "Feed alone",      "icon": "flee",   "sublabel": "Less noise, less risk", "action": "pass" },
		],
		"resolve_key": "leso_scatter_line",
	},

	"leso_follow_fast_one": {
		"id": "leso_follow_fast_one",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "One older Lesothosaurus seems to know the safest path. It is already moving.",
		"choices": [
			{ "label": "Follow it",       "icon": "stalk",  "sublabel": "Trust its route",      "action": "engage" },
			{ "label": "Go your own way", "icon": "flee",   "sublabel": "Don't follow blindly", "action": "pass" },
		],
		"resolve_key": "leso_follow_fast_one",
	},

	"leso_alarm_chorus": {
		"id": "leso_alarm_chorus",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "Several small herbivores begin calling at once. The sound builds fast.",
		"choices": [
			{ "label": "React with them", "icon": "flee",   "sublabel": "Trust the chorus",     "action": "engage" },
			{ "label": "Hold still",      "icon": "rest",   "sublabel": "Wait and confirm",     "action": "pass" },
		],
		"resolve_key": "leso_alarm_chorus",
	},

	"leso_crowded_grazing": {
		"id": "leso_crowded_grazing",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "A good patch attracts too many tiny herbivores.",
		"choices": [
			{ "label": "Push in",         "icon": "stalk",  "sublabel": "Eat fast",             "action": "engage" },
			{ "label": "Find another",    "icon": "flee",   "sublabel": "Not worth the fight",  "action": "pass" },
		],
		"resolve_key": "leso_crowded_grazing",
	},

	"leso_lost_from_group": {
		"id": "leso_lost_from_group",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "uncommon",
		"passive": false,
		"flavor": "After a sudden scare, you are alone. The group is gone.",
		"choices": [
			{ "label": "Move solo",       "icon": "stalk",  "sublabel": "Find your own route",  "action": "engage" },
			{ "label": "Wait",            "icon": "rest",   "sublabel": "They may come back",   "action": "pass" },
		],
		"resolve_key": "leso_lost_from_group",
	},

	# ── SEASONAL ──────────────────────────────────────────────────────────────

	"leso_spring_green_flush": {
		"id": "leso_spring_green_flush",
		"seasons": ["spring"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "Rain brings fresh plant growth across the plains. Everything is soft and new and abundant.",
		"choices": [
			{ "label": "Eat well",        "icon": "rest",   "sublabel": "Make the most of it",  "action": "engage" },
			{ "label": "Be careful",      "icon": "stalk",  "sublabel": "New plants can be wrong","action": "pass" },
		],
		"resolve_key": "leso_spring_green_flush",
	},

	"leso_spring_mud_prints": {
		"id": "leso_spring_mud_prints",
		"seasons": ["spring"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "Wet ground captures every footprint. The mud reads everything that has been through here.",
		"choices": [
			{ "label": "Read the mud",    "icon": "stalk",  "sublabel": "Learn what is nearby", "action": "engage" },
			{ "label": "Avoid the mud",   "icon": "flee",   "sublabel": "Slow your movement",   "action": "pass" },
		],
		"resolve_key": "leso_spring_mud_prints",
	},

	"leso_summer_dry_grass": {
		"id": "leso_summer_dry_grass",
		"seasons": ["summer"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "The plants are dry, tough, and less nourishing. Every bite costs more than it returns.",
		"choices": [
			{ "label": "Eat what is here","icon": "rest",   "sublabel": "Something is better than nothing","action": "engage" },
			{ "label": "Conserve energy", "icon": "flee",   "sublabel": "Wait for better conditions","action": "pass" },
		],
		"resolve_key": "leso_summer_dry_grass",
	},

	"leso_summer_heat_shimmer": {
		"id": "leso_summer_heat_shimmer",
		"seasons": ["summer"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "The air wavers. Predators are harder to see at a distance.",
		"choices": [
			{ "label": "Stay cautious",   "icon": "stalk",  "sublabel": "Trust nothing at range","action": "engage" },
			{ "label": "Wait in shade",   "icon": "rest",   "sublabel": "Don't move in this heat","action": "pass" },
		],
		"resolve_key": "leso_summer_heat_shimmer",
	},

	"leso_fall_seed_season": {
		"id": "leso_fall_seed_season",
		"seasons": ["fall"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "Dry plants drop seeds across the ground. High-energy food while the season still offers it.",
		"choices": [
			{ "label": "Eat seeds",       "icon": "rest",   "sublabel": "Stock up while you can","action": "engage" },
			{ "label": "Stay moving",     "icon": "flee",   "sublabel": "Exposed on the ground", "action": "pass" },
		],
		"resolve_key": "leso_fall_seed_season",
	},

	"leso_fall_moving_herds": {
		"id": "leso_fall_moving_herds",
		"seasons": ["fall"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "Larger herbivores shift routes, stirring up the land around them.",
		"choices": [
			{ "label": "Follow the trail","icon": "stalk",  "sublabel": "Use their wake",       "action": "engage" },
			{ "label": "Avoid the crush", "icon": "flee",   "sublabel": "Trampling risk",        "action": "pass" },
		],
		"resolve_key": "leso_fall_moving_herds",
	},

	"leso_winter_hidden_roots": {
		"id": "leso_winter_hidden_roots",
		"seasons": ["winter"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "Fresh leaves are rare, but underground food remains for those who know where to dig.",
		"choices": [
			{ "label": "Dig for roots",   "icon": "stalk",  "sublabel": "Head down, exposed",   "action": "engage" },
			{ "label": "Keep searching",  "icon": "flee",   "sublabel": "Find surface food",    "action": "pass" },
		],
		"resolve_key": "leso_winter_hidden_roots",
	},

	"leso_winter_cold_dawn": {
		"id": "leso_winter_cold_dawn",
		"seasons": ["winter"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "common",
		"passive": false,
		"flavor": "The morning is cold, and your legs feel stiff.",
		"choices": [
			{ "label": "Bask in the sun", "icon": "rest",   "sublabel": "Warm up first",        "action": "engage" },
			{ "label": "Move anyway",     "icon": "flee",   "sublabel": "Get clear before light","action": "pass" },
		],
		"resolve_key": "leso_winter_cold_dawn",
	},

	# ── RARE ──────────────────────────────────────────────────────────────────

	"leso_perfect_hide": {
		"id": "leso_perfect_hide",
		"seasons": ["spring", "summer", "fall", "winter"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "rare",
		"passive": false,
		"flavor": "You find a space between roots that is too small for anything that hunts you.",
		"choices": [
			{ "label": "Take it",         "icon": "rest",   "sublabel": "Nothing can follow",   "action": "engage" },
			{ "label": "Leave it",        "icon": "flee",   "sublabel": "Ground feels wrong",   "action": "pass" },
		],
		"resolve_key": "leso_perfect_hide",
	},

	"leso_false_safe_meadow": {
		"id": "leso_false_safe_meadow",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "rare",
		"passive": false,
		"flavor": "A beautiful green patch sits in the open. Everything about it looks perfect.",
		"choices": [
			{ "label": "Graze it",        "icon": "rest",   "sublabel": "Looks safe enough",    "action": "engage" },
			{ "label": "Stay back",       "icon": "flee",   "sublabel": "Something is wrong",   "action": "pass" },
		],
		"resolve_key": "leso_false_safe_meadow",
	},

	"leso_lightning_tree": {
		"id": "leso_lightning_tree",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "rare",
		"passive": false,
		"flavor": "A storm breaks a tree open, exposing soft inner material, insects, and shelter.",
		"choices": [
			{ "label": "Investigate",     "icon": "stalk",  "sublabel": "Check what was exposed","action": "engage" },
			{ "label": "Stay away",       "icon": "flee",   "sublabel": "Area still feels wrong","action": "pass" },
		],
		"resolve_key": "leso_lightning_tree",
	},

	"leso_chase_failed": {
		"id": "leso_chase_failed",
		"seasons": ["spring", "summer", "fall"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "rare",
		"passive": false,
		"flavor": "A predator lunges. Your body turns before you decide to.",
		"choices": [
			{ "label": "Push the turn",   "icon": "flee",   "sublabel": "Give everything",      "action": "engage" },
			{ "label": "Find cover fast", "icon": "stalk",  "sublabel": "Get small, get hidden","action": "pass" },
		],
		"resolve_key": "leso_chase_failed",
	},

	"leso_nesting_scrape": {
		"id": "leso_nesting_scrape",
		"seasons": ["spring", "summer"],
		"trees": ["herbivore"],
		"species": ["lesothosaurus"],
		"min_stage": 1,
		"max_stage": 3,
		"rarity": "rare",
		"passive": false,
		"flavor": "You find a shallow scraped-out nesting spot. Soft ground, good cover, recently used.",
		"choices": [
			{ "label": "Use the spot",    "icon": "rest",   "sublabel": "Rest here",            "action": "engage" },
			{ "label": "Leave it",        "icon": "flee",   "sublabel": "Someone will come back","action": "pass" },
		],
		"resolve_key": "leso_nesting_scrape",
	},

}
