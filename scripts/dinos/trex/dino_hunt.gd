extends "res://scripts/dinos/base_dino_hunt.gd"

const CRITS: Array = [
	{
		"flavor": "A young herbivore lowers its head near the edge of the trees, unaware of the heavy shape moving behind the brush.\n\nYou wait until it turns sideways.\n\nThen you surge forward.\n\nYour jaws close with terrible force, and the hunt ends before the prey can truly fight back.",
		"result": "You bring down prey with one decisive bite.",
		"button": "End it with teeth.",
		"hunger_gain": 0.72,
	},
	{
		"flavor": "The wind carries a warm animal scent through the ferns. You follow it slowly, each step careful, each breath narrowing the world down to one thing.\n\nThe prey never sees you.\n\nIt only hears the final rush.",
		"result": "You track prey perfectly by scent and strike cleanly.",
		"button": "Follow the scent.",
		"hunger_gain": 0.70,
	},
	{
		"flavor": "A small group of prey animals notices you too late and scatters. Most run together.\n\nOne panics.\n\nIt breaks away alone, sprinting into open ground with no cover and no herd beside it.\n\nYou do not chase the group.\n\nYou take the mistake.",
		"result": "You isolate panicked prey and win quickly.",
		"button": "Fear chose for me.",
		"hunger_gain": 0.72,
	},
	{
		"flavor": "You stand hidden behind thick trees as a young animal steps closer, feeding without looking up.\n\nYou do not move until it is too late.\n\nOne heavy step shakes the ground. The prey freezes.\n\nThe second step is the last thing it understands.",
		"result": "You use stillness and sudden power for a clean kill.",
		"button": "Let the ground warn them.",
		"hunger_gain": 0.75,
	},
	{
		"flavor": "Your prey bolts across uneven ground, fast but frightened. It looks back instead of watching its feet.\n\nThat is the mistake.\n\nIts body twists into a bad turn, and you are already closing from the side.",
		"result": "You punish a fleeing prey's mistake.",
		"button": "Never look back.",
		"hunger_gain": 0.70,
	},
	{
		"flavor": "A sturdy prey animal tries to shove past you, trusting its weight to carry it clear.\n\nIt almost works.\n\nThen your jaws find the shoulder.\n\nThe struggle becomes a stumble, the stumble becomes a fall, and the hunt is yours.",
		"result": "You overpower prey with crushing bite force.",
		"button": "Break its strength.",
		"hunger_gain": 0.75,
	},
	{
		"flavor": "A fleeing animal runs along the riverbank, trapped between deep water and tangled roots.\n\nYou do not waste energy chasing straight behind it.\n\nYou cut across the bend, arrive first, and wait with your jaws open.",
		"result": "You predict the escape path and intercept prey.",
		"button": "Meet it at the bend.",
		"hunger_gain": 0.72,
	},
	{
		"flavor": "For something your size, you should not be able to move this quietly.\n\nBut the forest is damp, the wind is right, and your prey is careless.\n\nYou close the distance step by step until there is no distance left.",
		"result": "You complete a flawless close-range stalk.",
		"button": "Too late to run.",
		"hunger_gain": 0.75,
	},
	{
		"flavor": "A defensive herbivore turns its horns and shoulders toward you, expecting a head-on attack.\n\nYou shift your weight, forcing it to guard the wrong angle.\n\nWhen it commits, you move around the side and strike where it cannot turn fast enough.",
		"result": "You bait a defensive prey into exposing itself.",
		"button": "Wrong side.",
		"hunger_gain": 0.72,
	},
	{
		"flavor": "A slower animal falls behind the herd, breathing hard and stumbling over broken ground.\n\nThe others keep moving.\n\nYou do not rush. You do not need to.\n\nYou close in with steady, terrible patience.",
		"result": "You catch a weakened straggler cleanly.",
		"button": "The herd left you.",
		"hunger_gain": 0.68,
	},
	{
		"flavor": "A young prey animal steps into a clearing, ears twitching at distant sounds.\n\nIt is listening in the wrong direction.\n\nYou erupt from the trees behind it, every step shaking loose leaves from the branches.",
		"result": "You launch a perfect surprise charge.",
		"button": "Come out of nowhere.",
		"hunger_gain": 0.75,
	},
	{
		"flavor": "Your prey sees you.\n\nFor one heartbeat, it does not run. Its body locks in pure animal fear.\n\nThat heartbeat is all a T-Rex needs.\n\nYou cross the distance before instinct returns.",
		"result": "You exploit fear and end the hunt instantly.",
		"button": "Fear is slow.",
		"hunger_gain": 0.78,
	},
]


