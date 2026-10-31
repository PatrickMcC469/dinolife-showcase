extends Node

signal world_flavor_ready(text: String)
signal event_ready(event_data: Dictionary)

# Passive world flavor — keyed by season_tree for distinct perspectives
const WORLD_FLAVOR = {

	# ── SPRING ────────────────────────────────────────────────────────────────
	"spring_predator": [
		"The thaw has pushed prey into the open. Everything that was hidden is moving again.",
		"Hatchling season. Easy food near the nests — if you find them before the parents return.",
		"The mud holds every track. You know exactly what has been through here and when.",
		"New growth gives the prey more cover. Less open ground for a clean run.",
		"Three different species are moving through your range right now. None of them are watching carefully yet.",
		"The scent trails are sharp after the rain. Reading this ground costs nothing.",
		"Rivals are resurveying their ranges. You'll need to remind them where yours ends.",
		"The prey is fat and slow from winter. The season won't stay this easy.",
	],
	"spring_herbivore": [
		"The grass is coming back. Enough to move slowly, to not count every bite.",
		"The herd spread after the thaw. More space — and more exposure.",
		"Predator tracks in the soft ground. Fresh. Whatever made them hasn't gone far.",
		"New growth means cover — for you and for whatever is hunting you.",
		"The watering hole is crowded again. Everyone is coming out of the cold at once.",
		"The calves born this season won't make it through summer without the herd's attention.",
		"The air smells of rain and growth and something else moving through the undergrowth.",
		"The mud slows everything equally. Small comfort when the predators are also faster now.",
	],
	"spring_flyer": [
		"The thermals are back. Spring air moves differently — warmer pockets, longer glides.",
		"From above: the herd is spread across three ridges. The predators are following the eastern group.",
		"The river has swollen over its banks. Fish in the shallows — easy picking if you time the dive.",
		"The colony is arguing over nest sites. The best ledges have had two fights over them already.",
		"You can see three ranges from this altitude. Something is burning in the valley one ridge over.",
		"New growth has softened the canopy. Things that were visible from above are hidden again.",
		"The migration routes are active. Thousands of wings in the thermals heading north.",
		"Updrafts off the warming rock are stronger by midday. The air is working for you today.",
	],

	# ── SUMMER ────────────────────────────────────────────────────────────────
	"summer_predator": [
		"Midday: nothing moves. The hunt belongs to early morning and late evening now.",
		"The watering hole brings everything to one place. Patience is a hunting technique.",
		"The herd is lean from the heat. Slower than spring — but more defensive for it.",
		"A rival has been marking the ridge line. The marks are recent and deliberate.",
		"The dust rises to the south. Something large is moving through dry ground.",
		"Three days without a clean kill. The season makes patience mandatory.",
		"The insects are loud. Everything that breathes is waiting in the shade.",
		"Dead prey near the eastern flats — more than is normal. Drought or disease. Both change how you hunt.",
	],
	"summer_herbivore": [
		"The watering hole is the most dangerous place in any range, and the only one that matters right now.",
		"Dry ground means less cover. A predator on the ridge can read your position from a distance.",
		"The grass has yellowed. Moving further for the green is a risk you keep calculating.",
		"Heat makes everyone slower and shorter-tempered. Even the herd is difficult.",
		"You can smell the predator before you see any track. The wind is working against you.",
		"The calves are struggling. The herd keeps circling back. The circling costs time you don't have.",
		"Dust cloud to the east — could be a herd moving, could be something chasing a herd.",
		"The watering hole truce holds by mutual exhaustion. Nobody has energy to break it.",
	],
	"summer_flyer": [
		"From altitude: every creature in this range is converging on one point. The watering hole.",
		"The thermals collapse by midday. The air goes flat and still. Every flight after noon costs more.",
		"Smoke rising to the southwest. Fire moves fast in the dry season. The wind is pointed at you.",
		"The insects swarm so thick in the lowland that from above it looks like a second canopy.",
		"The fish have gone deep with the heat. The surface is empty. The approach has to change.",
		"Three days of dead air. No thermals, no updrafts. Flying is effort with nothing behind it.",
		"The colony drinks at the river bend at dawn. The things waiting in the shallows know this now.",
		"From above: the predator is following the same track it used yesterday and the day before.",
	],

	# ── FALL ──────────────────────────────────────────────────────────────────
	"fall_predator": [
		"The migration is on. More prey than all year — and more hunters than all year.",
		"Everything is feeding like it's the last chance. Because it is.",
		"The rut has the prey distracted. Adults fighting each other instead of watching the perimeter.",
		"Rival packs have moved in behind the migration. Your range is contested from two directions.",
		"The cold nights have started slowing the prey. The advantage is shifting your way.",
		"A herd has been moving through for three days. You've eaten well. It won't last.",
		"The sick ones are falling behind the main group. The season is sorting them out for you.",
		"Last real chance before the lean months. Everything with sense is hunting heavy right now.",
	],
	"fall_herbivore": [
		"The rut is on. The bulls are focused on each other. You use the distraction to eat.",
		"Migration instinct pulling toward the south. The herd hasn't committed yet. Neither have you.",
		"The predators are following the herds south. The pressure behind you is building.",
		"Leaf fall has stripped your cover. You are more visible than you were a season ago.",
		"Everyone is eating to build reserves. The best feeding grounds have real competition now.",
		"Something about the air says move. You haven't moved yet and you don't know why.",
		"The sick have separated from the main group. You keep your distance.",
		"The nights are cold enough that rest costs something. The days are getting shorter.",
	],
	"fall_flyer": [
		"The migration thermals are extraordinary. Air carrying thousands of wings south in one corridor.",
		"From altitude: the hunting below is chaotic. Every predator in the range is moving at once.",
		"The cliff face is busy. Every ledge has something on it before nightfall.",
		"The thermals are shifting south. Your instinct and your territory are pulling in opposite directions.",
		"From above: three kills visible in a half-day's range. The season has fully arrived.",
		"The insects are disappearing. The food source that carried you through summer is closing.",
		"Colony is restless. Whether to stay or follow the thermals south hasn't been settled.",
		"Storm systems building from the north. The air is unpredictable. Every flight costs more.",
	],

	# ── WINTER ────────────────────────────────────────────────────────────────
	"winter_predator": [
		"The lean season. Every kill has to last longer than it would in any other time of year.",
		"The prey has thinned to what couldn't or wouldn't leave. The sick, the old, the unlucky.",
		"Rival tracks everywhere. Everyone is hunting the same shrinking pool.",
		"A kill site two days old, picked clean. You weren't the first one here by a long time.",
		"The cold is making the prey cluster. Easier to locate — harder to separate from the group.",
		"You've been following the same trail for two days. Whatever made it is still ahead of you.",
		"The storm rearranged everything overnight. Familiar ground looks wrong.",
		"Two seasons ago this range held ten times what it holds now. The winter math is brutal.",
	],
	"winter_herbivore": [
		"The herd is smaller than it was in spring. You've stopped counting.",
		"The predators are desperate. They don't break off as quickly as they did in fall.",
		"Snow covers the feeding ground. Bark, frozen roots, anything with any value.",
		"The cold slows the predators too. Small comfort when it slows everything else as well.",
		"The herd's outer edge is the most dangerous position. You are on the outer edge.",
		"Another one went down in the night. You didn't investigate. You knew what it meant.",
		"The watering hole has frozen solid. The river bend is the only option — and everything knows it.",
		"Three days without a good feed. The body is starting to answer for it.",
	],
	"winter_flyer": [
		"From altitude: the range is almost empty. What moved south when the thermals went was right to do so.",
		"The thermals are gone. Every flight is raw effort with nothing working for you.",
		"The colony has shrunk. Some followed the migration. You stayed and you're not sure why.",
		"The cliff face is cold enough that the rock pulls warmth from wherever you press against it.",
		"Ice on the river has trapped fish near the surface at the open bend. The only real opportunity in days.",
		"Wind from the north doesn't stop. Flying into it costs too much. You wait on the ledge.",
		"The prey below is slow and exposed against the snow. From altitude you can read every position.",
		"Three storms in seven days. You've barely left the roost. The hunger is starting to matter.",
	],
}


