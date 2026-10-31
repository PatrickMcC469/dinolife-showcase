extends Control

const ART = preload("res://scripts/ui/adventure_theme.gd")

signal choice_made(action: String)

# ── Nodes defined in event_overlay.tscn ──────────────────────────────────────
@onready var _popup_panel:    Control         = $PopupPanel
@onready var _bottom_section: MarginContainer = $PopupPanel/BottomSection
@onready var _title_label:    Label           = $PopupPanel/TopSection/TopVBox/TitleLabel
@onready var _flavor_label:   Label           = $PopupPanel/TopSection/TopVBox/FlavorScroll/StoryContent/FlavorLabel
@onready var _result_feedback = $PopupPanel/TopSection/TopVBox/FlavorScroll/StoryContent/ResultFeedback
@onready var _choices_grid:   GridContainer   = $PopupPanel/BottomSection/ButtonCenter/ChoicesGrid
@onready var _top_vbox:       VBoxContainer   = $PopupPanel/TopSection/TopVBox
@onready var _flavor_scroll:  ScrollContainer = $PopupPanel/TopSection/TopVBox/FlavorScroll
@onready var _event_image:    TextureRect     = $PopupPanel/EventImageWrap/EventImage
@onready var _event_image_wrap: Control       = $PopupPanel/EventImageWrap
@onready var _bg_panel:       Panel           = $PopupPanel/Background
@onready var _dim_overlay:    Panel           = $DimOverlay
@onready var _title_rule:     Panel           = $PopupPanel/TopSection/TopVBox/TitleRule
@onready var _reading_frame: Panel = $PopupPanel/ReadingFrame

var _dismiss_id:       int         = 0
var _back_btn:         Button       = null

var _safe_top:    int = 24
var _safe_bottom: int = 52

var _current_accent: Color = Color(0.85, 0.72, 0.35)

# Typewriter state
var _tw_full:   String = ""
var _tw_idx:    int    = 0
var _tw_elapsed: float = 0.0
var _revealing_gesture := false
var _show_tween: Tween

