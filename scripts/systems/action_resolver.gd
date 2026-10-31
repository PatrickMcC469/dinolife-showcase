extends Node

const LIFE_STORY = preload("res://scripts/systems/life_story.gd")
const COMPANIONS = preload("res://scripts/systems/companions.gd")
const WORLD = preload("res://scripts/systems/world_conditions.gd")

# Routes action choices to outcomes, applies stat changes, returns result events.
# game_screen holds a context string so multi-step chains work across overlay calls.

signal result_ready(event_data: Dictionary)

# Prey tables per predator size tier — hunger_value is how much hunger is restored
const PREY_TIERS = {
	1: [  # tiny predator (compsognathus, sinosauropteryx hatchling)
		{ "name": "a skittering lizard",           "fight_power": 0.05, "hunger_value": 0.15, "size": 1 },
		{ "name": "a fat beetle cluster",          "fight_power": 0.02, "hunger_value": 0.10, "size": 1 },
		{ "name": "a small nesting creature",      "fight_power": 0.08, "hunger_value": 0.20, "size": 1 },
		{ "name": "a clutch of unguarded eggs",    "fight_power": 0.00, "hunger_value": 0.18, "size": 1 },
		{ "name": "a slow ground insect",          "fight_power": 0.01, "hunger_value": 0.08, "size": 1 },
		{ "name": "a small mammal in the undergrowth", "fight_power": 0.10, "hunger_value": 0.22, "size": 1 },
	],
	2: [  # small predator (juvenile deinonychus, adult compsognathus)
		{ "name": "a young ornithopod",            "fight_power": 0.18, "hunger_value": 0.35, "size": 2 },
		{ "name": "a wounded scavenger",           "fight_power": 0.12, "hunger_value": 0.30, "size": 2 },
		{ "name": "a nesting herbivore",           "fight_power": 0.20, "hunger_value": 0.38, "size": 2 },
		{ "name": "a juvenile pterosaur on the ground", "fight_power": 0.14, "hunger_value": 0.28, "size": 2 },
		{ "name": "a small ankylosaur calf",       "fight_power": 0.22, "hunger_value": 0.40, "size": 2 },
		{ "name": "a half-grown lizard",           "fight_power": 0.10, "hunger_value": 0.25, "size": 2 },
	],
	3: [  # medium predator (deinonychus adult, dilophosaurus juvenile)
		{ "name": "a juvenile hadrosaur",          "fight_power": 0.30, "hunger_value": 0.55, "size": 3 },
		{ "name": "a lone ceratopsian",            "fight_power": 0.35, "hunger_value": 0.50, "size": 3 },
		{ "name": "an injured large herbivore",    "fight_power": 0.25, "hunger_value": 0.60, "size": 3 },
		{ "name": "a young iguanodont separated from its herd", "fight_power": 0.28, "hunger_value": 0.52, "size": 3 },
		{ "name": "a stegosaur wading in the shallows", "fight_power": 0.38, "hunger_value": 0.58, "size": 4 },
	],
	4: [  # large predator (adult dilophosaurus, juvenile carnotaurus)
		{ "name": "an adult hadrosaur",            "fight_power": 0.50, "hunger_value": 0.75, "size": 5 },
		{ "name": "a Triceratops calf",            "fight_power": 0.45, "hunger_value": 0.70, "size": 4 },
		{ "name": "a weakened sauropod",           "fight_power": 0.40, "hunger_value": 0.80, "size": 5 },
		{ "name": "a sub-adult sauropod",          "fight_power": 0.48, "hunger_value": 0.78, "size": 5 },
		{ "name": "a large ankylosaur — dangerous but substantial", "fight_power": 0.55, "hunger_value": 0.82, "size": 5 },
	],
	5: [  # apex predator (adult carnotaurus, allosaurus)
		{ "name": "an adult Stegosaurus",             "fight_power": 0.62, "hunger_value": 0.90, "size": 6 },
		{ "name": "a full-grown iguanodont herd straggler", "fight_power": 0.55, "hunger_value": 0.85, "size": 6 },
		{ "name": "an injured adult sauropod",        "fight_power": 0.50, "hunger_value": 0.95, "size": 7 },
		{ "name": "a large ceratopsian defending its ground", "fight_power": 0.70, "hunger_value": 0.88, "size": 6 },
		{ "name": "an old bull hadrosaur separated from the herd", "fight_power": 0.58, "hunger_value": 0.92, "size": 6 },
		{ "name": "a sub-adult sauropod, still too young to be safe", "fight_power": 0.52, "hunger_value": 1.00, "size": 7 },
	],
}

# Separate prey pool for flyers — fish, insects, small ground creatures
const FLYER_PREY_TIERS = {
	1: [  # tiny flyers (anurognathus, nemicolopterus, sordes, yi_qi)
		{ "name": "a cloud of flying insects",     "fight_power": 0.01, "hunger_value": 0.12, "size": 1 },
		{ "name": "a mosquito swarm over the water","fight_power": 0.00, "hunger_value": 0.10, "size": 1 },
		{ "name": "a large moth",                  "fight_power": 0.02, "hunger_value": 0.08, "size": 1 },
		{ "name": "a damselfly cluster",           "fight_power": 0.01, "hunger_value": 0.10, "size": 1 },
	],
	2: [  # small flyers (microraptor, archaeopteryx, jeholopterus)
		{ "name": "a juvenile fish near the surface","fight_power": 0.10, "hunger_value": 0.25, "size": 1 },
		{ "name": "a small lizard on an exposed rock","fight_power": 0.12, "hunger_value": 0.22, "size": 1 },
		{ "name": "a treefrog at the water's edge","fight_power": 0.06, "hunger_value": 0.18, "size": 1 },
		{ "name": "a large beetle on a tree trunk","fight_power": 0.03, "hunger_value": 0.14, "size": 1 },
		{ "name": "a slow ground lizard",          "fight_power": 0.08, "hunger_value": 0.20, "size": 1 },
	],
	3: [  # medium flyers (pterodactylus, pteranodon, dsungaripterus)
		{ "name": "a large river fish",              "fight_power": 0.18, "hunger_value": 0.40, "size": 2 },
		{ "name": "a slow-water turtle",             "fight_power": 0.20, "hunger_value": 0.45, "size": 2 },
		{ "name": "a fat ground lizard",             "fight_power": 0.15, "hunger_value": 0.35, "size": 2 },
		{ "name": "a dense shoal in the shallows",   "fight_power": 0.05, "hunger_value": 0.50, "size": 1 },
		{ "name": "a crab cluster on the tidal flat","fight_power": 0.08, "hunger_value": 0.38, "size": 1 },
		{ "name": "a surface-feeding fish school",   "fight_power": 0.06, "hunger_value": 0.42, "size": 1 },
		{ "name": "a large amphibian in the shallows","fight_power": 0.22, "hunger_value": 0.48, "size": 2 },
	],
}

const SCAVENGE_FINDS = [
	{ "desc": "the remains of a recent kill",  "hunger_value": 0.25 },
	{ "desc": "a scattered carcass",           "hunger_value": 0.18 },
	{ "desc": "bones with enough marrow left", "hunger_value": 0.12 },
]

const FORAGE_FINDS = [
	{ "desc": "a patch of dense vegetation",  "flavor": "You found a patch of dense vegetation. Not much, but enough.",     "hunger_value": 0.22 },
	{ "desc": "some scattered seed pods",     "flavor": "Scattered seed pods — dry but calorie-rich.",                       "hunger_value": 0.15 },
	{ "desc": "a cluster of fallen fruit",    "flavor": "Fallen fruit near a tree line. Soft and easy to eat.",              "hunger_value": 0.20 },
]

var _pending_prey: Dictionary = {}
var _pending_threat: Dictionary = {}
var _pending_combat_context: Dictionary = {}
var _pending_combat_is_hunt: bool = true   # false during graze defense — suppresses kills/strength gain

# ── OUTCOME EVENTS ────────────────────────────────────────────────────────────
# Generic 5-outcome event system. Any resolve_key listed here uses the
# weighted roller instead of a hand-coded function. Luck shifts good outcomes
# up and the debuff outcome down each turn.
#
# Default weights — override per-event with w_buff / w_food / w_health /
# w_nothing / w_debuff keys. All values are floats 0.0–1.0; they are
# normalised at runtime so they don't need to sum to 1.0.
#
# Buff:   { stat, amount, turns, source, [perm: true for permanent] }
# Food:   { hunger }       — how much hunger is restored
# Health: { health }       — how much health is restored
# Debuff: { health }       — direct damage (negative float)
#         { stat, amount, turns, source } — temporary stat debuff


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

var OUTCOME_EVENTS: Dictionary = {}


func _ready() -> void:
	OUTCOME_EVENTS.merge(_COMPI_EVENTS.OUTCOME_EVENTS)
	OUTCOME_EVENTS.merge(_DEIN_EVENTS.OUTCOME_EVENTS)
	OUTCOME_EVENTS.merge(_VELO_EVENTS.OUTCOME_EVENTS)
	OUTCOME_EVENTS.merge(_ALLO_EVENTS.OUTCOME_EVENTS)
	OUTCOME_EVENTS.merge(_TREX_EVENTS.OUTCOME_EVENTS)
	OUTCOME_EVENTS.merge(_LESO_EVENTS.OUTCOME_EVENTS)
	OUTCOME_EVENTS.merge(_IGUA_EVENTS.OUTCOME_EVENTS)
	OUTCOME_EVENTS.merge(_TRIKE_EVENTS.OUTCOME_EVENTS)
	OUTCOME_EVENTS.merge(_ANKY_EVENTS.OUTCOME_EVENTS)
	OUTCOME_EVENTS.merge(_ARGE_EVENTS.OUTCOME_EVENTS)




func _resolve_outcome_event(key: String, choice: String) -> Dictionary:
	if choice == "pass":
		return _result(OUTCOME_EVENTS[key].get("pass_flavor", "You move on without engaging."))
	var od: Dictionary = OUTCOME_EVENTS[key]
	var lm: float = GameState.luck_mod()
	# Luck boosts good outcomes and suppresses debuff
	var w_buff    := maxf(0.02, od.get("w_buff",    0.12) + lm * 0.50)
	var w_food    := maxf(0.02, od.get("w_food",    0.28) + lm * 0.30)
	var w_health  := maxf(0.02, od.get("w_health",  0.18) + lm * 0.20)
	var w_nothing := maxf(0.02, od.get("w_nothing", 0.30))
	var w_debuff  := maxf(0.02, od.get("w_debuff",  0.12) - lm * 1.00)
	var total := w_buff + w_food + w_health + w_nothing + w_debuff
	var roll  := randf() * total
	var outcome_key := "debuff"
	if roll < w_buff:
		outcome_key = "buff"
	elif roll < w_buff + w_food:
		outcome_key = "food"
	elif roll < w_buff + w_food + w_health:
		outcome_key = "health"
	elif roll < w_buff + w_food + w_health + w_nothing:
		outcome_key = "nothing"
	return _apply_world_outcome(od, outcome_key)


func _apply_world_outcome(od: Dictionary, outcome_key: String) -> Dictionary:
	var data: Dictionary = od.get(outcome_key, {})
	var flavor: String   = data.get("flavor", "Something happened.")
	match outcome_key:
		"buff":
			if data.get("perm", false):
				var perm_key := "permanent_%s_mod" % data["stat"]
				if GameState.get(perm_key) != null:
					GameState.set(perm_key, GameState.get(perm_key) + data["amount"])
				GameState.set(data["stat"], minf(1.0, GameState.get(data["stat"]) + data["amount"]))
				GameState.bonuses_earned.append(data.get("perm_label", "Survivor"))
			else:
				GameState.apply_temp_buff(data["stat"], data["amount"],
					data.get("turns", 2), data.get("source", "world_buff"))
		"food":
			GameState.hunger = minf(1.0, GameState.hunger + data.get("hunger", 0.20))
		"health":
			GameState.health = minf(1.0, GameState.health + data.get("health", 0.08))
		"debuff":
			if data.has("health"):
				GameState.health = maxf(0.0, GameState.health + data["health"])
			elif data.has("hunger"):
				GameState.hunger = maxf(0.0, GameState.hunger + data["hunger"])
			elif data.has("stat"):
				GameState.apply_temp_buff(data["stat"], data["amount"],
					data.get("turns", 2), data.get("source", "world_debuff"))
	return { "type": "result", "next_context": "", "flavor": flavor, "choices": [] }


func resolve(context: String, choice: String) -> Dictionary:
	var feedback_before := preload("res://scripts/systems/action_feedback.gd").snapshot()
	var before := LIFE_STORY.action_snapshot()
	var result := _resolve(context, choice)
	COMPANIONS.ensure_cast()
	LIFE_STORY.note_action(before, result)
	var new_perks: Array[String] = []
	if not choice.is_empty() and choice != "back" and result.get("choices", []).is_empty():
		new_perks = preload("res://scripts/systems/perks.gd").award()
	preload("res://scripts/systems/action_feedback.gd").attach(result, feedback_before)
	if not new_perks.is_empty():
		if not result.has("feedback"):
			result["feedback"] = preload("res://scripts/systems/action_feedback.gd").milestone("Perk earned: " + ", ".join(new_perks))
		else:
			result["feedback"]["milestones"].append("Perk earned: " + ", ".join(new_perks))
		GameState.save_run()
	return result


func _resolve(context: String, choice: String) -> Dictionary:
	if context == "family":
		return preload("res://scripts/systems/family_legacy.gd").resolve(choice)
	if context == "pack_story":
		return preload("res://scripts/systems/pack_story_events.gd").resolve(choice)
	if context == "home":
		return preload("res://scripts/systems/living_world.gd").resolve_home(choice)
	if context == "pack_relations":
		return preload("res://scripts/systems/pack_relationships.gd").resolve(choice)
	if context == "living":
		return preload("res://scripts/systems/living_world.gd").resolve(choice)
	if context == "leadership":
		return preload("res://scripts/systems/pack_leadership.gd").resolve(choice)
	if context == "discovery":
		return preload("res://scripts/systems/discoveries.gd").resolve(choice)
	if context == "journey":
		return preload("res://scripts/systems/journeys.gd").resolve(choice)
	if context == "companions":
		return COMPANIONS.resolve(choice)
	if context in OUTCOME_EVENTS:
		return _resolve_outcome_event(context, choice)
	match context:
		# Action chains
		"hunt":               return _resolve_hunt_roll()
		"hunt_crit":          return _no_event()
		"prey_found":         return _resolve_prey_encounter(choice)
		"prey_alerted":       return _resolve_prey_alerted(choice)
		"combat_preview":     return _resolve_combat_choice(choice)
		"threat":             return _resolve_threat(choice)
		"scavenge":           return _resolve_scavenge(choice)
		"rest":               return _resolve_rest()
		"territory":          return _resolve_territory()
		"sharpen":            return _resolve_sharpen_prompt()
		"sharpen_choice":     return _resolve_sharpen_result(choice)
		"water":              return _resolve_water()
		"bond":               return _resolve_bond()
		"tend":               return _resolve_tend()
		"nest_tend":          return _resolve_nest_tend()
		"graze":              return _resolve_graze_roll()
		"graze_crit":         return _resolve_graze_crit_dismiss()
		"graze_encounter":    return _resolve_graze_encounter(choice)
		"graze_danger":       return _resolve_graze_danger_choice(choice)
		# World events
		"hatchling_season":   return _resolve_hatchling(choice)
		"flooded_rivers":     return _resolve_flooded_rivers(choice)
		"new_pack_forming":   return _resolve_new_pack(choice)
		"herd_migration_begins","great_migration": return _resolve_migration(choice)
		"blooming_medicine":  return _resolve_medicine_plant(choice, false)
		"poison_bloom":       return _resolve_medicine_plant(choice, true)
		"drought":            return _resolve_drought(choice)
		"fruit_season":       return _resolve_fruit(choice)
		"waterhole_truce":    return _resolve_waterhole_truce(choice)
		"wildfire":           return _resolve_wildfire(choice)
		"insect_swarms":      return _resolve_insects(choice)
		"salt_lick","mineral_lick": return _resolve_mineral(choice)
		"mushroom_bloom":     return _resolve_mushrooms(choice)
		"rutting_season","red_moon_rut": return _resolve_rut(choice)
		"fattening_season":   return _resolve_fattening(choice)
		"sick_herd","plague_season": return _resolve_sick_herd(choice)
		"blizzard","superstorm": return _resolve_storm_event(choice)
		"frozen_river":       return _resolve_frozen_river(choice)
		"frozen_carcass":     return _resolve_frozen_carcass(choice)
		"winter_shelter":     return _resolve_winter_shelter(choice)
		"pack_fracture":      return _resolve_pack_fracture(choice)
		"pack_hunger":        return _resolve_pack_hunger(choice)
		"scavenger_war":      return _resolve_scavenger_war(choice)
		"herd_huddle":        return _resolve_herd_huddle(choice)
		"wounded_wanderer":   return _resolve_wounded_wanderer(choice)
		"fresh_tracks":       return _resolve_fresh_tracks(choice)
		"pack_invitation":    return _resolve_pack_invitation(choice)
		"rival_claim":        return _resolve_rival_claim(choice)
		"night_hunt":         return _resolve_night_hunt(choice)
		"herd_defense":       return _resolve_herd_defense(choice)
		"alpha_challenge":    return _resolve_alpha_challenge(choice)
		"defensive_stand":    return _resolve_defensive_stand(choice)
		"fresh_meadow":       return _resolve_fresh_meadow(choice)
		"herd_panic":         return _resolve_herd_panic(choice)
		"nest_defense","egg_snatcher": return _resolve_nest_defense(choice)
		"old_bull_challenge": return _resolve_rank_fight(choice)
		"fish_surface":       return _resolve_fish(choice)
		"sky_shadow":         return _resolve_sky_shadow(choice)
		"sudden_crosswind":   return _resolve_crosswind(choice)
		"storm_perch":        return _resolve_storm_perch(choice)
		"nest_site_rush":     return _resolve_nest_rush(choice)
		"predator_gathering": return _resolve_pred_gathering(choice)
		"predator_silence":   return _resolve_pred_silence(choice)
		# Pack actions
		"find_pack", "find_herd", "find_colony": return _resolve_find_pack()
		"find_pack_join":      return _resolve_find_pack_join(choice)
		"find_pack_challenge": return _resolve_find_pack_challenge(choice)
		"alpha_challenge_mandatory":              return _resolve_alpha_challenge_mandatory(choice)
		"alpha_challenge_coalition":              return _resolve_alpha_challenge_coalition(choice)
		"alpha_display":                          return _resolve_alpha_display(choice)
		"rival_challenge":                        return _resolve_rival_challenge(choice)
		"female_nesting_prep":                    return _resolve_female_nesting_prep(choice)
		"hatchling_event":                        return _resolve_hatchling_event(choice)
		"juvenile_parent_event":                  return _resolve_juvenile_parent_event(choice)
		"mother_bond_event":                      return _resolve_mother_bond_event(choice)
		# Deinonychus mating
		"dein_sub_mating":        return _resolve_dein_sub_mating(choice)
		"dein_rival_challenge":   return _resolve_dein_rival_challenge(choice)
		"dein_alpha_breeding":    return _resolve_dein_alpha_breeding(choice)
		"dein_female_breeding":   return _resolve_dein_female_breeding(choice)
		# Allosaurus mating (legacy species-specific routes — kept for save compatibility)
		"allo_male_mating":       return _resolve_allo_male_mating(choice)
		"allo_female_mating":     return _resolve_allo_female_mating(choice)
		# Generic Pattern A mating (allosaurus, trex, ankylosaurus)
		"pattern_a_male_mating":   return _resolve_pattern_a_male_mating(choice)
		"pattern_a_female_mating": return _resolve_pattern_a_female_mating(choice)
		# Generic Pattern B mating (lesothosaurus, iguanodon, triceratops, argentinosaurus)
		"pattern_b_tournament":    return _resolve_pattern_b_tournament(choice)
		"pattern_b_effort":        return _resolve_pattern_b_effort(choice)
		"pattern_b_female_mating": return _resolve_pattern_b_female_mating(choice)
		# Mating chains
		"find_mate":                     return _resolve_find_mate()
		"mate_pack_alpha_male_alpha":     return _resolve_mate_pack_alpha_male_alpha(choice)
		"mate_pack_alpha_male_sub":       return _resolve_mate_pack_alpha_male_sub(choice)
		"mate_pack_alpha_female":         return _resolve_mate_pack_alpha_female(choice)
		"mate_pack_coalition_alpha":      return _resolve_mate_pack_coalition_alpha(choice)
		"mate_pack_coalition_sub":        return _resolve_mate_pack_coalition_sub(choice)
		"mate_pack_coalition_female":     return _resolve_mate_pack_coalition_female(choice)
		"mate_tournament_combat_male":    return _resolve_mate_tournament_combat_male(choice)
		"mate_tournament_combat_female":  return _resolve_mate_tournament_combat_female(choice)
		"mate_tournament_speed_male":     return _resolve_mate_tournament_speed_male(choice)
		"mate_tournament_speed_female":   return _resolve_mate_tournament_speed_female(choice)
		"mate_aerial_male":               return _resolve_mate_aerial_male(choice)
		"mate_aerial_female":             return _resolve_mate_aerial_female(choice)
		"mate_nocturnal_male":            return _resolve_mate_nocturnal_male(choice)
		"mate_nocturnal_female":          return _resolve_mate_nocturnal_female(choice)
		"mate_stalk_male":                return _resolve_mate_stalk_male(choice)
		"mate_stalk_female":              return _resolve_mate_stalk_female(choice)
		"mate_court_male":                return _resolve_mate_court_male(choice)
		"mate_court_female":              return _resolve_mate_court_female(choice)
		"alpha_suspicion_confrontation":  return _resolve_alpha_suspicion(choice)
		# Species-specific events
		"comp_pack_flanking":   return _resolve_comp_pack_flanking(choice)
		"deinon_killing_strike":return _resolve_deinon_killing_strike(choice)
		"micro_canopy_launch":  return _resolve_micro_canopy_launch(choice)
		"troodon_night_sense":  return _resolve_troodon_night_sense(choice)
		"dilo_ambush_cover":    return _resolve_dilo_ambush_cover(choice)
		"bambi_terrain_gap":    return _resolve_bambi_terrain_gap(choice)
		"ornith_lizard_burst":  return _resolve_ornith_lizard_burst(choice)
		"hypsi_alarm_sprint":   return _resolve_hypsi_alarm_sprint(choice)
		"fruitaden_dense_cover":return _resolve_fruitaden_dense_cover(choice)
		"yi_qi_night_glide":    return _resolve_yi_qi_night_glide(choice)
		"archae_mode_switch":   return _resolve_archae_mode_switch(choice)
		"nemi_canopy_thread":   return _resolve_nemi_canopy_thread(choice)
		# Discovery / ambiguous encounters
		"tar_seep":             return _resolve_tar_seep(choice)
		"cave_hollow":          return _resolve_cave_hollow(choice)
		"glowing_pool":         return _resolve_glowing_pool(choice)
		"fallen_nest":          return _resolve_fallen_nest(choice)
		"bone_cache":           return _resolve_bone_cache(choice)
		"sleeping_creature":    return _resolve_sleeping_creature(choice)
		"strange_growth":       return _resolve_strange_growth(choice)
		# Winter expanded
		"migrant_stragglers":   return _resolve_migrant_stragglers(choice)
		"storm_driven_prey":    return _resolve_storm_driven_prey(choice)
		"frozen_kill_theft":    return _resolve_frozen_kill_theft(choice)
		"ice_shelf_collapse":   return _resolve_ice_shelf_collapse(choice)
		"starvation_rival":     return _resolve_starvation_rival(choice)
		"frost_hollow":         return _resolve_frost_hollow(choice)
		"winter_burrow":        return _resolve_winter_burrow(choice)
		"ice_fish_run":         return _resolve_ice_fish_run(choice)
		"desperate_feeding":    return _resolve_desperate_feeding(choice)
		"whiteout":             return _resolve_whiteout(choice)
		"carrion_circuit":      return _resolve_carrion_circuit(choice)
		"pack_split_winter":    return _resolve_pack_split_winter(choice)
		# Tier 4 / 3 species-specific
		"raptor_pack_strike":   return _resolve_raptor_pack_strike(choice)
		"carno_full_sprint":    return _resolve_carno_full_sprint(choice)
		"allo_displacement":    return _resolve_allo_displacement(choice)
		"troodon_circuit":      return _resolve_troodon_circuit(choice)
		"iguan_spike_warning":  return _resolve_iguan_spike_warning(choice)
		"kentro_spine_array":   return _resolve_kentro_spine_array(choice)
		"stego_thagomizer":     return _resolve_stego_thagomizer(choice)
		"pachy_dome_drive":     return _resolve_pachy_dome_drive(choice)
		"ptero_colony_dive":    return _resolve_ptero_colony_dive(choice)
		"rhamph_dusk_window":   return _resolve_rhamph_dusk_window(choice)
		"ptero_offshore_run":   return _resolve_ptero_offshore_run(choice)
		"dsun_tidal_flat":      return _resolve_dsun_tidal_flat(choice)
		# Flavor-only — any choice just dismisses
		"parents_leave":        return _no_event()
		# Elder end-game legendary events
		"elder_final_compsognathus":    return _resolve_elder_s1("compsognathus", choice)
		"elder_final_compsognathus_2a": return _resolve_elder_s2("compsognathus", "a", choice)
		"elder_final_compsognathus_2b": return _resolve_elder_s2("compsognathus", "b", choice)
		"elder_final_deinonychus":      return _resolve_elder_s1("deinonychus", choice)
		"elder_final_deinonychus_2a":   return _resolve_elder_s2("deinonychus", "a", choice)
		"elder_final_deinonychus_2b":   return _resolve_elder_s2("deinonychus", "b", choice)
		"elder_final_velociraptor":     return _resolve_elder_s1("velociraptor", choice)
		"elder_final_velociraptor_2a":  return _resolve_elder_s2("velociraptor", "a", choice)
		"elder_final_velociraptor_2b":  return _resolve_elder_s2("velociraptor", "b", choice)
		"elder_final_allosaurus":       return _resolve_elder_s1("allosaurus", choice)
		"elder_final_allosaurus_2a":    return _resolve_elder_s2("allosaurus", "a", choice)
		"elder_final_allosaurus_2b":    return _resolve_elder_s2("allosaurus", "b", choice)
		"elder_final_trex":             return _resolve_elder_s1("trex", choice)
		"elder_final_trex_2a":          return _resolve_elder_s2("trex", "a", choice)
		"elder_final_trex_2b":          return _resolve_elder_s2("trex", "b", choice)
		"elder_final_lesothosaurus":    return _resolve_elder_s1("lesothosaurus", choice)
		"elder_final_lesothosaurus_2a": return _resolve_elder_s2("lesothosaurus", "a", choice)
		"elder_final_lesothosaurus_2b": return _resolve_elder_s2("lesothosaurus", "b", choice)
		"elder_final_iguanodon":        return _resolve_elder_s1("iguanodon", choice)
		"elder_final_iguanodon_2a":     return _resolve_elder_s2("iguanodon", "a", choice)
		"elder_final_iguanodon_2b":     return _resolve_elder_s2("iguanodon", "b", choice)
		"elder_final_triceratops":      return _resolve_elder_s1("triceratops", choice)
		"elder_final_triceratops_2a":   return _resolve_elder_s2("triceratops", "a", choice)
		"elder_final_triceratops_2b":   return _resolve_elder_s2("triceratops", "b", choice)
		"elder_final_ankylosaurus":     return _resolve_elder_s1("ankylosaurus", choice)
		"elder_final_ankylosaurus_2a":  return _resolve_elder_s2("ankylosaurus", "a", choice)
		"elder_final_ankylosaurus_2b":  return _resolve_elder_s2("ankylosaurus", "b", choice)
		"elder_final_argentinosaurus":  return _resolve_elder_s1("argentinosaurus", choice)
		"elder_final_argentinosaurus_2a": return _resolve_elder_s2("argentinosaurus", "a", choice)
		"elder_final_argentinosaurus_2b": return _resolve_elder_s2("argentinosaurus", "b", choice)
		# Legendary world events
		"white_ghost":      return _resolve_white_ghost(choice)
		"ancient_watcher":  return _resolve_ancient_watcher(choice)
		"bone_ground":      return _resolve_bone_ground(choice)
		"the_great_herd":   return _resolve_great_herd(choice)
		# Turning-point events (desperate state)
		"last_water":       return _resolve_last_water(choice)
		"the_wrong_season": return _resolve_wrong_season(choice)
		"final_stand":      return _resolve_final_stand(choice)
		"last_reserves":    return _resolve_last_reserves(choice)
		# Rival system
		"rival_encounter":  return _resolve_rival_encounter(choice)
	return _no_event()


# ── HUNT ─────────────────────────────────────────────────────────────────────

func _resolve_hunt_roll() -> Dictionary:
	var uses := GameState.get_action_uses("hunt")
	if uses >= 3:
		return _hunt_nothing(uses)

	var luck := GameState.luck_mod() + WORLD.modifier("hunt")
	var roll := randf()

	# Crit: fires when roll lands above the ceiling — luck shifts ceiling down (easier to crit)
	var crit_floor      := clampf(1.0 - (0.08 + luck * 0.6), 0.82, 0.98)
	# Nothing: floor climbs each use and with negative luck
	var nothing_ceiling := clampf(0.16 + (uses - 1) * 0.22 - luck * 0.8, 0.04, 0.55)
	# Mixed: sits just above the nothing zone — negative luck widens it
	var mixed_ceiling   := clampf(nothing_ceiling + 0.13 - luck * 0.5, nothing_ceiling + 0.04, nothing_ceiling + 0.30)

	# ── Territory claim modifier ──────────────────────────────────────────────
	match GameState.territory_claim:
		"strong":
			crit_floor      = maxf(0.65, crit_floor      - 0.10)  # easier to crit
			nothing_ceiling = maxf(0.02, nothing_ceiling - 0.10)  # fewer empty hunts
		"useful":
			nothing_ceiling = maxf(0.02, nothing_ceiling - 0.05)  # slightly fewer empty hunts
		"contested":
			mixed_ceiling   = minf(nothing_ceiling + 0.45, mixed_ceiling + 0.12)  # more mixed results
		"weak":
			pass  # no change

	if roll >= crit_floor:
		return _hunt_crit()
	elif roll < nothing_ceiling:
		return _hunt_nothing(uses)
	elif roll < mixed_ceiling:
		return _hunt_mixed()
	else:
		return _hunt_success()


func _hunt_crit() -> Dictionary:
	var path := "res://scripts/dinos/%s/dino_hunt.gd" % GameState.species_id
	if ResourceLoader.exists(path):
		var script = load(path)
		var node := Node.new()
		node.set_script(script)
		var crit: Dictionary = node.get_crit_event()
		node.free()
		if not crit.is_empty():
			GameState.hunger = minf(GameState.hunger + crit.get("hunger_gain", 0.35), 1.0)
			GameState.kills     += 1
			GameState.fights_won += 1
			var flavor: String = (crit.get("flavor", "") as String) + "\n\n" + (crit.get("result", "") as String)
			return {
				"type": "hunt_crit",
				"flavor": flavor.strip_edges(),
				"choices": [
					{ "label": crit.get("button", "Good."), "icon": "stalk", "sublabel": "", "action": "crit_dismiss" }
				],
				"resolve_key": "hunt_crit",
			}
	# Generic fallback
	GameState.hunger = minf(GameState.hunger + 0.40, 1.0)
	GameState.kills     += 1
	GameState.fights_won += 1
	var flavors := [
		"You moved before it knew you were there. One strike. The kill came easy — the hunger fades for now.",
		"Perfect timing. The prey had no chance to react. Not every hunt feels like this.",
		"Everything lined up. You were already on it before the instincts finished firing.",
	]
	return _result(flavors[randi() % flavors.size()])


func _hunt_nothing(uses: int) -> Dictionary:
	var flavors: Array
	if uses >= 3:
		flavors = [
			"You have pushed this ground too hard today. Nothing stirs. The hunt is over for this season.",
			"The territory has gone quiet. You have taken everything the area will give today.",
			"Empty trails. Still air. You have exhausted the hunting ground for today.",
		]
	elif uses == 2:
		flavors = [
			"The ground is quiet again. Whatever was here has moved off.",
			"Nothing. The second time through, you find less than the first.",
			"You circle the area again. Still nothing worth the effort.",
		]
	else:
		flavors = [
			"The area is quiet. No tracks, no scent, no sign of anything worth chasing.",
			"Nothing moves. The hunting ground is empty this season.",
			"You range out but find no targets. The land offers nothing today.",
		]
	return _result(flavors[randi() % flavors.size()])


func _hunt_success() -> Dictionary:
	var path := "res://scripts/dinos/%s/dino_hunt.gd" % GameState.species_id
	if ResourceLoader.exists(path):
		var script = load(path)
		var node := Node.new()
		node.set_script(script)
		var encounters: Array = node.get_encounters()
		node.free()
		if not encounters.is_empty():
			return _build_species_encounter(encounters)
	return _build_prey_encounter(false)


func _build_species_encounter(encounters: Array) -> Dictionary:
	var enc: Dictionary = encounters[randi() % encounters.size()]
	var prey: Dictionary = enc.get("prey", {}).duplicate()
	prey["opponent_size"] = GameState.size
	prey["stalked"] = false
	_pending_prey = prey
	var attacker := {
		"fight_power":   GameState.strength,
		"size":          GameState.size,
		"opponent_size": prey.get("size", 1),
		"group_size":    PackManager.get_virtual_group_size(),
	}
	var context = CombatResolver.get_context_clue(attacker, prey)
	return {
		"type": "prey_found", "next_context": "prey_found",
		"prey_name": enc.get("prey", {}).get("name", ""),
		"flavor": enc.get("flavor", "") + "\n\n" + context,
		"choices": [
			{ "label": enc.get("button_fight", "Attack"),   "icon": "attack", "sublabel": enc.get("sublabel_fight", "Engage"),    "action": "attack" },
			{ "label": enc.get("button_leave", "Back off"), "icon": "flee",   "sublabel": enc.get("sublabel_leave", "Walk away"), "action": "leave"  },
		]
	}


func _hunt_mixed() -> Dictionary:
	var path := "res://scripts/dinos/%s/dino_hunt.gd" % GameState.species_id
	if ResourceLoader.exists(path):
		var script = load(path)
		var node := Node.new()
		node.set_script(script)
		var encounters: Array = node.get_mixed_encounters()
		node.free()
		if not encounters.is_empty():
			return _build_species_mixed_encounter(encounters)
	return _build_prey_encounter_alerted()


