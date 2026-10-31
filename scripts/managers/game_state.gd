extends Node

# Holds the active run's live state. Reset at the start of each new run.

var species_id: String = ""
var life_stage: int = 0  # 0=Hatchling 1=Juvenile 2=Sub-adult 3=Adult 4=Elder
var current_season: int = 0  # 0=Wet 1=Dry 2=Mating 3=Cold
var current_year: int = 1
var seasons_elapsed: int = 0

# Stats (0.0 - 1.0, species-relative)
var health: float = 1.0
var hunger: float = 1.0
var strength: float = 0.0
var speed: float = 0.0
var defense: float = 0.0
var type_stat: float = 0.0  # stealth / herd_bond / stamina depending on tree

# Daily luck — hidden, rolled each turn, influences outcome probability
var daily_luck: float = 0.0


# Hidden values never shown to player
var size: int = 1
var is_alpha: bool = false
var pack_alpha_name: String = "" # Named incumbent/previous alpha in the current group.
var pack_bond: float = 1.0
var turns_solo: int = 0
var territory_bonus_turns: int = 0
var territory_claim: String = ""          # active claim this season (applied to hunt rolls)
var pending_territory_claim: String = ""  # marked this season, activates next season

# Run record (shown on death screen)
var kills: int = 0
var fights_won: int = 0
var fights_lost: int = 0
var fights_lost_bad: int = 0   # bad losses specifically (diff < -0.30)
var fights_fled: int = 0
var kin_created: int = 0
var miles_traveled: float = 0.0
var night_hunts: int = 0
var bonuses_earned: Array = []
var earned_perks: Array = []
var bonus_stat_grants: Dictionary = {}
var mate_name: String = ""
var offspring_name: String = ""
var juvenile_name: String = ""
var offspring_history: Array = []
var life_events: Array = []
var companions: Array = []
var companion_group_id: int = 0
var companion_event: Dictionary = {}
var companion_event_count: int = 0
var companion_last_event_season: int = -1
var world_state: Dictionary = {}
var journey_state: Dictionary = {}
var discovery_state: Dictionary = {}
var living_state: Dictionary = {}
var council_state: Dictionary = {}
var pack_relations: Dictionary = {}
var pack_story_state: Dictionary = {}
var habitat_state: Dictionary = {}
var family_state: Dictionary = {}

# Diminishing returns tracker (reset each turn)
var action_uses: Dictionary = {}

# Rewarded ad tracking (reset each season)
var ad_bonus_training_used: bool = false

# Permanent stat modifiers from consistency bonuses/penalties
var permanent_health_mod: float = 0.0
var permanent_defense_mod: float = 0.0
var permanent_strength_mod: float = 0.0
var permanent_speed_mod: float = 0.0

# Stat histories for consistency bonus tracking
var hunger_history: Array = []
var health_history: Array = []
var type_stat_history: Array = []
const HUNGER_HISTORY_LENGTH = 8

const SEASON_NAMES = ["Wet", "Dry", "Mating", "Cold"]
const STAGE_NAMES = ["Hatchling", "Juvenile", "Sub-adult", "Adult", "Elder"]

# Active temporary buffs/debuffs: { stat, amount, turns_remaining, source }
var temp_buffs: Array = []

# Persistent injuries: { name, stat, amount, turns_remaining, permanent, untreated_turns }
# amount is always negative. Applied to stat on creation, reversed on heal.
var injuries: Array = []
var turns_since_rest: int = 0

# Player preferences — persist across all runs, never reset
var show_tutorial: bool = true   # set from the character select checkbox

