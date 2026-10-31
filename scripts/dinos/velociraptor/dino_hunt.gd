extends "res://scripts/dinos/base_dino_hunt.gd"

const CRITS: Array = [
	{
		"flavor": "A small lizard moves through loose dust, leaving tiny marks behind it. You follow without rushing, placing your feet where the ground is quietest.\n\nIt pauses beneath a dry root.\n\nYou strike before the dust even settles.",
		"result": "You track and catch prey with perfect timing.",
		"button": "Silent feet. Sharp teeth.",
		"hunger_gain": 0.38,
	},
	{
		"flavor": "A small animal darts beneath thorny brush, thinking the tight branches will protect it.\n\nBut you are small enough to follow.\n\nYou slip through the gap, corner it against the roots, and end the hunt before it finds another way out.",
		"result": "You use brush cover to trap prey.",
		"button": "The thorns favor me.",
		"hunger_gain": 0.36,
	},
	{
		"flavor": "A tiny mammal freezes near a fallen branch, listening for danger.\n\nYou freeze too.\n\nFor a long moment, neither of you moves. Then it blinks, just once.\n\nThat is enough.",
		"result": "You win with patience and precision.",
		"button": "One blink was all I needed.",
		"hunger_gain": 0.38,
	},
	{
		"flavor": "A young prey animal scrambles up a sandy slope, kicking dust behind it. Its feet slide. Its body tilts.\n\nYou were already climbing from the side.\n\nWhen it slips, you are there.",
		"result": "You exploit loose terrain for an easy kill.",
		"button": "Bad footing. Good meal.",
		"hunger_gain": 0.42,
	},
	{
		"flavor": "A small herbivore moves through low grass, nibbling as it goes. The wind bends the grass around you, hiding your approach.\n\nYou keep low, wait for the perfect angle, then burst forward.\n\nThe grass parts once.\n\nThe hunt ends.",
		"result": "You complete a clean grassland ambush.",
		"button": "Move with the grass.",
		"hunger_gain": 0.42,
	},
	{
		"flavor": "A fast lizard bolts toward a crack between rocks. You cannot reach its body in time.\n\nSo you catch the tail with your sickle claw.\n\nOne sharp hook, one quick pull, and the prey tumbles back toward your jaws.",
		"result": "You use your sickle claw with perfect control.",
		"button": "Hook it back.",
		"hunger_gain": 0.36,
	},
	{
		"flavor": "A bold little predator snaps at you, guarding its patch of brush. You step back as if frightened.\n\nIt follows.\n\nThat was the mistake.\n\nYou turn, spring forward, and catch it before it understands the trick.",
		"result": "You bait prey into a perfect counterattack.",
		"button": "Let it feel brave.",
		"hunger_gain": 0.40,
	},
	{
		"flavor": "A small animal squeezes between two sun-warmed stones, hiding in the narrow shade.\n\nYou circle instead of forcing your way in.\n\nWhen it flees out the other side, your jaws are waiting.",
		"result": "You predict the escape route perfectly.",
		"button": "I knew where it would run.",
		"hunger_gain": 0.38,
	},
	{
		"flavor": "The wind shifts across the dry ground, carrying dust, scent, and sound away from your prey.\n\nYou recognize the gift immediately.\n\nYou move in with the breeze at your back, silent and unseen, then strike before the prey ever senses you.",
		"result": "You use wind and scent to land a flawless hunt.",
		"button": "The wind hunted with me.",
		"hunger_gain": 0.44,
	},
	{
		"flavor": "A small runner breaks from cover and zigzags through the brush. It is fast, but each turn is too wide.\n\nYou cut the angles tighter.\n\nOn the final turn, it runs straight into your path.",
		"result": "You outmaneuver prey in a perfect chase.",
		"button": "Cut the corner.",
		"hunger_gain": 0.42,
	},
	{
		"flavor": "A small flying creature flutters low over the ground, struggling to gain height.\n\nYou wait until its wings beat downward.\n\nThen you jump.\n\nYour jaws close before it can rise.",
		"result": "You catch low-flying prey with a clean leap.",
		"button": "Too low. Too slow.",
		"hunger_gain": 0.28,
	},
	{
		"flavor": "A nestling creature wanders from cover, pecking at insects in the dirt. It never sees your feathers blend into the brush.\n\nYou lower yourself.\n\nOne breath.\n\nOne leap.\n\nDone.",
		"result": "You land a flawless pounce on vulnerable prey.",
		"button": "Small mistake. Smaller mercy.",
		"hunger_gain": 0.40,
	},
]


