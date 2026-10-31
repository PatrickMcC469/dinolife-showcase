extends Node

# Dice roll-off combat. Each side rolls randf() [0,1]. Stats add flat bonuses
# to the roll so high stats improve odds without guaranteeing anything.
# Advantage (roll twice, take higher) kicks in when one side's bonus is
# at least ADVANTAGE_RATIO times the other's.

enum Outcome { WIN, WIN_INJURED, LOSE, FLEE }

const ADVANTAGE_RATIO := 1.80   # bonus lead needed to earn advantage


# ── ATTACK STYLE FORMULAS ─────────────────────────────────────────────────────
# Each style blends stats differently to define how a dino fights.

func effective_attack(p: float, r: float, a: float, i: float, size: int, style: String) -> float:
	match style:
		"bite":   return p
		"speed":  return (a * 0.55) + (p * 0.45)
		"pack":   return (p * 0.55) + (i * 0.45)
		"bulk":   return (r * 0.65) + (p * 0.35)
		"charge": return (p * 0.55) + clampf(size * 0.04, 0.0, 0.32)
	return p


# ── PLAYER STAT LOADING ───────────────────────────────────────────────────────
# Loads from dino_stats.gd, applies hatchling mods, life stage, and hunger.

func load_player_stats() -> Dictionary:
	var path := "res://scripts/dinos/%s/dino_stats.gd" % GameState.species_id
	var bp := { "min": 0.25, "max": 0.45 }
	var br := { "min": 0.25, "max": 0.45 }
	var ba := { "min": 0.25, "max": 0.45 }
	var bi := { "min": 0.25, "max": 0.45 }
	var style := "bite"
	var size  := GameState.size

	if ResourceLoader.exists(path):
		var script = load(path)
		var obj := RefCounted.new()
		obj.set_script(script)
		var bs: Dictionary = obj.BASE_STATS
		bp    = bs.get("power",      bp)
		br    = bs.get("resilience", br)
		ba    = bs.get("agility",    ba)
		bi    = bs.get("instinct",   bi)
		style = obj.ATTACK_STYLE
		size  = obj.SIZE

	# Roll from species range + hatchling permanent mods
	var power      := randf_range(bp.min, bp.max) + GameState.permanent_strength_mod
	var resilience := randf_range(br.min, br.max) + GameState.permanent_defense_mod
	var agility    := randf_range(ba.min, ba.max) + GameState.permanent_speed_mod
	var instinct   := randf_range(bi.min, bi.max) + GameState.permanent_health_mod

	# Life stage bonus — higher stage = slightly stronger
	var stage_mod := GameState.life_stage * 0.025
	power      = minf(power      + stage_mod, 1.0)
	resilience = minf(resilience + stage_mod, 1.0)

	# Hunger modifier — fighting hungry costs you
	var hunger_mod := (GameState.hunger - 0.5) * 0.10
	power      = clampf(power      + hunger_mod, 0.02, 1.0)
	resilience = clampf(resilience + hunger_mod, 0.02, 1.0)

	# Active injury penalties — mapped to combat stats:
	# "strength" → Power,  "speed" → Agility,
	# "defense"  → Resilience,  "type_stat" → Instinct
	for inj in GameState.injuries:
		var amt: float = inj.get("amount", 0.0) as float
		match inj.get("stat", "") as String:
			"strength":  power      = maxf(power      + amt, 0.02)
			"speed":     agility    = maxf(agility    + amt, 0.02)
			"defense":   resilience = maxf(resilience + amt, 0.02)
			"type_stat": instinct   = maxf(instinct   + amt, 0.02)

	var eff := effective_attack(power, resilience, agility, instinct, size, style)
	return {
		"power":      power,
		"resilience": resilience,
		"agility":    agility,
		"instinct":   instinct,
		"size":       size,
		"style":      style,
		"fight_power": eff,
	}


# ── ENEMY STAT LOADING ────────────────────────────────────────────────────────
# Loads from shared enemy script if available; falls back to fight_power.