# Mating & reproduction — sex persists across runs; others reset each run
var sex: String = "male"      # set on character select before start_run
var has_mate: bool = false
var mate_was_alpha: bool = true  # false when female mates with a subordinate
var alpha_breed_pending: bool = false  # true when alpha won challenge during mating season; fires breeding next turn
var sub_mating_done: bool = false      # prevents sub-male mating event firing twice per mating season
var pending_egg: bool = false
var has_young: bool = false
var has_young_turns: int = 0
var nesting_score: float = 0.0   # accumulates during has_young period; drives pack_bond outcome
var alpha_suspects: bool = false  # alpha suspects female mated with non-alpha
var alpha_court_bonus: float = 0.0        # reserved for future mating style modifiers
var alpha_display_done: bool = false      # true once alpha mating season event has fired this season
var alpha_seasons_unchallenged: int = 0   # seasons since last rival challenge; raises rival chance
var female_prep_done: bool = false        # true once female nesting prep event has fired this season
var species_mating_done: bool = false     # true once Pattern A/B mating event has fired this season (male or female)
var male_mating_streak: int = 0          # consecutive seasons Pattern A male has mated successfully
var male_streak_boost_tier: int = 0     # permanent strength boosts earned from streak (max 2)
var breed_effort_pending: bool = false   # Pattern B: true after tournament win; chains effort event next process cycle
var next_season_graze_crit_bonus:    float = 0.0  # promoted from pending at season start; consumed by graze crit
var next_season_graze_success_bonus: float = 0.0  # promoted from pending at season start; consumed by graze success
var pending_graze_crit_bonus:        float = 0.0  # set by territory claim this season; promotes next season
var pending_graze_success_bonus:     float = 0.0  # set by territory claim this season; promotes next season
var active_hatchling_outcomes: Dictionary = {}  # temp: outcome pools for the current hatchling event
var good_parent_seasons: int = 0    # hatchling seasons where nesting_score was above threshold
var good_parent_boosts: int = 0     # permanent boosts earned from consistent good parenting (max 2)
var solo_raise_boosts: int = 0      # permanent boosts earned from successful solo raises (max 2)
var juvenile_lesson_score: float = 0.0      # accumulates during juvenile phase from parent events
var juvenile_lesson_done: bool = false      # true once juvenile outcome has resolved
var juvenile_outcome_pending: bool = false  # set when life_stage hits 2; fires outcome next turn
var active_juvenile_outcomes: Dictionary = {}  # temp: outcome pools for current juvenile event
var mother_bond: float = 0.0                    # T-Rex/Allosaurus/Ankylosaurus: accumulates during juvenile phase (child's perspective)
var active_mother_bond_outcomes: Dictionary = {} # temp: nested outcome pools for mother bond events

# Maternal bond — female player raising her own juvenile offspring (parent's perspective)
var has_juvenile:             bool    = false   # offspring is currently in juvenile phase
var juvenile_bond_turns:      int     = 0       # seasons offspring has been in juvenile phase
var offspring_bond:           float   = 0.0     # accumulated maternal bond score this generation
var offspring_bond_start:     float   = 0.0     # carry-over starting value from prior successful raise
var maternal_outcome_pending: bool    = false   # departure resolution queued for next season
var maternal_bond_done:       bool    = false   # departure outcome already resolved this generation
var active_maternal_outcomes: Dictionary = {}   # temp: outcome pools for current maternal event
var death_cause: String   = ""  # "starvation" | "combat" | "wounds" | "natural" | "elder_event" | "elder_glory" | ""
var death_detail: String  = ""  # creature name for combat, "Season, Year N" for starvation
var lifespan_reduction: int = 0       # seasons lost to injury accumulation
var total_injuries_sustained: int = 0 # raw count across the run
var elder_final_event_triggered: bool = false  # fires once per run after 3 elder seasons

# Rival — a named antagonist that develops through repeated encounters
var rival_name: String = ""
var rival_encounters: int = 0

const _RIVAL_NAMES_PREDATOR = [
	"the pale one", "the scarred hunter", "the one that follows",
	"the persistent shadow", "the old wound", "the relentless",
	"the hollow-eyed one", "the patient hunter",
]
const _RIVAL_NAMES_HERBIVORE = [
	"the shadow at the tree line", "the patient one", "the hollow-eyed predator",
	"the one that waits", "the persistent threat", "the weathered hunter",
	"the scarred one", "the old scar",
]


func is_desperate() -> bool:
	return health < 0.25 or hunger < 0.20


func assign_rival(species_tree: String) -> void:
	if rival_name != "":
		rival_encounters += 1
		return
	var pool: Array = _RIVAL_NAMES_HERBIVORE if species_tree == "herbivore" else _RIVAL_NAMES_PREDATOR
	rival_name      = pool[randi() % pool.size()]
	rival_encounters = 1


