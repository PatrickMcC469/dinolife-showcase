extends PanelContainer

const COMPANIONS = preload("res://scripts/systems/companions.gd")
const MEMBER_CARD = preload("res://scenes/ui/companion_member_card.tscn")
const LEADERSHIP = preload("res://scripts/systems/pack_leadership.gd")

@onready var heading: Label = $Content/Header/Heading
@onready var details_button: Button = $Content/Header/DetailsButton
@onready var cards: VBoxContainer = $Content/Cards
@onready var summary: Label = $Content/Summary

var expanded := false


func _ready() -> void:
	details_button.pressed.connect(_toggle_details)
	TurnManager.turn_started.connect(refresh)
	TurnManager.stat_changed.connect(refresh)
	PackManager.pack_disbanded.connect(refresh)
	refresh()


func _toggle_details() -> void:
	expanded = not expanded
	details_button.text = "Close" if expanded else "Details"
	refresh()


func refresh(_flavor: String = "") -> void:
	COMPANIONS.ensure_cast()
	var cast := COMPANIONS.current_cast()
	visible = COMPANIONS.supported() and not cast.is_empty()
	if not visible:
		return
	heading.text = ("YOUR " if GameState.pack_bond > 0.0 else "FORMER ") + COMPANIONS.group_name().to_upper()
	var ready := COMPANIONS.supporters()
	var alpha := LEADERSHIP.leader()
	var present := COMPANIONS.active_cast().size()
	summary.text = "%s size: %d / %d · %d ready to help" % [COMPANIONS.group_name().capitalize(), present + 1 if GameState.pack_bond > 0.0 else 0, COMPANIONS.max_companions() + 1, ready.size()]
	summary.text += "\n" + ("Includes you and %d companion%s" % [present, "" if present == 1 else "s"] if GameState.pack_bond > 0.0 else "You are traveling alone")
	if not alpha.is_empty():
		summary.text += "\n" + ("You are the alpha · one leadership action per season" if GameState.is_alpha else "Alpha: %s · %s toward you" % [alpha["name"], COMPANIONS.relationship(alpha)])
	var gone := cast.filter(func(member: Dictionary): return not member.get("active", false))
	var departed := gone.size()
	if departed > 0:
		summary.text += "\n%d departed · Latest departures below" % departed
	# Keep the roster readable after repeated departures and recruitment.
	var recent := gone.slice(maxi(0, gone.size() - 2))
	cast = cast.filter(func(member: Dictionary): return member.get("active", false) or (expanded and member in recent))
	while cards.get_child_count() < cast.size():
		cards.add_child(MEMBER_CARD.instantiate())
	for i in cards.get_child_count():
		var card: PanelContainer = cards.get_child(i)
		card.visible = i < cast.size()
		if not card.visible:
			continue
		var member: Dictionary = cast[i]
		var member_name: String = member["name"]
		var state := COMPANIONS.relationship(member)
		card.get_node("Content/Identity/Name").text = member_name
		card.get_node("Content/Identity/Alpha").visible = LEADERSHIP.is_leader(member)
		card.get_node("Content/Extra/Role").text = ("Alpha · " if LEADERSHIP.is_leader(member) else "") + COMPANIONS.personality(member)
		card.get_node("Content/Extra/Role").text += "\n" + preload("res://scripts/systems/companion_traits.gd").description(member)
		card.get_node("Content/Trait").text = str(member.get("trait", "")).to_upper()
		var badge: Label = card.get_node("Content/Identity/Badge/State")
		badge.text = state.to_upper()
		var color := Color(0.82, 0.72, 0.51)
		if state == "Trusting":
			color = Color(0.64, 0.86, 0.60)
		elif state == "Distant":
			color = Color(0.91, 0.57, 0.44)
		elif state == "Gone":
			color = Color(0.65, 0.64, 0.60)
		badge.add_theme_color_override("font_color", color)
		var trust: VBoxContainer = card.get_node("Content/Trust")
		trust.visible = state != "Gone"
		var percent := floori((float(member.get("trust", 0.0)) + 1.0) * 50.0)
		trust.get_node("Level").text = "Trust in you · %d%%" % percent
		var meter: ProgressBar = trust.get_node("Meter")
		meter.value = percent
		var fill: StyleBoxFlat = meter.get_theme_stylebox("fill").duplicate()
		fill.bg_color = color
		meter.add_theme_stylebox_override("fill", fill)
		var extra: VBoxContainer = card.get_node("Content/Extra")
		extra.visible = expanded
		extra.get_node("TrustGuide").visible = state != "Gone"
		extra.get_node("Reason").text = member.get("reason", "")
		var memories := preload("res://scripts/systems/companion_traits.gd").details(member)
		extra.get_node("Memories").text = "REMEMBERS\n" + memories
		extra.get_node("Memories").visible = not memories.is_empty()
		var support := "Needs more trust to offer support"
		if member_name in ready:
			support = "Ready to stand with you"
		elif GameState.seasons_elapsed < int(member.get("rest_until", -1)):
			support = "Resting · can help in %d season%s" % [int(member["rest_until"]) - GameState.seasons_elapsed, "" if int(member["rest_until"]) - GameState.seasons_elapsed == 1 else "s"]
		elif state == "Trusting":
			support = "Already helped this season"
		elif state == "Gone":
			support = "No longer with your " + COMPANIONS.group_name()
		extra.get_node("Support/Status").text = support
