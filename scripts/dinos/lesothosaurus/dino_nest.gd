extends "res://scripts/dinos/base_dino_nest.gd"

# Lesothosaurus — nesting phase flavor text

const NEST_DATA: Dictionary = {
	"tend": [
		"You move between the young, making contact with each one. They push back into the group and settle.",
		"A few are straying toward the open grass. You bring them back with small calls and nudges. They listen.",
		"The young are restless after the last scare. You stay visible and keep moving through them. It helps.",
		"One has separated from the others. You coax it back into the huddle. The group tightens.",
		"You spend the morning keeping the young close to cover. They are learning what safe ground looks like.",
		"The young follow your movements carefully. Watching how you read the sounds at the edge of the range.",
	],
	"already_used": [
		"The young are as settled as they can be. Another round through the group won't change what the season has to offer.",
		"They know you and they know the signals. What they carry now, they carry until next season.",
		"You have done what you can for them this season. They are as ready as tending will make them.",
		"More time among them won't build instincts the season hasn't already started to set.",
	],
	"outcome_exceptional": [
		"The young race into independence with sharp ears, quick feet, and steady instincts.",
		"They move like survivors already, alert without being ruled by fear.",
		"The group's lessons stay with them, giving each young life a strong beginning.",
	],
	"outcome_good": [
		"The young leave quicker, calmer, and better at staying near safety.",
		"They know the warning calls now and react with more sense than panic.",
		"Their small bodies are ready for the open grass.",
	],
	"outcome_okay": [
		"The young leave quicker, calmer, and better at staying near safety.",
		"They know the warning calls now and react with more sense than panic.",
		"Their small bodies are ready for the open grass.",
	],
	"outcome_neutral": [
		"The young Lesothosaurus leave with fair speed and uncertain courage.",
		"They are quick enough to try surviving, though fear still rules many choices.",
		"The grass takes them in, and their future depends on every sound they hear.",
	],
	"outcome_poor": [
		"The young leave alive, but jumpy and poorly fed.",
		"They know how to run, but not yet how to choose the right moment.",
		"They move into the grass with weak confidence and fragile bodies.",
	],
	"outcome_failed": [
		"The young scatter into the grass too nervous, too thin, and too quick to panic.",
		"They bolt before they understand the warning signs, vanishing into danger with frightened calls.",
		"Their legs are fast, but fear leads them more than instinct.",
	],
}

func get_nest_data() -> Dictionary:
	return NEST_DATA
