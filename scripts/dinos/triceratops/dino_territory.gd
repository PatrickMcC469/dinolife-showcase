extends "res://scripts/dinos/base_dino_territory.gd"

# strong   → Strong Claim   (+0.10 graze_crit_bonus, +0.08 graze_success_bonus next season)
# useful   → Useful Claim   (+0.05 graze_crit_bonus, +0.04 graze_success_bonus next season)
# contested → Contested Claim (increases mixed/danger chance next season)
# weak     → No Effect

const TERRITORY_DATA: Dictionary = {
	"strong": [
		"The herd fans out across the best low grazing ground and your marks go in at every edge. This patch belongs to the herd, and you lead it.",
		"You push through the center of the richest grazing stretch and mark it from end to end. Nothing else was bold enough to stand in the open here.",
		"The flat is wide and the growth is thick. You walk the full perimeter and leave heavy marks at every approach. A strong claim on excellent ground.",
		"The herd's presence clears the area, and you mark the boundary while the others feed. This ground is yours going into next season.",
		"You find the best undisturbed grazing stretch of the season and mark it before anyone else can. The herd's range is richer for it.",
	],
	"useful": [
		"You mark a solid section of the grazing flat before the herd moves on. Not the best patch, but a real advantage for next season.",
		"The ground here is decent — low plants, open enough to graze safely. Your marks go in at the main approach and hold well.",
		"A useful patch of growth gets marked clearly. The herd will return to this ground, and next season it will start as yours.",
		"You cover the edges of a good mid-range grazing area before the day gets hot. A clean enough claim on useful food.",
		"The patch is not the richest, but it is worth holding. Your marks are fresh and clear at the entry points.",
	],
	"contested": [
		"You find a grazing stretch worth claiming, but a rival herd has already moved through it. The ground carries their mark alongside yours.",
		"The best flat is already being worked by another group. Your marks go in, but the patch will be argued over next season.",
		"The low grazing ground is split between two herds now. Yours and another. Feeding here next season will not come easily.",
		"A rival bull's marks are already pressed into the edge of the ground you wanted. You add your own, but the claim is not clean.",
		"The patch is contested before you can fully establish it. Your marks are there, but so are the signs of a rival presence.",
	],
	"weak": [
		"The grazing ground is too open or too picked-over to hold a meaningful claim. Your marks go in but will not carry.",
		"You walk the edges of a flat that offers little worth claiming. Nothing worth staking this season.",
		"The herd has already spread too thin across the area for any single mark to mean much. The ground answers to no one.",
		"Too much open ground, not enough cover or richness. Your marks fade before they can mean anything next season.",
		"No useful patch presents itself. You leave some trace behind, but there is nothing here worth holding.",
	],
}

func get_territory_data() -> Dictionary:
	return TERRITORY_DATA
