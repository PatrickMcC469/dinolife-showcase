extends "res://scripts/dinos/base_dino_find_pack.gd"

const FIND_PACK_DATA: Dictionary = {
	"strong": [
		"You find a powerful herd with horns outward and calves protected near the center.",
		"A strong Triceratops herd stands in a loose circle, calm but ready.",
		"You find a herd that moves like a wall, slow, steady, and difficult to threaten.",
		"The circle opens just enough for you, then closes strong again.",
		"You find horns, frills, and heavy bodies gathered into real safety.",
	],
	"small": [
		"You find a smaller herd moving carefully across open ground.",
		"A few Triceratops stand together near low plants, alert and guarded.",
		"The herd lacks numbers, but its horns still make the world feel safer.",
		"You find a small group watching the horizon with disciplined patience.",
		"A modest herd lets you approach after a long, tense look.",
	],
	"unstable": [
		"You find a herd with too many gaps between bodies and too much tension in the air.",
		"The defensive circle is loose, and the young press close in nervous silence.",
		"You find Triceratops that should be bracing together, but keep drifting apart.",
		"The herd accepts you, but its wall feels weak.",
		"Warning snorts pass through the group without a clear response.",
	],
	"no_group": [
		"You search for heavy tracks and low warning snorts, but find only empty ground.",
		"The mud holds old horn marks, but no herd remains nearby.",
		"You follow trampled grass until the trail fades.",
		"The open land feels wide, quiet, and missing the safety of horns.",
		"You find signs of a herd, but they lead beyond your reach.",
	],
}

func get_find_pack_data() -> Dictionary:
	return FIND_PACK_DATA
