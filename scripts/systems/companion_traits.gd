extends RefCounted

const TRAITS = ["cautious", "bold", "protective", "independent"]
const DESCRIPTIONS = {
	"cautious": "Cautious · values cover and careful plans",
	"bold": "Bold · values exploration and decisive action",
	"protective": "Protective · values shared food and keeping others safe",
	"independent": "Independent · values space and having a say",
}
const AFFINITIES = {
	"stand": {"bold": 0.08, "protective": 0.08, "cautious": -0.15},
	"cover": {"cautious": 0.10, "protective": 0.08, "bold": -0.04},
	"scout": {"bold": 0.12, "independent": 0.12, "cautious": -0.08},
	"cooperate": {"independent": 0.08, "cautious": 0.04},
	"ridge": {"cautious": 0.08, "bold": -0.04},
	"river": {"bold": 0.08, "cautious": -0.04},
	"grove": {"protective": 0.08, "independent": -0.04},
}
const REMEMBERED = {
	"share": "You shared scarce food with them.",
	"stand": "You stayed beside them when danger came.",
	"cover": "You guided them safely out of danger.",
	"abandon": "You left them exposed to danger.",
	"keep": "You kept the food while they waited.",
	"cooperate": "You listened to their judgment.",
	"scout": "You trusted them to find the way.",
	"force": "You forced them to follow your timing.",
	"share_shelter": "You made room beside you in shelter.",
	"keep_shelter": "You kept the best shelter for yourself.",
	"council_backed": "You backed their concern when the group disagreed.",
	"council_overruled": "You chose another member's plan over their concern.",
	"council_heard": "You found a way to hear both sides of a disagreement.",
}


static func ensure(member: Dictionary) -> void:
	if member.get("trait", "") not in TRAITS:
		# Stable upgrades preserve old names, trust and the random sequence of a run.
		member["trait"] = "cautious" if member.get("role") == "steady" else ("bold" if member.get("role") == "challenger" else TRAITS[posmod(str(member.get("name", "")).hash(), TRAITS.size())])
	var memories: Array = []
	if member.get("memories") is Array:
		for memory in member["memories"]:
			if not memory is Dictionary or memory.get("choice", "") not in REMEMBERED:
				continue
			var season = memory.get("season", -1)
			if not (season is float or season is int) or int(season) < 0:
				continue
			memories.append({"choice": str(memory["choice"]), "season": int(season), "resolved": memory.get("resolved", false) == true})
	member["memories"] = memories.slice(maxi(0, memories.size() - 3))


static func description(member: Dictionary) -> String:
	ensure(member)
	return DESCRIPTIONS[member["trait"]]


static func affinity(member: Dictionary, choice: String) -> float:
	ensure(member)
	return float(AFFINITIES.get(choice, {}).get(member["trait"], 0.0))


static func hint(member: Dictionary, kind: String) -> String:
	ensure(member)
	var preference := ""
	match kind:
		"protect":
			preference = "prefers a safe route through cover" if member["trait"] == "cautious" else ("respects standing your ground" if member["trait"] in ["bold", "protective"] else "values help that leaves them room to act")
		"lead":
			preference = "wants the route checked together" if member["trait"] in ["cautious", "protective"] else "wants a chance to scout on their own"
		"share", "shelter":
			preference = "notices whether everyone has a place" if member["trait"] == "protective" else "will remember how you treat them here"
	if preference.is_empty():
		return ""
	return "%s is %s and %s." % [member["name"], member["trait"], preference]


static func record(member: Dictionary, choice: String) -> void:
	ensure(member)
	if choice not in REMEMBERED:
		return
	for memory in member["memories"]:
		if memory["choice"] == choice and int(memory["season"]) == GameState.seasons_elapsed:
			return
	member["memories"].append({"choice": choice, "season": GameState.seasons_elapsed, "resolved": false})
	if member["memories"].size() > 3:
		member["memories"].pop_front()


static func details(member: Dictionary) -> String:
	ensure(member)
	var lines: Array[String] = []
	for memory in member["memories"]:
		lines.append("Season %d · %s" % [int(memory["season"]) + 1, REMEMBERED[memory["choice"]]])
	return "\n".join(lines)
