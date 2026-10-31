@tool
extends EditorScript

# ── COMBAT SIMULATION TEST RUNNER ────────────────────────────────────────────
# Run this from the Godot editor: Script → Run (Ctrl+Shift+X)
# Simulates N fights per dino and prints outcome distributions + flee success
# rates so you can spot balance issues and check whether Run is a viable option.

const RUNS := 2000

const DINO_STATS := {
	"compsognathus": { "style": "speed",  "size": 1,  "power": [0.10, 0.25], "resilience": [0.10, 0.22], "agility": [0.65, 0.82], "instinct": [0.55, 0.72] },
	"velociraptor":  { "style": "speed",  "size": 2,  "power": [0.25, 0.45], "resilience": [0.20, 0.38], "agility": [0.65, 0.80], "instinct": [0.60, 0.75] },
	"deinonychus":   { "style": "pack",   "size": 3,  "power": [0.35, 0.55], "resilience": [0.30, 0.50], "agility": [0.55, 0.70], "instinct": [0.55, 0.70] },
	"allosaurus":    { "style": "bite",   "size": 6,  "power": [0.60, 0.80], "resilience": [0.58, 0.74], "agility": [0.35, 0.50], "instinct": [0.45, 0.60] },
	"trex":          { "style": "bite",   "size": 8,  "power": [0.75, 0.95], "resilience": [0.65, 0.85], "agility": [0.20, 0.38], "instinct": [0.45, 0.62] },
	"lesothosaurus": { "style": "speed",  "size": 1,  "power": [0.08, 0.18], "resilience": [0.15, 0.28], "agility": [0.70, 0.85], "instinct": [0.55, 0.70] },
	"iguanodon":     { "style": "charge", "size": 5,  "power": [0.35, 0.52], "resilience": [0.45, 0.62], "agility": [0.40, 0.55], "instinct": [0.50, 0.65] },
	"triceratops":   { "style": "charge", "size": 7,  "power": [0.55, 0.72], "resilience": [0.60, 0.78], "agility": [0.25, 0.40], "instinct": [0.45, 0.60] },
	"ankylosaurus":  { "style": "bulk",   "size": 7,  "power": [0.20, 0.38], "resilience": [0.80, 0.95], "agility": [0.10, 0.22], "instinct": [0.35, 0.50] },
	"argentinosaurus":{ "style": "bulk",  "size": 9,  "power": [0.30, 0.50], "resilience": [0.75, 0.92], "agility": [0.08, 0.18], "instinct": [0.40, 0.55] },
}

# Enemy brackets — fp, size, and a realistic agility range for that tier.
# Small/fast prey has high agility; large apex prey is slower but still dangerous.
const ENEMY_BRACKETS := [
	{ "fp": 0.15, "size": 1, "agility": [0.55, 0.70], "label": "tiny"   },
	{ "fp": 0.30, "size": 2, "agility": [0.45, 0.62], "label": "small"  },
	{ "fp": 0.45, "size": 4, "agility": [0.35, 0.52], "label": "medium" },
	{ "fp": 0.60, "size": 5, "agility": [0.28, 0.48], "label": "large"  },
	{ "fp": 0.75, "size": 7, "agility": [0.22, 0.42], "label": "apex"   },
]

const ADVANTAGE_RATIO := 1.80

# Life stages mirror GameState.life_stage values (0–4).
# stage_mod is added to Power and Resilience only — matches combat_resolver.gd line 58.
const LIFE_STAGES := [
	{ "name": "Juvenile",  "mod": 0.025 },
	{ "name": "Sub-adult", "mod": 0.050 },
	{ "name": "Adult",     "mod": 0.075 },
	{ "name": "Elder",     "mod": 0.100 },
]