# ── EVENT IMAGE MAP ───────────────────────────────────────────────────────────
const _EVENT_IMAGES: Dictionary = {
	"home_ridge": "home_ridge.png",
	"home_river": "home_river.png",
	"home_grove": "home_grove.png",
	"living_solitary_dawn": "living_solitary_dawn.png",
	"iguanodon_returned_care": "iguanodon_returned_care.png",
	"iguanodon_wary_distance": "iguanodon_wary_distance_v2.png",
	"iguanodon_resting_together": "iguanodon_resting_together.png",
	"iguanodon_teaching_young": "iguanodon_teaching_young_v2.png",
	"deinonychus_returned_care": "deinonychus_returned_care.png",
	"deinonychus_wary_distance": "deinonychus_wary_distance.png",
	"deinonychus_resting_together": "deinonychus_resting_together.png",
	"deinonychus_teaching_young": "deinonychus_teaching_young.png",
	"triceratops_returned_care": "triceratops_returned_care.png",
	"triceratops_wary_distance": "triceratops_wary_distance.png",
	"triceratops_resting_together": "triceratops_resting_together.png",
	"triceratops_teaching_young": "triceratops_teaching_young.png",
	"velociraptor_returned_care": "velociraptor_returned_care.png",
	"velociraptor_wary_distance": "velociraptor_wary_distance_v2.png",
	"velociraptor_resting_together": "velociraptor_resting_together.png",
	"velociraptor_teaching_young": "velociraptor_teaching_young.png",
	"compsognathus_returned_care": "compsognathus_returned_care.png",
	"compsognathus_wary_distance": "compsognathus_wary_distance.png",
	"compsognathus_resting_together": "compsognathus_resting_together.png",
	"compsognathus_teaching_young": "compsognathus_teaching_young.png",
	"lesothosaurus_returned_care": "lesothosaurus_returned_care.png",
	"lesothosaurus_wary_distance": "lesothosaurus_wary_distance.png",
	"lesothosaurus_resting_together": "lesothosaurus_resting_together.png",
	"lesothosaurus_teaching_young": "lesothosaurus_teaching_young.png",
	"argentinosaurus_returned_care": "argentinosaurus_returned_care_v3.png",
	"argentinosaurus_wary_distance": "argentinosaurus_wary_distance_v2.png",
	"argentinosaurus_resting_together": "argentinosaurus_resting_together_v3.png",
	"argentinosaurus_teaching_young": "argentinosaurus_teaching_young.png",
	"trex_journey_0": "trex_journey_0.png",
	"trex_journey_1": "trex_journey_1.png",
	"trex_journey_2": "trex_journey_2.png",
	"trex_teaching_young": "trex_teaching_young.png",
	"allosaurus_journey_0": "allosaurus_journey_0.png",
	"allosaurus_journey_1": "allosaurus_journey_1.png",
	"allosaurus_journey_2": "allosaurus_journey_2.png",
	"allosaurus_teaching_young": "allosaurus_teaching_young.png",
	"ankylosaurus_journey_0": "ankylosaurus_journey_0_v2.png",
	"ankylosaurus_journey_1": "ankylosaurus_journey_1_v2.png",
	"ankylosaurus_journey_2": "ankylosaurus_journey_2_v2.png",
	"ankylosaurus_teaching_young": "ankylosaurus_teaching_young_v2.png",
	"iguanodon_council_route": "iguanodon_council_route.png",
	"iguanodon_council_rest": "iguanodon_council_rest_v4.png",
	"iguanodon_council_newcomer": "iguanodon_council_newcomer_v2.png",
	"deinonychus_council_route": "deinonychus_council_route.png",
	"deinonychus_council_rest": "deinonychus_council_rest_v2.png",
	"deinonychus_council_newcomer": "deinonychus_council_newcomer_v2.png",
	"triceratops_council_route": "triceratops_council_route_v2.png",
	"triceratops_council_rest": "triceratops_council_rest_v4.png",
	"triceratops_council_newcomer": "triceratops_council_newcomer_v2.png",
	"velociraptor_council_route": "velociraptor_council_route_v2.png",
	"velociraptor_council_rest": "velociraptor_council_rest_v2.png",
	"velociraptor_council_newcomer": "velociraptor_council_newcomer_v2.png",
	"compsognathus_council_route": "compsognathus_council_route_v2.png",
	"compsognathus_council_rest": "compsognathus_council_rest_v2.png",
	"compsognathus_council_newcomer": "compsognathus_council_newcomer_v2.png",
	"lesothosaurus_council_route": "lesothosaurus_council_route.png",
	"lesothosaurus_council_rest": "lesothosaurus_council_rest_v2.png",
	"lesothosaurus_council_newcomer": "lesothosaurus_council_newcomer_v2.png",
	"argentinosaurus_council_route": "argentinosaurus_council_route_v2.png",
	"argentinosaurus_council_rest": "argentinosaurus_council_rest_v4.png",
	"argentinosaurus_council_newcomer": "argentinosaurus_council_newcomer_v2.png",
	"home_event": "all_species_heavy_foilage_cover.png",
	"living_event": "all_species_cover_resting.png",
	"council_herd": "dense_herd.png",
	"council_pack": "creatures_watching.png",
	"journey_event": "fresh_tracks.png",
	# SPRING
	"fresh_growth":              "spring_growth.png",
	"hatchling_season":          "hatchling_season.png",
	"mud_season":                "all_species_muddy_paw_prints.png",
	"flooded_rivers":            "flood_storm.png",
	"new_pack_forming":          "creatures_watching.png",
	"herd_migration_begins":     "migration.png",
	"blooming_medicine":         "herbal_plant.png",
	"poison_bloom":              "unusual_plants.png",
	"storm_week":                "lighting_storm.png",
	"nest_site_rush":            "all_species_heavy_foilage_cover.png",
	# SUMMER
	"heat_wave":                 "scorched_ground.png",
	"drought":                   "drought.png",
	"fruit_season":              "fruit_tree.png",
	"waterhole_truce":           "shared_waterhole.png",
	"wildfire":                  "wild_fire.png",
	"insect_swarms":             "insect_swarm.png",
	"dust_storm":                "dust_storm.png",
	"salt_lick":                 "mineral.png",
	# FALL
	"great_migration":           "migration.png",
	"rutting_season":            "rival_standoff.png",
	"fattening_season":          "meadow.png",
	"cold_nights":               "frost_ground.png",
	"sick_herd":                 "sick_herd.png",
	"mushroom_bloom":            "mushroom.png",
	"predator_gathering":        "creatures_watching.png",
	"leaf_fall":                 "autumn_canopy.png",
	"alpha_challenge":           "rival_standoff.png",
	# WINTER
	"deep_freeze":               "frost_ground.png",
	"snowfall":                  "frost_ground.png",
	"blizzard":                  "frozen_storm.png",
	"frozen_river":              "frozen_river.png",
	"frozen_carcass":            "bone_pile.png",
	"winter_shelter":            "burrow_entrance.png",
	"pack_hunger":               "dense_herd.png",
	"scavenger_war":             "scavengers.png",
	"herd_huddle":               "dense_herd.png",
	# PREDATOR-SPECIFIC
	"wounded_wanderer":          "track_injured.png",
	"fresh_tracks":              "fresh_tracks.png",
	"pack_invitation":           "creatures_watching.png",
	"rival_claim":               "rival_standoff.png",
	"night_hunt":                "night_forest.png",
	"herd_defense":              "dense_herd.png",
	# HERBIVORE-SPECIFIC
	"defensive_stand":           "dark_dino.png",
	"fresh_meadow":              "meadow.png",
	"mineral_lick":              "mineral.png",
	"herd_panic":                "stampede.png",
	"nest_defense":              "all_species_heavy_foilage_cover.png",
	"old_bull_challenge":        "rival_standoff.png",
	# FLYER-SPECIFIC
	"fish_surface":              "fish_water.png",
	"storm_perch":               "lighting_storm.png",
	"egg_snatcher":              "cliff_ledge.png",
	"migration_current":         "migration.png",
	# RARE/GLOBAL
	"great_drought":             "scorched_ground.png",
	"blooming_year":             "spring_growth.png",
	"superstorm":                "lighting_storm.png",
	"plague_season":             "sick_herd.png",
	"red_moon_rut":              "red_moon.png",
	"predator_silence":          "all_species_cover_resting.png",
	# DISCOVERY / AMBIGUOUS
	"tar_seep":                  "tar_pit.png",
	"cave_hollow":               "dark_hole.png",
	"glowing_pool":              "glowing_pool.png",
	"fallen_nest":               "fallen_nest.png",
	"bone_cache":                "bone_pile.png",
	"sleeping_creature":         "sleeping giant.png",
	"strange_growth":            "unusual_plants.png",
	# WINTER EXPANDED
	"migrant_stragglers":        "track_injured.png",
	"storm_driven_prey":         "frozen_storm.png",
	"frozen_kill_theft":         "scavengers.png",
	"ice_shelf_collapse":        "frozen_river.png",
	"starvation_rival":          "dark_dino.png",
	"frost_hollow":              "burrow_entrance.png",
	"winter_burrow":             "burrow_entrance.png",
	"ice_fish_run":              "fish_water.png",
	"desperate_feeding":         "bone_pile.png",
	"whiteout":                  "frozen_storm.png",
	"carrion_circuit":           "scavengers.png",
	"pack_split_winter":         "creatures_watching.png",
	# SPECIES-SPECIFIC (T1-T3)
	"comp_pack_flanking":        "creatures_watching.png",
	"deinon_killing_strike":     "all_species_heavy_foilage_cover.png",
	"micro_canopy_launch":       "all_species_heavy_foilage_cover.png",
	"troodon_night_sense":       "night_forest.png",
	"dilo_ambush_cover":         "all_species_cover_resting.png",
	"bambi_terrain_gap":         "dark_hole.png",
	"ornith_lizard_burst":       "meadow.png",
	"hypsi_alarm_sprint":        "stampede.png",
	"fruitaden_dense_cover":     "all_species_heavy_foilage_cover.png",
	"yi_qi_night_glide":         "night_forest.png",
	"archae_mode_switch":        "autumn_canopy.png",
	"nemi_canopy_thread":        "all_species_heavy_foilage_cover.png",
	# T4-T7 PREDATOR
	"raptor_pack_strike":        "creatures_watching.png",
	"carno_full_sprint":         "meadow.png",
	"allo_displacement":         "bone_pile.png",
	"troodon_circuit":           "night_forest.png",
	"sino_still_hunt":           "all_species_cover_resting.png",
	"yuty_cold_range":           "frost_ground.png",
	"giga_pack_coordinate":      "creatures_watching.png",
	"carchar_bite_hold":         "track_injured.png",
	"spino_river_claim":         "shared_waterhole.png",
	"tarbo_territory_press":     "rival_standoff.png",
	"trex_bite_test":            "dark_dino.png",
	"old_king_range_walk":       "all_species_muddy_paw_prints.png",
	"spino_river_depth":         "fish_water.png",
	"giga_matriarch_call":       "creatures_watching.png",
	"red_maw_challenge":         "rival_standoff.png",
	# HERBIVORE SPECIES-SPECIFIC
	"iguan_spike_warning":       "dark_dino.png",
	"kentro_spine_array":        "dark_dino.png",
	"stego_thagomizer":          "dark_dino.png",
	"pachy_dome_drive":          "rival_standoff.png",
	"lesotho_herd_signal":       "all_species_muddy_paw_prints.png",
	"micro_horn_standoff":       "dark_dino.png",
	"othni_pace_test":           "meadow.png",
	"chang_kin_gather":          "creatures_watching.png",
	"trike_frill_charge":        "dark_dino.png",
	"anky_tail_arc":             "dark_dino.png",
	"para_long_call":            "dense_herd.png",
	"edmont_migration_lead":     "migration.png",
	"diplo_tail_clear":          "dark_dino.png",
	"apato_herd_anchor":         "dense_herd.png",
	"brachi_high_browse":        "autumn_canopy.png",
	"shan_herd_signal":          "dense_herd.png",
	"argent_nothing_challenges": "meadow.png",
	"dread_size_reckoning":      "rival_standoff.png",
	"patago_ground_weight":      "flood_storm.png",
	"super_reach_test":          "autumn_canopy.png",
	# FLYER SPECIES-SPECIFIC
	"ptero_colony_dive":         "fish_water.png",
	"rhamph_dusk_window":        "fish_water.png",
	"dsun_tidal_flat":           "shared_waterhole.png",
	"anuro_swarm_hunt":          "insect_swarm.png",
	"jeholo_bark_hollow":        "burrow_entrance.png",
	"sordes_colony_warmth":      "dense_herd.png",
	"cear_fish_lock":            "fish_water.png",
	"tape_jungle_thermal":       "all_species_heavy_foilage_cover.png",
	"anhan_colonial_shoal":      "fish_water.png",
	"trope_cliff_run":           "cliff_ledge.png",
	"hatz_ground_hunt":          "meadow.png",
	"cryo_storm_flight":         "frozen_storm.png",
	"bone_ground_apex":          "meadow.png",
	"frost_storm_range":         "frozen_storm.png",
}

