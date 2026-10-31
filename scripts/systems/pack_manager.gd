extends Node

const COMPANIONS = preload("res://scripts/systems/companions.gd")
const LEADERSHIP = preload("res://scripts/systems/pack_leadership.gd")

# Handles all pack/herd/colony logic.
# "Pack" is used internally — flavor text varies by tree type.

signal pack_disbanded(flavor: String)
signal alpha_status_changed(is_alpha: bool)

const FRACTURE_BOND_THRESHOLD := 0.20


func _ready() -> void:
	TurnManager.life_stage_changed.connect(_on_life_stage_changed)
	TurnManager.turn_started.connect(_on_turn_started)


# ── TURN HOOKS ────────────────────────────────────────────────────────────────

func _on_turn_started() -> void:
	if GameState.pack_bond == 0.0:
		GameState.turns_solo += 1
	_check_natural_attrition()


func _on_life_stage_changed(stage: int) -> void:
	if stage == GameState.get_min_mate_stage():
		_check_alpha_challenge_event()


# ── BOND MANAGEMENT ───────────────────────────────────────────────────────────

func modify_bond(amount: float) -> void:
	if GameState.pack_bond == 0.0:
		return
	GameState.pack_bond = clampf(GameState.pack_bond + amount, 0.0, 1.0)
	_sync_display()


# ── FRACTURE EVENT ────────────────────────────────────────────────────────────

# Called each season start when bond is critically low.
# Fires a player-facing event — disband is a choice, not automatic.
func _check_natural_attrition() -> void:
	if GameState.pack_bond == 0.0:
		return
	if GameState.pack_bond < FRACTURE_BOND_THRESHOLD:
		_fire_fracture_event()


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


func _fire_fracture_event() -> void:
	var species := SpeciesDB.get_species(GameState.species_id)
	var tree: String = species.get("tree", "predator") as String
	var data  := _load_pack_data()

	var fracture_pool: Array = data.get("fracture", []) as Array
	var flavor: String
	if fracture_pool.is_empty():
		if tree == "herbivore":
			flavor = "The herd is restless. Some have started drifting toward the edge. The bond that held you together is wearing thin."
		else:
			flavor = "The pack is restless. Some have stopped coming when you call. The bond that held you together is wearing thin."
	else:
		flavor = fracture_pool[randi() % fracture_pool.size()]

	var hold_label: String
	var release_label: String

	if tree == "herbivore":
		hold_label    = "Move with them and try to draw them back"
		release_label = "Let the herd fragment"
	else:
		hold_label    = "Push to hold the pack together"
		release_label = "Let the pack go"

	TurnManager.event_fired.emit({
		"type":   "pack_fracture",
		"flavor": flavor,
		"choices": [
			{ "label": hold_label,    "icon": "bond", "sublabel": "Costs hunger. May not work.", "action": "fracture_hold"    },
			{ "label": release_label, "icon": "flee", "sublabel": "Part ways now",               "action": "fracture_release" },
		],
		"resolve_key": "pack_fracture",
	})


func trigger_disband(flavor: String) -> void:
	COMPANIONS.leave_group("The group broke apart.")
	GameState.pack_bond  = 0.0
	GameState.is_alpha   = false
	GameState.turns_solo = 0
	_sync_display()
	emit_signal("pack_disbanded", flavor)


# ── ALPHA MECHANICS ───────────────────────────────────────────────────────────

