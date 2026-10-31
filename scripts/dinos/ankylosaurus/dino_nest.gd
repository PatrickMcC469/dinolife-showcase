extends "res://scripts/dinos/base_dino_nest.gd"

# Ankylosaurus — nesting phase flavor text

const NEST_DATA: Dictionary = {
	"tend": [
		"You move close to the young and stay there. Sometimes presence is the whole lesson.",
		"A calf has stayed exposed on open ground too long. You push it gently back into the low cover.",
		"You lie flat near the young and let them practice pressing low beside you. They are learning the stillness.",
		"You circle the young slowly, checking for anything that has approached while you weren't watching. Nothing has.",
		"The young are restless. You hold your position and wait. They eventually press in beside you and go quiet.",
		"One of the young is tail-swinging recklessly near the others. You move between them calmly. It settles.",
	],
	"already_used": [
		"The young know where to press low and when to stay still. Another circle changes nothing.",
		"They have learned what stillness looks like by watching you hold it. This season's lessons are set.",
		"More time close to them won't improve what the season has already settled in their habits.",
		"The young have what they need from tending. Patience does the rest now.",
	],
	"outcome_exceptional": [
		"The young leave like little living stones, sturdy, calm, and difficult to trouble.",
		"They have learned to stay low, feed well, and endure the season's pressure.",
		"Their armor, bodies, and instincts all show the strength of a careful start.",
	],
	"outcome_good": [
		"The young leave heavier, calmer, and better at tucking down when danger passes.",
		"Their armor is still growing, but their instincts are stronger now.",
		"They move into the world with patient steps and a better sense of defense.",
	],
	"outcome_okay": [
		"The young leave heavier, calmer, and better at tucking down when danger passes.",
		"Their armor is still growing, but their instincts are stronger now.",
		"They move into the world with patient steps and a better sense of defense.",
	],
	"outcome_neutral": [
		"The young Ankylosaurus leave steady enough to try, though still clumsy and soft-plated.",
		"They move low to the ground, cautious but not fully prepared.",
		"Their future is slow, stubborn, and uncertain.",
	],
	"outcome_poor": [
		"The young survive to leave, but their armor feels too soft for the world ahead.",
		"They know how to stay low, but not always when it matters.",
		"Their first season alone begins with tired steps and thin strength.",
	],
	"outcome_failed": [
		"The young leave cover weak beneath their soft armor, restless when they should be still.",
		"Their bodies are built to endure, but their start has left them too fragile.",
		"They shuffle into independence hungry, poorly braced, and slow to understand danger.",
	],
}

func get_nest_data() -> Dictionary:
	return NEST_DATA