func get_crit_event() -> Dictionary:
	return CRITS[randi() % CRITS.size()]


const ENCOUNTERS: Array = [
	{
		"flavor": "A young hadrosaur feeds near the edge of a clearing, far enough from the herd to tempt you. It lifts its head as your scent reaches it, body tensing.\n\nIt is fast.\n\nYou are stronger.\n\nThe hunt will be decided in the first rush.",
		"button_fight": "Rush before it bolts.",
		"sublabel_fight": "First hit decides this",
		"button_leave": "Wait for better prey.",
		"sublabel_leave": "A chase may not be worth it",
		"prey": { "name": "a young hadrosaur", "fight_power": 0.32, "hunger_value": 0.72, "size": 5 },
	},
	{
		"flavor": "An adult hadrosaur stands knee-deep in ferns, chewing slowly. It is not armed with horns or armor, but its body is heavy, its legs are powerful, and panic can turn it into a living battering ram.\n\nA good bite could end this.\n\nA bad approach could leave you chasing pain.",
		"button_fight": "Close and hold.",
		"sublabel_fight": "Don't let it build momentum",
		"button_leave": "Conserve your energy.",
		"sublabel_leave": "That body mass means trouble",
		"prey": { "name": "an adult hadrosaur", "fight_power": 0.45, "hunger_value": 0.82, "size": 6 },
	},
	{
		"flavor": "A Triceratops calf has wandered beyond the safest edge of the herd. Its horns are still small, but it lowers its head when it sees you.\n\nThe calf is vulnerable.\n\nThe herd is close.\n\nIf you strike, you need to finish before the adults answer.",
		"button_fight": "Strike fast.",
		"sublabel_fight": "Silence it before the herd hears",
		"button_leave": "Retreat before the herd turns.",
		"sublabel_leave": "Adults are too close",
		"prey": { "name": "a stray Triceratops calf", "fight_power": 0.48, "hunger_value": 0.75, "size": 6 },
	},
	{
		"flavor": "A young Triceratops stands alone near a muddy slope, broad frill facing you. Its horns are not full-grown, but they are long enough to matter.\n\nIt paws the ground once.\n\nThis meal has points.",
		"button_fight": "Get past the horns.",
		"sublabel_fight": "Time the angle carefully",
		"button_leave": "Avoid the points.",
		"sublabel_leave": "Those horns are long enough",
		"prey": { "name": "a young Triceratops", "fight_power": 0.55, "hunger_value": 0.80, "size": 7 },
	},
	{
		"flavor": "An adult Triceratops turns to face you, lowering its horns with calm certainty. It does not run. It does not panic.\n\nIt waits.\n\nThere is a mountain of meat in front of you.\n\nThere is also a wall of bone.",
		"button_fight": "Take the fight.",
		"sublabel_fight": "Force it to commit first",
		"button_leave": "Back away.",
		"sublabel_leave": "That wall does not move for anything",
		"prey": { "name": "a defensive adult Triceratops", "fight_power": 0.75, "hunger_value": 0.88, "size": 8 },
	},
	{
		"flavor": "A wounded Ankylosaurus shuffles through the brush, one leg dragging slightly. Its armor is thick, but its movement is slow and uneven.\n\nThen its tail swings once through the grass.\n\nWounded does not mean safe.",
		"button_fight": "Press through the armor.",
		"sublabel_fight": "Find the gap while it is slow",
		"button_leave": "Look for softer meat.",
		"sublabel_leave": "That tail still reaches",
		"prey": { "name": "a wounded Ankylosaurus", "fight_power": 0.55, "hunger_value": 0.80, "size": 7 },
	},
	{
		"flavor": "An adult Ankylosaurus lowers itself near a patch of tough plants, armored back turned toward you. It sees you. It does not flee.\n\nIts tail club shifts slowly from side to side.\n\nEvery bite must get past the armor.\n\nEvery mistake invites the tail.",
		"button_fight": "Find the gap.",
		"sublabel_fight": "One wrong step and that tail finds you",
		"button_leave": "Leave the walking fortress alone.",
		"sublabel_leave": "Not worth the tail club",
		"prey": { "name": "an adult Ankylosaurus", "fight_power": 0.72, "hunger_value": 0.82, "size": 7 },
	},
	{
		"flavor": "A juvenile Edmontosaurus drinks from a shallow stream, separated from the others by a stand of trees. It notices you late and stumbles backward, water splashing around its legs.\n\nIf it reaches open ground, the chase begins.\n\nIf you reach it first, the meal is yours.",
		"button_fight": "Reach it before it runs.",
		"sublabel_fight": "The water slows it for now",
		"button_leave": "Hold position.",
		"sublabel_leave": "Let it settle before deciding",
		"prey": { "name": "a juvenile Edmontosaurus", "fight_power": 0.35, "hunger_value": 0.72, "size": 5 },
	},
	{
		"flavor": "A large Edmontosaurus bull stands broadside in the clearing, scarred from older attacks. It sees you and swings its heavy body toward the herd path.\n\nThis is a lot of meat.\n\nThis is also a lot of muscle.\n\nIf it runs, it may be hard to stop.",
		"button_fight": "Close before it builds speed.",
		"sublabel_fight": "Don't let it get into a full run",
		"button_leave": "Save your energy.",
		"sublabel_leave": "A running bull is a long chase",
		"prey": { "name": "a bull Edmontosaurus", "fight_power": 0.55, "hunger_value": 0.85, "size": 7 },
	},
	{
		"flavor": "A dome-headed herbivore steps from between the trees and lowers its skull. It does not look big enough to scare you.\n\nThen it charges a nearby trunk and cracks bark from the wood.\n\nMaybe not scary.\n\nDefinitely painful.",
		"button_fight": "Close before it charges.",
		"sublabel_fight": "Don't give it running room",
		"button_leave": "Avoid the headache.",
		"sublabel_leave": "That skull is built for exactly this",
		"prey": { "name": "a Pachycephalosaurus challenger", "fight_power": 0.45, "hunger_value": 0.68, "size": 5 },
	},
	{
		"flavor": "Another young tyrannosaur appears near the same prey trail, head low and jaws slightly open. It smells hungry.\n\nSo do you.\n\nNeither of you wants to leave first.",
		"button_fight": "Fight for the ground.",
		"sublabel_fight": "Establish dominance now",
		"button_leave": "Back down.",
		"sublabel_leave": "A tyrannosaur fight leaves marks",
		"prey": { "name": "a juvenile tyrannosaur rival", "fight_power": 0.58, "hunger_value": 0.75, "size": 7 },
	},
	{
		"flavor": "A larger tyrannosaur stands over the trail ahead, watching you with still, terrible patience. Its scars say it has survived fights you have not.\n\nThis is not prey.\n\nThis is a decision.",
		"button_fight": "Take the fight.",
		"sublabel_fight": "One of you leaves injured",
		"button_leave": "Retreat.",
		"sublabel_leave": "Those scars mean it has done this before",
		"prey": { "name": "an adult tyrannosaur rival", "fight_power": 0.80, "hunger_value": 0.78, "size": 8 },
	},
	{
		"flavor": "A group of feathered hunters scatter through the brush around you, chirping sharply. One alone would not worry you.\n\nSeveral together are different.\n\nThey are too small to be your meal easily and too smart to stand still.",
		"button_fight": "Drive them off.",
		"sublabel_fight": "Make it too costly to continue",
		"button_leave": "Leave the area.",
		"sublabel_leave": "Harassment adds up fast",
		"prey": { "name": "a dromaeosaur pack", "fight_power": 0.58, "hunger_value": 0.65, "size": 6 },
	},
	{
		"flavor": "A large crocodyliform lies half-hidden at the river's edge, jaws resting just above the water. It watches you with ancient patience.\n\nThe river smells like meat, mud, and danger.\n\nIf you fight here, the water will not be neutral.",
		"button_fight": "Fight on the bank.",
		"sublabel_fight": "Stay out of the water",
		"button_leave": "Stay away from the bank.",
		"sublabel_leave": "That water changes everything",
		"prey": { "name": "a river crocodyliform", "fight_power": 0.68, "hunger_value": 0.65, "size": 6 },
	},
	{
		"flavor": "A large horned herbivore lingers behind its group, breathing heavily. Its frill is scarred, and its steps are slow.\n\nBut when it sees you, it lowers its horns.\n\nEven sick prey can decide to make the last fight expensive.",
		"button_fight": "Press through the defense.",
		"sublabel_fight": "Sick does not mean safe",
		"button_leave": "Avoid the horns.",
		"sublabel_leave": "Desperate prey fights hardest",
		"prey": { "name": "a sickly Torosaurus", "fight_power": 0.52, "hunger_value": 0.85, "size": 7 },
	},
]


