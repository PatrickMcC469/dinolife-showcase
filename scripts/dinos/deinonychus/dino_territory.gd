extends "res://scripts/dinos/base_dino_territory.gd"

const TERRITORY_DATA: Dictionary = {
	"strong": [
		"You rake deep lines into bark and leave the brush smelling like a pack's warning.",
		"Your sickle claws carve a message into the trees that rivals would be foolish to ignore.",
		"The territory feels claimed by teeth, feathers, and coordinated threat.",
		"Your calls carry through the ferns, sharp enough to make smaller hunters vanish.",
		"You mark the hunting paths with claw strikes and steady confidence.",
		"The brush feels less like wilderness and more like a trap you understand.",
		"Your scent and scratches turn the area into a pack-controlled hunting lane.",
		"Every mark says the same thing: this ground has claws.",
		"The territory settles under your presence, tense and watchful.",
		"You leave the area feeling sharpened, claimed, and dangerous.",
	],
	"useful": [
		"You mark several trees and leave clear signs near the best trails.",
		"Your claw marks hold well enough to guide your next hunt.",
		"The territory feels more familiar after your patrol.",
		"You leave scent and scratches where prey movement looks strongest.",
		"Your signs are not overwhelming, but they are clear.",
		"You mark the brushline and listen as the forest quiets around you.",
		"The claim is solid enough to help you read the area later.",
		"You scratch bark, scent the trail, and move on with purpose.",
		"The hunting ground feels a little more under control.",
		"You leave enough warning that smaller rivals may think twice.",
	],
	"contested": [
		"A rival claw mark cuts across yours, fresh and deliberate.",
		"You catch the scent of another Deinonychus near the same trail.",
		"The brush goes quiet in a way that means something else is watching.",
		"Another predator has marked the tree before you.",
		"Your scent mixes with a stranger's, and neither claim feels settled.",
		"A distant call answers yours from deeper in the ferns.",
		"You find trampled grass where another hunter recently passed.",
		"Something has been using the same ambush path.",
		"Your marks hold, but another set of claws has challenged them.",
		"The territory is useful, but it is not yours alone.",
	],
	"weak": [
		"Rain softens your marks before they can carry.",
		"Your scratches look shallow against the bark.",
		"The wind shifts and scatters your scent through the wrong trails.",
		"Your call fades without answer or effect.",
		"The brush feels unchanged after your patrol.",
		"You mark the area, but nothing about it feels controlled.",
		"Your scent is lost beneath mud, plants, and old tracks.",
		"The ground is too busy with movement to claim clearly.",
		"Your warning marks fail to stand out.",
		"The territory remains wild, uncertain, and only partly understood.",
	],
}

func get_territory_data() -> Dictionary:
	return TERRITORY_DATA
