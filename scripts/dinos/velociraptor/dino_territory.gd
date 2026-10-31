extends "res://scripts/dinos/base_dino_territory.gd"

const TERRITORY_DATA: Dictionary = {
	"strong": [
		"You mark the dust paths and thorn gaps with subtle signs only a clever hunter would notice.",
		"Your scent settles low across the brush, turning quiet routes into claimed hunting lines.",
		"Every stone, root, and dust trail feels placed into your mental map.",
		"You claim the hidden paths where prey thinks it is safe.",
		"Your marks are quiet, but they say enough to warn anything paying attention.",
		"The wind carries your scent exactly where you want it.",
		"You turn the brush into a maze that favors your feet.",
		"Your territory feels sharp, silent, and ready.",
		"You leave signs so precise that the next hunt already feels easier to read.",
		"The dust remembers your steps.",
	],
	"useful": [
		"You mark a few stones and brush gaps along a useful trail.",
		"Your scent settles lightly through the dry grass.",
		"The territory feels more familiar after your careful patrol.",
		"You leave small signs where prey tracks cross most often.",
		"Your markings are subtle, but they may help next season.",
		"You claim a narrow path through the brush well enough for now.",
		"Your dust marks hold long enough to guide your return.",
		"You mark the best angle around a thorn patch.",
		"The area does not feel controlled, but it feels readable.",
		"You leave quiet signs across the hunting ground.",
	],
	"contested": [
		"Another raptor's tracks cross your dust trail.",
		"A strange scent clings to the same thornbrush gap.",
		"You find claw marks where you planned to leave your own.",
		"Something has been using your quiet path before you.",
		"A rival's scent rides the wind before yours can settle.",
		"Fresh tracks cut straight through your claim.",
		"The brush carries another hunter's warning.",
		"You pause as a distant chirp answers from the rocks.",
		"Your markings mix with signs of something equally patient.",
		"The territory feels useful, but watched.",
	],
	"weak": [
		"The wind scatters your scent before it settles.",
		"Loose dust erases your tracks almost as soon as you make them.",
		"Your marks fail to hold in the shifting ground.",
		"The brush is too tangled to claim cleanly.",
		"Your scent trail breaks apart in the dry air.",
		"The territory feels no easier to read afterward.",
		"Your signs are too faint to matter.",
		"The dust swallows your claim.",
		"You mark the area, but the wind takes most of it.",
		"Nothing about the hunting ground feels more yours.",
	],
}

func get_territory_data() -> Dictionary:
	return TERRITORY_DATA
