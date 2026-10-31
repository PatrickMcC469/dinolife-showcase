extends "res://scripts/dinos/base_dino_water.gd"

const WATER_DATA: Dictionary = {
	"clean": [
		"You find a cold stream running through the ferns and drink while watching the brush.",
		"Clear rainwater waits in a stone basin, clean enough for a steady drink.",
		"You lower your head to a quiet pool and drink with your claws planted.",
	],
	"muddy": [
		"A trampled hollow holds muddy water, but it is enough to keep you moving.",
		"You drink from a shallow pool marked by prey tracks and churned earth.",
		"Mud clouds the water, but you drink before the trail goes cold.",
	],
	"risky": [
		"You find water near fresh predator scent and drink without lowering your guard.",
		"The reeds shift nearby as you drink, but nothing comes close enough to start a fight.",
		"The water tastes stale, but you take what you need and leave quickly.",
	],
	"danger": [
		"You drink from a muddy stream, but something small snaps from the reeds and catches your leg before disappearing.",
		"You lower your head at the waterline, but a hidden jaw clips your snout and slips back into the mud.",
		"You find a drinkable pool, but sharp stones cut your foot as you step away.",
		"You drink enough to recover, but a swarm of biting insects drives you from the bank.",
		"You reach water beneath thick ferns, but something unseen claws your ankle and vanishes.",
		"You drink from a shaded pool, but the mud gives way and strains your leg before you pull free.",
		"You lap at a stream crossing, but a startled fish thrashes hard against your face.",
		"You find water, but another predator's scent makes you leave before drinking your fill.",
	],
	"dry": [
		"You follow old water trails through the ferns, but each one ends in dry mud.",
		"Every scent of water has faded beneath dust, tracks, and heat.",
		"You search the streambeds, but the season has emptied them.",
	],
}

func get_water_data() -> Dictionary:
	return WATER_DATA
