extends RefCounted

const COMPANIONS = preload("res://scripts/systems/companions.gd")
const WORLD = preload("res://scripts/systems/world_conditions.gd")
const TITLES = {"argentinosaurus": "Where the canopy returns", "velociraptor": "The reed-bed boundary"}


static func title(fallback: String) -> String:
	return TITLES.get(GameState.species_id, fallback)


static func customize(event: Dictionary, state: Dictionary) -> void:
	if GameState.species_id not in TITLES:
		return
	var phase := int(state["phase"])
	var text := ""
	if GameState.species_id == "argentinosaurus":
		if phase == 0:
			text = "Your herd has stripped the lower canopy. Higher in the hills, an upland forest still holds fresh leaves. Reaching it together will take two seasons. The ridge keeps you above the riverbanks; the river route offers easier places to rest, but a risky crossing."
		elif phase == 1:
			text = "The ridge narrows beneath the herd's weight. Loose rock gives under each step." if state["route"] == "ridge" else ("Floodwater presses against the herd's legs. The familiar ford is deep and its bank is giving way." if WORLD.kind() == "flood" else "The herd reaches the river ford. Each heavy step stirs mud over the firm stones below.")
			text += "\n\nSpend 8% food finding firm ground for the herd, or push through at the health cost shown below. The forest is still one season away."
		else:
			text = "The upland canopy rises ahead. You reached it by the %s trail; the herd's familiar rumbles answer from behind. Shelter at its edge gives 20%% food. The tallest, richest browse gives 35%% food, but an exposed approach costs 7%% health. Either choice improves feeding for this season and the next two." % state["route"]
	else:
		if phase == 0:
			text = "Fresh Velociraptor signals cross the reed beds where your pack hunts. Another pack is using the same narrow lanes. Over the next two seasons you can agree on separate hunting times, or patrol the lanes as your own. A truce costs food; defending them risks wounds."
		elif phase == 1:
			text = "The other pack answers from the reeds. " + ("They wait at the edge of the hunting lane you offered to share." if state["route"] == "share" else "They cross the lane you have been patrolling.")
			text += "\n\nLeave a portion and agree on hunting times for 6% food, or hold the lane for 6% health. This choice decides whether the final agreement is shared or defended."
		else:
			text = "The reeds carry fewer competing signals. " + ("Both packs are waiting their turn at the hunting lanes. Accepting the agreement gives 15% food and a modest feeding/territory advantage for three seasons." if state["route"] == "share" else "Your pack's signals hold the lanes. Keeping them gives 20% food and a stronger feeding/territory advantage for three seasons, at a final cost of 5% health.")
	if phase == 0:
		for member in COMPANIONS.current_cast():
			if member.get("active", false):
				var steady: bool = member.get("role") == "steady"
				var advice := ("favors a slow climb above the river." if steady else "wants the gentler river approach.") if GameState.species_id == "argentinosaurus" else ("wants to agree on hunting times." if steady else "wants your signals to own the lanes.")
				text += "\n\n%s %s" % [member["name"], advice]
	if phase == 1 and not COMPANIONS.supporters().is_empty():
		text += "\n\n%s can help for 3%% food, using their support for this season." % COMPANIONS.LIFE_STORY.names_text(COMPANIONS.supporters())
	if GameState.pack_bond <= 0.0:
		text += "\n\nYour group is no longer with you. You will have to finish the journey alone."
	event["title"] = title(event["title"]) if phase != 1 else ("A crossing for giants" if GameState.species_id == "argentinosaurus" else "Signals across the reeds")
	event["flavor"] = text
