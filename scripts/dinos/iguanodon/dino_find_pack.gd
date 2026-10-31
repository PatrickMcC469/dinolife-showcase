extends "res://scripts/dinos/base_dino_find_pack.gd"

const FIND_PACK_DATA: Dictionary = {
	"strong": [
		"You find a steady herd moving along a worn trail, calm enough to browse and alert enough to survive.",
		"A strong herd follows the path ahead, their steps steady and their warning calls clear.",
		"You find Iguanodon traveling together in a confident rhythm.",
		"The herd allows you into its path, and the trail immediately feels safer.",
		"You find a group with broad shoulders, steady movement, and enough numbers to matter.",
	],
	"small": [
		"You find a small herd gathered near broad leaves and old tracks.",
		"A few Iguanodon move together along the trail, cautious but not unfriendly.",
		"You find a modest group browsing near ferns, their numbers low but useful.",
		"The herd is small, but shared footsteps are still better than walking alone.",
		"You find a thin herd that watches you carefully before letting you keep pace.",
	],
	"unstable": [
		"You find a herd that keeps splitting into nervous clusters.",
		"The group accepts you, but the trail already feels uncertain.",
		"You find Iguanodon moving together without true rhythm.",
		"Some herd members browse while others keep drifting away.",
		"The herd feels useful, but not steady enough to trust completely.",
	],
	"no_group": [
		"You follow old tracks and half-heard calls, but no herd waits at the end of the trail.",
		"The path shows signs of Iguanodon, but all of them are old.",
		"You search the broad-leaf trail and find only empty ground.",
		"You listen for herd calls, but the forest answers with silence.",
		"The trail continues without the comfort of familiar footsteps.",
	],
}

func get_find_pack_data() -> Dictionary:
	return FIND_PACK_DATA