func load_enemy_stats(prey: Dictionary) -> Dictionary:
	var script_path: String = prey.get("script", "")
	var fp:    float = prey.get("fight_power", 0.30)
	var size:  int   = prey.get("size", 1)
	var style: String = "bite"
	var power:      float
	var resilience: float
	var agility:    float
	var instinct:   float

	if script_path != "" and ResourceLoader.exists(script_path):
		var script = load(script_path)
		var obj := RefCounted.new()
		obj.set_script(script)
		var bs: Dictionary = obj.BASE_STATS
		power      = randf_range(bs.get("power",      {}).get("min", fp * 0.80), bs.get("power",      {}).get("max", fp * 1.20))
		resilience = randf_range(bs.get("resilience", {}).get("min", fp * 0.75), bs.get("resilience", {}).get("max", fp * 1.10))
		agility    = randf_range(bs.get("agility",    {}).get("min", fp * 0.65), bs.get("agility",    {}).get("max", fp * 1.00))
		instinct   = randf_range(bs.get("instinct",   {}).get("min", fp * 0.65), bs.get("instinct",   {}).get("max", fp * 1.00))
		style      = obj.ATTACK_STYLE
		size       = obj.SIZE
	else:
		# Fallback: derive all stats from fight_power
		power      = randf_range(fp * 0.80, fp * 1.20)
		resilience = randf_range(fp * 0.75, fp * 1.10)
		agility    = randf_range(fp * 0.65, fp * 1.00)
		instinct   = randf_range(fp * 0.65, fp * 1.00)

	var eff := effective_attack(power, resilience, agility, instinct, size, style)
	return {
		"power":         power,
		"resilience":    resilience,
		"agility":       agility,
		"instinct":      instinct,
		"size":          size,
		"style":         style,
		"fight_power":   eff,
		"opponent_size": GameState.size,
		"name":          prey.get("name", "the creature"),
		"hunger_value":  prey.get("hunger_value", 0.35),
	}


# ── CONTEXT CLUE (v2 — 4-stat comparison) ────────────────────────────────────
# Used when full stat dicts are available (hunt encounters with new system).

func get_context_clue_v2(player: Dictionary, enemy: Dictionary) -> String:
	var lines: Array = []

	# Size
	var size_diff: int = (player.get("size", 1) as int) - (enemy.get("size", 1) as int)
	if size_diff >= 2:
		lines.append("It is much smaller than you.")
	elif size_diff == 1:
		lines.append("You have a size advantage.")
	elif size_diff == -1:
		lines.append("It is larger than you.")
	elif size_diff <= -2:
		lines.append("It towers over you.")
	else:
		lines.append("You are well matched in size.")

	# Attack comparison
	var atk_diff: float = (player.get("fight_power", 0.30) as float) - (enemy.get("fight_power", 0.30) as float)
	if atk_diff > 0.15:
		lines.append("Their attack looks weaker than yours.")
	elif atk_diff < -0.15:
		lines.append("Their attack looks stronger than yours.")
	else:
		lines.append("Their attack looks matched to yours.")

	# Defense comparison
	var def_diff: float = (player.get("resilience", 0.30) as float) - (enemy.get("resilience", 0.30) as float)
	if def_diff > 0.15:
		lines.append("Their defense seems weaker.")
	elif def_diff < -0.15:
		lines.append("Their defense seems stronger.")
	else:
		lines.append("Their defense seems similar to yours.")

	# Speed comparison
	var spd_diff: float = (player.get("agility", 0.30) as float) - (enemy.get("agility", 0.30) as float)
	if spd_diff > 0.15:
		lines.append("You are faster.")
	elif spd_diff < -0.15:
		lines.append("They are faster.")
	else:
		lines.append("You are similar in speed.")

	# Pack
	var group := PackManager.get_virtual_group_size()
	if group >= 7:
		lines.append("Your herd closes around you." if SpeciesDB.get_species(GameState.species_id).get("tree") == "herbivore" else "Your pack moves in from every angle.")
	elif group >= 4:
		lines.append("Your herd gathers beside you." if SpeciesDB.get_species(GameState.species_id).get("tree") == "herbivore" else "Your pack circles in from the brush.")
	elif group >= 2:
		lines.append("You are not alone in this.")

	# Injury warnings
	if GameState.has_injury_on("speed"):
		lines.append("Your leg is not right. Running will cost you.")
	if GameState.has_injury_on("strength"):
		lines.append("Your striking arm is still damaged.")

	return " ".join(condition_clues() + lines)


# ── CORE RESOLVE ──────────────────────────────────────────────────────────────

func resolve(attacker: Dictionary, defender: Dictionary) -> Dictionary:
	var atk_b  = _calc_bonus(attacker)
	var def_b  = _calc_bonus(defender)
	var ratio  = atk_b / maxf(def_b, 0.01)

	var atk_roll = _roll(ratio >= ADVANTAGE_RATIO) + atk_b + GameState.luck_mod() * 0.5
	var def_roll = _roll(ratio <= 1.0 / ADVANTAGE_RATIO) + def_b
	var diff     = atk_roll - def_roll

	var outcome: Outcome
	var damage      := 0.0
	var hunger_gain := 0.0
	var injury: Dictionary = {}

	# Trivial prey can't injure — minor misses at worst
	var trivial = defender.get("fight_power", 0.3) < 0.05

	if diff >= 0.30:
		outcome = Outcome.WIN
		hunger_gain = defender.get("hunger_value", 0.3)
		if randf() < 0.25 and not trivial:
			outcome = Outcome.WIN_INJURED
			injury = roll_injury("minor")
	elif diff >= 0.0:
		outcome = Outcome.WIN_INJURED
		hunger_gain = defender.get("hunger_value", 0.3) * 0.70
		if not trivial:
			damage = randf_range(0.05, 0.12)
			injury = roll_injury("moderate")
	elif diff >= -0.30:
		outcome = Outcome.LOSE
		if trivial:
			damage = randf_range(0.05, 0.12)
		else:
			damage = randf_range(0.18, 0.32)
			if randf() < 0.55:
				injury = roll_injury("moderate")
	else:
		outcome = Outcome.LOSE
		if trivial:
			damage = randf_range(0.08, 0.15)
		else:
			damage = randf_range(0.30, 0.55)
			if randf() < 0.70:
				injury = roll_injury("severe")

	return {
		"outcome":      outcome,
		"damage":       damage,
		"hunger_gain":  hunger_gain,
		"injury":       injury,
		"ratio":        ratio,
		"is_bad_loss":  diff < -0.30,
	}