func get_encounters() -> Array:
	return ENCOUNTERS


const MIXED_ENCOUNTERS: Array = [
	{
		"flavor": "You push through the trees toward a young hadrosaur feeding near the clearing edge.\n\nIt smells you before you strike.\n\nThe hadrosaur screams, twists, and kicks with both back legs as you close in. The ambush is gone. Now it is teeth against panic.",
		"combat_start": "The hadrosaur kicks wildly as combat begins.",
		"button_fight": "Push through the kick.",
		"sublabel_fight": "Don't let panic give it distance",
		"button_leave": "Let the scream carry it clear.",
		"sublabel_leave": "The ambush is already broken",
		"prey": { "name": "a young hadrosaur", "fight_power": 0.32, "hunger_value": 0.72, "size": 5 },
	},
	{
		"flavor": "An adult hadrosaur stands broadside in the ferns, chewing slowly.\n\nYou step from cover.\n\nInstead of fleeing, it surges sideways with its full weight, slamming toward you like a living wall. The hunt starts with impact.",
		"combat_start": "The hadrosaur body-slams forward in panic.",
		"button_fight": "Brace and hold.",
		"sublabel_fight": "Meet the weight before it builds speed",
		"button_leave": "Clear the path.",
		"sublabel_leave": "That body mass has real force behind it",
		"prey": { "name": "an adult hadrosaur", "fight_power": 0.45, "hunger_value": 0.82, "size": 6 },
	},
	{
		"flavor": "A Triceratops calf wanders too far from the herd. You move in, heavy feet quiet against soft ground.\n\nThen the calf sees you.\n\nIt cries out and charges in panic, tiny horns lowered. Behind it, the herd begins to shift.",
		"combat_start": "The calf charges before the herd can answer.",
		"button_fight": "End it before the herd arrives.",
		"sublabel_fight": "Fast or not at all",
		"button_leave": "Back off while you still can.",
		"sublabel_leave": "The herd is already moving",
		"prey": { "name": "a stray Triceratops calf", "fight_power": 0.48, "hunger_value": 0.75, "size": 6 },
	},
	{
		"flavor": "A young Triceratops stands alone near a muddy slope. You circle through the brush, looking for its flank.\n\nIt turns before you get there.\n\nThe frill faces you. The horns lower. The charge comes first.",
		"combat_start": "The young Triceratops charges with lowered horns.",
		"button_fight": "Get past the horns.",
		"sublabel_fight": "Time the angle before they reach you",
		"button_leave": "Retreat from the charge.",
		"sublabel_leave": "It took the flank before you did",
		"prey": { "name": "a young Triceratops", "fight_power": 0.55, "hunger_value": 0.80, "size": 7 },
	},
	{
		"flavor": "An adult Triceratops feeds at the edge of a clearing. You step closer, expecting it to move.\n\nIt does not.\n\nIt plants its feet, lowers its horns, and drives forward with the calm certainty of something that has survived predators before.",
		"combat_start": "The Triceratops meets you head-on.",
		"button_fight": "Take the fight.",
		"sublabel_fight": "Force it to commit first",
		"button_leave": "Back away.",
		"sublabel_leave": "It does not bluff",
		"prey": { "name": "a defensive adult Triceratops", "fight_power": 0.75, "hunger_value": 0.88, "size": 8 },
	},
	{
		"flavor": "A wounded Ankylosaurus shuffles through low brush, one leg dragging.\n\nYou move toward the weak side.\n\nThe tail swings before you reach it.\n\nThe club crashes through the plants with enough force to shake the ground, and the armored prey turns to face you.",
		"combat_start": "The Ankylosaurus swings its tail club first.",
		"button_fight": "Get past the tail.",
		"sublabel_fight": "Wait out the swing before closing",
		"button_leave": "Back out of club range.",
		"sublabel_leave": "Wounded does not mean disarmed",
		"prey": { "name": "a wounded Ankylosaurus", "fight_power": 0.55, "hunger_value": 0.80, "size": 7 },
	},
	{
		"flavor": "An adult Ankylosaurus grazes near a patch of tough plants, armor raised like stone plates.\n\nYou step around it, searching for a place to bite.\n\nIts tail shifts.\n\nThen the club comes around hard, forcing the fight before you can choose your angle.",
		"combat_start": "The Ankylosaurus tail club starts the battle.",
		"button_fight": "Find the gap before it resets.",
		"sublabel_fight": "Get low and get inside the swing",
		"button_leave": "Leave the walking fortress.",
		"sublabel_leave": "That club answers every approach",
		"prey": { "name": "an adult Ankylosaurus", "fight_power": 0.72, "hunger_value": 0.82, "size": 7 },
	},
	{
		"flavor": "A juvenile Edmontosaurus drinks from a shallow stream, separated from the others.\n\nYou rush the bank.\n\nThe prey slips backward in panic, splashing water into your path. Its back legs kick through mud and water before your jaws can land cleanly.",
		"combat_start": "The Edmontosaurus kicks from the streambank.",
		"button_fight": "Close through the mud.",
		"sublabel_fight": "The water slows you both",
		"button_leave": "Pull back from the bank.",
		"sublabel_leave": "The footing is worse than it looks",
		"prey": { "name": "a juvenile Edmontosaurus", "fight_power": 0.35, "hunger_value": 0.72, "size": 5 },
	},
	{
		"flavor": "A scarred Edmontosaurus bull sees you coming from the trees.\n\nIt does not wait to be chased.\n\nWith a deep bellow, it throws its full body forward, shoulder lowered, trying to smash past you before your bite finds purchase.",
		"combat_start": "The Edmontosaurus bull rushes you.",
		"button_fight": "Meet the rush.",
		"sublabel_fight": "Don't let it build full speed",
		"button_leave": "Get out of its path.",
		"sublabel_leave": "A running bull is a hard stop",
		"prey": { "name": "a bull Edmontosaurus", "fight_power": 0.55, "hunger_value": 0.85, "size": 7 },
	},
	{
		"flavor": "A dome-headed herbivore stands between two trees, watching you with stubborn eyes.\n\nYou move closer.\n\nIt charges without warning.\n\nThe thick skull slams toward your ribs before you can bring your jaws down.",
		"combat_start": "The Pachycephalosaurus charges skull-first.",
		"button_fight": "Catch it mid-charge.",
		"sublabel_fight": "Time the jaws for the approach",
		"button_leave": "Step aside.",
		"sublabel_leave": "That skull does not care about your size",
		"prey": { "name": "a Pachycephalosaurus challenger", "fight_power": 0.45, "hunger_value": 0.68, "size": 5 },
	},
	{
		"flavor": "A prey trail leads you through trampled grass, fresh and promising.\n\nAnother young tyrannosaur appears on the same trail.\n\nIt opens its jaws, gives one low rumble, and lunges. The prey is forgotten. The rival wants the hunting ground.",
		"combat_start": "The rival tyrannosaur attacks first.",
		"button_fight": "Hold the ground.",
		"sublabel_fight": "Back down now and lose it permanently",
		"button_leave": "Yield the trail.",
		"sublabel_leave": "A tyrannosaur fight leaves marks",
		"prey": { "name": "a juvenile tyrannosaur rival", "fight_power": 0.58, "hunger_value": 0.75, "size": 7 },
	},
	{
		"flavor": "A larger tyrannosaur waits ahead in the clearing, standing over the trail like it owns the forest.\n\nYou take one step too close.\n\nIts head drops. Its jaws open. The charge comes with no warning beyond the thunder of its feet.",
		"combat_start": "The adult rival charges to drive you off.",
		"button_fight": "Take the fight.",
		"sublabel_fight": "One of you leaves injured",
		"button_leave": "Retreat.",
		"sublabel_leave": "Those scars mean it has done this before",
		"prey": { "name": "an adult tyrannosaur rival", "fight_power": 0.80, "hunger_value": 0.78, "size": 8 },
	},
	{
		"flavor": "You follow movement through the brush, expecting one small animal.\n\nThen the chirps begin.\n\nFeathered hunters flicker between the ferns around you, darting in and out of sight. One slashes from the side before you can turn fully.",
		"combat_start": "The pack attacks from multiple angles.",
		"button_fight": "Drive them off.",
		"sublabel_fight": "Make it too costly to continue",
		"button_leave": "Leave the area.",
		"sublabel_leave": "Harassment from every angle adds up",
		"prey": { "name": "a dromaeosaur pack", "fight_power": 0.58, "hunger_value": 0.65, "size": 6 },
	},
	{
		"flavor": "A shape drifts near the riverbank. It looks slow. Half asleep. Easy.\n\nYou step too close to the water.\n\nThe river erupts.\n\nA crocodyliform lunges from the mud, jaws snapping toward your leg with ancient patience turned sudden violence.",
		"combat_start": "The crocodyliform ambushes from the river.",
		"button_fight": "Drag it onto dry ground.",
		"sublabel_fight": "Get it away from the water fast",
		"button_leave": "Lunge back from the bank.",
		"sublabel_leave": "The water is its weapon",
		"prey": { "name": "a river crocodyliform", "fight_power": 0.68, "hunger_value": 0.65, "size": 6 },
	},
	{
		"flavor": "A sickly Torosaurus lingers behind its group, breathing hard and moving slowly.\n\nYou approach, expecting weakness.\n\nIts head lowers.\n\nThe old horned herbivore surges forward with the last kind of strength any predator wants to meet.",
		"combat_start": "The Torosaurus charges despite its weakness.",
		"button_fight": "Press through the charge.",
		"sublabel_fight": "Sick does not mean slow horns",
		"button_leave": "Back away from the surge.",
		"sublabel_leave": "Desperate prey fights hardest",
		"prey": { "name": "a sickly Torosaurus", "fight_power": 0.52, "hunger_value": 0.85, "size": 7 },
	},
]


