extends Node

# ─────────────────────────────────────────────────────────────────────────────
# EventsDB — all world events mapped to game variables.
#
# Event structure:
#   id          : unique string
#   seasons     : array of season keys this event can fire in (spring/summer/fall/winter/any)
#   trees       : array of tree types this event targets (predator/herbivore/flyer/all)
#   rarity      : "common" | "uncommon" | "rare" | "legendary"
#   passive     : if true, effects apply immediately with no player choice
#   flavor      : implied world text shown to player — never explicit
#   effects     : passive stat changes applied on fire (empty dict if choice-driven)
#   choices     : array of choice cards (empty if passive)
#   resolve_key : string passed to ActionResolver when a choice is made
# ─────────────────────────────────────────────────────────────────────────────

const _WORLD_EVENTS: Dictionary = {

	# ══ SPRING ════════════════════════════════════════════════════════════════

	"fresh_growth": {
		"seasons": ["spring"], "trees": ["all"], "rarity": "common", "passive": true,
		"flavor": "New growth pushes through every hollow and hillside. The land is waking up.",
		"effects": { "hunger_mod_herb": 0.12, "prey_abundance_turns": 3 },
		"choices": [], "resolve_key": "",
	},
	"hatchling_season": {
		"seasons": ["spring"], "trees": ["all"], "rarity": "common", "passive": false,
		"flavor": "Tiny shapes dart through the undergrowth. A clutch has hatched nearby, and the young are beginning to explore.",
		"effects": {},
		"choices": [
			{ "label": "Search for nests",  "icon": "attack", "sublabel": "Easy prey nearby",       "action": "raid_nests" },
			{ "label": "Watch from cover",  "icon": "stalk",  "sublabel": "See what else is drawn",  "action": "observe" },
			{ "label": "Move on",           "icon": "flee",   "sublabel": "Not your concern",        "action": "leave" },
		],
		"resolve_key": "hatchling_season",
	},
	"mud_season": {
		"seasons": ["spring"], "trees": ["all"], "rarity": "common", "passive": true,
		"flavor": "Heavy rain has turned the low ground to mud. Each step takes more effort, but fresh tracks stand out clearly.",
		"effects": { "speed_buff": -0.12, "speed_buff_turns": 3, "stealth_buff": 0.10, "stealth_buff_turns": 3 },
		"choices": [], "resolve_key": "",
	},
	"flooded_rivers": {
		"seasons": ["spring"], "trees": ["flyer", "predator"], "rarity": "uncommon", "passive": false,
		"flavor": "The river has spilled over its banks. Shapes move beneath the rushing water, close enough to catch your attention.",
		"effects": {},
		"choices": [
			{ "label": "Fish the shallows", "icon": "hunt",  "sublabel": "Easy food near the banks", "action": "fish_flood" },
			{ "label": "Cross carefully",   "icon": "stalk", "sublabel": "New ground on the other side","action": "cross_river" },
			{ "label": "Stay clear",        "icon": "flee",  "sublabel": "Currents look dangerous",  "action": "leave" },
		],
		"resolve_key": "flooded_rivers",
	},
	"new_pack_forming": {
		"seasons": ["spring"], "trees": ["predator"], "rarity": "uncommon", "passive": false,
		"flavor": "Young hunters move without a clear leader. They are watching you.",
		"effects": {},
		"choices": [
			{ "label": "Assert yourself",  "icon": "attack", "sublabel": "Take the lead",         "action": "assert_pack" },
			{ "label": "Watch them",       "icon": "stalk",  "sublabel": "See how they move",     "action": "observe" },
			{ "label": "Avoid them",       "icon": "flee",   "sublabel": "Not your problem yet",  "action": "leave" },
		],
		"resolve_key": "new_pack_forming",
	},
	"herd_migration_begins": {
		"seasons": ["spring"], "trees": ["herbivore", "predator"], "rarity": "uncommon", "passive": false,
		"flavor": "A dust cloud rises to the east. Through it, you glimpse the shapes of a large herd on the move.",
		"effects": {},
		"choices": [
			{ "label": "Follow the herd",  "icon": "hunt",  "sublabel": "Food will follow",       "action": "follow_migration" },
			{ "label": "Join the herd",    "icon": "stalk", "sublabel": "Safety in numbers",      "action": "join_migration" },
			{ "label": "Let them pass",    "icon": "flee",  "sublabel": "Hold your ground",       "action": "leave" },
		],
		"resolve_key": "herd_migration_begins",
	},
	"blooming_medicine": {
		"seasons": ["spring"], "trees": ["herbivore", "flyer"], "rarity": "uncommon", "passive": false,
		"flavor": "The rain has brought up clusters of unfamiliar plants. Their bright, soft leaves look tempting.",
		"effects": {},
		"choices": [
			{ "label": "Eat carefully",    "icon": "hunt",  "sublabel": "Could restore health",   "action": "eat_medicine" },
			{ "label": "Sniff and leave",  "icon": "stalk", "sublabel": "Don't risk it",          "action": "leave" },
		],
		"resolve_key": "blooming_medicine",
	},
	"poison_bloom": {
		"seasons": ["spring"], "trees": ["herbivore"], "rarity": "uncommon", "passive": false,
		"flavor": "Colorful plants have sprung up overnight. They look inviting, but you do not know which are safe to eat.",
		"effects": {},
		"choices": [
			{ "label": "Eat them",         "icon": "hunt",  "sublabel": "Worth the risk",        "action": "eat_poison_bloom" },
			{ "label": "Avoid this patch", "icon": "flee",  "sublabel": "Something feels wrong", "action": "leave" },
		],
		"resolve_key": "poison_bloom",
	},
	"storm_week": {
		"seasons": ["spring", "fall"], "trees": ["all"], "rarity": "uncommon", "passive": true,
		"flavor": "Clouds have covered the sky for days. Lightning flickers in the distance, and the air feels charged.",
		"effects": { "stealth_buff": -0.15, "stealth_buff_turns": 4, "speed_buff": -0.08, "speed_buff_turns": 4 },
		"choices": [], "resolve_key": "",
	},
	"nest_site_rush": {
		"seasons": ["spring"], "trees": ["flyer", "herbivore"], "rarity": "uncommon", "passive": false,
		"flavor": "Every sheltered ledge and hollow is occupied or closely watched. Finding a place of your own will not be easy.",
		"effects": {},
		"choices": [
			{ "label": "Claim a nest",     "icon": "attack", "sublabel": "Fight for the best spot", "action": "claim_nest" },
			{ "label": "Scout quietly",    "icon": "stalk",  "sublabel": "Find an unclaimed one",   "action": "scout_nest" },
			{ "label": "Move on",          "icon": "flee",   "sublabel": "Not worth the fight",     "action": "leave" },
		],
		"resolve_key": "nest_site_rush",
	},

	# ══ SUMMER ════════════════════════════════════════════════════════════════

	"heat_wave": {
		"seasons": ["summer"], "trees": ["all"], "rarity": "common", "passive": true,
		"flavor": "The air is hot and still. Moving takes more effort, and the shady places are already crowded.",
		"effects": { "speed_buff": -0.10, "speed_buff_turns": 3, "hunger_decay_mod": 0.02 },
		"choices": [], "resolve_key": "",
	},
	"drought": {
		"seasons": ["summer"], "trees": ["all"], "rarity": "uncommon", "passive": false,
		"flavor": "The watering hole has shrunk to half its size. Animals crowd the remaining water, including hunters you would rather avoid.",
		"effects": {},
		"choices": [
			{ "label": "Drink and watch",  "icon": "stalk",  "sublabel": "Be ready to move fast",  "action": "waterhole_cautious" },
			{ "label": "Drink quickly",    "icon": "hunt",   "sublabel": "Get in and out",         "action": "waterhole_fast" },
			{ "label": "Wait for dark",    "icon": "flee",   "sublabel": "Less competition then",  "action": "waterhole_wait" },
		],
		"resolve_key": "drought",
	},
	"fruit_season": {
		"seasons": ["summer"], "trees": ["herbivore", "flyer"], "rarity": "common", "passive": false,
		"flavor": "Heavy fruit hangs low on the trees. Some has already fallen and split open.",
		"effects": {},
		"choices": [
			{ "label": "Feed heavily",     "icon": "hunt",  "sublabel": "Take what you can",      "action": "eat_fruit" },
			{ "label": "Eat carefully",    "icon": "stalk", "sublabel": "Some may have turned",   "action": "eat_fruit_careful" },
			{ "label": "Move on",          "icon": "flee",  "sublabel": "Not your season",        "action": "leave" },
		],
		"resolve_key": "fruit_season",
	},
	"waterhole_truce": {
		"seasons": ["summer"], "trees": ["all"], "rarity": "uncommon", "passive": false,
		"flavor": "Predators and prey gather at the same waterhole. For now, thirst keeps the peace, but every movement draws watchful eyes.",
		"effects": {},
		"choices": [
			{ "label": "Drink and hold",   "icon": "stalk", "sublabel": "Respect the truce",      "action": "truce_drink" },
			{ "label": "Break the truce",  "icon": "attack","sublabel": "Press the advantage",    "action": "truce_break" },
			{ "label": "Wait nearby",      "icon": "flee",  "sublabel": "Watch for weakness",     "action": "truce_wait" },
		],
		"resolve_key": "waterhole_truce",
	},
	"wildfire": {
		"seasons": ["summer"], "trees": ["all"], "rarity": "uncommon", "passive": false,
		"flavor": "Smoke rises from the ridge, and the wind carries it toward you. Animals are already fleeing through the brush.",
		"effects": {},
		"choices": [
			{ "label": "Flee immediately", "icon": "flee",  "sublabel": "Don't wait to see",      "action": "wildfire_flee" },
			{ "label": "Head for water",   "icon": "hunt",  "sublabel": "A river nearby",         "action": "wildfire_water" },
			{ "label": "Hold ground",      "icon": "attack","sublabel": "You've survived fire before","action": "wildfire_hold" },
		],
		"resolve_key": "wildfire",
	},
	"insect_swarms": {
		"seasons": ["summer"], "trees": ["flyer", "predator"], "rarity": "common", "passive": false,
		"flavor": "A dark cloud shifts above the trees. As it draws closer, you hear the hum of thousands of insects.",
		"effects": {},
		"choices": [
			{ "label": "Feed on the swarm","icon": "hunt",  "sublabel": "Easy food if you're small","action": "eat_insects" },
			{ "label": "Avoid the cloud",  "icon": "flee",  "sublabel": "Some swarms bite back",  "action": "leave" },
		],
		"resolve_key": "insect_swarms",
	},
	"dust_storm": {
		"seasons": ["summer"], "trees": ["all"], "rarity": "uncommon", "passive": true,
		"flavor": "A brown wall of dust rolls across the horizon. The wind carries the sharp smell of dry earth.",
		"effects": { "stealth_buff": 0.15, "stealth_buff_turns": 2, "speed_buff": -0.15, "speed_buff_turns": 2 },
		"choices": [], "resolve_key": "",
	},
	"salt_lick": {
		"seasons": ["summer"], "trees": ["herbivore"], "rarity": "uncommon", "passive": false,
		"flavor": "A mineral deposit has been exposed by the dry ground. Others have already found it.",
		"effects": {},
		"choices": [
			{ "label": "Push to the front","icon": "attack","sublabel": "Take your share",        "action": "salt_fight" },
			{ "label": "Wait your turn",   "icon": "stalk", "sublabel": "Safer, but slower",     "action": "salt_wait" },
			{ "label": "Leave it",         "icon": "flee",  "sublabel": "Not worth the crowd",   "action": "leave" },
		],
		"resolve_key": "salt_lick",
	},

	# ══ FALL ══════════════════════════════════════════════════════════════════

	"great_migration": {
		"seasons": ["fall"], "trees": ["all"], "rarity": "common", "passive": false,
		"flavor": "The ground trembles beneath a distant herd. Its low rumble has carried across the land for days.",
		"effects": {},
		"choices": [
			{ "label": "Follow the herds", "icon": "hunt",  "sublabel": "Food will follow",       "action": "follow_migration" },
			{ "label": "Join the movement","icon": "stalk", "sublabel": "Safety in the mass",     "action": "join_migration" },
			{ "label": "Hold your ground", "icon": "flee",  "sublabel": "Let it pass around you", "action": "leave" },
		],
		"resolve_key": "great_migration",
	},
	"rutting_season": {
		"seasons": ["fall"], "trees": ["all"], "rarity": "common", "passive": false,
		"flavor": "Calls and challenges fill the air. Even well-fed animals seem restless, sizing one another up.",
		"effects": {},
		"choices": [
			{ "label": "Challenge a rival","icon": "attack","sublabel": "Prove your strength",    "action": "rut_challenge" },
			{ "label": "Display and wait", "icon": "stalk", "sublabel": "Let them come to you",   "action": "rut_display" },
			{ "label": "Stay out of it",   "icon": "flee",  "sublabel": "Not your fight",         "action": "leave" },
		],
		"resolve_key": "rutting_season",
	},
	"fattening_season": {
		"seasons": ["fall"], "trees": ["all"], "rarity": "common", "passive": false,
		"flavor": "Animals linger over every patch of food they find. With colder seasons ahead, there is little time to waste.",
		"effects": {},
		"choices": [
			{ "label": "Feed aggressively","icon": "hunt",  "sublabel": "Fill up before the cold","action": "fatten_aggressive" },
			{ "label": "Eat steadily",     "icon": "stalk", "sublabel": "Consistent and safe",   "action": "fatten_steady" },
		],
		"resolve_key": "fattening_season",
	},
	"cold_nights": {
		"seasons": ["fall", "winter"], "trees": ["all"], "rarity": "common", "passive": true,
		"flavor": "The nights have grown bitter. Resting in the open no longer leaves you as refreshed as it once did.",
		"effects": { "health_regen_mod": -0.05, "health_regen_turns": 4 },
		"choices": [], "resolve_key": "",
	},
	"sick_herd": {
		"seasons": ["fall"], "trees": ["predator", "herbivore"], "rarity": "uncommon", "passive": false,
		"flavor": "The herd moves slowly, with too many heads hanging low. A few members stumble as they try to keep up.",
		"effects": {},
		"choices": [
			{ "label": "Target the weak",  "icon": "attack","sublabel": "Easy prey, but risky meat","action": "hunt_sick" },
			{ "label": "Watch the pattern","icon": "stalk", "sublabel": "Find the safest target",  "action": "observe" },
			{ "label": "Stay clear",       "icon": "flee",  "sublabel": "Disease travels",         "action": "leave" },
		],
		"resolve_key": "sick_herd",
	},
	"mushroom_bloom": {
		"seasons": ["fall"], "trees": ["herbivore", "flyer"], "rarity": "uncommon", "passive": false,
		"flavor": "Pale mushrooms have pushed through the leaf litter overnight. Some look familiar; others do not.",
		"effects": {},
		"choices": [
			{ "label": "Eat freely",       "icon": "hunt",  "sublabel": "Some look familiar",    "action": "eat_mushrooms_free" },
			{ "label": "Eat cautiously",   "icon": "stalk", "sublabel": "Take your time choosing","action": "eat_mushrooms_careful" },
			{ "label": "Leave them",       "icon": "flee",  "sublabel": "Not worth the guess",   "action": "leave" },
		],
		"resolve_key": "mushroom_bloom",
	},
	"predator_gathering": {
		"seasons": ["fall"], "trees": ["predator"], "rarity": "uncommon", "passive": false,
		"flavor": "Fresh predator tracks follow the migrating herds. You are one of many hunters drawn to the same trail.",
		"effects": {},
		"choices": [
			{ "label": "Assert territory", "icon": "attack","sublabel": "Make your claim known",  "action": "assert_territory" },
			{ "label": "Watch from range", "icon": "stalk", "sublabel": "Learn who's dangerous",  "action": "observe" },
			{ "label": "Avoid the routes", "icon": "flee",  "sublabel": "Hunt the edges",         "action": "leave" },
		],
		"resolve_key": "predator_gathering",
	},
	"leaf_fall": {
		"seasons": ["fall"], "trees": ["all"], "rarity": "common", "passive": true,
		"flavor": "Leaves have thinned across the canopy. You can see farther through the trees, but there is less cover to hide you.",
		"effects": { "stealth_buff": -0.10, "stealth_buff_turns": 8 },
		"choices": [], "resolve_key": "",
	},
	"alpha_challenge": {
		"seasons": ["fall"], "trees": ["predator"], "rarity": "uncommon", "passive": false,
		"flavor": "Your pack has begun to watch you differently. Glances linger, and a few hunters slow their steps when you approach.",
		"effects": {},
		"choices": [
			{ "label": "Reassert yourself","icon": "attack","sublabel": "End the question now",   "action": "alpha_reassert" },
			{ "label": "Show patience",    "icon": "stalk", "sublabel": "Strength doesn't always shout","action": "alpha_patience" },
		],
		"resolve_key": "alpha_challenge",
	},

	# ══ WINTER ════════════════════════════════════════════════════════════════

	"deep_freeze": {
		"seasons": ["winter"], "trees": ["all"], "rarity": "common", "passive": true,
		"flavor": "The cold has settled into the ground. Even familiar trails feel harder to cross, and every animal moves more slowly.",
		"effects": { "speed_buff": -0.12, "speed_buff_turns": 5, "hunger_decay_mod": 0.015 },
		"choices": [], "resolve_key": "",
	},
	"snowfall": {
		"seasons": ["winter"], "trees": ["all"], "rarity": "common", "passive": true,
		"flavor": "Snow blankets the land, revealing fresh tracks in the white. They will not stay clear for long.",
		"effects": { "stealth_buff": 0.10, "stealth_buff_turns": 2 },
		"choices": [], "resolve_key": "",
	},
	"blizzard": {
		"seasons": ["winter"], "trees": ["all"], "rarity": "uncommon", "passive": false,
		"flavor": "Blowing snow hides the trail ahead. The wind cuts through every gap in your shelter, making it dangerous to stay exposed.",
		"effects": {},
		"choices": [
			{ "label": "Find shelter now", "icon": "flee",  "sublabel": "Get out of the open",    "action": "blizzard_shelter" },
			{ "label": "Push through",     "icon": "attack","sublabel": "You can handle the cold","action": "blizzard_push" },
			{ "label": "Dig in here",      "icon": "stalk", "sublabel": "Make do with what's near","action": "blizzard_dig" },
		],
		"resolve_key": "blizzard",
	},
	"frozen_river": {
		"seasons": ["winter"], "trees": ["all"], "rarity": "uncommon", "passive": false,
		"flavor": "The river lies beneath a sheet of white ice. It looks solid, but heavier animals have broken through before.",
		"effects": {},
		"choices": [
			{ "label": "Cross carefully",  "icon": "stalk", "sublabel": "New territory on the far side","action": "cross_ice" },
			{ "label": "Fish through a crack","icon": "hunt","sublabel": "Cold slows the fish",   "action": "ice_fish" },
			{ "label": "Stay on this side","icon": "flee",  "sublabel": "Not worth the risk",    "action": "leave" },
		],
		"resolve_key": "frozen_river",
	},
	"frozen_carcass": {
		"seasons": ["winter"], "trees": ["predator", "flyer"], "rarity": "uncommon", "passive": false,
		"flavor": "The cold has preserved a large carcass. Its scent travels far enough to draw other hungry animals.",
		"effects": {},
		"choices": [
			{ "label": "Feed now",         "icon": "hunt",  "sublabel": "Others will smell this", "action": "frozen_feed_fast" },
			{ "label": "Watch first",      "icon": "stalk", "sublabel": "Someone may already be here","action": "frozen_feed_cautious" },
			{ "label": "Leave it",         "icon": "flee",  "sublabel": "Not worth the attention","action": "leave" },
		],
		"resolve_key": "frozen_carcass",
	},
	"winter_shelter": {
		"seasons": ["winter"], "trees": ["all"], "rarity": "common", "passive": false,
		"flavor": "A cave opens in the hillside, with warm air drifting from its mouth. You cannot tell whether it is occupied.",
		"effects": {},
		"choices": [
			{ "label": "Force your way in","icon": "attack","sublabel": "Take the shelter",       "action": "shelter_fight" },
			{ "label": "Check carefully",  "icon": "stalk", "sublabel": "See what's inside first","action": "shelter_scout" },
			{ "label": "Rest outside",     "icon": "flee",  "sublabel": "Not worth the fight",   "action": "leave" },
		],
		"resolve_key": "winter_shelter",
	},
	"pack_hunger": {
		"seasons": ["winter"], "trees": ["predator"], "rarity": "uncommon", "passive": false,
		"flavor": "Your pack is growing lean. At feeding time, its members watch one another as closely as they watch the food.",
		"effects": {},
		"choices": [
			{ "label": "Share your kill",  "icon": "hunt",  "sublabel": "Bond holds through lean times","action": "share_food" },
			{ "label": "Hold your portion","icon": "attack","sublabel": "You earned it",          "action": "keep_food" },
		],
		"resolve_key": "pack_hunger",
	},
	"scavenger_war": {
		"seasons": ["winter"], "trees": ["predator", "flyer"], "rarity": "uncommon", "passive": false,
		"flavor": "Three large scavengers circle a carcass. There is plenty of meat, but none of them looks ready to share.",
		"effects": {},
		"choices": [
			{ "label": "Dominate the scene","icon": "attack","sublabel": "Drive them off",        "action": "scav_dominate" },
			{ "label": "Steal scraps",     "icon": "stalk", "sublabel": "Quick in and out",      "action": "scav_steal" },
			{ "label": "Leave them to it", "icon": "flee",  "sublabel": "Find something else",   "action": "leave" },
		],
		"resolve_key": "scavenger_war",
	},
	"herd_huddle": {
		"seasons": ["winter"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"flavor": "The herd has pressed together against the cold. There is warmth and safety within the group, if you can find a place.",
		"effects": {},
		"choices": [
			{ "label": "Push into the center","icon": "attack","sublabel": "Warmest spot",       "action": "huddle_center" },
			{ "label": "Stay at the edge", "icon": "stalk", "sublabel": "Easier to leave",       "action": "huddle_edge" },
			{ "label": "Rest alone",       "icon": "flee",  "sublabel": "You prefer the open",   "action": "leave" },
		],
		"resolve_key": "herd_huddle",
	},

	# ══ PREDATOR-SPECIFIC ═════════════════════════════════════════════════════

	"wounded_wanderer": {
		"seasons": ["spring", "summer", "fall"], "trees": ["predator"], "rarity": "common", "passive": false,
		"flavor": "A large animal limps behind the others, favoring one side. Each step puts more distance between it and the herd.",
		"effects": {},
		"choices": [
			{ "label": "Attack now",       "icon": "attack","sublabel": "Easy target",            "action": "hunt_wounded" },
			{ "label": "Circle it first",  "icon": "stalk", "sublabel": "Make sure it's alone",  "action": "stalk_wounded" },
			{ "label": "Leave it",         "icon": "flee",  "sublabel": "Bait — maybe",           "action": "leave" },
		],
		"resolve_key": "wounded_wanderer",
	},
	"fresh_tracks": {
		"seasons": ["spring", "summer", "fall", "winter"], "trees": ["predator"], "rarity": "common", "passive": false,
		"flavor": "Deep prints mark the soft ground. Their edges are still fresh, left by a heavy animal moving slowly.",
		"effects": {},
		"choices": [
			{ "label": "Follow the trail", "icon": "hunt",  "sublabel": "See where it leads",    "action": "follow_tracks" },
			{ "label": "Study the prints", "icon": "stalk", "sublabel": "Learn before moving",   "action": "read_tracks" },
			{ "label": "Leave it",         "icon": "flee",  "sublabel": "Could be a trap",       "action": "leave" },
		],
		"resolve_key": "fresh_tracks",
	},
	"pack_invitation": {
		"seasons": ["spring", "fall"], "trees": ["predator"], "rarity": "uncommon", "passive": false,
		"flavor": "A group watches you from a distance. They hold their ground, waiting to see what you will do.",
		"effects": {},
		"choices": [
			{ "label": "Approach slowly",  "icon": "stalk", "sublabel": "Show you aren't a threat","action": "pack_approach" },
			{ "label": "Display strength", "icon": "attack","sublabel": "Let them know who you are","action": "pack_display" },
			{ "label": "Move on",          "icon": "flee",  "sublabel": "Not ready for that",    "action": "leave" },
		],
		"resolve_key": "pack_invitation",
	},
	"rival_claim": {
		"seasons": ["spring", "summer", "fall"], "trees": ["predator"], "rarity": "common", "passive": false,
		"flavor": "Fresh scent marks cover the trail. Another animal claims this ground, and it has noticed your arrival.",
		"effects": {},
		"choices": [
			{ "label": "Overmark it",      "icon": "attack","sublabel": "Make your own claim",   "action": "contest_territory" },
			{ "label": "Back off",         "icon": "flee",  "sublabel": "Find unclaimed ground", "action": "leave" },
			{ "label": "Wait and see",     "icon": "stalk", "sublabel": "Who made these marks",  "action": "observe" },
		],
		"resolve_key": "rival_claim",
	},
	"night_hunt": {
		"seasons": ["summer", "fall"], "trees": ["predator"], "rarity": "uncommon", "passive": false,
		"flavor": "Night settles over the range. With fewer distractions, the rustle of prey is easier to follow.",
		"effects": {},
		"choices": [
			{ "label": "Hunt the dark",    "icon": "hunt",  "sublabel": "Stealth is yours tonight","action": "night_hunt_go" },
			{ "label": "Wait for first light","icon": "stalk","sublabel": "Patience has rewards", "action": "leave" },
		],
		"resolve_key": "night_hunt",
	},
	"herd_defense": {
		"seasons": ["spring", "fall"], "trees": ["predator"], "rarity": "common", "passive": false,
		"flavor": "The prey stops running and forms a tight circle. Heads face outward, leaving no easy gap to attack.",
		"effects": {},
		"choices": [
			{ "label": "Test the formation","icon": "attack","sublabel": "Look for a weak point", "action": "test_herd" },
			{ "label": "Circle and wait",  "icon": "stalk", "sublabel": "Something may break away","action": "wait_herd" },
			{ "label": "Pull back",        "icon": "flee",  "sublabel": "Wrong fight today",     "action": "leave" },
		],
		"resolve_key": "herd_defense",
	},

	# ══ HERBIVORE-SPECIFIC ════════════════════════════════════════════════════

	"defensive_stand": {
		"seasons": ["spring", "summer", "fall", "winter"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"flavor": "A large predator comes straight toward you. It shows no sign of slowing.",
		"effects": {},
		"choices": [
			{ "label": "Charge it",        "icon": "attack","sublabel": "Meet it head on",        "action": "charge_predator" },
			{ "label": "Hold ground",      "icon": "stalk", "sublabel": "Don't give up territory","action": "hold_ground" },
			{ "label": "Run",              "icon": "flee",  "sublabel": "Speed is survival",      "action": "flee" },
		],
		"resolve_key": "defensive_stand",
	},
	"fresh_meadow": {
		"seasons": ["spring", "summer"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"flavor": "A clearing opens ahead, full of untouched growth. Feeding grounds this quiet are rare.",
		"effects": {},
		"choices": [
			{ "label": "Feed openly",      "icon": "hunt",  "sublabel": "Best food in season",   "action": "graze_meadow" },
			{ "label": "Feed at the edge", "icon": "stalk", "sublabel": "Less food, more cover",  "action": "graze_edge" },
			{ "label": "Keep moving",      "icon": "flee",  "sublabel": "Too exposed",            "action": "leave" },
		],
		"resolve_key": "fresh_meadow",
	},
	"mineral_lick": {
		"seasons": ["summer", "fall"], "trees": ["herbivore"], "rarity": "uncommon", "passive": false,
		"flavor": "A patch of exposed mineral rock is worn smooth by other animals. Its sharp scent draws you closer.",
		"effects": {},
		"choices": [
			{ "label": "Push to the front","icon": "attack","sublabel": "You need this more",    "action": "mineral_fight" },
			{ "label": "Wait your turn",   "icon": "stalk", "sublabel": "Get some eventually",   "action": "mineral_wait" },
		],
		"resolve_key": "mineral_lick",
	},
	"herd_panic": {
		"seasons": ["spring", "summer", "fall"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"flavor": "The herd erupts into motion without warning. You cannot see what startled it, and there is little time to decide.",
		"effects": {},
		"choices": [
			{ "label": "Run with them",    "icon": "flee",  "sublabel": "Move now, think later",  "action": "stampede_join" },
			{ "label": "Hold your ground", "icon": "attack","sublabel": "See what caused this",   "action": "stampede_hold" },
			{ "label": "Split from them",  "icon": "stalk", "sublabel": "Find your own path",     "action": "stampede_split" },
		],
		"resolve_key": "herd_panic",
	},
	"nest_defense": {
		"seasons": ["spring", "summer"], "trees": ["herbivore", "flyer"], "rarity": "uncommon", "passive": false,
		"flavor": "A predator edges toward the nest, pausing between steps. It is testing how closely the nest is guarded.",
		"effects": {},
		"choices": [
			{ "label": "Charge it off",    "icon": "attack","sublabel": "Protect what's yours",  "action": "defend_nest" },
			{ "label": "Create a distraction","icon": "stalk","sublabel": "Lead it away",        "action": "distract_predator" },
			{ "label": "Watch it closely", "icon": "flee",  "sublabel": "See if it leaves",      "action": "observe" },
		],
		"resolve_key": "nest_defense",
	},
	"old_bull_challenge": {
		"seasons": ["fall"], "trees": ["herbivore"], "rarity": "uncommon", "passive": false,
		"flavor": "The largest member of the herd holds your gaze. This time, the look feels like a challenge.",
		"effects": {},
		"choices": [
			{ "label": "Accept the challenge","icon": "attack","sublabel": "Fight for your place","action": "herd_rank_fight" },
			{ "label": "Submit quietly",    "icon": "flee",  "sublabel": "Live to try again",    "action": "submit_rank" },
		],
		"resolve_key": "old_bull_challenge",
	},
	"stalked": {
		"seasons": ["spring", "summer", "fall"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"flavor": "The same predator has appeared at the tree line three times. It keeps its distance, waiting for an opening.",
		"effects": {},
		"choices": [
			{ "label": "Run",              "icon": "flee",  "sublabel": "Don't let it pick the moment", "action": "flee" },
			{ "label": "Turn and face it", "icon": "attack","sublabel": "Sometimes that's enough",      "action": "charge_predator" },
			{ "label": "Move into cover",  "icon": "stalk", "sublabel": "Lose it in the brush",        "action": "hold_ground" },
		],
		"resolve_key": "defensive_stand",
	},
	"desperate_attack": {
		"seasons": ["winter"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"flavor": "Hunger has made the predator reckless. It charges before you can put much distance between you.",
		"effects": {},
		"choices": [
			{ "label": "Run",              "icon": "flee",  "sublabel": "Outpace it",                  "action": "flee" },
			{ "label": "Stand your ground","icon": "attack","sublabel": "Force it to commit or quit",  "action": "hold_ground" },
			{ "label": "Charge back",      "icon": "stalk", "sublabel": "Meet it before it's set",     "action": "charge_predator" },
		],
		"resolve_key": "defensive_stand",
	},

	# ══ FLYER-SPECIFIC ════════════════════════════════════════════════════════

	"strong_updraft": {
		"seasons": ["spring", "summer"], "trees": ["flyer"], "rarity": "common", "passive": true,
		"flavor": "Warm air rises hard off the rocks. You feel it before you reach the edge.",
		"effects": { "stamina_buff": 0.15, "stamina_buff_turns": 3 },
		"choices": [], "resolve_key": "",
	},
	"sudden_crosswind": {
		"seasons": ["spring", "fall"], "trees": ["flyer"], "rarity": "common", "passive": false,
		"flavor": "The wind shifts without warning. Everything in the air has to respond.",
		"effects": {},
		"choices": [
			{ "label": "Ride it out",      "icon": "attack","sublabel": "Use the new current",   "action": "crosswind_ride" },
			{ "label": "Land immediately", "icon": "flee",  "sublabel": "Ground is safer",       "action": "crosswind_land" },
		],
		"resolve_key": "sudden_crosswind",
	},
	"fish_surface": {
		"seasons": ["spring", "summer", "fall"], "trees": ["flyer"], "rarity": "common", "passive": false,
		"flavor": "The water is broken and glinting. Fish near the top. A lot of them.",
		"effects": {},
		"choices": [
			{ "label": "Dive immediately", "icon": "hunt",  "sublabel": "Take the first run",    "action": "fish_dive" },
			{ "label": "Circle first",     "icon": "stalk", "sublabel": "Find the best spot",    "action": "fish_circle" },
		],
		"resolve_key": "fish_surface",
	},
	"sky_shadow": {
		"seasons": ["spring", "summer", "fall"], "trees": ["flyer"], "rarity": "uncommon", "passive": false,
		"flavor": "A shadow passes that is larger than yours. Something up there is hunting.",
		"effects": {},
		"choices": [
			{ "label": "Challenge it",     "icon": "attack","sublabel": "This sky is yours",     "action": "sky_challenge" },
			{ "label": "Drop altitude",    "icon": "stalk", "sublabel": "Stay out of range",     "action": "sky_evade" },
			{ "label": "Land immediately", "icon": "flee",  "sublabel": "Ground is safer",       "action": "crosswind_land" },
		],
		"resolve_key": "sky_shadow",
	},
	"storm_perch": {
		"seasons": ["spring", "fall", "winter"], "trees": ["flyer"], "rarity": "common", "passive": false,
		"flavor": "The air has gone wrong. Flying in this would be a mistake.",
		"effects": {},
		"choices": [
			{ "label": "Find a high perch", "icon": "stalk","sublabel": "Wait it out above",     "action": "storm_high_perch" },
			{ "label": "Ground shelter",    "icon": "flee", "sublabel": "Safer but less visible","action": "storm_ground" },
		],
		"resolve_key": "storm_perch",
	},
	"egg_snatcher": {
		"seasons": ["spring", "summer"], "trees": ["flyer"], "rarity": "uncommon", "passive": false,
		"flavor": "A small thief is moving along the cliff. It knows where to look.",
		"effects": {},
		"choices": [
			{ "label": "Chase it down",    "icon": "attack","sublabel": "Protect the nest",      "action": "defend_nest" },
			{ "label": "Cut it off",       "icon": "stalk", "sublabel": "Block the approach",    "action": "intercept_thief" },
		],
		"resolve_key": "egg_snatcher",
	},
	"thermal_winds": {
		"seasons": ["spring", "summer"], "trees": ["flyer"], "rarity": "common", "passive": true,
		"flavor": "The air is doing most of the work today. The whole sky feels effortless.",
		"effects": { "stamina_buff": 0.20, "stamina_buff_turns": 2 },
		"choices": [], "resolve_key": "",
	},
	"migration_current": {
		"seasons": ["fall"], "trees": ["flyer"], "rarity": "rare", "passive": false,
		"flavor": "A river of air moves south. Other flyers are already in it. This goes somewhere.",
		"effects": {},
		"choices": [
			{ "label": "Join the current", "icon": "hunt",  "sublabel": "See where it leads",    "action": "join_migration" },
			{ "label": "Stay put",         "icon": "flee",  "sublabel": "Hold your territory",   "action": "leave" },
		],
		"resolve_key": "migration_current",
	},

	# ══ RARE / GLOBAL ═════════════════════════════════════════════════════════

	"great_drought": {
		"seasons": ["summer"], "trees": ["all"], "rarity": "rare", "passive": true,
		"flavor": "The dry season drags on. The last waterhole has dwindled to a puddle, and animals are beginning to leave.",
		"effects": { "hunger_decay_mod": 0.03, "speed_buff": -0.08, "speed_buff_turns": 8 },
		"choices": [], "resolve_key": "",
	},
	"blooming_year": {
		"seasons": ["spring"], "trees": ["all"], "rarity": "rare", "passive": true,
		"flavor": "Fresh growth covers nearly every surface. Even the familiar trails are disappearing beneath it.",
		"effects": { "hunger_mod_herb": 0.20, "prey_abundance_turns": 6 },
		"choices": [], "resolve_key": "",
	},
	"superstorm": {
		"seasons": ["fall", "winter"], "trees": ["all"], "rarity": "rare", "passive": false,
		"flavor": "The approaching storm darkens the sky to an unfamiliar color. This one feels different from the others.",
		"effects": {},
		"choices": [
			{ "label": "Find deep shelter","icon": "flee",  "sublabel": "Get underground if you can","action": "superstorm_shelter" },
			{ "label": "Run ahead of it",  "icon": "attack","sublabel": "Outpace it",             "action": "superstorm_run" },
		],
		"resolve_key": "superstorm",
	},
	"plague_season": {
		"seasons": ["fall"], "trees": ["all"], "rarity": "rare", "passive": false,
		"flavor": "Illness is spreading through the herds. More animals stumble on the trail, and some no longer rise to follow.",
		"effects": {},
		"choices": [
			{ "label": "Hunt the sick",    "icon": "attack","sublabel": "Easy prey — risky meat", "action": "hunt_sick" },
			{ "label": "Stay upwind",      "icon": "stalk", "sublabel": "Keep your distance",    "action": "observe" },
			{ "label": "Leave the area",   "icon": "flee",  "sublabel": "Get clear of this",     "action": "leave" },
		],
		"resolve_key": "plague_season",
	},
	"red_moon_rut": {
		"seasons": ["fall"], "trees": ["all"], "rarity": "legendary", "passive": false,
		"flavor": "The sky looks strange tonight. Across the range, animals stay awake and react sharply to every movement.",
		"effects": {},
		"choices": [
			{ "label": "Embrace it",       "icon": "attack","sublabel": "This energy is yours",  "action": "rut_challenge" },
			{ "label": "Stay low",         "icon": "flee",  "sublabel": "Don't get caught in it","action": "leave" },
		],
		"resolve_key": "red_moon_rut",
	},
	"predator_silence": {
		"seasons": ["spring", "summer"], "trees": ["all"], "rarity": "rare", "passive": false,
		"flavor": "The great hunters have been absent for three seasons. Prey now grazes without much caution, but that quiet may not last.",
		"effects": {},
		"choices": [
			{ "label": "Take advantage",   "icon": "hunt",  "sublabel": "Prey is less cautious", "action": "hunt_unguarded" },
			{ "label": "Stay cautious",    "icon": "stalk", "sublabel": "Something left — why",  "action": "observe" },
		],
		"resolve_key": "predator_silence",
	},

	# ══ SPECIES-SPECIFIC ══════════════════════════════════════════════════════

	"comp_pack_flanking": {
		"seasons": ["spring", "summer", "fall"], "trees": ["predator"], "species": ["compsognathus"],
		"rarity": "uncommon", "passive": false,
		"flavor": "The prey has not noticed the hunters moving behind it. Both flanks wait for your signal.",
		"effects": {},
		"choices": [
			{ "label": "Signal both flanks", "icon": "attack", "sublabel": "Coordinated strike",        "action": "signal_flanks" },
			{ "label": "Rush alone",         "icon": "hunt",   "sublabel": "Don't wait for the others", "action": "rush_alone" },
			{ "label": "Let it pass",        "icon": "flee",   "sublabel": "The angle isn't clean",     "action": "leave" },
		],
		"resolve_key": "comp_pack_flanking",
	},
	"deinon_killing_strike": {
		"seasons": ["spring", "summer", "fall"], "trees": ["predator"], "species": ["deinonychus"],
		"rarity": "uncommon", "passive": false,
		"flavor": "The pack has pinned the prey, and its struggles are slowing. From here, a well-placed leap could finish the hunt.",
		"effects": {},
		"choices": [
			{ "label": "Killing leap",    "icon": "attack", "sublabel": "Precision over the pack",  "action": "killing_leap" },
			{ "label": "Press together",  "icon": "hunt",   "sublabel": "Safer, slower, cleaner",   "action": "group_press" },
			{ "label": "Hold — reset",    "icon": "stalk",  "sublabel": "The opening isn't right",  "action": "back_off_reset" },
		],
		"resolve_key": "deinon_killing_strike",
	},
	"micro_canopy_launch": {
		"seasons": ["spring", "summer", "fall"], "trees": ["predator"], "species": ["microraptor"],
		"rarity": "uncommon", "passive": false,
		"flavor": "A gap in the canopy above. Prey feeding in the clearing below. The angle from that branch is exactly right.",
		"effects": {},
		"choices": [
			{ "label": "Four-wing dive",    "icon": "attack", "sublabel": "Drop from above — fast",  "action": "four_wing_dive" },
			{ "label": "Controlled glide",  "icon": "stalk",  "sublabel": "Slower approach, safer",  "action": "glide_to_prey" },
			{ "label": "Watch from here",   "icon": "flee",   "sublabel": "Read the ground first",   "action": "watch_from_here" },
		],
		"resolve_key": "micro_canopy_launch",
	},
	"troodon_night_sense": {
		"seasons": ["summer", "fall", "winter"], "trees": ["predator"], "species": ["troodon"],
		"rarity": "uncommon", "passive": false,
		"flavor": "Something moved through the dark a hundred lengths off. You tracked it by sound alone. Nothing else here registered it.",
		"effects": {},
		"choices": [
			{ "label": "Stalk it now",    "icon": "hunt",  "sublabel": "You have information it doesn't", "action": "stalk_now" },
			{ "label": "Map and wait",    "icon": "stalk", "sublabel": "Learn the full picture",          "action": "mark_and_wait" },
		],
		"resolve_key": "troodon_night_sense",
	},
	"dilo_ambush_cover": {
		"seasons": ["spring", "summer", "fall"], "trees": ["predator"], "species": ["dilophosaurus"],
		"rarity": "uncommon", "passive": false,
		"flavor": "You have been still long enough that the prey resumed feeding. The cover is ideal. The distance is exact.",
		"effects": {},
		"choices": [
			{ "label": "Burst strike",  "icon": "attack", "sublabel": "The patience paid off",     "action": "burst_strike" },
			{ "label": "Hold longer",   "icon": "stalk",  "sublabel": "Let it settle further in",  "action": "hold_longer" },
			{ "label": "Withdraw",      "icon": "flee",   "sublabel": "Not today",                  "action": "abort" },
		],
		"resolve_key": "dilo_ambush_cover",
	},
	"bambi_terrain_gap": {
		"seasons": ["spring", "summer", "fall"], "trees": ["predator"], "species": ["bambiraptor"],
		"rarity": "common", "passive": false,
		"flavor": "A gap in the rock formation — too narrow for anything your size or larger. The prey went through. So can you.",
		"effects": {},
		"choices": [
			{ "label": "Follow through",  "icon": "hunt",  "sublabel": "Close the distance in the gap",  "action": "follow_through" },
			{ "label": "Cut around",      "icon": "stalk", "sublabel": "Longer, but you know the ground", "action": "cut_around" },
			{ "label": "Leave it",        "icon": "flee",  "sublabel": "Not worth the squeeze",           "action": "leave" },
		],
		"resolve_key": "bambi_terrain_gap",
	},
	"ornith_lizard_burst": {
		"seasons": ["spring", "summer"], "trees": ["predator"], "species": ["ornitholestes"],
		"rarity": "common", "passive": false,
		"flavor": "A small animal bolts from beneath a root and races low across the ground. It is quick, but you may be quicker.",
		"effects": {},
		"choices": [
			{ "label": "Give chase",   "icon": "hunt",  "sublabel": "Close it down fast",  "action": "give_chase" },
			{ "label": "Snap at it",   "icon": "attack","sublabel": "Pure reflex",          "action": "snap_at_it" },
			{ "label": "Let it go",    "icon": "flee",  "sublabel": "Not worth the sprint", "action": "leave" },
		],
		"resolve_key": "ornith_lizard_burst",
	},
	"hypsi_alarm_sprint": {
		"seasons": ["spring", "summer", "fall"], "trees": ["herbivore"], "species": ["hypsilophodon"],
		"rarity": "common", "passive": false,
		"flavor": "The herd breaks into a run. You caught the first signs of panic and already know which way it is heading.",
		"effects": {},
		"choices": [
			{ "label": "Lead the run",    "icon": "hunt",   "sublabel": "Set the pace and direction", "action": "lead_the_run" },
			{ "label": "Sprint the edge", "icon": "flee",   "sublabel": "Peel off and run your line", "action": "sprint_edge" },
			{ "label": "Hold ground",     "icon": "attack", "sublabel": "See what's coming",          "action": "hold_ground" },
		],
		"resolve_key": "hypsi_alarm_sprint",
	},
	"fruitaden_dense_cover": {
		"seasons": ["spring", "summer", "fall"], "trees": ["herbivore"], "species": ["fruitadens"],
		"rarity": "common", "passive": false,
		"flavor": "The undergrowth closes above your head. Larger animals cannot follow you here, and the leaves hide your movements.",
		"effects": {},
		"choices": [
			{ "label": "Move through",    "icon": "stalk", "sublabel": "Use it as cover",         "action": "move_through" },
			{ "label": "Forage here",     "icon": "hunt",  "sublabel": "Feed while hidden",       "action": "forage_hidden" },
			{ "label": "Stay on path",    "icon": "flee",  "sublabel": "Keep moving normally",    "action": "leave" },
		],
		"resolve_key": "fruitaden_dense_cover",
	},
	"yi_qi_night_glide": {
		"seasons": ["summer", "fall"], "trees": ["flyer"], "species": ["yi_qi"],
		"rarity": "uncommon", "passive": false,
		"flavor": "The membrane catches the thermal perfectly. In the dark you have range nothing else here does. The world below is sound and shadow.",
		"effects": {},
		"choices": [
			{ "label": "Extend range",     "icon": "stalk", "sublabel": "Cover distance in the dark",  "action": "extend_range" },
			{ "label": "Strike from dark", "icon": "attack","sublabel": "The prey can't locate you",   "action": "strike_from_dark" },
			{ "label": "Roost",            "icon": "flee",  "sublabel": "Recover instead",             "action": "roost" },
		],
		"resolve_key": "yi_qi_night_glide",
	},
	"archae_mode_switch": {
		"seasons": ["spring", "summer", "fall"], "trees": ["flyer"], "species": ["archaeopteryx"],
		"rarity": "common", "passive": false,
		"flavor": "The predator behind you is faster on flat ground. Above you — a climbable trunk, a branch, and clear air. It cannot follow you up.",
		"effects": {},
		"choices": [
			{ "label": "Climb and glide",   "icon": "flee",   "sublabel": "Air is yours, ground is not", "action": "climb_and_glide" },
			{ "label": "Sprint and dodge",  "icon": "stalk",  "sublabel": "Ground escape attempt",       "action": "sprint_and_dodge" },
			{ "label": "Turn and fight",    "icon": "attack", "sublabel": "Make it cost something",      "action": "turn_and_fight" },
		],
		"resolve_key": "archae_mode_switch",
	},
	"nemi_canopy_thread": {
		"seasons": ["spring", "summer", "fall"], "trees": ["flyer"], "species": ["nemicolopterus"],
		"rarity": "common", "passive": false,
		"flavor": "A corridor through the canopy at your exact scale — too dense for anything larger to follow. Straight through to the far side.",
		"effects": {},
		"choices": [
			{ "label": "Take the shortcut",  "icon": "hunt",  "sublabel": "Fast — costs stamina",         "action": "take_shortcut" },
			{ "label": "Go around",          "icon": "stalk", "sublabel": "Longer but easier",            "action": "go_around" },
			{ "label": "Land and walk it",   "icon": "flee",  "sublabel": "Ground level through the gap", "action": "land_and_walk" },
		],
		"resolve_key": "nemi_canopy_thread",
	},

	# ══ DISCOVERY / AMBIGUOUS ════════════════════════════════════════════════════

	"tar_seep": {
		"seasons": ["summer", "fall"], "trees": ["all"], "rarity": "uncommon", "passive": false,
		"flavor": "Dark tar seeps into a hollow in the rock. Its heavy smell fills the air, and a large animal lies trapped in the center.",
		"effects": {},
		"choices": [
			{ "label": "Wade in for it",   "icon": "hunt",  "sublabel": "There's meat in there",      "action": "wade_in" },
			{ "label": "Probe the edge",   "icon": "stalk", "sublabel": "Stay on solid ground",       "action": "probe_edge" },
			{ "label": "Leave it",         "icon": "flee",  "sublabel": "The ground doesn't feel right","action": "leave" },
		],
		"resolve_key": "tar_seep",
	},
	"cave_hollow": {
		"seasons": ["fall", "winter"], "trees": ["predator", "herbivore"], "rarity": "uncommon", "passive": false,
		"flavor": "Warm air drifts from a dark opening in the rock. You hear nothing inside, but the silence tells you little.",
		"effects": {},
		"choices": [
			{ "label": "Go in",            "icon": "hunt",  "sublabel": "Warmth, maybe food",         "action": "enter_cave" },
			{ "label": "Check first",      "icon": "stalk", "sublabel": "Know before committing",     "action": "check_entrance" },
			{ "label": "Keep moving",      "icon": "flee",  "sublabel": "Not worth the gamble",       "action": "leave" },
		],
		"resolve_key": "cave_hollow",
	},
	"glowing_pool": {
		"seasons": ["spring", "summer"], "trees": ["all"], "rarity": "rare", "passive": false,
		"flavor": "Water has collected in a rock basin, tinted blue-green in the low light. Fresh tracks show that other animals have drunk here.",
		"effects": {},
		"choices": [
			{ "label": "Drink",            "icon": "hunt",  "sublabel": "The tracks say it's fine",   "action": "drink_pool" },
			{ "label": "Smell it first",   "icon": "stalk", "sublabel": "Trust your senses",          "action": "smell_first" },
			{ "label": "Move on",          "icon": "flee",  "sublabel": "Something feels wrong",      "action": "leave" },
		],
		"resolve_key": "glowing_pool",
	},
	"fallen_nest": {
		"seasons": ["spring", "summer"], "trees": ["all"], "rarity": "common", "passive": false,
		"flavor": "A large nest has fallen from the canopy. Its eggs are still intact, and the parent may be nearby.",
		"effects": {},
		"choices": [
			{ "label": "Take the eggs now", "icon": "hunt",  "sublabel": "Quick and committed",       "action": "raid_eggs" },
			{ "label": "Watch the sky",     "icon": "stalk", "sublabel": "Make sure it's clear",      "action": "watch_sky" },
			{ "label": "Leave them",        "icon": "flee",  "sublabel": "Not worth the attention",   "action": "leave" },
		],
		"resolve_key": "fallen_nest",
	},
	"bone_cache": {
		"seasons": ["spring", "summer", "fall", "winter"], "trees": ["predator", "flyer"], "rarity": "uncommon", "passive": false,
		"flavor": "The scent of buried meat rises from the ground. Another hunter cached a kill here, but you cannot tell when it will return.",
		"effects": {},
		"choices": [
			{ "label": "Dig it up",        "icon": "hunt",  "sublabel": "Cached food — take it",     "action": "dig_cache" },
			{ "label": "Scent the area",   "icon": "stalk", "sublabel": "Make sure it's abandoned",  "action": "scent_first" },
			{ "label": "Leave it",         "icon": "flee",  "sublabel": "Someone may be watching",   "action": "leave" },
		],
		"resolve_key": "bone_cache",
	},
	"sleeping_creature": {
		"seasons": ["spring", "summer", "fall"], "trees": ["predator"], "rarity": "uncommon", "passive": false,
		"flavor": "A large animal rests in the shade, its flanks rising and falling. It appears to be asleep, leaving you an opening.",
		"effects": {},
		"choices": [
			{ "label": "Strike now",       "icon": "attack","sublabel": "While it can't react",      "action": "ambush_sleeping" },
			{ "label": "Circle first",     "icon": "stalk", "sublabel": "Get the right angle",       "action": "circle_it" },
			{ "label": "Leave it",         "icon": "flee",  "sublabel": "Something feels off",       "action": "leave" },
		],
		"resolve_key": "sleeping_creature",
	},
	"strange_growth": {
		"seasons": ["spring", "summer"], "trees": ["all"], "rarity": "uncommon", "passive": false,
		"flavor": "Dense, pale plants grow in an unfamiliar patch. Their faint scent is pleasant, and other animals have nibbled at the edges.",
		"effects": {},
		"choices": [
			{ "label": "Eat freely",       "icon": "hunt",  "sublabel": "Others have — probably safe","action": "eat_freely" },
			{ "label": "Taste carefully",  "icon": "stalk", "sublabel": "Small amount, see what happens","action": "taste_carefully" },
			{ "label": "Leave it",         "icon": "flee",  "sublabel": "Don't touch what you don't know","action": "leave" },
		],
		"resolve_key": "strange_growth",
	},

	# ══ WINTER EXPANDED ══════════════════════════════════════════════════════════

	"migrant_stragglers": {
		"seasons": ["winter"], "trees": ["predator"], "rarity": "common", "passive": false,
		"flavor": "An animal struggles through the snow ahead. Its slow, uneven steps suggest it could not keep up with the migration.",
		"effects": {},
		"choices": [
			{ "label": "Strike now",       "icon": "attack","sublabel": "End it fast",              "action": "straggler_attack" },
			{ "label": "Circle for weakness","icon": "stalk","sublabel": "Find the right moment",   "action": "straggler_circle" },
			{ "label": "Leave it",         "icon": "flee",  "sublabel": "Too cold to risk injury",  "action": "leave" },
		],
		"resolve_key": "migrant_stragglers",
	},
	"storm_driven_prey": {
		"seasons": ["winter"], "trees": ["predator"], "rarity": "uncommon", "passive": false,
		"flavor": "An animal emerges from the blizzard, stumbling into the wind. It seems too disoriented to notice you.",
		"effects": {},
		"choices": [
			{ "label": "Intercept it",     "icon": "hunt",  "sublabel": "Cut it off now",           "action": "intercept_prey" },
			{ "label": "Let it tire",      "icon": "stalk", "sublabel": "Follow until it slows",    "action": "follow_exhausted" },
			{ "label": "Let it pass",      "icon": "flee",  "sublabel": "The storm is dangerous",   "action": "leave" },
		],
		"resolve_key": "storm_driven_prey",
	},
	"frozen_kill_theft": {
		"seasons": ["winter"], "trees": ["predator", "flyer"], "rarity": "common", "passive": false,
		"flavor": "A smaller predator feeds at the ice edge. It has not noticed you approaching its kill.",
		"effects": {},
		"choices": [
			{ "label": "Drive it off",     "icon": "attack","sublabel": "Take the kill",            "action": "drive_off_scavenger" },
			{ "label": "Rush in fast",     "icon": "hunt",  "sublabel": "Don't give it a chance",   "action": "rush_kill" },
			{ "label": "Watch it leave",   "icon": "stalk", "sublabel": "Wait — it may finish soon","action": "wait_departure" },
		],
		"resolve_key": "frozen_kill_theft",
	},
	"ice_shelf_collapse": {
		"seasons": ["winter"], "trees": ["all"], "rarity": "uncommon", "passive": false,
		"flavor": "Tracks lead across the frozen river. The far bank offers food and shelter, but you still have to trust the ice.",
		"effects": {},
		"choices": [
			{ "label": "Cross quickly",    "icon": "hunt",  "sublabel": "Speed reduces time on ice", "action": "cross_fast" },
			{ "label": "Test as you go",   "icon": "stalk", "sublabel": "Slow, but you'll know",    "action": "cross_careful" },
			{ "label": "Find another way", "icon": "flee",  "sublabel": "Not worth the risk",       "action": "leave" },
		],
		"resolve_key": "ice_shelf_collapse",
	},
	"starvation_rival": {
		"seasons": ["winter"], "trees": ["all"], "rarity": "common", "passive": false,
		"flavor": "One of your own kind stands ahead, ribs showing beneath its skin. Its eyes follow you, but it gives no familiar greeting.",
		"effects": {},
		"choices": [
			{ "label": "Drive it away",    "icon": "attack","sublabel": "Don't share this ground",  "action": "drive_rival" },
			{ "label": "Hold your ground", "icon": "stalk", "sublabel": "See what it does",         "action": "hold_rival" },
			{ "label": "Give ground",      "icon": "flee",  "sublabel": "Not the fight for this season","action": "leave" },
		],
		"resolve_key": "starvation_rival",
	},
	"frost_hollow": {
		"seasons": ["winter"], "trees": ["flyer"], "rarity": "common", "passive": false,
		"flavor": "A depression in the rock face where warm air rises and collects. You feel it from above. Other flyers have already found it.",
		"effects": {},
		"choices": [
			{ "label": "Claim the hollow", "icon": "attack","sublabel": "Drive them out",           "action": "claim_hollow" },
			{ "label": "Share the space",  "icon": "stalk", "sublabel": "Warmth over territory",   "action": "share_hollow" },
			{ "label": "Circle and wait",  "icon": "flee",  "sublabel": "See who leaves first",     "action": "wait_hollow" },
		],
		"resolve_key": "frost_hollow",
	},
	"winter_burrow": {
		"seasons": ["winter"], "trees": ["herbivore"], "rarity": "common", "passive": false,
		"flavor": "A hollow in the hillside holds a thick bed of old leaves. It could shelter one animal, though fresh scratches mark the entrance.",
		"effects": {},
		"choices": [
			{ "label": "Move in",          "icon": "attack","sublabel": "You need this",            "action": "take_burrow" },
			{ "label": "Check carefully",  "icon": "stalk", "sublabel": "Make sure it's empty",    "action": "scout_burrow" },
			{ "label": "Keep moving",      "icon": "flee",  "sublabel": "Not worth the risk",       "action": "leave" },
		],
		"resolve_key": "winter_burrow",
	},
	"ice_fish_run": {
		"seasons": ["winter"], "trees": ["predator", "flyer"], "rarity": "uncommon", "passive": false,
		"flavor": "Open water at the river bend where the current keeps the ice thin. Fish are stacked in the slow eddy, visible and sluggish with cold.",
		"effects": {},
		"choices": [
			{ "label": "Wade in for them", "icon": "hunt",  "sublabel": "Cold but there's plenty",  "action": "wade_fish" },
			{ "label": "Strike from bank", "icon": "stalk", "sublabel": "Stay dry, take fewer",     "action": "bank_fish" },
			{ "label": "Move on",          "icon": "flee",  "sublabel": "Too exposed here",         "action": "leave" },
		],
		"resolve_key": "ice_fish_run",
	},
	"desperate_feeding": {
		"seasons": ["winter"], "trees": ["all"], "rarity": "common", "passive": false,
		"flavor": "Hunger has driven you to food you would normally avoid. Pale, stringy scraps lie underfoot, offering another uncertain meal.",
		"effects": {},
		"choices": [
			{ "label": "Eat it",           "icon": "hunt",  "sublabel": "Something is better than nothing","action": "eat_desperate" },
			{ "label": "Investigate first","icon": "stalk", "sublabel": "Make sure it's edible",   "action": "investigate_food" },
			{ "label": "Hold out",         "icon": "flee",  "sublabel": "Find something better",   "action": "leave" },
		],
		"resolve_key": "desperate_feeding",
	},
	"whiteout": {
		"seasons": ["winter"], "trees": ["all"], "rarity": "uncommon", "passive": false,
		"flavor": "Snow falls so thickly that your landmarks vanish. You have a rough sense of the way home, but little else to guide you.",
		"effects": {},
		"choices": [
			{ "label": "Push through",     "icon": "attack","sublabel": "Keep moving, trust yourself","action": "push_through" },
			{ "label": "Shelter and wait", "icon": "flee",  "sublabel": "Ride it out",              "action": "shelter_wait" },
			{ "label": "Navigate carefully","icon": "stalk","sublabel": "Slow and methodical",      "action": "navigate_careful" },
		],
		"resolve_key": "whiteout",
	},
	"carrion_circuit": {
		"seasons": ["winter"], "trees": ["predator", "flyer"], "rarity": "rare", "passive": false,
		"flavor": "You find three carcasses within half a day, each abandoned after a few bites. Whatever killed them may still be nearby.",
		"effects": {},
		"choices": [
			{ "label": "Follow the kills", "icon": "hunt",  "sublabel": "Find what's doing this",   "action": "track_killer" },
			{ "label": "Take what's here", "icon": "attack","sublabel": "Eat and move fast",        "action": "feed_and_go" },
			{ "label": "Get clear",        "icon": "flee",  "sublabel": "Don't be next",            "action": "leave" },
		],
		"resolve_key": "carrion_circuit",
	},
	"pack_split_winter": {
		"seasons": ["winter"], "trees": ["predator"], "rarity": "uncommon", "passive": false,
		"flavor": "Two pack members want to take a different route through the cold. The others turn toward you, waiting for a decision.",
		"effects": {},
		"choices": [
			{ "label": "Lead forward",     "icon": "attack","sublabel": "Assert the direction",     "action": "lead_pack_forward" },
			{ "label": "Hold together",    "icon": "stalk", "sublabel": "Find a compromise",        "action": "hold_pack_together" },
			{ "label": "Split off alone",  "icon": "flee",  "sublabel": "Move faster without them", "action": "split_from_pack" },
		],
		"resolve_key": "pack_split_winter",
	},

	# ══ TIER 4 / 3 SPECIES-SPECIFIC ══════════════════════════════════════════

	# Predator T4
	"raptor_pack_strike": {
		"seasons": ["spring", "summer", "fall"], "trees": ["predator"], "species": ["velociraptor"],
		"rarity": "uncommon", "passive": false,
		"flavor": "Your pack surrounds the prey on three sides. Both flanks wait for your signal, but the formation will not hold forever.",
		"effects": {},
		"choices": [
			{ "label": "Signal both flanks", "icon": "attack", "sublabel": "Full coordination",          "action": "signal_flanks" },
			{ "label": "Rush in alone",       "icon": "hunt",   "sublabel": "Don't wait for the others", "action": "rush_in_solo" },
			{ "label": "Hold — reset angle",  "icon": "flee",   "sublabel": "The window isn't clean",    "action": "leave" },
		],
		"resolve_key": "raptor_pack_strike",
	},
	"carno_full_sprint": {
		"seasons": ["spring", "summer", "fall"], "trees": ["predator"], "species": ["carnotaurus"],
		"rarity": "uncommon", "passive": false,
		"flavor": "A long stretch of open ground separates you from the prey. It has not spotted you yet. Once you leave cover, you will have to close the distance before it reacts.",
		"effects": {},
		"choices": [
			{ "label": "Full sprint",    "icon": "attack", "sublabel": "Speed is the weapon",      "action": "full_sprint" },
			{ "label": "Cut wide first", "icon": "stalk",  "sublabel": "Safer angle, lower yield",  "action": "cut_wide" },
			{ "label": "Abandon it",     "icon": "flee",   "sublabel": "The ground isn't right",   "action": "leave" },
		],
		"resolve_key": "carno_full_sprint",
	},
	"allo_displacement": {
		"seasons": ["any"], "trees": ["predator"], "species": ["allosaurus"],
		"rarity": "uncommon", "passive": false,
		"flavor": "Three smaller predators feed on a fresh kill below the ridge. They have not seen you. Your size alone may be enough to drive them off.",
		"effects": {},
		"choices": [
			{ "label": "Walk in directly",  "icon": "stalk",  "sublabel": "Let your size do it",   "action": "walk_in_direct" },
			{ "label": "Charge and scatter","icon": "attack", "sublabel": "No ambiguity",           "action": "charge_scatter" },
			{ "label": "Leave it",          "icon": "flee",   "sublabel": "Not worth the contact", "action": "leave" },
		],
		"resolve_key": "allo_displacement",
	},
	"troodon_circuit": {
		"seasons": ["fall", "winter"], "trees": ["predator"], "species": ["troodon_alpha"],
		"rarity": "uncommon", "passive": false,
		"flavor": "The prey follows the same path it took last night. You know the route, and your pack is already waiting along it.",
		"effects": {},
		"choices": [
			{ "label": "Run the circuit",    "icon": "attack", "sublabel": "Full pack, full dark",    "action": "run_circuit" },
			{ "label": "Advance solo first", "icon": "hunt",   "sublabel": "Scout before committing", "action": "solo_advance_night" },
			{ "label": "Hold position",      "icon": "flee",   "sublabel": "Not tonight",             "action": "leave" },
		],
		"resolve_key": "troodon_circuit",
	},

	# Herbivore T3
	"iguan_spike_warning": {
		"seasons": ["any"], "trees": ["herbivore"], "species": ["iguanodon"],
		"rarity": "uncommon", "passive": false,
		"flavor": "A predator has followed you for some time. Now it edges close enough to see your thumb spike. A clear warning may spare you a fight.",
		"effects": {},
		"choices": [
			{ "label": "Present the spike",  "icon": "stalk",  "sublabel": "Show the math clearly",    "action": "present_spike" },
			{ "label": "Charge — spike low", "icon": "attack", "sublabel": "End it before it decides", "action": "charge_spike" },
			{ "label": "Retreat to herd",    "icon": "flee",   "sublabel": "Numbers over tactics",     "action": "retreat_herd" },
		],
		"resolve_key": "iguan_spike_warning",
	},
	"kentro_spine_array": {
		"seasons": ["any"], "trees": ["herbivore"], "species": ["kentrosaurus"],
		"rarity": "uncommon", "passive": false,
		"flavor": "Two predators coordinating their approach. They've identified what they think is the gap. Your spines are already facing that direction. Let them commit or don't.",
		"effects": {},
		"choices": [
			{ "label": "Hold — let them in", "icon": "stalk",  "sublabel": "Spines are the answer", "action": "hold_spine_wall" },
			{ "label": "Pivot and swing",    "icon": "attack", "sublabel": "Active counter",        "action": "pivot_swing" },
			{ "label": "Break for cover",    "icon": "flee",   "sublabel": "Outrun the geometry",   "action": "flee_cover" },
		],
		"resolve_key": "kentro_spine_array",
	},
	"stego_thagomizer": {
		"seasons": ["any"], "trees": ["herbivore"], "species": ["stegosaurus"],
		"rarity": "uncommon", "passive": false,
		"flavor": "It came from behind — the angle that reads as the right approach. The thagomizer was already tracking the sound of it before you turned.",
		"effects": {},
		"choices": [
			{ "label": "Full swing",    "icon": "attack", "sublabel": "Let the tail finish it",  "action": "full_swing" },
			{ "label": "Turn and face", "icon": "stalk",  "sublabel": "Deny it the back angle",  "action": "turn_face" },
			{ "label": "Move forward",  "icon": "flee",   "sublabel": "Don't give it the range", "action": "lunge_forward_stego" },
		],
		"resolve_key": "stego_thagomizer",
	},
	"pachy_dome_drive": {
		"seasons": ["any"], "trees": ["herbivore"], "species": ["pachycephalosaurus"],
		"rarity": "uncommon", "passive": false,
		"flavor": "A rival has been crossing your range for two days. Not a predator — competition that knows exactly what you are. It's been reading your patterns. One of you is going to own this ground.",
		"effects": {},
		"choices": [
			{ "label": "Dome charge",     "icon": "attack", "sublabel": "Let it be decided once",    "action": "dome_charge" },
			{ "label": "Display — hold",  "icon": "stalk",  "sublabel": "Show it without contact",   "action": "display_dome" },
			{ "label": "Cede the ground", "icon": "flee",   "sublabel": "This range isn't worth it", "action": "leave" },
		],
		"resolve_key": "pachy_dome_drive",
	},

	# Flyer T3
	"ptero_colony_dive": {
		"seasons": ["spring", "summer"], "trees": ["flyer"], "species": ["pterodactylus"],
		"rarity": "uncommon", "passive": false,
		"flavor": "The thermal pushed a shoal into the shallows. The colony is already climbing for angle. Three — maybe four — passes before the fish scatter.",
		"effects": {},
		"choices": [
			{ "label": "Lead the dive",        "icon": "attack", "sublabel": "Set the line for the colony", "action": "lead_colony_dive" },
			{ "label": "Follow the formation", "icon": "stalk",  "sublabel": "Let someone else break it",   "action": "follow_colony_dive" },
			{ "label": "Circle and wait",      "icon": "flee",   "sublabel": "Find a cleaner angle",        "action": "circle_wait_dive" },
		],
		"resolve_key": "ptero_colony_dive",
	},
	"rhamph_dusk_window": {
		"seasons": ["summer", "fall"], "trees": ["flyer"], "species": ["rhamphorhynchus"],
		"rarity": "uncommon", "passive": false,
		"flavor": "Thirty minutes before dark the surface goes flat. The fish come up. You know this window — it closes in one pass and doesn't repeat. The rest of your range is still roosting.",
		"effects": {},
		"choices": [
			{ "label": "Low surface run",   "icon": "hunt",   "sublabel": "Multiple fast passes", "action": "surface_run" },
			{ "label": "Single clean dive", "icon": "attack", "sublabel": "One precise strike",   "action": "precision_dive" },
			{ "label": "Miss the window",   "icon": "flee",   "sublabel": "Let it pass",          "action": "leave" },
		],
		"resolve_key": "rhamph_dusk_window",
	},
	"ptero_offshore_run": {
		"seasons": ["summer"], "trees": ["flyer"], "species": ["pteranodon"],
		"rarity": "rare", "passive": false,
		"flavor": "The offshore thermals are running hard. Two days out there are fish schools nothing else in this range can reach. The soaring is free — the question is whether your stamina holds for the return.",
		"effects": {},
		"choices": [
			{ "label": "Commit offshore", "icon": "attack", "sublabel": "Full run — high yield",     "action": "go_offshore" },
			{ "label": "Work the coast",  "icon": "stalk",  "sublabel": "Safer range, lower reward", "action": "coast_work" },
			{ "label": "Stay grounded",   "icon": "flee",   "sublabel": "Conditions aren't certain", "action": "leave" },
		],
		"resolve_key": "ptero_offshore_run",
	},
	"dsun_tidal_flat": {
		"seasons": ["fall", "winter"], "trees": ["flyer"], "species": ["dsungaripterus"],
		"rarity": "uncommon", "passive": false,
		"flavor": "The tide has exposed the flat. Dense shellfish — the kind of find that covers a week of hunger. The colony spotted it at the same time you did.",
		"effects": {},
		"choices": [
			{ "label": "Feed fast — claim it", "icon": "attack", "sublabel": "Get the best before the colony", "action": "feed_fast_claim" },
			{ "label": "Feed with the colony", "icon": "stalk",  "sublabel": "Share and stay safe",            "action": "feed_colony_share" },
			{ "label": "Mark and return",      "icon": "flee",   "sublabel": "Remember this location",         "action": "mark_and_return" },
		],
		"resolve_key": "dsun_tidal_flat",
	},

	# ══ PREDATOR T1–T3 SPECIES-SPECIFIC (REMAINING) ══════════════════════════

	"sino_still_hunt": {
		"seasons": ["spring", "summer", "fall"], "trees": ["predator"], "species": ["sinosauropteryx"],
		"rarity": "uncommon", "passive": false,
		"flavor": "You have stood still long enough for the prey to return to feeding nearby. Your feathers blend into the cover, hiding your outline.",
		"effects": {},
		"choices": [
			{ "label": "Strike now",        "icon": "attack", "sublabel": "The patience paid off",      "action": "burst_strike" },
			{ "label": "Closer first",      "icon": "stalk",  "sublabel": "Cut the distance in half",   "action": "close_quietly" },
			{ "label": "Hold — read more",  "icon": "flee",   "sublabel": "The angle could be better",  "action": "hold_longer" },
		],
		"resolve_key": "sino_still_hunt",
	},

	# ══ PREDATOR T5 SPECIES-SPECIFIC ═════════════════════════════════════════

	"yuty_cold_range": {
		"seasons": ["fall", "winter"], "trees": ["predator"], "species": ["yutyrannus"],
		"rarity": "uncommon", "passive": false,
		"flavor": "The temperature dropped overnight, leaving other predators sluggish. The prey still has to feed, and your feathers help you keep moving in the cold.",
		"effects": {},
		"choices": [
			{ "label": "Hunt the cold hours",  "icon": "hunt",   "sublabel": "No competition right now",  "action": "hunt_cold" },
			{ "label": "Range further",        "icon": "stalk",  "sublabel": "Map the extended territory","action": "range_wide" },
			{ "label": "Rest and recover",     "icon": "flee",   "sublabel": "Save the energy",           "action": "rest" },
		],
		"resolve_key": "yuty_cold_range",
	},
	"giga_pack_coordinate": {
		"seasons": ["spring", "summer", "fall"], "trees": ["predator"], "species": ["giganotosaurus"],
		"rarity": "uncommon", "passive": false,
		"flavor": "Your pack has separated a sauropod from its herd. The hunters are in position, but bringing down prey this large will take commitment.",
		"effects": {},
		"choices": [
			{ "label": "Call the full press",   "icon": "attack", "sublabel": "Everyone in — end it fast",   "action": "call_full_press" },
			{ "label": "Harass and exhaust",    "icon": "hunt",   "sublabel": "Slower but safer",            "action": "harass_exhaust" },
			{ "label": "Hold — read the herd",  "icon": "flee",   "sublabel": "The main herd may return",    "action": "leave" },
		],
		"resolve_key": "giga_pack_coordinate",
	},
	"carchar_bite_hold": {
		"seasons": ["any"], "trees": ["predator"], "species": ["carcharodontosaurus"],
		"rarity": "uncommon", "passive": false,
		"flavor": "You catch up with prey wounded in an earlier hunt. The deep bite has not healed, and blood loss is slowing it down.",
		"effects": {},
		"choices": [
			{ "label": "Follow and wait",  "icon": "stalk",  "sublabel": "The wound finishes it",    "action": "follow_and_wait" },
			{ "label": "Press now",        "icon": "attack", "sublabel": "Close it out quickly",     "action": "press_now" },
			{ "label": "Cut it loose",     "icon": "flee",   "sublabel": "Not worth prolonged risk", "action": "leave" },
		],
		"resolve_key": "carchar_bite_hold",
	},
	"spino_river_claim": {
		"seasons": ["spring", "summer"], "trees": ["predator"], "species": ["spinosaurus"],
		"rarity": "uncommon", "passive": false,
		"flavor": "A section of river your size has not crossed in several seasons. The fish are dense here and the bank is clear. Something else was here before. It isn't here now.",
		"effects": {},
		"choices": [
			{ "label": "Wade in and feed",    "icon": "hunt",   "sublabel": "Claim the stretch",        "action": "wade_and_feed" },
			{ "label": "Mark the territory",  "icon": "stalk",  "sublabel": "Establish presence first", "action": "mark_territory" },
			{ "label": "Stay downstream",     "icon": "flee",   "sublabel": "Known water is safer",     "action": "leave" },
		],
		"resolve_key": "spino_river_claim",
	},
	"tarbo_territory_press": {
		"seasons": ["fall", "winter"], "trees": ["predator"], "species": ["tarbosaurus"],
		"rarity": "uncommon", "passive": false,
		"flavor": "A younger apex predator has been patrolling your northern edge for a week. There is room in your range, but ignoring its claim may encourage it to move farther in.",
		"effects": {},
		"choices": [
			{ "label": "Drive it out now",    "icon": "attack", "sublabel": "End the question today",   "action": "drive_out" },
			{ "label": "Mark and trail it",   "icon": "stalk",  "sublabel": "Make it feel watched",     "action": "trail_mark" },
			{ "label": "Expand elsewhere",    "icon": "flee",   "sublabel": "Range is wide enough",     "action": "expand_range" },
		],
		"resolve_key": "tarbo_territory_press",
	},

	# ══ PREDATOR T6 SPECIES-SPECIFIC ═════════════════════════════════════════

	"trex_bite_test": {
		"seasons": ["any"], "trees": ["predator"], "species": ["trex"],
		"rarity": "uncommon", "passive": false,
		"flavor": "A large armored animal feeds alone in a clearing. Your powerful bite could break through its plating, but getting close carries its own risk.",
		"effects": {},
		"choices": [
			{ "label": "Commit — bite through", "icon": "attack", "sublabel": "The force is there",         "action": "bite_through" },
			{ "label": "Harass and wait",        "icon": "stalk",  "sublabel": "See how it responds first", "action": "harass_and_wait" },
			{ "label": "Leave it alone",         "icon": "flee",   "sublabel": "The risk isn't worth it",   "action": "leave" },
		],
		"resolve_key": "trex_bite_test",
	},

	# ══ PREDATOR T7 LEGENDARY SPECIES-SPECIFIC ═══════════════════════════════

	"old_king_range_walk": {
		"seasons": ["any"], "trees": ["predator"], "species": ["trex_old_king"],
		"rarity": "rare", "passive": false,
		"flavor": "You have held this range for many seasons. Three days ago, a younger predator crossed into its heart. Now the smaller animals scatter as you follow its trail.",
		"effects": {},
		"choices": [
			{ "label": "Walk toward it",    "icon": "stalk",  "sublabel": "The presence alone resolves it", "action": "walk_toward" },
			{ "label": "Drive it hard",     "icon": "attack", "sublabel": "Make it permanent",              "action": "drive_hard" },
			{ "label": "Let it run itself", "icon": "flee",   "sublabel": "Your range is not worth injury", "action": "leave" },
		],
		"resolve_key": "old_king_range_walk",
	},
	"spino_river_depth": {
		"seasons": ["spring", "summer"], "trees": ["predator"], "species": ["spinosaurus_river_monster"],
		"rarity": "rare", "passive": false,
		"flavor": "The deep channel — the one other things avoid. From below the water the prey is backlit against the sky. You have done this before. The depth is familiar.",
		"effects": {},
		"choices": [
			{ "label": "Strike from below",  "icon": "attack", "sublabel": "The kill angle is perfect",     "action": "strike_from_below" },
			{ "label": "Surface and press",  "icon": "hunt",   "sublabel": "Conventional but reliable",     "action": "surface_press" },
			{ "label": "Hold and read it",   "icon": "flee",   "sublabel": "Not the right moment",          "action": "leave" },
		],
		"resolve_key": "spino_river_depth",
	},
	"giga_matriarch_call": {
		"seasons": ["spring", "summer", "fall"], "trees": ["predator"], "species": ["giganotosaurus_pack_matriarch"],
		"rarity": "rare", "passive": false,
		"flavor": "Three younger hunters have started hunts without waiting for your signal. A well-timed call could bring them back into line before the pack divides.",
		"effects": {},
		"choices": [
			{ "label": "Assert the call",   "icon": "attack", "sublabel": "Command — not request",    "action": "assert_command" },
			{ "label": "Run the hunt first","icon": "hunt",   "sublabel": "Show rather than tell",    "action": "lead_by_example" },
			{ "label": "Watch and assess",  "icon": "stalk",  "sublabel": "Not every breach needs a response", "action": "observe" },
		],
		"resolve_key": "giga_matriarch_call",
	},
	"red_maw_challenge": {
		"seasons": ["any"], "trees": ["predator"], "species": ["carcharodonto_red_maw"],
		"rarity": "rare", "passive": false,
		"flavor": "Another apex predator has found three of your kills, each larger than the last. Now it follows your trail, studying the hunter behind them.",
		"effects": {},
		"choices": [
			{ "label": "Confront directly",  "icon": "attack", "sublabel": "Let the jaw resolve it",      "action": "confront_direct" },
			{ "label": "Leave a fresh kill", "icon": "stalk",  "sublabel": "Answer with evidence",        "action": "leave_evidence" },
			{ "label": "Move the pattern",   "icon": "flee",   "sublabel": "Stop being trackable",        "action": "shift_pattern" },
		],
		"resolve_key": "red_maw_challenge",
	},

	# ══ HERBIVORE T1–T2 SPECIES-SPECIFIC ═════════════════════════════════════

	"lesotho_herd_signal": {
		"seasons": ["spring", "summer", "fall"], "trees": ["herbivore"], "species": ["lesothosaurus"],
		"rarity": "common", "passive": false,
		"flavor": "Uneasy calls ripple through the herd. You noticed the disturbance before the others and know which way to move, if you choose to lead.",
		"effects": {},
		"choices": [
			{ "label": "Break and lead",    "icon": "flee",   "sublabel": "Set the direction for the herd", "action": "lead_the_run" },
			{ "label": "Signal the edge",   "icon": "stalk",  "sublabel": "Alert without committing",       "action": "signal_edge" },
			{ "label": "Hold and observe",  "icon": "attack", "sublabel": "It may not be a real threat",    "action": "observe" },
		],
		"resolve_key": "lesotho_herd_signal",
	},
	"micro_horn_standoff": {
		"seasons": ["any"], "trees": ["herbivore"], "species": ["microceratus"],
		"rarity": "common", "passive": false,
		"flavor": "An animal twice your size blocks the way to water. It watches you closely, weighing whether to attack. You lower your horn in warning.",
		"effects": {},
		"choices": [
			{ "label": "Lower the horn",    "icon": "attack", "sublabel": "Make the answer clear",     "action": "present_horn" },
			{ "label": "Hold your ground",  "icon": "stalk",  "sublabel": "Wait for it to decide",     "action": "hold_ground_herb" },
			{ "label": "Find another path", "icon": "flee",   "sublabel": "Not every standoff is worth it", "action": "leave" },
		],
		"resolve_key": "micro_horn_standoff",
	},
	"othni_pace_test": {
		"seasons": ["spring", "summer", "fall"], "trees": ["herbivore"], "species": ["othnielia"],
		"rarity": "common", "passive": false,
		"flavor": "A predator has paced the edge of your range for an hour. It stays just out of reach, testing how long you can keep moving.",
		"effects": {},
		"choices": [
			{ "label": "Keep steady pace",  "icon": "flee",   "sublabel": "Outlast it on endurance",    "action": "steady_pace" },
			{ "label": "Sprint — break it", "icon": "hunt",   "sublabel": "Force it to commit or lose", "action": "burst_sprint" },
			{ "label": "Turn toward herd",  "icon": "stalk",  "sublabel": "Numbers change the math",    "action": "rejoin_herd" },
		],
		"resolve_key": "othni_pace_test",
	},
	"chang_kin_gather": {
		"seasons": ["spring", "fall"], "trees": ["herbivore"], "species": ["changchunsaurus"],
		"rarity": "uncommon", "passive": false,
		"flavor": "You find three familiar members of last season's herd. They recognize you at once. Staying close could renew those old bonds.",
		"effects": {},
		"choices": [
			{ "label": "Draw close — bond",  "icon": "stalk",  "sublabel": "Strengthen the network",    "action": "bond_kin" },
			{ "label": "Move together",      "icon": "hunt",   "sublabel": "Travel with them a season", "action": "travel_with_kin" },
			{ "label": "Continue alone",     "icon": "flee",   "sublabel": "The bond holds without it", "action": "leave" },
		],
		"resolve_key": "chang_kin_gather",
	},

	# ══ HERBIVORE T4 SPECIES-SPECIFIC ════════════════════════════════════════

	"trike_frill_charge": {
		"seasons": ["any"], "trees": ["herbivore"], "species": ["triceratops"],
		"rarity": "uncommon", "passive": false,
		"flavor": "A predator circles toward your flank, searching for an opening beside your frill. You turn to face it and lower your head.",
		"effects": {},
		"choices": [
			{ "label": "Full charge — horns first", "icon": "attack", "sublabel": "End the assessment",      "action": "full_horn_charge" },
			{ "label": "Hold and display",           "icon": "stalk",  "sublabel": "Let the frill speak first","action": "display_frill" },
			{ "label": "Retreat to herd position",   "icon": "flee",   "sublabel": "Numbers make this easier","action": "retreat_herd" },
		],
		"resolve_key": "trike_frill_charge",
	},
	"anky_tail_arc": {
		"seasons": ["any"], "trees": ["herbivore"], "species": ["ankylosaurus"],
		"rarity": "uncommon", "passive": false,
		"flavor": "The predator approaches from behind. You track its steps by sound, shifting your heavy tail before you turn.",
		"effects": {},
		"choices": [
			{ "label": "Full tail swing",   "icon": "attack", "sublabel": "The club ends it",            "action": "full_tail_swing" },
			{ "label": "Pivot — face it",   "icon": "stalk",  "sublabel": "Deny the angle it wanted",   "action": "pivot_face_anky" },
			{ "label": "Lock down — wait",  "icon": "flee",   "sublabel": "Armor up, wait it out",      "action": "lock_down_armor" },
		],
		"resolve_key": "anky_tail_arc",
	},
	"para_long_call": {
		"seasons": ["spring", "summer", "fall"], "trees": ["herbivore"], "species": ["parasaurolophus"],
		"rarity": "uncommon", "passive": false,
		"flavor": "The herd is fragmented — a section is two ridges over and out of sight. The crest call carries across terrain that sight and scent don't. One signal from you brings them or tells them to move.",
		"effects": {},
		"choices": [
			{ "label": "Call — assembly",   "icon": "hunt",   "sublabel": "Bring them together",       "action": "call_assembly" },
			{ "label": "Call — warning",    "icon": "attack", "sublabel": "Alert without moving",      "action": "call_warning" },
			{ "label": "Move toward them",  "icon": "flee",   "sublabel": "Close the distance first",  "action": "move_toward_herd" },
		],
		"resolve_key": "para_long_call",
	},
	"edmont_migration_lead": {
		"seasons": ["fall"], "trees": ["herbivore"], "species": ["edmontosaurus"],
		"rarity": "uncommon", "passive": false,
		"flavor": "The herd is at the edge of the known range. The route south is the one it has run before — but conditions have changed this season and the usual path has dried up. The herd is waiting for someone to commit.",
		"effects": {},
		"choices": [
			{ "label": "Take the known path", "icon": "stalk",  "sublabel": "Familiar risk",              "action": "known_path" },
			{ "label": "Lead a new route",    "icon": "hunt",   "sublabel": "Scout ahead, herd follows",  "action": "new_route" },
			{ "label": "Hold and wait",       "icon": "flee",   "sublabel": "See if conditions change",   "action": "hold_migration" },
		],
		"resolve_key": "edmont_migration_lead",
	},

	# ══ HERBIVORE T5 SPECIES-SPECIFIC ════════════════════════════════════════

	"diplo_tail_clear": {
		"seasons": ["any"], "trees": ["herbivore"], "species": ["diplodocus"],
		"rarity": "uncommon", "passive": false,
		"flavor": "Two predators coordinating at flank distance — the standard approach for things your size. The tail has more arc than any predator in this range has fully understood yet.",
		"effects": {},
		"choices": [
			{ "label": "Sweep the arc",    "icon": "attack", "sublabel": "Full tail range — both flanks", "action": "tail_sweep_wide" },
			{ "label": "Target one",       "icon": "stalk",  "sublabel": "Precise, focused swing",       "action": "tail_target_one" },
			{ "label": "Move away",        "icon": "flee",   "sublabel": "Distance is the safer answer",  "action": "leave" },
		],
		"resolve_key": "diplo_tail_clear",
	},
	"apato_herd_anchor": {
		"seasons": ["spring", "summer"], "trees": ["herbivore"], "species": ["apatosaurus"],
		"rarity": "uncommon", "passive": false,
		"flavor": "A narrow canyon has split the herd into two groups. Smaller members watch you from either side, waiting to see which route you take.",
		"effects": {},
		"choices": [
			{ "label": "Hold center",     "icon": "stalk",  "sublabel": "Keep both groups in range",   "action": "hold_center" },
			{ "label": "Move to the left","icon": "hunt",   "sublabel": "Anchor the larger group",     "action": "move_left_group" },
			{ "label": "Push through",    "icon": "flee",   "sublabel": "Force the canyon — herd follows","action": "push_through_canyon" },
		],
		"resolve_key": "apato_herd_anchor",
	},
	"brachi_high_browse": {
		"seasons": ["summer", "fall"], "trees": ["herbivore"], "species": ["brachiosaurus"],
		"rarity": "common", "passive": false,
		"flavor": "Untouched leaves fill the canopy above. Your long neck brings them within reach; now you must decide how long to feed.",
		"effects": {},
		"choices": [
			{ "label": "Browse heavily",  "icon": "hunt",  "sublabel": "Take your fill — no competition", "action": "browse_heavy" },
			{ "label": "Move and browse", "icon": "stalk", "sublabel": "Cover ground while feeding",      "action": "browse_and_move" },
			{ "label": "Eat lower fare",  "icon": "flee",  "sublabel": "Save the canopy for tomorrow",    "action": "eat_low" },
		],
		"resolve_key": "brachi_high_browse",
	},
	"shan_herd_signal": {
		"seasons": ["spring", "summer", "fall"], "trees": ["herbivore"], "species": ["shantungosaurus"],
		"rarity": "uncommon", "passive": false,
		"flavor": "The herd is spread across three ridges. Your crest call is the only signal that reaches all of them simultaneously. What you call next sets the direction for all of them.",
		"effects": {},
		"choices": [
			{ "label": "Call — gather",    "icon": "hunt",   "sublabel": "Bring all three groups in",  "action": "call_gather_all" },
			{ "label": "Call — move out",  "icon": "stalk",  "sublabel": "Signal the migration",       "action": "call_move_out" },
			{ "label": "Stay quiet",       "icon": "flee",   "sublabel": "Not the moment for a call",  "action": "leave" },
		],
		"resolve_key": "shan_herd_signal",
	},

	# ══ HERBIVORE T6–T7 SPECIES-SPECIFIC ═════════════════════════════════════

	"argent_nothing_challenges": {
		"seasons": ["any"], "trees": ["herbivore"], "species": ["argentinosaurus"],
		"rarity": "rare", "passive": false,
		"flavor": "A predator has followed you for two days. It is large enough to notice but too small to threaten you alone. At last, it turns away.",
		"effects": {},
		"choices": [
			{ "label": "Continue grazing",   "icon": "hunt",  "sublabel": "It resolved itself",          "action": "continue_graze" },
			{ "label": "Turn toward it",     "icon": "stalk", "sublabel": "Acknowledge it — it leaves faster","action": "turn_toward_tracker" },
			{ "label": "Move away — graze",  "icon": "flee",  "sublabel": "Put the ridge between you",   "action": "leave" },
		],
		"resolve_key": "argent_nothing_challenges",
	},
	"dread_size_reckoning": {
		"seasons": ["any"], "trees": ["herbivore"], "species": ["dreadnoughtus"],
		"rarity": "rare", "passive": false,
		"flavor": "The largest predator in the region watches from a ridge. You hold its gaze until it finally descends the far side.",
		"effects": {},
		"choices": [
			{ "label": "Continue feeding",  "icon": "hunt",  "sublabel": "The conclusion was always this", "action": "continue_graze" },
			{ "label": "Move toward it",    "icon": "attack","sublabel": "Make the decision faster",       "action": "move_toward_pred" },
			{ "label": "Shift position",    "icon": "flee",  "sublabel": "Put the herd between you",       "action": "shift_to_herd" },
		],
		"resolve_key": "dread_size_reckoning",
	},
	"patago_ground_weight": {
		"seasons": ["summer", "fall"], "trees": ["herbivore"], "species": ["patagotitan"],
		"rarity": "rare", "passive": false,
		"flavor": "The riverbank shifts beneath your feet. The herd follows the firmer edge, but crossing the unstable center would cut the journey in half.",
		"effects": {},
		"choices": [
			{ "label": "Cross direct",     "icon": "hunt",  "sublabel": "Shorten the route — risk the footing", "action": "cross_direct_heavy" },
			{ "label": "Follow the edge",  "icon": "stalk", "sublabel": "Slower, stable ground",                "action": "follow_edge" },
			{ "label": "Lead the herd around","icon": "flee","sublabel": "No risk to anyone",                   "action": "lead_around" },
		],
		"resolve_key": "patago_ground_weight",
	},
	"super_reach_test": {
		"seasons": ["any"], "trees": ["herbivore"], "species": ["supersaurus"],
		"rarity": "uncommon", "passive": false,
		"flavor": "Fresh leaves grow well above the reach of smaller herbivores. Your long neck reaches them easily, while your tail keeps nearby animals at a distance.",
		"effects": {},
		"choices": [
			{ "label": "Neck up — feed deep","icon": "hunt",  "sublabel": "Full canopy access",          "action": "browse_canopy_high" },
			{ "label": "Feed and watch",     "icon": "stalk", "sublabel": "Read the ground while eating", "action": "feed_and_watch" },
			{ "label": "Move on",            "icon": "flee",  "sublabel": "Not worth the exposure",       "action": "leave" },
		],
		"resolve_key": "super_reach_test",
	},

	# ══ FLYER T1–T2 SPECIES-SPECIFIC (REMAINING) ════════════════════════════

	"anuro_swarm_hunt": {
		"seasons": ["spring", "summer"], "trees": ["flyer"], "species": ["anurognathus"],
		"rarity": "common", "passive": false,
		"flavor": "An insect cloud has risen from the grass — the kind that only lasts a few minutes before it disperses. The colony is already climbing. You are small enough to feed inside the cloud itself.",
		"effects": {},
		"choices": [
			{ "label": "Fly into the cloud",   "icon": "hunt",   "sublabel": "Feed inside — maximum yield", "action": "feed_swarm_inside" },
			{ "label": "Skim the edge",        "icon": "stalk",  "sublabel": "Safer, lower exposure",       "action": "skim_swarm_edge" },
			{ "label": "Let the colony work",  "icon": "flee",   "sublabel": "Follow after the leaders",    "action": "follow_colony" },
		],
		"resolve_key": "anuro_swarm_hunt",
	},
	"jeholo_bark_hollow": {
		"seasons": ["fall", "winter"], "trees": ["flyer"], "species": ["jeholopterus"],
		"rarity": "uncommon", "passive": false,
		"flavor": "A hollow in the bark — deep enough to roost, high enough to be safe. The entrance is the right size. Something else may have found it first.",
		"effects": {},
		"choices": [
			{ "label": "Check and enter",  "icon": "stalk",  "sublabel": "Clear it and roost",         "action": "enter_hollow" },
			{ "label": "Enter fast",       "icon": "hunt",   "sublabel": "Displace whatever's inside", "action": "displace_roost" },
			{ "label": "Find another",     "icon": "flee",   "sublabel": "Not worth the risk",         "action": "leave" },
		],
		"resolve_key": "jeholo_bark_hollow",
	},
	"sordes_colony_warmth": {
		"seasons": ["fall", "winter"], "trees": ["flyer"], "species": ["sordes"],
		"rarity": "common", "passive": false,
		"flavor": "The temperature has dropped fast. The colony is pressing together on the roost wall. The mass of them generates warmth that none of them could manage alone. Position inside the group matters.",
		"effects": {},
		"choices": [
			{ "label": "Press to center",   "icon": "hunt",  "sublabel": "Warmest position",            "action": "press_center_colony" },
			{ "label": "Hold your spot",    "icon": "stalk", "sublabel": "Stable but exposed to edge",  "action": "hold_position_colony" },
			{ "label": "Roost separately",  "icon": "flee",  "sublabel": "Solitude but cold",           "action": "roost_separate" },
		],
		"resolve_key": "sordes_colony_warmth",
	},

	# ══ FLYER T4 SPECIES-SPECIFIC ════════════════════════════════════════════

	"cear_fish_lock": {
		"seasons": ["spring", "summer", "fall"], "trees": ["flyer"], "species": ["cearadactylus"],
		"rarity": "uncommon", "passive": false,
		"flavor": "Shallow water ahead and a school running close to the surface. The interlocking teeth exist for exactly this — enter at speed and the fish that tries to slip past the jaw learns why that doesn't work.",
		"effects": {},
		"choices": [
			{ "label": "Speed dive — bite lock", "icon": "attack", "sublabel": "Full commitment, max yield", "action": "speed_dive_bite" },
			{ "label": "Skim pass first",        "icon": "stalk",  "sublabel": "Read the density",          "action": "skim_assess" },
			{ "label": "Wait for calm water",    "icon": "flee",   "sublabel": "Cleaner angle later",       "action": "wait_calm_water" },
		],
		"resolve_key": "cear_fish_lock",
	},
	"tape_jungle_thermal": {
		"seasons": ["spring", "summer"], "trees": ["flyer"], "species": ["tapejara"],
		"rarity": "uncommon", "passive": false,
		"flavor": "A thermal column rising through a canopy gap — visible from the disturbed leaves. The sail crest reads it perfectly. The gap is barely wide enough and the column runs for two hundred lengths before it disperses.",
		"effects": {},
		"choices": [
			{ "label": "Enter the thermal",   "icon": "hunt",  "sublabel": "Ride it — fast altitude",    "action": "ride_jungle_thermal" },
			{ "label": "Thread the canopy",   "icon": "stalk", "sublabel": "Safer gap route",            "action": "thread_canopy_gap" },
			{ "label": "Climb above",         "icon": "flee",  "sublabel": "Avoid the canopy entirely",  "action": "climb_above_canopy" },
		],
		"resolve_key": "tape_jungle_thermal",
	},
	"anhan_colonial_shoal": {
		"seasons": ["spring", "summer"], "trees": ["flyer"], "species": ["anhanguera"],
		"rarity": "uncommon", "passive": false,
		"flavor": "The colony has located a shoal in the open water. The synchronized dive works by cutting off escape routes from multiple angles. Everyone who commits improves the odds for everyone else.",
		"effects": {},
		"choices": [
			{ "label": "Lead the dive",         "icon": "attack", "sublabel": "Set the timing — full yield",  "action": "lead_colonial_dive" },
			{ "label": "Join the second wave",  "icon": "stalk",  "sublabel": "Lower risk, lower yield",      "action": "join_second_wave" },
			{ "label": "Circle and pick off",   "icon": "hunt",   "sublabel": "Take stragglers after",        "action": "circle_pick_off" },
		],
		"resolve_key": "anhan_colonial_shoal",
	},
	"ornith_ocean_crossing": {
		"seasons": ["spring", "fall"], "trees": ["flyer"], "species": ["ornithocheirus"],
		"rarity": "rare", "passive": false,
		"flavor": "The offshore current has shifted — the island chain crossing you completed last season runs a different angle this year. The route still exists. The conditions are just different.",
		"effects": {},
		"choices": [
			{ "label": "Commit to the crossing", "icon": "hunt",  "sublabel": "New route — high reward",    "action": "commit_crossing" },
			{ "label": "Scout the angle first",  "icon": "stalk", "sublabel": "Read the wind before going", "action": "scout_crossing" },
			{ "label": "Work the coast instead", "icon": "flee",  "sublabel": "Stay in known range",        "action": "coast_work" },
		],
		"resolve_key": "ornith_ocean_crossing",
	},

	# ══ FLYER T5 SPECIES-SPECIFIC ════════════════════════════════════════════

	"trope_cliff_run": {
		"seasons": ["spring", "summer", "fall"], "trees": ["flyer"], "species": ["tropeognathus"],
		"rarity": "uncommon", "passive": false,
		"flavor": "The coastal cliff face is generating updrafts that run for a kilometer before dispersing. The keel crest is already working. Smaller flyers are getting pushed off course. You are not.",
		"effects": {},
		"choices": [
			{ "label": "Run the full cliff",  "icon": "hunt",  "sublabel": "Claim the whole stretch",     "action": "run_cliff_full" },
			{ "label": "Drive off competition","icon": "attack","sublabel": "Own the updraft corridor",   "action": "drive_off_flyers" },
			{ "label": "Dive to fish below",  "icon": "stalk", "sublabel": "Use the height advantage",   "action": "dive_from_cliff" },
		],
		"resolve_key": "trope_cliff_run",
	},
	"hatz_ground_hunt": {
		"seasons": ["any"], "trees": ["flyer"], "species": ["hatzegopteryx"],
		"rarity": "uncommon", "passive": false,
		"flavor": "A slow-moving terrestrial animal has moved into the open ground. The ground approach — slow walk, head low, beak strike — is more efficient than aerial pursuit at this target size.",
		"effects": {},
		"choices": [
			{ "label": "Ground stalk — strike",  "icon": "attack", "sublabel": "Terrestrial method",          "action": "ground_stalk_strike" },
			{ "label": "Aerial drop",            "icon": "hunt",   "sublabel": "Height advantage — faster",   "action": "aerial_drop" },
			{ "label": "Leave — too large",      "icon": "flee",   "sublabel": "Not worth the risk",          "action": "leave" },
		],
		"resolve_key": "hatz_ground_hunt",
	},
	"cryo_storm_flight": {
		"seasons": ["fall", "winter"], "trees": ["flyer"], "species": ["cryodrakon"],
		"rarity": "uncommon", "passive": false,
		"flavor": "A storm system has pushed every other flyer to ground. The winds inside it are violent and the thermals are unpredictable. You have flown worse. The northern range is completely clear of competition right now.",
		"effects": {},
		"choices": [
			{ "label": "Fly the storm",      "icon": "attack", "sublabel": "Range while nothing else can", "action": "fly_storm" },
			{ "label": "Ride the edge",      "icon": "hunt",   "sublabel": "Work the storm boundary",     "action": "ride_storm_edge" },
			{ "label": "Ground and wait",    "icon": "flee",   "sublabel": "Even you have limits",         "action": "ground_wait_storm" },
		],
		"resolve_key": "cryo_storm_flight",
	},

	# ══ FLYER T6–T7 SPECIES-SPECIFIC ═════════════════════════════════════════

	"quetz_sky_claim": {
		"seasons": ["spring", "summer", "fall"], "trees": ["flyer"], "species": ["quetzalcoatlus"],
		"rarity": "rare", "passive": false,
		"flavor": "A high thermal column — the kind that takes you above cloud level — has opened over the inland sea. From that altitude the route to the next landmass is visible. Smaller flyers are not even attempting it.",
		"effects": {},
		"choices": [
			{ "label": "Ascend — claim the air",  "icon": "hunt",   "sublabel": "Map the high route",         "action": "ascend_high_thermal" },
			{ "label": "Offshore crossing",       "icon": "attack", "sublabel": "New territory beyond",       "action": "offshore_crossing_high" },
			{ "label": "Circle and assess",       "icon": "stalk",  "sublabel": "Read the conditions first",  "action": "circle_assess_quetz" },
		],
		"resolve_key": "quetz_sky_claim",
	},
	"sky_tyrant_dominion": {
		"seasons": ["any"], "trees": ["flyer"], "species": ["quetzal_sky_tyrant"],
		"rarity": "rare", "passive": false,
		"flavor": "Another large flyer has entered your range from the south. Not small — large enough that under normal circumstances it would pose a question. Your wingspan answers the question before it is asked.",
		"effects": {},
		"choices": [
			{ "label": "Climb — display size",  "icon": "stalk",  "sublabel": "The wingspan settles it",     "action": "display_wingspan" },
			{ "label": "Drive it out directly", "icon": "attack", "sublabel": "No ambiguity",                "action": "drive_out_sky" },
			{ "label": "Allow — assess",        "icon": "flee",   "sublabel": "It may not be competition",   "action": "observe" },
		],
		"resolve_key": "sky_tyrant_dominion",
	},
	"bone_ground_apex": {
		"seasons": ["any"], "trees": ["flyer"], "species": ["hatzegopteryx_bonebreaker"],
		"rarity": "rare", "passive": false,
		"flavor": "Large prey — terrestrial, slow, nowhere near water. From the air you can see it has no cover and no escape direction. The island has no apex predator that challenges you in either mode. This is straightforward.",
		"effects": {},
		"choices": [
			{ "label": "Aerial drop — pin",    "icon": "attack", "sublabel": "Height into commitment",       "action": "aerial_drop_pin" },
			{ "label": "Ground approach",      "icon": "stalk",  "sublabel": "Walk in — size does the work", "action": "ground_walk_in" },
			{ "label": "Pass on it",           "icon": "flee",   "sublabel": "Smaller prey is easier",       "action": "leave" },
		],
		"resolve_key": "bone_ground_apex",
	},
	"frost_storm_range": {
		"seasons": ["fall", "winter"], "trees": ["flyer"], "species": ["cryodrakon_frostwing"],
		"rarity": "rare", "passive": false,
		"flavor": "The northern crossing — the one that has killed every flyer that attempted it in the last three seasons — is running open today. The cold is absolute and the wind is exactly right. You have survived worse conditions than most things alive.",
		"effects": {},
		"choices": [
			{ "label": "Fly the crossing",     "icon": "attack", "sublabel": "The route is open — take it",  "action": "fly_northern_crossing" },
			{ "label": "Map from the edge",    "icon": "stalk",  "sublabel": "Assess — cross next window",   "action": "map_from_edge" },
			{ "label": "Hold and recover",     "icon": "flee",   "sublabel": "Not every window is worth it", "action": "rest" },
		],
		"resolve_key": "frost_storm_range",
	},
	"aram_long_route": {
		"seasons": ["spring", "fall"], "trees": ["flyer"], "species": ["arambourgiania"],
		"rarity": "rare", "passive": false,
		"flavor": "The flyway between two landmasses — the long one, the one nothing else attempts — is visible from altitude. The thermals are stacking in the right sequence. You have made this crossing. You know exactly what it requires.",
		"effects": {},
		"choices": [
			{ "label": "Commit the crossing",   "icon": "hunt",  "sublabel": "Full route — new territory",  "action": "commit_long_crossing" },
			{ "label": "Work the near island",  "icon": "stalk", "sublabel": "Closer range, less risk",     "action": "work_near_island" },
			{ "label": "Hold — wrong wind",     "icon": "flee",  "sublabel": "The sequence isn't complete", "action": "leave" },
		],
		"resolve_key": "aram_long_route",
	},

	# ══ LEGENDARY ═══════════════════════════════════════════════════════════════

	"white_ghost": {
		"seasons": ["any"], "trees": ["predator", "flyer"], "rarity": "legendary", "passive": false,
		"flavor": "An unusually pale animal moves calmly through the herd. The others give it room. It seems to know this place better than any of them.",
		"effects": {},
		"choices": [
			{ "label": "Hunt it",             "icon": "attack", "sublabel": "Worth more than any ordinary kill",           "action": "hunt_legendary_prey" },
			{ "label": "Follow at distance",  "icon": "stalk",  "sublabel": "See where something like this goes",          "action": "observe_legendary" },
			{ "label": "Leave it alone",      "icon": "flee",   "sublabel": "Some things carry weight you can't afford",   "action": "leave" },
		],
		"resolve_key": "white_ghost",
	},
	"ancient_watcher": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "legendary", "passive": false,
		"flavor": "An old predator rests on the ridge. It stays so still that birds land nearby without alarm. Age has not made it careless.",
		"effects": {},
		"choices": [
			{ "label": "Stand your ground", "icon": "attack", "sublabel": "Don't let it read weakness in your movement",   "action": "face_legendary" },
			{ "label": "Back away slowly",  "icon": "stalk",  "sublabel": "Don't trigger what patience is building toward","action": "retreat_legendary" },
			{ "label": "Run hard now",      "icon": "flee",   "sublabel": "Take the moment before it decides",             "action": "flee_legendary" },
		],
		"resolve_key": "ancient_watcher",
	},
	"bone_ground": {
		"seasons": ["winter"], "trees": ["predator", "flyer"], "rarity": "legendary", "passive": false,
		"flavor": "Bones fill a valley, preserved by years of cold. The oldest kills hint at a hunter that has lived here longer than you can imagine.",
		"effects": {},
		"choices": [
			{ "label": "Feed on what remains", "icon": "hunt",   "sublabel": "Something ancient is still meat",    "action": "bone_ground_feed" },
			{ "label": "Claim this ground",    "icon": "attack", "sublabel": "Whatever held this is gone now",     "action": "bone_ground_claim" },
			{ "label": "Leave it",             "icon": "flee",   "sublabel": "Some places belong to the past",     "action": "leave" },
		],
		"resolve_key": "bone_ground",
	},
	"the_great_herd": {
		"seasons": ["spring", "fall"], "trees": ["herbivore"], "rarity": "legendary", "passive": false,
		"flavor": "You hear the migration before you see it. Thousands of animals move in the same direction, while predators gather along the edges.",
		"effects": {},
		"choices": [
			{ "label": "Move with the herd",  "icon": "flee",   "sublabel": "Numbers are the only real safety",                "action": "join_great_herd" },
			{ "label": "Feed at the edges",   "icon": "stalk",  "sublabel": "The confusion throws off predators too",          "action": "edge_great_herd" },
			{ "label": "Hold your ground",    "icon": "attack", "sublabel": "This is your range — don't be moved from it",    "action": "hold_great_herd" },
		],
		"resolve_key": "the_great_herd",
	},

	# ══ TURNING POINT — only fire when health < 0.25 or hunger < 0.20 ════════

	"last_water": {
		"seasons": ["summer", "fall", "winter"], "trees": ["all"], "rarity": "common",
		"passive": false, "require_desperate": true,
		"flavor": "It has been three days since you last drank. Only one place nearby still holds water, and reaching it will not be easy.",
		"effects": {},
		"choices": [
			{ "label": "Push to the water",   "icon": "hunt",  "sublabel": "It's the only move left",              "action": "desperate_water" },
			{ "label": "Rest before moving",  "icon": "flee",  "sublabel": "Running dry costs more than resting",   "action": "desperate_rest" },
		],
		"resolve_key": "last_water",
	},
	"the_wrong_season": {
		"seasons": ["winter"], "trees": ["predator", "flyer"], "rarity": "common",
		"passive": false, "require_desperate": true,
		"flavor": "Your familiar range has nothing left to offer. After seasons spent following its trails, you face the one choice you have been avoiding: leave.",
		"effects": {},
		"choices": [
			{ "label": "Take the desperate option", "icon": "attack", "sublabel": "Something small. Something wrong.",  "action": "desperate_hunt" },
			{ "label": "Conserve and wait",         "icon": "flee",   "sublabel": "Every movement costs you now",       "action": "desperate_rest" },
		],
		"resolve_key": "the_wrong_season",
	},
	"final_stand": {
		"seasons": ["any"], "trees": ["herbivore"], "rarity": "common",
		"passive": false, "require_desperate": true,
		"flavor": "You are weak, and a predator has been watching long enough to notice. It may attack soon. Moving first could give you a chance.",
		"effects": {},
		"choices": [
			{ "label": "Turn and face it",  "icon": "attack", "sublabel": "On your terms while you still can",     "action": "desperate_stand" },
			{ "label": "Find the herd",     "icon": "flee",   "sublabel": "You need numbers behind you right now", "action": "desperate_herd" },
			{ "label": "Hide and endure",   "icon": "stalk",  "sublabel": "Stay still until it loses interest",    "action": "desperate_hide" },
		],
		"resolve_key": "final_stand",
	},
	"last_reserves": {
		"seasons": ["any"], "trees": ["predator", "flyer"], "rarity": "common",
		"passive": false, "require_desperate": true,
		"flavor": "Hunger leaves you little strength for a hunt. You must weigh what a chase could give you against the energy it would take.",
		"effects": {},
		"choices": [
			{ "label": "Commit everything",   "icon": "attack", "sublabel": "All in on one attempt",                          "action": "desperate_hunt" },
			{ "label": "Find something easy", "icon": "stalk",  "sublabel": "Small and certain is better than nothing",       "action": "desperate_water" },
			{ "label": "Rest and recover",    "icon": "flee",   "sublabel": "Spend what you have on surviving the night",     "action": "desperate_rest" },
		],
		"resolve_key": "last_reserves",
	},

	# ══ RIVAL — only fire when rival_name is set ════════════════════════════════

	"rival_returns": {
		"seasons": ["any"], "trees": ["all"], "rarity": "uncommon",
		"passive": false, "require_rival": true,
		"flavor": "{rival} has returned to your range. You recognize the familiar movements through the brush. It seems to have chosen this moment carefully.",
		"effects": {},
		"choices": [
			{ "label": "Confront it",     "icon": "attack", "sublabel": "End this before it decides the terms",   "action": "rival_confront" },
			{ "label": "Watch first",     "icon": "stalk",  "sublabel": "See what it wants before committing",    "action": "rival_observe" },
			{ "label": "Avoid the area",  "icon": "flee",   "sublabel": "Don't give it what it came for",         "action": "rival_avoid" },
		],
		"resolve_key": "rival_encounter",
	},
	"rival_territory": {
		"seasons": ["spring", "summer", "fall"], "trees": ["all"], "rarity": "uncommon",
		"passive": false, "require_rival": true,
		"flavor": "Fresh scent marks cross your range. {rival} left them while you were away, making a deliberate claim on your ground.",
		"effects": {},
		"choices": [
			{ "label": "Re-mark aggressively", "icon": "attack", "sublabel": "Make clear this is still yours",    "action": "rival_confront" },
			{ "label": "Watch the boundary",   "icon": "stalk",  "sublabel": "Wait for it to show itself",        "action": "rival_observe" },
			{ "label": "Yield the edge",       "icon": "flee",   "sublabel": "Not worth a direct confrontation",  "action": "rival_avoid" },
		],
		"resolve_key": "rival_encounter",
	},
	"rival_showdown": {
		"seasons": ["any"], "trees": ["all"], "rarity": "rare",
		"passive": false, "require_rival": true, "require_rival_encounters": 2,
		"flavor": "{rival} waits directly in your path. After seasons of circling and marking, the confrontation has finally come.",
		"effects": {},
		"choices": [
			{ "label": "Face it",   "icon": "attack", "sublabel": "This ends today",              "action": "rival_final" },
			{ "label": "Back down", "icon": "flee",   "sublabel": "Live to face it another season", "action": "rival_avoid" },
		],
		"resolve_key": "rival_encounter",
	},
}

const _COMPI_EVENTS = preload("res://scripts/data/species_events/compsognathus_events.gd")
const _DEIN_EVENTS  = preload("res://scripts/data/species_events/deinonychus_events.gd")
const _VELO_EVENTS  = preload("res://scripts/data/species_events/velociraptor_events.gd")
const _ALLO_EVENTS  = preload("res://scripts/data/species_events/allosaurus_events.gd")
const _TREX_EVENTS  = preload("res://scripts/data/species_events/trex_events.gd")
const _LESO_EVENTS  = preload("res://scripts/data/species_events/lesothosaurus_events.gd")
const _IGUA_EVENTS  = preload("res://scripts/data/species_events/iguanodon_events.gd")
const _TRIKE_EVENTS = preload("res://scripts/data/species_events/triceratops_events.gd")
const _ANKY_EVENTS  = preload("res://scripts/data/species_events/ankylosaurus_events.gd")
const _ARGE_EVENTS  = preload("res://scripts/data/species_events/argentinosaurus_events.gd")

var EVENTS: Dictionary = {}


func _ready() -> void:
	EVENTS.merge(_WORLD_EVENTS)
	EVENTS.merge(_COMPI_EVENTS.EVENTS)
	EVENTS.merge(_DEIN_EVENTS.EVENTS)
	EVENTS.merge(_VELO_EVENTS.EVENTS)
	EVENTS.merge(_ALLO_EVENTS.EVENTS)
	EVENTS.merge(_TREX_EVENTS.EVENTS)
	EVENTS.merge(_LESO_EVENTS.EVENTS)
	EVENTS.merge(_IGUA_EVENTS.EVENTS)
	EVENTS.merge(_TRIKE_EVENTS.EVENTS)
	EVENTS.merge(_ANKY_EVENTS.EVENTS)
	EVENTS.merge(_ARGE_EVENTS.EVENTS)


func get_events_for_context(season: String, tree: String, species_id: String = "", life_stage: int = -1) -> Array:
	var result = []
	for id in EVENTS:
		var ev = EVENTS[id]
		var season_match = "any" in ev["seasons"] or season in ev["seasons"]
		var tree_match = "all" in ev["trees"] or tree in ev["trees"]
		var species_match := true
		if ev.has("species") and not ev["species"].is_empty():
			species_match = species_id in ev["species"]
		var stage_match := true
		if life_stage >= 0:
			if ev.has("min_stage") and life_stage < ev["min_stage"]:
				stage_match = false
			if ev.has("max_stage") and life_stage > ev["max_stage"]:
				stage_match = false
		if ev.get("require_injured", false) and GameState.injuries.is_empty():
			stage_match = false
		if ev.get("require_pack", false) and GameState.pack_bond == 0.0:
			stage_match = false
		if ev.get("require_desperate", false) and not GameState.is_desperate():
			stage_match = false
		if ev.get("require_rival", false) and GameState.rival_name.is_empty():
			stage_match = false
		if ev.get("require_rival_encounters", 0) > 0 and GameState.rival_encounters < ev.get("require_rival_encounters", 0):
			stage_match = false
		if season_match and tree_match and species_match and stage_match:
			result.append(ev.duplicate())
			result[-1]["id"] = id
	return result


func get_event(id: String) -> Dictionary:
	if EVENTS.has(id):
		var ev = EVENTS[id].duplicate()
		ev["id"] = id
		return ev
	return {}


func get_rarity_weight(rarity: String) -> float:
	match rarity:
		"common":    return 1.0
		"uncommon":  return 0.45
		"rare":      return 0.15
		"legendary": return 0.04
	return 0.0
