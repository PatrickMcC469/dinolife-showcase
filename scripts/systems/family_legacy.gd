extends RefCounted

const TRAITS = ["curious", "cautious", "bold", "protective"]
const SKILLS = {
	"forage": {"name": "Find food", "lesson": "feeding lesson", "trait": "curious", "stat": "strength"},
	"cover": {"name": "Use cover", "lesson": "shelter lesson", "trait": "cautious", "stat": "defense"},
	"routes": {"name": "Read a trail", "lesson": "trail lesson", "trait": "bold", "stat": "speed"},
}


static func restore(value: Variant) -> Dictionary:
	var state := {"children": {}, "last_tick": GameState.seasons_elapsed, "pending": {}, "inheritance": {}}
	if not value is Dictionary: return state
	var children = value.get("children", {})
	if children is Dictionary:
		var names: Array = [GameState.offspring_name, GameState.juvenile_name]
		for child in GameState.offspring_history: names.append(child.get("name", ""))
		for name in children:
			if name is String and not name.is_empty() and name in names and children[name] is Dictionary:
				state["children"][name] = clean_child(children[name], name)
	state["last_tick"] = clampi(int(_number(value.get("last_tick"), GameState.seasons_elapsed)), -1, GameState.seasons_elapsed)
	var pending = value.get("pending")
	if pending is Dictionary and pending.get("name") in state["children"] and _number(pending.get("season"), -1) == GameState.seasons_elapsed:
		state["pending"] = {"name": pending["name"], "season": GameState.seasons_elapsed}
	var inherited = value.get("inheritance")
	if inherited is Dictionary and inherited.get("name") is String and inherited.get("skill") in SKILLS:
		state["inheritance"] = {"name": inherited["name"], "skill": inherited["skill"]}
	return state


static func _number(value: Variant, fallback: float) -> float:
	return float(value) if (value is int or value is float) and is_finite(float(value)) else fallback


static func clean_child(value: Dictionary, name: String) -> Dictionary:
	var child := {"name": name, "trait": value.get("trait", "") if value.get("trait") in TRAITS else TRAITS[posmod(name.hash(), TRAITS.size())], "skills": {}, "born": clampi(int(_number(value.get("born"), GameState.seasons_elapsed)), 0, GameState.seasons_elapsed)}
	for key in SKILLS:
		child["skills"][key] = clampi(int(_number(value.get("skills", {}).get(key), 0)) if value.get("skills", {}) is Dictionary else 0, 0, 2)
	return child


static func ensure_child(name: String) -> Dictionary:
	if name.is_empty(): return {}
	if not GameState.family_state.has("children"): GameState.family_state["children"] = {}
	if not GameState.family_state["children"].has(name):
		GameState.family_state["children"][name] = clean_child({}, name)
	return GameState.family_state["children"][name]


static func active_names() -> Array[String]:
	var names: Array[String] = []
	if GameState.has_young: names.append(load("res://scripts/systems/life_story.gd").young_name())
	if GameState.has_juvenile and not GameState.juvenile_name.is_empty() and GameState.juvenile_name not in names: names.append(GameState.juvenile_name)
	return names


static func available() -> bool:
	return GameState.health > 0 and (GameState.has_young or GameState.has_juvenile or not GameState.offspring_history.is_empty() or not GameState.family_state.get("inheritance", {}).is_empty())


static func learned(child: Dictionary) -> int:
	var count := 0
	for key in SKILLS: count += int(child.get("skills", {}).get(key, 0))
	return count


static func natural_skill(child: Dictionary) -> String:
	for skill in SKILLS:
		if SKILLS[skill]["trait"] == child["trait"]: return skill
	return "cover"


static func growth(name: String) -> Dictionary:
	var young := GameState.has_young and name == GameState.offspring_name
	var age := GameState.has_young_turns if young else GameState.juvenile_bond_turns
	var duration: int = SpeciesDB.get_species(GameState.species_id).get("nesting_seasons", 3) if young else TurnManager.MATERNAL_JUVENILE_SEASONS
	return {"young": young, "age": age, "duration": duration, "care": GameState.nesting_score if young else GameState.offspring_bond}


static func tick() -> void:
	if GameState.health <= 0 or int(GameState.family_state.get("last_tick", -1)) == GameState.seasons_elapsed: return
	GameState.family_state["last_tick"] = GameState.seasons_elapsed
	for name in active_names():
		var child := ensure_child(name)
		var amount := mini(2, int(learned(child) / 2)) * 0.01
		if name == GameState.offspring_name and GameState.has_young:
			GameState.nesting_score = minf(1.0, GameState.nesting_score + amount)
		elif name == GameState.juvenile_name and GameState.has_juvenile:
			GameState.offspring_bond = minf(1.0, GameState.offspring_bond + amount)


static func event(name: String) -> Dictionary:
	if name not in active_names() or GameState.get_action_uses("family_lesson") > 0 or GameState.health <= 0: return {}
	ensure_child(name)
	GameState.family_state["pending"] = {"name": name, "season": GameState.seasons_elapsed}
	GameState.save_run()
	return pending_event()