func _build_species_mixed_encounter(encounters: Array) -> Dictionary:
	var enc: Dictionary = encounters[randi() % encounters.size()]
	var prey: Dictionary = enc.get("prey", {}).duplicate()
	prey["opponent_size"] = GameState.size
	prey["stalked"] = false
	prey["alerted"] = true
	_pending_prey = prey
	var attacker := {
		"fight_power":   GameState.strength,
		"size":          GameState.size,
		"opponent_size": prey.get("size", 1),
		"group_size":    PackManager.get_virtual_group_size(),
	}
	var context = CombatResolver.get_context_clue(attacker, prey)
	var flavor: String = (enc.get("flavor", "") as String) + "\n\n" + (enc.get("combat_start", "") as String) + "\n\n" + context
	return {
		"type": "prey_alerted", "next_context": "prey_alerted",
		"prey_name": enc.get("prey", {}).get("name", ""),
		"flavor": flavor.strip_edges(),
		"choices": [
			{ "label": enc.get("button_fight", "Fight back."),  "icon": "attack", "sublabel": enc.get("sublabel_fight", "Take the hit and counter"), "action": "attack" },
			{ "label": enc.get("button_leave", "Flee."),        "icon": "flee",   "sublabel": enc.get("sublabel_leave", "Get out now"),               "action": "flee"   },
		]
	}


func _build_prey_encounter_alerted() -> Dictionary:
	var species := SpeciesDB.get_species(GameState.species_id)
	var is_flyer: bool = species.get("tree", "") == "flyer"
	var max_tier: int  = 3 if is_flyer else 5
	var tier: int = mini(GameState.size, max_tier)
	if not is_flyer and GameState.pack_bond >= 0.40:
		var pack_cap: int = max_tier if GameState.size >= 5 else 4
		tier = mini(tier + 1, pack_cap)
	var prey_pool: Array = FLYER_PREY_TIERS.get(tier, FLYER_PREY_TIERS[1]) if is_flyer \
		else PREY_TIERS.get(tier, PREY_TIERS[1])
	var prey: Dictionary = prey_pool[randi() % prey_pool.size()].duplicate()
	prey["opponent_size"] = GameState.size
	prey["stalked"] = false
	prey["alerted"] = true
	_pending_prey = prey
	var attacker := {
		"fight_power":   GameState.strength,
		"size":          GameState.size,
		"opponent_size": prey["size"],
		"group_size":    PackManager.get_virtual_group_size(),
	}
	var context = CombatResolver.get_context_clue(attacker, prey)
	return {
		"type": "prey_alerted", "next_context": "prey_alerted",
		"flavor": "You found %s — but it spotted you first. It's already braced.\n\n%s" % [prey["name"], context],
		"choices": [
			{ "label": "Commit anyway",  "icon": "attack", "sublabel": "Press through the disadvantage", "action": "attack" },
			{ "label": "Back off",       "icon": "flee",   "sublabel": "Disengage before it charges",   "action": "flee"   },
		]
	}


func _resolve_prey_alerted(choice: String) -> Dictionary:
	match choice:
		"attack":
			# Prey had time to brace — fight_power increased
			var prey := _pending_prey.duplicate()
			prey["fight_power"] = minf(prey["fight_power"] * 1.30, 0.95)
			_pending_prey = prey
			return _run_hunt_combat(false)
		"flee":
			return _roll_leave_consequence()
	return _no_event()


func _build_prey_encounter(stalked: bool) -> Dictionary:
	var species := SpeciesDB.get_species(GameState.species_id)
	var is_flyer: bool = species.get("tree", "") == "flyer"
	var max_tier: int  = 3 if is_flyer else 5
	var tier: int = mini(GameState.size, max_tier)
	# Coordinated packs can take prey one size class above their own,
	# but tier 5 (apex prey) requires base size >= 5 even with a pack
	if not is_flyer and GameState.pack_bond >= 0.40:
		var pack_cap: int = max_tier if GameState.size >= 5 else 4
		tier = mini(tier + 1, pack_cap)
	var prey_pool: Array = FLYER_PREY_TIERS.get(tier, FLYER_PREY_TIERS[1]) if is_flyer \
		else PREY_TIERS.get(tier, PREY_TIERS[1])
	var prey: Dictionary = prey_pool[randi() % prey_pool.size()].duplicate()
	prey["opponent_size"] = GameState.size
	prey["stalked"] = stalked
	_pending_prey = prey
	var attacker = {
		"fight_power":   GameState.strength,
		"size":          GameState.size,
		"opponent_size": prey["size"],
		"group_size":    PackManager.get_virtual_group_size(),
	}
	var context = CombatResolver.get_context_clue(attacker, prey)
	var stalk_hint = " You have the element of surprise." if stalked else ""
	return {
		"type": "prey_found", "next_context": "prey_found",
		"flavor": "You've found %s.%s\n\n%s" % [prey["name"], stalk_hint, context],
		"choices": [
			{ "label": "Attack",   "icon": "attack", "sublabel": "Go in hard",             "action": "attack" },
			{ "label": "Watch",    "icon": "stalk",  "sublabel": "Wait for a better moment","action": "watch" },
			{ "label": "Leave it", "icon": "flee",   "sublabel": "Not worth the risk",     "action": "leave" },
		]
	}


func _resolve_prey_encounter(choice: String) -> Dictionary:
	match choice:
		"attack":
			return _run_hunt_combat(false)
		"watch":
			# Watching may reveal a second chance or a threat
			if randf() < 0.40 + GameState.luck_mod():
				return _run_hunt_combat(true)  # better opening
			elif randf() < 0.30:
				return _build_threat_event()
			else:
				return {
					"type": "result", "next_context": "",
					"flavor": "You watched and waited. The moment passed. The prey moved off.",
					"choices": []
				}
		"leave":
			return _roll_leave_consequence()
	return _no_event()


func _roll_leave_consequence() -> Dictionary:
	var roll := randf()
	if roll < 0.12:
		# A rival saw you walk away — reads it as weakness and moves in
		return {
			"type": "threat", "next_context": "threat",
			"flavor": "Something was watching you from cover. When you turned away from the prey, it decided you were the easier target.",
			"choices": [
				{ "label": "Stand ground", "icon": "attack", "sublabel": "Don't give up any more ground", "action": "fight" },
				{ "label": "Back away",    "icon": "stalk",  "sublabel": "Keep moving, don't escalate",  "action": "watch" },
				{ "label": "Flee",         "icon": "flee",   "sublabel": "Get out now",                  "action": "flee" },
			]
		}
	if roll < 0.20:
		# Leaving the prey attracted a scavenger to the area — it's already at your water source
		GameState.apply_temp_buff("hunger", -0.06, 2, "rival_moved_in")
		return _result("The prey you left drew others in. Your usual range feels contested now. Finding food next turn will be harder.")
	return _no_event()


func _run_hunt_combat(bonus_opening: bool) -> Dictionary:
	return _show_combat_preview(bonus_opening)


func _show_combat_preview(bonus_opening: bool) -> Dictionary:
	var player := CombatResolver.load_player_stats()
	var enemy  := CombatResolver.load_enemy_stats(_pending_prey)

	# bonus_opening: prey is off-guard — weaken their effective stats
	if bonus_opening:
		enemy["fight_power"] = enemy.get("fight_power", 0.30) * 0.78
		enemy["resilience"]  = enemy.get("resilience",  0.30) * 0.80

	_pending_combat_context = {
		"player":        player,
		"enemy":         enemy,
		"bonus_opening": bonus_opening,
	}

	var comparison: String = CombatResolver.get_context_clue_v2(player, enemy)
	var species := SpeciesDB.get_species(GameState.species_id)
	var is_pack: bool = species.get("pack_species", false) and species.get("tree", "") == "predator"

	# Pack narrative — if outmatched and pack is available, hint at calling them in
	var player_fp: float = player.get("fight_power", 0.30) as float
	var enemy_fp:  float = enemy.get("fight_power",  0.30) as float
	if is_pack and enemy_fp > player_fp + 0.08:
		if GameState.pack_bond > 0.0:
			comparison += "\n\nSomething in you says this fight wants more teeth. The pack could turn it — but they will want their share of the kill."
		else:
			comparison += "\n\nYou feel it — this is a fight that wants the pack behind you. You are on your own."

	var choices := [
		{ "label": "Fight",  "icon": "attack", "sublabel": "Commit to the attack",          "action": "combat_fight" },
		{ "label": "Brace",  "icon": "shield", "sublabel": "Trade offense for protection",  "action": "combat_brace" },
		{ "label": "Run",    "icon": "flee",   "sublabel": "Speed contest — who's faster",  "action": "combat_run"   },
	]
	if is_pack and GameState.pack_bond > 0.0:
		choices.insert(2, {
			"label": "Call Pack", "icon": "pack",
			"sublabel": "More teeth, less meat for you",
			"action": "combat_pack"
		})
	var willing := COMPANIONS.supporters()
	if not willing.is_empty():
		comparison += "\n\n%s %s ready to stand with you. They remember how you treated them. Their help is available once this season." % [LIFE_STORY.names_text(willing), "is" if willing.size() == 1 else "are"]
		choices.insert(2, {"label": "Call companions" if is_pack else "Form up together", "icon": "bond",
			"sublabel": "Trusted support; share any food", "action": "combat_companions"})
	elif COMPANIONS.supported() and GameState.pack_bond > 0.0:
		comparison += "\n\nNo named companion is ready to help. They may still be wary, have pulled away, or already helped this season."
	# Juvenile mother-bond species — can call their mother to intervene, at a bond cost
	var is_mother_bond_juvenile: bool = GameState.life_stage == 1 \
		and GameState.species_id in ["trex", "allosaurus", "ankylosaurus"]
	if is_mother_bond_juvenile:
		choices.append({
			"label": "Call Mom", "icon": "bond",
			"sublabel": "She'll come — but she'll know",
			"action": "combat_call_mom"
		})

	return {
		"type": "combat_preview", "next_context": "combat_preview",
		"flavor": comparison,
		"choices": choices,
		"resolve_key": "combat_preview",
	}


func _resolve_combat_choice(choice: String) -> Dictionary:
	if _pending_combat_context.is_empty() or choice not in ["combat_fight", "combat_brace", "combat_run", "combat_pack", "combat_call_mom", "combat_companions"]:
		return _no_event()
	if choice == "combat_companions" and COMPANIONS.supporters().is_empty():
		return _no_event()
	var player: Dictionary = (_pending_combat_context.get("player", {}) as Dictionary).duplicate()
	var enemy:  Dictionary = (_pending_combat_context.get("enemy",  {}) as Dictionary).duplicate()
	var prey   := _pending_prey
	_pending_combat_context = {}
	var is_hunt := _pending_combat_is_hunt
	_pending_combat_is_hunt = true

	# ── CALL MOM (juvenile mother-bond species only) ───────────────────────────
	if choice == "combat_call_mom":
		GameState.mother_bond = maxf(-1.0, GameState.mother_bond - 0.20)
		var call_mom_flavors := [
			"She comes between you and the threat before it gets any closer. The predator reads her and retreats. You are safe — but she saw you call.",
			"Your mother moves in from the tree line without hesitation. The threat backs off immediately. She looks at you once before returning to where she was.",
			"You call and she answers. The encounter ends as fast as it started. She does not need to say anything. You already know.",
			"She arrives at full speed and places herself between you and the danger. The threat is gone in seconds. The space between you and her is quieter than it was this morning.",
		]
		return {
			"type": "result", "next_context": "",
			"flavor": call_mom_flavors[randi() % call_mom_flavors.size()],
			"choices": []
		}

	# ── RUN ──────────────────────────────────────────────────────────────────
	if choice == "combat_run":
		var p_speed: float = (player.get("agility", 0.40) as float) + GameState.luck_mod() * 0.40
		var e_speed: float = enemy.get("agility", 0.40) as float
		# Even when faster, a 5% stumble chance keeps escape from feeling guaranteed.
		var clean_escape := p_speed >= e_speed and randf() > 0.05
		if clean_escape:
			GameState.fights_fled += 1
			return { "type": "result", "next_context": "", "flavor": "You break away clean. They don't follow.", "choices": [] }
		else:
			# Caught — forced into fight at a disadvantage
			player["fight_power"] = maxf(player.get("fight_power", 0.30) * 0.80, 0.05)
			player["resilience"]  = maxf(player.get("resilience",  0.30) * 0.85, 0.05)

	# ── BRACE ─────────────────────────────────────────────────────────────────
	if choice == "combat_brace":
		var p:  float  = (player.get("power",      0.30) as float) * 0.80
		var r:  float  = (player.get("resilience", 0.30) as float) * 1.25
		var a:  float  = player.get("agility",    0.30) as float
		var i:  float  = player.get("instinct",   0.30) as float
		var s:  int    = player.get("size",        1)    as int
		var st: String = player.get("style",       "bite") as String
		player["power"]      = p
		player["resilience"] = r
		player["fight_power"] = CombatResolver.effective_attack(p, r, a, i, s, st)

	# ── BUILD ATTACKER DICT ───────────────────────────────────────────────────
	var pack_called := choice == "combat_pack"
	var companion_names: Array[String] = []
	if choice == "combat_companions":
		companion_names = COMPANIONS.take_support("in a hunt" if is_hunt else "against a threat")
	var attacker := {
		"power":         player.get("power",         0.30),
		"resilience":    player.get("resilience",    0.30),
		"agility":       player.get("agility",       0.30),
		"instinct":      player.get("instinct",      0.30),
		"fight_power":   player.get("fight_power",   0.35),
		"size":          player.get("size",          GameState.size),
		"opponent_size": enemy.get("size",           1),
		"group_size":    (maxi(PackManager.get_virtual_group_size(), 4) if pack_called else PackManager.get_virtual_group_size()),
		"style":         player.get("style",         "bite"),
		"companion_bonus": mini(companion_names.size(), 2) * 0.04,
	}

	var result := CombatResolver.resolve(attacker, enemy)

	# Pack splits the hunger reward
	if pack_called:
		result["hunger_gain"] = result.get("hunger_gain", 0.0) * 0.60
	elif not companion_names.is_empty():
		result["hunger_gain"] = result.get("hunger_gain", 0.0) * 0.80
	var event := _apply_combat_result(result, prey, is_hunt)
	if not companion_names.is_empty():
		event["flavor"] = "%s stood beside you.\n\n%s" % [LIFE_STORY.names_text(companion_names), event.get("flavor", "")]
	return event


# ── SCAVENGE ─────────────────────────────────────────────────────────────────

func _load_scavenge_data() -> Dictionary:
	var path := "res://scripts/dinos/%s/dino_hunt.gd" % GameState.species_id
	if ResourceLoader.exists(path):
		var script = load(path)
		var node := Node.new()
		node.set_script(script)
		var finds: Array  = node.get_scavenge_finds() as Array
		var miss:  String = node.get_scavenge_miss()  as String
		node.free()
		if not finds.is_empty():
			return { "finds": finds, "miss": miss }
	return {}


func _resolve_scavenge(choice: String) -> Dictionary:
	var uses        := GameState.get_action_uses("scavenge")
	var young_female: bool = GameState.sex == "female" and GameState.has_young

	# "Dig in" takes what's already found — small guaranteed gain, skip random roll.
	if choice == "scavenge_eat":
		var species_tree: String = SpeciesDB.get_species(GameState.species_id).get("tree", "predator") as String
		var suffix := " You ate quickly — one eye always back toward the young." if young_female else ""
		var gain: float = 0.12 * (0.70 if young_female else 1.0)
		var flavor: String
		if species_tree == "herbivore":
			var herb_eat := [
				"You eat what you found without lingering. Not much, but it takes the edge off." + suffix,
				"You work through the find quickly. Enough to keep going." + suffix,
				"The pickings are lean but real. You take what's there." + suffix,
			]
			flavor = herb_eat[randi() % herb_eat.size()]
		else:
			var carn_eat := [
				"Old and picked over, but you take what's left. Something is better than nothing." + suffix,
				"You dig in before anything else finds it. Not fresh, but edible." + suffix,
				"Not a clean find — but hunger doesn't care. You eat." + suffix,
			]
			flavor = carn_eat[randi() % carn_eat.size()]
		GameState.hunger = minf(1.0, GameState.hunger + gain)
		return { "type": "result", "next_context": "", "flavor": flavor, "choices": [] }

	var find_chance := (0.70 if uses == 1 else 0.35) + GameState.luck_mod() + WORLD.modifier("scavenge")
	if young_female:
		find_chance -= 0.20

	var scav_data := _load_scavenge_data()
	var species_finds: Array = scav_data.get("finds", []) as Array

	if randf() < find_chance:
		var flavor: String
		var gain:   float
		if not species_finds.is_empty():
			var find: Dictionary = species_finds[randi() % species_finds.size()]
			gain   = find.get("hunger_value", 0.18) * (0.70 if young_female else 1.0)
			flavor = find.get("flavor", "You found something edible and take what you can.")
			if flavor.strip_edges().is_empty():
				flavor = "You found something edible and take what you can."
			if young_female:
				flavor += " You ate faster than you wanted to — one eye always back toward the young."
		else:
			var species_tree: String = SpeciesDB.get_species(GameState.species_id).get("tree", "predator") as String
			var suffix := " You ate faster than you wanted to — one eye always back toward the young." if young_female else ""
			if species_tree == "herbivore":
				var find = FORAGE_FINDS[randi() % FORAGE_FINDS.size()]
				gain   = find["hunger_value"] * (0.70 if young_female else 1.0)
				flavor = find["flavor"] + suffix
			else:
				var find = SCAVENGE_FINDS[randi() % SCAVENGE_FINDS.size()]
				gain   = find["hunger_value"] * (0.70 if young_female else 1.0)
				flavor = "You found %s. Not a clean kill, but it fills the belly.%s" % [find["desc"], suffix]
		GameState.hunger = minf(1.0, GameState.hunger + gain)
		return { "type": "result", "next_context": "", "flavor": flavor, "choices": [] }

	# Miss
	var miss: String
	if young_female:
		miss = "You couldn't range far enough to find anything. The young kept pulling your attention back."
	else:
		var species_miss: String = scav_data.get("miss", "") as String
		miss = species_miss if species_miss != "" else "You searched the area but found nothing worth eating."
	return { "type": "result", "next_context": "", "flavor": miss, "choices": [] }


# ── GRAZE (herbivore food equivalent of hunt) ─────────────────────────────────

func _load_graze_data() -> Dictionary:
	var path := "res://scripts/dinos/%s/dino_graze.gd" % GameState.species_id
	if not ResourceLoader.exists(path):
		return {}
	var script = load(path)
	var node := Node.new()
	node.set_script(script)
	var data: Dictionary = node.get_graze_data()
	node.free()
	return data


func _resolve_graze_roll() -> Dictionary:
	var uses := GameState.get_action_uses("graze")
	if uses >= 3:
		return _graze_nothing(uses)

	var luck := GameState.luck_mod() + WORLD.modifier("graze")
	var roll := randf()

	var crit_floor      := clampf(1.0 - (0.08 + luck * 0.6), 0.82, 0.98)
	var no_food_ceiling := clampf(0.12 + (uses - 1) * 0.15 - luck * 0.8, 0.03, 0.45)
	var danger_ceiling  := clampf(no_food_ceiling + 0.08 - luck * 0.4, no_food_ceiling + 0.02, no_food_ceiling + 0.18)
	var mixed_ceiling   := clampf(danger_ceiling  + 0.12 - luck * 0.5, danger_ceiling  + 0.03, danger_ceiling  + 0.25)

	match GameState.territory_claim:
		"strong":
			crit_floor      = maxf(0.65, crit_floor      - 0.10)
			no_food_ceiling = maxf(0.02, no_food_ceiling - 0.10)
		"useful":
			no_food_ceiling = maxf(0.02, no_food_ceiling - 0.05)
		"contested":
			danger_ceiling  = minf(no_food_ceiling + 0.25, danger_ceiling + 0.08)
			mixed_ceiling   = minf(danger_ceiling  + 0.40, mixed_ceiling  + 0.10)

	if   roll >= crit_floor:      return _graze_crit()
	elif roll < no_food_ceiling:  return _graze_nothing(uses)
	elif roll < danger_ceiling:   return _graze_danger()
	elif roll < mixed_ceiling:    return _graze_mixed()
	else:                         return _graze_success()


func _graze_crit() -> Dictionary:
	var data: Dictionary = _load_graze_data()
	var pool: Array = data.get("crit_flavor", []) as Array
	var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() else \
		"You find excellent grazing and feed deeply without any threat."
	var bonus := GameState.next_season_graze_crit_bonus
	GameState.next_season_graze_crit_bonus = 0.0
	GameState.hunger = minf(1.0, GameState.hunger + 0.40 + bonus)
	return {
		"type": "graze_crit", "next_context": "graze_crit",
		"flavor": flavor,
		"choices": [{ "label": "Eat well.", "icon": "bond", "sublabel": "", "action": "crit_dismiss" }],
		"resolve_key": "graze_crit",
	}


func _graze_success() -> Dictionary:
	var data: Dictionary = _load_graze_data()
	var pool: Array = data.get("success_flavor", []) as Array
	var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() else \
		"You find enough to eat without any trouble."
	var bonus := GameState.next_season_graze_success_bonus
	GameState.next_season_graze_success_bonus = 0.0
	GameState.hunger = minf(1.0, GameState.hunger + 0.22 + bonus)
	return _result(flavor)


func _graze_mixed() -> Dictionary:
	var data: Dictionary = _load_graze_data()
	var encounters: Array = data.get("mixed_encounters", []) as Array
	if encounters.is_empty():
		return _graze_success()
	var enc: Dictionary = encounters[randi() % encounters.size()]
	var predator: Dictionary = enc.get("predator", {}).duplicate()
	predator["hunger_value"]  = 0.22   # food the player earns by winning
	predator["opponent_size"] = GameState.size
	_pending_prey = predator
	var attacker := {
		"fight_power":   GameState.strength,
		"size":          GameState.size,
		"opponent_size": predator.get("size", 1),
		"group_size":    0,
	}
	var context: String = CombatResolver.get_context_clue(attacker, predator)
	return {
		"type": "graze_encounter", "next_context": "graze_encounter",
		"predator_name": predator.get("name", ""),
		"flavor": (enc.get("flavor", "") as String) + "\n\n" + context,
		"choices": [
			{ "label": enc.get("button_fight", "Hold your ground"), "icon": "attack",
			  "sublabel": enc.get("sublabel_fight", "Drive them off and eat"), "action": "fight_predator" },
			{ "label": enc.get("button_leave", "Leave the food"),   "icon": "flee",
			  "sublabel": enc.get("sublabel_leave", "Walk away hungry"),       "action": "leave_food"    },
		],
		"resolve_key": "graze_encounter",
	}


func _graze_danger() -> Dictionary:
	var data: Dictionary = _load_graze_data()
	var encounters: Array = data.get("danger_encounters", []) as Array
	if encounters.is_empty():
		return _build_threat_event()
	var enc: Dictionary = encounters[randi() % encounters.size()]
	var predator: Dictionary = enc.get("predator", {}).duplicate()
	predator["hunger_value"]  = 0.18   # small food gain for winning; you were near food when attacked
	predator["opponent_size"] = GameState.size
	_pending_prey            = predator
	_pending_combat_is_hunt  = false
	return {
		"type": "graze_danger", "next_context": "graze_danger",
		"predator_name": predator.get("name", ""),
		"flavor": enc.get("flavor", "A predator attacks before you can reach the food."),
		"choices": [
			{ "label": "Defend yourself", "icon": "attack",
			  "sublabel": "No choice — it is already moving", "action": "defend" },
		],
		"resolve_key": "graze_danger",
	}


func _graze_nothing(uses: int) -> Dictionary:
	var data: Dictionary = _load_graze_data()
	var pool: Array
	if uses >= 3:
		pool = [
			"You have covered every reachable patch today. Nothing useful remains.",
			"The ground has nothing left to offer this season. You have already taken what it had.",
			"You searched every likely patch. The area is spent for today.",
		]
	else:
		pool = data.get("no_food_flavor", []) as Array
		if pool.is_empty():
			pool = [
				"You search the area but find nothing worth eating.",
				"The ground is dry, stripped, or too exposed to graze safely.",
				"Every promising patch has already been picked clean.",
			]
	return _result(pool[randi() % pool.size()])


func _resolve_graze_crit_dismiss() -> Dictionary:
	return _no_event()


func _resolve_graze_encounter(choice: String) -> Dictionary:
	match choice:
		"fight_predator":
			_pending_combat_is_hunt = false
			return _show_combat_preview(false)
		"leave_food":
			_pending_prey = {}
			var flavors := [
				"You back away from the food and leave it behind.",
				"You move off without eating. Better hungry than hurt.",
				"You leave the food and put distance between you and the threat.",
			]
			return _result(flavors[randi() % flavors.size()])
	return _no_event()


func _resolve_graze_danger_choice(choice: String) -> Dictionary:
	match choice:
		"defend":
			return _show_combat_preview(false)
	return _no_event()


# ── REST ─────────────────────────────────────────────────────────────────────

func _load_rest_flavors() -> Dictionary:
	var path := "res://scripts/dinos/%s/dino_rest.gd" % GameState.species_id
	if ResourceLoader.exists(path):
		var script = load(path)
		var node := Node.new()
		node.set_script(script)
		var flavors: Dictionary = node.get_rest_flavors() as Dictionary
		node.free()
		return flavors
	return {}


func _resolve_rest() -> Dictionary:
	var uses        := GameState.get_action_uses("rest")
	var heal_amount := 0.0
	var rf          := _load_rest_flavors()
	var pool: Array

	if uses == 1:
		heal_amount = 0.20 * GameState.hunger
		pool = rf.get("first", []) as Array
		if pool.is_empty():
			pool = ["You rest. The body recovers slowly."]
	elif uses == 2:
		heal_amount = 0.10 * GameState.hunger
		pool = rf.get("second", []) as Array
		if pool.is_empty():
			pool = ["You settle again, but rest does not come as easily the second time."]
	else:
		heal_amount = 0.0
		pool = rf.get("exhausted", []) as Array
		if pool.is_empty():
			pool = ["You rest, but your body gains nothing more this season."]

	var flavor: String = pool[randi() % pool.size()]

	GameState.health = minf(1.0, GameState.health + heal_amount)
	return { "type": "result", "next_context": "", "flavor": flavor, "choices": [] }


# ── TERRITORY ────────────────────────────────────────────────────────────────

func _load_territory_data() -> Dictionary:
	var path := "res://scripts/dinos/%s/dino_territory.gd" % GameState.species_id
	if ResourceLoader.exists(path):
		var script = load(path)
		var node := Node.new()
		node.set_script(script)
		var data: Dictionary = node.get_territory_data() as Dictionary
		node.free()
		return data
	return {}


func _resolve_territory() -> Dictionary:
	var lm := GameState.luck_mod() + WORLD.modifier("territory")

	# Weighted outcome roll — luck shifts weight toward strong/useful or contested/weak
	var w_strong    := maxf(0.05, 0.25 + lm * 2.0)
	var w_useful    := maxf(0.05, 0.30 + lm * 0.5)
	var w_contested := maxf(0.05, 0.25 - lm * 1.0)
	var w_weak      := maxf(0.05, 0.20 - lm * 1.5)
	var total       := w_strong + w_useful + w_contested + w_weak
	var roll        := randf() * total
	var claim: String
	if roll < w_strong:
		claim = "strong"
	elif roll < w_strong + w_useful:
		claim = "useful"
	elif roll < w_strong + w_useful + w_contested:
		claim = "contested"
	else:
		claim = "weak"

	GameState.pending_territory_claim = claim

	# Herbivores earn a food bonus that activates next season (pending → active at advance_season)
	if GameState.species_id in _PATTERN_B_SPECIES:
		match claim:
			"strong":
				GameState.pending_graze_crit_bonus    = 0.10
				GameState.pending_graze_success_bonus = 0.08
			"useful":
				GameState.pending_graze_crit_bonus    = 0.05
				GameState.pending_graze_success_bonus = 0.04

	# Patrolling and scent-marking burns energy regardless of outcome.
	GameState.hunger = maxf(0.0, GameState.hunger - 0.08)

	var data  := _load_territory_data()
	var pool: Array = data.get(claim, []) as Array
	var flavor: String
	if pool.is_empty():
		match claim:
			"strong":    flavor = "You mark the perimeter thoroughly. This ground is yours."
			"useful":    flavor = "You mark the area well enough. A solid claim for next season."
			"contested": flavor = "Your marks hold, but something else is already here."
			_:           flavor = "Your marks are faint. The claim may not carry."
	else:
		flavor = pool[randi() % pool.size()]

	return { "type": "result", "next_context": "", "flavor": flavor, "choices": [] }


# ── SHARPEN SKILLS ────────────────────────────────────────────────────────────

func _load_sharpen_data() -> Dictionary:
	var path := "res://scripts/dinos/%s/dino_sharpen.gd" % GameState.species_id
	if ResourceLoader.exists(path):
		var script = load(path)
		var node := Node.new()
		node.set_script(script)
		var data: Dictionary = node.get_sharpen_data() as Dictionary
		node.free()
		return data
	return {}


func _resolve_sharpen_prompt() -> Dictionary:
	var data    := _load_sharpen_data()
	var choices := []
	for stat in ["strength", "defense", "speed", "instinct"]:
		var entry: Dictionary = data.get(stat, {}) as Dictionary
		var label: String     = entry.get("button", stat.capitalize()) as String
		var icon: String
		match stat:
			"strength": icon = "attack"
			"defense":  icon = "shield"
			"speed":    icon = "flee"
			"instinct": icon = "stalk"
		choices.append({ "label": label, "icon": icon, "sublabel": stat.capitalize(), "action": stat })
	choices.append({ "label": "Back", "action": "back" })
	return {
		"type": "sharpen_choice", "next_context": "sharpen_choice",
		"flavor": "You choose to hone your survival skills. What will you focus on this season?",
		"choices": choices,
	}


func _resolve_sharpen_result(choice: String) -> Dictionary:
	if choice == "back":
		return _result("You decide this isn't the season for it. You move on.")

	var stat_key: String
	match choice:
		"strength": stat_key = "strength"
		"defense":  stat_key = "defense"
		"speed":    stat_key = "speed"
		"instinct": stat_key = "type_stat"
		_:          return _no_event()

	var data:  Dictionary = _load_sharpen_data()
	var entry: Dictionary = data.get(choice, {}) as Dictionary

	# Training hard burns energy — more drain on failed sessions (wasted effort).
	var fail_chance := clampf(0.12 - GameState.luck_mod() * 2.0, 0.04, 0.45)
	var flavor:  String

	if randf() < fail_chance:
		GameState.hunger = maxf(0.0, GameState.hunger - 0.12)
		GameState.apply_temp_buff(stat_key, -0.03, 2, "training_strain")
		flavor = entry.get("failure", "The practice goes wrong. You feel worse for it.")
	else:
		GameState.hunger = maxf(0.0, GameState.hunger - 0.09)
		GameState.set(stat_key, minf(1.0, GameState.get(stat_key) as float + 0.03))
		flavor = entry.get("success", "The practice pays off. You feel sharper.")

	return _result(flavor)


# ── WATER ────────────────────────────────────────────────────────────────────

func _load_water_data() -> Dictionary:
	var path := "res://scripts/dinos/%s/dino_water.gd" % GameState.species_id
	if ResourceLoader.exists(path):
		var script = load(path)
		var node := Node.new()
		node.set_script(script)
		var data: Dictionary = node.get_water_data() as Dictionary
		node.free()
		return data
	return {}


func _resolve_water() -> Dictionary:
	var lm   := GameState.luck_mod() + WORLD.modifier("water")
	var data := _load_water_data()

	# Weighted outcome — good luck raises clean, bad luck raises danger/dry
	var w_clean   := maxf(0.05, 0.25 + lm * 1.0)
	var w_muddy   := 0.25
	var w_risky   := maxf(0.05, 0.20 - lm * 0.5)
	var w_danger  := maxf(0.05, 0.15 - lm * 0.75)
	var w_dry     := maxf(0.05, 0.15 - lm * 0.75)
	var total     := w_clean + w_muddy + w_risky + w_danger + w_dry
	var roll      := randf() * total

	var outcome: String
	if roll < w_clean:
		outcome = "clean"
	elif roll < w_clean + w_muddy:
		outcome = "muddy"
	elif roll < w_clean + w_muddy + w_risky:
		outcome = "risky"
	elif roll < w_clean + w_muddy + w_risky + w_danger:
		outcome = "danger"
	else:
		outcome = "dry"

	var pool: Array = data.get(outcome, []) as Array
	var flavor: String
	if pool.is_empty():
		match outcome:
			"clean":  flavor = "You find clear water and drink well."
			"muddy":  flavor = "You find muddy water. It keeps you moving."
			"risky":  flavor = "You drink from a risky source and get away clean."
			"danger": flavor = "You find water, but something small hurts you in the process."
			_:        flavor = "You search but the nearest water is dry."
	else:
		flavor = pool[randi() % pool.size()]

	match outcome:
		"clean":
			GameState.hunger = minf(1.0, GameState.hunger + 0.14)
		"muddy":
			GameState.hunger = minf(1.0, GameState.hunger + 0.08)
		"risky":
			GameState.hunger = minf(1.0, GameState.hunger + 0.08)
		"danger":
			GameState.hunger = minf(1.0, GameState.hunger + 0.10)
			GameState.health = maxf(0.0, GameState.health - 0.05)
		"dry":
			pass

	return _result(flavor)


# ── BOND ─────────────────────────────────────────────────────────────────────

func _load_bond_data() -> Dictionary:
	var path := "res://scripts/dinos/%s/dino_bond.gd" % GameState.species_id
	if ResourceLoader.exists(path):
		var script = load(path)
		var node := Node.new()
		node.set_script(script)
		var data: Dictionary = node.get_bond_data() as Dictionary
		node.free()
		return data
	return {}


func _resolve_bond() -> Dictionary:
	if GameState.pack_bond == 0.0:
		return _result("There is no one here to bond with.")

	var lm   := GameState.luck_mod()
	var data := _load_bond_data()

	# Weighted outcome — luck shifts weight toward strong/useful; bad luck raises friction
	var w_strong   := maxf(0.05, 0.20 + lm * 1.5)
	var w_useful   := maxf(0.05, 0.35 + lm * 0.5)
	var w_awkward  := 0.25
	var w_misread  := maxf(0.05, 0.15 - lm * 0.75)
	var w_friction := maxf(0.02, 0.05 - lm * 0.75)
	var total      := w_strong + w_useful + w_awkward + w_misread + w_friction
	var roll       := randf() * total

	var outcome: String
	if roll < w_strong:
		outcome = "strong"
	elif roll < w_strong + w_useful:
		outcome = "useful"
	elif roll < w_strong + w_useful + w_awkward:
		outcome = "awkward"
	elif roll < w_strong + w_useful + w_awkward + w_misread:
		outcome = "misread"
	else:
		outcome = "friction"

	var pool: Array = data.get(outcome, []) as Array
	var flavor: String
	if pool.is_empty():
		match outcome:
			"strong":   flavor = "The group comes together completely. The bond feels strong."
			"useful":   flavor = "The group settles closer. The bond improves."
			"awkward":  flavor = "The effort is uneven, but the bond improves slightly."
			"misread":  flavor = "Your attempt doesn't land. The group stays as it was."
			_:          flavor = "Your push creates friction. The group feels more tense."
	else:
		flavor = pool[randi() % pool.size()]

	match outcome:
		"strong":   PackManager.modify_bond( 0.20)
		"useful":   PackManager.modify_bond( 0.12)
		"awkward":  PackManager.modify_bond( 0.04)
		"misread":  pass
		"friction": PackManager.modify_bond(-0.04)

	# Successful shared effort earns trust even when the overall bond is capped.
	if outcome in ["strong", "useful", "awkward"]:
		COMPANIONS.ensure_cast()
		COMPANIONS.bond_effort()
	elif outcome == "friction":
		COMPANIONS.group_response(-0.1, "Your push created friction instead of bringing you closer.")

	# Bonding takes time and shared effort — always costs food.
	GameState.hunger = maxf(0.0, GameState.hunger - 0.07)

	return _result(flavor)


