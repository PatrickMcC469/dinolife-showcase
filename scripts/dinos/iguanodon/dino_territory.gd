extends "res://scripts/dinos/base_dino_territory.gd"

# strong   → Strong Claim   (+0.10 graze_crit_bonus, +0.08 graze_success_bonus next season)
# useful   → Useful Claim   (+0.05 graze_crit_bonus, +0.04 graze_success_bonus next season)
# contested → Contested Claim (increases mixed/danger chance next season)
# weak     → No Effect

const TERRITORY_DATA: Dictionary = {
	"strong": [
		"You walk the full length of the browsing corridor and mark every major crossing. The trail is yours. Next season begins there.",
		"The herd path runs through a stretch of rich, undisturbed growth. You mark it thoroughly before the others close in.",
		"You cover the best browsing ground before the season moves on. Clear marks at the entry points. A strong claim on good food.",
		"The trail opens into a broad, sheltered feeding zone. You walk every edge and the marks hold deep in the soft ground.",
		"Your marks go into the bark and soil at the best feeding stretch along the path. The corridor is yours for next season.",
	],
	"useful": [
		"You mark a solid stretch of the browsing path before the light changes. Not the richest ground, but a real claim.",
		"The trail here is decent — wide enough and well-shaded. Your marks are clear and recent. A useful advantage for next season.",
		"You cover the main approaches to a good feeding stretch and leave fresh signs. Someone may challenge it, but the claim holds for now.",
		"A reasonable section of herd path gets your mark. The ground here is worth claiming, even if it is not the best of the season.",
		"You find a mid-range feeding stretch and mark it efficiently. Next season, this stretch will favor you.",
	],
	"contested": [
		"You mark the browsing path, but older signs are already there. A rival herd has been through this corridor recently.",
		"The trail is useful, but the ground carries too many competing marks. Next season, this stretch will be harder to feed from safely.",
		"You find signs of another group along the path you wanted. Your marks go in, but they are not the only ones.",
		"The feeding corridor is split — your marks are there, but so are theirs. Expect to be challenged near this ground next season.",
		"The trail shows recent use by more than one herd. Your mark holds, but the ground will not give itself over easily.",
	],
	"weak": [
		"The trail here is too exposed and too well-traveled to mark effectively. Nothing sticks.",
		"You walk the path but find nothing worth staking. The browsing ground is too thin or too open to hold a meaningful claim.",
		"Your marks go into the path, but the ground here shifts with the herd flow. Nothing carries to next season.",
		"The corridor is too broad and too contested already. Your marks are lost in the noise of other passage.",
		"You find no useful stretch of trail to claim this season. You move through without gaining ground.",
	],
}

func get_territory_data() -> Dictionary:
	return TERRITORY_DATA
