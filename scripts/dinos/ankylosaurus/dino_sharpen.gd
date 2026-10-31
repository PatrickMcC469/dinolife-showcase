extends "res://scripts/dinos/base_dino_sharpen.gd"

const SHARPEN_DATA: Dictionary = {
	"strength": {
		"button":  "Swing weight through your tail",
		"success": "Your tail swing feels heavier and better timed.",
		"failure": "You overuse your tail muscles, weakening your next strike.",
	},
	"defense": {
		"button":  "Lock down behind your armor",
		"success": "You practice lowering your body, helping your armor take the next hit better.",
		"failure": "You brace unevenly and expose softer gaps between your plates.",
	},
	"speed": {
		"button":  "Practice steady low movement",
		"success": "Your low steps become steadier, improving your next dodge or retreat.",
		"failure": "You shuffle too heavily and feel slower afterward.",
	},
	"instinct": {
		"button":  "Turn the right side to danger",
		"success": "You sharpen your defensive instincts and angle your armor more naturally.",
		"failure": "You practice the wrong turn and leave yourself poorly positioned.",
	},
}

func get_sharpen_data() -> Dictionary:
	return SHARPEN_DATA