func start_run(p_species_id: String) -> void:
	if p_species_id not in UnlockManager.PLAYABLE_SPECIES:
		push_error("Species is not playable in the first edition: " + p_species_id)
		return
	species_id = p_species_id
	life_stage = 0
	current_season = 0
	current_year = 1
	seasons_elapsed = 0
	health = 1.0
	hunger = 1.0
	is_alpha = false
	pack_alpha_name = ""
	pack_bond = 0.5
	turns_solo = 0
	territory_bonus_turns       = 0
	territory_claim             = ""
	pending_territory_claim     = ""
	kills = 0
	fights_won = 0
	fights_lost     = 0
	fights_lost_bad = 0
	fights_fled     = 0
	kin_created = 0
	miles_traveled = 0.0
	night_hunts = 0
	bonuses_earned = []
	earned_perks = []
	bonus_stat_grants = {}
	mate_name = ""
	offspring_name = ""
	juvenile_name = ""
	offspring_history = []
	life_events = []
	companions = []
	companion_group_id = 0
	companion_event = {}
	companion_event_count = 0
	companion_last_event_season = -1
	world_state = {}
	journey_state = {}
	discovery_state = preload("res://scripts/systems/discoveries.gd").restore(null)
	living_state = {}
	council_state = {}
	pack_relations = {}
	pack_story_state = {}
	habitat_state = {}
	family_state = {}
	action_uses = {}
	ad_bonus_training_used = false
	permanent_health_mod = 0.0
	permanent_defense_mod = 0.0
	permanent_strength_mod = 0.0
	permanent_speed_mod = 0.0
	hunger_history = []
	health_history = []
	type_stat_history = []
	temp_buffs = []
	injuries = []
	turns_since_rest = 0
	has_mate = false
	mate_was_alpha = true
	alpha_breed_pending = false
	sub_mating_done = false
	species_mating_done = false
	male_mating_streak = 0
	male_streak_boost_tier = 0
	breed_effort_pending = false
	next_season_graze_crit_bonus    = 0.0
	next_season_graze_success_bonus = 0.0
	pending_graze_crit_bonus        = 0.0
	pending_graze_success_bonus     = 0.0
	pending_egg = false
	has_young = false
	has_young_turns = 0
	nesting_score = 0.0
	alpha_suspects = false
	alpha_court_bonus = 0.0
	alpha_display_done = false
	alpha_seasons_unchallenged = 0
	female_prep_done = false
	active_hatchling_outcomes = {}
	good_parent_seasons = 0
	good_parent_boosts  = 0
	solo_raise_boosts   = 0
	juvenile_lesson_score    = 0.0
	juvenile_lesson_done     = false
	juvenile_outcome_pending = false
	active_juvenile_outcomes = {}
	mother_bond                   = 0.0
	active_mother_bond_outcomes   = {}
	has_juvenile             = false
	juvenile_bond_turns      = 0
	offspring_bond           = 0.0
	offspring_bond_start     = 0.0
	maternal_outcome_pending = false
	maternal_bond_done       = false
	active_maternal_outcomes = {}
	death_cause   = ""
	death_detail  = ""
	lifespan_reduction = 0
	total_injuries_sustained = 0
	elder_final_event_triggered = false
	rival_name = ""
	rival_encounters = 0
	var species = SpeciesDB.get_species(p_species_id)
	if species:
		strength = species.base_strength
		speed = species.base_speed
		defense = species.base_defense
		type_stat = species.base_type_stat
		size = species.base_size
	preload("res://scripts/systems/family_legacy.gd").inherit(LegacyManager.take_family_lesson(p_species_id))