# ── TEND WOUNDS ───────────────────────────────────────────────────────────────

func _load_tend_data() -> Dictionary:
	var path := "res://scripts/dinos/%s/dino_tend.gd" % GameState.species_id
	if ResourceLoader.exists(path):
		var script = load(path)
		var node := Node.new()
		node.set_script(script)
		var data: Dictionary = node.get_tend_data() as Dictionary
		node.free()
		return data
	return {}


func _resolve_tend() -> Dictionary:
	var data := _load_tend_data()

	# No injuries to tend (safety check — card should be greyed out, but guard anyway)
	if GameState.injuries.is_empty():
		return _result("You have no wounds that need tending.")

	# Success — tick all non-permanent injuries, cost hunger
	GameState.tick_injuries_on_tend()
	GameState.hunger = maxf(0.0, GameState.hunger - 0.08)

	var pool: Array = data.get("success", []) as Array
	var flavor: String
	if pool.is_empty():
		flavor = "You tend your wounds carefully. They feel a little better."
	else:
		flavor = pool[randi() % pool.size()]
	return _result(flavor)


# ── TEND NEST ─────────────────────────────────────────────────────────────────

func _load_nest_data() -> Dictionary:
	var path := "res://scripts/dinos/%s/dino_nest.gd" % GameState.species_id
	if ResourceLoader.exists(path):
		var script = load(path)
		var node := Node.new()
		node.set_script(script)
		var data: Dictionary = node.get_nest_data() as Dictionary
		node.free()
		return data
	return {}


func _resolve_nest_tend() -> Dictionary:
	if not GameState.has_young:
		return _result("There are no young to tend right now.")

	var data := _load_nest_data()
	var uses := GameState.get_action_uses("nest_tend")

	if uses >= 2:
		var pool: Array = data.get("already_used", []) as Array
		var flavor: String
		if pool.is_empty():
			flavor = "You have already spent time with the young this season. More attention won't help them until the season turns."
		else:
			flavor = pool[randi() % pool.size()]
		return _result(flavor)

	# Success — spend hunger, improve nesting score
	GameState.hunger = maxf(0.0, GameState.hunger - 0.10)
	GameState.nesting_score = minf(1.0, GameState.nesting_score + 0.25)

	var pool: Array = data.get("tend", []) as Array
	var flavor: String
	if pool.is_empty():
		flavor = "You spend time with the young. They settle under your attention."
	else:
		flavor = pool[randi() % pool.size()]
	return _result(flavor)


# ── THREAT (rival predator or danger) ────────────────────────────────────────

func _build_threat_event() -> Dictionary:
	_pending_threat = {
		"fight_power":   randf_range(0.25, 0.55),
		"speed":         randf_range(0.40, 0.70),
		"size":          GameState.size + (randi() % 3) - 1,
		"opponent_size": GameState.size,
		"group_size":    0,
	}
	var attacker = {
		"fight_power":   GameState.strength,
		"size":          GameState.size,
		"opponent_size": _pending_threat["size"],
		"group_size":    PackManager.get_virtual_group_size(),
	}
	var context = CombatResolver.get_context_clue(attacker, _pending_threat)
	return {
		"type": "threat", "next_context": "threat",
		"flavor": "A rival predator emerges from the brush. It has already seen you.\n\n%s" % context,
		"choices": [
			{ "label": "Stand ground", "icon": "attack", "sublabel": "Hold your territory", "action": "fight" },
			{ "label": "Back away",    "icon": "stalk",  "sublabel": "Don't escalate",      "action": "watch" },
			{ "label": "Flee",         "icon": "flee",   "sublabel": "Get out now",          "action": "flee" },
		]
	}


func _resolve_threat(choice: String) -> Dictionary:
	match choice:
		"fight":
			var attacker = {
				"fight_power":   GameState.strength,
				"size":          GameState.size,
				"opponent_size": _pending_threat.get("size", GameState.size),
				"group_size":    PackManager.get_virtual_group_size(),
			}
			var result = CombatResolver.resolve(attacker, _pending_threat)
			return _apply_combat_result(result, _pending_threat, false)
		"watch":
			if randf() < 0.55:
				return {
					"type": "result", "next_context": "",
					"flavor": "You hold your ground without advancing. The rival reads this and moves off.",
					"choices": []
				}
			else:
				var attacker = {
					"fight_power":   GameState.strength * 0.90,
					"size":          GameState.size,
					"opponent_size": _pending_threat.get("size", GameState.size),
					"group_size":    PackManager.get_virtual_group_size(),
				}
				var result = CombatResolver.resolve(attacker, _pending_threat)
				return _apply_combat_result(result, _pending_threat, false)
		"flee":
			var flee_result = CombatResolver.resolve_flee(_pending_threat)
			if flee_result["escaped"]:
				GameState.fights_fled += 1
				GameState.speed = minf(1.0, GameState.speed + 0.01)
				return {
					"type": "result", "next_context": "",
					"flavor": "You break away and push hard. The rival does not follow.",
					"choices": []
				}
			else:
				var flee_dmg: float = flee_result["damage"] as float
				GameState.health = maxf(0.0, GameState.health - flee_dmg)
				return {
					"type": "result", "next_context": "",
					"flavor": "You try to pull away but it catches you before you clear the brush. You take a hit.",
					"choices": []
				}
	return _no_event()


# ── COMBAT APPLICATION ────────────────────────────────────────────────────────

func _load_combat_flavors() -> Dictionary:
	var path := "res://scripts/dinos/%s/dino_hunt.gd" % GameState.species_id
	if ResourceLoader.exists(path):
		var script = load(path)
		var node := Node.new()
		node.set_script(script)
		var flavors: Dictionary = node.get_combat_flavors() as Dictionary
		node.free()
		return flavors
	return {}


func _apply_combat_result(result: Dictionary, opponent: Dictionary, is_hunt: bool) -> Dictionary:
	var outcome = result["outcome"]
	var flavors: Dictionary = _load_combat_flavors()
	var flavor := ""
	SoundManager.stop_combat_loop()

	match outcome:
		CombatResolver.Outcome.WIN:
			GameState.hunger = minf(1.0, GameState.hunger + result["hunger_gain"])
			GameState.fights_won += 1
			if is_hunt:
				GameState.kills    += 1
				GameState.strength  = minf(1.0, GameState.strength + 0.01)
			# Juvenile mother-bond species: winning without calling mom builds the bond
			if GameState.life_stage == 1 and GameState.species_id in ["trex", "allosaurus", "ankylosaurus"]:
				GameState.mother_bond = minf(2.0, GameState.mother_bond + 0.05)
			# Rival final showdown — winning ends the rivalry
			if opponent.get("is_rival_final", false):
				var rname := GameState.rival_name.capitalize()
				GameState.rival_name = ""
				GameState.rival_encounters = 0
				GameState.bonuses_earned.append("Rival Defeated")
				flavor = "You put %s down for good. The range has been quiet in a way it hasn't been since before any of this started. You don't expect to miss it. You might anyway." % rname
				SoundManager.play_win_roar()
				return { "type": "result", "next_context": "", "flavor": flavor, "choices": [] }
			flavor = flavors.get("win", "A clean fight. You come away with a kill and no new wounds.")
			SoundManager.play_win_roar()

		CombatResolver.Outcome.WIN_INJURED:
			GameState.hunger = minf(1.0, GameState.hunger + result["hunger_gain"])
			GameState.fights_won += 1
			if is_hunt:
				GameState.kills += 1
			var injury: Dictionary = result.get("injury", {}) as Dictionary
			if not injury.is_empty():
				_apply_injury(injury)
			# Juvenile mother-bond species: winning (even injured) without calling builds the bond slightly
			if GameState.life_stage == 1 and GameState.species_id in ["trex", "allosaurus", "ankylosaurus"]:
				GameState.mother_bond = minf(2.0, GameState.mother_bond + 0.05)
			# Rival final showdown — winning (even injured) ends the rivalry
			if opponent.get("is_rival_final", false):
				var rname := GameState.rival_name.capitalize()
				GameState.rival_name = ""
				GameState.rival_encounters = 0
				GameState.bonuses_earned.append("Rival Defeated")
				flavor = "%s is gone. It cost you — the wounds are real — but it's done. You came away from it and it didn't. That's the only math that matters now." % rname
				SoundManager.play_win_roar()
				return { "type": "result", "next_context": "", "flavor": flavor, "choices": [] }
			# A costly fight that hurt you — this creature could become a recurring nemesis
			if not is_hunt and randf() < 0.30:
				var _tree: String = SpeciesDB.get_species(GameState.species_id).get("tree", "predator") as String
				GameState.assign_rival(_tree)
			flavor = flavors.get("win_inj", "You take the kill but it cost you something.")
			SoundManager.play_win_roar()

		CombatResolver.Outcome.LOSE:
			var is_bad: bool = result.get("is_bad_loss", false) as bool

			if is_bad:
				# ── BAD LOSS — roll escape chance ────────────────────────────
				# Escape odds fall with each bad loss this run.
				var bad_count: int    = GameState.fights_lost_bad
				var chance: float     = clampf(0.65 - bad_count * 0.15, 0.10, 0.65)
				GameState.fights_lost_bad += 1
				GameState.fights_lost     += 1

				if randf() < chance:
					# Survived — severe injury guaranteed, partial health cost
					var severe: Dictionary = CombatResolver.roll_injury("severe") as Dictionary
					if not severe.is_empty():
						_apply_injury(severe)
					GameState.health = maxf(0.05, GameState.health - randf_range(0.15, 0.30))
					flavor = flavors.get("escape", "Everything went wrong. You barely made it out alive.")
				else:
					# Did not survive
					GameState.health       = 0.0
					GameState.death_cause  = "combat"
					GameState.death_detail = opponent.get("name", "a creature") as String
					SoundManager.play("game_over")
					flavor = flavors.get("escape", "You didn't make it out. The injuries were too much.")
			else:
				# ── NORMAL LOSS ───────────────────────────────────────────────
				var raw_damage: float = result["damage"] as float
				GameState.health      = maxf(0.0, GameState.health - raw_damage)
				GameState.fights_lost += 1
				var injury: Dictionary = result.get("injury", {}) as Dictionary
				if not injury.is_empty():
					_apply_injury(injury)
				SoundManager.play("combat_hit")
				SoundManager.check_low_health()
				flavor = flavors.get("lose", "You come off worse. You pull back before it finishes the job.")
				if GameState.health <= 0.0:
					GameState.death_cause  = "combat"
					GameState.death_detail = opponent.get("name", "a creature") as String
					SoundManager.play("game_over")

		CombatResolver.Outcome.FLEE:
			GameState.fights_fled += 1
			flavor = "You break off before it goes further."

	return { "type": "result", "next_context": "", "flavor": flavor, "choices": [] }


func _apply_injury(injury: Dictionary) -> void:
	GameState.apply_injury(injury)


func _tick_injuries() -> void:
	GameState.tick_injuries_on_rest()


func _no_event() -> Dictionary:
	return { "type": "none", "next_context": "", "flavor": "", "choices": [] }


func _result(flavor: String) -> Dictionary:
	return { "type": "result", "next_context": "", "flavor": flavor, "choices": [] }


# ── WORLD EVENT RESOLVERS ─────────────────────────────────────────────────────

func _resolve_hatchling(choice: String) -> Dictionary:
	match choice:
		"raid_nests":
			if randf() < 0.65:
				GameState.hunger = minf(1.0, GameState.hunger + 0.25)
				GameState.kills += 1
				return _result("The nest is unguarded. You eat quickly before a parent can return.")
			else:
				GameState.health = maxf(0.0, GameState.health - 0.15)
				return _result("A parent returns before you can finish. You escape its attack, carrying a wound from the nest.")
		"observe":
			if randf() < 0.40:
				return _build_threat_event()
		"leave": pass
	return _no_event()


func _resolve_flooded_rivers(choice: String) -> Dictionary:
	match choice:
		"fish_flood":
			GameState.hunger = minf(1.0, GameState.hunger + 0.35)
			return _result("The swollen river has swept fish into the shallows. You catch enough to make a good meal.")
		"cross_river":
			if randf() < 0.60:
				GameState.miles_traveled += 15.0
				return _result("You reach the far bank safely, with unfamiliar trails stretching ahead.")
			else:
				GameState.health = maxf(0.0, GameState.health - 0.20)
				return _result("The current catches you midway across. You struggle onto the far bank, bruised by the crossing.")
	return _no_event()


func _resolve_new_pack(choice: String) -> Dictionary:
	match choice:
		"assert_pack":
			var attacker = { "fight_power": GameState.strength, "size": GameState.size, "opponent_size": GameState.size, "group_size": 0 }
			var defender = { "fight_power": randf_range(0.3, 0.6), "size": GameState.size, "hunger_value": 0.0 }
			var result = CombatResolver.resolve(attacker, defender)
			if result["outcome"] in [CombatResolver.Outcome.WIN, CombatResolver.Outcome.WIN_INJURED]:
				GameState.pack_bond = 0.6
				PackManager.join_group(0.60)
				return _result("The young hunters fall in behind you, accepting your lead. You have a pack.")
			else:
				GameState.health = maxf(0.0, GameState.health - result["damage"])
				return _result("The hunters reject your challenge and drive you back. You retreat before the fight grows worse.")
		"observe":
			return _result("You watch the hunters move through the brush. They notice you but keep their distance, neither welcoming nor driving you away.")
	return _no_event()


func _resolve_migration(choice: String) -> Dictionary:
	match choice:
		"follow_migration":
			GameState.kills += randi_range(1, 3)
			GameState.hunger = minf(1.0, GameState.hunger + 0.30)
			GameState.miles_traveled += 40.0
			return _result("You follow the migrating herds and catch prey along the way. The long trail rewards you with a full belly.")
		"join_migration":
			if GameState.pack_bond == 0.0:
				PackManager.join_group(randf_range(0.35, 0.65))
			GameState.miles_traveled += 60.0
			return _result("You fall into step with the herd. Surrounded by its moving ranks, you follow the trail into new ground.")
	return _no_event()


func _resolve_medicine_plant(choice: String, is_poison: bool) -> Dictionary:
	match choice:
		"eat_medicine", "eat_poison_bloom", "eat_carefully":
			if is_poison:
				if randf() < 0.55:
					GameState.speed = maxf(0.0, GameState.speed - 0.12)
					GameState.apply_temp_buff("speed", -0.12, 3, "poison_plant")
					return _result("The plants leave your legs unsteady. You will move more slowly until the poison wears off.")
				else:
					GameState.hunger = minf(1.0, GameState.hunger + 0.15)
					return _result("You eat the unfamiliar plants without falling ill. Whether by caution or luck, you have found a safe meal.")
			else:
				GameState.health = minf(1.0, GameState.health + 0.20)
				return _result("After eating the plant, you begin to feel steadier. Some of your strength returns.")
	return _no_event()


func _resolve_drought(choice: String) -> Dictionary:
	match choice:
		"waterhole_cautious":
			GameState.hunger = minf(1.0, GameState.hunger + 0.10)
			GameState.apply_temp_buff("speed", -0.06, 2, "drought_stress")
			if randf() < 0.35:
				return _build_threat_event()
			return _result("You find space to drink without drawing an attack. Picking your way through the crowd is tiring, and you move slowly afterward.")
		"waterhole_fast":
			GameState.hunger = minf(1.0, GameState.hunger + 0.10)
			GameState.strength = minf(1.0, GameState.strength + 0.01)
			return _result("You dart in for a drink and leave before the watching animals can react.")
		"waterhole_wait":
			GameState.hunger = minf(1.0, GameState.hunger + 0.10)
			GameState.apply_temp_buff("strength", -0.05, 2, "drought_fatigue")
			return _result("After dark, the crowd thins enough for you to drink undisturbed. The long wait leaves you tired.")
	return _no_event()


func _resolve_fruit(choice: String) -> Dictionary:
	match choice:
		"eat_fruit":
			if randf() < 0.25:
				GameState.speed = maxf(0.0, GameState.speed - 0.08)
				GameState.apply_temp_buff("speed", -0.08, 2, "bad_fruit")
				return _result("Some of the fruit has spoiled. Your stomach turns, and you move sluggishly afterward.")
			GameState.hunger = minf(1.0, GameState.hunger + 0.40)
			return _result("The fallen fruit is rich and plentiful. You eat more than you expected to find.")
		"eat_fruit_careful":
			GameState.hunger = minf(1.0, GameState.hunger + 0.25)
			return _result("You choose the fruit carefully and leave the spoiled pieces behind. The meal fills your belly.")
	return _no_event()


func _resolve_waterhole_truce(choice: String) -> Dictionary:
	match choice:
		"truce_drink":
			GameState.hunger = minf(1.0, GameState.hunger + 0.10)
			return _result("You drink while the surrounding animals hold their ground. For now, the truce lasts.")
		"truce_break":
			GameState.kills += 1
			GameState.hunger = minf(1.0, GameState.hunger + 0.45)
			GameState.health = maxf(0.0, GameState.health - 0.15)
			GameState.fights_won += 1
			return _result("You strike through the uneasy truce and bring down prey. The struggle leaves you wounded, with hungry eyes watching your meal.")
		"truce_wait":
			if randf() < 0.50:
				GameState.kills += 1
				GameState.hunger = minf(1.0, GameState.hunger + 0.30)
				return _result("You wait until a weakened animal lags behind the others. A quick attack gives you a meal.")
	return _no_event()


func _resolve_wildfire(choice: String) -> Dictionary:
	match choice:
		"wildfire_flee":
			GameState.miles_traveled += 20.0
			GameState.apply_temp_buff("speed", -0.10, 2, "wildfire_exhaustion")
			return _result("You run for hours before the smoke begins to thin. The fire is behind you, but your exhausted legs will need time to recover.")
		"wildfire_water":
			GameState.hunger = minf(1.0, GameState.hunger + 0.10)
			return _result("You cross the river and drink on the far bank. The water holds back the fire while you wait for it to burn out.")
		"wildfire_hold":
			if randf() < 0.40:
				GameState.health = maxf(0.0, GameState.health - 0.30)
				GameState.apply_temp_buff("speed", -0.12, 3, "wildfire_burns")
				return _result("You wait too long, and the flames reach your shelter. You escape with burns that make every step painful.")
			GameState.apply_temp_buff("speed", -0.06, 2, "wildfire_smoke")
			return _result("The flames pass around your shelter. You stay safe from the fire, but the smoke leaves you coughing and slow.")
	return _no_event()


func _resolve_insects(choice: String) -> Dictionary:
	match choice:
		"eat_insects":
			var species = SpeciesDB.get_species(GameState.species_id)
			if GameState.size <= 2:
				GameState.hunger = minf(1.0, GameState.hunger + 0.20)
				return _result("You snap at the insects until your belly fills. For an animal your size, the swarm makes a good meal.")
			return _result("The tiny insects offer too little food for an animal your size. You pass through the swarm and move on.")
	return _no_event()


func _resolve_mineral(choice: String) -> Dictionary:
	match choice:
		"salt_fight", "mineral_fight":
			var attacker = { "fight_power": GameState.strength, "size": GameState.size, "opponent_size": GameState.size, "group_size": PackManager.get_virtual_group_size() }
			var defender = { "fight_power": randf_range(0.25, 0.50), "size": GameState.size, "hunger_value": 0.0 }
			var result = CombatResolver.resolve(attacker, defender)
			if result["outcome"] in [CombatResolver.Outcome.WIN, CombatResolver.Outcome.WIN_INJURED]:
				GameState.defense = minf(1.0, GameState.defense + 0.04)
				return _result("You pushed to the front. The minerals strengthened your armor.")
			GameState.health = maxf(0.0, GameState.health - result["damage"])
			return _result("They didn't give ground easily. You got some but paid for it.")
		"salt_wait", "mineral_wait":
			GameState.defense = minf(1.0, GameState.defense + 0.02)
			return _result("You wait until the others leave space at the mineral deposit. There is less left to take, but you avoid a fight.")
	return _no_event()


func _resolve_mushrooms(choice: String) -> Dictionary:
	match choice:
		"eat_mushrooms_free":
			var roll = randf()
			if roll < 0.30:
				GameState.apply_temp_buff("speed", -0.10, 2, "bad_mushroom")
				return _result("The mushrooms leave you dazed. You struggle to react as quickly as usual.")
			elif roll < 0.65:
				GameState.hunger = minf(1.0, GameState.hunger + 0.25)
				return _result("You find a cluster of edible mushrooms and eat your fill.")
			else:
				GameState.health = minf(1.0, GameState.health + 0.15)
				GameState.hunger = minf(1.0, GameState.hunger + 0.15)
				return _result("The mushrooms make a nourishing meal. Your belly fills, and some of your strength returns.")
		"eat_mushrooms_careful":
			GameState.hunger = minf(1.0, GameState.hunger + 0.15)
			return _result("You inspect the mushrooms carefully and eat only the ones you recognize. The small meal is safe.")
	return _no_event()


func _resolve_rut(choice: String) -> Dictionary:
	match choice:
		"rut_challenge":
			var attacker = { "fight_power": GameState.strength, "size": GameState.size, "opponent_size": GameState.size + (randi() % 2), "group_size": 0 }
			var defender = { "fight_power": randf_range(0.35, 0.65), "size": GameState.size + (randi() % 2), "hunger_value": 0.0 }
			var result = CombatResolver.resolve(attacker, defender)
			if result["outcome"] in [CombatResolver.Outcome.WIN, CombatResolver.Outcome.WIN_INJURED]:
				GameState.strength = minf(1.0, GameState.strength + 0.03)
				if result.get("injury", {}).size() > 0:
					_apply_injury(result["injury"])
				return _result("You won the clash. Your standing improved.")
			GameState.health = maxf(0.0, GameState.health - result["damage"])
			GameState.fights_lost += 1
			return _result("The rival forces you back. You retreat with fresh wounds, giving ground after the failed challenge.")
		"rut_display":
			if randf() < 0.55:
				GameState.type_stat = minf(1.0, GameState.type_stat + 0.03)
				return _result("Your display draws an interested response. You hold your posture a little longer as the others watch.")
	return _no_event()


func _resolve_fattening(choice: String) -> Dictionary:
	match choice:
		"fatten_aggressive":
			GameState.hunger = minf(1.0, GameState.hunger + 0.35)
			if randf() < 0.25:
				return _build_threat_event()
			return _result("You feed until your belly is full, building reserves for the coming cold.")
		"fatten_steady":
			GameState.hunger = minf(1.0, GameState.hunger + 0.22)
			return _result("You feed steadily without attracting trouble. The meal leaves you better prepared for the cold.")
	return _no_event()


func _resolve_sick_herd(choice: String) -> Dictionary:
	match choice:
		"hunt_sick", "target_weak":
			if randf() < 0.30:
				GameState.apply_temp_buff("health", -0.08, 3, "diseased_meat")
				GameState.hunger = minf(1.0, GameState.hunger + 0.35)
				GameState.kills += 1
				return _result("The sick animal is easy to catch, but its meat leaves you unwell. The meal will take time to recover from.")
			GameState.kills += 1
			GameState.hunger = minf(1.0, GameState.hunger + 0.45)
			return _result("The weakest animal cannot run far. You catch it quickly and find enough good meat to fill your belly.")
		"observe":
			return _result("You stay upwind and watch the herd. Gradually, its movements become easier to predict.")
	return _no_event()


func _resolve_storm_event(choice: String) -> Dictionary:
	match choice:
		"blizzard_shelter", "superstorm_shelter":
			GameState.health = minf(1.0, GameState.health + 0.10)
			return _result("You find cover before the storm reaches its worst. Safe enough to rest, you emerge feeling stronger.")
		"blizzard_push", "superstorm_run":
			if randf() < 0.45:
				GameState.health = maxf(0.0, GameState.health - 0.20)
				GameState.apply_temp_buff("speed", -0.15, 3, "storm_exposure")
				return _result("The storm catches you on the trail. You struggle onward, but the exposure leaves you hurt and stiff with cold.")
			GameState.miles_traveled += 25.0
			GameState.apply_temp_buff("speed", -0.08, 2, "storm_exertion")
			return _result("You push ahead of the worst weather and reach quieter ground. The hard journey leaves your legs heavy with exhaustion.")
		"blizzard_dig":
			GameState.health = minf(1.0, GameState.health + 0.05)
			GameState.apply_temp_buff("strength", -0.06, 2, "storm_cold")
			return _result("The hollow holds against the wind, giving you a little rest. Cold still seeps through, leaving you stiff.")
	return _no_event()


func _resolve_frozen_river(choice: String) -> Dictionary:
	match choice:
		"cross_ice":
			var species = SpeciesDB.get_species(GameState.species_id)
			var size_risk = GameState.size >= 6
			if size_risk and randf() < 0.50:
				GameState.health = maxf(0.0, GameState.health - 0.30)
				return _result("The ice breaks beneath your weight. You claw your way to the far bank, injured and chilled by the water.")
			GameState.miles_traveled += 20.0
			return _result("The ice holds beneath your steps. You reach the far bank safely and continue onto new ground.")
		"ice_fish":
			GameState.hunger = minf(1.0, GameState.hunger + 0.30)
			return _result("The cold leaves the fish sluggish beneath the ice. You catch them with little effort and eat well.")
	return _no_event()


func _resolve_frozen_carcass(choice: String) -> Dictionary:
	match choice:
		"frozen_feed_fast":
			GameState.hunger = minf(1.0, GameState.hunger + 0.45)
			if randf() < 0.40:
				return _build_threat_event()
			return _result("You eat quickly from the frozen carcass. No other hunter arrives before you finish.")
		"frozen_feed_cautious":
			if randf() < 0.35:
				return _build_threat_event()
			GameState.hunger = minf(1.0, GameState.hunger + 0.35)
			return _result("You check the surrounding ground before feeding. With no rival nearby, you enjoy an undisturbed meal.")
	return _no_event()


func _resolve_winter_shelter(choice: String) -> Dictionary:
	match choice:
		"shelter_fight":
			var defender = { "fight_power": randf_range(0.20, 0.55), "size": GameState.size, "hunger_value": 0.0, "opponent_size": GameState.size }
			var attacker = { "fight_power": GameState.strength, "size": GameState.size, "opponent_size": GameState.size, "group_size": PackManager.get_virtual_group_size() }
			var result = CombatResolver.resolve(attacker, defender)
			if result["outcome"] in [CombatResolver.Outcome.WIN, CombatResolver.Outcome.WIN_INJURED]:
				GameState.health = minf(1.0, GameState.health + 0.15)
				return _result("You took the shelter. Warm rest. Worth it.")
			GameState.health = maxf(0.0, GameState.health - result["damage"])
			return _result("It held its ground. You rest outside.")
		"shelter_scout":
			if randf() < 0.55:
				GameState.health = minf(1.0, GameState.health + 0.15)
				return _result("Empty. You moved in. Good rest.")
			return _build_threat_event()
	return _no_event()


func _load_pack_data() -> Dictionary:
	var path := "res://scripts/dinos/%s/dino_pack.gd" % GameState.species_id
	if ResourceLoader.exists(path):
		var script = load(path)
		var node := Node.new()
		node.set_script(script)
		var data: Dictionary = node.get_pack_data() as Dictionary
		node.free()
		return data
	return {}


func _resolve_pack_fracture(choice: String) -> Dictionary:
	var species  := SpeciesDB.get_species(GameState.species_id)
	var is_herd  := (species.get("tree", "") as String) == "herbivore"
	var data     := _load_pack_data()
	match choice:
		"fracture_hold":
			GameState.hunger = maxf(0.0, GameState.hunger - 0.10)
			var success_chance := clampf(0.55 + GameState.luck_mod() * 1.0, 0.20, 0.80)
			if randf() < success_chance:
				PackManager.modify_bond(0.10)
				var pool: Array = data.get("push_success", []) as Array
				if pool.is_empty():
					return _result("You pushed to hold them together and it worked. The pack steadies — for now." if not is_herd \
						else "You moved with the restless ones and drew them back in. The herd holds — for now.")
				return _result(pool[randi() % pool.size()])
			else:
				var pool: Array = data.get("push_failure", []) as Array
				var disband_flavor: String
				if pool.is_empty():
					disband_flavor = "You tried, but they were already gone. The pack scattered before you could bring them back." if not is_herd \
						else "You tried, but the herd had already made its choice. You are on your own."
				else:
					disband_flavor = pool[randi() % pool.size()]
				PackManager.trigger_disband(disband_flavor)
				return _result("")
		"fracture_release":
			var pool: Array = data.get("release", []) as Array
			var disband_flavor: String
			if pool.is_empty():
				disband_flavor = "You let the pack go. Better to part now than push it to something worse." if not is_herd \
					else "You let the herd go. Better to part now than push it to something worse."
			else:
				disband_flavor = pool[randi() % pool.size()]
			PackManager.trigger_disband(disband_flavor)
			return _result("")
	return _no_event()


func _resolve_pack_hunger(choice: String) -> Dictionary:
	if GameState.pack_bond <= 0.0:
		return _result("You are traveling alone now. There is no group here to share food with.")
	match choice:
		"share_food":
			GameState.hunger = maxf(0.0, GameState.hunger - 0.12)
			COMPANIONS.group_response(0.4, "You shared food when the group was hungry.", "share")
			GameState.pack_bond = minf(1.0, GameState.pack_bond + 0.12)
			return _result("You gave some of yours. The pack steadied.")
		"keep_food":
			COMPANIONS.group_response(-0.4, "You kept your food while the group went hungry.", "keep")
			GameState.pack_bond = maxf(0.0, GameState.pack_bond - 0.20)
			if GameState.pack_bond <= 0.0:
				return _result("You kept your food. The last companions leave, and you are traveling alone.")
			if GameState.pack_bond <= 0.20:
				return _result("You kept it. The look in their eyes has changed. The pack may not hold.")
			return _result("You kept it. There was grumbling. The pack held — barely.")
	return _no_event()


func _resolve_scavenger_war(choice: String) -> Dictionary:
	match choice:
		"scav_dominate":
			var attacker = { "fight_power": GameState.strength, "size": GameState.size, "opponent_size": GameState.size + 1, "group_size": PackManager.get_virtual_group_size() }
			var defender = { "fight_power": randf_range(0.30, 0.60), "size": GameState.size + 1, "hunger_value": 0.35 }
			var result = CombatResolver.resolve(attacker, defender)
			return _apply_combat_result(result, defender, false)
		"scav_steal":
			if randf() < 0.60:
				GameState.hunger = minf(1.0, GameState.hunger + 0.20)
				return _result("Quick enough. In and out before they reacted.")
			GameState.health = maxf(0.0, GameState.health - 0.12)
			return _result("They noticed. You got some but took a hit leaving.")
	return _no_event()


func _resolve_herd_huddle(choice: String) -> Dictionary:
	match choice:
		"huddle_center":
			var attacker = { "fight_power": GameState.strength, "size": GameState.size, "opponent_size": GameState.size, "group_size": PackManager.get_virtual_group_size() }
			var defender = { "fight_power": randf_range(0.25, 0.45), "size": GameState.size, "hunger_value": 0.0 }
			var result = CombatResolver.resolve(attacker, defender)
			if result["outcome"] in [CombatResolver.Outcome.WIN, CombatResolver.Outcome.WIN_INJURED]:
				GameState.health = minf(1.0, GameState.health + 0.20)
				return _result("You pushed in. The warmth at the center is real.")
			return _result("Others held their ground. You rested at the edge.")
		"huddle_edge":
			GameState.health = minf(1.0, GameState.health + 0.10)
			return _result("Cold but safer. You rested at the edge of the group.")
	return _no_event()


func _resolve_wounded_wanderer(choice: String) -> Dictionary:
	match choice:
		"hunt_wounded":
			# 20% chance the wound is feigned or the scent called something else in — it's a trap
			if randf() < 0.20:
				GameState.health = maxf(0.0, GameState.health - 0.14)
				_apply_injury({ "name": "Ambush Wound", "stat": "defense", "amount": -0.10, "turns": 3 })
				return _result("You were almost on it when something hit you from behind. The wound was either feigned or the scent drew in something that had been waiting. You came off worse.")
			var prey = { "fight_power": 0.15, "size": GameState.size + 1, "hunger_value": 0.50, "opponent_size": GameState.size }
			var attacker = { "fight_power": GameState.strength, "size": GameState.size, "opponent_size": GameState.size + 1, "group_size": PackManager.get_virtual_group_size() }
			return _apply_combat_result(CombatResolver.resolve(attacker, prey), prey, true)
		"stalk_wounded":
			# Stalking reduces bait risk — low chance it was still a setup
			if randf() < 0.10:
				return {
					"type": "threat", "next_context": "threat",
					"flavor": "You circled it carefully. It was watching you circle. Something larger was watching you both.",
					"choices": [
						{ "label": "Stand ground", "icon": "attack", "sublabel": "Face it directly",       "action": "fight" },
						{ "label": "Back away",    "icon": "stalk",  "sublabel": "Retreat without running","action": "watch" },
						{ "label": "Flee",         "icon": "flee",   "sublabel": "Get out fast",           "action": "flee" },
					]
				}
			_pending_prey = { "fight_power": 0.10, "size": GameState.size + 1, "hunger_value": 0.50, "opponent_size": GameState.size }
			return {
				"type": "prey_found", "next_context": "prey_found",
				"flavor": "You circled it. It's more hurt than it looked. No one else nearby.",
				"choices": [
					{ "label": "Attack now", "icon": "attack", "sublabel": "Clean opportunity",  "action": "attack" },
					{ "label": "Leave it",   "icon": "flee",   "sublabel": "Something feels off","action": "leave" },
				]
			}
	return _no_event()


func _resolve_fresh_tracks(choice: String) -> Dictionary:
	match choice:
		"follow_tracks":
			if randf() < 0.55:
				return _build_prey_encounter(false)
			elif randf() < 0.40:
				return _build_threat_event()
			return _result("The trail went cold. Whatever made it is long gone.")
		"read_tracks":
			GameState.type_stat = minf(1.0, GameState.type_stat + 0.02)
			# Rare: while you were reading its tracks, it was reading yours
			if randf() < 0.15:
				return _build_threat_event()
			return _result("You read the ground carefully. You learned something about how things move here.")
		"leave":
			# 15% chance whatever made the tracks was close enough to follow you out
			if randf() < 0.15:
				return _build_threat_event()
			return _no_event()
	return _no_event()


