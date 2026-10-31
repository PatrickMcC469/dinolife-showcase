extends "res://scripts/dinos/base_dino_territory.gd"

const TERRITORY_DATA: Dictionary = {
	"strong": [
		"Deep tracks, crushed brush, and heavy scent turn the trail into a warning.",
		"You mark the territory so clearly that the forest seems quieter afterward.",
		"Your claim settles over the area like a shadow with teeth.",
		"Every broken branch says something massive passed here and may return.",
		"Your scent hangs heavy enough to make smaller predators vanish.",
		"The hunting ground feels claimed by weight, hunger, and jaws.",
		"You leave a trail of pressure the whole area seems to understand.",
		"Your markings make the forest feel smaller around you.",
		"The ground itself holds the memory of your passage.",
		"Anything crossing this trail will know a tyrant walks here.",
	],
	"useful": [
		"You leave heavy tracks and scent along a promising prey path.",
		"Your claim is clear enough to help you read the area next season.",
		"The brush carries your scent well enough for now.",
		"You mark the trail without wasting too much energy.",
		"The territory feels more familiar beneath your feet.",
		"Your signs settle across the clearing and nearby trees.",
		"You claim the ground in a simple, direct way.",
		"Your scent lingers where prey movement is strongest.",
		"The area does not feel ruled, but it feels noticed.",
		"You leave enough warning that smaller hunters may avoid the trail.",
	],
	"contested": [
		"Another tyrannosaur's scent cuts through the clearing.",
		"Deep rival tracks cross the trail ahead.",
		"A scarred tree shows bite marks that are not yours.",
		"The air carries a heavy warning from another large predator.",
		"Something big has already claimed part of this ground.",
		"Your markings meet a rival's scent and the forest feels tense.",
		"You find crushed brush from another massive body.",
		"The territory smells of prey, but also competition.",
		"A distant rumble answers your presence from beyond the trees.",
		"This claim may hold, but something powerful knows you are here.",
	],
	"weak": [
		"Rain washes your scent into the mud.",
		"The wind carries your warning away from the trail.",
		"Your tracks vanish in churned ground and broken leaves.",
		"The territory feels too open for your claim to settle.",
		"Your scent fades faster than it should.",
		"The forest does not quiet after your patrol.",
		"You mark the trail, but the warning feels thin.",
		"Your claim scatters across too much ground.",
		"The signs you leave do not feel strong enough to matter.",
		"The area remains unclaimed, restless, and full of competing scents.",
	],
}

func get_territory_data() -> Dictionary:
	return TERRITORY_DATA
