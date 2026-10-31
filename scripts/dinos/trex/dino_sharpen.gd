extends "res://scripts/dinos/base_dino_sharpen.gd"

const SHARPEN_DATA: Dictionary = {
	"strength": {
		"button":  "Focus the killing bite",
		"success": "Your bite timing sharpens, making your next attack feel decisive.",
		"failure": "You strain your jaws during practice, dulling your next bite.",
	},
	"defense": {
		"button":  "Absorb the clash with your bulk",
		"success": "You practice taking impact through your weight, helping you endure the next fight.",
		"failure": "You brace badly and leave your body less prepared for the next hit.",
	},
	"speed": {
		"button":  "Train one decisive rush",
		"success": "Your heavy first rush feels cleaner and harder to avoid.",
		"failure": "You push your legs too hard, making your next movement slower.",
	},
	"instinct": {
		"button":  "Follow scent to the opening",
		"success": "You sharpen your scent focus, helping you find the next hunt's weak point.",
		"failure": "Too many old smells muddy your focus and make openings harder to read.",
	},
}

func get_sharpen_data() -> Dictionary:
	return SHARPEN_DATA
