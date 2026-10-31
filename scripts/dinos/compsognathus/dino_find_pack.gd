extends "res://scripts/dinos/base_dino_find_pack.gd"

const FIND_PACK_DATA: Dictionary = {
	"no_male": [
		"You find a scatter of compies chirping beneath the ferns. No one blocks your path, and the group seems willing to let another quick mouth join.",
		"A small pack darts through root tunnels ahead of you, nervous but not hostile. Their calls leave room for you to follow.",
		"You find compies picking through leaf litter together. They watch you closely, but no challenger steps forward.",
		"A lively little group gathers near a scrap trail. They chirp, shuffle, and make space without a fight.",
		"You catch familiar scents beneath a fallen log. The group is wary, but nothing stands between you and joining.",
	],
	"dominant_male": [
		"You find a busy compi group near a rich scrap trail, but a bold male blocks your way with raised tail and snapping teeth.",
		"A pack gathers beneath the ferns, but one sharp-eyed male rushes forward, making it clear the group is not free to join.",
		"You approach a group of compies feeding together, and the dominant male lets out a harsh chirp before lunging between you and the others.",
		"The group smells strong and useful, but a male stands in the center of it, daring you to come closer.",
		"You find the kind of pack that could help you survive, but its male leader bares his teeth and refuses to share.",
	],
	"no_group": [
		"You follow scattered chirps through the leaves, but each one fades before you find the source.",
		"The undergrowth is full of tracks, but none lead to a group willing to gather.",
		"You search every root tunnel and fern gap, but no compies answer your calls.",
		"The scents are old, the trails are broken, and the small shadows stay hidden.",
		"You find signs of other compies, but they are already gone.",
	],
}

func get_find_pack_data() -> Dictionary:
	return FIND_PACK_DATA