const _GRAZE_THREAT_IMAGES: Dictionary = {
	# Rival herbivores — use existing dino character art
	"Rival Triceratops Bull":      "res://assets/dinos/triceratops_adult.png",
	"Torosaurus Challenger":       "res://assets/dinos/triceratops_adult.png",
	"Rival Ankylosaurus":          "res://assets/dinos/ankylosaurus_adult.png",
	"Aggressive Rival Iguanodon":  "res://assets/dinos/iguanodon_adult.png",
	# Predators — reuse from hunt_images
	"Adult Tyrannosaur":           "res://assets/hunt_images/prey_rival_apex.png",
	"Juvenile Tyrannosaur":        "res://assets/hunt_images/prey_rival_apex.png",
	"Adult Allosaurus":            "res://assets/hunt_images/prey_rival_large.png",
	"Juvenile Allosaurus":         "res://assets/hunt_images/prey_rival_large.png",
	"Ceratosaurus Challenger":     "res://assets/hunt_images/prey_rival_large.png",
	"Lone Deinonychus":            "res://assets/hunt_images/prey_rival_dein.png",
	"Deinonychus Pair":            "res://assets/hunt_images/prey_rival_dein.png",
	"Juvenile Deinonychus":        "res://assets/hunt_images/prey_rival_dein.png",
	"Young Velociraptor":          "res://assets/hunt_images/prey_rival_medium.png",
	"Hungry Compsognathus Pair":   "res://assets/hunt_images/prey_rival_small.png",
	"Dromaeosaur Pack":            "res://assets/hunt_images/prey_raptor_pack.png",
	"Small Raptor Pack":           "res://assets/hunt_images/prey_raptor_pack.png",
	"Crocodyliform Near Water":    "res://assets/hunt_images/prey_croc.png",
	"Crocodyliform Near Mud":      "res://assets/hunt_images/prey_croc.png",
	"Large Crocodyliform":         "res://assets/hunt_images/prey_croc.png",
	"Ambush Snake":                "res://assets/hunt_images/prey_snake.png",
	"Large Ground Lizard":         "res://assets/hunt_images/prey_monitor.png",
	"Opportunistic Pterosaur":     "res://assets/hunt_images/prey_ptero_chick.png",
}

