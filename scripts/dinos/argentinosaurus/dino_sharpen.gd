extends "res://scripts/dinos/base_dino_sharpen.gd"

const SHARPEN_DATA: Dictionary = {
	"strength": {
		"button":  "Build force through neck and shoulders",
		"success": "Your neck and shoulders feel stronger after slow, steady practice.",
		"failure": "You strain your long neck, weakening your next forceful movement.",
	},
	"defense": {
		"button":  "Endure beneath your massive frame",
		"success": "You practice standing firm, helping your huge body absorb the next threat.",
		"failure": "You settle your weight badly and leave yourself more vulnerable.",
	},
	"speed": {
		"button":  "Keep your giant steps steady",
		"success": "Your stride feels smoother, helping you move with more control.",
		"failure": "You push your legs too far and feel heavy moving into next season.",
	},
	"instinct": {
		"button":  "Stay with the herd's deep rhythm",
		"success": "You tune into the herd's movement, reading danger through the ground and calls.",
		"failure": "You drift out of rhythm and miss signals you should have felt.",
	},
}

func get_sharpen_data() -> Dictionary:
	return SHARPEN_DATA
