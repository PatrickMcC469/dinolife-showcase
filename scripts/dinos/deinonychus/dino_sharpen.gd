extends "res://scripts/dinos/base_dino_sharpen.gd"

const SHARPEN_DATA: Dictionary = {
	"strength": {
		"button":  "Sharpen sickle-claw strikes",
		"success": "Your claw strikes land with better control and force.",
		"failure": "You scrape your claw awkwardly, making your next attacks less steady.",
	},
	"defense": {
		"button":  "Brace after the pounce",
		"success": "You practice landing low and strong, helping your body hold up in the next fight.",
		"failure": "Your landings are sloppy, leaving your guard weaker than before.",
	},
	"speed": {
		"button":  "Practice leap-and-recover drills",
		"success": "Your legs learn to spring and reset faster after each movement.",
		"failure": "You push your leap too hard, leaving your next dodge slower.",
	},
	"instinct": {
		"button":  "Read the pack's hunting rhythm",
		"success": "You fall into the rhythm of the hunt, reading openings more clearly.",
		"failure": "You misread the timing and carry that confusion into your next hunt.",
	},
}

func get_sharpen_data() -> Dictionary:
	return SHARPEN_DATA