func _roll(has_advantage: bool) -> float:
	var r = randf()
	return maxf(r, randf()) if has_advantage else r


func resolve_flee(attacker: Dictionary) -> Dictionary:
	var threat_speed  = attacker.get("speed", 0.5)
	var escape_chance = clampf(0.40 + (GameState.speed - threat_speed), 0.15, 0.90)
	if randf() < escape_chance:
		return { "escaped": true, "damage": 0.0 }
	return { "escaped": false, "damage": randf_range(0.12, 0.22) }


# ── BONUS CALCULATION ─────────────────────────────────────────────────────────
# When the new 4-stat dict is provided, uses effective_attack().
# Falls back to fight_power for all existing callsites — fully backward compatible.

func _calc_bonus(combatant: Dictionary) -> float:
	var fp: float
	if combatant.has("power") and combatant.has("style"):
		fp = effective_attack(
			combatant.get("power",      0.30),
			combatant.get("resilience", 0.30),
			combatant.get("agility",    0.30),
			combatant.get("instinct",   0.30),
			combatant.get("size",       1),
			combatant.get("style",      "bite")
		)
	else:
		fp = combatant.get("fight_power", 0.30)

	var sz:     int = combatant.get("size",          1) as int
	var opp_sz: int = combatant.get("opponent_size", 1) as int
	var grp:    int = combatant.get("group_size",    0) as int
	var sz_mod := clampf((sz - opp_sz) * 0.06, -0.18, 0.18)
	var pack   := 0.0
	if   grp >= 7: pack = 0.30
	elif grp >= 4: pack = 0.22
	elif grp >= 2: pack = 0.12
	return fp * 0.50 + sz_mod + pack + float(combatant.get("companion_bonus", 0.0))


# ── CONTEXT CLUE (v1 — legacy, fight_power based) ────────────────────────────

func get_context_clue(attacker: Dictionary, defender: Dictionary) -> String:
	var atk_b     = _calc_bonus(attacker)
	var def_b     = _calc_bonus(defender)
	var ratio     = atk_b / maxf(def_b, 0.01)
	var size_diff = attacker.get("size", 1) - defender.get("size", 1)
	var group     = attacker.get("group_size", 0)
	var lines: Array = []

	if size_diff >= 2:
		lines.append("It is much smaller than you.")
	elif size_diff == 1:
		lines.append("You have a size advantage.")
	elif size_diff == -1:
		lines.append("It is larger than you.")
	elif size_diff <= -2:
		lines.append("It towers over you.")
	else:
		lines.append("You are well matched in size.")

	if group >= 7:
		lines.append("Your herd closes around you." if SpeciesDB.get_species(GameState.species_id).get("tree") == "herbivore" else "Your pack moves in from every angle.")
	elif group >= 4:
		lines.append("Your herd gathers beside you." if SpeciesDB.get_species(GameState.species_id).get("tree") == "herbivore" else "Your pack circles in from the brush.")
	elif group >= 2:
		lines.append("You are not alone in this.")

	if GameState.has_injury_on("speed"):
		lines.append("Your leg is not right. Fleeing will cost you.")
	if GameState.has_injury_on("strength"):
		lines.append("Your striking arm is still damaged.")

	if ratio >= ADVANTAGE_RATIO:
		lines.append("The odds are strongly in your favor.")
	elif ratio >= 1.30:
		lines.append("The odds are in your favor.")
	elif ratio <= 1.0 / ADVANTAGE_RATIO:
		lines.append("This looks dangerous.")
	elif ratio <= 0.75:
		lines.append("This will be difficult.")

	return " ".join(condition_clues() + lines)


func condition_clues() -> Array[String]:
	var lines: Array[String] = []
	if GameState.health < 0.35:
		lines.append("You are badly weakened. Another heavy hit could end this life.")
	if GameState.hunger < 0.30:
		lines.append("Your food reserves are low. A costly fight could leave nothing for the next season.")
	if GameState.has_injury_on("defense"):
		lines.append("Your injured hide leaves you exposed when you trade blows.")
	return lines