const _HUNT_PREY_IMAGES: Dictionary = {
	# Compsognathus prey
	"a cornered skink":              "prey_lizard_small.png",
	"an armored beetle":             "prey_beetle.png",
	"a thornback lizard":            "prey_lizard_small.png",
	"a mud frog":                    "prey_frog.png",
	"a lost hatchling":              "prey_hatchling.png",
	"a wounded mammal":              "prey_mammal_small.png",
	"a rival Compsognathus":         "prey_rival_small.png",
	"a giant centipede":             "prey_centipede.png",
	"a guard beetle":                "prey_beetle.png",
	"a young tree lizard":           "prey_lizard_small.png",
	"a trapped fish":                "prey_fish_small.png",
	"a fallen pterosaur chick":      "prey_ptero_chick.png",
	"a shell-cracker crab":          "prey_crab.png",
	"a grass snake":                 "prey_snake.png",
	"an injured raptor hatchling":   "prey_hatchling.png",
	"a grass lizard":                "prey_lizard_small.png",
	"a nest-guarding small creature":"prey_hatchling.png",
	"a cornered tiny mammal":        "prey_mammal_small.png",
	"a sharp-jawed fish":            "prey_fish_small.png",
	"a root-hollow predator":        "prey_rival_small.png",
	# Deinonychus prey
	"a young Dryosaurus":            "prey_ornithopod_juv.png",
	"a cornered Protoceratops":      "prey_ceratopsian_juv.png",
	"an injured ornithopod":         "prey_ornithopod_juv.png",
	"a rival Deinonychus":           "prey_rival_dein.png",
	"a thick-tailed lizard":         "prey_monitor.png",
	"a thornback juvenile":          "prey_ornithopod_juv.png",
	"a stray Triceratops calf":      "prey_ceratopsian_juv.png",
	"a fallen pterosaur":            "prey_ptero_chick.png",
	"a young Pachycephalosaur":      "prey_ornithopod_juv.png",
	"a nest-guarding Oviraptor":     "prey_oviraptor.png",
	"a wounded juvenile Iguanodon":  "prey_ornithopod_juv.png",
	"a small crocodyliform":         "prey_croc.png",
	"a giant monitor lizard":        "prey_monitor.png",
	"a young hadrosaur":             "prey_hadrosaur_juv.png",
	"a juvenile Ankylosaur":         "prey_ankylosaur_juv.png",
	# Velociraptor prey
	"a desert skink":                "prey_lizard_small.png",
	"a burrow lizard":               "prey_lizard_small.png",
	"a thornbrush mammal":           "prey_mammal_small.png",
	"a sand snake":                  "prey_snake.png",
	"a nest-guarding theropod":      "prey_oviraptor.png",
	"a young Protoceratops":         "prey_ceratopsian_juv.png",
	"a rival Velociraptor":          "prey_rival_medium.png",
	"a giant scorpion":              "prey_scorpion.png",
	"a thick-tailed gecko":          "prey_lizard_small.png",
	"a dust hare":                   "prey_mammal_small.png",
	"a young Oviraptor":             "prey_oviraptor.png",
	"an armored desert beetle":      "prey_beetle.png",
	"a juvenile Mononykus":          "prey_ornithopod_juv.png",
	"a rock-crack lizard":           "prey_lizard_small.png",
	# Allosaurus prey
	"a juvenile Camptosaurus":       "prey_ornithopod_juv.png",
	"a wounded ornithopod":          "prey_ornithopod_juv.png",
	"a young Stegosaurus":           "prey_stegosaur_juv.png",
	"a stray juvenile sauropod":     "prey_sauropod_juv.png",
	"a juvenile Kentrosaurus":       "prey_stegosaur_juv.png",
	"a rival Allosaurus":            "prey_rival_large.png",
	"a Ceratosaurus challenger":     "prey_rival_large.png",
	"a young thumb-spiked herbivore":"prey_ornithopod_juv.png",
	"a river crocodyliform":         "prey_croc.png",
	"an adult Dryosaurus":           "prey_hadrosaur_adult.png",
	"an injured Stegosaurus calf":   "prey_stegosaur_juv.png",
	"a thick-hided lizard":          "prey_monitor.png",
	"an isolated young hadrosaur":   "prey_hadrosaur_juv.png",
	# T-Rex prey
	"an adult hadrosaur":            "prey_hadrosaur_bull.png",
	"a young Triceratops":           "prey_trike_adult.png",
	"a defensive adult Triceratops": "prey_trike_adult.png",
	"a wounded Ankylosaurus":        "prey_anky_adult.png",
	"an adult Ankylosaurus":         "prey_anky_adult.png",
	"a juvenile Edmontosaurus":      "prey_hadrosaur_juv.png",
	"a bull Edmontosaurus":          "prey_hadrosaur_bull.png",
	"a Pachycephalosaurus challenger":"prey_ornithopod_juv.png",
	"a juvenile tyrannosaur rival":  "prey_rival_apex.png",
	"an adult tyrannosaur rival":    "prey_rival_apex.png",
	"a dromaeosaur pack":            "prey_raptor_pack.png",
	"a sickly Torosaurus":           "prey_trike_adult.png",
}