func _resolve_pack_invitation(choice: String) -> Dictionary:
	match choice:
		"pack_approach":
			if randf() < 0.65:
				PackManager.join_group(maxf(GameState.pack_bond, 0.55))
				return _result("They accepted the approach. You have allies now.")
			return _result("They moved off. Not ready to share territory.")
		"pack_display":
			if randf() < 0.50:
				PackManager.join_group(maxf(GameState.pack_bond, 0.65))
				return _result("Your strength read. They fell in.")
			return _result("They didn't react well to the display. They left.")
	return _no_event()


func _resolve_rival_claim(choice: String) -> Dictionary:
	match choice:
		"contest_territory":
			if randf() < 0.55:
				GameState.territory_bonus_turns = 4
				# Sometimes a dominant mark also intimidates nearby threats for a turn
				if randf() < 0.30:
					GameState.apply_temp_buff("defense", 0.08, 2, "dominant_mark")
					return _result("Your marks are stronger now. The territory is yours. Whatever else was in this area read the change and pulled back.")
				return _result("Your marks are stronger now. The territory is yours.")
			return _build_threat_event()
		"observe":
			# 18% chance watching from cover still gets you spotted
			if randf() < 0.18:
				return _build_threat_event()
			# Sometimes watching reveals useful information
			if randf() < 0.25:
				GameState.apply_temp_buff("type_stat", 0.06, 3, "rival_studied")
				return _result("You watched long enough to understand how it moves. Old marks, specific patterns. Useful. It never saw you.")
			return _result("You watched from distance. Big. Old marks. Not a fight you want today.")
		"leave":
			# Backing off completely sometimes means the rival expands into your range
			if randf() < 0.22:
				GameState.apply_temp_buff("hunger", -0.08, 3, "territory_lost")
				return _result("You found new ground to hunt. But what you left behind is already being marked over. Your usual range will feel tighter.")
			return _result("You moved off. Not every territory is worth the fight.")
	return _no_event()


func _resolve_night_hunt(choice: String) -> Dictionary:
	match choice:
		"night_hunt_go":
			GameState.type_stat = minf(1.0, GameState.type_stat + 0.05)
			GameState.night_hunts += 1
			return _build_prey_encounter(true)
	return _no_event()


func _resolve_herd_defense(choice: String) -> Dictionary:
	match choice:
		"test_herd":
			if GameState.pack_bond >= 0.40:
				return _build_prey_encounter(false)
			else:
				GameState.health = maxf(0.0, GameState.health - 0.15)
				return _result("You tested it alone. They held. You pulled back with new bruises.")
		"wait_herd":
			if randf() < 0.45:
				return _build_prey_encounter(true)
			return _result("Nothing broke from the formation. You moved on.")
	return _no_event()


func _resolve_alpha_challenge(choice: String) -> Dictionary:
	match choice:
		"alpha_reassert":
			var attacker = { "fight_power": GameState.strength, "size": GameState.size, "opponent_size": GameState.size, "group_size": 0 }
			var defender = { "fight_power": randf_range(0.35, 0.60), "size": GameState.size, "hunger_value": 0.0 }
			var result = CombatResolver.resolve(attacker, defender)
			if result["outcome"] in [CombatResolver.Outcome.WIN, CombatResolver.Outcome.WIN_INJURED]:
				GameState.pack_bond = minf(1.0, GameState.pack_bond + 0.15)
				return _result("The question is answered. The pack is yours.")
			PackManager.modify_bond(-0.30)
			return _result("You lost the challenge. One left. The others are watching.")
		"alpha_patience":
			GameState.pack_bond = minf(1.0, GameState.pack_bond + 0.08)
			return _result("You didn't escalate. The tension passed. They're still here.")
	return _no_event()


func _resolve_defensive_stand(choice: String) -> Dictionary:
	match choice:
		"charge_predator":
			var attacker = { "fight_power": GameState.strength + GameState.defense * 0.5, "size": GameState.size, "opponent_size": GameState.size + 1, "group_size": PackManager.get_virtual_group_size() }
			var defender = { "fight_power": randf_range(0.35, 0.65), "size": GameState.size + 1, "hunger_value": 0.0 }
			var result = CombatResolver.resolve(attacker, defender)
			if result["outcome"] in [CombatResolver.Outcome.WIN, CombatResolver.Outcome.WIN_INJURED]:
				GameState.fights_won += 1
				return _result("Your charge landed. It backed off.")
			GameState.health = maxf(0.0, GameState.health - result["damage"])
			GameState.fights_lost += 1
			return _result("It held through your charge. You broke off and ran.")
		"hold_ground":
			if randf() < 0.55:
				return _result("You held. It circled and moved on. Didn't want the fight.")
			return _build_threat_event()
		"flee":
			return _resolve_threat("flee")
	return _no_event()


func _resolve_fresh_meadow(choice: String) -> Dictionary:
	match choice:
		"graze_meadow":
			GameState.hunger = minf(1.0, GameState.hunger + 0.35)
			if randf() < 0.30:
				return _build_threat_event()
			return _result("The best food of the season. You fed well.")
		"graze_edge":
			GameState.hunger = minf(1.0, GameState.hunger + 0.18)
			return _result("Less food but you kept cover. Safe choice.")
	return _no_event()


func _resolve_herd_panic(choice: String) -> Dictionary:
	match choice:
		"stampede_join":
			GameState.miles_traveled += 15.0
			GameState.speed = minf(1.0, GameState.speed + 0.01)
			return _result("You ran with them. The cause became clear as you moved — a large predator behind the herd.")
		"stampede_hold":
			if randf() < 0.40:
				GameState.health = maxf(0.0, GameState.health - 0.15)
				return _result("The herd hit you on its way through. You stayed upright but it cost you.")
			return _result("You held. The herd parted around you. Now you can see what caused it.")
		"stampede_split":
			GameState.miles_traveled += 8.0
			return _result("You found your own path out of it. Slower but intact.")
	return _no_event()


func _resolve_nest_defense(choice: String) -> Dictionary:
	match choice:
		"defend_nest", "chase_thief":
			var attacker = { "fight_power": GameState.strength, "size": GameState.size, "opponent_size": GameState.size - 1, "group_size": 0 }
			var defender = { "fight_power": randf_range(0.15, 0.35), "size": maxi(1, GameState.size - 1), "hunger_value": 0.0 }
			var result = CombatResolver.resolve(attacker, defender)
			if result["outcome"] in [CombatResolver.Outcome.WIN, CombatResolver.Outcome.WIN_INJURED]:
				GameState.kin_created = maxi(GameState.kin_created, 1)
				return _result("You drove it off. The nest is intact.")
			GameState.health = maxf(0.0, GameState.health - result["damage"])
			return _result("It got away. Some of the nest was taken.")
		"distract_predator", "intercept_thief":
			if randf() < 0.60:
				GameState.miles_traveled += 5.0
				return _result("You led it away from the nest. Came back to find everything intact.")
			return _result("The distraction worked halfway. You lost one egg.")
	return _no_event()


func _resolve_rank_fight(choice: String) -> Dictionary:
	match choice:
		"herd_rank_fight":
			var attacker = { "fight_power": GameState.strength + GameState.defense * 0.3, "size": GameState.size, "opponent_size": GameState.size + 1, "group_size": 0 }
			var defender = { "fight_power": randf_range(0.40, 0.70), "size": GameState.size + 1, "hunger_value": 0.0 }
			var result = CombatResolver.resolve(attacker, defender)
			if result["outcome"] in [CombatResolver.Outcome.WIN, CombatResolver.Outcome.WIN_INJURED]:
				GameState.pack_bond = minf(1.0, GameState.pack_bond + 0.20)
				GameState.strength = minf(1.0, GameState.strength + 0.02)
				return _result("You won the clash. Your place in the herd is secure.")
			GameState.health = maxf(0.0, GameState.health - result["damage"])
			GameState.pack_bond = maxf(0.0, GameState.pack_bond - 0.15)
			return _result("You lost. You hold your place for now — barely.")
		"submit_rank":
			GameState.pack_bond = maxf(0.0, GameState.pack_bond - 0.05)
			return _result("You stepped back. The position cost you nothing but the rank.")
	return _no_event()


func _resolve_fish(choice: String) -> Dictionary:
	match choice:
		"fish_dive":
			if randf() < 0.70:
				GameState.hunger = minf(1.0, GameState.hunger + 0.35)
				GameState.kills += 1
				return _result("Clean dive. Good catch.")
			GameState.apply_temp_buff("type_stat", -0.08, 2, "bad_dive")
			return _result("Misjudged the angle. You came up empty and winded.")
		"fish_circle":
			GameState.hunger = minf(1.0, GameState.hunger + 0.30)
			GameState.kills += 1
			return _result("You picked your moment. The dive paid off.")
	return _no_event()


func _resolve_sky_shadow(choice: String) -> Dictionary:
	match choice:
		"sky_challenge":
			var attacker = { "fight_power": GameState.strength, "size": GameState.size, "opponent_size": GameState.size + 2, "group_size": PackManager.get_virtual_group_size() }
			var defender = { "fight_power": randf_range(0.45, 0.75), "size": GameState.size + 2, "hunger_value": 0.0 }
			var result = CombatResolver.resolve(attacker, defender)
			if result["outcome"] in [CombatResolver.Outcome.WIN, CombatResolver.Outcome.WIN_INJURED]:
				return _result("You held the sky. It went elsewhere.")
			GameState.health = maxf(0.0, GameState.health - result["damage"])
			return _result("Too big. You dropped altitude fast.")
		"sky_evade":
			GameState.type_stat = minf(1.0, GameState.type_stat + 0.01)
			return _result("You read the thermals and dropped out of its range.")
	return _no_event()


func _resolve_crosswind(choice: String) -> Dictionary:
	match choice:
		"crosswind_ride":
			if randf() < 0.60:
				GameState.type_stat = minf(1.0, GameState.type_stat + 0.03)
				GameState.miles_traveled += 20.0
				return _result("You rode it. Covered ground you couldn't have on your own.")
			GameState.apply_temp_buff("type_stat", -0.10, 2, "crosswind_injury")
			return _result("It threw you. You recovered but the wing needs rest.")
		"crosswind_land":
			return _result("You landed before it got worse. Smart call.")
	return _no_event()


func _resolve_storm_perch(choice: String) -> Dictionary:
	match choice:
		"storm_high_perch":
			GameState.health = minf(1.0, GameState.health + 0.12)
			return _result("The high ledge held. You waited the storm out above the chaos.")
		"storm_ground":
			GameState.health = minf(1.0, GameState.health + 0.08)
			return _result("Ground shelter. Safer but cramped. You came out intact.")
	return _no_event()


func _resolve_nest_rush(choice: String) -> Dictionary:
	match choice:
		"claim_nest":
			var attacker = { "fight_power": GameState.strength, "size": GameState.size, "opponent_size": GameState.size, "group_size": 0 }
			var defender = { "fight_power": randf_range(0.20, 0.45), "size": GameState.size, "hunger_value": 0.0 }
			var result = CombatResolver.resolve(attacker, defender)
			if result["outcome"] in [CombatResolver.Outcome.WIN, CombatResolver.Outcome.WIN_INJURED]:
				GameState.health = minf(1.0, GameState.health + 0.15)
				return _result("You took the best ledge. Good rest ahead.")
			return _result("It held the spot. You rested somewhere lesser.")
		"scout_nest":
			GameState.health = minf(1.0, GameState.health + 0.10)
			return _result("You found an unclaimed hollow. Not the best — but yours.")
	return _no_event()


func _resolve_pred_gathering(choice: String) -> Dictionary:
	match choice:
		"assert_territory":
			GameState.territory_bonus_turns = 5
			return _result("Your marks are heavy here now. The others will note it.")
		"observe":
			GameState.type_stat = minf(1.0, GameState.type_stat + 0.02)
			return _result("You watched who was dangerous and who wasn't. Useful.")
	return _no_event()


func _resolve_pred_silence(choice: String) -> Dictionary:
	match choice:
		"hunt_unguarded":
			return _build_prey_encounter(true)
		"observe":
			return _result("You held back. Smart. Three seasons later the apex hunters came back. You were ready.")
	return _no_event()


# ── PACK ACTION RESOLVERS ─────────────────────────────────────────────────────

func _load_find_pack_data() -> Dictionary:
	var path := "res://scripts/dinos/%s/dino_find_pack.gd" % GameState.species_id
	if ResourceLoader.exists(path):
		var script = load(path)
		var node := Node.new()
		node.set_script(script)
		var data: Dictionary = node.get_find_pack_data() as Dictionary
		node.free()
		return data
	return {}


func _resolve_find_pack() -> Dictionary:
	var species      := SpeciesDB.get_species(GameState.species_id)
	var mating_style: String = species.get("mating_style", "") as String
	var is_alpha_species := mating_style == "pack_alpha"
	var lm           := GameState.luck_mod()
	var data         := _load_find_pack_data()

	# Solo time bonus — longer alone = easier to find a group
	var solo_bonus := minf(0.30, GameState.turns_solo * 0.04)

	if is_alpha_species:
		# Outcomes: no_male / dominant_male / no_group
		var w_no_male    := maxf(0.05, 0.45 + lm * 1.0 + solo_bonus)
		var w_dominant   := maxf(0.05, 0.30 - lm * 0.5)
		var w_no_group   := maxf(0.05, 0.25 - lm * 0.5 - solo_bonus)
		var total        := w_no_male + w_dominant + w_no_group
		var roll         := randf() * total

		if roll < w_no_male:
			var pool: Array = data.get("no_male", []) as Array
			var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() \
				else "You find a group. No one blocks your path."
			return {
				"type": "choice", "next_context": "find_pack_join",
				"flavor": flavor,
				"choices": [
					{ "label": "Join the group",      "icon": "bond", "sublabel": "Start with moderate bond", "action": "join"  },
					{ "label": "Keep moving alone",   "icon": "flee", "sublabel": "Stay solo",                "action": "pass"  },
				],
			}
		elif roll < w_no_male + w_dominant:
			var pool: Array = data.get("dominant_male", []) as Array
			var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() \
				else "You find a group, but a dominant male blocks your way."
			return {
				"type": "choice", "next_context": "find_pack_challenge",
				"flavor": flavor,
				"choices": [
					{ "label": "Fight for the group", "icon": "attack", "sublabel": "Win to take them",    "action": "fight" },
					{ "label": "Leave them be",       "icon": "flee",   "sublabel": "Walk away",           "action": "pass"  },
				],
			}
		else:
			var pool: Array = data.get("no_group", []) as Array
			var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() \
				else "You searched but found no one."
			return _result(flavor)

	else:
		# Outcomes: strong / small / unstable / no_group
		var w_strong   := maxf(0.05, 0.20 + lm * 1.0 + solo_bonus * 0.5)
		var w_small    := maxf(0.05, 0.35 + lm * 0.3 + solo_bonus * 0.5)
		var w_unstable := maxf(0.05, 0.25 - lm * 0.5)
		var w_no_group := maxf(0.05, 0.20 - lm * 0.8 - solo_bonus)
		var total      := w_strong + w_small + w_unstable + w_no_group
		var roll       := randf() * total

		var outcome: String
		var starting_bond: float
		if roll < w_strong:
			outcome = "strong";  starting_bond = 0.70
		elif roll < w_strong + w_small:
			outcome = "small";   starting_bond = 0.50
		elif roll < w_strong + w_small + w_unstable:
			outcome = "unstable"; starting_bond = 0.25
		else:
			outcome = "no_group"; starting_bond = 0.0

		var pool: Array = data.get(outcome, []) as Array
		var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() \
			else ("You searched but found nothing." if outcome == "no_group" else "You find a group and join them.")

		if outcome != "no_group":
			PackManager.join_group(starting_bond)

		return _result(flavor)


func _resolve_find_pack_join(choice: String) -> Dictionary:
	match choice:
		"join":
			PackManager.join_group(0.55)
			return _result("You fall in with the group. The bond is cautious but real.")
		"pass":
			return _result("You keep moving. The group disappears behind you.")
	return _no_event()


func _resolve_find_pack_challenge(choice: String) -> Dictionary:
	match choice:
		"fight":
			var attacker = {
				"fight_power":   GameState.strength,
				"size":          GameState.size,
				"opponent_size": GameState.size,
				"group_size":    0,
			}
			var defender = {
				"fight_power":   randf_range(0.40, 0.65),
				"size":          GameState.size,
				"opponent_size": GameState.size,
				"hunger_value":  0.0,
			}
			var result = CombatResolver.resolve(attacker, defender)
			if result["outcome"] in [CombatResolver.Outcome.WIN, CombatResolver.Outcome.WIN_INJURED]:
				if result.get("injury", {}).size() > 0:
					_apply_injury(result["injury"])
				PackManager.join_group(0.60)
				return _result("You took him down. The group fell silent, then fell in behind you.")
			else:
				GameState.health = maxf(0.0, GameState.health - result["damage"])
				if result.get("injury", {}).size() > 0:
					_apply_injury(result["injury"])
				return _result("He drove you back. You left without the group.")
		"pass":
			return _result("You turn and leave. The group was not worth the fight.")
	return _no_event()


func _resolve_alpha_challenge_mandatory(choice: String) -> Dictionary:
	match choice:
		"alpha_fight":
			var result = PackManager.resolve_alpha_fight()
			return {
				"type": "result", "next_context": "", "choices": [],
				"flavor": result["flavor"]
			}
		"alpha_leave":
			var result = PackManager.resolve_alpha_leave()
			return {
				"type": "result", "next_context": "", "choices": [],
				"flavor": result["flavor"]
			}
	return _no_event()


func _resolve_alpha_challenge_coalition(choice: String) -> Dictionary:
	match choice:
		"alpha_fight":
			var result = PackManager.resolve_alpha_fight()
			return {
				"type": "result", "next_context": "", "choices": [],
				"flavor": result["flavor"]
			}
		"alpha_stay":
			var result = PackManager.resolve_alpha_stay()
			return {
				"type": "result", "next_context": "", "choices": [],
				"flavor": result["flavor"]
			}
		"alpha_leave":
			var result = PackManager.resolve_alpha_leave()
			return {
				"type": "result", "next_context": "", "choices": [],
				"flavor": result["flavor"]
			}
	return _no_event()


func _resolve_hatchling_event(choice: String) -> Dictionary:
	const DELTAS := {
		"positive":    0.15,
		"neutral":     0.0,
		"negative":   -0.15,
		"feed_heavy":  0.20,
		"feed_steady": 0.10,
		"feed_light":  0.0,
		"feed_skip":  -0.15,
	}
	const HUNGER_COSTS := {
		"feed_heavy":  0.12,
		"feed_steady": 0.07,
		"feed_light":  0.04,
	}
	GameState.nesting_score += DELTAS.get(choice, 0.0)
	GameState.hunger = maxf(0.0, GameState.hunger - HUNGER_COSTS.get(choice, 0.0))
	# Scale the "good season" threshold to match the species' nesting cycle length.
	# A Comps parent (2 seasons) qualifies at a lower absolute score than a T-Rex (5 seasons),
	# but the relative effort required is the same.
	var nesting_seasons: int = SpeciesDB.get_species(GameState.species_id).get("nesting_seasons", 5)
	var season_threshold := 0.25 * (nesting_seasons / 5.0)
	if GameState.nesting_score >= season_threshold:
		GameState.good_parent_seasons += 1
	var outcomes: Dictionary = GameState.active_hatchling_outcomes
	GameState.active_hatchling_outcomes = {}
	var pool: Array = outcomes.get(choice, []) as Array
	var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() else \
		"The moment passed. The young moved on to the next thing."
	return _result(flavor)


func _resolve_juvenile_parent_event(choice: String) -> Dictionary:
	const DELTAS := { "follow": 0.15, "partial": 0.05, "ignore": -0.10 }
	GameState.juvenile_lesson_score += DELTAS.get(choice, 0.0)
	var outcomes: Dictionary = GameState.active_juvenile_outcomes
	GameState.active_juvenile_outcomes = {}
	var pool: Array = outcomes.get(choice, []) as Array
	var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() else \
		"The moment passed without a lesson."
	return _result(flavor)


func _resolve_mother_bond_event(choice: String) -> Dictionary:
	# Roll a tier based on base percentages modified by daily luck
	# Base thresholds: Crit 10% | Success 40% | Mixed 35% | Fail 15%
	var luck := GameState.daily_luck  # roughly -0.75 to +0.75
	var roll := randf()
	var crit_limit    := clampf(0.10 + luck * 0.08, 0.02, 0.25)
	var success_limit := clampf(0.50 + luck * 0.12, 0.20, 0.70)
	var mixed_limit   := clampf(0.85 + luck * 0.08, 0.60, 0.95)
	var tier: String
	if   roll < crit_limit:    tier = "crit"
	elif roll < success_limit: tier = "success"
	elif roll < mixed_limit:   tier = "mixed"
	else:                      tier = "fail"

	const BOND_DELTAS := { "crit": 0.25, "success": 0.15, "mixed": 0.05, "fail": -0.10 }
	GameState.mother_bond += BOND_DELTAS.get(tier, 0.0)

	var outcomes: Dictionary = GameState.active_mother_bond_outcomes
	GameState.active_mother_bond_outcomes = {}
	var choice_outcomes: Dictionary = outcomes.get(choice, {}) as Dictionary
	var pool: Array = choice_outcomes.get(tier, []) as Array
	var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() else \
		"The moment passed. The lesson fades into the season."
	return _result(flavor)


# ── DEINONYCHUS MATING SYSTEM ─────────────────────────────────────────────────

func _load_dein_mate_event(event_type: String) -> Dictionary:
	var path := "res://scripts/dinos/deinonychus/dino_mate.gd"
	if not ResourceLoader.exists(path):
		return {}
	var script = load(path)
	var node := Node.new()
	node.set_script(script)
	var data: Dictionary
	match event_type:
		"sub":    data = node.get_dein_sub_event()
		"rival":  data = node.get_dein_rival_event()
		"alpha":  data = node.get_dein_alpha_breeding_event()
		"female": data = node.get_dein_female_breeding_event()
		_:        data = {}
	node.free()
	return data


func _swap_dein_fight_injury() -> void:
	# Replace the generic Fight Wound (health) applied by PackManager
	# with a random Deinonychus-specific minor injury on a different stat.
	for i in range(GameState.injuries.size() - 1, -1, -1):
		var inj: Dictionary = GameState.injuries[i] as Dictionary
		if inj.get("name", "") == "Fight Wound" and inj.get("stat", "") == "health":
			GameState.health = clampf(GameState.health - inj["amount"], 0.0, 1.0)
			GameState.injuries.remove_at(i)
			GameState.total_injuries_sustained = maxi(GameState.total_injuries_sustained - 1, 0)
			GameState.lifespan_reduction       = maxi(GameState.lifespan_reduction - 1, 0)
			break
	const DEIN_INJURIES: Array = [
		{ "name": "Sickle Claw Slash", "stat": "speed",    "amount": -0.08, "turns": 2 },
		{ "name": "Pack Rake",         "stat": "strength", "amount": -0.08, "turns": 2 },
		{ "name": "Feather Bite",      "stat": "defense",  "amount": -0.08, "turns": 2 },
	]
	GameState.apply_injury(DEIN_INJURIES[randi() % DEIN_INJURIES.size()])


func _roll_dein_breeding_tier() -> String:
	# strong_success 10% | success 40% | mixed 35% | fail 15% (luck-modified)
	var luck: float = GameState.daily_luck
	var roll: float = randf()
	var ss_limit: float = clampf(0.10 + luck * 0.08, 0.02, 0.25)
	var s_limit:  float = clampf(0.50 + luck * 0.12, 0.20, 0.70)
	var m_limit:  float = clampf(0.85 + luck * 0.08, 0.60, 0.95)
	if   roll < ss_limit: return "strong_success"
	elif roll < s_limit:  return "success"
	elif roll < m_limit:  return "mixed"
	else:                 return "fail"


func _resolve_dein_sub_mating(choice: String) -> Dictionary:
	var event: Dictionary = _load_dein_mate_event("sub")
	var outcomes: Dictionary = event.get("outcomes", {}) as Dictionary
	GameState.sub_mating_done = true

	if choice == "stay":
		var pool: Array = outcomes.get("stay", []) as Array
		var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() else \
			"You hold your position. The season passes without your claim."
		return _result(flavor)

	# choice == "challenge"
	if choice != "challenge":
		return _no_event()
	var challenge: Dictionary = outcomes.get("challenge", {}) as Dictionary
	var supporters := COMPANIONS.supporters()
	supporters.erase(str(preload("res://scripts/systems/pack_leadership.gd").leader().get("name", "")))
	var result: Dictionary = PackManager.resolve_alpha_fight()
	var tier := "win" if result["won"] else "loss_injured" if result["injured"] else "loss"
	if result["won"]:
		if GameState.is_mating_season():
			GameState.alpha_breed_pending = true
	elif result["injured"]:
		_swap_dein_fight_injury()
	var pool: Array = challenge.get(tier, []) as Array
	var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() else result["flavor"]
	if not pool.is_empty() and not supporters.is_empty():
		flavor += " %s backed your claim to leadership." % LIFE_STORY.names_text(supporters)
	return _result(flavor)


func _resolve_dein_rival_challenge(choice: String) -> Dictionary:
	var event: Dictionary = _load_dein_mate_event("rival")
	var outcomes: Dictionary = event.get("outcomes", {}) as Dictionary

	if choice == "yield":
		preload("res://scripts/systems/pack_leadership.gd").cede()
		var pool: Array = outcomes.get("yield", []) as Array
		var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() else \
			"You yield the center. The challenger becomes alpha."
		return _result(flavor)

	# choice == "fight"
	if choice != "fight":
		return _no_event()
	var fight: Dictionary = outcomes.get("fight", {}) as Dictionary
	var supporters := COMPANIONS.supporters()
	var result: Dictionary = PackManager.resolve_defender_fight()
	var tier := "win" if result["won"] else "loss_injured" if result["injured"] else "loss"
	if result["won"]:
		if GameState.is_mating_season():
			GameState.alpha_breed_pending = true
	elif result["injured"]:
		_swap_dein_fight_injury()
	var pool: Array = fight.get(tier, []) as Array
	var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() else result["flavor"]
	if not pool.is_empty() and not supporters.is_empty():
		flavor += " %s stayed beside you when the challenger arrived." % LIFE_STORY.names_text(supporters)
	return _result(flavor)


const _DEIN_BREED_HUNGER: Dictionary = {
	"lead": 0.12, "guard": 0.07, "offer": 0.04, "let": 0.0,
	"give": 0.12, "stay":  0.07,
}

const _DEIN_BREED_NESTING: Dictionary = {
	"lead":  { "strong_success":  0.30, "success":  0.20, "mixed":  0.05, "fail": -0.10 },
	"guard": { "strong_success":  0.20, "success":  0.15, "mixed":  0.05, "fail": -0.05 },
	"offer": { "strong_success":  0.10, "success":  0.08, "mixed":  0.03, "fail":  0.00 },
	"let":   { "strong_success":  0.05, "success":  0.03, "mixed": -0.05, "fail": -0.15 },
	"give":  { "strong_success":  0.30, "success":  0.20, "mixed":  0.05, "fail": -0.10 },
	"stay":  { "strong_success":  0.20, "success":  0.15, "mixed":  0.05, "fail": -0.05 },
}


func _resolve_dein_breeding(action: String, event_type: String) -> Dictionary:
	var event: Dictionary   = _load_dein_mate_event(event_type)
	var outcomes: Dictionary = event.get("outcomes", {}) as Dictionary
	var tier: String         = _roll_dein_breeding_tier()

	# Hunger cost
	var hunger_cost: float = _DEIN_BREED_HUNGER.get(action, 0.0)
	GameState.hunger = maxf(0.0, GameState.hunger - hunger_cost)

	# Nesting score delta
	var nesting_deltas: Dictionary = _DEIN_BREED_NESTING.get(action, {}) as Dictionary
	GameState.nesting_score += nesting_deltas.get(tier, 0.0)

	# Mark mating complete
	GameState.has_mate    = true
	GameState.pending_egg = true

	# Pick flavor
	var choice_outcomes: Dictionary = outcomes.get(action, {}) as Dictionary
	var pool: Array = choice_outcomes.get(tier, []) as Array
	var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() else \
		"The season continues around the pack."
	return _result(flavor)


func _resolve_dein_alpha_breeding(choice: String) -> Dictionary:
	return _resolve_dein_breeding(choice, "alpha")


func _resolve_dein_female_breeding(choice: String) -> Dictionary:
	return _resolve_dein_breeding(choice, "female")


# ── ALLOSAURUS MATING SYSTEM ──────────────────────────────────────────────────

func _load_allo_mate_event(event_type: String) -> Dictionary:
	var path := "res://scripts/dinos/allosaurus/dino_mate.gd"
	if not ResourceLoader.exists(path):
		return {}
	var script = load(path)
	var node := Node.new()
	node.set_script(script)
	var data: Dictionary
	match event_type:
		"male":   data = node.get_male_event()
		"female": data = node.get_female_event()
		_:        data = {}
	node.free()
	return data


func _roll_allo_female_tier(action: String) -> String:
	# Tier probabilities vary by choice.
	# ignore biases toward fail; strong_challenger biases toward strong_success.
	var luck: float = GameState.daily_luck
	var roll: float = randf()
	var ss: float
	var s:  float
	var m:  float
	match action:
		"strong_challenger":
			ss = clampf(0.15 + luck * 0.08, 0.03, 0.30)
			s  = clampf(0.55 + luck * 0.12, 0.25, 0.72)
			m  = clampf(0.88 + luck * 0.06, 0.65, 0.97)
		"test_patience":
			ss = clampf(0.10 + luck * 0.08, 0.02, 0.25)
			s  = clampf(0.50 + luck * 0.12, 0.20, 0.70)
			m  = clampf(0.85 + luck * 0.08, 0.60, 0.95)
		"safe_mate":
			ss = clampf(0.10 + luck * 0.08, 0.02, 0.25)
			s  = clampf(0.50 + luck * 0.12, 0.20, 0.70)
			m  = clampf(0.85 + luck * 0.08, 0.60, 0.95)
		_:  # ignore — higher fail chance
			ss = clampf(0.05 + luck * 0.04, 0.01, 0.15)
			s  = clampf(0.35 + luck * 0.08, 0.10, 0.55)
			m  = clampf(0.68 + luck * 0.06, 0.45, 0.82)
	if   roll < ss: return "strong_success"
	elif roll < s:  return "success"
	elif roll < m:  return "mixed"
	else:           return "fail"


const _ALLO_FIGHT_INJURIES: Array = [
	{ "name": "Jaw Clash",   "stat": "strength", "amount": -0.08, "turns": 2 },
	{ "name": "Flank Bite",  "stat": "defense",  "amount": -0.08, "turns": 2 },
	{ "name": "Hip Slam",    "stat": "speed",    "amount": -0.08, "turns": 2 },
]

const _ALLO_FEMALE_HUNGER: Dictionary = {
	"strong_challenger": 0.12,
	"test_patience":     0.07,
	"safe_mate":         0.04,
	"ignore":            0.0,
}

const _ALLO_FEMALE_NESTING: Dictionary = {
	"strong_challenger": { "strong_success":  0.35, "success":  0.25, "mixed":  0.05, "fail": -0.15 },
	"test_patience":     { "strong_success":  0.25, "success":  0.20, "mixed":  0.05, "fail": -0.10 },
	"safe_mate":         { "strong_success":  0.15, "success":  0.10, "mixed":  0.03, "fail": -0.05 },
	"ignore":            { "strong_success":  0.08, "success":  0.05, "mixed": -0.05, "fail": -0.20 },
}


func _resolve_allo_male_mating(choice: String) -> Dictionary:
	var event: Dictionary    = _load_allo_mate_event("male")
	var outcomes: Dictionary = event.get("outcomes", {}) as Dictionary
	GameState.species_mating_done = true

	if choice == "leave":
		GameState.male_mating_streak = 0
		var pool: Array = outcomes.get("leave", []) as Array
		var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() else \
			"You leave the trail. The season belongs to another."
		return _result(flavor)

	# choice == "challenge"
	var challenge: Dictionary = outcomes.get("challenge", {}) as Dictionary
	var win_chance: float     = clampf(0.45 + GameState.luck_mod(), 0.10, 0.85)
	var roll: float           = randf()

	if roll < win_chance:
		# Win — mate this season
		GameState.has_mate    = true
		GameState.pending_egg = true
		GameState.male_mating_streak += 1

		# Check for streak boost
		var streak_added: String = ""
		if GameState.male_mating_streak >= 4 and GameState.male_streak_boost_tier == 1:
			GameState.permanent_strength_mod += 0.03
			GameState.male_streak_boost_tier   = 2
			GameState.bonuses_earned.append("Dominant Line")
			streak_added = " Your dominance is no longer a question."
		elif GameState.male_mating_streak >= 2 and GameState.male_streak_boost_tier == 0:
			GameState.permanent_strength_mod += 0.03
			GameState.male_streak_boost_tier   = 1
			GameState.bonuses_earned.append("Proven Line")
			streak_added = " The forest is starting to recognize your victories."

		var pool: Array = challenge.get("win", []) as Array
		var win_text: String = pool[randi() % pool.size()] if not pool.is_empty() else \
			"You win the contest. The female accepts your claim."

		# Append streak flavor if on a streak (2+)
		if GameState.male_mating_streak >= 2 and streak_added.is_empty():
			var streak_pool: Array = event.get("streak_flavor", []) as Array
			if not streak_pool.is_empty():
				win_text += " " + streak_pool[randi() % streak_pool.size()]

		return _result(win_text + streak_added)

	# Loss
	var injured: bool = roll >= win_chance + (1.0 - win_chance) * 0.5
	GameState.health = maxf(0.0, GameState.health - 0.12)
	if injured:
		GameState.apply_injury(_ALLO_FIGHT_INJURIES[randi() % _ALLO_FIGHT_INJURIES.size()])
	GameState.male_mating_streak = 0

	var tier: String = "loss_injured" if injured else "loss"
	var pool: Array  = challenge.get(tier, []) as Array
	var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() else \
		"You lose the contest. The season belongs to the rival."
	return _result(flavor)


func _resolve_allo_female_mating(choice: String) -> Dictionary:
	var event: Dictionary    = _load_allo_mate_event("female")
	var outcomes: Dictionary = event.get("outcomes", {}) as Dictionary
	GameState.species_mating_done = true

	var tier: String = _roll_allo_female_tier(choice)

	# Hunger cost
	var hunger_cost: float = _ALLO_FEMALE_HUNGER.get(choice, 0.0)
	GameState.hunger = maxf(0.0, GameState.hunger - hunger_cost)

	# Nesting score delta
	var nesting_deltas: Dictionary = _ALLO_FEMALE_NESTING.get(choice, {}) as Dictionary
	GameState.nesting_score += nesting_deltas.get(tier, 0.0)

	# Mark mating complete (female always gets a mate this season)
	GameState.has_mate    = true
	GameState.pending_egg = true

	# Pick flavor
	var choice_outcomes: Dictionary = outcomes.get(choice, {}) as Dictionary
	var pool: Array = choice_outcomes.get(tier, []) as Array
	var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() else \
		"The season continues around the forest."
	return _result(flavor)


