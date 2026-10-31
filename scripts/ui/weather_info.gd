extends RefCounted

const WORLD = preload("res://scripts/systems/world_conditions.gd")
const HOME = preload("res://scripts/systems/living_world.gd")
const ART_ICONS = preload("res://scripts/ui/illustrated_icons.gd")
const ICONS = [
	preload("res://assets/ui/action_icons/weather_rain.svg"),
	preload("res://assets/ui/action_icons/weather_sun.svg"),
	preload("res://assets/ui/action_icons/weather_bloom.svg"),
	preload("res://assets/ui/action_icons/weather_snow.svg"),
]
const SEASON_DETAILS = [
	"Rain shapes this season's encounters. Floods and fresh growth can appear; their effects depend on the event and your choices. Rain alone has no fixed stat penalty.",
	"Heat and dry ground shape this season's encounters. Droughts and food shortages can appear. Dry weather alone has no fixed stat penalty; active conditions are listed below.",
	"Eligible dinosaurs can seek mates this season. Courtship, rivals and nesting choices depend on your species, life stage and readiness.",
	"Cold-season encounters may bring ice, scarce food or shelter choices. Prepared shelter can reduce the extra food used in your home range.",
]


static func caption() -> String:
	return {"flood": "Flood", "drought": "Drought"}.get(WORLD.kind(), GameState.get_season_name())


static func icon() -> Texture2D:
	if WORLD.kind() == "flood": return ART_ICONS.texture("weather_flood")
	if WORLD.kind() == "drought": return ART_ICONS.texture("weather_sun")
	return ART_ICONS.texture(["weather_rain", "weather_sun", "weather_bloom", "weather_snow"][GameState.current_season])


static func detail() -> String:
	var text := "CURRENT SEASON · %s\n%s" % [GameState.get_season_name(), SEASON_DETAILS[GameState.current_season]]
	var condition := WORLD.kind()
	text += "\n\nACTIVE CONDITIONS\n" + WORLD.summary() + "\n" + WORLD.detail()
	if not condition.is_empty():
		var effects: Dictionary = WORLD.CONDITIONS[condition]
		for action in ["hunt", "graze", "scavenge", "water", "territory"]:
			if action not in effects: continue
			var name: String = {"hunt": "Hunting", "graze": "Grazing", "scavenge": "Foraging", "water": "Finding water", "territory": "Range claims"}[action]
			text += "\n%s: %+.0f percentage points to success chance." % [name, float(effects[action]) * 100]
	if GameState.life_stage > 0:
		var home := str(GameState.living_state.get("site", ""))
		if home in HOME.SITES: text += "\n\nLOCAL FOOD & TRACKS\n" + preload("res://scripts/systems/habitat_conditions.gd").detail(home)
		if condition == "drought": text += "\nDrought food cost: 3% extra each season."
		if GameState.current_season == 3 and HOME.available() and not GameState.living_state.get("site", "").is_empty():
			text += "\n\nCOLD & YOUR SHELTER\nShelter level %d / 2. Cold food cost: %.0f%% extra each season." % [int(GameState.living_state.get("shelter", 0)), HOME.cold_cost() * 100]
		if condition == "flood" and HOME.available() and GameState.living_state.get("site") == "river":
			text += "\nRiver bend flood cost: %.1f%% health each season." % ((0.04 - int(GameState.living_state.get("shelter", 0)) * 0.015) * 100)
	else:
		text += "\n\nAs a hatchling, seasonal food drain and lasting world conditions do not apply yet."
	return text