func _ready() -> void:
	_reading_frame.add_theme_stylebox_override("panel", ART.parchment())
	SettingsManager.interface_animations_changed.connect(_on_motion_setting)
	# Convert physical safe-area pixels to the scene's logical viewport units.
	if OS.get_name() == "iOS":
		var safe_area := DisplayServer.get_display_safe_area()
		var window_height := float(DisplayServer.window_get_size().y)
		var viewport_height := get_viewport().get_visible_rect().size.y
		var scale := viewport_height / window_height if window_height > 0.0 else 1.0
		_safe_top = maxi(24, int(safe_area.position.y * scale) + 8)
		_safe_bottom = maxi(40, int((window_height - safe_area.end.y) * scale) + 8)
	_bottom_section.add_theme_constant_override("margin_bottom", _safe_bottom)


# ── PUBLIC API ────────────────────────────────────────────────────────────────

const _TREX_ENCOUNTER_EVENTS: Array = [
	"anky_trex_test_bite", "anky_rex_learns", "trike_trex_standoff",
]

func show_event(event_data: Dictionary) -> void:
	_result_feedback.show_result(event_data.get("feedback"), event_data.get("reveal"))
	var ev_type: String = event_data.get("type", "") as String
	var ev_id:   String = event_data.get("id",   "") as String

	if ev_type == "combat_preview":
		SoundManager.start_combat_loop()
		SoundManager.pulse_haptic()
	else:
		SoundManager.stop_combat_loop()
		if ev_id in _TREX_ENCOUNTER_EVENTS:
			SoundManager.play("trex_encounter")

	_dismiss_id += 1
	var my_id := _dismiss_id

	# Scene art can override the event ID; world events otherwise use ID or type.
	var _img_key: String = event_data.get("image_key", ev_id if ev_id != "" else ev_type)
	var img_file: String = _EVENT_IMAGES.get(_img_key, "")
	var img_path: String = "res://assets/event_images/" + img_file
	var has_image: bool  = img_file != "" and _event_image != null and ResourceLoader.exists(img_path)

	if has_image:
		_event_image.texture                   = load(img_path)
		_event_image_wrap.custom_minimum_size  = Vector2(0, 300)
		_event_image_wrap.visible              = true
	else:
		if _event_image_wrap != null:
			_event_image_wrap.custom_minimum_size = Vector2(0, 0)
			_event_image_wrap.visible             = false
		# Hunt encounters carry a prey_name; look it up in _HUNT_PREY_IMAGES.
		var prey_name: String = event_data.get("prey_name", "") as String
		if not prey_name.is_empty():
			var hunt_img: String = _HUNT_PREY_IMAGES.get(prey_name, "") as String
			if not hunt_img.is_empty():
				var hunt_path: String = "res://assets/hunt_images/" + hunt_img
				if _event_image != null and ResourceLoader.exists(hunt_path):
					_event_image.texture                  = load(hunt_path)
					_event_image_wrap.custom_minimum_size = Vector2(0, 300)
					_event_image_wrap.visible             = true
					has_image = true
		# Graze encounters carry a predator_name; paths are stored in full in _GRAZE_THREAT_IMAGES.
		var predator_name: String = event_data.get("predator_name", "") as String
		if not has_image and not predator_name.is_empty():
			var threat_path: String = _GRAZE_THREAT_IMAGES.get(predator_name, "") as String
			if not threat_path.is_empty() and _event_image != null and ResourceLoader.exists(threat_path):
				_event_image.texture                  = load(threat_path)
				_event_image_wrap.custom_minimum_size = Vector2(0, 300)
				_event_image_wrap.visible             = true
				has_image = true

	var title:   String = event_data.get("title",   "") as String
	var flavor:  String = event_data.get("flavor",  "") as String
	var choices: Array  = event_data.get("choices", []) as Array
	# The half-height sheet cannot fit its title, reading viewport and safe footer on short phones.
	var is_compact: bool = get_viewport_rect().size.y >= 680 and not has_image and choices.size() <= 1 and flavor.length() < 120
	var top_section := _top_vbox.get_parent() as MarginContainer
	var reading_top := 0.06
	var reading_bottom := 0.58 if is_compact else 0.52
	var choices_top := 0.61 if is_compact else 0.55
	if has_image:
		reading_top = 0.24 if choices.size() > 3 else 0.32
		reading_bottom = 0.56 if choices.size() > 3 else 0.65
		choices_top = reading_bottom + 0.025
		_event_image_wrap.anchor_bottom = reading_top + 0.08
	for section in [top_section, _reading_frame]:
		section.anchor_top = reading_top
		section.anchor_bottom = reading_bottom
	_bottom_section.anchor_top = choices_top

	var bg_style := StyleBoxFlat.new()
	if is_compact:
		_popup_panel.anchor_top    = 0.52
		_popup_panel.anchor_bottom = 1.0
		if _dim_overlay != null:
			_dim_overlay.visible = true
		bg_style.bg_color                = Color(0.08, 0.13, 0.105, 1.0)
		bg_style.corner_radius_top_left  = 18
		bg_style.corner_radius_top_right = 18
	else:
		_popup_panel.anchor_top    = 0.0
		_popup_panel.anchor_bottom = 1.0
		if _dim_overlay != null:
			_dim_overlay.visible = false
		bg_style.bg_color = Color(0.08, 0.13, 0.105, 1.0)
	if _bg_panel != null:
		_bg_panel.add_theme_stylebox_override("panel", bg_style)

	if title.is_empty():
		match ev_type:
			"consistency_bonus":   title = "Bonus"
			"consistency_penalty": title = "Setback"
			"info":                title = "Notice"

	# Separate the "back" action — rendered as a small floating button at the
	# bottom-left of the popup so it doesn't occupy a grid slot.
	var main_choices: Array = []
	var has_back := false
	for c in choices:
		if (c.get("action", "") as String) == "back":
			has_back = true
		else:
			main_choices.append(c)
	_bottom_section.add_theme_constant_override("margin_bottom", _safe_bottom + (40 if has_back else 0))

	# Clean up any lingering back button from a previous event.
	if is_instance_valid(_back_btn):
		_back_btn.queue_free()
		_back_btn = null

	# Apply top margin: compact popup is at the screen bottom so notch clearance
	# is irrelevant there; full-screen mode needs the full safe-area value.
	top_section.add_theme_constant_override("margin_top", 18 if is_compact or has_image else _safe_top)

	# Season accent — tints title, rule, and buttons.
	_current_accent = _get_accent_color()
	var title_display_color := _current_accent.darkened(0.68)
	_title_label.add_theme_color_override("font_color", title_display_color)

	_title_label.text = title
	_title_label.visible = not title.is_empty()

	# Update rule color and visibility.
	if _title_rule != null:
		var rs := StyleBoxFlat.new()
		rs.bg_color = Color(_current_accent.r, _current_accent.g, _current_accent.b, 0.55)
		_title_rule.add_theme_stylebox_override("panel", rs)
		_title_rule.visible = not title.is_empty()

	_start_typewriter(flavor)
	if event_data.get("instant_text", false) or (ev_type == "info" and choices.all(func(choice): return choice.get("action", "ok") in ["ok", "back", "close", "continue"])):
		_finish_typewriter()
	var choices_scroll := _choices_grid.get_parent() as ScrollContainer
	choices_scroll.scroll_vertical = 0

	for child in _choices_grid.get_children():
		child.queue_free()

	if main_choices.is_empty():
		if title.is_empty():
			# Result/flavor — player reads then continues at their own pace
			_choices_grid.columns = 1
			var cont_btn := _make_btn("Continue", "ok")
			cont_btn.custom_minimum_size = Vector2(0, 46)
			_choices_grid.add_child(cont_btn)
			cont_btn.pressed.connect(func():
				if _dismiss_id == my_id:
					_on_choice("ok")
			)
		else:
			# Named info event — player taps OK
			_choices_grid.columns = 1
			var ok_btn := _make_btn("OK", "ok")
			ok_btn.custom_minimum_size = Vector2(0, 46)
			_choices_grid.add_child(ok_btn)
			ok_btn.pressed.connect(func():
				if _dismiss_id == my_id:
					_on_choice("ok")
			)
	else:
		if main_choices.size() == 1:
			_choices_grid.columns = 1
			var action_id: String = main_choices[0].get("action", "")
			var lbl: String       = main_choices[0].get("label",  action_id)
			var btn       := _make_btn(lbl, action_id)
			btn.custom_minimum_size = Vector2(0, 46)
			_choices_grid.add_child(btn)
			btn.pressed.connect(func():
				if _dismiss_id == my_id:
					_on_choice(action_id)
			)
		else:
			# 2 columns when all labels fit ~18 chars, else 1 column for longer text.
			var max_label_len := 0
			for choice in main_choices:
				max_label_len = maxi(max_label_len, (choice.get("label", "") as String).length())
			var cols := 2 if (main_choices.size() >= 3 and max_label_len <= 18) else 1
			_choices_grid.columns = cols
			var wrap_chars := 13 if cols == 2 else 38
			for choice in main_choices:
				var action_id: String = choice.get("action",   "")
				var lbl: String       = choice.get("label",    action_id)
				var sublbl: String    = choice.get("sublabel", "")
				var btn       := _make_btn(lbl, action_id, sublbl, wrap_chars)
				btn.size_flags_vertical = Control.SIZE_SHRINK_CENTER
				_choices_grid.add_child(btn)
				btn.pressed.connect(func():
					if _dismiss_id == my_id:
						_on_choice(action_id)
				)

	# Add the small floating back button if this event supports backing out.
	if has_back:
		_back_btn = _make_back_btn()
		_popup_panel.add_child(_back_btn)
		_back_btn.pressed.connect(func():
			if _dismiss_id == my_id:
				_on_choice("back")
		)

	# Even on the smallest phone, a complete choice must fit in its scroll window.
	var tallest_choice := 0.0
	for button in _choices_grid.get_children():
		if not button.is_queued_for_deletion():
			tallest_choice = maxf(tallest_choice, button.get_combined_minimum_size().y)
	var popup_height := get_viewport_rect().size.y * (0.48 if is_compact else 1.0)
	var choice_space := tallest_choice + _bottom_section.get_theme_constant("margin_bottom") + 8
	choices_top = minf(choices_top, 1.0 - choice_space / popup_height)
	_bottom_section.anchor_top = choices_top
	for section in [top_section, _reading_frame]:
		section.anchor_bottom = minf(reading_bottom, choices_top - 0.025)
	get_parent().move_child(self, -1)
	visible = true
	_play_show_animation(is_compact)