# ═══════════════════════════════════════════════════════════════════════════════
# GENERIC PATTERN A — challenge/leave (allosaurus, trex, ankylosaurus)
# ═══════════════════════════════════════════════════════════════════════════════

const _PATTERN_A_SPECIES: Array = ["allosaurus", "trex", "ankylosaurus"]
const _PATTERN_B_SPECIES: Array = ["lesothosaurus", "iguanodon", "triceratops", "argentinosaurus"]

func _load_species_mate_event(species_id: String, event_type: String) -> Dictionary:
	var path := "res://scripts/dinos/%s/dino_mate.gd" % species_id
	if not ResourceLoader.exists(path):
		return {}
	var script = load(path)
	var node := Node.new()
	node.set_script(script)
	var data: Dictionary
	match event_type:
		"male":       data = node.get_male_event()
		"female":     data = node.get_female_event()
		"tournament": data = node.get_tournament_event()
		"effort":     data = node.get_effort_event()
		_:            data = {}
	node.free()
	return data

# Shared tier roll for all female and effort events.
# Identical logic to _roll_allo_female_tier — kept separate so allo path stays
# untouched while generic path uses this one.
func _roll_mating_tier(action: String) -> String:
	var luck: float = GameState.daily_luck
	var roll: float = randf()
	var ss: float
	var s:  float
	var m:  float
	match action:
		"strong_challenger", "full_support":
			ss = clampf(0.15 + luck * 0.08, 0.03, 0.30)
			s  = clampf(0.55 + luck * 0.12, 0.25, 0.72)
			m  = clampf(0.88 + luck * 0.06, 0.65, 0.97)
		"test_patience", "guard_path":
			ss = clampf(0.10 + luck * 0.08, 0.02, 0.25)
			s  = clampf(0.50 + luck * 0.12, 0.20, 0.70)
			m  = clampf(0.85 + luck * 0.08, 0.60, 0.95)
		"safe_mate", "offer":
			ss = clampf(0.10 + luck * 0.08, 0.02, 0.25)
			s  = clampf(0.50 + luck * 0.12, 0.20, 0.70)
			m  = clampf(0.85 + luck * 0.08, 0.60, 0.95)
		_:  # ignore / let — higher fail chance
			ss = clampf(0.05 + luck * 0.04, 0.01, 0.15)
			s  = clampf(0.35 + luck * 0.08, 0.10, 0.55)
			m  = clampf(0.68 + luck * 0.06, 0.45, 0.82)
	if   roll < ss: return "strong_success"
	elif roll < s:  return "success"
	elif roll < m:  return "mixed"
	else:           return "fail"


func _resolve_pattern_a_male_mating(choice: String) -> Dictionary:
	var event: Dictionary    = _load_species_mate_event(GameState.species_id, "male")
	var outcomes: Dictionary = event.get("outcomes", {}) as Dictionary
	GameState.species_mating_done = true

	if choice == "leave":
		GameState.male_mating_streak = 0
		var pool: Array = outcomes.get("leave", []) as Array
		var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() else \
			"You leave the trail. The season belongs to another."
		return _result(flavor)

	# choice == "challenge"
	var challenge: Dictionary = outcomes.get("challenge", {}) as Dictionary
	var win_chance: float     = clampf(0.45 + GameState.luck_mod(), 0.10, 0.85)
	var roll: float           = randf()

	if roll < win_chance:
		GameState.has_mate    = true
		GameState.pending_egg = true
		GameState.male_mating_streak += 1

		var streak_added: String = ""
		if GameState.male_mating_streak >= 4 and GameState.male_streak_boost_tier == 1:
			GameState.permanent_strength_mod += 0.03
			GameState.male_streak_boost_tier   = 2
			GameState.bonuses_earned.append("Dominant Line")
			streak_added = " Your dominance is no longer a question."
		elif GameState.male_mating_streak >= 2 and GameState.male_streak_boost_tier == 0:
			GameState.permanent_strength_mod += 0.03
			GameState.male_streak_boost_tier   = 1
			GameState.bonuses_earned.append("Proven Line")
			streak_added = " The territory is starting to recognize your victories."

		var pool: Array = challenge.get("win", []) as Array
		var win_text: String = pool[randi() % pool.size()] if not pool.is_empty() else \
			"You win the contest. The female accepts your claim."

		if GameState.male_mating_streak >= 2 and streak_added.is_empty():
			var streak_pool: Array = event.get("streak_flavor", []) as Array
			if not streak_pool.is_empty():
				win_text += " " + streak_pool[randi() % streak_pool.size()]

		return _result(win_text + streak_added)

	# Loss
	var injured: bool = roll >= win_chance + (1.0 - win_chance) * 0.5
	GameState.health = maxf(0.0, GameState.health - 0.12)
	if injured:
		var injuries: Array = event.get("injuries", []) as Array
		if not injuries.is_empty():
			GameState.apply_injury(injuries[randi() % injuries.size()])
	GameState.male_mating_streak = 0

	var tier: String = "loss_injured" if injured else "loss"
	var pool: Array  = challenge.get(tier, []) as Array
	var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() else \
		"You lose the contest. The season belongs to the rival."
	return _result(flavor)


func _resolve_pattern_a_female_mating(choice: String) -> Dictionary:
	var event: Dictionary    = _load_species_mate_event(GameState.species_id, "female")
	var outcomes: Dictionary = event.get("outcomes", {}) as Dictionary
	GameState.species_mating_done = true

	var tier: String = _roll_mating_tier(choice)

	var hunger_costs: Dictionary = event.get("hunger", {}) as Dictionary
	GameState.hunger = maxf(0.0, GameState.hunger - hunger_costs.get(choice, 0.0))

	var nesting_map: Dictionary = event.get("nesting", {}) as Dictionary
	var nesting_deltas: Dictionary = nesting_map.get(choice, {}) as Dictionary
	GameState.nesting_score += nesting_deltas.get(tier, 0.0)

	GameState.has_mate    = true
	GameState.pending_egg = true

	var choice_outcomes: Dictionary = outcomes.get(choice, {}) as Dictionary
	var pool: Array = choice_outcomes.get(tier, []) as Array
	var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() else \
		"The season continues."
	return _result(flavor)


# ═══════════════════════════════════════════════════════════════════════════════
# GENERIC PATTERN B — tournament + effort chain
# (lesothosaurus, iguanodon, triceratops, argentinosaurus)
# ═══════════════════════════════════════════════════════════════════════════════

func _resolve_pattern_b_tournament(choice: String) -> Dictionary:
	var event: Dictionary    = _load_species_mate_event(GameState.species_id, "tournament")
	var outcomes: Dictionary = event.get("outcomes", {}) as Dictionary
	GameState.species_mating_done = true

	if choice == "step_back":
		var pool: Array = outcomes.get("step_back", []) as Array
		var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() else \
			"You step back from the contest. The season passes."
		return _result(flavor)

	# choice == "enter"
	var enter: Dictionary = outcomes.get("enter", {}) as Dictionary
	var win_chance: float = clampf(0.40 + GameState.luck_mod(), 0.10, 0.85)
	var roll: float       = randf()

	if roll < win_chance:
		# Win — chain the effort event next in this same process cycle
		GameState.breed_effort_pending = true
		var pool: Array = enter.get("win", []) as Array
		var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() else \
			"You win the contest and earn the right to mate."
		return _result(flavor)

	# Loss
	var injured: bool = roll >= win_chance + (1.0 - win_chance) * 0.5
	GameState.health = maxf(0.0, GameState.health - 0.10)
	if injured:
		var injuries: Array = event.get("injuries", []) as Array
		if not injuries.is_empty():
			GameState.apply_injury(injuries[randi() % injuries.size()])

	var tier: String = "loss_injured" if injured else "loss"
	var pool: Array  = enter.get(tier, []) as Array
	var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() else \
		"You lose the contest. The season belongs to another male."
	return _result(flavor)


func _resolve_pattern_b_effort(choice: String) -> Dictionary:
	var event: Dictionary    = _load_species_mate_event(GameState.species_id, "effort")
	var outcomes: Dictionary = event.get("outcomes", {}) as Dictionary
	GameState.breed_effort_pending = false

	var tier: String = _roll_mating_tier(choice)

	var hunger_costs: Dictionary = event.get("hunger", {}) as Dictionary
	GameState.hunger = maxf(0.0, GameState.hunger - hunger_costs.get(choice, 0.0))

	var nesting_map: Dictionary = event.get("nesting", {}) as Dictionary
	var nesting_deltas: Dictionary = nesting_map.get(choice, {}) as Dictionary
	GameState.nesting_score += nesting_deltas.get(tier, 0.0)

	# Set mate and egg only after effort resolves
	GameState.has_mate    = true
	GameState.pending_egg = true

	var choice_outcomes: Dictionary = outcomes.get(choice, {}) as Dictionary
	var pool: Array = choice_outcomes.get(tier, []) as Array
	var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() else \
		"The nesting period continues."
	return _result(flavor)


func _resolve_pattern_b_female_mating(choice: String) -> Dictionary:
	var event: Dictionary    = _load_species_mate_event(GameState.species_id, "female")
	var outcomes: Dictionary = event.get("outcomes", {}) as Dictionary
	GameState.species_mating_done = true

	var tier: String = _roll_mating_tier(choice)

	var hunger_costs: Dictionary = event.get("hunger", {}) as Dictionary
	GameState.hunger = maxf(0.0, GameState.hunger - hunger_costs.get(choice, 0.0))

	var nesting_map: Dictionary = event.get("nesting", {}) as Dictionary
	var nesting_deltas: Dictionary = nesting_map.get(choice, {}) as Dictionary
	GameState.nesting_score += nesting_deltas.get(tier, 0.0)

	GameState.has_mate    = true
	GameState.pending_egg = true

	var choice_outcomes: Dictionary = outcomes.get(choice, {}) as Dictionary
	var pool: Array = choice_outcomes.get(tier, []) as Array
	var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() else \
		"The season continues."
	return _result(flavor)


func _resolve_female_nesting_prep(choice: String) -> Dictionary:
	var d := _load_mate_data()
	match choice:
		"prepare_nest":
			GameState.hunger        = maxf(0.0, GameState.hunger - 0.10)
			GameState.nesting_score = 0.25
			var pool: Array = d.get("female_prep_nest", []) as Array
			return _mate_result(pool[randi() % pool.size()] if not pool.is_empty() else \
				"You prepared the nest carefully. The season has a strong beginning.", 0.80)
		"seek_food":
			GameState.hunger        = maxf(0.0, GameState.hunger - 0.08)
			GameState.nesting_score = 0.15
			var pool: Array = d.get("female_prep_food", []) as Array
			return _mate_result(pool[randi() % pool.size()] if not pool.is_empty() else \
				"You fed well while you could. The season starts with more strength than it might have.", 0.70)
		"stay_close":
			# nesting_score stays 0.0 — neutral
			var pool: Array = d.get("female_prep_group", []) as Array
			return _mate_result(pool[randi() % pool.size()] if not pool.is_empty() else \
				"You stayed close to the group. The season begins steadily.", 0.55)
		"ignore_season":
			GameState.nesting_score = -0.15
			var pool: Array = d.get("female_prep_ignore", []) as Array
			return _mate_result(pool[randi() % pool.size()] if not pool.is_empty() else \
				"You let the season arrive without preparation. The start is weaker for it.", 0.35)
	return _no_event()


func _resolve_rival_challenge(choice: String) -> Dictionary:
	var d := _load_mate_data()
	match choice:
		"fight":
			var result = PackManager.resolve_defender_fight()
			if result["won"]:
				var pool: Array = d.get("rival_fight_won", []) as Array
				var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() else result["flavor"]
				if not pool.is_empty():
					flavor += result.get("support_note", "")
				return _mate_result(flavor, 0.80)
			if result.get("injured", false):
				var pool: Array = d.get("rival_fight_lost_injured", []) as Array
				var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() else result["flavor"]
				if not pool.is_empty():
					flavor += result.get("support_note", "")
				return _result(flavor)
			var pool: Array = d.get("rival_fight_lost", []) as Array
			var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() else result["flavor"]
			if not pool.is_empty():
				flavor += result.get("support_note", "")
			return _result(flavor)
		"leave":
			PackManager.resolve_alpha_leave()
			var pool: Array = d.get("rival_left", []) as Array
			var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() else \
				"You left before the fight began. The territory belongs to the challenger now."
			return _result(flavor)
	return _no_event()


func _resolve_alpha_display(choice: String) -> Dictionary:
	var d := _load_mate_data()
	match choice:
		"display_show":
			# Good start — costs hunger, strong mate bond
			GameState.hunger = maxf(0.0, GameState.hunger - 0.08)
			var pool: Array = d.get("alpha_display_show", []) as Array
			var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() else \
				"You spent the energy proving yourself. The pack's attention is on you. The season is stronger for it."
			return _mate_result(flavor, 0.80)
		"display_guard":
			# Neutral start — held the territory, steady bond
			var pool: Array = d.get("alpha_display_guard", []) as Array
			var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() else \
				"You held the territory and kept the pack safe. Not a bold move — but a steady one."
			return _mate_result(flavor, 0.60)
		"display_ignore":
			# Bad start — ignored the season, weak bond
			var pool: Array = d.get("alpha_display_ignore", []) as Array
			var flavor: String = pool[randi() % pool.size()] if not pool.is_empty() else \
				"You let the season move around you. The pack noticed your absence from the moment."
			return _mate_result(flavor, 0.35)
	return _no_event()


# ── MATING SYSTEM ─────────────────────────────────────────────────────────────

func _load_mate_data() -> Dictionary:
	var path := "res://scripts/dinos/%s/dino_mate.gd" % GameState.species_id
	if ResourceLoader.exists(path):
		var script = load(path)
		var node := Node.new()
		node.set_script(script)
		var data: Dictionary = node.get_mate_data() as Dictionary
		node.free()
		return data
	return {}


# Pick text from a success-type outcome key; falls back to "success" pool, then to fallback string.
func _pick_mate_text(data: Dictionary, key: String, fallback: String) -> String:
	var pool: Array = data.get(key, []) as Array
	if pool.is_empty():
		pool = data.get("success", []) as Array
	if pool.is_empty():
		return fallback
	return pool[randi() % pool.size()]


# Pick text from a fail-type outcome key; falls back to "no_mate" pool, then to fallback string.
func _pick_mate_fail(data: Dictionary, key: String, fallback: String) -> String:
	var pool: Array = data.get(key, []) as Array
	if pool.is_empty():
		pool = data.get("no_mate", []) as Array
	if pool.is_empty():
		return fallback
	return pool[randi() % pool.size()]


func _mate_result(flavor: String, _bond: float = 0.0) -> Dictionary:
	GameState.has_mate = true
	GameState.pending_egg = true
	return _result(flavor)


func _resolve_find_mate() -> Dictionary:
	var species = SpeciesDB.get_species(GameState.species_id)
	var style = species.get("mating_style", "solitary_stalk")
	var sex = GameState.sex
	var pack: bool = GameState.pack_bond > 0.0
	var mdata := _load_mate_data()
	# Pack styles fall back to solitary if no pack
	if style in ["pack_alpha", "pack_coalition"] and not pack:
		style = "solitary_stalk"
	var key := ""
	var flavor := ""
	var choices: Array = []
	match style:
		"pack_alpha":
			if sex == "male":
				if GameState.is_alpha:
					key = "mate_pack_alpha_male_alpha"
					var pool: Array = mdata.get("seek_male_alpha", []) as Array
					flavor = pool[randi() % pool.size()] if not pool.is_empty() else \
						"Mating season. You don't need to seek — you hold this ground. The pack arranges itself around you. Two of the females have moved to the outer ring, waiting, watchful. This is what the alpha position means."
					choices = [
						{ "label": "Choose the boldest one",    "icon": "attack", "sublabel": "She's been watching you back",          "action": "choose_bold" },
						{ "label": "Choose the strongest one",  "icon": "stalk",  "sublabel": "Offspring survival comes first",        "action": "choose_strong" },
					]
				else:
					key = "mate_pack_alpha_male_sub"
					var pool: Array = mdata.get("seek_male_sub", []) as Array
					flavor = pool[randi() % pool.size()] if not pool.is_empty() else \
						"Mating season settles over the pack. When your eyes follow one of the females too long, the alpha is already there — body between you and her, weight forward, eyes locked on yours. Not a threat. A fact."
					choices = [
						{ "label": "Challenge him",              "icon": "attack", "sublabel": "This is what you've been building toward", "action": "alpha_fight" },
						{ "label": "Fall back",                  "icon": "stalk",  "sublabel": "Keep your place in the pack",             "action": "submit" },
						{ "label": "Leave before it escalates",  "icon": "flee",   "sublabel": "Walk away from all of it",                "action": "leave_pack" },
					]
			else:
				key = "mate_pack_alpha_female"
				var pool: Array = mdata.get("seek_female_pack", []) as Array
				flavor = pool[randi() % pool.size()] if not pool.is_empty() else \
					"The alpha has already chosen you. Not loudly — just the way he shifts when you're close, a longer pause when he passes. The other females have noticed. The subordinate males do not approach."
				choices = [
					{ "label": "Accept it",                       "icon": "stalk",  "sublabel": "This is the safest path",                 "action": "accept" },
					{ "label": "Try to slip out of the territory","icon": "flee",   "sublabel": "Risk everything to choose for yourself",  "action": "evade" },
					{ "label": "Signal a subordinate male",       "icon": "attack", "sublabel": "Dangerous. Very dangerous.",              "action": "signal_sub" },
				]
		"pack_coalition":
			if sex == "male":
				if GameState.is_alpha:
					key = "mate_pack_coalition_alpha"
					var pool: Array = mdata.get("seek_male_alpha", []) as Array
					flavor = pool[randi() % pool.size()] if not pool.is_empty() else \
						"Mating season. The coalition holds its shape around you. You are the one who mates — the others know this. The females have settled into the center of the range. This is your right to exercise."
					choices = [
						{ "label": "Choose your mate",           "icon": "attack", "sublabel": "Your right as alpha",                    "action": "alpha_choose" },
						{ "label": "Permit a subordinate",       "icon": "stalk",  "sublabel": "Coalition loyalty has its rewards",      "action": "permit_sub" },
					]
				else:
					key = "mate_pack_coalition_sub"
					var pool: Array = mdata.get("seek_male_sub", []) as Array
					flavor = pool[randi() % pool.size()] if not pool.is_empty() else \
						"Mating season. The alpha is already moving among the females. You know what the coalition rules are. You also know a moment when you see one."
					choices = [
						{ "label": "Wait — your turn will come",    "icon": "stalk",  "sublabel": "Loyalty has a longer return",         "action": "wait_loyal" },
						{ "label": "Try when the alpha is away",    "icon": "attack", "sublabel": "High risk. Low probability.",         "action": "sneak" },
						{ "label": "Leave the coalition",           "icon": "flee",   "sublabel": "Find your own path",                  "action": "leave_pack" },
					]
			else:
				key = "mate_pack_coalition_female"
				var pool: Array = mdata.get("seek_female_pack", []) as Array
				flavor = pool[randi() % pool.size()] if not pool.is_empty() else \
					"The alpha has made his presence known. The coalition males watch from their positions. The hierarchy is clear — and you are inside it."
				choices = [
					{ "label": "Accept the alpha",               "icon": "stalk",  "sublabel": "The expected choice",                   "action": "accept" },
					{ "label": "Signal a coalition subordinate", "icon": "attack", "sublabel": "Risky. He will have to be quick.",       "action": "signal_sub" },
				]
		"tournament_combat":
			if sex == "male":
				key = "mate_tournament_combat_male"
				var pool: Array = mdata.get("seek_male", []) as Array
				flavor = pool[randi() % pool.size()] if not pool.is_empty() else \
					"The males are gathering near the rock flat — three already pushing, horn on horn. The impacts carry. The females watch from the herd's edge, unhurried. They have seen this before."
				choices = [
					{ "label": "Enter the contest",             "icon": "attack", "sublabel": "Horn to horn",                   "action": "fight" },
					{ "label": "Display from the edge",         "icon": "stalk",  "sublabel": "Let her see you without the risk","action": "display" },
					{ "label": "Observe this season",           "icon": "flee",   "sublabel": "No mate — but no injury either",  "action": "pass" },
				]
			else:
				key = "mate_tournament_combat_female"
				var pool: Array = mdata.get("seek_female", []) as Array
				flavor = pool[randi() % pool.size()] if not pool.is_empty() else \
					"The pushing match is happening at the herd's edge. You can feel it in the ground. The winner earns the right to approach. You can wait for him — or move toward the one you've been watching."
				choices = [
					{ "label": "Wait for the winner",           "icon": "stalk",  "sublabel": "Take whoever earns it",            "action": "wait" },
					{ "label": "Move toward the one you want",  "icon": "attack", "sublabel": "Make your preference known",       "action": "choose" },
					{ "label": "Leave the area",                "icon": "flee",   "sublabel": "Not this season",                  "action": "leave" },
				]
		"tournament_speed":
			if sex == "male":
				key = "mate_tournament_speed_male"
				var pool: Array = mdata.get("seek_male", []) as Array
				flavor = pool[randi() % pool.size()] if not pool.is_empty() else \
					"Dawn. The males line up at the edge of the open ground. The ones who reach the tree line first get noticed. The ones who fall back go home alone."
				choices = [
					{ "label": "Run hard from the start",        "icon": "attack", "sublabel": "Hold nothing back",               "action": "sprint_hard" },
					{ "label": "Pace yourself, strike at the end","icon": "stalk", "sublabel": "Smart race beats a fast start",   "action": "sprint_pace" },
					{ "label": "Hold back",                      "icon": "flee",   "sublabel": "Not this season",                 "action": "pass" },
				]
			else:
				key = "mate_tournament_speed_female"
				var pool: Array = mdata.get("seek_female", []) as Array
				flavor = pool[randi() % pool.size()] if not pool.is_empty() else \
					"The males are running the dawn ground. You could stand here and take whoever wins. Or you could run out into it — make them chase you instead of a finish line."
				choices = [
					{ "label": "Run with them",                  "icon": "attack", "sublabel": "Let the fastest one follow you",  "action": "lead" },
					{ "label": "Wait and pick the one you want", "icon": "stalk",  "sublabel": "After the race, your choice",     "action": "choose" },
					{ "label": "Ignore the season",              "icon": "flee",   "sublabel": "Not this year",                   "action": "pass" },
				]
		"display_aerial":
			if sex == "male":
				key = "mate_aerial_male"
				var pool: Array = mdata.get("seek_male", []) as Array
				flavor = pool[randi() % pool.size()] if not pool.is_empty() else \
					"The air above the colony is thick with it — wing spreads, dive patterns, calls that cut through. You climb into it."
				choices = [
					{ "label": "Power dive",                     "icon": "attack", "sublabel": "Drop fast. Pull up sharp.",        "action": "dive" },
					{ "label": "Precision glide",                "icon": "stalk",  "sublabel": "Slow. Deliberate. Readable.",      "action": "glide" },
					{ "label": "Watch from a perch",             "icon": "flee",   "sublabel": "Learn, but not today",             "action": "watch" },
				]
			else:
				key = "mate_aerial_female"
				var pool: Array = mdata.get("seek_female", []) as Array
				flavor = pool[randi() % pool.size()] if not pool.is_empty() else \
					"They are all up there competing for notice. One pulled out of the formation to circle lower — not quite landing. Closer than the others."
				choices = [
					{ "label": "Acknowledge the one circling",   "icon": "attack", "sublabel": "That one already made his choice","action": "respond" },
					{ "label": "Wait for better options",        "icon": "stalk",  "sublabel": "Let them prove themselves first",  "action": "wait" },
					{ "label": "Leave the colony airspace",      "icon": "flee",   "sublabel": "Not this season",                  "action": "leave" },
				]
		"display_swarm":
			if sex == "male":
				key = "mate_aerial_male"
				var pool: Array = mdata.get("seek_male", []) as Array
				flavor = pool[randi() % pool.size()] if not pool.is_empty() else \
					"The swarm is up — hundreds in the same column of air, each pattern slightly different. You pull into the formation and find your rhythm."
				choices = [
					{ "label": "Break from the swarm and dive",  "icon": "attack", "sublabel": "Stand out from the noise",        "action": "dive" },
					{ "label": "Fly the formation perfectly",    "icon": "stalk",  "sublabel": "Precision signals strength",      "action": "glide" },
					{ "label": "Hold at the edge",               "icon": "flee",   "sublabel": "Not this season",                 "action": "watch" },
				]
			else:
				key = "mate_aerial_female"
				var pool: Array = mdata.get("seek_female", []) as Array
				flavor = pool[randi() % pool.size()] if not pool.is_empty() else \
					"The swarm fills the air above the roost. One broke formation — circling lower, closer. The others haven't noticed or don't care."
				choices = [
					{ "label": "Acknowledge the one circling",   "icon": "attack", "sublabel": "He made his move first",          "action": "respond" },
					{ "label": "Wait to see who else breaks",    "icon": "stalk",  "sublabel": "Better options may follow",       "action": "wait" },
					{ "label": "Return to the roost",            "icon": "flee",   "sublabel": "Not this season",                 "action": "leave" },
				]
		"display_nocturnal":
			if sex == "male":
				key = "mate_nocturnal_male"
				var pool: Array = mdata.get("seek_male", []) as Array
				flavor = pool[randi() % pool.size()] if not pool.is_empty() else \
					"After dark, the forest fills with calls — layered, overlapping. Each voice trying to cut through. You add yours."
				choices = [
					{ "label": "Call loudly and often",          "icon": "attack", "sublabel": "Be heard above everyone",         "action": "loud" },
					{ "label": "Quiet and precise — a pattern",  "icon": "stalk",  "sublabel": "Quality over volume",             "action": "precise" },
					{ "label": "Stay silent",                    "icon": "flee",   "sublabel": "Safe, but alone",                 "action": "silent" },
				]
			else:
				key = "mate_nocturnal_female"
				var pool: Array = mdata.get("seek_female", []) as Array
				flavor = pool[randi() % pool.size()] if not pool.is_empty() else \
					"One call in the dark keeps returning to your roost. Consistent. Patient. Getting closer. Three nights now."
				choices = [
					{ "label": "Answer it",                      "icon": "attack", "sublabel": "End the waiting",                 "action": "respond" },
					{ "label": "Stay quiet — let it find you",   "icon": "stalk",  "sublabel": "Make him work for it",            "action": "wait" },
					{ "label": "Relocate your roost",            "icon": "flee",   "sublabel": "Not this season",                 "action": "leave" },
				]
		"solitary_stalk":
			if sex == "male":
				key = "mate_stalk_male"
				var pool: Array = mdata.get("seek_male", []) as Array
				flavor = pool[randi() % pool.size()] if not pool.is_empty() else \
					"Fresh tracks — twice in three days. Same size as you, moving through your range without challenge. That means something."
				choices = [
					{ "label": "Follow the trail",               "icon": "attack", "sublabel": "Find her before she moves on",   "action": "follow" },
					{ "label": "Mark your territory and wait",   "icon": "stalk",  "sublabel": "Signal your presence",           "action": "wait" },
					{ "label": "Leave it",                       "icon": "flee",   "sublabel": "Not this season",                "action": "leave" },
				]
			else:
				key = "mate_stalk_female"
				var pool: Array = mdata.get("seek_female", []) as Array
				flavor = pool[randi() % pool.size()] if not pool.is_empty() else \
					"Something has been circling your range for days. Not predator behavior — too patient, too deliberate. It hasn't approached directly. Yet."
				choices = [
					{ "label": "Wait — let it come to you",      "icon": "stalk",  "sublabel": "Safe. On your terms.",            "action": "receive" },
					{ "label": "Move toward where it's been",    "icon": "attack", "sublabel": "Close the distance yourself",    "action": "approach" },
					{ "label": "Drive it off",                   "icon": "flee",   "sublabel": "Your range stays yours",         "action": "reject" },
				]
		"solitary_court":
			if sex == "male":
				key = "mate_court_male"
				var pool: Array = mdata.get("seek_male", []) as Array
				flavor = pool[randi() % pool.size()] if not pool.is_empty() else \
					"She has been watching you from the ridge for three days. You know this because you also watch. Troodon pairs carefully — it starts with observation."
				choices = [
					{ "label": "Leave clear sign near her range","icon": "stalk",  "sublabel": "Let her read your capability",   "action": "signal" },
					{ "label": "Hunt visibly in her sight line", "icon": "attack", "sublabel": "Show what you bring",            "action": "demonstrate" },
					{ "label": "Wait — see if she approaches",   "icon": "flee",   "sublabel": "Patience has its own signal",    "action": "wait" },
				]
			else:
				key = "mate_court_female"
				var pool: Array = mdata.get("seek_female", []) as Array
				flavor = pool[randi() % pool.size()] if not pool.is_empty() else \
					"A male has been leaving deliberate sign near your range — not territorial. Something else. He has been watching from the treeline for three days without approaching."
				choices = [
					{ "label": "Follow the sign and go to him",  "icon": "attack", "sublabel": "You've seen enough to decide",   "action": "investigate" },
					{ "label": "Continue your routine",          "icon": "stalk",  "sublabel": "Make him wait longer",            "action": "ignore" },
					{ "label": "Walk straight to the treeline",  "icon": "flee",   "sublabel": "Cut past the signals entirely",  "action": "approach" },
				]
		_:  # fallback solitary
			if sex == "male":
				key = "mate_stalk_male"
				var pool: Array = mdata.get("seek_male", []) as Array
				flavor = pool[randi() % pool.size()] if not pool.is_empty() else \
					"The season has shifted. Tracks, sounds, signs at the edge of your range. Something out there."
				choices = [
					{ "label": "Search actively",                "icon": "attack", "sublabel": "Cover ground, find them",        "action": "follow" },
					{ "label": "Mark territory and wait",        "icon": "stalk",  "sublabel": "Let them come to you",           "action": "wait" },
					{ "label": "Let it pass",                    "icon": "flee",   "sublabel": "Not this season",                "action": "leave" },
				]
			else:
				key = "mate_stalk_female"
				var pool: Array = mdata.get("seek_female", []) as Array
				flavor = pool[randi() % pool.size()] if not pool.is_empty() else \
					"The season has shifted. Something has been circling your range without making itself known."
				choices = [
					{ "label": "Wait — let it approach",         "icon": "stalk",  "sublabel": "On your terms",                  "action": "receive" },
					{ "label": "Go toward where it's been",      "icon": "attack", "sublabel": "Close the distance",             "action": "approach" },
					{ "label": "Drive it off",                   "icon": "flee",   "sublabel": "Your range stays yours",         "action": "reject" },
				]
	return { "type": "mate_seek", "next_context": key, "flavor": flavor, "choices": choices }


func _resolve_mate_pack_alpha_male_alpha(choice: String) -> Dictionary:
	var d := _load_mate_data()
	match choice:
		"choose_bold":
			return _mate_result(_pick_mate_text(d, "alpha_chose_bold", "She held your gaze when you chose her. The pack settled. This is what the season is for."), 0.75)
		"choose_strong":
			return _mate_result(_pick_mate_text(d, "alpha_chose_strong", "The stronger female. Practical. The pack accepts it without question."), 0.65)
	return _no_event()


func _resolve_mate_pack_alpha_male_sub(choice: String) -> Dictionary:
	var d := _load_mate_data()
	match choice:
		"alpha_fight":
			var result = PackManager.resolve_alpha_fight()
			var support_note: String = result.get("support_note", "")
			var fallback: String = result["flavor"].trim_suffix(support_note)
			if result["won"]:
				return _mate_result(_pick_mate_text(d, "sub_fight_won", fallback + " The season is yours now.") + support_note, 0.70)
			if result.get("injured", false):
				return _result(_pick_mate_fail(d, "sub_fight_lost_injured", fallback) + support_note)
			return _result(_pick_mate_fail(d, "sub_fight_lost", fallback) + support_note)
		"submit":
			return _result(_pick_mate_fail(d, "sub_submitted", "You fell back. He watched you go. You kept your place — but not your chance. Not this season."))
		"leave_pack":
			PackManager.resolve_alpha_leave()
			return _result(_pick_mate_fail(d, "sub_left_pack", "You left before it came to a fight. No territory, no pack. Alone — but no one standing over you."))
	return _no_event()


func _resolve_mate_pack_alpha_female(choice: String) -> Dictionary:
	var d := _load_mate_data()
	match choice:
		"accept":
			GameState.mate_was_alpha = true
			return _mate_result(_pick_mate_text(d, "female_accept_alpha", "You held your ground and let him approach. The pack arranged itself around the two of you. It is done."), 0.65)
		"evade":
			if randf() < 0.35:
				PackManager.resolve_alpha_leave()
				return _result(_pick_mate_fail(d, "female_evade_success", "You slipped out before the season locked you in. No pack now — but this was your choice to make."))
			GameState.mate_was_alpha = true
			return _mate_result(_pick_mate_text(d, "female_evade_caught", "He found you before you cleared the territory. There was no aggression — just that look again. You stayed."), 0.45)
		"signal_sub":
			if randf() < 0.20:
				PackManager.modify_bond(-0.40)
				GameState.mate_was_alpha = false
				return _mate_result(_pick_mate_text(d, "female_chose_sub_success", "The subordinate was bold enough. The alpha didn't see it in time. The pack fractured over it."), 0.60)
			PackManager.modify_bond(-0.30)
			return _result(_pick_mate_fail(d, "female_chose_sub_caught", "The alpha saw. The subordinate backed down immediately. The pack bond took the damage. Your position is complicated now."))
	return _no_event()


# ── PACK COALITION (Deinonychus) ──────────────────────────────────────────────

func _resolve_mate_pack_coalition_alpha(choice: String) -> Dictionary:
	var d := _load_mate_data()
	match choice:
		"alpha_choose":
			GameState.mate_was_alpha = true
			return _mate_result(_pick_mate_text(d, "coalition_alpha", "You chose. The coalition held its shape around the decision. No question was asked."), 0.70)
		"permit_sub":
			# Alpha permits a subordinate — earns coalition loyalty
			PackManager.modify_bond(0.15)
			return _result(_pick_mate_fail(d, "coalition_sub_permitted", "You stepped back and let one of them have it. The coalition settled closer around you afterward. That investment will return."))
	return _no_event()