func roll_world_event() -> void:
	var condition_flavor := preload("res://scripts/systems/world_conditions.gd").flavor()
	var season = GameState.get_season_key()
	var species = SpeciesDB.get_species(GameState.species_id)
	var tree = species.get("tree", "predator")
	var key = season + "_" + tree
	var pool: Array = WORLD_FLAVOR.get(key, WORLD_FLAVOR.get(season + "_predator", []))
	if not condition_flavor.is_empty():
		emit_signal("world_flavor_ready", condition_flavor)
	elif pool.size() > 0:
		emit_signal("world_flavor_ready", pool[randi() % pool.size()])
	_maybe_fire_world_event(season)


func _maybe_fire_world_event(season: String) -> void:
	var species = SpeciesDB.get_species(GameState.species_id)
	var tree = species.get("tree", "predator")
	var candidates = EventsDB.get_events_for_context(season, tree, GameState.species_id, GameState.life_stage)
	if candidates.is_empty():
		return

	# Desperate events get guaranteed priority when the player is in a bad state.
	if GameState.is_desperate():
		var desperate_pool: Array = candidates.filter(func(e): return e.get("require_desperate", false))
		if not desperate_pool.is_empty():
			_fire_event(desperate_pool[randi() % desperate_pool.size()])
			return

	# Weighted roll — rarity determines chance to even be considered
	var rolled = []
	for ev in candidates:
		if ev.get("require_desperate", false):
			continue  # skip turning-point events when not desperate
		var weight = EventsDB.get_rarity_weight(ev.get("rarity", "common"))
		if randf() < weight * 0.35:  # base 35% for common, scales down
			rolled.append(ev)
	if rolled.is_empty():
		return
	var chosen = rolled[randi() % rolled.size()]
	_fire_event(chosen)