func _check_alpha_challenge_event() -> void:
	var species := SpeciesDB.get_species(GameState.species_id)
	if not species.get("pack_species", false):
		return
	if GameState.pack_bond == 0.0:
		return
	if GameState.is_alpha:
		return
	var alpha := LEADERSHIP.leader()
	var alpha_name: String = alpha.get("name", "The current alpha")
	var mating_style: String = species.get("mating_style", "") as String
	if mating_style == "pack_coalition":
		TurnManager.event_fired.emit({
			"type":   "alpha_challenge_coalition",
			"flavor": "You have grown into your full strength. %s watches you from the front of the group. The others wait to see whether you will keep your place or challenge theirs." % alpha_name,
			"choices": [
				{ "label": "Challenge the alpha", "icon": "attack", "sublabel": "Fight for mating rights",     "action": "alpha_fight" },
				{ "label": "Stay as subordinate", "icon": "stalk",  "sublabel": "Hold your place in the pack", "action": "alpha_stay"  },
				{ "label": "Leave the pack",      "icon": "flee",   "sublabel": "Find your own path",          "action": "alpha_leave" },
			],
			"resolve_key": "alpha_challenge_coalition",
		})
	else:
		TurnManager.event_fired.emit({
			"type":   "alpha_challenge_mandatory",
			"flavor": "You have grown. %s, the group's alpha, watches you differently now. You can meet their challenge or find your own path." % alpha_name,
			"choices": [
				{ "label": "Challenge the alpha", "icon": "attack", "sublabel": "Fight for your place", "action": "alpha_fight" },
				{ "label": "Leave the pack",      "icon": "flee",   "sublabel": "Find your own path",   "action": "alpha_leave" },
			],
			"resolve_key": "alpha_challenge_mandatory",
		})


func resolve_alpha_fight() -> Dictionary:
	var species  := SpeciesDB.get_species(GameState.species_id)
	var mstyle   : String = species.get("mating_style", "") as String

	# ── 3-outcome roll: win / lose / lose+injury ──────────────────────────────
	# Base win chance: harder before Adult (stage 3), slightly above average after.
	var base_win  : float = 0.30 if GameState.life_stage < 3 else 0.55
	var alpha := LEADERSHIP.leader()
	var alpha_name: String = alpha.get("name", "the alpha")
	GameState.record_action_use("alpha_challenge")
	var supporters := COMPANIONS.take_support("when you challenged for leadership", alpha_name)
	var support_note := " %s backed your claim to leadership." % COMPANIONS.LIFE_STORY.names_text(supporters) if not supporters.is_empty() else ""
	var peer_support := preload("res://scripts/systems/pack_story_events.gd").alpha_modifier(supporters, alpha_name)
	if not is_zero_approx(peer_support): support_note += " Their bonds with %s changed your chance by %+.0f%%." % [alpha_name, peer_support * 100]
	var win_chance: float = clampf(base_win + GameState.luck_mod() + mini(supporters.size(), 2) * 0.04 + peer_support, 0.05, 0.90)
	var roll      : float = randf()

	if roll < win_chance:
		# ── WIN ──────────────────────────────────────────────────────────────
		GameState.is_alpha = true
		if not alpha.is_empty():
			COMPANIONS._change(alpha, -0.15, "You took their place as alpha. They are still adjusting to following you.")
		GameState.alpha_seasons_unchallenged = 0
		modify_bond(0.20)
		emit_signal("alpha_status_changed", true)
		return { "won": true, "injured": false, "support_note": support_note, "flavor": "%s gives way. The %s turns toward your signal. You are the alpha now, but each companion's trust still has to be earned." % [alpha_name, COMPANIONS.group_name()] + support_note }

	# ── LOSS — split remaining 50/50: plain loss vs loss with minor injury ────
	var injured: bool = roll >= win_chance + (1.0 - win_chance) * 0.5
	GameState.health = maxf(0.0, GameState.health - 0.12)
	if not alpha.is_empty():
		COMPANIONS._change(alpha, -0.12, "You challenged their leadership. They watch you more cautiously now.")
	if injured:
		GameState.apply_injury({
			"name":   "Fight Wound",
			"stat":   "health",
			"amount": -0.08,
			"turns":  3,
		})

	# Only pack_alpha species (compsognathus, velociraptor) disband on loss.
	if mstyle == "pack_alpha":
		trigger_disband("")

	var loss_flavor: String
	if injured:
		loss_flavor = "You lost the challenge and came away wounded. The pack is no longer yours to claim."
	else:
		loss_flavor = "You lost the challenge. The pack turned its back. You are on your own." if mstyle == "pack_alpha" else "%s holds their place as alpha. You stay with the %s, bruised and watched more closely." % [alpha_name, COMPANIONS.group_name()]
	return { "won": false, "injured": injured, "support_note": support_note, "flavor": loss_flavor + support_note }