func get_crit_event() -> Dictionary:
	return CRITS[randi() % CRITS.size()]


const ENCOUNTERS: Array = [
	{
		"flavor": "A sleek skink darts between dry roots, stopping just long enough to flick its tongue at the air. It sees you, but it has not run yet.\n\nThe chase would be quick.\n\nThe bite might be quicker.",
		"button_fight": "Chase it down.",
		"sublabel_fight": "Move before it decides to run",
		"button_leave": "Let it escape.",
		"sublabel_leave": "Not worth the speed",
		"prey": { "name": "a desert skink", "fight_power": 0.08, "hunger_value": 0.14, "size": 1 },
	},
	{
		"flavor": "A small lizard freezes beside a narrow burrow entrance. Its body is halfway turned toward safety, but your path cuts across the opening.\n\nIf you strike fast, you can stop it.\n\nIf you hesitate, it vanishes underground.",
		"button_fight": "Strike before it dives.",
		"sublabel_fight": "One chance before it disappears",
		"button_leave": "Search elsewhere.",
		"sublabel_leave": "Not worth rushing",
		"prey": { "name": "a burrow lizard", "fight_power": 0.14, "hunger_value": 0.16, "size": 1 },
	},
	{
		"flavor": "A tiny mammal rustles beneath thorny brush, snapping seeds in its teeth. When you creep closer, it darts deeper into the tangled stems and bares its sharp little teeth.\n\nThe brush protects it.\n\nBut you might be small enough to follow.",
		"button_fight": "Follow it in.",
		"sublabel_fight": "The thorns will cost you",
		"button_leave": "Avoid the thorns.",
		"sublabel_leave": "Find something in the open",
		"prey": { "name": "a thornbrush mammal", "fight_power": 0.26, "hunger_value": 0.30, "size": 1 },
	},
	{
		"flavor": "A thin snake lies half-buried in warm sand, almost invisible except for the slow flick of its tongue.\n\nIt does not flee when you step closer.\n\nIt coils.",
		"button_fight": "Strike first.",
		"sublabel_fight": "Fast or not at all",
		"button_leave": "Back away slowly.",
		"sublabel_leave": "Venom changes everything",
		"prey": { "name": "a sand snake", "fight_power": 0.55, "hunger_value": 0.18, "size": 1 },
	},
	{
		"flavor": "You find a shallow ground nest tucked beneath dry grass. Before you can reach the eggs, a small feathered parent rushes from cover, wings spread and beak snapping.\n\nThe eggs are exposed.\n\nThe guard is not bluffing.",
		"button_fight": "Fight through the guard.",
		"sublabel_fight": "Get past it to reach the eggs",
		"button_leave": "Leave the nest.",
		"sublabel_leave": "The guard means it",
		"prey": { "name": "a nest-guarding theropod", "fight_power": 0.30, "hunger_value": 0.35, "size": 2 },
	},
	{
		"flavor": "A young Protoceratops noses through dusty plants, its beak clipping leaves close to the ground. When it spots you, it turns sideways and lowers its head.\n\nIt is not fast.\n\nIt is stubborn.",
		"button_fight": "Push through the defense.",
		"sublabel_fight": "That beak will find you",
		"button_leave": "Move on.",
		"sublabel_leave": "Too stubborn for an easy hunt",
		"prey": { "name": "a young Protoceratops", "fight_power": 0.42, "hunger_value": 0.50, "size": 3 },
	},
	{
		"flavor": "Another Velociraptor steps into view near the same small prey trail. Its feathers lift, its sickle claw flexes, and its eyes stay fixed on you instead of the food.\n\nThis is not just a hunt anymore.\n\nIt is a claim.",
		"button_fight": "Fight for the ground.",
		"sublabel_fight": "Contest the territory",
		"button_leave": "Back off.",
		"sublabel_leave": "Not worth a fight with your own kind",
		"prey": { "name": "a rival Velociraptor", "fight_power": 0.35, "hunger_value": 0.40, "size": 2 },
	},
	{
		"flavor": "A flat stone shifts as something moves beneath it. A large scorpion crawls out, claws open and tail raised.\n\nIt is small enough to kill.\n\nIt is dangerous enough to regret touching.",
		"button_fight": "Risk the sting.",
		"sublabel_fight": "High risk, little reward",
		"button_leave": "Leave it alone.",
		"sublabel_leave": "That tail is not worth it",
		"prey": { "name": "a giant scorpion", "fight_power": 0.52, "hunger_value": 0.15, "size": 1 },
	},
	{
		"flavor": "A young pterosaur flutters beside a cracked branch, one wing dragging against the dirt. It hisses when you approach, jabbing its beak toward your face.\n\nIt cannot fly well.\n\nBut it can scream.",
		"button_fight": "End it before it screams.",
		"sublabel_fight": "Silence it fast",
		"button_leave": "Retreat before attention arrives.",
		"sublabel_leave": "That scream carries far",
		"prey": { "name": "a fallen pterosaur chick", "fight_power": 0.28, "hunger_value": 0.32, "size": 2 },
	},
	{
		"flavor": "A chunky gecko waddles over sun-warmed stones, its thick tail swaying like a tempting meal. When you approach, it opens its mouth wide and plants its feet.\n\nIt looks slow.\n\nIt also looks very willing to bite your snout.",
		"button_fight": "Get past the bite.",
		"sublabel_fight": "That mouth is the whole fight",
		"button_leave": "Ignore it.",
		"sublabel_leave": "Too much bite for too little meal",
		"prey": { "name": "a thick-tailed gecko", "fight_power": 0.15, "hunger_value": 0.18, "size": 1 },
	},
	{
		"flavor": "A small fast-running mammal bolts from a patch of dry grass, kicking dust behind it. It is built to flee, not fight, but cornered animals do not always remember that.\n\nIf you chase it, you will need to finish quickly.",
		"button_fight": "Chase it down.",
		"sublabel_fight": "Don't let the chase go long",
		"button_leave": "Save your energy.",
		"sublabel_leave": "Too fast for a long pursuit",
		"prey": { "name": "a dust hare", "fight_power": 0.12, "hunger_value": 0.22, "size": 1 },
	},
	{
		"flavor": "A young Oviraptor pecks through loose dirt, searching for insects or eggs. It freezes when it sees you, then spreads its feathered arms and snaps its beak.\n\nIt is not much bigger than you.\n\nBut it is not helpless.",
		"button_fight": "Press the fight.",
		"sublabel_fight": "Fast and aggressive",
		"button_leave": "Avoid the contest.",
		"sublabel_leave": "Not worth a mirror fight",
		"prey": { "name": "a young Oviraptor", "fight_power": 0.32, "hunger_value": 0.38, "size": 2 },
	},
	{
		"flavor": "A large beetle crawls across cracked earth, its shell dull and hard. When your shadow falls over it, the beetle raises its front legs and clicks its jaws.\n\nThere is food beneath that armor.\n\nGetting to it is the annoying part.",
		"button_fight": "Crack the shell.",
		"sublabel_fight": "Force through the armor",
		"button_leave": "Look for softer prey.",
		"sublabel_leave": "Too much effort for the meal",
		"prey": { "name": "an armored desert beetle", "fight_power": 0.14, "hunger_value": 0.12, "size": 1 },
	},
	{
		"flavor": "A small, strange theropod scratches at an insect mound with powerful little arms. It notices you and lets out a sharp warning call.\n\nIt is smaller than many prey animals.\n\nBut those claws were made for digging — and they can still cut.",
		"button_fight": "Close before it digs away.",
		"sublabel_fight": "Don't give it time to call",
		"button_leave": "Leave it digging.",
		"sublabel_leave": "Those claws will find you",
		"prey": { "name": "a juvenile Mononykus", "fight_power": 0.28, "hunger_value": 0.25, "size": 2 },
	},
	{
		"flavor": "A lizard squeezes into a narrow crack between two rocks, leaving only its head and front legs exposed. It snaps at you from inside the gap.\n\nYou can reach it.\n\nBut only if you get close to its mouth.",
		"button_fight": "Reach in carefully.",
		"sublabel_fight": "Slow and precise",
		"button_leave": "Wait for easier prey.",
		"sublabel_leave": "Those teeth are at face level",
		"prey": { "name": "a rock-crack lizard", "fight_power": 0.25, "hunger_value": 0.20, "size": 1 },
	},
]


