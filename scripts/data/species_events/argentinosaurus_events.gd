extends Node

# ─── Argentinosaurus Events ───────────────────────────────────────────────────
# 40 events: 5 juvenile, 5 subadult, 7 adult, 5 wounded adult, 5 social/herd,
#            8 seasonal, 5 rare
# Species: argentinosaurus   Tree: herbivore
# Defining mechanic: herd column as living terrain, high browsing, giant scale
# ─────────────────────────────────────────────────────────────────────────────

const OUTCOME_EVENTS: Dictionary = {

	# ══ JUVENILE ════════════════════════════════════════════════════════════

	"arge_born_beneath_giants": {
		"w_buff": 0.12, "w_food": 0.26, "w_health": 0.20, "w_nothing": 0.30, "w_debuff": 0.12,
		"buff":   { "stat": "defense", "amount": 0.10, "turns": 2, "source": "arge_born_beneath_giants", "flavor": "You learn to stay in the shelter of the adults, where their size discourages danger." },
		"food":   { "hunger": 0.12, "flavor": "Soft shoots grow undisturbed near the nesting ground." },
		"health": { "health": 0.08, "flavor": "You rest on warm ground, soothed by the steady movement of the herd around you." },
		"debuff": { "health": -0.08, "flavor": "You lose the center in a wave of moving limbs and dust." },
	},

	"arge_first_neck_stretch": {
		"w_buff": 0.12, "w_food": 0.28, "w_health": 0.18, "w_nothing": 0.30, "w_debuff": 0.12,
		"buff":   { "stat": "type_stat", "amount": 0.08, "turns": 3, "source": "arge_first_neck_stretch", "flavor": "Your neck remembers how far it went. It will go further next time." },
		"food":   { "hunger": 0.12, "flavor": "Low branches, tender enough for your young teeth." },
		"health": { "health": 0.07, "flavor": "The slow stretch eases the stiffness in your neck." },
		"debuff": { "stat": "speed", "amount": -0.06, "turns": 2, "source": "arge_first_neck_stretch", "flavor": "You lean too far and stumble, straining your neck as your front feet slip." },
	},

	"arge_footprints_like_ponds": {
		"w_buff": 0.12, "w_food": 0.26, "w_health": 0.22, "w_nothing": 0.30, "w_debuff": 0.10,
		"buff":   { "stat": "type_stat", "amount": 0.08, "turns": 2, "source": "arge_footprints_like_ponds", "flavor": "You follow the adults' deep tracks until the route begins to feel familiar." },
		"food":   { "hunger": 0.12, "flavor": "Small plants grow at the edges of the print, sheltered and undisturbed." },
		"health": { "health": 0.08, "flavor": "Clean water, collected and cool." },
		"debuff": { "stat": "speed", "amount": -0.08, "turns": 2, "source": "arge_footprints_like_ponds", "flavor": "Your foot follows the print down and the mud holds it there." },
	},

	"arge_tiny_among_titans": {
		"w_buff": 0.12, "w_food": 0.24, "w_health": 0.18, "w_nothing": 0.30, "w_debuff": 0.16,
		"buff":   { "stat": "speed", "amount": 0.10, "turns": 2, "source": "arge_tiny_among_titans", "flavor": "You learn to watch each adult's stride and step safely through the gaps." },
		"food":   { "hunger": 0.12, "flavor": "The adults turn the soil as they walk, uncovering plants you can eat." },
		"health": { "health": 0.08, "flavor": "The herd's center is the safest place in the world." },
		"debuff": { "health": -0.08, "flavor": "A foot comes down near you. Not on you, but near enough." },
	},

	"arge_low_fern_breakfast": {
		"w_buff": 0.12, "w_food": 0.32, "w_health": 0.18, "w_nothing": 0.28, "w_debuff": 0.10,
		"buff":   { "stat": "type_stat", "amount": 0.08, "turns": 2, "source": "arge_low_fern_breakfast", "flavor": "Tender plants are easy on your young teeth. You learn which shoots to seek out." },
		"food":   { "hunger": 0.14, "flavor": "Soft ferns, rich and low." },
		"health": { "health": 0.08, "flavor": "Young plants carry what your body needs most." },
		"debuff": { "health": -0.06, "flavor": "A few mouthfuls from the fern patch leave your stomach unsettled." },
	},

	# ══ SUBADULT ════════════════════════════════════════════════════════════

	"arge_herd_trail_memory": {
		"w_buff": 0.12, "w_food": 0.28, "w_health": 0.18, "w_nothing": 0.28, "w_debuff": 0.14,
		"buff":   { "stat": "type_stat", "amount": 0.10, "turns": 3, "source": "arge_herd_trail_memory", "flavor": "The floodplain remembers the herd and the herd remembers the floodplain." },
		"food":   { "hunger": 0.16, "flavor": "The ancient route leads where it always leads." },
		"health": { "health": 0.10, "flavor": "Safe ground and resting places, worn smooth by generations." },
		"debuff": { "health": -0.10, "flavor": "Predators learn the same routes the herds do. Someone is waiting." },
	},

	"arge_growing_appetite": {
		"w_buff": 0.12, "w_food": 0.32, "w_health": 0.20, "w_nothing": 0.26, "w_debuff": 0.10,
		"buff":   { "stat": "type_stat", "amount": 0.10, "turns": 3, "source": "arge_growing_appetite", "flavor": "Your body knows how to use food now. Every bite counts double." },
		"food":   { "hunger": 0.18, "flavor": "A rich browse patch, enough for a body that is finally ready for it." },
		"health": { "health": 0.10, "flavor": "Full feeding fills more than your stomach." },
		"debuff": { "stat": "hunger", "amount": -0.12, "flavor": "Your body demands more than the area can give. The gap stays open." },
	},

	"arge_high_branch_reward": {
		"w_buff": 0.12, "w_food": 0.32, "w_health": 0.18, "w_nothing": 0.28, "w_debuff": 0.10,
		"buff":   { "stat": "type_stat", "amount": 0.12, "turns": 3, "source": "arge_high_branch_reward", "flavor": "Up here, nothing else has ever reached. The leaves have been waiting for you." },
		"food":   { "hunger": 0.18, "flavor": "Untouched leaves, clean and undamaged." },
		"health": { "health": 0.10, "flavor": "Good food from somewhere nothing can compete with you." },
		"debuff": { "stat": "speed", "amount": -0.08, "turns": 2, "source": "arge_high_branch_reward", "flavor": "Your neck went further than it should. The strain follows you." },
	},

	"arge_river_crossing": {
		"w_buff": 0.12, "w_food": 0.26, "w_health": 0.22, "w_nothing": 0.28, "w_debuff": 0.12,
		"buff":   { "stat": "speed", "amount": 0.12, "turns": 2, "source": "arge_river_crossing", "flavor": "Wide water parts around you. You learn you are not afraid of rivers." },
		"food":   { "hunger": 0.16, "flavor": "Moist riverside plants, thick and green." },
		"health": { "health": 0.12, "flavor": "Drinking deep and cooling in the current." },
		"debuff": { "stat": "speed", "amount": -0.10, "turns": 3, "source": "arge_river_crossing", "flavor": "The muddy bank takes hold of your feet. Every step out costs you." },
	},

	"arge_giant_predator_scent": {
		"w_buff": 0.12, "w_food": 0.22, "w_health": 0.18, "w_nothing": 0.30, "w_debuff": 0.18,
		"buff":   { "stat": "defense", "amount": 0.12, "turns": 2, "source": "arge_giant_predator_scent", "flavor": "The adults go still and their stillness becomes yours. Nothing moves until it passes." },
		"food":   { "hunger": 0.14, "flavor": "Smaller animals scatter ahead of the predator's path, clearing your way." },
		"health": { "health": 0.10, "flavor": "Staying close to adult bodies feels safer than open ground." },
		"debuff": { "health": -0.10, "flavor": "Panic breaks the herd formation. The young scatter." },
	},

	# ══ ADULT ════════════════════════════════════════════════════════════════

	"arge_walking_forest": {
		"w_buff": 0.12, "w_food": 0.28, "w_health": 0.18, "w_nothing": 0.32, "w_debuff": 0.10,
		"buff":   { "stat": "type_stat", "amount": 0.12, "turns": 3, "source": "arge_walking_forest", "flavor": "You are not moving through the landscape. You are part of it." },
		"food":   { "hunger": 0.18, "flavor": "Your passage opens browse paths nothing else thought to reach." },
		"health": { "health": 0.10, "flavor": "Slow steady movement costs very little and gives back a great deal." },
		"debuff": { "health": -0.08, "flavor": "The dense growth drags across your side as you push through." },
	},

	"arge_neck_above_herd": {
		"w_buff": 0.12, "w_food": 0.28, "w_health": 0.18, "w_nothing": 0.32, "w_debuff": 0.10,
		"buff":   { "stat": "type_stat", "amount": 0.12, "turns": 3, "source": "arge_neck_above_herd", "flavor": "From up here you see what no one else does. You act on it." },
		"food":   { "hunger": 0.18, "flavor": "A green zone in the distance. The herd follows your turn." },
		"health": { "health": 0.10, "flavor": "The herd moves to safer ground. You guided them there." },
		"debuff": { "stat": "speed", "amount": -0.08, "turns": 2, "source": "arge_neck_above_herd", "flavor": "Holding your head at that height for that long has a price." },
	},

	"arge_predator_tests_giant": {
		"w_buff": 0.12, "w_food": 0.24, "w_health": 0.18, "w_nothing": 0.32, "w_debuff": 0.14,
		"buff":   { "stat": "type_stat", "amount": 0.14, "turns": 3, "source": "arge_predator_tests_giant", "flavor": "It circled for a long time before deciding the answer was no." },
		"food":   { "hunger": 0.16, "flavor": "Its retreat leaves the feeding ground open." },
		"health": { "health": 0.10, "flavor": "Choosing not to fight costs nothing. You fed instead." },
		"debuff": { "health": -0.12, "flavor": "Before it decides the math is wrong, it tests the answer with your flank." },
	},

	"arge_tail_sweep_warning": {
		"w_buff": 0.12, "w_food": 0.26, "w_health": 0.18, "w_nothing": 0.32, "w_debuff": 0.12,
		"buff":   { "stat": "defense", "amount": 0.12, "turns": 3, "source": "arge_tail_sweep_warning", "flavor": "Whatever came up behind you will not do it again." },
		"food":   { "hunger": 0.14, "flavor": "The cleared space gives you a better angle on the plants." },
		"health": { "health": 0.10, "flavor": "The warning worked and cost you nothing." },
		"debuff": { "stat": "speed", "amount": -0.10, "turns": 2, "source": "arge_tail_sweep_warning", "flavor": "The twist in your hips stays there longer than you expected." },
	},

	"arge_deep_browse_grove": {
		"w_buff": 0.12, "w_food": 0.34, "w_health": 0.22, "w_nothing": 0.22, "w_debuff": 0.10,
		"buff":   { "stat": "type_stat", "amount": 0.14, "turns": 3, "source": "arge_deep_browse_grove", "flavor": "You stood in the canopy and ate until you ran out of reasons to stop." },
		"food":   { "hunger": 0.28, "flavor": "Leaves nothing else has ever tasted. The grove was made for something your size." },
		"health": { "health": 0.16, "flavor": "A meal like this heals more than hunger." },
		"debuff": { "stat": "speed", "amount": -0.10, "turns": 2, "source": "arge_deep_browse_grove", "flavor": "You ate too much to move quickly. The weight makes itself known." },
	},

	"arge_ground_tremor_march": {
		"w_buff": 0.12, "w_food": 0.26, "w_health": 0.18, "w_nothing": 0.32, "w_debuff": 0.12,
		"buff":   { "stat": "type_stat", "amount": 0.12, "turns": 3, "source": "arge_ground_tremor_march", "flavor": "The earth moves with you. Everything else moves away." },
		"food":   { "hunger": 0.16, "flavor": "The herd reaches a fresh plain and spreads across it." },
		"health": { "health": 0.10, "flavor": "Moving together, nothing follows. Rest is safer at the end." },
		"debuff": { "stat": "hunger", "amount": -0.12, "flavor": "A march this long takes more than it gives." },
	},

	"arge_calf_shield": {
		"w_buff": 0.12, "w_food": 0.24, "w_health": 0.18, "w_nothing": 0.32, "w_debuff": 0.14,
		"buff":   { "stat": "defense", "amount": 0.12, "turns": 2, "source": "arge_calf_shield", "flavor": "You position yourself without thinking. The calf is behind you now." },
		"food":   { "hunger": 0.14, "flavor": "The herd shifts and finds better ground while you hold position." },
		"health": { "health": 0.10, "flavor": "The area calms. The herd stabilizes." },
		"debuff": { "health": -0.10, "flavor": "Your position drew attention. You took what was meant for the calf." },
	},

	# ══ WOUNDED ADULT ═══════════════════════════════════════════════════════

	"arge_wound_like_cliff": {
		"w_buff": 0.12, "w_food": 0.22, "w_health": 0.22, "w_nothing": 0.28, "w_debuff": 0.16,
		"buff":   { "stat": "defense", "amount": 0.12, "turns": 2, "source": "arge_wound_like_cliff", "flavor": "Your hide has held more than this before. It will hold this too." },
		"food":   { "hunger": 0.14, "flavor": "You stay close to food while the injury settles." },
		"health": { "health": 0.10, "flavor": "Mud and rest do what they can for something this large." },
		"debuff": { "health": -0.14, "flavor": "The blood scent reaches things with poor judgment and good noses." },
	},

	"arge_heavy_limp": {
		"w_buff": 0.12, "w_food": 0.22, "w_health": 0.22, "w_nothing": 0.28, "w_debuff": 0.16,
		"buff":   { "stat": "speed", "amount": 0.10, "turns": 2, "source": "arge_heavy_limp", "flavor": "You find the way to move that costs the least. It is slower, but it holds." },
		"food":   { "hunger": 0.14, "flavor": "The herd slows where the browse is good. You catch up there." },
		"health": { "health": 0.10, "flavor": "Careful movement lets the injury stabilize." },
		"debuff": { "stat": "speed", "amount": -0.12, "turns": 3, "source": "arge_heavy_limp", "flavor": "The herd does not slow forever. The gap between you and them grows." },
	},

	"arge_mud_cooling": {
		"w_buff": 0.12, "w_food": 0.22, "w_health": 0.24, "w_nothing": 0.28, "w_debuff": 0.14,
		"buff":   { "stat": "defense", "amount": 0.10, "turns": 2, "source": "arge_mud_cooling", "flavor": "Mud seals the wound and kills the scent. The swarm of insects lifts." },
		"food":   { "hunger": 0.14, "flavor": "Wetland plants grow thick near the floodplain edge." },
		"health": { "health": 0.12, "flavor": "Cool mud draws the heat from the wound and the weight from your bones." },
		"debuff": { "stat": "speed", "amount": -0.12, "turns": 3, "source": "arge_mud_cooling", "flavor": "Your feet sink past the point where pulling free is simple." },
	},

	"arge_herd_slows": {
		"w_buff": 0.12, "w_food": 0.22, "w_health": 0.22, "w_nothing": 0.28, "w_debuff": 0.16,
		"buff":   { "stat": "defense", "amount": 0.12, "turns": 2, "source": "arge_herd_slows", "flavor": "The giants around you slow their pace. You are not left behind today." },
		"food":   { "hunger": 0.14, "flavor": "The herd route passes through browse. You eat while you can." },
		"health": { "health": 0.10, "flavor": "The group shields you and your body uses the rest." },
		"debuff": { "health": -0.10, "flavor": "The herd's hesitation signals something else that is watching." },
	},

	"arge_neck_held_low": {
		"w_buff": 0.12, "w_food": 0.22, "w_health": 0.22, "w_nothing": 0.28, "w_debuff": 0.16,
		"buff":   { "stat": "type_stat", "amount": 0.10, "turns": 2, "source": "arge_neck_held_low", "flavor": "You find the food that is within reach. This will do." },
		"food":   { "hunger": 0.14, "flavor": "Low shrubs and soft ground plants. Close enough." },
		"health": { "health": 0.10, "flavor": "The reduced strain gives the injury something to work with." },
		"debuff": { "stat": "defense", "amount": -0.08, "turns": 2, "source": "arge_neck_held_low", "flavor": "Low and slow and easy to read. The horizon feels closer than it should." },
	},

	# ══ HERD / SOCIAL ═══════════════════════════════════════════════════════

	"arge_giant_herd_column": {
		"w_buff": 0.12, "w_food": 0.26, "w_health": 0.18, "w_nothing": 0.32, "w_debuff": 0.12,
		"buff":   { "stat": "defense", "amount": 0.12, "turns": 3, "source": "arge_giant_herd_column", "flavor": "A column of giants stretches to the horizon. Nothing sensible approaches." },
		"food":   { "hunger": 0.16, "flavor": "The column ends at fresh vegetation no one has touched yet." },
		"health": { "health": 0.10, "flavor": "Moving together keeps the predators watching from a safe distance." },
		"debuff": { "health": -0.10, "flavor": "The gap between you and the column is where something decides to try." },
	},

	"arge_calves_in_wake": {
		"w_buff": 0.12, "w_food": 0.24, "w_health": 0.18, "w_nothing": 0.34, "w_debuff": 0.12,
		"buff":   { "stat": "defense", "amount": 0.10, "turns": 2, "source": "arge_calves_in_wake", "flavor": "The young stay in the disturbed ground behind you. You do not need to watch them — you just walk." },
		"food":   { "hunger": 0.14, "flavor": "Your footsteps overturn the soil. Small things worth eating come up." },
		"health": { "health": 0.08, "flavor": "The herd's rhythm lowers everything. Even rest feels easier in motion." },
		"debuff": { "health": -0.08, "flavor": "Dust and confusion. One of the calves goes the wrong direction." },
	},

	"arge_the_slow_turn": {
		"w_buff": 0.12, "w_food": 0.24, "w_health": 0.18, "w_nothing": 0.30, "w_debuff": 0.16,
		"buff":   { "stat": "type_stat", "amount": 0.10, "turns": 2, "source": "arge_the_slow_turn", "flavor": "The herd completes the turn without breaking. Something was watching and decides not to." },
		"food":   { "hunger": 0.16, "flavor": "The new direction leads exactly where it should." },
		"health": { "health": 0.10, "flavor": "A turn done cleanly wastes nothing." },
		"debuff": { "health": -0.12, "flavor": "The gap opens at the pivot point and something recognizes it faster than the herd does." },
	},

	"arge_elder_leads_route": {
		"w_buff": 0.12, "w_food": 0.30, "w_health": 0.20, "w_nothing": 0.26, "w_debuff": 0.12,
		"buff":   { "stat": "type_stat", "amount": 0.12, "turns": 3, "source": "arge_elder_leads_route", "flavor": "The elder has walked this land since before you were born. It remembers what the land looked like before the drought." },
		"food":   { "hunger": 0.18, "flavor": "The ancient path leads exactly where it always has." },
		"health": { "health": 0.12, "flavor": "Safe water and resting ground, remembered across seasons." },
		"debuff": { "stat": "hunger", "amount": -0.12, "flavor": "The route the elder remembered led somewhere that is not there anymore." },
	},

	"arge_herd_wall_of_necks": {
		"w_buff": 0.14, "w_food": 0.24, "w_health": 0.18, "w_nothing": 0.30, "w_debuff": 0.14,
		"buff":   { "stat": "type_stat", "amount": 0.14, "turns": 3, "source": "arge_herd_wall_of_necks", "flavor": "There is no good angle. There is no weak side. From the outside, it is just a wall of impossible height." },
		"food":   { "hunger": 0.16, "flavor": "Nothing comes close. The herd feeds undisturbed." },
		"health": { "health": 0.12, "flavor": "Group calm restores more than rest alone." },
		"debuff": { "stat": "hunger", "amount": -0.12, "flavor": "Holding the formation takes energy the march has already spent." },
	},

	# ══ SEASONAL ════════════════════════════════════════════════════════════

	"arge_spring_floodplain_bloom": {
		"w_buff": 0.12, "w_food": 0.34, "w_health": 0.22, "w_nothing": 0.22, "w_debuff": 0.10,
		"buff":   { "stat": "type_stat", "amount": 0.12, "turns": 3, "source": "arge_spring_floodplain_bloom", "flavor": "The plain grows faster than anything can eat it. For now." },
		"food":   { "hunger": 0.22, "flavor": "Fresh growth in every direction, low and dense and untouched." },
		"health": { "health": 0.14, "flavor": "Spring food restores things that winter quietly took." },
		"debuff": { "stat": "speed", "amount": -0.08, "turns": 2, "source": "arge_spring_floodplain_bloom", "flavor": "The wet ground grabs at every step." },
	},

	"arge_spring_nesting_ground": {
		"w_buff": 0.12, "w_food": 0.24, "w_health": 0.18, "w_nothing": 0.30, "w_debuff": 0.16,
		"buff":   { "stat": "defense", "amount": 0.12, "turns": 2, "source": "arge_spring_nesting_ground", "flavor": "The adults form an outer ring without deciding to. The calves inside do not know how safe they are." },
		"food":   { "hunger": 0.14, "flavor": "Soft plants grow thick near the nesting ground." },
		"health": { "health": 0.10, "flavor": "Warm ground and familiar faces. Rest comes easier here." },
		"debuff": { "health": -0.10, "flavor": "Something patient has been walking the edge of the nesting ground for days." },
	},

	"arge_summer_heat_over_giant": {
		"w_buff": 0.12, "w_food": 0.22, "w_health": 0.18, "w_nothing": 0.32, "w_debuff": 0.16,
		"buff":   { "stat": "type_stat", "amount": 0.10, "turns": 2, "source": "arge_summer_heat_over_giant", "flavor": "You learn when to move and when to stand. The heat has a schedule and you have learned it." },
		"food":   { "hunger": 0.14, "flavor": "Shade plants stay edible through the worst of it." },
		"health": { "health": 0.10, "flavor": "Shade and water restore what the sun took." },
		"debuff": { "stat": "hunger", "amount": -0.14, "flavor": "Too much body to cool and not enough shade. Stamina bleeds away." },
	},

	"arge_summer_dry_riverbed": {
		"w_buff": 0.12, "w_food": 0.26, "w_health": 0.22, "w_nothing": 0.28, "w_debuff": 0.12,
		"buff":   { "stat": "speed", "amount": 0.10, "turns": 2, "source": "arge_summer_dry_riverbed", "flavor": "The dry bed is wide and flat. The footing is firmer than you expected." },
		"food":   { "hunger": 0.16, "flavor": "Underground moisture keeps the roots alive where the surface is bare." },
		"health": { "health": 0.12, "flavor": "A hidden pool, deep under a bend in the riverbed." },
		"debuff": { "stat": "speed", "amount": -0.12, "turns": 2, "source": "arge_summer_dry_riverbed", "flavor": "The cracked mud shifts under your weight. Your foot goes through." },
	},

	"arge_fall_migration_pull": {
		"w_buff": 0.12, "w_food": 0.30, "w_health": 0.20, "w_nothing": 0.26, "w_debuff": 0.12,
		"buff":   { "stat": "type_stat", "amount": 0.12, "turns": 3, "source": "arge_fall_migration_pull", "flavor": "The herd feels the pull before any one member decides to move." },
		"food":   { "hunger": 0.18, "flavor": "The migration route opens onto browse no one has reached since last year." },
		"health": { "health": 0.12, "flavor": "The route finds water and shade in the right order." },
		"debuff": { "stat": "hunger", "amount": -0.14, "flavor": "The distance between here and there is real. You feel it." },
	},

	"arge_fall_old_growth_grove": {
		"w_buff": 0.12, "w_food": 0.34, "w_health": 0.22, "w_nothing": 0.22, "w_debuff": 0.10,
		"buff":   { "stat": "type_stat", "amount": 0.12, "turns": 3, "source": "arge_fall_old_growth_grove", "flavor": "Trees this old carry food from twenty meters of roots. The grove provides." },
		"food":   { "hunger": 0.24, "flavor": "Mature growth that has not been touched since the last migration." },
		"health": { "health": 0.14, "flavor": "The herd spreads and feeds without competing. Full feeding restores everything." },
		"debuff": { "stat": "speed", "amount": -0.10, "turns": 2, "source": "arge_fall_old_growth_grove", "flavor": "Another herd arrived first. You push for position and both sides are slower for it." },
	},

	"arge_winter_bare_floodplain": {
		"w_buff": 0.12, "w_food": 0.22, "w_health": 0.16, "w_nothing": 0.36, "w_debuff": 0.14,
		"buff":   { "stat": "speed", "amount": 0.10, "turns": 2, "source": "arge_winter_bare_floodplain", "flavor": "The plain is open and you cover it faster than the season expects." },
		"food":   { "hunger": 0.14, "flavor": "A distant patch, barely visible. Far enough that nothing else bothered." },
		"health": { "health": 0.10, "flavor": "Slow travel and rest at the end of a long day." },
		"debuff": { "stat": "hunger", "amount": -0.14, "flavor": "The empty plain gives nothing back. Hunger uses the stamina you were saving." },
	},

	"arge_winter_dust_herd": {
		"w_buff": 0.12, "w_food": 0.22, "w_health": 0.18, "w_nothing": 0.34, "w_debuff": 0.14,
		"buff":   { "stat": "defense", "amount": 0.10, "turns": 2, "source": "arge_winter_dust_herd", "flavor": "The dust makes everything invisible. Including you." },
		"food":   { "hunger": 0.12, "flavor": "Wind strips the top layer. Roots underneath are exposed." },
		"health": { "health": 0.10, "flavor": "Close to the others. The dust cannot find you in the center." },
		"debuff": { "health": -0.10, "flavor": "Dust settles in places it was not welcome." },
	},

	# ══ RARE ════════════════════════════════════════════════════════════════

	"arge_mapusaurus_pressure": {
		"w_buff": 0.10, "w_food": 0.20, "w_health": 0.18, "w_nothing": 0.30, "w_debuff": 0.22,
		"buff":   { "stat": "type_stat", "amount": 0.14, "turns": 0, "perm": true, "perm_label": "Titan Nerve", "source": "arge_mapusaurus_pressure", "flavor": "The predator that hunts giants tried the herd and the herd held. You held." },
		"food":   { "hunger": 0.16, "flavor": "The predator retreats. The herd closes its gaps and moves to safer browse." },
		"health": { "health": 0.12, "flavor": "Staying in formation, the herd absorbed the pressure and came out intact." },
		"debuff": { "health": -0.22, "flavor": "The isolation worked. For a moment you were separated and the moment was enough." },
	},

	"arge_earth_shaking_step": {
		"w_buff": 0.14, "w_food": 0.20, "w_health": 0.18, "w_nothing": 0.30, "w_debuff": 0.18,
		"buff":   { "stat": "strength", "amount": 0.16, "turns": 0, "perm": true, "perm_label": "Earthshaker", "source": "arge_earth_shaking_step", "flavor": "The ground spoke for you. Everything nearby heard it and made its decision." },
		"food":   { "hunger": 0.16, "flavor": "The impact splits the soil. Roots underneath come up." },
		"health": { "health": 0.12, "flavor": "The threat scattered. The area belongs to you." },
		"debuff": { "stat": "speed", "amount": -0.12, "turns": 3, "source": "arge_earth_shaking_step", "flavor": "The ground gave way wrong under your foot. The leg knows it." },
	},

	"arge_giant_falls_nearby": {
		"w_buff": 0.12, "w_food": 0.20, "w_health": 0.18, "w_nothing": 0.32, "w_debuff": 0.18,
		"buff":   { "stat": "type_stat", "amount": 0.14, "turns": 3, "source": "arge_giant_falls_nearby", "flavor": "You walk past without stopping. You do not need to understand it. You just need to remember which direction it did not go." },
		"food":   { "hunger": 0.14, "flavor": "The area around it has not been grazed in days. The plants are undisturbed." },
		"health": { "health": 0.12, "flavor": "The herd rests nearby. Nothing approaches while the giant is still there." },
		"debuff": { "health": -0.14, "flavor": "Things gather. Quickly. More of them than expected." },
	},

	"arge_volcano_ash_drift": {
		"w_buff": 0.12, "w_food": 0.20, "w_health": 0.18, "w_nothing": 0.32, "w_debuff": 0.18,
		"buff":   { "stat": "type_stat", "amount": 0.12, "turns": 3, "source": "arge_volcano_ash_drift", "flavor": "You learn to read what the land is telling you. This patch — no. That one — yes." },
		"food":   { "hunger": 0.12, "flavor": "Uncovered plants at the edge of the drift, still clean." },
		"health": { "health": 0.10, "flavor": "Moving away before it settled was the right call." },
		"debuff": { "health": -0.14, "flavor": "The ash was in the water before you saw it. You only know after." },
	},

	"arge_living_horizon": {
		"w_buff": 0.14, "w_food": 0.20, "w_health": 0.20, "w_nothing": 0.30, "w_debuff": 0.16,
		"buff":   { "stat": "defense", "amount": 0.14, "turns": 0, "perm": true, "perm_label": "Living Horizon", "source": "arge_living_horizon", "flavor": "From a distance, you look like the land itself is moving. Nothing comes to test that." },
		"food":   { "hunger": 0.18, "flavor": "The herd arrives at an untouched grove. No one reached it before you." },
		"health": { "health": 0.14, "flavor": "Calm migration, long and uncontested. Everything recovers on the way." },
		"debuff": { "health": -0.14, "flavor": "Something followed the movement instead of avoiding it. It has been planning since the horizon." },
	},

}