func _resolve_mate_pack_coalition_sub(choice: String) -> Dictionary:
	var d := _load_mate_data()
	match choice:
		"wait_loyal":
			return _result(_pick_mate_fail(d, "sub_submitted", "You held your position. The season passed without you. The alpha noticed the discipline. Your place in the coalition is stable."))
		"sneak":
			if randf() < 0.18:
				GameState.mate_was_alpha = false
				PackManager.modify_bond(-0.20)
				return _mate_result(_pick_mate_text(d, "coalition_sub_sneak", "You found a moment the alpha missed. It was quick. The coalition didn't see it — or chose not to."), 0.55)
			PackManager.modify_bond(-0.25)
			return _result(_pick_mate_fail(d, "female_chose_sub_caught", "The alpha saw. What you tried to take was made very clear to everyone. Your position in the coalition is damaged."))
		"leave_pack":
			PackManager.resolve_alpha_leave()
			return _result(_pick_mate_fail(d, "sub_left_pack", "You left the coalition rather than wait again. Solo now. The season is yours to spend how you want."))
	return _no_event()


func _resolve_mate_pack_coalition_female(choice: String) -> Dictionary:
	var d := _load_mate_data()
	match choice:
		"accept":
			GameState.mate_was_alpha = true
			return _mate_result(_pick_mate_text(d, "female_accept_alpha", "The alpha's choice settled over you. The coalition arranged itself. It is done."), 0.65)
		"signal_sub":
			if randf() < 0.20:
				PackManager.modify_bond(-0.35)
				GameState.mate_was_alpha = false
				return _mate_result(_pick_mate_text(d, "female_chose_sub_success", "One of the subordinates moved quickly. The alpha was occupied. The coalition paid the cost later."), 0.55)
			PackManager.modify_bond(-0.25)
			return _result(_pick_mate_fail(d, "female_chose_sub_caught", "The alpha caught the signal. The subordinate went still. The pack bond fractured at the seam. Your standing here is complicated now."))
	return _no_event()


func _resolve_mate_tournament_combat_male(choice: String) -> Dictionary:
	var d := _load_mate_data()
	match choice:
		"fight":
			var attacker = { "fight_power": GameState.strength + GameState.defense * 0.3, "size": GameState.size, "opponent_size": GameState.size, "group_size": 0 }
			var defender = { "fight_power": randf_range(0.30, 0.65), "size": GameState.size, "hunger_value": 0.0 }
			var result = CombatResolver.resolve(attacker, defender)
			if result["outcome"] in [CombatResolver.Outcome.WIN, CombatResolver.Outcome.WIN_INJURED]:
				if result.get("injury", {}).size() > 0:
					_apply_injury(result["injury"])
				GameState.fights_won += 1
				return _mate_result(_pick_mate_text(d, "tournament_fight_won", "You won the contest. She came down from the edge before the dust settled. No question about what it meant."), 0.70)
			GameState.health = maxf(0.0, GameState.health - result["damage"])
			if result.get("injury", {}).size() > 0:
				_apply_injury(result["injury"])
			GameState.fights_lost += 1
			return _result(_pick_mate_fail(d, "tournament_fight_lost", "You lost. Still standing — but she didn't come toward you. Someone else won this season."))
		"display":
			if GameState.defense >= 0.45:
				return _mate_result(_pick_mate_text(d, "tournament_display_good", "You held your ground at the edge without entering. She noticed the restraint as much as the strength."), 0.50)
			return _result(_pick_mate_fail(d, "tournament_display_fail", "You stayed at the edge. She watched the contest. Whoever won it earned her attention — not you."))
		"pass":
			GameState.pack_bond = minf(1.0, GameState.pack_bond + 0.05)
			return _result(_pick_mate_fail(d, "tournament_pass", "You didn't enter the contest. The season passed. The herd accepted your patience without comment."))
	return _no_event()


func _resolve_mate_tournament_combat_female(choice: String) -> Dictionary:
	var d := _load_mate_data()
	match choice:
		"wait":
			return _mate_result(_pick_mate_text(d, "tournament_f_waited", "The contest ended. The winner approached without rushing. You had already decided to let him."), 0.55 + randf() * 0.15)
		"choose":
			if randf() < 0.50:
				return _mate_result(_pick_mate_text(d, "tournament_f_chose_won", "He won. He came straight to you. You'd already told him what you wanted without saying a word."), 0.75)
			if randf() < 0.50:
				return _mate_result(_pick_mate_text(d, "tournament_f_chose_lost", "He lost. But he still came toward you quietly, away from the circle. You let him."), 0.55)
			return _result(_pick_mate_fail(d, "tournament_f_left", "He lost. The winner claimed the attention you'd been signaling. Sometimes the one you want doesn't win."))
		"leave":
			return _result(_pick_mate_fail(d, "tournament_f_left", "You moved away before the contest ended. A quiet season."))
	return _no_event()


func _resolve_mate_tournament_speed_male(choice: String) -> Dictionary:
	var d := _load_mate_data()
	match choice:
		"sprint_hard":
			if GameState.speed >= 0.65:
				return _mate_result(_pick_mate_text(d, "speed_sprint_won", "You hit the tree line first. She was there — had been watching from the shade. No ceremony. Just acknowledgment."), 0.70)
			if GameState.speed >= 0.40 and randf() < 0.55:
				return _mate_result(_pick_mate_text(d, "speed_sprint_close", "Close — near the front. She chose the fastest. That was close enough."), 0.60)
			GameState.apply_temp_buff("speed", -0.08, 2, "overexerted")
			return _result(_pick_mate_fail(d, "speed_sprint_overexerted", "You pushed past your limit. You didn't finish well. The season went to someone faster."))
		"sprint_pace":
			var roll = GameState.speed * 0.5 + randf() * 0.4
			if roll >= 0.50:
				return _mate_result(_pick_mate_text(d, "speed_pace_won", "You ran smart — saved your sprint for the end. She noticed who had something left when the others didn't."), 0.65)
			return _result(_pick_mate_fail(d, "speed_pace_lost", "You paced yourself but others ran smarter still. Not this season."))
		"pass":
			return _result(_pick_mate_fail(d, "speed_pass", "You held back. The race happened without you. The season moved on."))
	return _no_event()


func _resolve_mate_tournament_speed_female(choice: String) -> Dictionary:
	var d := _load_mate_data()
	match choice:
		"lead":
			return _mate_result(_pick_mate_text(d, "speed_f_led", "You broke into the race ahead of them. The fastest male understood immediately — he ran toward you, not the finish line."), 0.75)
		"choose":
			return _mate_result(_pick_mate_text(d, "speed_f_chose", "You watched from the shade. The one you'd already chosen came in well. He came to you before he was done breathing hard."), 0.65)
		"pass":
			return _result(_pick_mate_fail(d, "speed_pass", "You let the season pass. The morning ground was quiet after the race. You grazed alone."))
	return _no_event()


func _resolve_mate_aerial_male(choice: String) -> Dictionary:
	var d := _load_mate_data()
	match choice:
		"dive":
			var power = GameState.strength * 0.6 + randf() * 0.4
			if power >= 0.45:
				return _mate_result(_pick_mate_text(d, "success", "You dropped hard and pulled up sharp — close enough that the wind moved. She tracked you all the way down."), 0.70)
			if power >= 0.25:
				return _mate_result(_pick_mate_text(d, "success", "Decent dive. Not the best up there — but clean. She landed nearby without fanfare."), 0.55)
			if randf() < 0.30:
				_apply_injury({ "name": "Wrenched wing", "stat": "type_stat", "amount": -0.15, "turns": 3 })
			return _result(_pick_mate_fail(d, "no_mate", "The dive was off. You pulled up too late. Nothing broken — but no one noticed it in a good way."))
		"glide":
			var grace = GameState.type_stat * 0.6 + GameState.speed * 0.3 + randf() * 0.2
			if grace >= 0.50:
				return _mate_result(_pick_mate_text(d, "success", "You glided the full pattern, unhurried. She came off her perch and joined your thermal. That was enough."), 0.65)
			return _result(_pick_mate_fail(d, "no_mate", "You held the glide but the pattern read as ordinary. Nobody landed next to you."))
		"watch":
			GameState.type_stat = minf(1.0, GameState.type_stat + 0.02)
			return _result(_pick_mate_fail(d, "no_mate", "You watched from the ridge. Learned the patterns. The season passed — but you read something useful for next time."))
	return _no_event()


func _resolve_mate_aerial_female(choice: String) -> Dictionary:
	var d := _load_mate_data()
	match choice:
		"respond":
			return _mate_result(_pick_mate_text(d, "success", "You acknowledged the one circling lower. He landed. The display was already done — this was just the confirmation."), 0.65)
		"wait":
			if randf() < 0.55:
				return _mate_result(_pick_mate_text(d, "success", "You waited. Three more broke formation after the first. The second one was better. You acknowledged him."), 0.72)
			return _result(_pick_mate_fail(d, "no_mate", "You waited. The first gave up and returned to formation. No one else broke out. The season closed."))
		"leave":
			return _result(_pick_mate_fail(d, "no_mate", "You left the colony airspace before it got serious. A quiet season."))
	return _no_event()


func _resolve_mate_nocturnal_male(choice: String) -> Dictionary:
	var d := _load_mate_data()
	match choice:
		"loud":
			if randf() < 0.20:
				return _build_threat_event()
			if GameState.type_stat * 0.4 + randf() * 0.6 >= 0.50:
				return _mate_result(_pick_mate_text(d, "success", "Your call cut through the rest. She found you before midnight."), 0.65)
			return _result(_pick_mate_fail(d, "no_mate", "You called all night. Something came — but not what you were calling for. You moved before dawn."))
		"precise":
			var precision = GameState.type_stat * 0.7 + randf() * 0.3
			if precision >= 0.45:
				return _mate_result(_pick_mate_text(d, "success", "The pattern reached her. She answered twice before she came close. Deliberate. That's how it's done in the dark."), 0.72)
			return _result(_pick_mate_fail(d, "no_mate", "The pattern didn't carry far enough. Or she heard it and chose silence. No answer came."))
		"silent":
			return _result(_pick_mate_fail(d, "no_mate", "You held quiet through the night. Safe. Alone."))
	return _no_event()


func _resolve_mate_nocturnal_female(choice: String) -> Dictionary:
	var d := _load_mate_data()
	match choice:
		"respond":
			return _mate_result(_pick_mate_text(d, "success", "You answered. He was closer than the dark made him seem. He came directly — no circling, no delay."), 0.70)
		"wait":
			if randf() < 0.60:
				return _mate_result(_pick_mate_text(d, "success", "You stayed quiet. He found you anyway — three nights of patience told him exactly where your roost was."), 0.65)
			return _result(_pick_mate_fail(d, "no_mate", "You stayed quiet. The calls continued two more nights and then stopped. He moved on."))
		"leave":
			return _result(_pick_mate_fail(d, "no_mate", "You relocated before dawn. The calls don't follow you to the new hollow. Safe, and quiet."))
	return _no_event()


func _resolve_mate_stalk_male(choice: String) -> Dictionary:
	var d := _load_mate_data()
	match choice:
		"follow":
			if randf() < 0.70:
				return _mate_result(_pick_mate_text(d, "stalk_m_found", "The trail led you to her. She had stopped moving — waiting, or resting. You approached carefully. She didn't leave."), 0.65)
			return _result(_pick_mate_fail(d, "stalk_m_trail_lost", "You followed the trail for two days. It ended at a river crossing. Whatever was ahead moved on before you could close the distance."))
		"wait":
			if randf() < 0.50:
				return _mate_result(_pick_mate_text(d, "stalk_m_waited_came", "Your marks were read. She came into your range three days later, unhurried. A quiet meeting."), 0.60)
			return _result(_pick_mate_fail(d, "stalk_m_waited_empty", "Your territory was marked well. Nothing came. The season ran its course."))
		"leave":
			return _result(_pick_mate_fail(d, "stalk_m_left", "You left the trail alone. The season moved through without consequence."))
	return _no_event()


func _resolve_mate_stalk_female(choice: String) -> Dictionary:
	var d := _load_mate_data()
	match choice:
		"receive":
			return _mate_result(_pick_mate_text(d, "stalk_f_received", "You held your range and let him come on his timing. When he finally approached, there was no uncertainty in it."), 0.68)
		"approach":
			if randf() < 0.80:
				return _mate_result(_pick_mate_text(d, "stalk_f_approached", "You moved toward where he had been. He was still there — watching. The distance closed faster than either of you expected."), 0.72)
			return _result(_pick_mate_fail(d, "stalk_f_range_empty", "You moved toward the signs. The range was empty. He'd moved on."))
		"reject":
			GameState.type_stat = minf(1.0, GameState.type_stat + 0.03)
			return _result(_pick_mate_fail(d, "stalk_f_rejected", "You marked your range heavily and drove off anything that came close. The season passed on your terms. Alone — but your ground is clean."))
	return _no_event()


func _resolve_mate_court_male(choice: String) -> Dictionary:
	var d := _load_mate_data()
	match choice:
		"signal":
			var intelligence = GameState.type_stat * 0.65 + randf() * 0.35
			if intelligence >= 0.45:
				return _mate_result(_pick_mate_text(d, "court_m_signal", "She read the sign correctly. When she came to you, she already knew what she was deciding. She decided yes."), 0.72)
			return _result(_pick_mate_fail(d, "no_mate", "You left the signs. She found them. But the message didn't translate — or the answer was no. She didn't come."))
		"demonstrate":
			if GameState.hunger >= 0.60:
				return _mate_result(_pick_mate_text(d, "court_m_demonstrate", "You made a clean kill in her sight line. She watched the whole thing. Came down from the ridge before you'd finished."), 0.68)
			return _result(_pick_mate_fail(d, "no_mate", "You hunted where she could see — and came up empty. Twice. She stopped watching before the third attempt."))
		"wait":
			if randf() < 0.60:
				return _mate_result(_pick_mate_text(d, "court_m_waited", "You held your range and didn't press. She came down on the fourth day. You had been patient enough."), 0.70)
			return _result(_pick_mate_fail(d, "no_mate", "You waited. She watched longer than most would. Then she moved on. Patience had a limit this season."))
	return _no_event()


func _resolve_mate_court_female(choice: String) -> Dictionary:
	var d := _load_mate_data()
	match choice:
		"investigate":
			return _mate_result(_pick_mate_text(d, "court_f_investigated", "You followed the sign to him. He was at the edge of his range, watching your approach. You both already knew how this would go."), 0.75)
		"ignore":
			GameState.type_stat = minf(1.0, GameState.type_stat + 0.02)
			return _result(_pick_mate_fail(d, "no_mate", "You continued your routine. He watched for three more days and then read the message in your movement. He left. The season closed quietly."))
		"approach":
			return _mate_result(_pick_mate_text(d, "court_f_approached", "You walked straight toward the treeline. He was there. No signs, no signals — just you deciding, and him seeing you decide."), 0.80)
	return _no_event()


func _resolve_alpha_suspicion(choice: String) -> Dictionary:
	match choice:
		"stay_hope":
			# Bond matters — higher bond means more trust, more chance he lets it go
			var trust = GameState.pack_bond * 0.6 + randf() * 0.4
			if trust >= 0.55:
				GameState.alpha_suspects = false
				return _result("The days pass. He watches. Then one morning he moves on from it — or chooses to. The pack holds. The young grow. Nothing more is said.")
			# He doesn't let it go — confrontation becomes forced
			return _build_alpha_forced_confrontation()
		"leave":
			PackManager.resolve_alpha_leave()
			GameState.alpha_suspects = false
			return _result("You took the young and left before it came to a head. No pack now — but the young are safe, and this was your choice to make.")
		"confront":
			# High risk — fight for your place in the pack
			var attacker = {
				"fight_power":   GameState.strength,
				"size":          GameState.size,
				"opponent_size": GameState.size + 1,
				"group_size":    0,
			}
			var defender = {
				"fight_power":   randf_range(0.45, 0.75),
				"size":          GameState.size + 1,
				"opponent_size": GameState.size,
				"hunger_value":  0.0,
			}
			var result = CombatResolver.resolve(attacker, defender)
			GameState.alpha_suspects = false
			if result["outcome"] in [CombatResolver.Outcome.WIN, CombatResolver.Outcome.WIN_INJURED]:
				if result.get("injury", {}).size() > 0:
					_apply_injury(result["injury"])
				PackManager.modify_bond(-0.20)
				return _result("You named it. You held your ground. He backed down — not cleanly, but he backed down. The pack holds but the tension will last.")
			GameState.health = maxf(0.0, GameState.health - result["damage"])
			if result.get("injury", {}).size() > 0:
				_apply_injury(result["injury"])
			PackManager.resolve_alpha_leave()
			return _result("He didn't accept the confrontation. It came to force, and you came off worse. You left with the young before it went further.")
	return _no_event()


func _build_alpha_forced_confrontation() -> Dictionary:
	_pending_threat = {
		"fight_power":   randf_range(0.45, 0.75),
		"speed":         randf_range(0.45, 0.65),
		"size":          GameState.size + 1,
		"opponent_size": GameState.size,
		"group_size":    0,
	}
	var attacker = {
		"fight_power":   GameState.strength,
		"size":          GameState.size,
		"opponent_size": _pending_threat["size"],
		"group_size":    0,
	}
	var context = CombatResolver.get_context_clue(attacker, _pending_threat)
	return {
		"type": "threat", "next_context": "threat",
		"flavor": "He stopped waiting. The pack cleared space around you two without being asked. It is happening now.\n\n%s" % context,
		"choices": [
			{ "label": "Fight him",        "icon": "attack", "sublabel": "Hold your place in the pack",    "action": "fight" },
			{ "label": "Back down",        "icon": "stalk",  "sublabel": "Submit — end it without blood", "action": "watch" },
			{ "label": "Run with the young","icon": "flee",  "sublabel": "Get them out now",               "action": "flee" },
		],
	}


# ── SPECIES-SPECIFIC EVENTS ──────────────────────────────────────────────────

func _resolve_comp_pack_flanking(choice: String) -> Dictionary:
	match choice:
		"signal_flanks":
			if GameState.pack_bond >= 0.50:
				GameState.hunger = minf(1.0, GameState.hunger + 0.35)
				GameState.kills += 1
				GameState.fights_won += 1
				PackManager.modify_bond(0.05)
				return _result("Both groups moved at the same moment. The prey had no read on which way to break. Everyone fed.")
			if GameState.pack_bond > 0.0:
				GameState.hunger = minf(1.0, GameState.hunger + 0.18)
				GameState.kills += 1
				return _result("The timing was off. One flank moved early. The prey found a gap. You got something, but not what was planned.")
			return _result("No pack to signal. The flanking plan collapsed to a solo rush. The prey made cover.")
		"rush_alone":
			return _build_prey_encounter(false)
	return _no_event()


func _resolve_deinon_killing_strike(choice: String) -> Dictionary:
	match choice:
		"killing_leap":
			var precision := GameState.strength * 0.6 + GameState.type_stat * 0.4
			if precision >= 0.55:
				GameState.hunger = minf(1.0, GameState.hunger + 0.40)
				GameState.kills += 1
				GameState.fights_won += 1
				return _result("You left the ground at the exact moment. The claw found the right place. It was immediate. The pack moved in.")
			GameState.hunger = minf(1.0, GameState.hunger + 0.15)
			GameState.kills += 1
			_apply_injury({ "name": "Landing Impact", "stat": "speed", "amount": -0.10, "turns": 2 })
			return _result("The strike landed but the angle was off. You came away with a kill and a leg that does not feel right.")
		"group_press":
			if GameState.pack_bond > 0.0:
				GameState.hunger = minf(1.0, GameState.hunger + 0.28)
				GameState.kills += 1
				GameState.fights_won += 1
				return _result("The pack wore it down together. Slower than the leap, but everyone came away clean.")
			return _build_prey_encounter(false)
		"back_off_reset":
			PackManager.modify_bond(0.05)
			return _result("You held. The pack held with you. Sometimes the pack that waits is the one still whole tomorrow.")
	return _no_event()


func _resolve_micro_canopy_launch(choice: String) -> Dictionary:
	match choice:
		"four_wing_dive":
			var flight_skill := GameState.speed * 0.5 + GameState.type_stat * 0.5
			if flight_skill >= 0.55:
				GameState.hunger = minf(1.0, GameState.hunger + 0.25)
				GameState.kills += 1
				GameState.fights_won += 1
				return _result("All four wings engaged in the dive. Nothing that size falls that fast. The prey had no warning. Clean strike.")
			GameState.hunger = minf(1.0, GameState.hunger + 0.08)
			return _result("The angle was slightly wrong. You clipped it and it spun away. Something off the impact, but not the kill.")
		"glide_to_prey":
			GameState.hunger = minf(1.0, GameState.hunger + 0.12)
			GameState.kills += 1
			return _result("A controlled glide to the clearing edge. The prey did not have time to orient to your approach angle.")
		"watch_from_here":
			GameState.apply_temp_buff("type_stat", 0.08, 2, "canopy_vantage")
			return _result("You held the perch and watched. The clearing told you where everything was moving. You know this ground better now.")
	return _no_event()


func _resolve_troodon_night_sense(choice: String) -> Dictionary:
	match choice:
		"stalk_now":
			var night_skill := GameState.type_stat * 0.7 + GameState.speed * 0.3
			if night_skill >= 0.50:
				GameState.hunger = minf(1.0, GameState.hunger + 0.30)
				GameState.kills += 1
				GameState.fights_won += 1
				GameState.night_hunts += 1
				return _result("You moved on the sound alone. In this dark your senses gave you information the prey had no way of knowing you had.")
			return _build_prey_encounter(true)
		"mark_and_wait":
			GameState.apply_temp_buff("type_stat", 0.10, 3, "troodon_patience")
			return _result("You held position and mapped every sound in the area. By the time you moved you understood the space completely.")
	return _no_event()


func _resolve_dilo_ambush_cover(choice: String) -> Dictionary:
	match choice:
		"burst_strike":
			if GameState.type_stat >= 0.55:
				GameState.hunger = minf(1.0, GameState.hunger + 0.40)
				GameState.kills += 1
				GameState.fights_won += 1
				return _result("The stillness paid off. By the time it registered the movement you were already there. A clean kill from ambush.")
			return _build_prey_encounter(false)
		"hold_longer":
			GameState.hunger = maxf(0.0, GameState.hunger - 0.04)
			GameState.apply_temp_buff("type_stat", 0.12, 2, "dilo_patience")
			return _result("You stayed still longer than necessary. The prey fully relaxed. The opening next turn will be better for it.")
		"abort":
			return _result("You backed off quietly. It never knew you were there. The patience was not wasted.")
	return _no_event()


func _resolve_bambi_terrain_gap(choice: String) -> Dictionary:
	match choice:
		"follow_through":
			if GameState.speed >= 0.70:
				GameState.hunger = minf(1.0, GameState.hunger + 0.22)
				GameState.kills += 1
				return _result("You pushed through the gap before it could turn around. On the other side nowhere left to run. Clean.")
			GameState.miles_traveled += 0.5
			return _result("You made it through but lost a step in the squeeze. The prey was already clear. You found its trail.")
		"cut_around":
			GameState.miles_traveled += 1.0
			return _result("You took the long way around. The prey was gone, but you know this terrain now.")
	return _no_event()


func _resolve_ornith_lizard_burst(choice: String) -> Dictionary:
	match choice:
		"give_chase":
			if GameState.speed >= 0.65:
				GameState.hunger = minf(1.0, GameState.hunger + 0.12)
				GameState.kills += 1
				return _result("Two strides and you were on it. Small and fast, but not fast enough. A quick meal.")
			return _result("It was faster through the roots than you read. You gave up the chase after twenty lengths.")
		"snap_at_it":
			if randf() < 0.55:
				GameState.hunger = minf(1.0, GameState.hunger + 0.08)
				GameState.kills += 1
				return _result("Pure reflex. It landed in your grip before the thought completed.")
			return _result("You snapped too early. It swerved under your lunge and was gone.")
	return _no_event()


func _resolve_hypsi_alarm_sprint(choice: String) -> Dictionary:
	match choice:
		"lead_the_run":
			PackManager.modify_bond(0.06)
			GameState.apply_temp_buff("speed", 0.10, 2, "herd_sprint")
			return _result("You called the direction and they followed. Whatever triggered the alarm fell behind. They know you read it first.")
		"sprint_edge":
			GameState.apply_temp_buff("speed", 0.12, 2, "solo_sprint")
			GameState.miles_traveled += 1.5
			return _result("You peeled off and ran your own line. Faster alone, and you were clear before the cause caught up.")
		"hold_ground":
			if randf() < 0.35:
				return _result("False alarm. Something small in the brush. You held and it passed. The herd saw you hold.")
			GameState.health = maxf(0.0, GameState.health - 0.12)
			_apply_injury({ "name": "Stampede Impact", "stat": "defense", "amount": -0.08, "turns": 2 })
			return _result("The herd came through your position. The mass of them hit you on the way past. Still standing.")
	return _no_event()


func _resolve_fruitaden_dense_cover(choice: String) -> Dictionary:
	match choice:
		"move_through":
			GameState.apply_temp_buff("type_stat", 0.15, 3, "dense_cover")
			GameState.miles_traveled += 0.5
			return _result("You pushed through at ground level. Invisible in it. Anything looking for you gave up at the edge.")
		"forage_hidden":
			GameState.hunger = minf(1.0, GameState.hunger + 0.15)
			GameState.apply_temp_buff("type_stat", 0.08, 2, "cover_forage")
			return _result("You fed in the middle of it. Slow, thorough, undetected. The size that complicates everything else was exactly right here.")
	return _no_event()


func _resolve_yi_qi_night_glide(choice: String) -> Dictionary:
	match choice:
		"extend_range":
			GameState.miles_traveled += 3.0
			GameState.apply_temp_buff("type_stat", 0.12, 2, "night_thermal")
			return _result("The membrane held the air and you crossed distance nothing else could cover at this hour. The night was entirely yours.")
		"strike_from_dark":
			GameState.night_hunts += 1
			var flight_skill := GameState.speed * 0.4 + GameState.type_stat * 0.6
			if flight_skill >= 0.55:
				GameState.hunger = minf(1.0, GameState.hunger + 0.22)
				GameState.kills += 1
				return _result("You came out of complete dark. The prey read the air but could not locate the direction in time.")
			return _build_prey_encounter(true)
		"roost":
			GameState.health = minf(1.0, GameState.health + 0.08)
			return _result("You found a sheltered fold in the rock. The membrane kept the warmth in. By morning you were restored.")
	return _no_event()


func _resolve_archae_mode_switch(choice: String) -> Dictionary:
	match choice:
		"climb_and_glide":
			GameState.fights_fled += 1
			GameState.apply_temp_buff("speed", 0.10, 2, "glide_escape")
			return _result("You went up. Three moves: trunk, branch, air. Whatever was behind you stopped at the base of the tree. Already a hundred lengths ahead.")
		"sprint_and_dodge":
			var evade := GameState.speed * 0.6 + GameState.defense * 0.4
			if evade >= 0.50:
				GameState.fights_fled += 1
				GameState.miles_traveled += 1.0
				return _result("You cut hard across open ground and made cover before it closed the distance.")
			GameState.health = maxf(0.0, GameState.health - 0.14)
			_apply_injury({ "name": "Pursuit Wound", "stat": "speed", "amount": -0.08, "turns": 2 })
			return _result("It was faster than you read. You made cover but it caught you at the edge. Through, but not clean.")
		"turn_and_fight":
			return _build_prey_encounter(false)
	return _no_event()


func _resolve_nemi_canopy_thread(choice: String) -> Dictionary:
	match choice:
		"take_shortcut":
			GameState.miles_traveled += 3.0
			GameState.type_stat = maxf(0.0, GameState.type_stat - 0.04)
			return _result("You pushed through the corridor at speed. The canopy closed behind you immediately. New ground on the other side.")
		"go_around":
			GameState.miles_traveled += 0.8
			return _result("You took the long route. You know where the corridor opens now.")
		"land_and_walk":
			GameState.hunger = maxf(0.0, GameState.hunger - 0.05)
			return _result("You landed and moved through at ground level. At your scale the undergrowth is navigable. Cost energy, crossed quietly.")
	return _no_event()


# ── DISCOVERY / AMBIGUOUS ─────────────────────────────────────────────────────

func _resolve_tar_seep(choice: String) -> Dictionary:
	match choice:
		"wade_in":
			if randf() < 0.60:
				GameState.hunger = minf(1.0, GameState.hunger + 0.30)
				GameState.kills += 1
				return _result("The preserved meat was real. You pulled enough free to eat well. Getting out was harder than getting in, but you made it.")
			GameState.health = maxf(0.0, GameState.health - 0.08)
			GameState.apply_temp_buff("speed", -0.20, 3, "tar_stuck")
			_apply_injury({ "name": "Tar Coat", "stat": "speed", "amount": -0.10, "turns": 3 })
			return _result("The ground shifted under you. You got in deeper than intended. The tar is on your legs and it is not coming off quickly.")
		"probe_edge":
			if randf() < 0.80:
				GameState.hunger = minf(1.0, GameState.hunger + 0.15)
				return _result("You pulled what you could reach from solid ground. Less than the full prize, but you're clean and mobile.")
			GameState.apply_temp_buff("speed", -0.10, 2, "tar_slip")
			return _result("Your footing went at the edge. You pulled back fast — still free, but slower for the rest of the day.")
		"leave":
			return _roll_leave_consequence()
	return _no_event()


func _resolve_cave_hollow(choice: String) -> Dictionary:
	match choice:
		"enter_cave":
			var roll := randf()
			if roll < 0.40:
				GameState.health = minf(1.0, GameState.health + 0.10)
				return _result("Empty. The air inside is warm and still. You rested in the dark and emerged restored.")
			elif roll < 0.70:
				GameState.hunger = minf(1.0, GameState.hunger + 0.20)
				GameState.kills += 1
				return _result("Something small had been using the back of the cave. It had nowhere to go. An easy meal in the dark.")
			# Something is in there
			GameState.health = maxf(0.0, GameState.health - 0.14)
			_apply_injury({ "name": "Cave Clash", "stat": "defense", "amount": -0.08, "turns": 2 })
			return _result("You made it three steps in before the occupant responded. Getting out cost you something. Whatever it was, it stays in there.")
		"check_entrance":
			if randf() < 0.70:
				GameState.health = minf(1.0, GameState.health + 0.08)
				return _result("The smell at the entrance told you enough. Empty, and warm. You rested at the threshold and moved on restored.")
			GameState.health = maxf(0.0, GameState.health - 0.10)
			_apply_injury({ "name": "Ambush Bite", "stat": "speed", "amount": -0.06, "turns": 2 })
			return _result("Something came out before you'd read it. You backed off fast but not fast enough. It didn't follow far.")
		"leave":
			return _no_event()
	return _no_event()


func _resolve_glowing_pool(choice: String) -> Dictionary:
	match choice:
		"drink_pool":
			if randf() < 0.55:
				GameState.health = minf(1.0, GameState.health + 0.10)
				GameState.apply_temp_buff("defense", 0.10, 3, "mineral_pool")
				return _result("Whatever is in the water settled well. You feel it — a clarity, a steadiness in the body. The tracks were right.")
			GameState.health = maxf(0.0, GameState.health - 0.12)
			_apply_injury({ "name": "Gut Sickness", "stat": "strength", "amount": -0.10, "turns": 3 })
			return _result("The tracks were old. Whatever made them survived because they were bigger, or luckier. Your body is working to clear this.")
		"smell_first":
			if randf() < 0.75:
				GameState.health = minf(1.0, GameState.health + 0.08)
				GameState.apply_temp_buff("defense", 0.08, 2, "mineral_pool")
				return _result("The smell was mineral, not rot. You drank carefully and kept watch. The body responded well.")
			GameState.health = maxf(0.0, GameState.health - 0.06)
			return _result("It smelled almost fine. The taste told you partway through. You stopped early. The effects are mild but real.")
		"leave":
			return _no_event()
	return _no_event()


func _resolve_fallen_nest(choice: String) -> Dictionary:
	match choice:
		"raid_eggs":
			if randf() < 0.65:
				GameState.hunger = minf(1.0, GameState.hunger + 0.20)
				return _result("The eggs were intact and unguarded. You took them fast and moved. No pursuit.")
			# Parent returns
			GameState.health = maxf(0.0, GameState.health - 0.15)
			_apply_injury({ "name": "Nest Defense Strike", "stat": "defense", "amount": -0.08, "turns": 2 })
			return _result("The parent came back mid-raid. It was larger than the nest suggested. You got out with something, but paid for it.")
		"watch_sky":
			if randf() < 0.75:
				GameState.hunger = minf(1.0, GameState.hunger + 0.15)
				return _result("Clear. You took the eggs at your own pace. Nothing came back for them.")
			return _result("The eggs had already cooled before they hit the ground. Nothing worth eating.")
		"leave":
			return _no_event()
	return _no_event()


func _resolve_bone_cache(choice: String) -> Dictionary:
	match choice:
		"dig_cache":
			if randf() < 0.65:
				GameState.hunger = minf(1.0, GameState.hunger + 0.25)
				return _result("Cached meat, mostly intact. Whatever buried it left enough seasons ago that the claim is yours now.")
			# Attracted something
			GameState.health = maxf(0.0, GameState.health - 0.12)
			_apply_injury({ "name": "Cache Confrontation", "stat": "speed", "amount": -0.06, "turns": 2 })
			return _result("The smell brought something in before you'd finished. It challenged immediately. You gave up the cache and left with a reminder.")
		"scent_first":
			if randf() < 0.80:
				GameState.hunger = minf(1.0, GameState.hunger + 0.20)
				return _result("Clear. The cache had been sitting untended for a while. You dug it up and ate without competition.")
			# Still owned
			GameState.health = maxf(0.0, GameState.health - 0.10)
			_apply_injury({ "name": "Cache Dispute", "stat": "defense", "amount": -0.06, "turns": 2 })
			return _result("The owner hadn't gone far. It came back fast. You disengaged before it got worse, but the cache wasn't worth finishing.")
		"leave":
			return _roll_leave_consequence()
	return _no_event()


func _resolve_sleeping_creature(choice: String) -> Dictionary:
	match choice:
		"ambush_sleeping":
			if randf() < 0.60:
				GameState.hunger = minf(1.0, GameState.hunger + 0.35)
				GameState.kills += 1
				return _result("It didn't fully register what was happening before it was over. A clean strike on a sleeping target.")
			# Wakes and fights
			GameState.health = maxf(0.0, GameState.health - 0.18)
			_apply_injury({ "name": "Startled Prey Strike", "stat": "speed", "amount": -0.10, "turns": 3 })
			GameState.fights_lost += 1
			return _result("It woke mid-strike. The panic response was faster than the sleep suggested. You got out, but it cost you significantly.")
		"circle_it":
			if randf() < 0.80:
				GameState.hunger = minf(1.0, GameState.hunger + 0.30)
				GameState.kills += 1
				return _result("You took the time to find the right angle. One committed strike. It barely registered before it was done.")
			# Partially wakes — you're in position
			GameState.health = maxf(0.0, GameState.health - 0.08)
			GameState.fights_won += 1
			GameState.hunger = minf(1.0, GameState.hunger + 0.20)
			return _result("It stirred while you were moving into position. You committed anyway — it was awake but disoriented. You took damage, but you won.")
		"leave":
			if randf() < 0.10:
				GameState.health = maxf(0.0, GameState.health - 0.10)
				_apply_injury({ "name": "Ambush Reversal", "stat": "speed", "amount": -0.08, "turns": 2 })
				return _result("It was already awake. The moment you turned it moved. It had been watching you the whole time.")
			return _no_event()
	return _no_event()