func hide_overlay() -> void:
	SoundManager.stop_combat_loop()
	_result_feedback.finish_animation()
	if is_instance_valid(_show_tween):
		_show_tween.kill()
		_show_tween = null
	visible = false

	_popup_panel.modulate.a    = 1.0
	_popup_panel.offset_top    = 0.0
	_popup_panel.offset_bottom = 0.0
	if _dim_overlay != null:
		_dim_overlay.visible = false
	for child in _choices_grid.get_children():
		child.queue_free()
	if is_instance_valid(_back_btn):
		_back_btn.queue_free()
		_back_btn = null


# ── INTERNAL ─────────────────────────────────────────────────────────────────

func _on_motion_setting(_enabled: bool) -> void:
	if is_instance_valid(_show_tween): _show_tween.kill()
	_popup_panel.offset_top = 0.0
	_popup_panel.offset_bottom = 0.0
	_popup_panel.modulate.a = 1.0


func _on_choice(action_id: String) -> void:
	# First tap while text is still animating: show the full text and wait.
	if _tw_idx < _tw_full.length():
		_finish_typewriter()
		return
	_dismiss_id += 1
	hide_overlay()
	choice_made.emit(action_id)


func _input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return
	var pointer: bool = event is InputEventScreenTouch or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT)
	if not pointer:
		return
	# Consume the complete revealing gesture, including emulated mouse events.
	# A tap on a choice must reveal text without selecting that choice as well.
	if _revealing_gesture:
		_revealing_gesture = event.pressed
		get_viewport().set_input_as_handled()
	elif event.pressed and _tw_idx < _tw_full.length():
		_revealing_gesture = true
		_finish_typewriter()
		get_viewport().set_input_as_handled()