# ── INJURY POOLS (per species, per severity) ─────────────────────────────────
# "stat" maps to GameState properties: strength, speed, defense, type_stat, health
# "amount" is always negative. "turns" = -1 means permanent (never heals).
# Stat → combat mapping:  strength → Power,  speed → Agility,
#                         defense  → Resilience,  type_stat → Instinct

const INJURY_POOLS := {
	"compsognathus": {
		"minor": [
			{ "name": "Sore Jaw",       "flavor": "Your jaw aches after the fight, making each bite feel weaker than it should.",             "stat": "strength", "amount": -0.07, "turns": 3 },
			{ "name": "Scratched Flank","flavor": "Claw marks rake your side, leaving your small body more vulnerable.",                      "stat": "defense",  "amount": -0.07, "turns": 3 },
			{ "name": "Bent Toe",       "flavor": "One tiny toe bends wrong, throwing off your quick little steps.",                          "stat": "speed",    "amount": -0.07, "turns": 3 },
			{ "name": "Shaken Senses",  "flavor": "The fight rattled you, making it harder to read danger quickly.",                          "stat": "type_stat","amount": -0.07, "turns": 3 },
		],
		"moderate": [
			{ "name": "Split Bite",     "flavor": "A cut along your mouth makes it harder to snap down with full force.",                     "stat": "strength", "amount": -0.14, "turns": 7 },
			{ "name": "Torn Hide",      "flavor": "A deeper tear exposes tender flesh beneath your thin hide.",                               "stat": "defense",  "amount": -0.14, "turns": 7 },
			{ "name": "Twisted Leg",    "flavor": "Your leg twists painfully, slowing every sprint and dodge.",                               "stat": "speed",    "amount": -0.14, "turns": 7 },
			{ "name": "Missed Shadows", "flavor": "You keep reacting late to movement you should have noticed sooner.",                       "stat": "type_stat","amount": -0.14, "turns": 7 },
		],
		"severe": [
			{ "name": "Cracked Jaw",      "flavor": "Your jaw is badly damaged, and every attack feels painful and unsteady.",               "stat": "strength", "amount": -0.18, "turns": -1 },
			{ "name": "Exposed Ribs",     "flavor": "Your side is badly opened, making every hit feel dangerous.",                           "stat": "defense",  "amount": -0.24, "turns": 15 },
			{ "name": "Crippled Sprint",  "flavor": "You can still move, but your fastest escape is badly broken.",                          "stat": "speed",    "amount": -0.24, "turns": 15 },
			{ "name": "Panic Instinct",   "flavor": "Fear keeps breaking your focus before your hunting instincts can settle.",              "stat": "type_stat","amount": -0.24, "turns": 15 },
		],
	},
	"deinonychus": {
		"minor": [
			{ "name": "Sore Sickle Claw",  "flavor": "Your killing claw aches, weakening the force behind each strike.",                    "stat": "strength", "amount": -0.07, "turns": 3 },
			{ "name": "Ruffled Guard",      "flavor": "Your feathers and skin are torn enough to leave weak spots exposed.",                 "stat": "defense",  "amount": -0.07, "turns": 3 },
			{ "name": "Stiff Hock",         "flavor": "Your leg joint stiffens, making your leaps and dodges slower.",                      "stat": "speed",    "amount": -0.07, "turns": 3 },
			{ "name": "Broken Focus",       "flavor": "The fight shook your concentration, dulling your hunting rhythm.",                    "stat": "type_stat","amount": -0.07, "turns": 3 },
		],
		"moderate": [
			{ "name": "Torn Claw Tendon",   "flavor": "A painful tear makes your claw strikes harder to land with power.",                  "stat": "strength", "amount": -0.14, "turns": 7 },
			{ "name": "Slashed Chest",      "flavor": "A deep slash across your chest makes every hit harder to endure.",                   "stat": "defense",  "amount": -0.14, "turns": 7 },
			{ "name": "Sprained Leap",      "flavor": "Your jumping leg buckles painfully whenever you try to spring forward.",             "stat": "speed",    "amount": -0.14, "turns": 7 },
			{ "name": "Lost Pack Rhythm",   "flavor": "You struggle to read movement and timing the way a hunter should.",                  "stat": "type_stat","amount": -0.14, "turns": 7 },
		],
		"severe": [
			{ "name": "Broken Killing Claw","flavor": "Your sickle claw is badly damaged, stealing strength from your attacks.",            "stat": "strength", "amount": -0.18, "turns": -1 },
			{ "name": "Open Rib Wound",     "flavor": "Your side is badly opened, and your body can barely shield itself.",                 "stat": "defense",  "amount": -0.24, "turns": 15 },
			{ "name": "Ruined Pounce",      "flavor": "Your pounce is badly compromised, leaving you slower and easier to catch.",          "stat": "speed",    "amount": -0.24, "turns": 15 },
			{ "name": "Hunt Panic",         "flavor": "Your instincts scatter under pressure, making clean ambushes nearly impossible.",    "stat": "type_stat","amount": -0.24, "turns": 15 },
		],
	},
	"velociraptor": {
		"minor": [
			{ "name": "Bruised Snout",       "flavor": "Your snout throbs, weakening your bite when you strike.",                           "stat": "strength", "amount": -0.07, "turns": 3 },
			{ "name": "Torn Feathers",       "flavor": "Torn feathers leave your body less protected than before.",                         "stat": "defense",  "amount": -0.07, "turns": 3 },
			{ "name": "Sand-Burned Feet",    "flavor": "Your feet are scraped raw, slowing your careful steps.",                            "stat": "speed",    "amount": -0.07, "turns": 3 },
			{ "name": "Dust-Blind Focus",    "flavor": "Dust and pain cloud your focus, making prey harder to read.",                       "stat": "type_stat","amount": -0.07, "turns": 3 },
		],
		"moderate": [
			{ "name": "Damaged Bite",        "flavor": "Pain runs through your jaw whenever you clamp down.",                               "stat": "strength", "amount": -0.14, "turns": 7 },
			{ "name": "Exposed Side",        "flavor": "A wound along your side makes every hit cut deeper.",                               "stat": "defense",  "amount": -0.14, "turns": 7 },
			{ "name": "Twisted Ankle",       "flavor": "Your ankle turns painfully, hurting your sprint and dodge.",                        "stat": "speed",    "amount": -0.14, "turns": 7 },
			{ "name": "Misread Movement",    "flavor": "You keep choosing the wrong angle when prey starts to move.",                       "stat": "type_stat","amount": -0.14, "turns": 7 },
		],
		"severe": [
			{ "name": "Split Jawline",        "flavor": "Your jaw is badly hurt, making every attack unstable and weak.",                   "stat": "strength", "amount": -0.18, "turns": -1 },
			{ "name": "Deep Body Gash",       "flavor": "A serious gash leaves you vulnerable and struggling to absorb damage.",            "stat": "defense",  "amount": -0.24, "turns": 15 },
			{ "name": "Failed Sprint",        "flavor": "Your legs no longer answer quickly when danger demands speed.",                    "stat": "speed",    "amount": -0.24, "turns": 15 },
			{ "name": "Broken Ambush Sense",  "flavor": "Your timing is badly shaken, and perfect openings slip past you.",               "stat": "type_stat","amount": -0.24, "turns": 15 },
		],
	},
	"allosaurus": {
		"minor": [
			{ "name": "Sore Neck Muscles",  "flavor": "Your neck strains with each bite, weakening your attack.",                          "stat": "strength", "amount": -0.07, "turns": 3 },
			{ "name": "Scraped Hide",        "flavor": "Your hide is scraped raw, leaving you easier to hurt.",                             "stat": "defense",  "amount": -0.07, "turns": 3 },
			{ "name": "Heavy Limp",          "flavor": "A limp slows your chase and makes dodging harder.",                                 "stat": "speed",    "amount": -0.07, "turns": 3 },
			{ "name": "Clouded Hunt Sense",  "flavor": "Pain clouds your predator focus, making hunts less certain.",                      "stat": "type_stat","amount": -0.07, "turns": 3 },
		],
		"moderate": [
			{ "name": "Jaw Strain",          "flavor": "Your jaws ache badly, making heavy bites harder to force.",                        "stat": "strength", "amount": -0.14, "turns": 7 },
			{ "name": "Deep Flank Wound",    "flavor": "A deep wound along your side makes each hit more punishing.",                      "stat": "defense",  "amount": -0.14, "turns": 7 },
			{ "name": "Pulled Thigh",        "flavor": "Your thigh burns with pain whenever you try to sprint.",                           "stat": "speed",    "amount": -0.14, "turns": 7 },
			{ "name": "Bad Angle Read",      "flavor": "You misjudge openings and approach prey from weaker angles.",                      "stat": "type_stat","amount": -0.14, "turns": 7 },
		],
		"severe": [
			{ "name": "Torn Jaw Ligament",     "flavor": "A serious jaw injury steals power from every attack you make.",                  "stat": "strength", "amount": -0.18, "turns": -1 },
			{ "name": "Bleeding Side Tear",    "flavor": "Your side is badly torn, and your body struggles to take damage.",               "stat": "defense",  "amount": -0.24, "turns": 15 },
			{ "name": "Buckled Leg",           "flavor": "Your leg nearly gives out under you, ruining your speed.",                       "stat": "speed",    "amount": -0.24, "turns": 15 },
			{ "name": "Lost Predator Timing",  "flavor": "Your hunting rhythm breaks, causing you to miss chances you should own.",        "stat": "type_stat","amount": -0.24, "turns": 15 },
		],
	},
	"trex": {
		"minor": [
			{ "name": "Aching Bite",         "flavor": "Your jaws ache, dulling the power behind each bite.",                              "stat": "strength", "amount": -0.07, "turns": 3 },
			{ "name": "Bruised Hide",        "flavor": "Heavy bruising makes each new hit hurt more than it should.",                      "stat": "defense",  "amount": -0.07, "turns": 3 },
			{ "name": "Heavy Foot Pain",     "flavor": "One foot aches under your weight, slowing your movement.",                         "stat": "speed",    "amount": -0.07, "turns": 3 },
			{ "name": "Scent Confusion",     "flavor": "Pain and blood muddle your sense of smell during hunts.",                          "stat": "type_stat","amount": -0.07, "turns": 3 },
		],
		"moderate": [
			{ "name": "Cracked Tooth",       "flavor": "A cracked tooth sends pain through every attack.",                                 "stat": "strength", "amount": -0.14, "turns": 7 },
			{ "name": "Torn Shoulder",       "flavor": "A torn shoulder leaves your body harder to protect in combat.",                    "stat": "defense",  "amount": -0.14, "turns": 7 },
			{ "name": "Damaged Knee",        "flavor": "Your knee strains with each step, hurting your chase and dodge.",                  "stat": "speed",    "amount": -0.14, "turns": 7 },
			{ "name": "Missed Opening",      "flavor": "You hesitate at moments where a clean bite should happen.",                        "stat": "type_stat","amount": -0.14, "turns": 7 },
		],
		"severe": [
			{ "name": "Broken Bite Power",   "flavor": "Your bite is badly compromised, weakening your greatest weapon.",                  "stat": "strength", "amount": -0.18, "turns": -1 },
			{ "name": "Deep Rib Wound",      "flavor": "A deep wound near your ribs makes every blow dangerous.",                          "stat": "defense",  "amount": -0.24, "turns": 15 },
			{ "name": "Failing Leg",         "flavor": "Your leg threatens to collapse whenever you push for speed.",                      "stat": "speed",    "amount": -0.24, "turns": 15 },
			{ "name": "Broken Hunt Nerve",   "flavor": "Your predator instincts falter, making every hunt feel uncertain.",               "stat": "type_stat","amount": -0.24, "turns": 15 },
		],
	},
	"lesothosaurus": {
		"minor": [
			{ "name": "Weak Tug",            "flavor": "Your jaw and neck feel weak when pulling at food or fighting back.",               "stat": "strength", "amount": -0.07, "turns": 3 },
			{ "name": "Scraped Belly",       "flavor": "Your belly is scraped raw, leaving you more vulnerable.",                          "stat": "defense",  "amount": -0.07, "turns": 3 },
			{ "name": "Stiff Toes",          "flavor": "Your toes stiffen, making quick turns harder.",                                    "stat": "speed",    "amount": -0.07, "turns": 3 },
			{ "name": "Nervous Glance",      "flavor": "You keep looking the wrong way at the wrong time.",                                "stat": "type_stat","amount": -0.07, "turns": 3 },
		],
		"moderate": [
			{ "name": "Sore Neck",           "flavor": "Pain stiffens your neck, making forceful movement harder.",                        "stat": "strength", "amount": -0.14, "turns": 7 },
			{ "name": "Torn Side",           "flavor": "A tear along your side makes every hit feel sharper.",                             "stat": "defense",  "amount": -0.14, "turns": 7 },
			{ "name": "Sprained Runner's Leg","flavor": "Your best running leg hurts with every step.",                                   "stat": "speed",    "amount": -0.14, "turns": 7 },
			{ "name": "False Alarm Panic",   "flavor": "Your fear spikes too easily, ruining your timing.",                                "stat": "type_stat","amount": -0.14, "turns": 7 },
		],
		"severe": [
			{ "name": "Torn Jaw Muscle",      "flavor": "Your jaw is badly strained, making every bite weak and painful.",                "stat": "strength", "amount": -0.24, "turns": 15 },
			{ "name": "Open Flank Wound",     "flavor": "Your flank is badly opened, and you can barely absorb damage.",                  "stat": "defense",  "amount": -0.24, "turns": 15 },
			{ "name": "Broken Escape Stride", "flavor": "Your escape stride is badly damaged, and speed no longer feels safe.",           "stat": "speed",    "amount": -0.18, "turns": -1 },
			{ "name": "Frozen Fear",          "flavor": "Terror locks your instincts in place when you need to react.",                   "stat": "type_stat","amount": -0.24, "turns": 15 },
		],
	},
	"iguanodon": {
		"minor": [
			{ "name": "Sore Thumb Spike",    "flavor": "Your thumb spike aches, weakening your defensive strikes.",                        "stat": "strength", "amount": -0.07, "turns": 3 },
			{ "name": "Bruised Shoulder",    "flavor": "Your shoulder bruises deeply, making hits harder to absorb.",                      "stat": "defense",  "amount": -0.07, "turns": 3 },
			{ "name": "Mud-Stiff Leg",       "flavor": "Your leg feels stiff and heavy, slowing your movement.",                           "stat": "speed",    "amount": -0.07, "turns": 3 },
			{ "name": "Missed Herd Signal",  "flavor": "You miss a warning cue you normally would have noticed.",                          "stat": "type_stat","amount": -0.07, "turns": 3 },
		],
		"moderate": [
			{ "name": "Strained Forelimb",   "flavor": "A strained forelimb makes pushing and striking harder.",                          "stat": "strength", "amount": -0.14, "turns": 7 },
			{ "name": "Torn Chest Hide",     "flavor": "A tear across your chest leaves your guard weaker.",                               "stat": "defense",  "amount": -0.14, "turns": 7 },
			{ "name": "Limping Stride",      "flavor": "A painful limp makes running and dodging harder.",                                 "stat": "speed",    "amount": -0.14, "turns": 7 },
			{ "name": "Poor Danger Read",    "flavor": "You misread danger, reacting too late to the threat.",                             "stat": "type_stat","amount": -0.14, "turns": 7 },
		],
		"severe": [
			{ "name": "Damaged Thumb Spike", "flavor": "Your thumb spike is badly injured, stealing power from your attacks.",             "stat": "strength", "amount": -0.18, "turns": -1 },
			{ "name": "Open Guard Wound",    "flavor": "A serious wound breaks through your strongest defensive posture.",                 "stat": "defense",  "amount": -0.24, "turns": 15 },
			{ "name": "Crushed Foot",        "flavor": "Your foot is badly hurt, making escape painfully slow.",                           "stat": "speed",    "amount": -0.24, "turns": 15 },
			{ "name": "Broken Herd Sense",   "flavor": "Your survival instincts feel scattered without clear herd rhythm.",               "stat": "type_stat","amount": -0.24, "turns": 15 },
		],
	},
	"triceratops": {
		"minor": [
			{ "name": "Bruised Horn Base",   "flavor": "The base of your horn throbs, weakening your charges.",                            "stat": "strength", "amount": -0.07, "turns": 3 },
			{ "name": "Frill Scrape",        "flavor": "Your frill is scraped, leaving your guard less reliable.",                         "stat": "defense",  "amount": -0.07, "turns": 3 },
			{ "name": "Stiff Foreleg",       "flavor": "Your foreleg stiffens, slowing your charge and dodge.",                            "stat": "speed",    "amount": -0.07, "turns": 3 },
			{ "name": "Startled Nerve",      "flavor": "The fight shook your courage, making you react late.",                             "stat": "type_stat","amount": -0.07, "turns": 3 },
		],
		"moderate": [
			{ "name": "Chipped Horn",        "flavor": "A chipped horn makes each strike feel unstable.",                                  "stat": "strength", "amount": -0.14, "turns": 7 },
			{ "name": "Torn Frill Edge",     "flavor": "A torn frill weakens the shield protecting your head and neck.",                   "stat": "defense",  "amount": -0.14, "turns": 7 },
			{ "name": "Wrenched Knee",       "flavor": "Your knee twists painfully whenever you try to move fast.",                        "stat": "speed",    "amount": -0.14, "turns": 7 },
			{ "name": "Missed Warning Snort","flavor": "You fail to read danger signals quickly enough.",                                  "stat": "type_stat","amount": -0.14, "turns": 7 },
		],
		"severe": [
			{ "name": "Cracked Horn",        "flavor": "Your horn is badly cracked, stealing force from your attacks.",                    "stat": "strength", "amount": -0.18, "turns": -1 },
			{ "name": "Split Frill Wound",   "flavor": "Your frill is badly split, making every hit more dangerous.",                      "stat": "defense",  "amount": -0.24, "turns": 15 },
			{ "name": "Broken Charge Step",  "flavor": "Your charge breaks down, leaving you slow and vulnerable.",                        "stat": "speed",    "amount": -0.24, "turns": 15 },
			{ "name": "Panic Break",         "flavor": "Your instincts break under pressure, costing you control of the fight.",           "stat": "type_stat","amount": -0.24, "turns": 15 },
		],
	},
	"ankylosaurus": {
		"minor": [
			{ "name": "Sore Tail Base",      "flavor": "Your tail base aches, weakening the force behind your swing.",                     "stat": "strength", "amount": -0.07, "turns": 3 },
			{ "name": "Scratched Plates",    "flavor": "Your armor plates are scraped, leaving small weak points.",                        "stat": "defense",  "amount": -0.07, "turns": 3 },
			{ "name": "Heavy Shuffle",       "flavor": "Your steps grow heavier, slowing your movement.",                                  "stat": "speed",    "amount": -0.07, "turns": 3 },
			{ "name": "Slow Threat Read",    "flavor": "You notice danger a moment later than you should.",                                "stat": "type_stat","amount": -0.07, "turns": 3 },
		],
		"moderate": [
			{ "name": "Strained Tail Club",  "flavor": "Your tail club feels heavy and painful to move.",                                  "stat": "strength", "amount": -0.14, "turns": 7 },
			{ "name": "Cracked Armor Plate", "flavor": "A cracked plate exposes the softer body beneath.",                                 "stat": "defense",  "amount": -0.14, "turns": 7 },
			{ "name": "Twisted Low Leg",     "flavor": "A low leg injury makes every shuffle painful.",                                    "stat": "speed",    "amount": -0.14, "turns": 7 },
			{ "name": "Bad Defensive Angle", "flavor": "You keep turning the wrong side toward danger.",                                   "stat": "type_stat","amount": -0.14, "turns": 7 },
		],
		"severe": [
			{ "name": "Damaged Tail Club",   "flavor": "Your strongest weapon is badly hurt, weakening your attacks.",                     "stat": "strength", "amount": -0.18, "turns": -1 },
			{ "name": "Split Armor Seam",    "flavor": "A deep split between plates leaves you badly vulnerable.",                         "stat": "defense",  "amount": -0.24, "turns": 15 },
			{ "name": "Dragging Hind Leg",   "flavor": "One hind leg drags badly, making escape nearly impossible.",                       "stat": "speed",    "amount": -0.24, "turns": 15 },
			{ "name": "Broken Brace Instinct","flavor": "Your defensive instincts fail when you need to hold firm.",                      "stat": "type_stat","amount": -0.24, "turns": 15 },
		],
	},
	"argentinosaurus": {
		"minor": [
			{ "name": "Neck Strain",         "flavor": "Your long neck strains painfully when you push or pull.",                          "stat": "strength", "amount": -0.07, "turns": 3 },
			{ "name": "Scraped Hide",        "flavor": "Your thick hide is scraped, making hits harder to shrug off.",                     "stat": "defense",  "amount": -0.07, "turns": 3 },
			{ "name": "Sore Footpad",        "flavor": "Your footpad aches beneath your weight, slowing each step.",                       "stat": "speed",    "amount": -0.07, "turns": 3 },
			{ "name": "Herd Drift",          "flavor": "You drift from the herd's rhythm and miss subtle warnings.",                       "stat": "type_stat","amount": -0.07, "turns": 3 },
		],
		"moderate": [
			{ "name": "Heavy Shoulder Pull", "flavor": "A deep shoulder strain weakens your massive body's force.",                        "stat": "strength", "amount": -0.14, "turns": 7 },
			{ "name": "Deep Side Bite",      "flavor": "A deep bite along your side makes every hit matter more.",                         "stat": "defense",  "amount": -0.14, "turns": 7 },
			{ "name": "Mud-Wrenched Leg",    "flavor": "A twisted leg makes movement heavy, painful, and slow.",                           "stat": "speed",    "amount": -0.14, "turns": 7 },
			{ "name": "Missed Danger Rumble","flavor": "You fail to read the low signals of danger around you.",                           "stat": "type_stat","amount": -0.14, "turns": 7 },
		],
		"severe": [
			{ "name": "Torn Neck Muscle",    "flavor": "A serious neck injury makes powerful movement painful and weak.",                   "stat": "strength", "amount": -0.18, "turns": -1 },
			{ "name": "Open Giant Wound",    "flavor": "A massive wound leaves even your huge body dangerously exposed.",                  "stat": "defense",  "amount": -0.24, "turns": 15 },
			{ "name": "Failing Giant Step",  "flavor": "One great leg struggles to carry you, making escape desperate.",                   "stat": "speed",    "amount": -0.24, "turns": 15 },
			{ "name": "Isolation Panic",     "flavor": "Fear of separation overwhelms your instincts during hunts and threats.",           "stat": "type_stat","amount": -0.24, "turns": 15 },
		],
	},
}