func _resolve_strange_growth(choice: String) -> Dictionary:
	match choice:
		"eat_freely":
			if randf() < 0.45:
				GameState.health = minf(1.0, GameState.health + 0.10)
				GameState.apply_temp_buff("defense", 0.10, 2, "strange_growth_buff")
				return _result("The body took to it. Whatever the growth contains settled well. You feel more resistant than before. The others who ate here were right.")
			GameState.health = maxf(0.0, GameState.health - 0.14)
			_apply_injury({ "name": "Toxin", "stat": "strength", "amount": -0.12, "turns": 3 })
			return _result("The others who ate here survived because they ate less. The body is working against it now. You'll clear it, but not quickly.")
		"taste_carefully":
			if randf() < 0.65:
				GameState.health = minf(1.0, GameState.health + 0.07)
				GameState.apply_temp_buff("defense", 0.06, 2, "strange_growth_mild")
				return _result("A small amount, waited to see. The response was good. Whatever is in it, your body accepted it.")
			GameState.health = maxf(0.0, GameState.health - 0.06)
			return _result("The small amount limited the damage. You felt the warning in time to stop. Something is moving through the system but it'll pass.")
		"leave":
			return _no_event()
	return _no_event()


# ── WINTER EXPANDED ───────────────────────────────────────────────────────────

func _resolve_migrant_stragglers(choice: String) -> Dictionary:
	match choice:
		"straggler_attack":
			var power := GameState.strength * 0.6 + GameState.speed * 0.4
			if power >= 0.40:
				GameState.hunger = minf(1.0, GameState.hunger + 0.40)
				GameState.kills += 1
				return _result("It was already spent. The cold had done most of the work before you found it.")
			GameState.health = maxf(0.0, GameState.health - 0.10)
			GameState.hunger = minf(1.0, GameState.hunger + 0.25)
			GameState.kills += 1
			return _result("Weaker than it looked but not helpless. You took it, but the cold made you pay for the effort.")
		"straggler_circle":
			GameState.hunger = minf(1.0, GameState.hunger + 0.45)
			GameState.kills += 1
			return _result("You waited for the angle. When it stumbled you were already in position. A clean end to a cold hunt.")
		"leave":
			return _roll_leave_consequence()
	return _no_event()


func _resolve_storm_driven_prey(choice: String) -> Dictionary:
	match choice:
		"intercept_prey":
			var hunt_power := GameState.speed * 0.5 + GameState.strength * 0.5
			if hunt_power >= 0.45:
				GameState.hunger = minf(1.0, GameState.hunger + 0.38)
				GameState.kills += 1
				return _result("You cut it off before it found direction. The blizzard was working for you as much as against you.")
			GameState.health = maxf(0.0, GameState.health - 0.08)
			GameState.hunger = minf(1.0, GameState.hunger + 0.20)
			GameState.kills += 1
			return _result("The wind threw off the approach. You still took it but the fight was messier than it needed to be in this cold.")
		"follow_exhausted":
			GameState.hunger = minf(1.0, GameState.hunger + 0.42)
			GameState.kills += 1
			return _result("You tracked it at distance and let the storm do the work. When it stopped moving you were right there.")
		"leave":
			return _no_event()
	return _no_event()


func _resolve_frozen_kill_theft(choice: String) -> Dictionary:
	match choice:
		"drive_off_scavenger":
			if randf() < 0.70:
				GameState.hunger = minf(1.0, GameState.hunger + 0.30)
				return _result("It read you correctly and retreated. You had the kill to yourself.")
			GameState.health = maxf(0.0, GameState.health - 0.08)
			GameState.hunger = minf(1.0, GameState.hunger + 0.20)
			return _result("It didn't go without a response. You drove it off eventually and took the kill, but not cleanly.")
		"rush_kill":
			GameState.hunger = minf(1.0, GameState.hunger + 0.25)
			return _result("You came in fast and it scattered. The kill was already partially eaten but there was enough left.")
		"wait_departure":
			if randf() < 0.55:
				GameState.hunger = minf(1.0, GameState.hunger + 0.22)
				return _result("It finished and moved on. You moved in behind it and took the remains. Cold-preserved — enough to matter.")
			return _result("It stayed. You waited until the cold made waiting cost too much and moved on. Nothing gained.")
	return _no_event()


func _resolve_ice_shelf_collapse(choice: String) -> Dictionary:
	match choice:
		"cross_fast":
			var size_risk := float(GameState.size) / 5.0
			if randf() > size_risk * 0.6:
				return _result("The ice held. You were across before the weight had time to matter. Whatever was on the far side was worth the crossing.")
			GameState.health = maxf(0.0, GameState.health - 0.20)
			_apply_injury({ "name": "Ice Break", "stat": "speed", "amount": -0.12, "turns": 3 })
			return _result("The ice gave partway across. You made the far bank but the cold water found every gap. Moving is harder now.")
		"cross_careful":
			var size_risk := float(GameState.size) / 5.0
			if randf() > size_risk * 0.35:
				return _result("Slow and deliberate. Each step tested before you committed your weight. You crossed without incident.")
			GameState.health = maxf(0.0, GameState.health - 0.12)
			_apply_injury({ "name": "Cold Soak", "stat": "strength", "amount": -0.08, "turns": 2 })
			return _result("Even carefully it broke near the bank. You got out fast. Cold and slower for it, but across.")
		"leave":
			return _no_event()
	return _no_event()


func _resolve_starvation_rival(choice: String) -> Dictionary:
	match choice:
		"drive_rival":
			if randf() < 0.65:
				GameState.fights_won += 1
				return _result("It backed down fast. Desperation had taken the fight out of it before you even closed the distance.")
			GameState.health = maxf(0.0, GameState.health - 0.12)
			GameState.fights_won += 1
			_apply_injury({ "name": "Desperate Bite", "stat": "defense", "amount": -0.06, "turns": 2 })
			return _result("It had nothing to lose and fought like it. You drove it off eventually. Cost you more than it should have.")
		"hold_rival":
			if randf() < 0.60:
				return _result("You held your ground and it eventually moved on. Not a threat — just a creature running out of options.")
			GameState.health = maxf(0.0, GameState.health - 0.08)
			_apply_injury({ "name": "Ambush Snap", "stat": "speed", "amount": -0.05, "turns": 2 })
			return _result("It made a move while you were watching. Not from strength — from nothing left to lose. You backed it off.")
		"leave":
			return _no_event()
	return _no_event()


func _resolve_frost_hollow(choice: String) -> Dictionary:
	match choice:
		"claim_hollow":
			if randf() < 0.60:
				GameState.health = minf(1.0, GameState.health + 0.12)
				GameState.fights_won += 1
				return _result("They read the display and cleared out. The warmth in the hollow was real. You emerged in better shape than you entered.")
			GameState.health = maxf(0.0, GameState.health - 0.08)
			GameState.health = minf(1.0, GameState.health + 0.08)
			GameState.fights_won += 1
			return _result("One of them pushed back. You settled it but the hollow evened out the injury cost. Still warmer than the alternative.")
		"share_hollow":
			GameState.health = minf(1.0, GameState.health + 0.08)
			return _result("The others tolerated the arrangement. The warmth was shared out. Less than claiming it fully but better than the open cold.")
		"wait_hollow":
			if randf() < 0.45:
				GameState.health = minf(1.0, GameState.health + 0.10)
				return _result("One left eventually. You moved in behind it and had the hollow to yourself through the worst of the cold.")
			return _result("Nobody left. You circled until the waiting cost more than it would have been worth. The open night took its toll.")
	return _no_event()


func _resolve_winter_burrow(choice: String) -> Dictionary:
	match choice:
		"take_burrow":
			if randf() < 0.50:
				GameState.health = minf(1.0, GameState.health + 0.14)
				return _result("Empty. The warmth of old occupation was still in the walls. You slept in something close to comfort.")
			GameState.health = maxf(0.0, GameState.health - 0.10)
			_apply_injury({ "name": "Burrow Bite", "stat": "defense", "amount": -0.06, "turns": 2 })
			return _result("Something was still inside. Small — but frantic and cornered. You cleared it out and took the burrow. Not cleanly.")
		"scout_burrow":
			if randf() < 0.75:
				GameState.health = minf(1.0, GameState.health + 0.12)
				return _result("Empty. You checked at the entrance before committing. The warmth inside was real and you had it to yourself.")
			return _result("Occupied. Whatever made those scratches was still in there and made the smell very clear from the entrance. You moved on.")
		"leave":
			return _no_event()
	return _no_event()


func _resolve_ice_fish_run(choice: String) -> Dictionary:
	match choice:
		"wade_fish":
			GameState.hunger = minf(1.0, GameState.hunger + 0.35)
			GameState.health = maxf(0.0, GameState.health - 0.05)
			return _result("The cold hit immediately. You worked fast and got out with enough to matter. The chill stayed in the legs for a while.")
		"bank_fish":
			GameState.hunger = minf(1.0, GameState.hunger + 0.18)
			return _result("Fewer fish from this angle, but you stayed dry. In this cold that's worth the difference.")
		"leave":
			return _no_event()
	return _no_event()


func _resolve_desperate_feeding(choice: String) -> Dictionary:
	match choice:
		"eat_desperate":
			if randf() < 0.55:
				GameState.hunger = minf(1.0, GameState.hunger + 0.18)
				return _result("Something. Not good, but enough. The body accepted it without protest.")
			GameState.hunger = minf(1.0, GameState.hunger + 0.08)
			GameState.health = maxf(0.0, GameState.health - 0.08)
			return _result("The body got something, but it's fighting the rest of it. You're less hungry and more unwell.")
		"investigate_food":
			if randf() < 0.70:
				GameState.hunger = minf(1.0, GameState.hunger + 0.15)
				return _result("Checking first gave you enough information to eat the right parts and leave the rest. A small gain, cleanly taken.")
			return _result("You investigated until it was clear there was nothing worth the risk. Moved on hungry.")
		"leave":
			return _no_event()
	return _no_event()


func _resolve_whiteout(choice: String) -> Dictionary:
	match choice:
		"push_through":
			var nav := GameState.speed * 0.4 + GameState.type_stat * 0.6
			if nav >= 0.45 or randf() < 0.55:
				GameState.miles_traveled += 1.0
				return _result("You kept moving and your sense of it held. When the storm thinned you were where you needed to be.")
			GameState.health = maxf(0.0, GameState.health - 0.10)
			GameState.hunger = maxf(0.0, GameState.hunger - 0.08)
			return _result("The direction drifted. You came out of the whiteout in the wrong place, depleted from the effort.")
		"shelter_wait":
			GameState.health = minf(1.0, GameState.health + 0.06)
			return _result("You found a windbreak and held until the storm passed. Cost time and a little warmth, but you came out oriented.")
		"navigate_careful":
			GameState.miles_traveled += 0.5
			return _result("Slow. You checked every landmark you could find through the white. It took everything but you came through in the right place.")
	return _no_event()


func _resolve_carrion_circuit(choice: String) -> Dictionary:
	match choice:
		"track_killer":
			if randf() < 0.40:
				GameState.strength = minf(1.0, GameState.strength + 0.04)
				GameState.permanent_defense_mod += 0.03
				GameState.defense = minf(1.0, GameState.defense + 0.03)
				GameState.bonuses_earned.append("Winter Watcher — Defense increased")
				return _result("You found it. Watched it hunt from distance. The pattern it uses is something you can use. The memory of it will hold.")
			GameState.health = maxf(0.0, GameState.health - 0.15)
			_apply_injury({ "name": "Apex Encounter", "stat": "defense", "amount": -0.10, "turns": 3 })
			GameState.fights_lost += 1
			return _result("You found it. It found you first. You disengaged and survived, but the encounter cost you significantly.")
		"feed_and_go":
			GameState.hunger = minf(1.0, GameState.hunger + 0.28)
			if randf() < 0.35:
				GameState.health = maxf(0.0, GameState.health - 0.12)
				_apply_injury({ "name": "Apex Interruption", "stat": "speed", "amount": -0.08, "turns": 2 })
				return _result("It came back while you were feeding. You got clear but whatever makes those kills doesn't negotiate.")
			return _result("You fed fast and moved. Nothing came back for it while you were there.")
		"leave":
			return _no_event()
	return _no_event()


func _resolve_pack_split_winter(choice: String) -> Dictionary:
	match choice:
		"lead_pack_forward":
			if GameState.pack_bond > 0.0:
				PackManager.modify_bond(0.08)
				return _result("You moved first. The hesitant ones followed. The pack held and the direction was right.")
			return _no_event()
		"hold_pack_together":
			if GameState.pack_bond > 0.0:
				PackManager.modify_bond(0.04)
				return _result("You found the middle ground. Nobody got what they wanted fully, but the pack moved as one.")
			return _no_event()
		"split_from_pack":
			if GameState.pack_bond > 0.0:
				GameState.apply_temp_buff("speed", 0.10, 3, "solo_winter")
				COMPANIONS.group_response(-0.15, "You went ahead alone while the group faced winter.")
				PackManager.modify_bond(-0.15)
				return _result("You moved alone. Faster without them — for now. The bond frayed. Winter alone has its own costs.")
			return _no_event()
	return _no_event()


# ── TIER 4 / 3 SPECIES-SPECIFIC ──────────────────────────────────────────────

func _resolve_raptor_pack_strike(choice: String) -> Dictionary:
	match choice:
		"signal_flanks":
			var coord := GameState.type_stat * 0.5 + (GameState.pack_bond) * 0.5
			if coord + randf() * 0.4 >= 0.55:
				var gain := randf_range(0.35, 0.55)
				GameState.hunger = minf(1.0, GameState.hunger + gain)
				GameState.kills += 1
				GameState.fights_won += 1
				GameState.strength = minf(1.0, GameState.strength + 0.01)
				PackManager.modify_bond(0.06)
				return _result("Both flanks closed at once. The prey had nowhere to run. The pack worked perfectly.")
			else:
				GameState.hunger = minf(1.0, GameState.hunger + 0.15)
				return _result("The signal was right but the timing slipped. One flank hit early. You got a partial feed.")
		"rush_in_solo":
			var atk := { "fight_power": GameState.strength, "size": GameState.size, "opponent_size": GameState.size + 1, "group_size": 0 }
			var prey := { "fight_power": 0.30, "size": GameState.size, "hunger_value": 0.45, "opponent_size": GameState.size }
			return _apply_combat_result(CombatResolver.resolve(atk, prey), prey, true)
		"leave":
			return _no_event()
	return _no_event()


func _resolve_carno_full_sprint(choice: String) -> Dictionary:
	match choice:
		"full_sprint":
			var close := GameState.speed * 0.7 + randf() * 0.3
			if close >= 0.65:
				var gain := randf_range(0.40, 0.60)
				GameState.hunger = minf(1.0, GameState.hunger + gain)
				GameState.kills += 1
				GameState.fights_won += 1
				GameState.speed = minf(1.0, GameState.speed + 0.01)
				return _result("You closed the distance before it could read the threat. Clean run, clean kill.")
			elif close >= 0.45:
				GameState.hunger = minf(1.0, GameState.hunger + 0.22)
				return _result("You closed it but not cleanly. Partial feed.")
			else:
				return _result("It broke before you reached it. Nothing to show for the run.")
		"cut_wide":
			if GameState.speed * 0.4 + randf() * 0.5 >= 0.55:
				GameState.hunger = minf(1.0, GameState.hunger + randf_range(0.22, 0.38))
				GameState.kills += 1
				return _result("The wide angle worked. Slower but cleaner. You fed.")
			return _result("The wide arc cost too much time. It was gone before you closed in.")
		"leave":
			return _no_event()
	return _no_event()


func _resolve_allo_displacement(choice: String) -> Dictionary:
	match choice:
		"walk_in_direct":
			if GameState.size >= 7:
				GameState.hunger = minf(1.0, GameState.hunger + randf_range(0.55, 0.80))
				return _result("You walked into the clearing. They read your size and left without hesitation. The kill was yours before you reached it.")
			elif GameState.size >= 5 and randf() < 0.80:
				GameState.hunger = minf(1.0, GameState.hunger + randf_range(0.45, 0.70))
				return _result("Two of the three scattered immediately. The third held a moment, then thought better of it.")
			elif GameState.size >= 5:
				var atk := { "fight_power": GameState.strength, "size": GameState.size, "opponent_size": GameState.size - 2, "group_size": PackManager.get_virtual_group_size() }
				var rival := { "fight_power": 0.35, "size": GameState.size - 2, "hunger_value": 0.60, "opponent_size": GameState.size }
				return _apply_combat_result(CombatResolver.resolve(atk, rival), rival, false)
			else:
				if randf() < 0.55:
					GameState.hunger = minf(1.0, GameState.hunger + randf_range(0.35, 0.55))
					return _result("They read your approach and gave ground. The kill was yours.")
				return _result("They held. You weren't large enough to settle it by presence alone.")
		"charge_scatter":
			GameState.hunger = minf(1.0, GameState.hunger + randf_range(0.50, 0.75))
			GameState.kills += 1
			if randf() < 0.20:
				GameState.apply_injury({ "name": "Glancing bite", "stat": "defense", "amount": -0.10, "turns": 2 })
				return _result("They scattered. One caught you on the way out. Minor. The kill was worth it.")
			return _result("They scattered. You took the kill before the dust settled.")
		"leave":
			return _no_event()
	return _no_event()


func _resolve_troodon_circuit(choice: String) -> Dictionary:
	match choice:
		"run_circuit":
			var night := GameState.type_stat * 0.6 + (GameState.pack_bond) * 0.4
			if night + randf() * 0.25 >= 0.65:
				GameState.hunger = minf(1.0, GameState.hunger + randf_range(0.45, 0.65))
				GameState.kills += 2
				GameState.fights_won += 1
				GameState.night_hunts += 1
				GameState.type_stat = minf(1.0, GameState.type_stat + 0.01)
				PackManager.modify_bond(0.05)
				return _result("The circuit ran clean. The pack moved at your signal. Two kills before the prey population understood what was happening.")
			else:
				GameState.hunger = minf(1.0, GameState.hunger + randf_range(0.18, 0.30))
				GameState.night_hunts += 1
				return _result("The circuit ran but the timing broke down in the dark. One clean kill, not two.")
		"solo_advance_night":
			if GameState.type_stat * 0.7 + randf() * 0.3 >= 0.70:
				GameState.hunger = minf(1.0, GameState.hunger + randf_range(0.28, 0.42))
				GameState.kills += 1
				GameState.night_hunts += 1
				GameState.type_stat = minf(1.0, GameState.type_stat + 0.01)
				return _result("You moved ahead of the pack into the dark. Your night sense found it before it found you.")
			return _result("You pushed ahead but the dark gave you less than expected. The prey scattered before you had position.")
		"leave":
			return _no_event()
	return _no_event()


func _resolve_iguan_spike_warning(choice: String) -> Dictionary:
	match choice:
		"present_spike":
			if (GameState.defense + GameState.strength) * 0.5 + randf() * 0.4 >= 0.55:
				GameState.defense = minf(1.0, GameState.defense + 0.01)
				return _result("You turned and let it see the spike. It held a moment, ran the math, and moved off. No contact.")
			else:
				var atk := { "fight_power": (GameState.strength + GameState.defense) * 0.5, "size": GameState.size, "opponent_size": GameState.size - 1, "group_size": PackManager.get_virtual_group_size() }
				var threat := { "fight_power": 0.32, "size": GameState.size - 1, "opponent_size": GameState.size }
				return _apply_combat_result(CombatResolver.resolve(atk, threat), threat, false)
		"charge_spike":
			if GameState.strength * 0.5 + GameState.defense * 0.3 + randf() * 0.4 >= 0.55:
				GameState.defense = minf(1.0, GameState.defense + 0.01)
				return _result("You drove into it before it finished calculating. The spike connected. It left fast.")
			else:
				var atk := { "fight_power": GameState.strength, "size": GameState.size, "opponent_size": GameState.size, "group_size": PackManager.get_virtual_group_size() }
				var threat := { "fight_power": 0.38, "size": GameState.size, "opponent_size": GameState.size }
				return _apply_combat_result(CombatResolver.resolve(atk, threat), threat, false)
		"retreat_herd":
			if GameState.pack_bond > 0.0:
				return _result("You moved back into the group. The predator circled once and found better odds elsewhere.")
			GameState.apply_temp_buff("speed", 0.06, 2, "spike_retreat")
			return _result("You moved off. Nothing followed.")
	return _no_event()


func _resolve_kentro_spine_array(choice: String) -> Dictionary:
	match choice:
		"hold_spine_wall":
			if GameState.defense * 0.6 + randf() * 0.4 >= 0.50:
				GameState.defense = minf(1.0, GameState.defense + 0.01)
				GameState.fights_won += 1
				return _result("They committed. The spines answered. One of them won't be making that approach again.")
			else:
				var atk := { "fight_power": GameState.defense, "size": GameState.size, "opponent_size": GameState.size + 1, "group_size": PackManager.get_virtual_group_size() }
				var threat := { "fight_power": 0.40, "size": GameState.size + 1, "opponent_size": GameState.size }
				return _apply_combat_result(CombatResolver.resolve(atk, threat), threat, false)
		"pivot_swing":
			if GameState.speed * 0.4 + GameState.defense * 0.4 + randf() * 0.3 >= 0.55:
				GameState.defense = minf(1.0, GameState.defense + 0.01)
				return _result("You turned faster than they expected. The swing caught the lead one. The second broke off.")
			else:
				var atk := { "fight_power": (GameState.speed + GameState.defense) * 0.5, "size": GameState.size, "opponent_size": GameState.size, "group_size": PackManager.get_virtual_group_size() }
				var threat := { "fight_power": 0.35, "size": GameState.size, "opponent_size": GameState.size }
				return _apply_combat_result(CombatResolver.resolve(atk, threat), threat, false)
		"flee_cover":
			if GameState.speed * 0.7 + randf() * 0.3 >= 0.50:
				return _result("You broke for the dense ground. They abandoned the approach once you were in cover.")
			GameState.health = maxf(0.0, GameState.health - randf_range(0.08, 0.16))
			return _result("They caught you at the edge of cover. You made it through but not cleanly.")
	return _no_event()


func _resolve_stego_thagomizer(choice: String) -> Dictionary:
	match choice:
		"full_swing":
			if GameState.strength * 0.4 + GameState.defense * 0.4 + randf() * 0.3 >= 0.50:
				GameState.defense = minf(1.0, GameState.defense + 0.01)
				GameState.fights_won += 1
				return _result("The tail connected before it had finished committing. It won't be making that approach again this season.")
			else:
				GameState.health = maxf(0.0, GameState.health - randf_range(0.08, 0.18))
				GameState.apply_injury({ "name": "Wrenched flank", "stat": "speed", "amount": -0.12, "turns": 2 })
				return _result("The swing was wide. It got a hit in while you were recovering.")
		"turn_face":
			if GameState.defense * 0.7 + randf() * 0.3 >= 0.50:
				GameState.defense = minf(1.0, GameState.defense + 0.01)
				return _result("You turned before it committed. It saw your full stance and thought better of it. Long stare, then it moved off.")
			else:
				var atk := { "fight_power": GameState.defense, "size": GameState.size, "opponent_size": GameState.size - 1, "group_size": PackManager.get_virtual_group_size() }
				var threat := { "fight_power": 0.35, "size": GameState.size - 1, "opponent_size": GameState.size }
				return _apply_combat_result(CombatResolver.resolve(atk, threat), threat, false)
		"lunge_forward_stego":
			if GameState.strength * 0.5 + randf() * 0.4 >= 0.50:
				return _result("You stepped into it instead of absorbing the hit. It wasn't expecting the advance. It broke off.")
			var atk := { "fight_power": GameState.strength, "size": GameState.size, "opponent_size": GameState.size, "group_size": PackManager.get_virtual_group_size() }
			var threat := { "fight_power": 0.40, "size": GameState.size, "opponent_size": GameState.size }
			return _apply_combat_result(CombatResolver.resolve(atk, threat), threat, false)
	return _no_event()


func _resolve_pachy_dome_drive(choice: String) -> Dictionary:
	match choice:
		"dome_charge":
			if GameState.strength * 0.6 + randf() * 0.5 >= 0.45 + randf() * 0.4:
				GameState.territory_bonus_turns = maxi(GameState.territory_bonus_turns, 4)
				GameState.fights_won += 1
				GameState.strength = minf(1.0, GameState.strength + 0.01)
				return _result("Clean impact. It took the hit, held a second, then walked. Your range, your season.")
			else:
				GameState.health = maxf(0.0, GameState.health - randf_range(0.10, 0.20))
				GameState.fights_lost += 1
				return _result("You hit first but it absorbed it better than you expected. Second impact went its way. Still here, but the ground shifted.")
		"display_dome":
			if GameState.type_stat * 0.6 + GameState.strength * 0.3 + randf() * 0.3 >= 0.55:
				GameState.territory_bonus_turns = maxi(GameState.territory_bonus_turns, 3)
				return _result("You held stance long enough. It read the dome and decided contact wasn't worth it.")
			else:
				if GameState.strength * 0.5 + randf() * 0.5 >= 0.55:
					GameState.territory_bonus_turns = maxi(GameState.territory_bonus_turns, 3)
					GameState.fights_won += 1
					return _result("It didn't yield to the display. The charge settled it. Your range.")
				GameState.health = maxf(0.0, GameState.health - randf_range(0.08, 0.15))
				GameState.fights_lost += 1
				return _result("It called the display. The dome charge went its way.")
		"leave":
			return _no_event()
	return _no_event()


func _resolve_ptero_colony_dive(choice: String) -> Dictionary:
	match choice:
		"lead_colony_dive":
			if GameState.type_stat * 0.5 + GameState.speed * 0.3 + randf() * 0.3 >= 0.60:
				GameState.hunger = minf(1.0, GameState.hunger + randf_range(0.38, 0.55))
				GameState.type_stat = minf(1.0, GameState.type_stat + 0.01)
				PackManager.modify_bond(0.05)
				return _result("You set the line. The colony followed. Three clean passes before the shoal broke. The colony fed well.")
			else:
				GameState.hunger = minf(1.0, GameState.hunger + randf_range(0.18, 0.28))
				return _result("The lead angle was off. The formation broke on the second pass. You fed but the colony took less than it should have.")
		"follow_colony_dive":
			GameState.hunger = minf(1.0, GameState.hunger + randf_range(0.22, 0.35))
			return _result("The colony broke the shoal. You followed in and fed. Clean and safe.")
		"circle_wait_dive":
			if randf() < 0.40:
				return _build_prey_encounter(true)
			return _result("You circled looking for a better angle. The shoal scattered before you found one.")
	return _no_event()


func _resolve_rhamph_dusk_window(choice: String) -> Dictionary:
	match choice:
		"surface_run":
			if GameState.speed * 0.5 + GameState.type_stat * 0.3 + randf() * 0.3 >= 0.55:
				GameState.hunger = minf(1.0, GameState.hunger + randf_range(0.28, 0.42))
				GameState.type_stat = minf(1.0, GameState.type_stat + 0.01)
				return _result("You ran the surface low and fast while the light held. Three passes. The fish were exactly where they always are at this hour.")
			else:
				GameState.hunger = minf(1.0, GameState.hunger + randf_range(0.12, 0.20))
				return _result("The run was good but the timing slipped on the second pass. One clean catch.")
		"precision_dive":
			var prec := GameState.type_stat * 0.7 + randf() * 0.4
			if prec >= 0.65:
				GameState.hunger = minf(1.0, GameState.hunger + randf_range(0.32, 0.50))
				GameState.type_stat = minf(1.0, GameState.type_stat + 0.02)
				return _result("One dive. You read the surface perfectly. The fish didn't see it until it was over.")
			elif prec >= 0.45:
				GameState.hunger = minf(1.0, GameState.hunger + randf_range(0.12, 0.22))
				return _result("Close. The dive was good but the fish moved at the last moment.")
			else:
				return _result("You misjudged the depth. The surface read wrong. The dive missed.")
		"leave":
			return _no_event()
	return _no_event()


func _resolve_ptero_offshore_run(choice: String) -> Dictionary:
	match choice:
		"go_offshore":
			var stamina := GameState.type_stat * 0.7 + randf() * 0.35
			if stamina >= 0.70:
				GameState.hunger = minf(1.0, GameState.hunger + randf_range(0.60, 0.90))
				GameState.type_stat = minf(1.0, GameState.type_stat + 0.02)
				GameState.miles_traveled += 80.0
				return _result("Two days out. The offshore thermals were everything. Fish schools unlike anything near the coast. You soared back full.")
			elif stamina >= 0.50:
				GameState.hunger = minf(1.0, GameState.hunger + randf_range(0.30, 0.50))
				GameState.health = maxf(0.0, GameState.health - 0.08)
				GameState.miles_traveled += 60.0
				return _result("You made it there and back, but the return thermals failed. Fed well. Paid for it.")
			else:
				GameState.health = maxf(0.0, GameState.health - 0.20)
				GameState.hunger = maxf(0.0, GameState.hunger - 0.15)
				return _result("The thermals died offshore. You flapped the entire return leg. Made it back barely.")
		"coast_work":
			GameState.hunger = minf(1.0, GameState.hunger + randf_range(0.22, 0.38))
			GameState.miles_traveled += 20.0
			return _result("You worked the coastal thermals. Lower yield than offshore — but you came back in condition.")
		"leave":
			return _no_event()
	return _no_event()


func _resolve_dsun_tidal_flat(choice: String) -> Dictionary:
	match choice:
		"feed_fast_claim":
			GameState.hunger = minf(1.0, GameState.hunger + randf_range(0.40, 0.60))
			if randf() < 0.30:
				PackManager.modify_bond(-0.08)
				return _result("You claimed the dense section first. Fed well. The colony worked the edges. The bond took a small hit.")
			return _result("You moved first and held the best section. The colony came in behind you. No real contest.")
		"feed_colony_share":
			GameState.hunger = minf(1.0, GameState.hunger + randf_range(0.25, 0.40))
			PackManager.modify_bond(0.04)
			return _result("You fed alongside the colony. The flat was wide enough. Good feed, good standing.")
		"mark_and_return":
			GameState.territory_bonus_turns = maxi(GameState.territory_bonus_turns, 3)
			GameState.hunger = minf(1.0, GameState.hunger + randf_range(0.10, 0.18))
			return _result("You fed light and memorized the location. Next tide, you will know exactly where to be before anyone else does.")
	return _no_event()


# ── ELDER END-GAME LEGENDARY EVENTS ──────────────────────────────────────────
# Fires once per run after 3 elder seasons for main-chain species.
# Two decision points. Death sets health to 0 and death_cause = "elder_event".
# Victory opens a keep_going / end_run choice handled in game_screen.gd.

