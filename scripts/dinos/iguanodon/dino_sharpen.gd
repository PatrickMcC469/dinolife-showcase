extends "res://scripts/dinos/base_dino_sharpen.gd"

const SHARPEN_DATA: Dictionary = {
	"strength": {
		"button":  "Drive force through your thumb spikes",
		"success": "Your forelimbs and thumb spikes feel steadier for the next fight.",
		"failure": "You strain your forelimb during practice, weakening your next strike.",
	},
	"defense": {
		"button":  "Set your shoulder and hold firm",
		"success": "You practice bracing your body, helping you absorb the next attack.",
		"failure": "Your stance slips too often, leaving your defense poorly set.",
	},
	"speed": {
		"button":  "Keep pace with the moving herd",
		"success": "Your stride steadies, helping you move and dodge more confidently.",
		"failure": "You push too hard to keep pace and feel sluggish afterward.",
	},
	"instinct": {
		"button":  "Read the herd's danger signals",
		"success": "You study the herd's reactions, improving your next survival read.",
		"failure": "You misread harmless movement and carry doubt into your next choice.",
	},
}

func get_sharpen_data() -> Dictionary:
	return SHARPEN_DATA