static func pending_event() -> Dictionary:
	var pending: Dictionary = GameState.family_state.get("pending", {})
	if pending.is_empty(): return {}
	var name := str(pending.get("name", ""))
	if GameState.health <= 0 or name not in active_names() or GameState.get_action_uses("family_lesson") > 0 or int(pending.get("season", -1)) != GameState.seasons_elapsed:
		GameState.family_state["pending"] = {}
		return {}
	var child := ensure_child(name)
	var choices: Array = []
	if GameState.hunger >= 0.03:
		for key in SKILLS:
			if int(child["skills"][key]) < 2:
				var natural: bool = child["trait"] == SKILLS[key]["trait"] or (child["trait"] == "protective" and key == "cover")
				choices.append({"action": key, "label": SKILLS[key]["name"], "icon": "nest", "sublabel": "3%% food · %s · +3%% care or juvenile bond" % ("a natural strength; learns quickly" if natural else "one step of practice")})
	choices.append({"action": "back", "label": "Let them rest", "icon": "rest", "sublabel": "Keep your lesson for this season"})
	return {"type": "living_event", "title": "Time with " + name, "image_key": GameState.species_id + "_teaching_young", "flavor": "%s is %s. %s\n\nOne lesson each season, shared across your young. Practiced skills add up to 2%% nesting care or juvenile bond each season; they stay in your family record when this child leaves." % [name, child["trait"], {"curious": "Every new sound pulls their attention away, then brings them back with another question.", "cautious": "They wait for your signal before trying a new path.", "bold": "They rush ahead, then turn back to see whether you followed.", "protective": "They stop to check on the others before following you."}[child["trait"]]], "choices": choices, "resolve_key": "family", "next_context": "family"}


static func teach(name: String, skill: String) -> bool:
	if name not in active_names() or skill not in SKILLS or GameState.get_action_uses("family_lesson") > 0: return false
	var child := ensure_child(name)
	if int(child["skills"][skill]) >= 2: return false
	var natural: bool = child["trait"] == SKILLS[skill]["trait"] or (child["trait"] == "protective" and skill == "cover")
	child["skills"][skill] = mini(2, int(child["skills"][skill]) + (2 if natural else 1))
	GameState.record_action_use("family_lesson")
	return true


static func resolve(choice: String) -> Dictionary:
	var current := pending_event()
	if current.is_empty(): return {"type": "result", "flavor": "That lesson is no longer available.", "choices": []}
	if not current["choices"].any(func(option): return option["action"] == choice): return current
	var name: String = GameState.family_state["pending"]["name"]
	GameState.family_state["pending"] = {}
	var text := ""
	if choice != "back" and teach(name, choice):
		GameState.hunger -= 0.03
		if name == GameState.offspring_name and GameState.has_young: GameState.nesting_score = minf(1.0, GameState.nesting_score + 0.03)
		else: GameState.offspring_bond = minf(1.0, GameState.offspring_bond + 0.03)
		text = "%s %s %s" % [name, {"forage": "follows your gaze to the feeding signs and tries the trail alone.", "cover": "waits for the rustle to pass, then reaches the shelter without your signal.", "routes": "tests the turning path, looks back, and finds the way home."}[choice], "The lesson has settled into a skill." if int(ensure_child(name)["skills"][choice]) == 2 else "There is still more to practice."]
		load("res://scripts/systems/life_story.gd").remember("family_lesson_%d" % GameState.seasons_elapsed, text, 7)
	GameState.save_run()
	TurnManager.stat_changed.emit()
	return {"type": "result", "flavor": text, "choices": []}


static func skill_summary(child: Dictionary) -> String:
	var text: Array[String] = []
	for key in SKILLS:
		var level := int(child.get("skills", {}).get(key, 0))
		text.append("%s: %s" % [SKILLS[key]["name"], ["Not practiced", "Learning", "Learned"][clampi(level, 0, 2)]])
	return "\n".join(text)


static func legacy_skill(child: Dictionary) -> String:
	if child.get("bond") not in ["strong", "steady"]: return ""
	for key in SKILLS:
		if int(child.get("skills", {}).get(key, 0)) == 2: return key
	return ""


static func inherit(lesson: Dictionary) -> void:
	if not GameState.family_state.get("inheritance", {}).is_empty(): return
	if lesson.get("skill") not in SKILLS or not lesson.get("name") is String: return
	var skill: String = lesson["skill"]
	GameState.family_state["inheritance"] = {"name": lesson["name"], "skill": skill}
	var stat: String = SKILLS[skill]["stat"]
	GameState.set(stat, minf(1.0, float(GameState.get(stat)) + 0.02))
	GameState.set("permanent_" + stat + "_mod", float(GameState.get("permanent_" + stat + "_mod")) + 0.02)
	GameState.bonuses_earned.append("Family Lesson")
	GameState.bonus_stat_grants["Family Lesson"] = [{"stat": stat, "amount": 0.02}]
	load("res://scripts/systems/life_story.gd").remember("family_inheritance", "%s's %s helped this new life begin. +2%% %s." % [lesson["name"], SKILLS[skill]["lesson"], stat], 8)
