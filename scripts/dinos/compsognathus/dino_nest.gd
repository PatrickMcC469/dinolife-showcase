extends "res://scripts/dinos/base_dino_nest.gd"

# Compsognathus — nesting phase flavor text

const NEST_DATA: Dictionary = {
	"tend": [
		"You lead the young through a familiar stretch of roots and let them practice following your footsteps exactly.",
		"A few of the young are chasing insects too far from the group. You chirp once. They come back.",
		"You pick through the leaf litter beside the hatchlings, turning over anything that moves. They learn what is worth chasing.",
		"One hatchling is getting pushed by the others. You move between them briefly. The group settles.",
		"You check the familiar hollows in the roots — the hiding spots. Each one still fits the young perfectly.",
		"The young trail behind you in a loose cluster, matching your pace through the undergrowth.",
	],
	"already_used": [
		"You have led them through the paths, called them back, shown them the hiding spots. They know the roots now.",
		"The young have your lessons. More chirping won't add to what this season has already given them.",
		"They know the paths, the signals, and the hollows. Another pass through the undergrowth changes nothing.",
		"The season's teaching is finished. What the young carry into the ferns, they already have.",
	],
	"outcome_exceptional": [
		"The young move like tiny shadows, quiet, quick, and clever enough to survive the green world.",
		"They leave the nest strong, alert, and already working together in little bursts of chirps and motion.",
		"Every hatchling seems ready for life beyond the roots, carrying your care into the wild.",
	],
	"outcome_good": [
		"The young compies leave with sharp chirps, quick steps, and enough sense to hide before danger sees them.",
		"They vanish into the root tunnels with good speed and better instincts than most.",
		"The hatchlings are ready. Small, fast, and careful, they begin their own lives.",
	],
	"outcome_okay": [
		"The young compies leave with sharp chirps, quick steps, and enough sense to hide before danger sees them.",
		"They vanish into the root tunnels with good speed and better instincts than most.",
		"The hatchlings are ready. Small, fast, and careful, they begin their own lives.",
	],
	"outcome_neutral": [
		"The young compies leave the nest with quick feet and uncertain instincts. They may survive, if the ferns are kind.",
		"They scatter into the undergrowth, neither weak nor strong, just ready enough to try.",
		"The little group breaks apart into separate paths, each hatchling carrying a fair chance.",
	],
	"outcome_poor": [
		"The young survive to independence, but they leave nervous, thin, and poorly prepared.",
		"They dart away from the old root paths with more fear than skill.",
		"A few have learned enough to move on, but their start into life is fragile.",
	],
	"outcome_failed": [
		"The young compies scatter into the ferns too thin, too hungry, and too loud. Some vanish before they ever find their own safe paths.",
		"The hatchlings are old enough to leave, but not strong enough to thrive. Their tiny chirps fade quickly beneath the leaves.",
		"They leave the nest in panic, each one running alone into a world that notices small mistakes.",
	],
}

func get_nest_data() -> Dictionary:
	return NEST_DATA
