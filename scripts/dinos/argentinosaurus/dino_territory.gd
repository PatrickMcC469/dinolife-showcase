extends "res://scripts/dinos/base_dino_territory.gd"

# strong   → Strong Claim   (+0.10 graze_crit_bonus, +0.08 graze_success_bonus next season)
# useful   → Useful Claim   (+0.05 graze_crit_bonus, +0.04 graze_success_bonus next season)
# contested → Contested Claim (increases mixed/danger chance next season)
# weak     → No Effect

const TERRITORY_DATA: Dictionary = {
	"strong": [
		"The herd moves through a grove heavy with tall growth and your presence marks it completely. Nothing else has a claim here worth reading.",
		"You walk the full edge of a canopy-rich browsing zone and leave heavy signs at every approach. The grove belongs to the herd, and you led the claim.",
		"The tallest, richest browsing stretch of the season sits unmarked. The herd settles in and you establish the perimeter fully. A strong gain.",
		"You push the herd through a wide stretch of untouched tall growth and mark the boundaries from one end to the other. Clean and complete.",
		"The grove is dense and full of reachable growth. The herd's presence is enough to clear it, and your marks make the claim official.",
	],
	"useful": [
		"You mark a solid section of the browsing zone before the herd moves on. Not the richest canopy, but a real claim on useful food.",
		"The tall growth here is decent and within reach. Your marks are clear at the main approach. A useful advantage for next season.",
		"A reasonable stretch of canopy gets marked efficiently. The herd will return here, and next season it starts as yours.",
		"You cover the edges of a mid-range browsing area before the day moves. The claim is clean enough to hold.",
		"The grove is average but worth holding. Your marks go into the bark and soft ground at the entry points.",
	],
	"contested": [
		"The grove is worth claiming, but a rival herd has already moved through it. The marks are layered and the claim is unclear.",
		"You find a browsing zone already marked by another sauropod group. Your marks go in alongside theirs, but the ground is split.",
		"The best tall growth of the area is already being contested by another herd. Next season, this grove will not give itself over easily.",
		"A rival giant's marks are pressed into the grove entrance before yours. You add your own, but the claim has no clean winner.",
		"The browsing zone is shared now — your marks and theirs sit in the same ground. Feeding here next season will require caution.",
	],
	"weak": [
		"The grove is too sparse or too exposed to hold a claim that means anything. The marks go in, but nothing carries.",
		"The canopy here is too thin or too picked-over to stake meaningful ground. The herd moves through without gaining territory.",
		"You find no rich browsing zone worth claiming this season. The area offers nothing worth returning to.",
		"The ground is too vast and the growth too scattered. No single mark anchors the claim here.",
		"Your marks are too light for ground this open. Nothing holds next season. You move on without gaining anything.",
	],
}

func get_territory_data() -> Dictionary:
	return TERRITORY_DATA