func advance_season() -> void:
	seasons_elapsed += 1
	current_season = (current_season + 1) % 4
	if current_season == 0:
		current_year += 1
	hunger_history.append(hunger)
	health_history.append(health)
	type_stat_history.append(type_stat)
	if hunger_history.size() > HUNGER_HISTORY_LENGTH:
		hunger_history.pop_front()
		health_history.pop_front()
		type_stat_history.pop_front()
	action_uses.clear()
	ad_bonus_training_used = false
	if current_season == 0:
		has_mate = false
		mate_was_alpha = true
	# Promote pending graze bonuses earned last season — active bonus survives until consumed by graze
	next_season_graze_crit_bonus    = pending_graze_crit_bonus
	next_season_graze_success_bonus = pending_graze_success_bonus
	pending_graze_crit_bonus        = 0.0
	pending_graze_success_bonus     = 0.0
	if current_season == 2:
		alpha_display_done  = false  # allow alpha and female events to fire each new mating season
		female_prep_done    = false
		alpha_breed_pending = false
		sub_mating_done     = false
		species_mating_done  = false
		breed_effort_pending = false
	if has_young:
		has_young_turns += 1
		# Expiry is checked in TurnManager._check_nesting_outcome() to allow event firing
	if has_juvenile:
		juvenile_bond_turns += 1
		# Expiry is checked in TurnManager._check_maternal_bond_event()


func get_action_uses(action_id: String) -> int:
	return action_uses.get(action_id, 0)


func record_action_use(action_id: String) -> void:
	action_uses[action_id] = action_uses.get(action_id, 0) + 1


func reset_action_uses() -> void:
	action_uses.clear()


func get_stage_name() -> String:
	return STAGE_NAMES[life_stage]


func get_season_name() -> String:
	return SEASON_NAMES[current_season]


func is_mating_season() -> bool:
	return current_season == 2


func get_min_mate_stage() -> int:
	var species = SpeciesDB.get_species(species_id)
	var max_sz: int = species.get("max_size", 1)
	return species.get("min_mate_stage", 2 if max_sz <= 3 else 3)


func can_mate() -> bool:
	return is_mating_season() and life_stage >= get_min_mate_stage() and not has_mate


func apply_temp_buff(stat: String, amount: float, turns: int, source: String) -> void:
	# Remove existing buff from same source before applying new one
	temp_buffs = temp_buffs.filter(func(b): return b["source"] != source)
	temp_buffs.append({ "stat": stat, "amount": amount, "turns_remaining": turns, "source": source })
	var current = get(stat)
	if current != null:
		set(stat, clampf(current + amount, 0.0, 1.0))


func tick_temp_buffs() -> void:
	var expired: Array = []
	for buff in temp_buffs:
		buff["turns_remaining"] -= 1
		if buff["turns_remaining"] <= 0:
			expired.append(buff)
			var current = get(buff["stat"])
			if current != null:
				set(buff["stat"], clampf(current - buff["amount"], 0.0, 1.0))
	for b in expired:
		temp_buffs.erase(b)


func roll_daily_luck() -> void:
	# Average two rolls to weight toward neutral — extreme luck days are rarer
	daily_luck = (randf_range(-1.0, 1.0) + randf_range(-1.0, 1.0)) * 0.5


func luck_mod() -> float:
	return daily_luck * 0.15


func get_season_key() -> String:
	return ["spring", "summer", "fall", "winter"][current_season]


# ── INJURY SYSTEM ─────────────────────────────────────────────────────────────

func apply_injury(injury: Dictionary) -> void:
	var stat = injury.get("stat", "health")
	var amount = injury.get("amount", -0.10)
	var turns = injury.get("turns", 3)
	var permanent = turns == -1

	# If the same body part is hit again, worsen existing injury
	for existing in injuries:
		if existing["stat"] == stat and not existing["permanent"]:
			var extra = amount * 0.5
			existing["amount"] += extra
			existing["turns_remaining"] += 2
			var current = get(stat)
			if current != null:
				set(stat, clampf(current + extra, 0.0, 1.0))
			return

	var entry = {
		"name":            injury.get("name", "Injury"),
		"stat":            stat,
		"amount":          amount,
		"turns_remaining": turns,
		"permanent":       permanent,
		"untreated_turns": 0,
	}
	injuries.append(entry)
	var current = get(stat)
	if current != null:
		set(stat, clampf(current + amount, 0.0, 1.0))
	# Accumulate lifespan cost — permanent injuries cost more
	total_injuries_sustained += 1
	var cost := 3 if permanent else 1
	lifespan_reduction = mini(lifespan_reduction + cost, 16)


