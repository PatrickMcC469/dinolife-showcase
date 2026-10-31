extends "res://scripts/dinos/base_dino_territory.gd"

# strong   → Strong Claim   (+0.10 graze_crit_bonus, +0.08 graze_success_bonus next season)
# useful   → Useful Claim   (+0.05 graze_crit_bonus, +0.04 graze_success_bonus next season)
# contested → Contested Claim (increases mixed/danger chance next season)
# weak     → No Effect

const TERRITORY_DATA: Dictionary = {
	"strong": [
		"You work the full perimeter of a rich low-cover feeding area at your own pace. The marks are deep and recent. This ground is yours.",
		"A wide stretch of useful plants sits sheltered between stone and shadow. You cover every edge and the claim settles in well.",
		"The feeding zone is thick with good low growth and well protected. You mark every entrance and leave nothing unclear.",
		"You find a strong patch of covered ground and mark it thoroughly before moving on. Next season, this area recognizes you first.",
		"The best sheltered feeding stretch of the season sits quiet and unclaimed. You take your time and mark it completely. A solid gain.",
	],
	"useful": [
		"The patch is decent — sheltered enough and worth holding. Your marks are clear at the main approach.",
		"You mark a solid section of covered ground before the day moves on. A useful claim on food worth returning to.",
		"The feeding area here is average but sheltered. Your marks go into the soft earth at the edge and hold.",
		"A reasonable patch of low-cover growth gets marked cleanly. Next season starts with this advantage.",
		"You find a mid-range feeding stretch near stone cover and mark the edges. Not rich, but a real claim.",
	],
	"contested": [
		"You find a sheltered feeding patch worth claiming, but a rival has already marked the perimeter. Both claims are there, and neither is clean.",
		"The low-cover ground is split — your marks layer over another's. This area will not give itself over easily next season.",
		"A rival ankylosaurus has been through this patch recently. Your marks go in, but the ground remembers both of you.",
		"The feeding area carries too many competing signs. You mark it, but next season the food will be contested from the start.",
		"Your marks are there, but so are theirs. The sheltered ground is shared now, and it will show in the feeding.",
	],
	"weak": [
		"You move through the area slowly but find nothing worth staking. The ground is too open or already too stripped.",
		"The feeding patch here is too exposed to hold a mark that means anything next season.",
		"You mark what you can, but the ground is hard and the area too uncertain. Nothing carries.",
		"No useful covered patch presents itself. You move on without gaining anything from the search.",
		"The area offers no sheltered ground worth claiming this season. Your marks go into empty earth.",
	],
}

func get_territory_data() -> Dictionary:
	return TERRITORY_DATA