func resolve_defender_fight() -> Dictionary:
	var species  := SpeciesDB.get_species(GameState.species_id)
	var mstyle   : String = species.get("mating_style", "") as String

	# ── Incumbent alpha is the defender — weighted to win ─────────────────────
	# Before Adult: even odds. Adult+: meaningfully favored.
	var base_win  : float = 0.50 if GameState.life_stage < 3 else 0.65
	var supporters := COMPANIONS.take_support("when your leadership was challenged")
	var support_note := " %s stayed beside you when the challenger arrived." % COMPANIONS.LIFE_STORY.names_text(supporters) if not supporters.is_empty() else ""
	var win_chance: float = clampf(base_win + GameState.luck_mod() + mini(supporters.size(), 2) * 0.04, 0.10, 0.90)
	var roll      : float = randf()

	if roll < win_chance:
		# ── WIN — held the position ───────────────────────────────────────────
		GameState.alpha_seasons_unchallenged = 0
		modify_bond(0.05)
		return { "won": true, "injured": false, "support_note": support_note, "flavor": "You drove the challenger off. The %s still follows your signal." % COMPANIONS.group_name() + support_note }

	# ── LOSS — split remaining 50/50: plain loss vs loss with minor injury ────
	var injured: bool = roll >= win_chance + (1.0 - win_chance) * 0.5
	GameState.health = maxf(0.0, GameState.health - 0.12)
	if injured:
		GameState.apply_injury({
			"name":   "Fight Wound",
			"stat":   "health",
			"amount": -0.08,
			"turns":  3,
		})

	LEADERSHIP.cede()
	if mstyle == "pack_alpha":
		trigger_disband("")

	var loss_flavor: String
	if injured:
		loss_flavor = "The challenger proved stronger and left you wounded. You are no longer alpha."
	else:
		loss_flavor = "The challenger took your place. The %s gathered around their new alpha." % COMPANIONS.group_name()
	return { "won": false, "injured": injured, "support_note": support_note, "flavor": loss_flavor + support_note }


func resolve_alpha_leave() -> Dictionary:
	trigger_disband("You left before it came to a fight. The territory is behind you now.")
	return { "flavor": "You walked away from the pack. Alone — but on your own terms." }


func resolve_alpha_stay() -> Dictionary:
	return { "flavor": "You held your position and lowered your head. Not submission — patience. Your time will come." }


# ── JOIN PACK ─────────────────────────────────────────────────────────────────

# Called by action_resolver when the player successfully joins a group.
func join_group(starting_bond: float) -> void:
	GameState.pack_bond  = starting_bond
	GameState.is_alpha   = false
	GameState.turns_solo = 0
	COMPANIONS.new_group()
	_sync_display()


# ── FLAVOR HELPERS ────────────────────────────────────────────────────────────

func _group_flavor(context: String) -> Array:
	var species := SpeciesDB.get_species(GameState.species_id)
	var tree: String = species.get("tree", "predator") as String
	match context:
		"found":
			if tree == "herbivore":
				return [
					"You found a herd. They moved aside to let you in.",
					"A herd passed and did not exclude you. You fell in.",
				]
			elif tree == "flyer":
				return [
					"A colony on the cliffs. They tolerated your landing.",
					"You found others roosting. They didn't drive you off.",
				]
			else:
				return [
					"You found others. Cautious at first — but they held their ground near you.",
					"A small group. They tested you, then accepted you.",
				]
	return [""]


# Bond measures how many real companions can coordinate effectively in combat.
func get_virtual_group_size() -> int:
	if GameState.pack_bond == 0.0 or not SpeciesDB.get_species(GameState.species_id).get("pack_species", false):
		return 0
	if COMPANIONS.supported():
		COMPANIONS.ensure_cast()
		return roundi(COMPANIONS.active_cast().size() * GameState.pack_bond)
	return roundi(GameState.pack_bond * 6.0)


func _sync_display() -> void:
	var species := SpeciesDB.get_species(GameState.species_id)
	if species.get("pack_species", false):
		GameState.type_stat = GameState.pack_bond