func get_encounters() -> Array:
	return ENCOUNTERS


const MIXED_ENCOUNTERS: Array = [
	{
		"flavor": "You follow tiny tracks across loose sand, each print fresh and clear.\n\nThe trail stops beside a half-buried root.\n\nYou lean closer.\n\nThe sand erupts as a skink bursts out beneath your feet, snapping and twisting in panic before you can pin it.",
		"combat_start": "The skink lashes out from the sand.",
		"button_fight": "Hold it down.",
		"sublabel_fight": "Pin it before it twists free",
		"button_leave": "Let it go.",
		"sublabel_leave": "Not worth chasing across loose ground",
		"prey": { "name": "a desert skink", "fight_power": 0.08, "hunger_value": 0.14, "size": 1 },
	},
	{
		"flavor": "A small lizard freezes beside a burrow entrance. You creep closer, ready to cut off its escape.\n\nThen the lizard darts the wrong way — straight at you.\n\nIts claws scrape your snout as it scrambles over your face, turning the clean catch into a frantic fight.",
		"combat_start": "The burrow lizard panics and attacks.",
		"button_fight": "Catch it before it rights itself.",
		"sublabel_fight": "It's already on top of you",
		"button_leave": "Let it run past.",
		"sublabel_leave": "Recover and look elsewhere",
		"prey": { "name": "a burrow lizard", "fight_power": 0.14, "hunger_value": 0.16, "size": 1 },
	},
	{
		"flavor": "Something rustles beneath a thorny shrub. You slip in low, careful not to snag your feathers.\n\nA tiny mammal waits inside, cornered and furious.\n\nIt launches from the brush with a shrill squeak, teeth flashing before you can pull back.",
		"combat_start": "The mammal attacks from inside the thorns.",
		"button_fight": "Fight it in the tangle.",
		"sublabel_fight": "Close quarters — move carefully",
		"button_leave": "Back out of the brush.",
		"sublabel_leave": "Not worth the thorns and the bite",
		"prey": { "name": "a thornbrush mammal", "fight_power": 0.26, "hunger_value": 0.30, "size": 1 },
	},
	{
		"flavor": "You track a faint movement across the warm ground, expecting a lizard.\n\nThe line in the sand stops moving.\n\nThen it coils.\n\nA thin snake rises from the dust, already pulled back to strike. You are too close to escape the first bite.",
		"combat_start": "The snake strikes from the sand.",
		"button_fight": "Fight through the bite.",
		"sublabel_fight": "You're already inside its range",
		"button_leave": "Jump back fast.",
		"sublabel_leave": "Give it ground and leave",
		"prey": { "name": "a sand snake", "fight_power": 0.55, "hunger_value": 0.18, "size": 1 },
	},
	{
		"flavor": "You find eggs hidden beneath dry grass and lower your head toward them.\n\nA feathered parent bursts from cover with a sharp cry, wings spread wide and claws raking at the ground.\n\nThe nest was not abandoned.\n\nAnd now you are the threat.",
		"combat_start": "The nest guardian attacks before you can retreat.",
		"button_fight": "Drive the guard off.",
		"sublabel_fight": "Fight through it to reach the eggs",
		"button_leave": "Back away from the nest.",
		"sublabel_leave": "Leave the eggs and the fight",
		"prey": { "name": "a nest-guarding theropod", "fight_power": 0.30, "hunger_value": 0.35, "size": 2 },
	},
	{
		"flavor": "A young Protoceratops browses in dusty plants, head lowered and unaware.\n\nYou take one step into the open.\n\nIts head snaps up.\n\nThe beak comes first, then the shove. Your ambush collapses into a close fight.",
		"combat_start": "The Protoceratops turns and bites first.",
		"button_fight": "Hold your ground.",
		"sublabel_fight": "Don't let it reset its footing",
		"button_leave": "Fall back.",
		"sublabel_leave": "That beak hits harder than expected",
		"prey": { "name": "a young Protoceratops", "fight_power": 0.42, "hunger_value": 0.50, "size": 3 },
	},
	{
		"flavor": "You follow a prey trail through dry brush, scent fresh and promising.\n\nAnother Velociraptor steps into the trail ahead.\n\nIts feathers lift. Its sickle claw flexes. It does not look at the prey tracks anymore.\n\nIt looks at you.",
		"combat_start": "The rival Velociraptor lunges to claim the trail.",
		"button_fight": "Fight for the ground.",
		"sublabel_fight": "Establish dominance now",
		"button_leave": "Back down.",
		"sublabel_leave": "A mirror fight leaves marks",
		"prey": { "name": "a rival Velociraptor", "fight_power": 0.35, "hunger_value": 0.40, "size": 2 },
	},
	{
		"flavor": "You nose a flat stone aside, expecting beetles underneath.\n\nA scorpion slides out instead.\n\nIts claws open. Its tail rises.\n\nBefore you can leap back, the stinger snaps forward.",
		"combat_start": "The scorpion strikes from beneath the stone.",
		"button_fight": "Pin the tail first.",
		"sublabel_fight": "Stop the sting before anything else",
		"button_leave": "Back away fast.",
		"sublabel_leave": "That venom is not worth the meal",
		"prey": { "name": "a giant scorpion", "fight_power": 0.52, "hunger_value": 0.15, "size": 1 },
	},
	{
		"flavor": "A young pterosaur flutters beside a fallen branch, one wing dragging in the dirt.\n\nYou move in fast, expecting it to stumble.\n\nInstead, it shrieks and throws itself at your face, beak jabbing wildly as its wings batter your eyes.",
		"combat_start": "The pterosaur chick attacks in panic.",
		"button_fight": "Fight through the noise.",
		"sublabel_fight": "Get control before it screams again",
		"button_leave": "Pull back from the scream.",
		"sublabel_leave": "That shriek carries far",
		"prey": { "name": "a fallen pterosaur chick", "fight_power": 0.28, "hunger_value": 0.32, "size": 2 },
	},
	{
		"flavor": "A thick-tailed gecko waddles over warm stones, slow and tempting.\n\nYou lunge.\n\nThe gecko turns faster than expected, mouth wide, and clamps down before your jaws find the right angle.",
		"combat_start": "The gecko bites as you strike.",
		"button_fight": "Shake it loose and finish.",
		"sublabel_fight": "That grip is stronger than it looks",
		"button_leave": "Pull back and let it drop.",
		"sublabel_leave": "Not worth a locked jaw on your snout",
		"prey": { "name": "a thick-tailed gecko", "fight_power": 0.15, "hunger_value": 0.18, "size": 1 },
	},
	{
		"flavor": "A small mammal bolts from dry grass, kicking dust behind it.\n\nYou cut the angle perfectly — almost.\n\nThe hare twists at the last second and drives both back feet into your chest, turning the chase into a scramble.",
		"combat_start": "The dust hare kicks hard as you close in.",
		"button_fight": "Don't let it reset.",
		"sublabel_fight": "Close before it gets distance again",
		"button_leave": "Let it run.",
		"sublabel_leave": "Those kicks will keep coming",
		"prey": { "name": "a dust hare", "fight_power": 0.12, "hunger_value": 0.22, "size": 1 },
	},
	{
		"flavor": "A young Oviraptor pecks through loose dirt, too focused on insects to notice you.\n\nThen a twig snaps beneath your foot.\n\nThe Oviraptor whips around, lets out a sharp alarm call, and rushes you with beak and claws.",
		"combat_start": "The Oviraptor charges after spotting you.",
		"button_fight": "Meet the charge head-on.",
		"sublabel_fight": "Cut it off before it builds speed",
		"button_leave": "Break away.",
		"sublabel_leave": "That alarm call brings attention",
		"prey": { "name": "a young Oviraptor", "fight_power": 0.32, "hunger_value": 0.38, "size": 2 },
	},
	{
		"flavor": "A large beetle crawls across cracked earth, shell dull and hard.\n\nYou try to grab it from the side.\n\nIts body snaps shut against your bite, then its mandibles click around your snout.\n\nThe easy crunch becomes a fight for control.",
		"combat_start": "The beetle clamps down with its mandibles.",
		"button_fight": "Break its grip.",
		"sublabel_fight": "Pry those mandibles free",
		"button_leave": "Drop it and back off.",
		"sublabel_leave": "That grip is not loosening on its own",
		"prey": { "name": "an armored desert beetle", "fight_power": 0.14, "hunger_value": 0.12, "size": 1 },
	},
	{
		"flavor": "A juvenile Mononykus scratches at an insect mound, head buried in the dirt.\n\nYou creep closer.\n\nIts head pops up suddenly.\n\nWith a sharp call, it slashes sideways with its digging claws before you can spring.",
		"combat_start": "The Mononykus swipes first with its claws.",
		"button_fight": "Close past the claws.",
		"sublabel_fight": "Get inside the reach before it swings again",
		"button_leave": "Back off.",
		"sublabel_leave": "Those claws were built for exactly this",
		"prey": { "name": "a juvenile Mononykus", "fight_power": 0.28, "hunger_value": 0.25, "size": 2 },
	},
	{
		"flavor": "A lizard hides between two rocks, only its head and front legs visible.\n\nYou lower your snout, trying to pull it free.\n\nThe lizard snaps first.\n\nPain flashes across your face, and now it is wedged in the crack with its teeth in you.",
		"combat_start": "The rock-crack lizard bites from cover.",
		"button_fight": "Pull it free.",
		"sublabel_fight": "Drag it out of the gap",
		"button_leave": "Back your face out of there.",
		"sublabel_leave": "Leave it in its crack",
		"prey": { "name": "a rock-crack lizard", "fight_power": 0.25, "hunger_value": 0.20, "size": 1 },
	},
]


