extends RefCounted

const STORIES = {
	"compsognathus": {"title": "Room beneath the log", "intro": "%s waits beside a fallen log where the %s is settling. You reached the dry hollow first. Clearing the leaves would make room for two, but the work will use some of your reserves.", "result": "%s slips beneath the log beside you. The leaves rustle as you both settle, sheltered from the weather."},
	"deinonychus": {"title": "The sheltered hunting line", "intro": "%s reaches a rocky ledge as the %s spreads through the brush. You have a place out of the wind. You could clear a second spot, point them toward another ledge, or keep this cover to yourself.", "result": "%s rests beside you beneath the ledge. With room for two, your hunting partner can finally settle out of the wind."},
	"velociraptor": {"title": "A place out of the wind", "intro": "%s follows the %s toward a sheltered bank after the hunt. You rest behind the roots, out of the wind. Clearing another place takes energy, but there is room if you make the effort.", "result": "%s curls into the space you cleared beside the bank. A quiet answering call comes from close by."},
	"lesothosaurus": {"title": "Lookout's shelter", "intro": "%s waits beyond the ferns as the %s settles. You found the thickest cover. You could clear a place beside you, show them another sheltered patch, or keep this one to yourself.", "result": "%s slips beneath the ferns beside you. The leaves close around both of you, hiding you from passing eyes."},
	"iguanodon": {"title": "A resting place for two", "intro": "%s reaches the trees as the %s slows to rest. You found a sheltered patch first. Clearing the undergrowth would make room for them, though the work will draw on your food reserves.", "result": "%s rests in the space you cleared beneath the trees. Their familiar shape stays close as the herd settles."},
	"triceratops": {"title": "Inside the resting circle", "intro": "%s waits at the exposed edge as the %s settles into a resting circle. You have a place sheltered by the others. Shifting the circle takes energy, but it could bring your companion inside.", "result": "%s steps into the resting circle beside you. The herd shifts around the space you made, closing the gap behind them."},
	"argentinosaurus": {"title": "Room in the lee", "intro": "%s slows beside the ridge where the %s rests. You have found a place out of the wind. Moving the fallen branches and shifting aside would make room for them, at a cost to your food reserves.", "result": "%s settles beside the ridge in the space you cleared. Their low rumble answers yours from close by."},
}


static func story() -> Dictionary:
	var data: Dictionary = STORIES[GameState.species_id].duplicate()
	var condition := ""
	match GameState.current_season:
		0: condition = "Wet leaves and dripping ground make a dry resting place valuable."
		1: condition = "The dry season's heat makes sheltered rest valuable."
		2: condition = "The busy breeding season leaves little quiet room to rest."
		3: condition = "Cold wind crosses the range; sheltered rest matters tonight."
	data["intro"] = condition + "\n\n" + str(data["intro"])
	return data