const EVENTS: Dictionary = {

	# ══ JUVENILE ════════════════════════════════════════════════════════════

	"arge_born_beneath_giants": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["argentinosaurus"],
		"max_stage": 1,
		"flavor": "You hatched small. The world around you is not small. The nearest adult's ankle is above your head.",
		"effects": {}, "choices": [], "resolve_key": "arge_born_beneath_giants",
	},

	"arge_first_neck_stretch": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["argentinosaurus"],
		"max_stage": 1,
		"flavor": "There are leaves above your head that look worth trying. Your neck is the longest thing on your body and it is not long enough yet.",
		"effects": {}, "choices": [], "resolve_key": "arge_first_neck_stretch",
	},

	"arge_footprints_like_ponds": {
		"seasons": ["spring", "summer"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["argentinosaurus"],
		"max_stage": 1,
		"flavor": "An adult footprint pressed deep into the earth has filled with rain. It is wider than your body.",
		"effects": {}, "choices": [], "resolve_key": "arge_footprints_like_ponds",
	},

	"arge_tiny_among_titans": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["argentinosaurus"],
		"max_stage": 1,
		"flavor": "The herd moves and every footfall near you is a small earthquake. You are the size of their mistakes.",
		"effects": {}, "choices": [], "resolve_key": "arge_tiny_among_titans",
	},

	"arge_low_fern_breakfast": {
		"seasons": ["spring", "summer"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["argentinosaurus"],
		"max_stage": 1,
		"flavor": "The ferns are low and soft and exactly right. Someday you will eat from the canopy. Today this is enough.",
		"effects": {}, "choices": [], "resolve_key": "arge_low_fern_breakfast",
	},

	# ══ SUBADULT ════════════════════════════════════════════════════════════

	"arge_herd_trail_memory": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["argentinosaurus"],
		"min_stage": 1, "max_stage": 2,
		"flavor": "The floodplain trail is pressed a meter deep by generations of feet. You are the newest set.",
		"effects": {}, "choices": [], "resolve_key": "arge_herd_trail_memory",
	},

	"arge_growing_appetite": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["argentinosaurus"],
		"min_stage": 1, "max_stage": 2,
		"flavor": "Yesterday you were full. Today your body wants more and you cannot explain why except that you are bigger than you were.",
		"effects": {}, "choices": [], "resolve_key": "arge_growing_appetite",
	},

	"arge_high_branch_reward": {
		"seasons": ["spring", "summer", "fall"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["argentinosaurus"],
		"min_stage": 1, "max_stage": 2,
		"flavor": "Your neck clears the height that ended the reach of everything below you. Up here the leaves are undisturbed.",
		"effects": {}, "choices": [], "resolve_key": "arge_high_branch_reward",
	},

	"arge_river_crossing": {
		"seasons": ["spring", "summer", "fall"], "trees": ["herbivore"], "rarity": "uncommon", "passive": false,
		"species": ["argentinosaurus"],
		"min_stage": 1, "max_stage": 2,
		"flavor": "A broad slow river. The herd does not stop. You follow it in.",
		"effects": {}, "choices": [], "resolve_key": "arge_river_crossing",
	},

	"arge_giant_predator_scent": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "uncommon", "passive": false,
		"species": ["argentinosaurus"],
		"min_stage": 1, "max_stage": 2,
		"flavor": "The adults smell it before you do. They stop walking without agreeing to. You stop because they do.",
		"effects": {}, "choices": [], "resolve_key": "arge_giant_predator_scent",
	},

	# ══ ADULT ═══════════════════════════════════════════════════════════════

	"arge_walking_forest": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["argentinosaurus"],
		"min_stage": 2,
		"flavor": "Branches bend and break as you walk through. Small creatures disappear ahead of you. You do not notice any of this.",
		"effects": {}, "choices": [], "resolve_key": "arge_walking_forest",
	},

	"arge_neck_above_herd": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["argentinosaurus"],
		"min_stage": 2,
		"flavor": "Your head is above everything. You can see the floodplain all the way to the treeline. The herd below you sees nothing.",
		"effects": {}, "choices": [], "resolve_key": "arge_neck_above_herd",
	},

	"arge_predator_tests_giant": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "uncommon", "passive": false,
		"species": ["argentinosaurus"],
		"min_stage": 2,
		"flavor": "It is large enough that lesser animals would run. For you it is a creature that is still working out whether you are a problem or an opportunity.",
		"effects": {}, "choices": [], "resolve_key": "arge_predator_tests_giant",
	},

	"arge_tail_sweep_warning": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["argentinosaurus"],
		"min_stage": 2,
		"flavor": "Your tail is ten meters of moving bone. Something behind you misjudged how much of you there was.",
		"effects": {}, "choices": [], "resolve_key": "arge_tail_sweep_warning",
	},

	"arge_deep_browse_grove": {
		"seasons": ["spring", "summer", "fall"], "trees": ["herbivore"], "rarity": "uncommon", "passive": false,
		"species": ["argentinosaurus"],
		"min_stage": 2,
		"flavor": "A grove of trees so tall that nothing below your height has ever reached them. You stand in the canopy and eat.",
		"effects": {}, "choices": [], "resolve_key": "arge_deep_browse_grove",
	},

	"arge_ground_tremor_march": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["argentinosaurus"],
		"min_stage": 2,
		"flavor": "The herd moves as a body and the earth moves with it. Anything in front of you does the math and leaves.",
		"effects": {}, "choices": [], "resolve_key": "arge_ground_tremor_march",
	},

	"arge_calf_shield": {
		"seasons": ["spring", "summer"], "trees": ["herbivore"], "rarity": "uncommon", "passive": false,
		"species": ["argentinosaurus"],
		"min_stage": 2,
		"flavor": "A small pale shape near the herd edge. You move toward it without deciding to.",
		"effects": {}, "choices": [], "resolve_key": "arge_calf_shield",
	},

	# ══ WOUNDED ADULT ═══════════════════════════════════════════════════════

	"arge_wound_like_cliff": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "uncommon", "passive": false,
		"species": ["argentinosaurus"],
		"min_stage": 2, "require_injured": true,
		"flavor": "The wound is large enough to see from a distance. Large enough that things that would not normally consider you are reconsidering.",
		"effects": {}, "choices": [], "resolve_key": "arge_wound_like_cliff",
	},

	"arge_heavy_limp": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "uncommon", "passive": false,
		"species": ["argentinosaurus"],
		"min_stage": 2, "require_injured": true,
		"flavor": "Your mass means that injured movement is its own kind of problem. Every step costs more than it should. The herd does not slow for you forever.",
		"effects": {}, "choices": [], "resolve_key": "arge_heavy_limp",
	},

	"arge_mud_cooling": {
		"seasons": ["spring", "summer", "fall"], "trees": ["herbivore"], "rarity": "uncommon", "passive": false,
		"species": ["argentinosaurus"],
		"min_stage": 2, "require_injured": true,
		"flavor": "A wet flat of floodplain mud. Wide enough for something your size. You lower yourself toward it.",
		"effects": {}, "choices": [], "resolve_key": "arge_mud_cooling",
	},

	"arge_herd_slows": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "uncommon", "passive": false,
		"species": ["argentinosaurus"],
		"min_stage": 2, "require_injured": true,
		"flavor": "The herd reads your pace and adjusts. You do not know how they know. They just do.",
		"effects": {}, "choices": [], "resolve_key": "arge_herd_slows",
	},

	"arge_neck_held_low": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "uncommon", "passive": false,
		"species": ["argentinosaurus"],
		"min_stage": 2, "require_injured": true,
		"flavor": "Pain or exhaustion keeps your neck down. You see the ground instead of the horizon. It will have to be enough for now.",
		"effects": {}, "choices": [], "resolve_key": "arge_neck_held_low",
	},

	# ══ HERD / SOCIAL ═══════════════════════════════════════════════════════

	"arge_giant_herd_column": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["argentinosaurus"],
		"min_stage": 1,
		"flavor": "The column stretches further than you can see in either direction. You are part of something that looks like a moving ridge from a distance.",
		"effects": {}, "choices": [], "resolve_key": "arge_giant_herd_column",
	},

	"arge_calves_in_wake": {
		"seasons": ["spring", "summer"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["argentinosaurus"],
		"min_stage": 1,
		"flavor": "The young follow in the disturbed ground behind the adults. You were one of them once. You cannot remember it.",
		"effects": {}, "choices": [], "resolve_key": "arge_calves_in_wake",
	},

	"arge_the_slow_turn": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "uncommon", "passive": false,
		"species": ["argentinosaurus"],
		"min_stage": 1,
		"flavor": "A herd this large does not turn quickly. The pivot takes time. In that time, gaps open between the bodies.",
		"effects": {}, "choices": [], "resolve_key": "arge_the_slow_turn",
	},

	"arge_elder_leads_route": {
		"seasons": ["fall", "winter"], "trees": ["herbivore"], "rarity": "uncommon", "passive": false,
		"species": ["argentinosaurus"],
		"min_stage": 1,
		"flavor": "The oldest one changed direction this morning. No one argued. The herd turned with it.",
		"effects": {}, "choices": [], "resolve_key": "arge_elder_leads_route",
	},

	"arge_herd_wall_of_necks": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "uncommon", "passive": false,
		"species": ["argentinosaurus"],
		"min_stage": 2,
		"flavor": "Several giants align side by side. The predator that was circling stops. From where it stands there is no useful direction.",
		"effects": {}, "choices": [], "resolve_key": "arge_herd_wall_of_necks",
	},

	# ══ SEASONAL ════════════════════════════════════════════════════════════

	"arge_spring_floodplain_bloom": {
		"seasons": ["spring"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["argentinosaurus"],
		"flavor": "Rain transforms the floodplain overnight. Low green plants push up through every centimeter of open ground.",
		"effects": {}, "choices": [], "resolve_key": "arge_spring_floodplain_bloom",
	},

	"arge_spring_nesting_ground": {
		"seasons": ["spring"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["argentinosaurus"],
		"flavor": "Hatching season. The nesting ground is warm and full of pale soft shapes that were eggs three days ago.",
		"effects": {}, "choices": [], "resolve_key": "arge_spring_nesting_ground",
	},

	"arge_summer_heat_over_giant": {
		"seasons": ["summer"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["argentinosaurus"],
		"flavor": "A body this large holds heat long after the air cools. The sun has not helped.",
		"effects": {}, "choices": [], "resolve_key": "arge_summer_heat_over_giant",
	},

	"arge_summer_dry_riverbed": {
		"seasons": ["summer"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["argentinosaurus"],
		"flavor": "The river pulled back weeks ago. The bed it left is wide and cracked and still holds secrets.",
		"effects": {}, "choices": [], "resolve_key": "arge_summer_dry_riverbed",
	},

	"arge_fall_migration_pull": {
		"seasons": ["fall"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["argentinosaurus"],
		"flavor": "Something in the air changes. The herd shifts direction before anyone says to.",
		"effects": {}, "choices": [], "resolve_key": "arge_fall_migration_pull",
	},

	"arge_fall_old_growth_grove": {
		"seasons": ["fall"], "trees": ["herbivore"], "rarity": "uncommon", "passive": false,
		"species": ["argentinosaurus"],
		"flavor": "Trees so old they have names no one gave them. Their canopy holds food from a season that is almost over.",
		"effects": {}, "choices": [], "resolve_key": "arge_fall_old_growth_grove",
	},

	"arge_winter_bare_floodplain": {
		"seasons": ["winter"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["argentinosaurus"],
		"flavor": "The floodplain in winter is flat and empty and honest about it. Food is somewhere. You can see for kilometers and it is not here.",
		"effects": {}, "choices": [], "resolve_key": "arge_winter_bare_floodplain",
	},

	"arge_winter_dust_herd": {
		"seasons": ["winter"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["argentinosaurus"],
		"flavor": "Dry wind lifts the plain into the air. The herd disappears into itself, visible only as shapes and sound.",
		"effects": {}, "choices": [], "resolve_key": "arge_winter_dust_herd",
	},

	# ══ RARE ════════════════════════════════════════════════════════════════

	"arge_mapusaurus_pressure": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "rare", "passive": false,
		"species": ["argentinosaurus"],
		"min_stage": 1,
		"flavor": "A predator built to hunt giants has been trailing the herd for two days. It is not looking for a fight. It is looking for a gap.",
		"effects": {}, "choices": [], "resolve_key": "arge_mapusaurus_pressure",
	},

	"arge_earth_shaking_step": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "rare", "passive": false,
		"species": ["argentinosaurus"],
		"min_stage": 2,
		"flavor": "Your foot comes down on solid ground and the ground disagrees about being solid. The impact spreads outward in every direction.",
		"effects": {}, "choices": [], "resolve_key": "arge_earth_shaking_step",
	},

	"arge_giant_falls_nearby": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "rare", "passive": false,
		"species": ["argentinosaurus"],
		"flavor": "An enormous sauropod goes down. Not quickly. It takes a long time for something that large to finish falling.",
		"effects": {}, "choices": [], "resolve_key": "arge_giant_falls_nearby",
	},

	"arge_volcano_ash_drift": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "rare", "passive": false,
		"species": ["argentinosaurus"],
		"flavor": "Fine grey ash drifts down from a sky that was clear yesterday. It settles on everything evenly, without preference.",
		"effects": {}, "choices": [], "resolve_key": "arge_volcano_ash_drift",
	},

	"arge_living_horizon": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "rare", "passive": false,
		"species": ["argentinosaurus"],
		"min_stage": 2,
		"flavor": "From a hillside kilometers away, the herd looks like the land itself is migrating. Something that size does not get tested. It gets avoided.",
		"effects": {}, "choices": [], "resolve_key": "arge_living_horizon",
	},

}