func _start_typewriter(full_text: String) -> void:
	_revealing_gesture = false
	_tw_full = full_text
	_tw_idx  = 0
	_tw_elapsed = 0.0
	_flavor_label.text = full_text
	_flavor_label.visible_characters = 0
	_flavor_scroll.scroll_vertical = 0


func _process(delta: float) -> void:
	if not visible or _tw_idx >= _tw_full.length():
		return
	_tw_elapsed += delta
	_tw_idx = mini(int(_tw_elapsed / 0.03), _tw_full.length())
	_flavor_label.visible_characters = _tw_idx


func _finish_typewriter() -> void:
	_tw_idx            = _tw_full.length()
	_flavor_label.visible_characters = -1


func _get_accent_color() -> Color:
	match GameState.current_season:
		0: return Color(0.38, 0.82, 0.70)   # Wet   — teal
		1: return Color(1.00, 0.68, 0.20)   # Dry   — amber
		2: return Color(0.90, 0.50, 0.72)   # Mating — rose
		3: return Color(0.52, 0.72, 0.92)   # Cold  — steel blue
	return Color(0.85, 0.72, 0.35)          # fallback gold


func _play_show_animation(is_compact: bool) -> void:
	if is_instance_valid(_show_tween):
		_show_tween.kill()
	if not SettingsManager.interface_animations_enabled:
		_popup_panel.offset_top = 0.0
		_popup_panel.offset_bottom = 0.0
		_popup_panel.modulate.a = 1.0
		return
	if is_compact:
		_popup_panel.modulate.a = 1.0
		var screen_h := get_viewport().get_visible_rect().size.y
		var popup_h  := screen_h * 0.48  # matches anchor_top 0.52 → popup is 48% of screen
		_popup_panel.offset_top    = popup_h
		_popup_panel.offset_bottom = popup_h
		var tw := create_tween()
		_show_tween = tw
		tw.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tw.tween_method(func(v: float):
			_popup_panel.offset_top    = v
			_popup_panel.offset_bottom = v
		, popup_h, 0.0, 0.25)
	else:
		_popup_panel.offset_top    = 0.0
		_popup_panel.offset_bottom = 0.0
		_popup_panel.modulate.a    = 0.0
		var tw := create_tween()
		_show_tween = tw
		tw.set_ease(Tween.EASE_OUT)
		tw.tween_property(_popup_panel, "modulate:a", 1.0, 0.20)