const ELDER_S2 = {
	"compsognathus": {
		"a": {
			"flavor": "You cut through the narrow section of the ravine they hadn't scouted. The pack closed the second entrance on your signal. Three of them. The leader doubled back — just you and it now, in the gap you've known for six seasons.",
			"choices": [
				{ "label": "Hold the chokepoint", "icon": "stalk", "sublabel": "Let it choose retreat.", "action": "safe" },
				{ "label": "Drive forward", "icon": "attack", "sublabel": "Finish this now.", "action": "risky" },
			],
			"death_chance": { "safe": 0.15, "risky": 0.40 },
			"death_flavor": {
				"safe": "It didn't retreat. The gap was narrower than you needed. One mistake in ground you've run for six seasons.",
				"risky": "It was waiting for the commit. The counter came before you'd finished the strike.",
			},
			"win_flavor": {
				"safe": "It held the stare for a long time. Then backed out. The range is yours. The pack's challenge is over.",
				"risky": "The exchange was fast and low. It went down before it had time to recover. The pack's challenge is settled.",
			},
		},
		"b": {
			"flavor": "You moved to the center of the boundary at midday — visible, deliberate. Their leader came out to meet you. Bigger than the ones you've run off before. The exchange started immediately.",
			"choices": [
				{ "label": "Feint low, go for the flank", "icon": "stalk", "sublabel": "Read its weight, then move.", "action": "safe" },
				{ "label": "Go for the neck directly", "icon": "attack", "sublabel": "No reading, just commit.", "action": "risky" },
			],
			"death_chance": { "safe": 0.25, "risky": 0.50 },
			"death_flavor": {
				"safe": "The feint read wrong. It had anticipated the low approach. The counter came too fast.",
				"risky": "No hesitation — that was yours. The counter had no hesitation either. That was the problem.",
			},
			"win_flavor": {
				"safe": "You read the weight shift before it came. The feint worked. The bite caught flank. It broke off. The territory is settled.",
				"risky": "You went straight for the critical angle. It didn't recover from the first exchange. Decisive.",
			},
		},
	},
	"deinonychus": {
		"a": {
			"flavor": "You found him alone at the northern edge. He turned to face you but didn't posture. Just the two of you, no audience. The answer to what comes next has to happen here.",
			"choices": [
				{ "label": "Make the point and step back", "icon": "flee", "sublabel": "The message matters more than the victory.", "action": "safe" },
				{ "label": "Drive the exchange to its conclusion", "icon": "attack", "sublabel": "No ambiguity left behind.", "action": "risky" },
			],
			"death_chance": { "safe": 0.10, "risky": 0.45 },
			"death_flavor": {
				"safe": "He didn't read the message the way you intended. The exchange wasn't supposed to go this far.",
				"risky": "He was faster at the critical moment than three seasons of watching him had suggested.",
			},
			"win_flavor": {
				"safe": "You held the stance long enough for him to read it completely. He turned after a moment and moved back toward the pack. He'll work with what just happened.",
				"risky": "You committed fully. He responded fully. When it was over, you were still standing. The answer was clear to everyone who wasn't there to see it.",
			},
		},
		"b": {
			"flavor": "You called the coordinated hunt — a target that required the two of you working the flanks together. The pack followed both your positioning and his counter-movement. At the kill, you stood together over it. The pack arranged itself around both of you.",
			"choices": [
				{ "label": "Give him the first eat", "icon": "bond", "sublabel": "Secure the loyalty — this is the long move.", "action": "safe" },
				{ "label": "Eat first — you called the hunt", "icon": "attack", "sublabel": "Establish the hierarchy clearly.", "action": "risky" },
			],
			"death_chance": { "safe": 0.05, "risky": 0.25 },
			"death_flavor": {
				"safe": "You stepped back. He read it as concession rather than generosity. The move accelerated the process you were trying to prevent.",
				"risky": "You asserted the hierarchy at the wrong moment. He had the pack's attention and the response had support you hadn't fully mapped.",
			},
			"win_flavor": {
				"safe": "You stepped back at the kill. He accepted. Later at the nest boundary, he moved away when you approached. The dynamic shifted on your terms.",
				"risky": "You took first eat and held the position. He deferred. The pack read it. He stayed in the pack, under the terms.",
			},
		},
	},
	"velociraptor": {
		"a": {
			"flavor": "You coordinated the flank approach at dusk — six pack members, one isolated hadrosaur at the migration edge. The charge was committed. Two pack members took impacts before the prey went down. You are bleeding. The kill is real.",
			"choices": [
				{ "label": "Hold the kill — let the injured rest", "icon": "bond", "sublabel": "The pack comes first.", "action": "safe" },
				{ "label": "Push into the main migration for a second kill", "icon": "attack", "sublabel": "While you have momentum.", "action": "risky" },
			],
			"death_chance": { "safe": 0.15, "risky": 0.45 },
			"death_flavor": {
				"safe": "While you held position, a larger predator drawn by the noise arrived at the kill. You didn't have the pack's full strength to respond.",
				"risky": "The second push went into the densest part of the migration. The response from the herd wasn't what the first encounter had been.",
			},
			"win_flavor": {
				"safe": "The pack ate. Two injured, both recoverable. The migration passed overnight. The range is clear. You held it.",
				"risky": "The second target came down. The pack ate twice. The injuries were worth it.",
			},
		},
		"b": {
			"flavor": "You led the pack two days east to secondary ground — thinner hunting, but safe. The pack ate on the first night. The range you yielded is behind you.",
			"choices": [
				{ "label": "Rest two days, then return to claim the range", "icon": "stalk", "sublabel": "Strength back first.", "action": "safe" },
				{ "label": "Return immediately — press the claim before something fills it", "icon": "attack", "sublabel": "Speed over recovery.", "action": "risky" },
			],
			"death_chance": { "safe": 0.10, "risky": 0.30 },
			"death_flavor": {
				"safe": "During the rest period, a rival pack settled the range and had time to establish. The return was harder than projected.",
				"risky": "The pack wasn't recovered. The rapid return pushed still-injured members into another high-intensity engagement.",
			},
			"win_flavor": {
				"safe": "You returned rested. A smaller group had occupied the range. The pack removed them efficiently. The territory is yours.",
				"risky": "The rapid return caught the range open. You marked and established before nightfall. Nothing challenged the claim.",
			},
		},
	},
	"allosaurus": {
		"a": {
			"flavor": "You positioned at the center of the killing ground at dawn. It found you within an hour. The distance between you closed at a pace that made clear neither of you planned to stop.",
			"choices": [
				{ "label": "Wait for its first commitment — read the angle", "icon": "flee", "sublabel": "Let it show the move.", "action": "safe" },
				{ "label": "Close the distance first — dictate the terms", "icon": "attack", "sublabel": "You set the pace.", "action": "risky" },
			],
			"death_chance": { "safe": 0.25, "risky": 0.50 },
			"death_flavor": {
				"safe": "It showed a move and you read it. The actual move was different. One misread at this weight class is the difference.",
				"risky": "Dictating terms to something of equal size requires that the first move lands. It didn't.",
			},
			"win_flavor": {
				"safe": "It showed its weight shift before the final move. You'd been waiting for it. The counter landed before the full commit. It broke off and moved north.",
				"risky": "You closed the range faster than it expected. The weight advantage was yours in the first exchange. It withdrew.",
			},
		},
		"b": {
			"flavor": "You positioned inside the canyon crossing at midnight. It entered the narrow section before dawn. The angle was everything you needed.",
			"choices": [
				{ "label": "Drive it toward the dead end — block the exit", "icon": "stalk", "sublabel": "Methodical, no exposure.", "action": "safe" },
				{ "label": "Drop from the shelf above", "icon": "attack", "sublabel": "Maximum impact, maximum risk.", "action": "risky" },
			],
			"death_chance": { "safe": 0.15, "risky": 0.35 },
			"death_flavor": {
				"safe": "You held the exit but it didn't try for it — it turned and came for you, in the confines you'd positioned yourself in.",
				"risky": "The drop angle was off by a step. It had time to respond before you'd completed the commitment.",
			},
			"win_flavor": {
				"safe": "You closed the exit while it was committed to the canyon. When it turned, the geometry was yours. It pushed back the way it came.",
				"risky": "The drop landed clean. The impact was decisive. It didn't recover the momentum and withdrew.",
			},
		},
	},
	"trex": {
		"a": {
			"flavor": "You reached the southern boundary at dawn. It was already there. Neither of you moved for several minutes. The space between you felt smaller than the distance.",
			"choices": [
				{ "label": "Hold the line and make the territorial display", "icon": "stalk", "sublabel": "Let the range answer the question.", "action": "safe" },
				{ "label": "Walk forward and close the distance", "icon": "attack", "sublabel": "End the ambiguity.", "action": "risky" },
			],
			"death_chance": { "safe": 0.15, "risky": 0.40 },
			"death_flavor": {
				"safe": "It read the display as hesitation. What you intended as a territorial statement became an invitation.",
				"risky": "Closing the distance with something of equal size removes the option of a second move. There wasn't one.",
			},
			"win_flavor": {
				"safe": "You held the position and made the full display — weight, sound, presence. It held the stare for a long time. Then it turned and moved south. The boundary is clear.",
				"risky": "You closed the distance and it matched the move. The exchange was short and definitive. It broke contact and moved south.",
			},
		},
		"b": {
			"flavor": "Two days ahead of it — marking every boundary, covering routes, staying one step faster through familiar ground. It followed your track. On the second night, you heard it stop. On the third morning, the marks at the southern boundary were heading away.",
			"choices": [
				{ "label": "Hold the range — let it make the decision", "icon": "flee", "sublabel": "The territory has already spoken.", "action": "safe" },
				{ "label": "Follow it out — make certain of the outcome", "icon": "attack", "sublabel": "Escort the message personally.", "action": "risky" },
			],
			"death_chance": { "safe": 0.05, "risky": 0.30 },
			"death_flavor": {
				"safe": "It stopped and turned. You'd let the distance close during the follow without realizing it. The favorable geometry of your range was behind you.",
				"risky": "It was waiting for you to come off your ground. The follow-through took you into its territory.",
			},
			"win_flavor": {
				"safe": "You held the boundary and it continued south. The range returned to its normal rhythm inside a season. The question is settled.",
				"risky": "You followed far enough to make the point personal. It understood. The encounter ended cleanly and on your terms.",
			},
		},
	},
	"lesothosaurus": {
		"a": {
			"flavor": "You broke northeast at speed. Two of them followed. The third circled back for the herd — but the herd had already scattered and was gone. Open ground, two of them, and the ravine gap you know by memory.",
			"choices": [
				{ "label": "Make for the ravine gap", "icon": "flee", "sublabel": "They won't commit to the narrow crossing.", "action": "safe" },
				{ "label": "Keep running in open ground", "icon": "attack", "sublabel": "Outrun them — trust the legs.", "action": "risky" },
			],
			"death_chance": { "safe": 0.20, "risky": 0.40 },
			"death_flavor": {
				"safe": "You made the gap but one of them was faster through the narrow section than expected.",
				"risky": "Three hundred meters, the legs were right. Four hundred, one of them was still there. Five hundred, it was beside you.",
			},
			"win_flavor": {
				"safe": "You made the gap before they could close it. One entered and stopped at the width. The other held outside. You cleared the far end and kept moving until the sounds stopped.",
				"risky": "The legs held. After four hundred meters the gap was yours. They stopped at the crest of the hill.",
			},
		},
		"b": {
			"flavor": "You moved to the center of the herd and held still. For two days the formation held. Then a younger member spooked and the center opened for thirty seconds. Long enough to be seen.",
			"choices": [
				{ "label": "Reverse direction into the stampede", "icon": "flee", "sublabel": "Use the herd's movement.", "action": "safe" },
				{ "label": "Sprint for the undergrowth at the edge", "icon": "attack", "sublabel": "Straight line, commit fully.", "action": "risky" },
			],
			"death_chance": { "safe": 0.15, "risky": 0.35 },
			"death_flavor": {
				"safe": "You reversed into the stampede but the angle put you at the edge of it rather than the center. Exposed again.",
				"risky": "The sprint was right. The angle was slightly off. Two body lengths short of the undergrowth.",
			},
			"win_flavor": {
				"safe": "You turned back into the moving mass. The predator committed to one direction and the stampede took you through the gap it expected to close.",
				"risky": "The sprint committed everything the legs had. The edge came up fast. In the undergrowth, you were invisible. They circled and moved on.",
			},
		},
	},
	"iguanodon": {
		"a": {
			"flavor": "Two days on the known route. The predators came on the second evening, exactly where they always do in this season. You moved the herd close together and turned to face them with the thumb spikes extended.",
			"choices": [
				{ "label": "Hold the defensive circle — wait for dawn", "icon": "stalk", "sublabel": "Dawn drives them back.", "action": "safe" },
				{ "label": "Charge the lead predator", "icon": "attack", "sublabel": "Break the approach before it commits.", "action": "risky" },
			],
			"death_chance": { "safe": 0.20, "risky": 0.40 },
			"death_flavor": {
				"safe": "The circle held through the night but the sustained pressure found the weakest member. When it broke, the circle followed.",
				"risky": "The charge was committed. The lead predator absorbed the impact and the others closed from behind.",
			},
			"win_flavor": {
				"safe": "You held through the night. At first light, the predators withdrew. The herd crossed the corridor at dawn. No losses.",
				"risky": "The charge caught the lead predator before it committed. The spike impact changed the calculation. The others didn't follow it in.",
			},
		},
		"b": {
			"flavor": "Open ground for two days. Heat. No shade. The herd moved but slowed steadily. On the second morning, two of the older members could not keep pace. The predators tracking the migration had noticed.",
			"choices": [
				{ "label": "Hold the herd's pace — keep everyone together", "icon": "bond", "sublabel": "Don't abandon anyone.", "action": "risky" },
				{ "label": "Maintain crossing speed — the majority has to make it", "icon": "flee", "sublabel": "The math is brutal but clear.", "action": "safe" },
			],
			"death_chance": { "safe": 0.10, "risky": 0.30 },
			"death_flavor": {
				"safe": "The crossing speed held but the herd fragmented under pressure at the final approach. You were in the wrong position when the gap opened.",
				"risky": "You circled back for the stragglers and the predators arrived before the herd could reform around you.",
			},
			"win_flavor": {
				"safe": "The crossing speed held. The herd reached cover. The crossing was done.",
				"risky": "You slowed to hold the stragglers. The herd circled back. The predators came but the massed response drove them off. Everyone crossed.",
			},
		},
	},
	"triceratops": {
		"a": {
			"flavor": "You closed the distance at speed. The impact was total — the horns found purchase, the predator staggered. You are bleeding from a secondary hit. So is it. The second predator is still circling.",
			"choices": [
				{ "label": "Hold the ground — it's hurt, wait for it to break off", "icon": "stalk", "sublabel": "You've done enough.", "action": "safe" },
				{ "label": "Drive it back while it's staggered", "icon": "attack", "sublabel": "End the engagement now.", "action": "risky" },
			],
			"death_chance": { "safe": 0.20, "risky": 0.40 },
			"death_flavor": {
				"safe": "The second predator closed while you held position waiting for the first to break off. Two angles.",
				"risky": "The press committed you fully. The second predator had the angle on your flank while you were mid-charge.",
			},
			"win_flavor": {
				"safe": "You held the position and let the injury work. The staggered predator moved off. The second circled twice more and followed. The herd was safe.",
				"risky": "The press while it was staggered was decisive. It broke contact before recovering. The second predator retreated when the first went down.",
			},
		},
		"b": {
			"flavor": "You formed up with three herd members and moved as a unit. The predator circled for a gap. Then the second one appeared — two of them working angles. A younger herd member panicked and the gap opened.",
			"choices": [
				{ "label": "Call the broken member back — close the gap", "icon": "bond", "sublabel": "Hold the line.", "action": "safe" },
				{ "label": "Fill the gap with your own body", "icon": "attack", "sublabel": "No gap to exploit.", "action": "risky" },
			],
			"death_chance": { "safe": 0.15, "risky": 0.35 },
			"death_flavor": {
				"safe": "The call was too slow. The gap had been there long enough.",
				"risky": "You filled the gap but the position put you between both predators simultaneously.",
			},
			"win_flavor": {
				"safe": "The call brought the broken member back before the predators could commit. The line held. They circled twice more, then moved on.",
				"risky": "You filled the gap with your body and turned to face the angle. The predators saw a closed wall. They didn't push it.",
			},
		},
	},
	"ankylosaurus": {
		"a": {
			"flavor": "You heaved and shifted, working both sides. One rear leg came free with effort. The other is still under. The exertion cost you. The thing at the edge of the bog has stopped circling. It's watching.",
			"choices": [
				{ "label": "Position the club while the leg is free", "icon": "stalk", "sublabel": "Ready for what's coming.", "action": "safe" },
				{ "label": "Final push — try to get fully free", "icon": "attack", "sublabel": "Risk the exhaustion.", "action": "risky" },
			],
			"death_chance": { "safe": 0.15, "risky": 0.35 },
			"death_flavor": {
				"safe": "The wait with the club positioned gave it the time it needed to close. The first swing missed the angle.",
				"risky": "The final push needed one more thing than the body had. The collapse into the bog was deeper than before.",
			},
			"win_flavor": {
				"safe": "You had the club ready when it finally committed. The first swing landed clean. It retreated. By midday, with the ground firming, you got the last leg free.",
				"risky": "The final effort worked. You cleared the bog and turned to face the circler. It read the situation differently once you were mobile. It withdrew.",
			},
		},
		"b": {
			"flavor": "Three hours still. The rains stopped. The surface is starting to firm at the edges — not enough to move on yet, but the direction is right. The thing at the bog's edge is still there. It's hungry and the waiting has made it commit.",
			"choices": [
				{ "label": "Wait for the ground to firm completely", "icon": "flee", "sublabel": "Patience has the math right.", "action": "safe" },
				{ "label": "Swing the club as it approaches", "icon": "attack", "sublabel": "Meet it on your terms.", "action": "risky" },
			],
			"death_chance": { "safe": 0.10, "risky": 0.25 },
			"death_flavor": {
				"safe": "The additional wait pushed past the patience of the thing at the edge. It came before the ground firmed.",
				"risky": "The swing was right but the footing wasn't. The bog shifted under the effort. The follow-through didn't complete.",
			},
			"win_flavor": {
				"safe": "Another two hours. The surface held your weight. You moved to firmer ground. The predator followed until the terrain changed in your favor. Then it stopped.",
				"risky": "The swing caught it as it committed to the soft ground. The bog worked against it the way it had worked against you. The contact was decisive.",
			},
		},
	},
	"argentinosaurus": {
		"a": {
			"flavor": "Fourteen days of crossing. The herd reads the terrain from decades of migration — each member knows the route by season. You know it too. But knowing and doing have started to separate.",
			"choices": [
				{ "label": "Stop for a day — let the body recover", "icon": "bond", "sublabel": "The herd will hold.", "action": "safe" },
				{ "label": "Push through to the northern ground", "icon": "flee", "sublabel": "You've done this every time.", "action": "risky" },
			],
			"death_chance": { "safe": 0.15, "risky": 0.35 },
			"death_flavor": {
				"safe": "The day of rest was right. But the predators that follow migrating herds found the one that had stopped and fallen behind.",
				"risky": "Seventeen days was one more than the crossing had available.",
			},
			"win_flavor": {
				"safe": "You stopped on the fourteenth day. The herd slowed and held two days ahead. You covered the remaining distance on the sixteenth day. The northern ground was everything it has always been.",
				"risky": "Seventeen days. The crossings you've made before carried the muscle memory the body needed to finish. You reached the northern ground.",
			},
		},
		"b": {
			"flavor": "Three days of alternate route — lower terrain, shorter daily distances. Slower but sustainable. You arrived at the northern feeding ground two days after the herd. They were still there. The route worked.",
			"choices": [
				{ "label": "Rejoin the herd and rest", "icon": "bond", "sublabel": "The crossing is complete.", "action": "safe" },
				{ "label": "Survey the northern ground before settling", "icon": "stalk", "sublabel": "Old habits.", "action": "risky" },
			],
			"death_chance": { "safe": 0.05, "risky": 0.10 },
			"death_flavor": {
				"safe": "The rest you needed had to happen before the predators following the herd found the one that arrived late and alone.",
				"risky": "The survey took you further from the herd than intended. Northern ground predators target the edges first.",
			},
			"win_flavor": {
				"safe": "You rejoined the herd on the northern ground. The crossing was done. Every one of them. Every route.",
				"risky": "The survey showed three new water sources and confirmed the western range was clear. You returned to the herd with better information than anyone had on arrival.",
			},
		},
	},
}

const ELDER_VICTORY_CONGRATS = {
	"compsognathus":  "You beat the odds. The pack is still yours, the range is still yours, and everything that came for you this season found out why that is. Congratulations — you've beaten the Elder's Last Trial.",
	"deinonychus":    "The pack's future held through the hardest test it would ever face. You navigated it without losing either the pack or yourself. Congratulations — you've beaten the Elder's Last Trial.",
	"velociraptor":   "The range held, the pack held, and the season that should have broken you didn't. Whatever comes next, this was the one that mattered. Congratulations — you've beaten the Elder's Last Trial.",
	"allosaurus":     "The challenge is over. The range is yours by contest, not by default — something tested you and found out what eleven seasons of territory defense actually means. Congratulations — you've beaten the Elder's Last Trial.",
	"trex":           "The only thing in this range that could challenge you tried. You answered the question completely. The boundary is settled. The land remembers. Congratulations — you've beaten the Elder's Last Trial.",
	"lesothosaurus":  "The predators that keyed on your pace found out the pace still had answers left in it. The herd is intact. So are you. Congratulations — you've beaten the Elder's Last Trial.",
	"iguanodon":      "The herd made it through because you led them through. The decisions that had to be right were right. Congratulations — you've beaten the Elder's Last Trial.",
	"triceratops":    "The predator that came for the herd three seasons in a row found a wall it couldn't breach. You were that wall. Congratulations — you've beaten the Elder's Last Trial.",
	"ankylosaurus":   "The bog, the waiting, the thing at the edge — you outlasted all of it. That's what this armor was always for. Congratulations — you've beaten the Elder's Last Trial.",
	"argentinosaurus": "Twenty-three crossings, and the twenty-fourth — the one the body said you couldn't finish. You finished it. Congratulations — you've beaten the Elder's Last Trial.",
}


func _resolve_elder_s1(species_id: String, choice: String) -> Dictionary:
	var step = ELDER_S2.get(species_id, {}).get(choice, {})
	if step.is_empty():
		return _no_event()
	return {
		"type":         "result",
		"next_context": "elder_final_%s_2%s" % [species_id, choice],
		"flavor":       step["flavor"],
		"choices":      step["choices"],
	}


func _resolve_elder_s2(species_id: String, branch: String, choice: String) -> Dictionary:
	var step = ELDER_S2.get(species_id, {}).get(branch, {})
	if step.is_empty():
		return _no_event()
	var dc: float = step.get("death_chance", {}).get(choice, 0.0)
	if dc > 0.0 and randf() < dc:
		GameState.health     = 0.0
		GameState.death_cause = "elder_event"
		var df: String = step.get("death_flavor", {}).get(choice, "The seasons finally caught up.")
		return _result(df)
	var wf: String = step.get("win_flavor", {}).get(choice, "You made it through.")
	var congrats: String = ELDER_VICTORY_CONGRATS.get(species_id, "Congratulations — you've beaten the Elder's Last Trial.")
	return {
		"type":         "result",
		"next_context": "elder_victory",
		"flavor":       wf + "\n\n" + congrats,
		"choices": [
			{ "label": "Keep going", "icon": "attack", "sublabel": "You're not done yet.", "action": "keep_going" },
			{ "label": "End this run", "icon": "flee",   "sublabel": "A fitting close to a legendary life.", "action": "end_run" },
		],
	}


# ── LEGENDARY EVENTS ──────────────────────────────────────────────────────────

func _resolve_white_ghost(choice: String) -> Dictionary:
	match choice:
		"hunt_legendary_prey":
			# High-risk hunt — the creature fights back hard
			if GameState.strength >= 0.55 and randf() < (0.50 + GameState.luck_mod()):
				GameState.hunger = minf(1.0, GameState.hunger + 0.50)
				GameState.kills += 1
				GameState.fights_won += 1
				GameState.strength = minf(1.0, GameState.strength + 0.02)
				GameState.bonuses_earned.append("White Ghost Kill")
				return _result("It fought like nothing you have hunted before. When it was over you stood over something the world won't see again. The hunger is gone. Something else is in its place.")
			else:
				GameState.health = maxf(0.0, GameState.health - 0.25)
				GameState.apply_temp_buff("strength", -0.08, 3, "legendary_wound")
				if GameState.health <= 0.0:
					GameState.death_cause = "combat"
					GameState.death_detail = "the white ghost"
				return _result("It was faster than you expected. You landed nothing. It left you on the ground and walked away. That creature knew exactly what you were.")
		"observe_legendary":
			# Safe — watch and learn. Temp speed buff from studying its movement.
			GameState.apply_temp_buff("speed", 0.08, 4, "ghost_movement")
			return _result("You watched it for a long time. The way it moved — economy in everything, no wasted motion. You won't forget that. Something in how you move has changed.")
		"leave":
			return _result("You made the right call. Some encounters carry weight that outlasts the season. You walked away and felt the pressure of it behind you for the rest of the day.")
	return _no_event()


func _resolve_ancient_watcher(choice: String) -> Dictionary:
	match choice:
		"face_legendary":
			if GameState.defense >= 0.50 or randf() < (0.35 + GameState.luck_mod()):
				GameState.apply_temp_buff("defense", 0.06, 3, "ancient_respect")
				return _result("You held. It watched for a long time — longer than anything should need to make a decision — and then it left. It read you correctly and chose not to engage. You feel different about your own size after that.")
			else:
				GameState.health = maxf(0.0, GameState.health - 0.20)
				GameState.apply_temp_buff("speed", -0.06, 2, "ancient_strike")
				return _result("The patience ended without warning. One strike and you were already bleeding before you understood what happened. It didn't pursue. It had already finished what it meant to do.")
		"retreat_legendary":
			GameState.apply_temp_buff("speed", 0.04, 2, "careful_retreat")
			return _result("You backed away slowly. It watched every step. When you were far enough that it lost interest you let yourself breathe. You learned something about distance today — yours and everything else's.")
		"flee_legendary":
			if GameState.speed >= 0.50 or randf() < (0.55 + GameState.luck_mod()):
				return _result("You were already moving before the decision finished forming. It came off the ridge, but you had committed and your speed held. It didn't follow far. Old bodies burn out quickly on a chase.")
			else:
				GameState.health = maxf(0.0, GameState.health - 0.15)
				GameState.apply_temp_buff("hunger", -0.10, 2, "flight_cost")
				return _result("You moved too late. The first stride it took told you that age hadn't slowed it as much as you thought. You got away, but not clean.")
	return _no_event()


func _resolve_bone_ground(choice: String) -> Dictionary:
	match choice:
		"bone_ground_feed":
			GameState.hunger = minf(1.0, GameState.hunger + 0.35)
			# Preserved bones carry ancient sickness — small health cost
			GameState.health = maxf(0.0, GameState.health - 0.08)
			return _result("You fed. The hunger retreated. But something in the cold meat of this place sat wrong in you for days afterward — something old that your body didn't recognize. Worth it. Probably.")
		"bone_ground_claim":
			GameState.pending_territory_claim = "strong"
			GameState.bonuses_earned.append("Bone Ground Claim")
			GameState.apply_temp_buff("defense", 0.05, 3, "bone_ground_anchor")
			return _result("You marked what the old hunter no longer guards. The valley is yours now — or as close to yours as this kind of place ever belongs to anything living. You feel steadier in the area than you have in seasons.")
		"leave":
			return _result("You turned away from it. Some places are too heavy to claim. You didn't look back. By nightfall you had almost convinced yourself you had made the right call.")
	return _no_event()


func _resolve_great_herd(choice: String) -> Dictionary:
	match choice:
		"join_great_herd":
			GameState.hunger = minf(1.0, GameState.hunger + 0.30)
			GameState.apply_temp_buff("defense", 0.08, 3, "great_herd_numbers")
			return _result("You moved with them. Thousands of bodies around you, all moving in the same direction. A predator picked at the outer edge — you stayed centered and it never came close. By the time the herd thinned you had eaten well and the fear of this season felt smaller.")
		"edge_great_herd":
			GameState.hunger = minf(1.0, GameState.hunger + 0.22)
			if randf() < 0.25:
				GameState.health = maxf(0.0, GameState.health - 0.10)
				return _result("You fed at the confusion of the edges — the herd moving in one direction, the predators working the margins in the other. You ate. Something came too close twice. The second time cost you. You cleared the worst of it and kept moving.")
			return _result("The predators working the herd edges were focused on the weak and the young. You moved through the margin of it and found food in the confusion. It was more dangerous than the center. It was also where the eating was.")
		"hold_great_herd":
			GameState.pending_territory_claim = "strong"
			GameState.hunger = maxf(0.0, GameState.hunger - 0.06)
			return _result("You held your ground while everything around you moved south. By nightfall the valley was quiet in a way it hadn't been in seasons. Your marks were undisturbed. You had stayed and your range knew it. The next season will start from a position of strength.")
	return _no_event()


# ── TURNING POINT EVENTS ──────────────────────────────────────────────────────

func _resolve_last_water(choice: String) -> Dictionary:
	match choice:
		"desperate_water":
			GameState.health = maxf(0.0, GameState.health - 0.08)
			if GameState.health <= 0.0:
				GameState.death_cause = "starvation"
				return _result("The push to the water was the last thing you had. You didn't make it.")
			GameState.hunger = minf(1.0, GameState.hunger + 0.30)
			return _result("You made it. Barely. The water was there — just as the body's accounting was about to close. You drank until the math stopped mattering. You are not recovered. But you are not finished either.")
		"desperate_rest":
			var heal := GameState.hunger * 0.10
			GameState.health = minf(1.0, GameState.health + heal)
			GameState.hunger = maxf(0.0, GameState.hunger - 0.06)
			return _result("You stayed still instead of pushing. The body used what little reserves remained to buy back a fraction of what the last few days had cost. When you moved again, the water was still there. Still possible.")
	return _no_event()


func _resolve_wrong_season(choice: String) -> Dictionary:
	match choice:
		"desperate_hunt":
			# Desperate small hunt — high success rate, low reward
			if randf() < (0.65 + GameState.luck_mod()):
				GameState.hunger = minf(1.0, GameState.hunger + 0.18)
				GameState.kills += 1
				return _result("Something small and wrong. Not what you would have chosen three seasons ago. You ate it anyway. The body does not argue with you about standards when the numbers are this bad.")
			else:
				GameState.health = maxf(0.0, GameState.health - 0.08)
				return _result("The hunt went nowhere. Whatever it was got away. The energy you spent is gone and the hunger is the same as it was. This is the worst kind of loss — nothing to show for the cost.")
		"desperate_rest":
			var heal := GameState.hunger * 0.08
			GameState.health = minf(1.0, GameState.health + heal)
			GameState.hunger = maxf(0.0, GameState.hunger - 0.04)
			return _result("You conserved. Every movement deliberate and minimal. The body held what it had and spent nothing it didn't need to. Tomorrow the problem will be the same. But you will face it with slightly more than you had today.")
	return _no_event()


func _resolve_final_stand(choice: String) -> Dictionary:
	match choice:
		"desperate_stand":
			# Turn and face — defense check
			if GameState.defense >= 0.45 or GameState.strength >= 0.50 or randf() < (0.40 + GameState.luck_mod()):
				GameState.apply_temp_buff("defense", 0.06, 2, "final_stand_resolve")
				return _result("You turned. It had expected you to keep running. The change in your movement — facing it instead of fleeing — bought you the half-second you needed. It broke off. Whatever it calculated when you stopped running came out in your favor.")
			else:
				GameState.health = maxf(0.0, GameState.health - 0.22)
				if GameState.health <= 0.0:
					GameState.death_cause = "combat"
					GameState.death_detail = "a predator while weakened"
				return _result("You turned and it didn't matter. Weakened and watched — you were exactly what it had read you to be. The stand was on the wrong terms. It knew that before you did.")
		"desperate_herd":
			if GameState.pack_bond > 0.0:
				GameState.pack_bond = minf(1.0, GameState.pack_bond + 0.08)
				GameState.apply_temp_buff("defense", 0.10, 3, "herd_safety")
				return _result("You found them. The herd closed around you — not out of loyalty, but out of habit, out of numbers. The predator at your back decided the odds had changed. For now you are safe inside the mass of it.")
			else:
				GameState.hunger = maxf(0.0, GameState.hunger - 0.08)
				GameState.apply_temp_buff("defense", 0.05, 2, "crowd_cover")
				return _result("You moved toward any numbers you could find. The nearest group wasn't your herd — wasn't anything you knew — but the predator behind you didn't know that. Distance and bodies bought you a season.")
		"desperate_hide":
			if GameState.health >= 0.15 and randf() < (0.55 + GameState.luck_mod()):
				var heal := GameState.hunger * 0.06
				GameState.health = minf(1.0, GameState.health + heal)
				return _result("You went still. Whatever was following you moved through the area twice and found nothing to commit to. By the time it gave up you had been motionless so long your legs ached. But you were alive. You rested in the hiding and came out of it slightly less broken than before.")
			else:
				GameState.health = maxf(0.0, GameState.health - 0.15)
				if GameState.health <= 0.0:
					GameState.death_cause = "combat"
					GameState.death_detail = "a predator while in hiding"
				return _result("The hiding wasn't good enough. It found you anyway — the smell, the sound, something you couldn't control. You barely got moving before it reached you. You survived the moment but not cleanly.")
	return _no_event()


func _resolve_last_reserves(choice: String) -> Dictionary:
	match choice:
		"desperate_hunt":
			# All-in — high variance
			var roll := randf() + GameState.luck_mod()
			if roll > 0.40:
				var gain := 0.35 + (roll - 0.40) * 0.30
				GameState.hunger = minf(1.0, GameState.hunger + gain)
				GameState.kills += 1
				GameState.strength = minf(1.0, GameState.strength + 0.01)
				return _result("Everything went in. The last reserves, the last clean movement, the last sprint you had left in you. It was enough. The kill came down and the hunger math reset. You held yourself together long enough to change the numbers.")
			else:
				GameState.health = maxf(0.0, GameState.health - 0.18)
				GameState.hunger = maxf(0.0, GameState.hunger - 0.05)
				if GameState.health <= 0.0:
					GameState.death_cause = "starvation"
				return _result("You committed everything and it wasn't enough. The prey got away and you spent more than you had. The body is presenting you with an accounting you cannot cover. You need something to change and it has to change fast.")
		"desperate_water":
			# Small but guaranteed — insects, roots, anything
			GameState.hunger = minf(1.0, GameState.hunger + 0.14)
			return _result("You found something small — not a hunt, barely even a meal. But the number moved and the body registered it. Small and certain was the right call. You feel worse than yesterday but slightly better than you did an hour ago.")
		"desperate_rest":
			var heal := GameState.hunger * 0.12
			GameState.health = minf(1.0, GameState.health + heal)
			GameState.hunger = maxf(0.0, GameState.hunger - 0.05)
			return _result("You spent what you had on stillness. The body took it and put it somewhere more useful than movement. When you woke the hunger was worse but the health had moved a fraction in the right direction. Tomorrow the hunt has to happen. Tonight you bought the right to have a tomorrow.")
	return _no_event()


# ── RIVAL ENCOUNTER ───────────────────────────────────────────────────────────

func _resolve_rival_encounter(choice: String) -> Dictionary:
	var species_tree: String = SpeciesDB.get_species(GameState.species_id).get("tree", "predator") as String
	var rival_display: String = GameState.rival_name.capitalize() if not GameState.rival_name.is_empty() else "your rival"

	match choice:
		"rival_confront":
			GameState.assign_rival(species_tree)
			# Build a virtual rival opponent — scaled near player's own stats
			var rival_power := clampf(GameState.strength + randf_range(-0.05, 0.10), 0.30, 0.85)
			var rival_defense := clampf(GameState.defense + randf_range(-0.05, 0.08), 0.20, 0.80)
			var rival_enemy := {
				"name":       rival_display,
				"fight_power": rival_power,
				"resilience":  rival_defense,
				"agility":     clampf(GameState.speed + randf_range(-0.08, 0.08), 0.20, 0.85),
				"size":        GameState.size,
				"opponent_size": GameState.size,
				"hunger_value": 0.0,
			}
			_pending_prey = rival_enemy
			_pending_combat_is_hunt = false
			return _show_combat_preview(false)

		"rival_observe":
			GameState.assign_rival(species_tree)
			# Watching is safe — small instinct buff for reading its patterns
			GameState.apply_temp_buff("type_stat", 0.05, 2, "rival_read")
			var obs_flavors := [
				"%s moved through the area but didn't commit. You watched everything — the way it favored its left side, the way it checked behind it before committing to anything. You know it better now than it knows you." % rival_display,
				"You stayed downwind and watched. %s circled the area twice, read something you couldn't see, and left. You learned more from watching it leave than you did from watching it arrive." % rival_display,
				"%s was doing the same thing you were — watching. At some point you were both watching each other without admitting it. It left first. You're not sure what that means." % rival_display,
			]
			return _result(obs_flavors[randi() % obs_flavors.size()])

		"rival_avoid":
			# Cede ground — lose some territory, avoid confrontation
			if GameState.territory_claim == "strong":
				GameState.territory_claim = "useful"
			elif GameState.territory_claim == "useful":
				GameState.territory_claim = "contested"
			var avoid_flavors := [
				"You left the area before it came to anything. %s got the ground this time. There's a cost to that — you felt it when you crossed into unfamiliar range on the other side. But you're intact." % rival_display,
				"You moved away from the boundary and didn't look back. %s took it without a fight. Some seasons you make that calculation and live with it." % rival_display,
				"You gave %s the space and went elsewhere. The day felt wrong from that point forward but nothing actually happened. Sometimes that's the best outcome available." % rival_display,
			]
			return _result(avoid_flavors[randi() % avoid_flavors.size()])

		"rival_final":
			# Final showdown — high stakes. Win: rival cleared. Lose: serious damage.
			var rival_power := clampf(GameState.strength + randf_range(0.02, 0.15), 0.30, 0.90)
			var rival_enemy := {
				"name":       rival_display,
				"fight_power": rival_power,
				"resilience":  clampf(GameState.defense + 0.05, 0.20, 0.85),
				"agility":     clampf(GameState.speed + randf_range(-0.05, 0.10), 0.20, 0.85),
				"size":        GameState.size,
				"opponent_size": GameState.size,
				"hunger_value": 0.15,
				"is_rival_final": true,
			}
			_pending_prey = rival_enemy
			_pending_combat_is_hunt = false
			return _show_combat_preview(false)

	return _no_event()
