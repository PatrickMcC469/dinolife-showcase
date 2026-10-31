extends Node

# ─── Ankylosaurus Events ──────────────────────────────────────────────────────
# 40 events: 5 juvenile, 5 subadult, 7 adult, 5 wounded adult, 5 social,
#            8 seasonal, 5 rare
# Species: ankylosaurus   Tree: herbivore
# Defining mechanic: tail club and armor plating
# ─────────────────────────────────────────────────────────────────────────────

const OUTCOME_EVENTS: Dictionary = {

	# ══ JUVENILE ════════════════════════════════════════════════════════════

	"anky_pebble_armor": {
		"w_buff": 0.12, "w_food": 0.28, "w_health": 0.18, "w_nothing": 0.30, "w_debuff": 0.12,
		"buff":   { "stat": "defense", "amount": 0.10, "turns": 2, "source": "anky_pebble_armor", "flavor": "You crouch low, learning how to keep your soft young plates between you and danger." },
		"food":   { "hunger": 0.12, "flavor": "Soft shoots curl beneath a low shrub." },
		"health": { "health": 0.08, "flavor": "Resting low in cover, your body settles." },
		"debuff": { "stat": "hunger", "amount": -0.10, "flavor": "You freeze too long. Stress burns through your reserves." },
	},

	"anky_first_tail_swing": {
		"w_buff": 0.12, "w_food": 0.26, "w_health": 0.18, "w_nothing": 0.32, "w_debuff": 0.12,
		"buff":   { "stat": "defense", "amount": 0.08, "turns": 3, "source": "anky_first_tail_swing", "flavor": "The swing lands cleanly. You begin to feel how to guide the weight of your tail." },
		"food":   { "hunger": 0.10, "flavor": "Your swing knocks loose edible leaves." },
		"health": { "health": 0.07, "flavor": "A few steady swings loosen your muscles. You finish practice feeling stronger." },
		"debuff": { "stat": "speed", "amount": -0.08, "turns": 2, "source": "anky_first_tail_swing", "flavor": "You twist too hard. Your hip seizes." },
	},

	"anky_low_fern_snack": {
		"w_buff": 0.12, "w_food": 0.32, "w_health": 0.20, "w_nothing": 0.26, "w_debuff": 0.10,
		"buff":   { "stat": "type_stat", "amount": 0.08, "turns": 3, "source": "anky_low_fern_snack", "flavor": "You learn where the low things grow." },
		"food":   { "hunger": 0.14, "flavor": "Soft ferns, exactly where you expected." },
		"health": { "health": 0.08, "flavor": "Easy food makes everything easier." },
		"debuff": { "health": -0.06, "flavor": "Bitter leaves coat your tongue. Your stomach turns." },
	},

	"anky_hide_under_adult": {
		"w_buff": 0.12, "w_food": 0.26, "w_health": 0.20, "w_nothing": 0.30, "w_debuff": 0.12,
		"buff":   { "stat": "defense", "amount": 0.12, "turns": 2, "source": "anky_hide_under_adult", "flavor": "Under the bulk of another, nothing can see you." },
		"food":   { "hunger": 0.10, "flavor": "The adult's shuffling steps expose buried roots." },
		"health": { "health": 0.08, "flavor": "You rest in a space nothing dares enter." },
		"debuff": { "health": -0.08, "flavor": "The adult shifts its weight. You take the hit." },
	},

	"anky_shell_curl_instinct": {
		"w_buff": 0.12, "w_food": 0.28, "w_health": 0.20, "w_nothing": 0.30, "w_debuff": 0.10,
		"buff":   { "stat": "defense", "amount": 0.10, "turns": 2, "source": "anky_shell_curl_instinct", "flavor": "Flat against the ground, your armor becomes the ground." },
		"food":   { "hunger": 0.11, "flavor": "Crouched low, you find roots you never noticed before." },
		"health": { "health": 0.08, "flavor": "Stillness is its own kind of rest." },
		"debuff": { "stat": "speed", "amount": -0.08, "turns": 2, "source": "anky_shell_curl_instinct", "flavor": "You stayed curled too long. Your legs protest." },
	},

	# ══ SUBADULT ════════════════════════════════════════════════════════════

	"anky_club_bone_practice": {
		"w_buff": 0.12, "w_food": 0.26, "w_health": 0.18, "w_nothing": 0.32, "w_debuff": 0.12,
		"buff":   { "stat": "defense", "amount": 0.12, "turns": 3, "source": "anky_club_bone_practice", "flavor": "The weight of your tail starts to feel like a weapon." },
		"food":   { "hunger": 0.12, "flavor": "The impact shakes down a scatter of leaves." },
		"health": { "health": 0.09, "flavor": "Controlled practice builds stamina you did not know you had." },
		"debuff": { "stat": "defense", "amount": -0.10, "turns": 2, "source": "anky_club_bone_practice", "flavor": "Your tail aches from the strain. Defense suffers for it." },
	},

	"anky_tough_root_patch": {
		"w_buff": 0.12, "w_food": 0.32, "w_health": 0.18, "w_nothing": 0.28, "w_debuff": 0.10,
		"buff":   { "stat": "type_stat", "amount": 0.10, "turns": 3, "source": "anky_tough_root_patch", "flavor": "You learn to read the ground. Hard surface, soft treasure beneath." },
		"food":   { "hunger": 0.16, "flavor": "Roots, dense and fibrous, pulled free from packed earth." },
		"health": { "health": 0.10, "flavor": "Rich roots leave you feeling solid." },
		"debuff": { "stat": "speed", "amount": -0.08, "turns": 2, "source": "anky_tough_root_patch", "flavor": "Digging tires your forelimbs." },
	},

	"anky_predator_sniffing": {
		"w_buff": 0.12, "w_food": 0.24, "w_health": 0.18, "w_nothing": 0.30, "w_debuff": 0.16,
		"buff":   { "stat": "defense", "amount": 0.12, "turns": 2, "source": "anky_predator_sniffing", "flavor": "You turn slowly, armor always facing the threat. It cannot find a way in." },
		"food":   { "hunger": 0.12, "flavor": "Its circling pushes you toward a patch you had not noticed." },
		"health": { "health": 0.08, "flavor": "Holding your ground costs nothing." },
		"debuff": { "health": -0.10, "flavor": "It snaps at your leg before retreating. Blood runs down your ankle." },
	},

	"anky_armor_itch": {
		"w_buff": 0.12, "w_food": 0.26, "w_health": 0.20, "w_nothing": 0.32, "w_debuff": 0.10,
		"buff":   { "stat": "type_stat", "amount": 0.08, "turns": 2, "source": "anky_armor_itch", "flavor": "Bark scraping, parasites gone. You feel cleaner than you have in days." },
		"food":   { "hunger": 0.10, "flavor": "Rubbing against the tree exposes edible plant matter beneath the bark." },
		"health": { "health": 0.10, "flavor": "Without the itch, your body relaxes and heals." },
		"debuff": { "stat": "hunger", "amount": -0.10, "flavor": "The parasites stay. You scratch until exhausted." },
	},

	"anky_mud_armor": {
		"w_buff": 0.14, "w_food": 0.26, "w_health": 0.20, "w_nothing": 0.30, "w_debuff": 0.10,
		"buff":   { "stat": "defense", "amount": 0.12, "turns": 3, "source": "anky_mud_armor", "flavor": "Mud fills every joint and seam. You are harder to reach than usual." },
		"food":   { "hunger": 0.12, "flavor": "The wet ground reveals buried roots." },
		"health": { "health": 0.10, "flavor": "The cool mud draws heat and fatigue out of your body." },
		"debuff": { "stat": "speed", "amount": -0.10, "turns": 2, "source": "anky_mud_armor", "flavor": "The mud sets. Every step is heavier than the last." },
	},

	# ══ ADULT ════════════════════════════════════════════════════════════════

	"anky_tail_club_warning": {
		"w_buff": 0.12, "w_food": 0.24, "w_health": 0.18, "w_nothing": 0.32, "w_debuff": 0.14,
		"buff":   { "stat": "type_stat", "amount": 0.12, "turns": 3, "source": "anky_tail_club_warning", "flavor": "The sound of bone scraping earth is enough. It stops." },
		"food":   { "hunger": 0.14, "flavor": "With it gone, you feed without looking over your shoulder." },
		"health": { "health": 0.10, "flavor": "A threat avoided costs you nothing." },
		"debuff": { "health": -0.10, "flavor": "It does not stop. It tests you. You pay for holding the line." },
	},

	"anky_sideways_stand": {
		"w_buff": 0.12, "w_food": 0.26, "w_health": 0.18, "w_nothing": 0.32, "w_debuff": 0.12,
		"buff":   { "stat": "defense", "amount": 0.14, "turns": 3, "source": "anky_sideways_stand", "flavor": "Side on, tail ready, armor forward. There is no good angle for anything hungry." },
		"food":   { "hunger": 0.14, "flavor": "You hold the feeding ground. It gives up." },
		"health": { "health": 0.10, "flavor": "A defensive posture that costs you nothing preserves everything." },
		"debuff": { "stat": "hunger", "amount": -0.10, "flavor": "Holding tension for that long drains more than expected." },
	},

	"anky_trex_test_bite": {
		"w_buff": 0.10, "w_food": 0.20, "w_health": 0.18, "w_nothing": 0.30, "w_debuff": 0.22,
		"buff":   { "stat": "type_stat", "amount": 0.14, "turns": 3, "source": "anky_trex_test_bite", "flavor": "You held. The rex remembered. Something in you settles permanently." },
		"food":   { "hunger": 0.14, "flavor": "Its retreat leaves you the clearing. You feed in silence." },
		"health": { "health": 0.10, "flavor": "Your armor held. Confidence is its own kind of recovery." },
		"debuff": { "health": -0.20, "flavor": "Jaws the size of your skull close around you. Your armor holds, but what is beneath does not." },
	},

	"anky_bone_breaking_swing": {
		"w_buff": 0.14, "w_food": 0.24, "w_health": 0.18, "w_nothing": 0.28, "w_debuff": 0.16,
		"buff":   { "stat": "defense", "amount": 0.16, "turns": 3, "source": "anky_bone_breaking_swing", "flavor": "You felt it connect. Your tail is not just a warning anymore." },
		"food":   { "hunger": 0.14, "flavor": "The area empties. The plants are yours." },
		"health": { "health": 0.12, "flavor": "A clean win. Nothing broken, nothing lost." },
		"debuff": { "stat": "defense", "amount": -0.12, "turns": 2, "source": "anky_bone_breaking_swing", "flavor": "You over-swing. The strain in your tail base costs you later." },
	},

	"anky_low_browse_corridor": {
		"w_buff": 0.12, "w_food": 0.32, "w_health": 0.20, "w_nothing": 0.26, "w_debuff": 0.10,
		"buff":   { "stat": "speed", "amount": 0.10, "turns": 2, "source": "anky_low_browse_corridor", "flavor": "A path made for you, by the shape of the world." },
		"food":   { "hunger": 0.16, "flavor": "Untouched plants. Nothing else fits through here." },
		"health": { "health": 0.10, "flavor": "The corridor offers shelter nothing can follow you into." },
		"debuff": { "stat": "hunger", "amount": -0.10, "flavor": "You wedge yourself in too far. Getting out costs more than you found." },
	},

	"anky_armor_plates_sun": {
		"w_buff": 0.12, "w_food": 0.26, "w_health": 0.20, "w_nothing": 0.32, "w_debuff": 0.10,
		"buff":   { "stat": "type_stat", "amount": 0.10, "turns": 2, "source": "anky_armor_plates_sun", "flavor": "Warmth spreads through the bone of your armor into your body beneath." },
		"food":   { "hunger": 0.12, "flavor": "Sunlit plants nearby. Easy and warm." },
		"health": { "health": 0.10, "flavor": "Heat restores something rest alone cannot." },
		"debuff": { "stat": "hunger", "amount": -0.12, "flavor": "Your armor traps too much. You overheat before you can move to shade." },
	},

	"anky_rock_like_stillness": {
		"w_buff": 0.12, "w_food": 0.24, "w_health": 0.18, "w_nothing": 0.34, "w_debuff": 0.12,
		"buff":   { "stat": "type_stat", "amount": 0.12, "turns": 3, "source": "anky_rock_like_stillness", "flavor": "You stopped moving. The world forgot about you." },
		"food":   { "hunger": 0.12, "flavor": "Once safe, the nearby plants reveal themselves." },
		"health": { "health": 0.10, "flavor": "Stillness is rest. The land does the work." },
		"debuff": { "stat": "hunger", "amount": -0.12, "flavor": "You wait too long. Stillness becomes hunger." },
	},

	# ══ WOUNDED ADULT ═══════════════════════════════════════════════════════

	"anky_bruised_under_armor": {
		"w_buff": 0.12, "w_food": 0.24, "w_health": 0.22, "w_nothing": 0.28, "w_debuff": 0.14,
		"buff":   { "stat": "defense", "amount": 0.10, "turns": 2, "source": "anky_bruised_under_armor", "flavor": "Pain teaches you where to brace. You hold tighter." },
		"food":   { "hunger": 0.12, "flavor": "You choose the nearest plants. Close is enough." },
		"health": { "health": 0.10, "flavor": "Rest works slowly on deep bruises. You take what you can get." },
		"debuff": { "health": -0.10, "flavor": "The hidden bruise worsens. Rest healing feels like nothing." },
	},

	"anky_tail_club_strain": {
		"w_buff": 0.12, "w_food": 0.24, "w_health": 0.22, "w_nothing": 0.28, "w_debuff": 0.14,
		"buff":   { "stat": "defense", "amount": 0.10, "turns": 2, "source": "anky_tail_club_strain", "flavor": "You learn to hold back. The swing you do not take cannot hurt you." },
		"food":   { "hunger": 0.12, "flavor": "You feed quietly, tail at rest." },
		"health": { "health": 0.10, "flavor": "Careful stillness gives the injury space to settle." },
		"debuff": { "stat": "defense", "amount": -0.12, "turns": 3, "source": "anky_tail_club_strain", "flavor": "The strain in your tail base makes every move a risk." },
	},

	"anky_blood_between_plates": {
		"w_buff": 0.12, "w_food": 0.22, "w_health": 0.22, "w_nothing": 0.28, "w_debuff": 0.16,
		"buff":   { "stat": "defense", "amount": 0.10, "turns": 2, "source": "anky_blood_between_plates", "flavor": "Mud seals the gap. The scent drops. The insects leave." },
		"food":   { "hunger": 0.12, "flavor": "Roots near the mud wallow, easy to reach." },
		"health": { "health": 0.10, "flavor": "The clean water pulls heat from the wound." },
		"debuff": { "health": -0.12, "flavor": "Something gets in. The seam between plates becomes a slow problem." },
	},

	"anky_slow_untouchable": {
		"w_buff": 0.12, "w_food": 0.22, "w_health": 0.20, "w_nothing": 0.30, "w_debuff": 0.16,
		"buff":   { "stat": "defense", "amount": 0.12, "turns": 2, "source": "anky_slow_untouchable", "flavor": "Even injured, you are more trouble than you are worth. They know it." },
		"food":   { "hunger": 0.10, "flavor": "You do not need to travel far. Low food is enough for now." },
		"health": { "health": 0.10, "flavor": "Slow and deliberate. Every step costs nothing you cannot afford." },
		"debuff": { "stat": "hunger", "amount": -0.10, "flavor": "Moving this slowly means falling behind the best feeding grounds." },
	},

	"anky_safe_against_stone": {
		"w_buff": 0.12, "w_food": 0.22, "w_health": 0.24, "w_nothing": 0.28, "w_debuff": 0.14,
		"buff":   { "stat": "defense", "amount": 0.12, "turns": 2, "source": "anky_safe_against_stone", "flavor": "Stone on one side, armor on the other. Nothing can reach you from behind." },
		"food":   { "hunger": 0.10, "flavor": "Moss and low plants grow thick near the rock face." },
		"health": { "health": 0.12, "flavor": "Protected on all sides, your body finally rests." },
		"debuff": { "stat": "speed", "amount": -0.10, "turns": 2, "source": "anky_safe_against_stone", "flavor": "You rest too long against the stone. Rising takes everything you have." },
	},

	# ══ SOCIAL ══════════════════════════════════════════════════════════════

	"anky_armored_neighbors": {
		"w_buff": 0.12, "w_food": 0.26, "w_health": 0.18, "w_nothing": 0.32, "w_debuff": 0.12,
		"buff":   { "stat": "defense", "amount": 0.10, "turns": 2, "source": "anky_armored_neighbors", "flavor": "Two sets of armor are harder to ignore than one." },
		"food":   { "hunger": 0.12, "flavor": "Shared grazing opens up a patch neither of you noticed alone." },
		"health": { "health": 0.10, "flavor": "Near another, the alertness drops. Rest comes easier." },
		"debuff": { "stat": "hunger", "amount": -0.10, "flavor": "Competition over the same plant patch pushes you away empty." },
	},

	"anky_club_distance": {
		"w_buff": 0.12, "w_food": 0.24, "w_health": 0.16, "w_nothing": 0.32, "w_debuff": 0.16,
		"buff":   { "stat": "type_stat", "amount": 0.10, "turns": 2, "source": "anky_club_distance", "flavor": "You learn the reach of others. You do not need to be friends. You just need to not be in range." },
		"food":   { "hunger": 0.12, "flavor": "You find another patch, away from the tension." },
		"health": { "health": 0.08, "flavor": "Conflict avoided is energy saved." },
		"debuff": { "health": -0.10, "flavor": "The tail catches you before you step back. A lesson in distance." },
	},

	"anky_armored_calf_alert": {
		"w_buff": 0.12, "w_food": 0.24, "w_health": 0.16, "w_nothing": 0.32, "w_debuff": 0.16,
		"buff":   { "stat": "defense", "amount": 0.12, "turns": 2, "source": "anky_armored_calf_alert", "flavor": "The calf's safety and yours are the same thing right now." },
		"food":   { "hunger": 0.10, "flavor": "The calf's path cuts through soft plants." },
		"health": { "health": 0.08, "flavor": "The area feels calmer with the calf back in cover." },
		"debuff": { "health": -0.10, "flavor": "Positioning yourself between the calf and the tree line costs you." },
	},

	"anky_shared_mud_wallow": {
		"w_buff": 0.14, "w_food": 0.24, "w_health": 0.20, "w_nothing": 0.30, "w_debuff": 0.12,
		"buff":   { "stat": "defense", "amount": 0.10, "turns": 2, "source": "anky_shared_mud_wallow", "flavor": "Layered mud, shared heat, shared safety. The routine settles in." },
		"food":   { "hunger": 0.12, "flavor": "Wet roots push up through the disturbed wallow edge." },
		"health": { "health": 0.10, "flavor": "Cool mud and company lower your guard. Rest comes deeper." },
		"debuff": { "health": -0.08, "flavor": "Crowded. Irritable. Someone's flank presses yours harder than it should." },
	},

	"anky_territory_scrape": {
		"w_buff": 0.12, "w_food": 0.24, "w_health": 0.16, "w_nothing": 0.32, "w_debuff": 0.16,
		"buff":   { "stat": "type_stat", "amount": 0.10, "turns": 2, "source": "anky_territory_scrape", "flavor": "You read the marks and know exactly where not to go — and where to find what you need." },
		"food":   { "hunger": 0.12, "flavor": "The marks lead you along a feeding route you would not have found otherwise." },
		"health": { "health": 0.08, "flavor": "You take the hint and rest safely where no one has claimed." },
		"debuff": { "health": -0.10, "flavor": "You stepped too close. The original owner has not left yet." },
	},

	# ══ SEASONAL ════════════════════════════════════════════════════════════

	"anky_spring_soft_growth": {
		"w_buff": 0.12, "w_food": 0.32, "w_health": 0.20, "w_nothing": 0.26, "w_debuff": 0.10,
		"buff":   { "stat": "type_stat", "amount": 0.10, "turns": 3, "source": "anky_spring_soft_growth", "flavor": "New growth restores more than hunger. Everything feels easier." },
		"food":   { "hunger": 0.16, "flavor": "Ground-level plants, soft and thick after the rain." },
		"health": { "health": 0.12, "flavor": "Fresh growth is dense with everything your body needs." },
		"debuff": { "health": -0.08, "flavor": "Something new in the growth does not agree with you." },
	},

	"anky_spring_rain_slick": {
		"w_buff": 0.12, "w_food": 0.26, "w_health": 0.18, "w_nothing": 0.32, "w_debuff": 0.12,
		"buff":   { "stat": "speed", "amount": 0.10, "turns": 2, "source": "anky_spring_rain_slick", "flavor": "Your weight works with you on wet ground instead of against you." },
		"food":   { "hunger": 0.12, "flavor": "Rain loosens the soil. Roots and shoots come free." },
		"health": { "health": 0.10, "flavor": "Cool rain washes the dust from your plates." },
		"debuff": { "stat": "speed", "amount": -0.10, "turns": 2, "source": "anky_spring_rain_slick", "flavor": "Your feet find the wrong patch. The slope takes you somewhere unplanned." },
	},

	"anky_summer_heat_plates": {
		"w_buff": 0.12, "w_food": 0.24, "w_health": 0.18, "w_nothing": 0.32, "w_debuff": 0.14,
		"buff":   { "stat": "type_stat", "amount": 0.10, "turns": 2, "source": "anky_summer_heat_plates", "flavor": "You find shade before it becomes a problem. Your body thanks you." },
		"food":   { "hunger": 0.12, "flavor": "Shade plants stay tender through the worst of the heat." },
		"health": { "health": 0.10, "flavor": "Shade and stillness are their own kind of medicine." },
		"debuff": { "stat": "hunger", "amount": -0.12, "flavor": "Your armor traps the heat too long. Stamina bleeds away before you can stop it." },
	},

	"anky_summer_dry_root_dig": {
		"w_buff": 0.12, "w_food": 0.32, "w_health": 0.18, "w_nothing": 0.28, "w_debuff": 0.10,
		"buff":   { "stat": "type_stat", "amount": 0.10, "turns": 3, "source": "anky_summer_dry_root_dig", "flavor": "Where nothing else can find food, you know where to look." },
		"food":   { "hunger": 0.16, "flavor": "Roots survive what drought kills above ground." },
		"health": { "health": 0.10, "flavor": "Dense underground food restores what the heat took." },
		"debuff": { "stat": "hunger", "amount": -0.12, "flavor": "The digging in hard dry earth costs more than what you pull up." },
	},

	"anky_fall_heavy_feeding": {
		"w_buff": 0.12, "w_food": 0.34, "w_health": 0.20, "w_nothing": 0.24, "w_debuff": 0.10,
		"buff":   { "stat": "type_stat", "amount": 0.12, "turns": 3, "source": "anky_fall_heavy_feeding", "flavor": "You eat like there is no tomorrow, because the calendar agrees." },
		"food":   { "hunger": 0.18, "flavor": "Low-browse patch, rich and untouched." },
		"health": { "health": 0.12, "flavor": "Full. Actually full. Your body remembers this feeling." },
		"debuff": { "stat": "speed", "amount": -0.10, "turns": 2, "source": "anky_fall_heavy_feeding", "flavor": "You ate too much to move quickly. The extra weight shows." },
	},

	"anky_fall_predator_pressure": {
		"w_buff": 0.12, "w_food": 0.24, "w_health": 0.18, "w_nothing": 0.30, "w_debuff": 0.16,
		"buff":   { "stat": "defense", "amount": 0.12, "turns": 2, "source": "anky_fall_predator_pressure", "flavor": "You read the rhythm of the season. You hold your ground and it passes." },
		"food":   { "hunger": 0.14, "flavor": "It circles but does not commit. You take the space it leaves." },
		"health": { "health": 0.10, "flavor": "You hold ground. No wound. You come out ahead." },
		"debuff": { "health": -0.12, "flavor": "It finds the gap between your armor at your flank. You pay for it." },
	},

	"anky_winter_tough_browse": {
		"w_buff": 0.12, "w_food": 0.28, "w_health": 0.16, "w_nothing": 0.32, "w_debuff": 0.12,
		"buff":   { "stat": "type_stat", "amount": 0.10, "turns": 3, "source": "anky_winter_tough_browse", "flavor": "Tough plants are plants. You have learned not to be choosy." },
		"food":   { "hunger": 0.12, "flavor": "Fibrous and rough, but edible. It is enough." },
		"health": { "health": 0.08, "flavor": "Slow, steady eating stabilizes more than it restores." },
		"debuff": { "health": -0.08, "flavor": "The poor quality grinds through you without giving much back." },
	},

	"anky_winter_cold_armor": {
		"w_buff": 0.12, "w_food": 0.24, "w_health": 0.18, "w_nothing": 0.34, "w_debuff": 0.12,
		"buff":   { "stat": "defense", "amount": 0.10, "turns": 2, "source": "anky_winter_cold_armor", "flavor": "You learn to time it. Wait for the sun, then move." },
		"food":   { "hunger": 0.10, "flavor": "Sunlit patches reveal plants that stayed protected overnight." },
		"health": { "health": 0.10, "flavor": "Warm sun is its own medicine on a cold morning." },
		"debuff": { "stat": "defense", "amount": -0.10, "turns": 2, "source": "anky_winter_cold_armor", "flavor": "The cold works into your joints overnight. Your armor is slower to respond." },
	},

	# ══ RARE ════════════════════════════════════════════════════════════════

	"anky_rex_learns": {
		"w_buff": 0.14, "w_food": 0.22, "w_health": 0.18, "w_nothing": 0.28, "w_debuff": 0.18,
		"buff":   { "stat": "type_stat", "amount": 0.14, "turns": 0, "perm": true, "perm_label": "Apex Deterrent", "source": "anky_rex_learns", "flavor": "The largest predator on earth tried you and walked away. Everything else already knows." },
		"food":   { "hunger": 0.16, "flavor": "The clearing is yours. You feed in silence." },
		"health": { "health": 0.14, "flavor": "The standoff is over. Your body unclenches." },
		"debuff": { "health": -0.22, "flavor": "You landed the swing. You also took a bite that nearly ended everything." },
	},

	"anky_club_meets_bone": {
		"w_buff": 0.14, "w_food": 0.22, "w_health": 0.18, "w_nothing": 0.28, "w_debuff": 0.18,
		"buff":   { "stat": "strength", "amount": 0.16, "turns": 0, "perm": true, "perm_label": "Bone Breaker", "source": "anky_club_meets_bone", "flavor": "You know what your tail can do now. The weight is no longer heavy — it is purpose." },
		"food":   { "hunger": 0.14, "flavor": "The area clears itself. The plants are yours." },
		"health": { "health": 0.12, "flavor": "You avoid further conflict. The field is yours." },
		"debuff": { "health": -0.18, "flavor": "The impact travels back through your tail. The base aches in a way that will not pass quickly." },
	},

	"anky_armor_scar_memory": {
		"w_buff": 0.14, "w_food": 0.20, "w_health": 0.18, "w_nothing": 0.32, "w_debuff": 0.16,
		"buff":   { "stat": "defense", "amount": 0.14, "turns": 0, "perm": true, "perm_label": "Scarred Plates", "source": "anky_armor_scar_memory", "flavor": "Every scar is a lesson that stuck. Your armor remembers everything." },
		"food":   { "hunger": 0.12, "flavor": "A familiar feeding ground. Muscle memory brings you here without thinking." },
		"health": { "health": 0.12, "flavor": "With danger behind you, your breathing settles. You finally rest without flinching at every sound." },
		"debuff": { "stat": "hunger", "amount": -0.12, "flavor": "Old scars ache in the cold. Your stamina pays for it." },
	},

	"anky_perfect_wallow": {
		"w_buff": 0.14, "w_food": 0.22, "w_health": 0.22, "w_nothing": 0.26, "w_debuff": 0.16,
		"buff":   { "stat": "defense", "amount": 0.16, "turns": 4, "source": "anky_perfect_wallow", "flavor": "Shaded, deep, and cool. Every joint fills with mud. Every threat slips off." },
		"food":   { "hunger": 0.16, "flavor": "Wet roots and soft plants surround the edge of the wallow." },
		"health": { "health": 0.16, "flavor": "Everything that hurt stops hurting. For now." },
		"debuff": { "stat": "hunger", "amount": -0.14, "flavor": "You sank deeper than intended. Getting out was a fight of its own." },
	},

	"anky_living_rock": {
		"w_buff": 0.14, "w_food": 0.20, "w_health": 0.20, "w_nothing": 0.32, "w_debuff": 0.14,
		"buff":   { "stat": "defense", "amount": 0.14, "turns": 3, "source": "anky_living_rock", "flavor": "It walked around you. You did not breathe. You were not there." },
		"food":   { "hunger": 0.14, "flavor": "Once it is gone, the plants are still there, untouched." },
		"health": { "health": 0.14, "flavor": "Safe stillness restores more than movement ever could." },
		"debuff": { "stat": "hunger", "amount": -0.14, "flavor": "Too long. Way too long. Your body ran low while you waited." },
	},

}