const FALLBACK_INJURY_POOLS := {
	"minor": [
		{ "name": "Scratched flank", "stat": "defense",  "amount": -0.08, "turns": 2 },
		{ "name": "Bruised jaw",     "stat": "strength", "amount": -0.08, "turns": 2 },
	],
	"moderate": [
		{ "name": "Torn muscle", "stat": "speed",    "amount": -0.20, "turns": 3 },
		{ "name": "Cracked rib", "stat": "defense",  "amount": -0.20, "turns": 4 },
		{ "name": "Deep gash",   "stat": "defense",  "amount": -0.15, "turns": 3 },
	],
	"severe": [
		{ "name": "Broken leg",    "stat": "speed",    "amount": -0.30, "turns": 5  },
		{ "name": "Eye damage",    "stat": "type_stat","amount": -0.25, "turns": -1 },
		{ "name": "Shattered claw","stat": "strength", "amount": -0.25, "turns": 4  },
	],
}


func roll_injury(severity: String) -> Dictionary:
	var sid: String = GameState.species_id
	var pools: Dictionary = INJURY_POOLS.get(sid, FALLBACK_INJURY_POOLS) as Dictionary
	var pool: Array = pools.get(severity, []) as Array
	if pool.is_empty():
		pool = FALLBACK_INJURY_POOLS.get(severity, []) as Array
	if pool.is_empty():
		return {}
	return pool[randi() % pool.size()]