func _run() -> void:
	print("\n=== COMBAT SIMULATION — %d runs per matchup ===\n" % RUNS)
	for dino_id in DINO_STATS:
		print("══ %s ══" % dino_id.to_upper())
		var ds: Dictionary = DINO_STATS[dino_id] as Dictionary
		for stage in LIFE_STAGES:
			var st:         Dictionary = stage as Dictionary
			var stage_name: String     = st.get("name", "") as String
			var stage_mod:  float      = st.get("mod",  0.0) as float
			print("  ── %s ──" % stage_name)
			for bracket in ENEMY_BRACKETS:
				var b:     Dictionary = bracket as Dictionary
				var fp:    float      = b.get("fp",    0.30) as float
				var esz:   int        = b.get("size",  3)    as int
				var eagi:  Array      = b.get("agility", [0.35, 0.50]) as Array
				var label: String     = b.get("label", "") as String

				var wins        := 0
				var wins_inj    := 0
				var losses      := 0
				var losses_bad  := 0
				var fled_clean  := 0
				var fled_caught := 0

				for _i in range(RUNS):
					var outcome := _sim_fight(ds, fp, esz, stage_mod)
					match outcome:
						"win":      wins += 1
						"win_inj":  wins_inj += 1
						"lose":     losses += 1
						"lose_bad": losses_bad += 1

					if _sim_flee(ds, eagi):
						fled_clean += 1
					else:
						fled_caught += 1

				var total := float(RUNS)
				print("    vs %-6s (fp=%.2f sz=%d)  |  Win %.0f%%  Win+Inj %.0f%%  Lose %.0f%%  Lose(bad) %.0f%%  |  Run: Escape %.0f%%  Caught %.0f%%" % [
					label, fp, esz,
					wins        / total * 100,
					wins_inj    / total * 100,
					losses      / total * 100,
					losses_bad  / total * 100,
					fled_clean  / total * 100,
					fled_caught / total * 100,
				])
		print("")


func _sim_fight(ds: Dictionary, enemy_fp: float, enemy_size: int, stage_mod: float) -> String:
	# Power and Resilience get the life stage bonus; Agility and Instinct do not.
	# Matches combat_resolver.gd load_player_stats() lines 58-60.
	var p: float  = minf(randf_range(ds.power[0],      ds.power[1])      + stage_mod, 1.0)
	var r: float  = minf(randf_range(ds.resilience[0], ds.resilience[1]) + stage_mod, 1.0)
	var a: float  = randf_range(ds.agility[0],    ds.agility[1])
	var i: float  = randf_range(ds.instinct[0],   ds.instinct[1])
	var s: int    = ds.size as int
	var style: String = ds.style as String

	var player_fp := _effective_attack(p, r, a, i, s, style)

	var atk_b := player_fp * 0.50 + clampf((s         - enemy_size) * 0.06, -0.18, 0.18)
	var def_b := enemy_fp  * 0.50 + clampf((enemy_size - s)         * 0.06, -0.18, 0.18)
	var ratio := atk_b / maxf(def_b, 0.01)

	var atk_roll := _roll(ratio >= ADVANTAGE_RATIO) + atk_b
	var def_roll := _roll(ratio <= 1.0 / ADVANTAGE_RATIO) + def_b
	var diff     := atk_roll - def_roll

	if diff >= 0.30:
		return "win" if randf() > 0.15 else "win_inj"
	elif diff >= 0.0:
		return "win_inj"
	elif diff >= -0.30:
		return "lose"
	else:
		return "lose_bad"


func _sim_flee(ds: Dictionary, enemy_agility_range: Array) -> bool:
	# Player agility + small luck factor vs enemy agility.
	# Even when faster, a 5% stumble chance keeps escape from feeling guaranteed.
	# Matches action_resolver.gd _resolve_combat_choice() Run logic.
	var player_agi: float = randf_range(ds.agility[0], ds.agility[1])
	var luck_factor: float = randf_range(-0.15, 0.15) * 0.40
	var p_speed := player_agi + luck_factor
	var e_speed: float = randf_range(enemy_agility_range[0], enemy_agility_range[1])
	if p_speed < e_speed:
		return false
	return randf() > 0.05  # 5% fumble even when faster


func _effective_attack(p: float, r: float, a: float, i: float, size: int, style: String) -> float:
	match style:
		"bite":   return p
		"speed":  return (a * 0.55) + (p * 0.45)
		"pack":   return (p * 0.55) + (i * 0.45)
		"bulk":   return (r * 0.65) + (p * 0.35)
		"charge": return (p * 0.55) + clampf(size * 0.04, 0.0, 0.32)
	return p


func _roll(has_advantage: bool) -> float:
	var roll := randf()
	return maxf(roll, randf()) if has_advantage else roll