func tick_injuries_on_rest() -> void:
	turns_since_rest = 0
	var healed: Array = []
	for injury in injuries:
		if injury["permanent"]:
			continue
		injury["turns_remaining"] -= 1
		injury["untreated_turns"] = 0
		if injury["turns_remaining"] <= 0:
			healed.append(injury)
	for injury in healed:
		injuries.erase(injury)
		var current = get(injury["stat"])
		if current != null:
			set(injury["stat"], clampf(current - injury["amount"], 0.0, 1.0))


func tick_injuries_on_tend() -> void:
	var healed: Array = []
	for injury in injuries:
		if injury["permanent"]:
			continue
		injury["turns_remaining"] -= 1
		injury["untreated_turns"] = 0
		if injury["turns_remaining"] <= 0:
			healed.append(injury)
	for injury in healed:
		injuries.erase(injury)
		var current = get(injury["stat"])
		if current != null:
			set(injury["stat"], clampf(current - injury["amount"], 0.0, 1.0))


func tick_injuries_untreated() -> void:
	turns_since_rest += 1
	for injury in injuries:
		if injury["permanent"]:
			continue
		injury["untreated_turns"] += 1
		# After 4 untreated turns, injury worsens
		if injury["untreated_turns"] >= 4 and randf() < 0.30:
			var worsen = injury["amount"] * 0.25
			injury["amount"] += worsen
			injury["turns_remaining"] += 1
			injury["untreated_turns"] = 0
			var current = get(injury["stat"])
			if current != null:
				set(injury["stat"], clampf(current + worsen, 0.0, 1.0))


func shorten_injuries(turns: int) -> void:
	var healed: Array = []
	for injury in injuries:
		if injury["permanent"]:
			continue
		injury["turns_remaining"] = maxi(injury["turns_remaining"] - turns, 0)
		if injury["turns_remaining"] <= 0:
			healed.append(injury)
	for injury in healed:
		injuries.erase(injury)
		var current = get(injury["stat"])
		if current != null:
			set(injury["stat"], clampf(current - injury["amount"], 0.0, 1.0))


func has_injury_on(stat: String) -> bool:
	for injury in injuries:
		if injury["stat"] == stat:
			return true
	return false


func get_injury_label(injury: Dictionary) -> String:
	if injury["permanent"]:
		return "%s (permanent)" % injury["name"]
	return "%s (%d)" % [injury["name"], injury["turns_remaining"]]


# ── SAVE / LOAD ───────────────────────────────────────────────────────────────

const SAVE_PATH = "user://dinolife_save.json"

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)


func delete_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_PATH))


