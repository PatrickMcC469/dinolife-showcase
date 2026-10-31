extends "res://scripts/dinos/base_dino_sharpen.gd"

const SHARPEN_DATA: Dictionary = {
	"strength": {
		"button":  "Toughen your little bite and tug",
		"success": "Your jaw and neck feel stronger after working through tough roots and resistant stems.",
		"failure": "You strain yourself tugging too hard, weakening your next effort.",
	},
	"defense": {
		"button":  "Fold low beneath cover",
		"success": "You practice making yourself small, helping danger hit you less cleanly.",
		"failure": "You crouch too stiffly and leave yourself slow to react.",
	},
	"speed": {
		"button":  "Practice sudden escape bursts",
		"success": "Your legs feel sharper after quick starts through the grass.",
		"failure": "You tire your legs with too many bursts, hurting your next escape.",
	},
	"instinct": {
		"button":  "Listen before the warning call",
		"success": "You sharpen your awareness, catching danger before panic spreads.",
		"failure": "Every small sound feels like danger, making your instincts unreliable.",
	},
}

func get_sharpen_data() -> Dictionary:
	return SHARPEN_DATA
