extends "res://scripts/dinos/base_dino_sharpen.gd"

const SHARPEN_DATA: Dictionary = {
	"strength": {
		"button":  "Practice quick snap-bites",
		"success": "Your bite timing sharpens, making your next strikes feel quicker and cleaner.",
		"failure": "You overextend your jaw during practice, making your next attacks feel weaker.",
	},
	"defense": {
		"button":  "Learn to twist away from danger",
		"success": "You practice slipping out of reach, helping you take hits less directly.",
		"failure": "You twist the wrong way too often, leaving your body easier to catch off guard.",
	},
	"speed": {
		"button":  "Drill dart-and-run footwork",
		"success": "Your tiny feet move faster after practicing quick escapes through roots and leaves.",
		"failure": "You tire yourself out with too many bursts, slowing your next escape.",
	},
	"instinct": {
		"button":  "Watch shadows before they move",
		"success": "You study every flicker in the brush, sharpening your next hunt instincts.",
		"failure": "You startle at harmless movement and second-guess real openings.",
	},
}

func get_sharpen_data() -> Dictionary:
	return SHARPEN_DATA