func save_run() -> void:
	var data = {
		"species_id": species_id,
		"life_stage": life_stage,
		"current_season": current_season,
		"current_year": current_year,
		"seasons_elapsed": seasons_elapsed,
		"health": health,
		"hunger": hunger,
		"strength": strength,
		"speed": speed,
		"defense": defense,
		"type_stat": type_stat,
		"daily_luck": daily_luck,
		"size": size,
		"is_alpha": is_alpha,
		"pack_alpha_name": pack_alpha_name,
		"pack_bond": pack_bond,
		"turns_solo": turns_solo,
		"territory_bonus_turns":      territory_bonus_turns,
		"territory_claim":            territory_claim,
		"pending_territory_claim":    pending_territory_claim,
		"kills": kills,
		"fights_won": fights_won,
		"fights_lost": fights_lost,
		"fights_lost_bad": fights_lost_bad,
		"fights_fled": fights_fled,
		"kin_created": kin_created,
		"miles_traveled": miles_traveled,
		"night_hunts": night_hunts,
		"bonuses_earned": bonuses_earned,
		"earned_perks": earned_perks,
		"bonus_stat_grants": bonus_stat_grants,
		"mate_name": mate_name,
		"offspring_name": offspring_name,
		"juvenile_name": juvenile_name,
		"offspring_history": offspring_history,
		"life_events": life_events,
		"companions": companions,
		"companion_group_id": companion_group_id,
		"companion_event": companion_event,
		"companion_event_count": companion_event_count,
		"companion_last_event_season": companion_last_event_season,
		"world_state": world_state,
		"journey_state": journey_state,
		"discovery_state": discovery_state,
		"living_state": living_state,
		"council_state": council_state,
		"pack_relations": pack_relations,
		"pack_story_state": pack_story_state,
		"habitat_state": habitat_state,
		"family_state": family_state,
		"action_uses": action_uses,
		"ad_bonus_training_used": ad_bonus_training_used,
		"permanent_health_mod": permanent_health_mod,
		"permanent_defense_mod": permanent_defense_mod,
		"permanent_strength_mod": permanent_strength_mod,
		"permanent_speed_mod": permanent_speed_mod,
		"hunger_history": hunger_history,
		"health_history": health_history,
		"type_stat_history": type_stat_history,
		"temp_buffs": temp_buffs,
		"injuries": injuries,
		"turns_since_rest": turns_since_rest,
		"sex": sex,
		"has_mate": has_mate,
		"mate_was_alpha": mate_was_alpha,
		"alpha_breed_pending": alpha_breed_pending,
		"sub_mating_done": sub_mating_done,
		"species_mating_done": species_mating_done,
		"male_mating_streak": male_mating_streak,
		"male_streak_boost_tier": male_streak_boost_tier,
		"breed_effort_pending": breed_effort_pending,
		"next_season_graze_crit_bonus":    next_season_graze_crit_bonus,
		"next_season_graze_success_bonus": next_season_graze_success_bonus,
		"pending_graze_crit_bonus":        pending_graze_crit_bonus,
		"pending_graze_success_bonus":     pending_graze_success_bonus,
		"pending_egg": pending_egg,
		"has_young": has_young,
		"has_young_turns": has_young_turns,
		"nesting_score": nesting_score,
		"alpha_suspects": alpha_suspects,
		"alpha_court_bonus": alpha_court_bonus,
		"alpha_display_done": alpha_display_done,
		"alpha_seasons_unchallenged": alpha_seasons_unchallenged,
		"female_prep_done":           female_prep_done,
		"good_parent_seasons":        good_parent_seasons,
		"good_parent_boosts":         good_parent_boosts,
		"solo_raise_boosts":          solo_raise_boosts,
		"juvenile_lesson_score":      juvenile_lesson_score,
		"juvenile_lesson_done":       juvenile_lesson_done,
		"juvenile_outcome_pending":   juvenile_outcome_pending,
		"mother_bond":                mother_bond,
		"has_juvenile":             has_juvenile,
		"juvenile_bond_turns":      juvenile_bond_turns,
		"offspring_bond":           offspring_bond,
		"offspring_bond_start":     offspring_bond_start,
		"maternal_outcome_pending": maternal_outcome_pending,
		"maternal_bond_done":       maternal_bond_done,
		"death_cause": death_cause,
		"death_detail": death_detail,
		"elder_final_event_triggered": elder_final_event_triggered,
		"rival_name": rival_name,
		"rival_encounters": rival_encounters,
		"lifespan_reduction": lifespan_reduction,
		"total_injuries_sustained": total_injuries_sustained,
	}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()