const EVENTS: Dictionary = {

	# ══ JUVENILE ════════════════════════════════════════════════════════════

	"anky_pebble_armor": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["ankylosaurus"],
		"max_stage": 1,
		"flavor": "Your armor plates are soft and pale. They are not protection yet, but they will be. You crouch low when a shape crosses the light above you.",
		"effects": {}, "choices": [], "resolve_key": "anky_pebble_armor",
	},

	"anky_first_tail_swing": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["ankylosaurus"],
		"max_stage": 1,
		"flavor": "Your tail is heavier than the rest of you, or it feels that way. You swing it at a buzzing insect and miss by several body lengths.",
		"effects": {}, "choices": [], "resolve_key": "anky_first_tail_swing",
	},

	"anky_low_fern_snack": {
		"seasons": ["spring", "summer"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["ankylosaurus"],
		"max_stage": 1,
		"flavor": "The ferns are exactly mouth height. The world seems to have been arranged for someone your size.",
		"effects": {}, "choices": [], "resolve_key": "anky_low_fern_snack",
	},

	"anky_hide_under_adult": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["ankylosaurus"],
		"max_stage": 1,
		"flavor": "A larger armored shape blocks the sky above you. You do not know it. You stay close anyway.",
		"effects": {}, "choices": [], "resolve_key": "anky_hide_under_adult",
	},

	"anky_shell_curl_instinct": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["ankylosaurus"],
		"max_stage": 1,
		"flavor": "Something passes overhead. Before you decide to, your body flattens and your limbs tuck close.",
		"effects": {}, "choices": [], "resolve_key": "anky_shell_curl_instinct",
	},

	# ══ SUBADULT ════════════════════════════════════════════════════════════

	"anky_club_bone_practice": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["ankylosaurus"],
		"min_stage": 1, "max_stage": 2,
		"flavor": "The dead branch is not a threat. That is why you chose it. Your tail club is getting real, and you want to know what it can do.",
		"effects": {}, "choices": [], "resolve_key": "anky_club_bone_practice",
	},

	"anky_tough_root_patch": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["ankylosaurus"],
		"min_stage": 1, "max_stage": 2,
		"flavor": "The surface is packed solid. Something good is underneath. You can feel it.",
		"effects": {}, "choices": [], "resolve_key": "anky_tough_root_patch",
	},

	"anky_predator_sniffing": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "uncommon", "passive": false,
		"species": ["ankylosaurus"],
		"min_stage": 1, "max_stage": 2,
		"flavor": "It does not charge. It walks the perimeter, head low, reading you. You turn slowly, keeping your armor between the two of you.",
		"effects": {}, "choices": [], "resolve_key": "anky_predator_sniffing",
	},

	"anky_armor_itch": {
		"seasons": ["spring", "summer"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["ankylosaurus"],
		"min_stage": 1, "max_stage": 2,
		"flavor": "Something moves beneath your armor. Between the plates, where you cannot reach. You find a tree and press hard.",
		"effects": {}, "choices": [], "resolve_key": "anky_armor_itch",
	},

	"anky_mud_armor": {
		"seasons": ["spring", "summer", "fall"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["ankylosaurus"],
		"min_stage": 1, "max_stage": 2,
		"flavor": "Soft mud, just deep enough. You lower yourself in and feel your plates fill with cool weight.",
		"effects": {}, "choices": [], "resolve_key": "anky_mud_armor",
	},

	# ══ ADULT ═══════════════════════════════════════════════════════════════

	"anky_tail_club_warning": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["ankylosaurus"],
		"min_stage": 2,
		"flavor": "You drag your tail club across the ground. The sound it makes is its own kind of language.",
		"effects": {}, "choices": [], "resolve_key": "anky_tail_club_warning",
	},

	"anky_sideways_stand": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "uncommon", "passive": false,
		"species": ["ankylosaurus"],
		"min_stage": 2,
		"flavor": "You shift your body sideways, presenting the widest possible wall of armor, tail ready at the far end.",
		"effects": {}, "choices": [], "resolve_key": "anky_sideways_stand",
	},

	"anky_trex_test_bite": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "uncommon", "passive": false,
		"species": ["ankylosaurus"],
		"min_stage": 2,
		"flavor": "The largest predator alive walks toward you without hurrying. It is not afraid. It is just deciding whether you are worth the effort.",
		"effects": {}, "choices": [], "resolve_key": "anky_trex_test_bite",
	},

	"anky_bone_breaking_swing": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "uncommon", "passive": false,
		"species": ["ankylosaurus"],
		"min_stage": 2,
		"flavor": "It is inside your range and does not know it yet.",
		"effects": {}, "choices": [], "resolve_key": "anky_bone_breaking_swing",
	},

	"anky_low_browse_corridor": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["ankylosaurus"],
		"min_stage": 2,
		"flavor": "A tunnel of shrubs and low growth, too low for anything larger. It opens ahead like an invitation.",
		"effects": {}, "choices": [], "resolve_key": "anky_low_browse_corridor",
	},

	"anky_armor_plates_sun": {
		"seasons": ["spring", "summer"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["ankylosaurus"],
		"min_stage": 2,
		"flavor": "The sun climbs slowly across your back. Your armor warms from the outside in.",
		"effects": {}, "choices": [], "resolve_key": "anky_armor_plates_sun",
	},

	"anky_rock_like_stillness": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "uncommon", "passive": false,
		"species": ["ankylosaurus"],
		"min_stage": 2,
		"flavor": "Danger moves nearby. You stop everything. Not just movement — everything. You become part of the landscape.",
		"effects": {}, "choices": [], "resolve_key": "anky_rock_like_stillness",
	},

	# ══ WOUNDED ADULT ═══════════════════════════════════════════════════════

	"anky_bruised_under_armor": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "uncommon", "passive": false,
		"species": ["ankylosaurus"],
		"min_stage": 2, "require_injured": true,
		"flavor": "Your plates held. But something underneath did not. Every step tells you where.",
		"effects": {}, "choices": [], "resolve_key": "anky_bruised_under_armor",
	},

	"anky_tail_club_strain": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "uncommon", "passive": false,
		"species": ["ankylosaurus"],
		"min_stage": 2, "require_injured": true,
		"flavor": "Your tail hangs heavy and wrong. You know you should not swing it, but you also know what happens if you do not.",
		"effects": {}, "choices": [], "resolve_key": "anky_tail_club_strain",
	},

	"anky_blood_between_plates": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "uncommon", "passive": false,
		"species": ["ankylosaurus"],
		"min_stage": 2, "require_injured": true,
		"flavor": "A seam that was not there before. Something got between the plates, and now the outside world has a way in.",
		"effects": {}, "choices": [], "resolve_key": "anky_blood_between_plates",
	},

	"anky_slow_untouchable": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "uncommon", "passive": false,
		"species": ["ankylosaurus"],
		"min_stage": 2, "require_injured": true,
		"flavor": "You are not fast. You are not fast even healthy. But you are still here, and the things that tried to change that are not.",
		"effects": {}, "choices": [], "resolve_key": "anky_slow_untouchable",
	},

	"anky_safe_against_stone": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "uncommon", "passive": false,
		"species": ["ankylosaurus"],
		"min_stage": 2, "require_injured": true,
		"flavor": "Stone at your back, armor facing out. You lower yourself carefully and breathe.",
		"effects": {}, "choices": [], "resolve_key": "anky_safe_against_stone",
	},

	# ══ SOCIAL ══════════════════════════════════════════════════════════════

	"anky_armored_neighbors": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["ankylosaurus"],
		"min_stage": 1,
		"flavor": "Another one grazes thirty paces away. You do not approach. It does not approach. But you are both still there.",
		"effects": {}, "choices": [], "resolve_key": "anky_armored_neighbors",
	},

	"anky_club_distance": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["ankylosaurus"],
		"min_stage": 1,
		"flavor": "You moved too close to the other's tail. It did not warn you. It simply swung.",
		"effects": {}, "choices": [], "resolve_key": "anky_club_distance",
	},

	"anky_armored_calf_alert": {
		"seasons": ["spring", "summer"], "trees": ["herbivore"], "rarity": "uncommon", "passive": false,
		"species": ["ankylosaurus"],
		"min_stage": 2,
		"flavor": "Small and pale-plated, it wanders too close to the open. Its soft armor catches the light.",
		"effects": {}, "choices": [], "resolve_key": "anky_armored_calf_alert",
	},

	"anky_shared_mud_wallow": {
		"seasons": ["spring", "summer", "fall"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["ankylosaurus"],
		"min_stage": 1,
		"flavor": "Three of you at the wallow edge. Nobody chose this. It just happened that way.",
		"effects": {}, "choices": [], "resolve_key": "anky_shared_mud_wallow",
	},

	"anky_territory_scrape": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "uncommon", "passive": false,
		"species": ["ankylosaurus"],
		"min_stage": 1,
		"flavor": "The soil is churned and the low plants are scraped aside. Something left marks. You read them.",
		"effects": {}, "choices": [], "resolve_key": "anky_territory_scrape",
	},

	# ══ SEASONAL ════════════════════════════════════════════════════════════

	"anky_spring_soft_growth": {
		"seasons": ["spring"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["ankylosaurus"],
		"flavor": "New plants push up through every gap in the ground. Low, soft, and close enough to eat without bending.",
		"effects": {}, "choices": [], "resolve_key": "anky_spring_soft_growth",
	},

	"anky_spring_rain_slick": {
		"seasons": ["spring"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["ankylosaurus"],
		"flavor": "The rain makes everything shine. It also makes everything slip.",
		"effects": {}, "choices": [], "resolve_key": "anky_spring_rain_slick",
	},

	"anky_summer_heat_plates": {
		"seasons": ["summer"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["ankylosaurus"],
		"flavor": "The sun is relentless and your armor holds every degree of it.",
		"effects": {}, "choices": [], "resolve_key": "anky_summer_heat_plates",
	},

	"anky_summer_dry_root_dig": {
		"seasons": ["summer"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["ankylosaurus"],
		"flavor": "The green things are gone. You lower your head toward the ground and start pushing.",
		"effects": {}, "choices": [], "resolve_key": "anky_summer_dry_root_dig",
	},

	"anky_fall_heavy_feeding": {
		"seasons": ["fall"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["ankylosaurus"],
		"flavor": "The plants are thick and available and you do not stop eating when you should.",
		"effects": {}, "choices": [], "resolve_key": "anky_fall_heavy_feeding",
	},

	"anky_fall_predator_pressure": {
		"seasons": ["fall"], "trees": ["herbivore"], "rarity": "uncommon", "passive": false,
		"species": ["ankylosaurus"],
		"flavor": "The season change makes everything bolder. It watched you from the shadows before stepping into the open.",
		"effects": {}, "choices": [], "resolve_key": "anky_fall_predator_pressure",
	},

	"anky_winter_tough_browse": {
		"seasons": ["winter"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["ankylosaurus"],
		"flavor": "Everything soft is gone. What remains is the kind of plant that fights back when you eat it.",
		"effects": {}, "choices": [], "resolve_key": "anky_winter_tough_browse",
	},

	"anky_winter_cold_armor": {
		"seasons": ["winter"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"species": ["ankylosaurus"],
		"flavor": "Cold settles overnight and you feel it in the morning. Not through your plates — between them.",
		"effects": {}, "choices": [], "resolve_key": "anky_winter_cold_armor",
	},

	# ══ RARE ════════════════════════════════════════════════════════════════

	"anky_rex_learns": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "rare", "passive": false,
		"species": ["ankylosaurus"],
		"min_stage": 2,
		"flavor": "A T. rex commits to the lunge and your tail meets it. The crack echoes. The rex limps back. You both know something is different now.",
		"effects": {}, "choices": [], "resolve_key": "anky_rex_learns",
	},

	"anky_club_meets_bone": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "rare", "passive": false,
		"species": ["ankylosaurus"],
		"min_stage": 2,
		"flavor": "The swing connects. Not with muscle or scale — with bone. The sound is final.",
		"effects": {}, "choices": [], "resolve_key": "anky_club_meets_bone",
	},

	"anky_armor_scar_memory": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "rare", "passive": false,
		"species": ["ankylosaurus"],
		"min_stage": 2,
		"flavor": "In the low afternoon light you count the scratches across your plates. There are more than you remember. You survived all of them.",
		"effects": {}, "choices": [], "resolve_key": "anky_armor_scar_memory",
	},

	"anky_perfect_wallow": {
		"seasons": ["spring", "summer"], "trees": ["herbivore"], "rarity": "rare", "passive": false,
		"species": ["ankylosaurus"],
		"flavor": "Shaded, deep, surrounded by plants. You have been looking for this your whole life without knowing it.",
		"effects": {}, "choices": [], "resolve_key": "anky_perfect_wallow",
	},

	"anky_living_rock": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "rare", "passive": false,
		"species": ["ankylosaurus"],
		"min_stage": 2,
		"flavor": "The predator walks past you. You do not breathe. You are not interesting. You are just the landscape.",
		"effects": {}, "choices": [], "resolve_key": "anky_living_rock",
	},

}
