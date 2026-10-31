extends RefCounted

const COMPANIONS = preload("res://scripts/systems/companions.gd")
const CATALOG = {
	"trailwise": {"name": "Trailwise", "icon": "territory", "stat": "feeding", "amount": 0.02, "goal": 1, "requirement": "Finish your species' journey with its reward."},
	"sheltercraft": {"name": "Sheltercraft", "icon": "shield", "stat": "defense", "amount": 0.03, "goal": 2, "requirement": "Prepare a home shelter to level 2."},
	"devoted_parent": {"name": "Devoted Parent", "icon": "nest", "stat": "speed", "amount": 0.03, "goal": 1, "requirement": "Raise a young dinosaur that leaves with a strong bond."},
	"battle_hardened": {"name": "Battle Hardened", "icon": "hunt", "stat": "strength", "amount": 0.03, "goal": 5, "requirement": "Win 5 fights in this life."},
	"long_stride": {"name": "Long Stride", "icon": "territory", "stat": "speed", "amount": 0.03, "goal": 12, "requirement": "Survive 12 seasons and reach Sub-adult."},
	"trusted_circle": {"name": "Trusted Circle", "icon": "group", "stat": "defense", "amount": 0.03, "goal": 2, "requirement": "Earn Trusting relationships with 2 active companions."},
}
const LEGACY = {
	"Family Lesson": "Up to +2% to one stat from a learned family skill chosen in Lineage before this life began. One family lesson per life.",
	"Great Bond": "Up to +4% health, strength, speed and defense from your mother's guidance.",
	"Strong Bond": "Up to +2.5% health, strength, speed and defense from your mother's guidance.",
	"Raised Well": "Up to +8% strength from your parent's lessons.",
	"Well Raised": "Up to +5% strength from your parent's lessons.",
	"Fair Start": "Up to +4% speed from your parent's lessons.",
	"Great Mother": "Up to +4% to one stat, chosen when earned; +20% starting bond for future young (starting bond caps at 60%).",
	"Good Mother": "Up to +2.5% to one stat, chosen when earned; +10% starting bond for future young (starting bond caps at 60%).",
	"Good Parent": "Up to +5% health from consistent nesting care. Can be earned twice per life.",
	"Successful Solo Raise": "Up to +5% health from raising young alone. Can be earned twice per life. Its +12% strength boost is temporary and appears below while active.",
	"Tail Spike Survivor": "Up to +12% defense from surviving a tail-spike encounter.",
	"Apex Deterrent": "Up to +14% technique from standing against an apex predator.",
	"Bone Breaker": "Up to +16% strength from a decisive tail strike.",
	"Scarred Plates": "Up to +14% defense from surviving a severe encounter.",
	"Titan Nerve": "Up to +14% technique from holding firm under predator pressure.",
	"Earthshaker": "Up to +16% strength from a powerful display.",
	"Living Horizon": "Up to +14% defense from your imposing presence.",
	"Scarred Survivor": "Up to +6% defense from surviving a dangerous encounter.",
	"Spike Veteran": "Up to +15% defense from using your thumb spike effectively.",
	"Sharp Turn": "Up to +15% speed from an exceptional escape.",
	"Horn Survivor": "Up to +15% defense from surviving a horned opponent.",
	"Club Survivor": "Up to +15% defense from surviving a club-tailed opponent.",
	"Perfect Charge": "Up to +16% strength from a perfectly timed charge.",
	"Rival Defeated": "Your recurring rival was defeated. This is a milestone; it does not grant an additional stat boost by itself.",
	"Proven Line": "Adds +3% to the strength modifier used at life-stage growth after two consecutive mating victories.",
	"Dominant Line": "Adds another +3% to the strength modifier used at life-stage growth after four consecutive mating victories.",
	"Winter Watcher — Defense increased": "Up to +3% lasting defense and a one-time +4% strength gain from studying the hunter.",
	"White Ghost Kill": "Recorded a legendary hunt. At the time, it granted up to +50% food and +2% strength; it is not an ongoing boost.",
	"Bone Ground Claim": "Marked a strong territory claim for the following season and gained +5% defense for 3 seasons. The active boost appears below until it expires.",
}


static func restore(value: Variant) -> Array:
	var restored: Array = []
	if value is Array:
		for key in value:
			if key is String and key in CATALOG and key not in restored:
				restored.append(key)
	# A saved bonus name is also proof of an award; never apply it twice.
	for key in CATALOG:
		if CATALOG[key]["name"] in GameState.bonuses_earned and key not in restored:
			restored.append(key)
	return restored