# Measure each line so costs and consequences stay readable on narrow phones.
func _wrap_label(text: String, max_chars: int = 16) -> String:
	var width := get_viewport_rect().size.x * 0.92 - 40.0
	if max_chars <= 18:
		width = (width - 8.0) / 2.0
	width = maxf(60.0, width - 44.0) # Keep text inside the illustrated border.
	var font := get_theme_font("font", "Button")
	var lines: Array[String] = []
	for paragraph in text.split("\n"):
		var line := ""
		for word in paragraph.split(" ", false):
			var candidate := word if line.is_empty() else line + " " + word
			if not line.is_empty() and font.get_string_size(candidate, HORIZONTAL_ALIGNMENT_LEFT, -1, 16).x > width:
				lines.append(line)
				line = word
			else:
				line = candidate
		lines.append(line)
	return "\n".join(lines)


func _make_btn(lbl: String, _action_id: String, sublbl: String = "", max_label_chars: int = 38) -> Button:
	var btn := Button.new()
	btn.mouse_filter = Control.MOUSE_FILTER_PASS
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn.size_flags_vertical   = Control.SIZE_SHRINK_CENTER
	btn.custom_minimum_size   = Vector2(60, 50)
	btn.focus_mode            = Control.FOCUS_ALL
	btn.clip_text             = false
	btn.accessibility_name = lbl + ". " + sublbl
	var wrapped_lbl    := _wrap_label(lbl,    max_label_chars)
	var wrapped_sublbl := _wrap_label(sublbl, max_label_chars) if sublbl.strip_edges() != "" else ""
	btn.text = (wrapped_lbl + "\n" + wrapped_sublbl) if wrapped_sublbl != "" else wrapped_lbl
	btn.add_theme_font_size_override("font_size", 16)
	btn.add_theme_color_override("font_color", Color(1.00, 0.92, 0.72))

	ART.button(btn)
	for state in ["normal", "hover", "pressed", "disabled"]:
		var style := btn.get_theme_stylebox(state)
		style.content_margin_left = 22
		style.content_margin_right = 22
		style.content_margin_top = 16
		style.content_margin_bottom = 16
	preload("res://scripts/ui/choice_motion.gd").attach(btn)
	return btn


# Small "← Back" button anchored to the bottom-left corner of the popup panel.
func _make_back_btn() -> Button:
	var btn := Button.new()
	btn.layout_mode = 1
	btn.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	btn.offset_left   = 12
	btn.offset_bottom = -_safe_bottom
	btn.offset_right  = 96
	btn.offset_top    = -_safe_bottom - 32
	btn.flat          = true
	btn.focus_mode    = Control.FOCUS_NONE
	btn.text          = "← Back"
	btn.add_theme_font_size_override("font_size", 13)
	btn.add_theme_color_override("font_color",       Color(0.70, 0.60, 0.42, 0.90))
	btn.add_theme_color_override("font_hover_color", Color(0.90, 0.78, 0.55, 1.00))
	return btn