func get_mixed_encounters() -> Array:
	return MIXED_ENCOUNTERS


const COMBAT_FLAVORS: Dictionary = {
	"win":    "One strike. That's all it took. The ground shook and the prey didn't get back up. This is what apex looks like.",
	"win_inj":"The kill is yours — it was never in question. But something connected before it went down. A bruise. A gouge. Nothing that stops you. But noted.",
	"lose":   "Even a T-Rex miscalculates. You pushed into the wrong angle and paid for it. You disengage with damage you didn't expect to take.",
	"escape": "You don't run. You never run. But you're retreating now — torn up, breathing hard, moving on instinct. This does not happen. And yet.",
}

func get_combat_flavors() -> Dictionary:
	return COMBAT_FLAVORS


const SCAVENGE_FINDS: Array = [
	{ "flavor": "You find a heavy carcass left open in the clearing, still rich with meat. You claim it with crushing bites and eat until the area goes quiet.", "hunger_value": 0.25 },
	{ "flavor": "A chunk of torn flesh lies near a trampled herd path. It is not a true kill, but it is enough to feed the hunger for now.",                    "hunger_value": 0.18 },
	{ "flavor": "You find cracked bones and scraps already worked over by smaller scavengers. You crush what remains and take what little marrow is left.",      "hunger_value": 0.12 },
]
const SCAVENGE_MISS: String = "The air carries old blood and false trails, but no meal waits at the end of them."

func get_scavenge_finds() -> Array:
	return SCAVENGE_FINDS

func get_scavenge_miss() -> String:
	return SCAVENGE_MISS