func _inject_rival_name(text: String) -> String:
	if GameState.rival_name.is_empty():
		return text
	var name_cap := GameState.rival_name.capitalize()
	return text.replace("{rival}", name_cap)


func _fire_event(event_data: Dictionary) -> void:
	var flavor: String = _inject_rival_name(event_data.get("flavor", ""))
	if event_data.get("passive", false):
		_apply_passive_effects(event_data)
		if flavor != "":
			emit_signal("event_ready", {
				"type": "world_passive",
				"flavor": flavor,
				"choices": [],
				"resolve_key": "",
			})
	else:
		emit_signal("event_ready", {
			"type": event_data.get("id", "world_event"),
			"flavor": flavor,
			"choices": event_data.get("choices", []),
			"resolve_key": event_data.get("resolve_key", ""),
		})


func _apply_passive_effects(ev: Dictionary) -> void:
	var effects: Dictionary = ev.get("effects", {})
	var species = SpeciesDB.get_species(GameState.species_id)
	var tree = species.get("tree", "predator")

	if effects.has("hunger_mod_herb") and tree == "herbivore":
		GameState.hunger = minf(1.0, GameState.hunger + effects["hunger_mod_herb"])

	if effects.has("speed_buff") and effects.has("speed_buff_turns"):
		GameState.apply_temp_buff("speed", effects["speed_buff"], effects["speed_buff_turns"], ev.get("id", "event"))

	if effects.has("stealth_buff") and effects.has("stealth_buff_turns"):
		GameState.apply_temp_buff("type_stat", effects["stealth_buff"], effects["stealth_buff_turns"], ev.get("id", "event"))

	if effects.has("stamina_buff") and effects.has("stamina_buff_turns"):
		GameState.apply_temp_buff("type_stat", effects["stamina_buff"], effects["stamina_buff_turns"], ev.get("id", "event"))

	if effects.has("hunger_decay_mod"):
		# Flag on GameState for TurnManager to read
		GameState.apply_temp_buff("hunger", -effects["hunger_decay_mod"], effects.get("speed_buff_turns", 3), ev.get("id", "event") + "_hunger")


func get_action_event(action_id: String) -> Dictionary:
	match action_id:
		"hunt":      return {}
		"scavenge":  return _roll_scavenge_event()
		"graze":     return {}
		"rest":      return {}
		"territory": return {}
		"sharpen":   return {}
		"water":     return {}
		_:           return {}


func _roll_hunt_event() -> Dictionary:
	var uses = GameState.get_action_uses("hunt")
	if uses >= 3:
		return {
			"type": "action_blocked",
			"flavor": "The area has gone quiet. Nothing stirs.",
			"choices": [], "resolve_key": ""
		}
	var flavors = [
		"You catch a scent on the wind. Something is nearby.",
		"Movement in the brush ahead. Could be prey.",
		"Tracks in the dirt. Fresh. Something came through here recently.",
		"A sound — too deliberate to be the wind.",
		"The undergrowth shifts. Something stopped moving when you did.",
	]
	return {
		"type": "hunt_search",
		"flavor": flavors[randi() % flavors.size()],
		"choices": [
			{ "label": "Follow the trail", "icon": "attack", "sublabel": "Press the hunt",         "action": "hunt_pursue" },
			{ "label": "Approach slowly",  "icon": "stalk",  "sublabel": "Don't spook it",         "action": "hunt_stalk" },
			{ "label": "Leave it",         "icon": "flee",   "sublabel": "Not worth the risk",     "action": "leave" },
		],
		"resolve_key": "hunt",
	}


func _roll_scavenge_event() -> Dictionary:
	var uses = GameState.get_action_uses("scavenge")
	if uses >= 2:
		return {
			"type": "action_blocked",
			"flavor": "You have picked this area clean. Nothing left here.",
			"choices": [], "resolve_key": ""
		}
	var species_tree: String = SpeciesDB.get_species(GameState.species_id).get("tree", "predator") as String
	var is_herbivore: bool = species_tree == "herbivore"
	var flavor: String
	if is_herbivore:
		var herb_flavors := [
			"A dense cluster of something edible is nearby. You can smell it from here.",
			"Something grows thick just off the main path. It looks undisturbed.",
			"You catch the scent of ripe vegetation on the air. Something worth investigating.",
			"A patch of growth is tucked into the low ground ahead. Heavy enough to smell at a distance.",
		]
		flavor = herb_flavors[randi() % herb_flavors.size()]
	else:
		flavor = "The smell of something old hangs in the air. Worth investigating."
	return {
		"type": "scavenge_search",
		"flavor": flavor,
		"choices": [
			{ "label": "Dig in",       "icon": "attack", "sublabel": "Take what you can",        "action": "scavenge_eat" },
			{ "label": "Keep looking", "icon": "stalk",  "sublabel": "Maybe something better",   "action": "scavenge_continue" },
		],
		"resolve_key": "scavenge",
	}