static func eligible(key: String) -> bool:
	return key != "trusted_circle" or COMPANIONS.supported()


static func progress(key: String) -> int:
	match key:
		"trailwise":
			return 1 if GameState.journey_state.get("phase", -1) == 3 and float(GameState.journey_state.get("reward", 0.0)) > 0.0 else 0
		"sheltercraft": return int(GameState.living_state.get("shelter", 0)) if GameState.living_state.get("shelter_author", "player") == "player" else 0
		"devoted_parent": return GameState.offspring_history.filter(func(child): return child is Dictionary and child.get("bond", "") == "strong").size()
		"battle_hardened": return GameState.fights_won
		"long_stride": return GameState.seasons_elapsed
		"trusted_circle": return COMPANIONS.active_cast().filter(func(member): return COMPANIONS.relationship(member) == "Trusting").size() if COMPANIONS.supported() else 0
	return 0


static func award() -> Array[String]:
	var newly: Array[String] = []
	if GameState.health <= 0.0 or GameState.species_id.is_empty():
		return newly
	for key in CATALOG:
		var data: Dictionary = CATALOG[key]
		if key in GameState.earned_perks or not eligible(key) or progress(key) < int(data["goal"]):
			continue
		if key == "long_stride" and GameState.life_stage < 2: continue
		GameState.earned_perks.append(key)
		GameState.bonuses_earned.append(data["name"])
		if data["stat"] != "feeding":
			var modifier := "permanent_" + str(data["stat"]) + "_mod"
			GameState.set(modifier, float(GameState.get(modifier)) + float(data["amount"]))
			GameState.set(data["stat"], minf(1.0, float(GameState.get(data["stat"])) + float(data["amount"])))
		preload("res://scripts/systems/life_story.gd").remember("perk_" + key, "Earned %s. %s" % [data["name"], effect(key)], 7)
		newly.append(str(data["name"]))
	return newly


static func modifier(action: String) -> float:
	return 0.02 if "trailwise" in GameState.earned_perks and action in ["hunt", "graze", "scavenge"] else 0.0


static func effect(key: String) -> String:
	var data: Dictionary = CATALOG[key]
	return "+2 percentage points to feeding success chances." if data["stat"] == "feeding" else "Up to +3%% %s. Stat values cap at 100%%." % str(data["stat"])


static func legacy_effect(name: String) -> String:
	for key in CATALOG:
		if CATALOG[key]["name"] == name: return effect(key)
	if name in LEGACY:
		var text: String = LEGACY[name]
		if name in ["Great Mother", "Good Mother", "Family Lesson"]:
			var grants: Array = GameState.bonus_stat_grants.get(name, [])
			for grant in grants:
				text += "\nRecorded grant: +%.1f%% %s." % [float(grant["amount"]) * 100, str(grant["stat"])]
			if grants.size() < GameState.bonuses_earned.count(name): text += "\nEarlier grants do not identify the chosen stat."
		return text
	if name.begins_with("Well Fed "): return "Up to +5% defense from consistently full food reserves in this life stage."
	if name.begins_with("Thriving "): return "Up to +4% speed from consistently high health in this life stage."
	if name.begins_with("Keen "): return "Up to +4% technique from consistent practice in this life stage."
	return "A recorded reward from this life. Its original save does not describe an exact effect."


static func record_grant(name: String, stat: String, amount: float) -> void:
	if not GameState.bonus_stat_grants.has(name): GameState.bonus_stat_grants[name] = []
	GameState.bonus_stat_grants[name].append({"stat": stat, "amount": amount})


static func restore_grants(value: Variant) -> Dictionary:
	var restored := {}
	if not value is Dictionary: return restored
	for name in ["Great Mother", "Good Mother", "Family Lesson"]:
		if not value.get(name) is Array: continue
		var grants: Array = []
		for grant in value[name]:
			if not grant is Dictionary or grant.get("stat", "") not in ["health", "strength", "speed", "defense"]: continue
			var amount = grant.get("amount")
			if not (amount is int or amount is float): continue
			var expected := 0.04 if name == "Great Mother" else (0.02 if name == "Family Lesson" else 0.025)
			if is_equal_approx(float(amount), expected): grants.append({"stat": grant["stat"], "amount": expected})
		restored[name] = grants.slice(0, GameState.bonuses_earned.count(name))
	return restored


static func legacy_status(name: String) -> String:
	if name == "Rival Defeated": return "MILESTONE"
	if name == "White Ghost Kill": return "ONE-TIME REWARD"
	if name == "Bone Ground Claim": return "RECORDED CLAIM · TEMPORARY EFFECT"
	return "THIS LIFE"