func load_run() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return false
	var text = file.get_as_text()
	file.close()
	var data = JSON.parse_string(text)
	if not data is Dictionary:
		return false
	if data.get("species_id", "") not in UnlockManager.PLAYABLE_SPECIES:
		return false
	species_id                = data.get("species_id", "")
	life_stage                = data.get("life_stage", 0)
	current_season            = data.get("current_season", 0)
	current_year              = data.get("current_year", 1)
	seasons_elapsed           = data.get("seasons_elapsed", 0)
	health                    = data.get("health", 1.0)
	hunger                    = data.get("hunger", 1.0)
	strength                  = data.get("strength", 0.0)
	speed                     = data.get("speed", 0.0)
	defense                   = data.get("defense", 0.0)
	type_stat                 = data.get("type_stat", 0.0)
	daily_luck                = data.get("daily_luck", 0.0)
	size                      = data.get("size", 1)
	is_alpha                  = data.get("is_alpha", false)
	pack_alpha_name = data.get("pack_alpha_name", "") if data.get("pack_alpha_name") is String else ""
	pack_bond                 = data.get("pack_bond", 0.0)
	turns_solo                = data.get("turns_solo", 0)
	territory_bonus_turns       = data.get("territory_bonus_turns",      0)
	territory_claim             = data.get("territory_claim",            "")
	pending_territory_claim     = data.get("pending_territory_claim",    "")
	kills                     = data.get("kills", 0)
	fights_won                = data.get("fights_won", 0)
	fights_lost               = data.get("fights_lost", 0)
	fights_lost_bad           = int(data.get("fights_lost_bad", 0))
	fights_fled               = data.get("fights_fled", 0)
	kin_created               = data.get("kin_created", 0)
	miles_traveled            = data.get("miles_traveled", 0.0)
	night_hunts               = data.get("night_hunts", 0)
	bonuses_earned            = data.get("bonuses_earned", [])
	earned_perks = preload("res://scripts/systems/perks.gd").restore(data.get("earned_perks"))
	bonus_stat_grants = preload("res://scripts/systems/perks.gd").restore_grants(data.get("bonus_stat_grants"))
	mate_name = data.get("mate_name", "") if data.get("mate_name") is String else ""
	offspring_name = data.get("offspring_name", "") if data.get("offspring_name") is String else ""
	juvenile_name = data.get("juvenile_name", "") if data.get("juvenile_name") is String else ""
	offspring_history = []
	if data.get("offspring_history") is Array:
		for child in data["offspring_history"]:
			if child is Dictionary and child.get("name") is String and child.get("bond") is String:
				if child.has("skills"):
					child = child.duplicate(true)
					child.merge(preload("res://scripts/systems/family_legacy.gd").clean_child(child, child["name"]), true)
				offspring_history.append(child)
	life_events = []
	if data.get("life_events") is Array:
		for memory in data["life_events"]:
			if memory is Dictionary and memory.get("key") is String and memory.get("text") is String:
				life_events.append(memory)
	companions = []
	var group_id_value = data.get("companion_group_id", 0)
	companion_group_id = maxi(0, int(group_id_value)) if group_id_value is int or group_id_value is float else 0
	if data.get("companions") is Array:
		for member in data["companions"]:
			if member is Dictionary and member.get("name") is String and member.get("role") in ["steady", "challenger", "member"]:
				var trust_value = member.get("trust", 0.0)
				member["trust"] = clampf(float(trust_value), -1.0, 1.0) if trust_value is float or trust_value is int else 0.0
				member["active"] = member.get("active", false) == true
				member["reason"] = member.get("reason", "") if member.get("reason") is String else "Still learning whether to rely on you."
				for key in ["help_season", "bond_season", "group_id", "rest_until"]:
					var value = member.get(key, -1)
					member[key] = int(value) if value is float or value is int else -1
				preload("res://scripts/systems/companion_traits.gd").ensure(member)
				companions.append(member)
	companion_event = data.get("companion_event", {}) if data.get("companion_event") is Dictionary else {}
	if companion_event.get("kind") not in ["intro", "share", "protect", "lead", "shelter", "join"] or not companion_event.get("name") is String:
		companion_event = {}
	var event_count = data.get("companion_event_count", 0)
	companion_event_count = maxi(0, int(event_count)) if event_count is int or event_count is float else 0
	var last_event_season = data.get("companion_last_event_season", -1)
	companion_last_event_season = int(last_event_season) if last_event_season is int or last_event_season is float else -1
	world_state = preload("res://scripts/systems/world_conditions.gd").restore(data.get("world_state"))
	journey_state = preload("res://scripts/systems/journeys.gd").restore(data.get("journey_state"), species_id)
	discovery_state = preload("res://scripts/systems/discoveries.gd").restore(data.get("discovery_state"))
	living_state = preload("res://scripts/systems/living_world.gd").restore(data.get("living_state"))
	council_state = preload("res://scripts/systems/pack_council.gd").restore(data.get("council_state"))
	pack_relations = preload("res://scripts/systems/pack_relationships.gd").restore(data.get("pack_relations"))
	pack_story_state = preload("res://scripts/systems/pack_story_events.gd").restore(data.get("pack_story_state"))
	habitat_state = preload("res://scripts/systems/habitat_conditions.gd").restore(data.get("habitat_state"))
	action_uses               = data.get("action_uses", {})
	ad_bonus_training_used    = data.get("ad_bonus_training_used", false)
	permanent_health_mod      = data.get("permanent_health_mod", 0.0)
	permanent_defense_mod     = data.get("permanent_defense_mod", 0.0)
	permanent_strength_mod    = data.get("permanent_strength_mod", 0.0)
	permanent_speed_mod       = data.get("permanent_speed_mod", 0.0)
	hunger_history            = data.get("hunger_history", [])
	health_history            = data.get("health_history", [])
	type_stat_history         = data.get("type_stat_history", [])
	temp_buffs                = data.get("temp_buffs", [])
	injuries                  = data.get("injuries", [])
	turns_since_rest          = data.get("turns_since_rest", 0)
	sex                       = data.get("sex", "male")
	has_mate                  = data.get("has_mate", false)
	mate_was_alpha            = data.get("mate_was_alpha", true)
	alpha_breed_pending       = data.get("alpha_breed_pending", false)
	sub_mating_done           = data.get("sub_mating_done", false)
	species_mating_done       = data.get("species_mating_done", false)
	male_mating_streak        = data.get("male_mating_streak", 0)
	male_streak_boost_tier    = data.get("male_streak_boost_tier", 0)
	breed_effort_pending               = data.get("breed_effort_pending", false)
	next_season_graze_crit_bonus       = data.get("next_season_graze_crit_bonus", 0.0)
	next_season_graze_success_bonus    = data.get("next_season_graze_success_bonus", 0.0)
	pending_graze_crit_bonus           = data.get("pending_graze_crit_bonus", 0.0)
	pending_graze_success_bonus        = data.get("pending_graze_success_bonus", 0.0)
	pending_egg               = data.get("pending_egg", false)
	has_young                 = data.get("has_young", false)
	has_young_turns           = data.get("has_young_turns", 0)
	nesting_score             = data.get("nesting_score", 0.0)
	alpha_suspects            = data.get("alpha_suspects", false)
	alpha_court_bonus              = data.get("alpha_court_bonus", 0.0)
	alpha_display_done             = data.get("alpha_display_done", false)
	alpha_seasons_unchallenged     = data.get("alpha_seasons_unchallenged", 0)
	female_prep_done               = data.get("female_prep_done", false)
	good_parent_seasons            = data.get("good_parent_seasons", 0)
	good_parent_boosts             = data.get("good_parent_boosts", 0)
	solo_raise_boosts              = data.get("solo_raise_boosts", 0)
	juvenile_lesson_score          = data.get("juvenile_lesson_score", 0.0)
	juvenile_lesson_done           = data.get("juvenile_lesson_done", false)
	juvenile_outcome_pending       = data.get("juvenile_outcome_pending", false)
	active_juvenile_outcomes       = data.get("active_juvenile_outcomes", {})
	mother_bond                    = data.get("mother_bond", 0.0)
	has_juvenile             = data.get("has_juvenile",             false)
	juvenile_bond_turns      = data.get("juvenile_bond_turns",      0)
	offspring_bond           = data.get("offspring_bond",           0.0)
	offspring_bond_start     = data.get("offspring_bond_start",     0.0)
	maternal_outcome_pending = data.get("maternal_outcome_pending", false)
	maternal_bond_done       = data.get("maternal_bond_done",       false)
	active_maternal_outcomes = data.get("active_maternal_outcomes", {})
	death_cause               = data.get("death_cause", "")
	death_detail              = data.get("death_detail", "")
	elder_final_event_triggered = bool(data.get("elder_final_event_triggered", false))
	rival_name                = data.get("rival_name", "")
	rival_encounters          = int(data.get("rival_encounters", 0))
	lifespan_reduction        = data.get("lifespan_reduction", 0)
	total_injuries_sustained  = data.get("total_injuries_sustained", 0)
	family_state = preload("res://scripts/systems/family_legacy.gd").restore(data.get("family_state"))
	return true
