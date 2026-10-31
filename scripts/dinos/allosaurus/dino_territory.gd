extends "res://scripts/dinos/base_dino_territory.gd"

const TERRITORY_DATA: Dictionary = {
	"strong": [
		"You score trees, drag scent through the brush, and make the forest remember you.",
		"Your heavy markings turn the trail into a warning for smaller hunters.",
		"The territory feels claimed by weight, teeth, and confidence.",
		"You leave deep claw marks where prey trails cross.",
		"Your scent hangs thick near the treeline, bold enough to make rivals cautious.",
		"Broken branches and gouged bark announce your presence clearly.",
		"You mark the area like a predator that expects to be obeyed.",
		"The forest feels less crowded after your claim settles.",
		"Your warning signs carry through the brush with heavy authority.",
		"The hunting ground feels like it belongs to your jaws.",
	],
	"useful": [
		"You mark the main trail and leave clear scent near the brushline.",
		"Your scratches hold well enough to guide your next patrol.",
		"The area feels more familiar after your heavy-footed circuit.",
		"You leave a solid claim across the nearby hunting path.",
		"Your marks are plain, strong, and useful.",
		"You claim enough ground to make the next hunt feel more controlled.",
		"Your scent settles near the places prey already passes.",
		"You mark a few trees and move on before wasting energy.",
		"The territory does not feel dominated, but it feels workable.",
		"Your claim is not impressive, but it should hold for now.",
	],
	"contested": [
		"Another large predator has marked the same trail.",
		"Fresh claw marks cut across yours at shoulder height.",
		"A rival scent hangs near the treeline, strong and recent.",
		"The forest carries a low warning that you are not alone.",
		"Something heavy moved through here before you.",
		"Your claim meets another predator's claim and neither gives way.",
		"You find gouged bark that was not made by your claws.",
		"The scent of a rival Allosaurus lingers near the prey path.",
		"The area feels valuable enough that something else wants it.",
		"You mark the ground, but another hunter has already answered.",
	],
	"weak": [
		"Rain dulls your scent before it can settle.",
		"Your claw marks splinter badly and lose their shape.",
		"The trail is too trampled for your claim to stand out.",
		"Your scent fades beneath mud and old blood.",
		"The forest feels unchanged after your patrol.",
		"You mark the area, but the warning does not carry.",
		"Your claim feels scattered and incomplete.",
		"The brush swallows your signs before they matter.",
		"You leave marks, but they lack weight.",
		"The territory remains wild, busy, and unconvinced.",
	],
}

func get_territory_data() -> Dictionary:
	return TERRITORY_DATA
