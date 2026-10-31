extends "res://scripts/dinos/base_dino_territory.gd"

# strong   → Strong Claim   (+0.10 graze_crit_bonus, +0.08 graze_success_bonus next season)
# useful   → Useful Claim   (+0.05 graze_crit_bonus, +0.04 graze_success_bonus next season)
# contested → Contested Claim (increases mixed/danger chance next season)
# weak     → No Effect

const TERRITORY_DATA: Dictionary = {
	"strong": [
		"You move quickly through the low grass and mark every edge of a rich feeding stretch. Nothing larger has crossed it recently. The ground is yours.",
		"A hidden network of fresh shoots sits tucked between roots. You cover the full perimeter before anything notices you. The claim is clean.",
		"The feeding patch is sheltered and rich. You move fast enough to mark it thoroughly before the day changes. It will remember your scent.",
		"You find a stretch of ground the others have missed. Quick marks at every entrance. Next season, this patch answers to you first.",
		"The grass here is thick and undisturbed. Your marks go into dry earth at the edges, and the area holds them well.",
	],
	"useful": [
		"The patch is decent — not the best, but marked well enough to hold for another season.",
		"You move through the grass quickly and leave clear signs at the main approaches. Something may contest it, but the claim is real.",
		"A small feeding stretch sits at the edge of cover. You mark the edges before moving on. A reasonable gain.",
		"The ground here is average, but the marks are fresh. Next season begins with that small advantage.",
		"You find the patch already thinned by the season but mark it before anyone else does. The ground acknowledges it.",
	],
	"contested": [
		"You find a patch worth claiming, but another has already marked the edges. The ground belongs to both of you, and that means neither.",
		"Your marks layer over older ones. Something else has been using this stretch of grass. Next season, the food will be harder to reach here.",
		"The feeding path is useful, but the signs are mixed — you are not the only one who found it this season.",
		"You leave your marks, but a rival has done the same recently. Neither claim is clean. Expect trouble near this ground.",
		"The grass is shared whether you want it or not. Your marks are there, but so are theirs. Nothing here will come easily.",
	],
	"weak": [
		"You move through the area but find no patch worth staking. Your marks go unread in dry, hard ground.",
		"The grass is too open and the ground too bare. Nothing holds a mark here for long.",
		"You mark what you can, but the area shifts too quickly to mean anything by next season.",
		"No useful patch presents itself. You leave some trace, but it will not carry.",
		"The ground here is too exposed or already too stripped to stake a real claim. You leave without gaining anything from it.",
	],
}

func get_territory_data() -> Dictionary:
	return TERRITORY_DATA
