extends "res://scripts/dinos/base_dino_sharpen.gd"

const SHARPEN_DATA: Dictionary = {
	"strength": {
		"button":  "Put power behind your horns",
		"success": "Your horn drive feels stronger and more controlled.",
		"failure": "You jar your horn base during practice, weakening your next charge.",
	},
	"defense": {
		"button":  "Guard behind frill and stance",
		"success": "You practice lowering your head and holding firm, strengthening your next defense.",
		"failure": "Your stance opens at the wrong angle, leaving you easier to hurt.",
	},
	"speed": {
		"button":  "Practice short charging steps",
		"success": "Your charge starts feel sharper and more stable.",
		"failure": "You overwork your forelegs, making your next movement slower.",
	},
	"instinct": {
		"button":  "Sense when the herd should brace",
		"success": "You sharpen your warning instincts, reading danger before it closes in.",
		"failure": "You tense too early and miss the real signal when it matters.",
	},
}

func get_sharpen_data() -> Dictionary:
	return SHARPEN_DATA