func get_mixed_encounters() -> Array:
	return MIXED_ENCOUNTERS


const COMBAT_FLAVORS: Dictionary = {
	"win":    "Fast, low, decisive. You hit before it even registered you were there. A clean kill — exactly what speed is for.",
	"win_inj":"You landed it, but not clean. A claw caught you on the way out. The kill's yours. The wound stings with every step.",
	"lose":   "It was faster than you expected — or you pushed past what the opening allowed. You take real damage pulling back.",
	"escape": "You got out. That's the only win here. You're bleeding and running and the adrenaline is the only thing keeping you moving.",
}

func get_combat_flavors() -> Dictionary:
	return COMBAT_FLAVORS


const SCAVENGE_FINDS: Array = [
	{ "flavor": "You uncover a buried clutch of small eggs beneath dry brush. You crack them open carefully and eat before the wind carries your scent too far.", "hunger_value": 0.25 },
	{ "flavor": "A small carcass lies half-hidden between stones, picked over but still fresh. You pull it into cover and eat what remains.",                     "hunger_value": 0.18 },
	{ "flavor": "You find a few dried scraps beneath a thorn bush. They taste more like dust than meat, but they still quiet your stomach.",                     "hunger_value": 0.12 },
]
const SCAVENGE_MISS: String = "You follow faint smells through dust and brush, but the trail gives you nothing."

func get_scavenge_finds() -> Array:
	return SCAVENGE_FINDS

func get_scavenge_miss() -> String:
	return SCAVENGE_MISS
