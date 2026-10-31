extends "res://scripts/dinos/base_dino_sharpen.gd"

const SHARPEN_DATA: Dictionary = {
	"strength": {
		"button":  "Drive power into your bite",
		"success": "Your jaws and neck work together, making your next attack feel heavier.",
		"failure": "You strain your bite practice, weakening your next strike.",
	},
	"defense": {
		"button":  "Turn your hide against the hit",
		"success": "You practice angling your body, helping you absorb the next clash better.",
		"failure": "You turn too late in practice, leaving your guard poorly set.",
	},
	"speed": {
		"button":  "Practice short crushing lunges",
		"success": "Your short bursts become cleaner, improving your next rush or dodge.",
		"failure": "You overwork your legs and feel stiff moving into next season.",
	},
	"instinct": {
		"button":  "Learn where prey will break",
		"success": "You study movement and fear, making the next opening easier to spot.",
		"failure": "You chase the wrong imagined weakness and dull your hunting focus.",
	},
}

func get_sharpen_data() -> Dictionary:
	return SHARPEN_DATA
