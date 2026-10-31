extends "res://scripts/dinos/base_dino_sharpen.gd"

const SHARPEN_DATA: Dictionary = {
	"strength": {
		"button":  "Refine precise claw hooks",
		"success": "Your claw work becomes sharper, helping you strike with cleaner precision.",
		"failure": "Your hook timing slips, making your next attacks feel less reliable.",
	},
	"defense": {
		"button":  "Keep low behind brush",
		"success": "You practice staying covered, making it harder for danger to hit you cleanly.",
		"failure": "You hug the cover too tightly and leave yourself boxed in.",
	},
	"speed": {
		"button":  "Cut sharper angles through dust",
		"success": "Your footwork improves, helping you dodge and flee with better control.",
		"failure": "You push too fast through loose ground and throw off your next sprint.",
	},
	"instinct": {
		"button":  "Study wind, scent, and silence",
		"success": "You read the air carefully, improving your next hunting opportunity.",
		"failure": "You overthink every signal and miss what should have been obvious.",
	},
}

func get_sharpen_data() -> Dictionary:
	return SHARPEN_DATA
