extends "res://scripts/dinos/base_dino_hunt.gd"

const CRITS: Array = [
	{
		"flavor": "A small herbivore lowers its head to feed, unaware of the shadow moving through the brush.\n\nYou crouch low. Your feathers still. Your sickle claw lifts.\n\nOne explosive leap later, the prey barely has time to cry out.",
		"result": "You bring down prey with a flawless ambush.",
		"button": "Strike before fear moves.",
		"hunger_gain": 0.48,
	},
	{
		"flavor": "A quick series of soft calls passes through the ferns. You are not alone. Another Deinonychus shifts at the edge of the clearing, driving a startled animal toward your hiding place.\n\nThe prey runs exactly where the pack wants it.\n\nStraight to you.",
		"result": "The pack helps you secure a clean kill.",
		"button": "Good pack. Good hunt.",
		"hunger_gain": 0.52,
	},
	{
		"flavor": "A fleeing lizard-like herbivore darts around a fallen log, but its back foot slips in loose dirt.\n\nThat single mistake is enough.\n\nYou close the distance in a flash and hit before it can recover.",
		"result": "You catch prey after a perfect opening.",
		"button": "Take the opening.",
		"hunger_gain": 0.45,
	},
	{
		"flavor": "Tall grass hides every step you take. The wind pushes your scent away. Your prey keeps feeding, twitching only at insects near its feet.\n\nYou move closer.\n\nCloser.\n\nThen the grass erupts.",
		"result": "You complete a silent stalk and quick kill.",
		"button": "From silence, teeth.",
		"hunger_gain": 0.48,
	},
	{
		"flavor": "A young prey animal bolts from cover, separated from the others. It is fast, but panic makes its path sloppy.\n\nYou do not chase blindly. You angle ahead.\n\nWhen it turns, you are already there.",
		"result": "You outmaneuver prey and end the hunt quickly.",
		"button": "Cut off the escape.",
		"hunger_gain": 0.50,
	},
	{
		"flavor": "Your prey tries to scramble up a muddy bank, kicking dirt behind it.\n\nYou leap onto its side and drive your sickle claw down, pinning it before it can pull free.\n\nThe fight ends almost as soon as it begins.",
		"result": "You use your sickle claw perfectly.",
		"button": "Pin it down.",
		"hunger_gain": 0.50,
	},
	{
		"flavor": "A small animal bursts from the brush before it even sees you. Something else frightened it first, but you are the danger waiting in its path.\n\nIt skids to turn away.\n\nToo late.",
		"result": "You catch prey forced directly toward you.",
		"button": "Wrong direction.",
		"hunger_gain": 0.44,
	},
	{
		"flavor": "A low branch hides your body as you watch a young herbivore wander closer. Its attention stays on the leaves above it, not the hunter below.\n\nYou wait until it takes one more step.\n\nThen you launch.",
		"result": "You spring from cover and win instantly.",
		"button": "Let it step closer.",
		"hunger_gain": 0.48,
	},
	{
		"flavor": "A nearby packmate gives a quiet chirp. You shift left. They move right. The prey hesitates, confused by motion on both sides.\n\nThat hesitation ruins it.\n\nYou strike together before it chooses a direction.",
		"result": "You and the pack execute a clean flank.",
		"button": "Close the trap.",
		"hunger_gain": 0.55,
	},
	{
		"flavor": "A young prey animal crosses slick mud near the waterline. Its feet slide. Its body drops low.\n\nYou were already waiting near the reeds.\n\nBy the time it regains balance, your claws are on it.",
		"result": "You exploit terrain for an easy kill.",
		"button": "The mud chose poorly.",
		"hunger_gain": 0.48,
	},
	{
		"flavor": "A small predator snaps at you from beside a root, more bold than wise. It expects you to back off.\n\nInstead, you surge forward with sudden speed.\n\nIts confidence vanishes under your claws.",
		"result": "You overpower a smaller predator cleanly.",
		"button": "Bold was a mistake.",
		"hunger_gain": 0.42,
	},
	{
		"flavor": "Your prey bolts into open ground, fast but predictable. Every turn it makes, you read before it finishes.\n\nYou close the gap stride by stride, then leap when its stamina breaks.\n\nNo wasted motion. No messy fight.",
		"result": "You win through a perfect chase.",
		"button": "Run it down.",
		"hunger_gain": 0.50,
	},
]


func get_crit_event() -> Dictionary:
	return CRITS[randi() % CRITS.size()]


const ENCOUNTERS: Array = [
	{
		"flavor": "A young Dryosaurus grazes near the edge of the brush, lifting its head every few bites. Its legs are thin but fast, and its tail twitches with nervous energy.\n\nYou could rush it before it bolts.\n\nBut if it sees you first, this becomes a chase.",
		"button_fight": "Rush before it bolts.",
		"sublabel_fight": "Speed is the only window",
		"button_leave": "Stay hidden.",
		"sublabel_leave": "Don't start a chase you may lose",
		"prey": { "name": "a young Dryosaurus", "fight_power": 0.28, "hunger_value": 0.48, "size": 2 },
	},
	{
		"flavor": "A small Protoceratops backs against a rocky mound, lowering its beaked head. It is not large, but it looks sturdy, stubborn, and very unwilling to become food.\n\nYour claws can hurt it.\n\nIts beak can hurt you back.",
		"button_fight": "Fight through the bite.",
		"sublabel_fight": "Expect a rough struggle",
		"button_leave": "Retreat.",
		"sublabel_leave": "That beak is not worth it",
		"prey": { "name": "a cornered Protoceratops", "fight_power": 0.38, "hunger_value": 0.55, "size": 3 },
	},
	{
		"flavor": "You catch the scent of blood and find a small ornithopod limping through the ferns. One leg drags slightly, but its eyes are alert.\n\nIt is weakened.\n\nNot helpless.",
		"button_fight": "Press the advantage.",
		"sublabel_fight": "Wounded does not mean safe",
		"button_leave": "Leave it.",
		"sublabel_leave": "Find something with less fight left",
		"prey": { "name": "an injured ornithopod", "fight_power": 0.25, "hunger_value": 0.50, "size": 2 },
	},
	{
		"flavor": "Another Deinonychus steps from the brush, feathers raised and sickle claw lifted. Between you lies a frightened prey animal neither of you has claimed yet.\n\nThe rival chirps once.\n\nThis hunt just became a challenge.",
		"button_fight": "Fight for the hunt.",
		"sublabel_fight": "Contest the kill",
		"button_leave": "Back off.",
		"sublabel_leave": "Not worth fighting your own kind",
		"prey": { "name": "a rival Deinonychus", "fight_power": 0.40, "hunger_value": 0.52, "size": 3 },
	},
	{
		"flavor": "A heavy lizard crawls across a sunlit patch of stones. It is slower than you, but thick-bodied and covered in rough scales.\n\nWhen you approach, it whips its tail hard enough to crack against the rocks.",
		"button_fight": "Get past the tail.",
		"sublabel_fight": "Time the opening",
		"button_leave": "Search for easier prey.",
		"sublabel_leave": "That tail looks painful",
		"prey": { "name": "a thick-tailed lizard", "fight_power": 0.35, "hunger_value": 0.45, "size": 2 },
	},
	{
		"flavor": "A young armored herbivore noses through low plants, unaware of you at first. When it hears your step, it turns sideways, showing small bony ridges along its back.\n\nThere is meat here.\n\nThere are also spikes.",
		"button_fight": "Risk the spikes.",
		"sublabel_fight": "Force through the armor",
		"button_leave": "Avoid the rough meal.",
		"sublabel_leave": "Those ridges will cost you",
		"prey": { "name": "a thornback juvenile", "fight_power": 0.48, "hunger_value": 0.58, "size": 3 },
	},
	{
		"flavor": "A young Triceratops calf has wandered just beyond the herd's safest circle. Its horns are only small points, but it lowers its head when it spots you.\n\nYou could take the risk.\n\nBut if it cries out, larger bodies may answer.",
		"button_fight": "Strike fast.",
		"sublabel_fight": "Silence it before the herd hears",
		"button_leave": "Retreat before the herd notices.",
		"sublabel_leave": "The adults are too close",
		"prey": { "name": "a stray Triceratops calf", "fight_power": 0.58, "hunger_value": 0.68, "size": 4 },
	},
	{
		"flavor": "A pterosaur crashes awkwardly near a fallen branch, one wing bent wrong. It hisses, snapping its beak and beating the good wing against the ground.\n\nIt cannot fly away easily.\n\nThat does not mean it cannot fight.",
		"button_fight": "End it before it calls.",
		"sublabel_fight": "Beak and noise are both problems",
		"button_leave": "Leave before the noise spreads.",
		"sublabel_leave": "Not worth the attention",
		"prey": { "name": "a fallen pterosaur", "fight_power": 0.34, "hunger_value": 0.50, "size": 2 },
	},
	{
		"flavor": "A young dome-headed herbivore spots you and does not run. Instead, it lowers its skull and paws the dirt.\n\nIt is smaller than an adult, but that head looks like it was made to ruin someone's ribs.",
		"button_fight": "Take the fight.",
		"sublabel_fight": "Don't let it get a running start",
		"button_leave": "Back away.",
		"sublabel_leave": "That skull is not worth the risk",
		"prey": { "name": "a young Pachycephalosaur", "fight_power": 0.55, "hunger_value": 0.62, "size": 3 },
	},
	{
		"flavor": "You find a nest tucked beneath dry branches, but a feathered Oviraptor stands over it with its arms spread and beak open.\n\nThe eggs would be easy food.\n\nThe parent is the problem.",
		"button_fight": "Fight for the nest.",
		"sublabel_fight": "Get through the guard",
		"button_leave": "Leave it.",
		"sublabel_leave": "The eggs are not worth the beak",
		"prey": { "name": "a nest-guarding Oviraptor", "fight_power": 0.36, "hunger_value": 0.48, "size": 2 },
	},
	{
		"flavor": "A juvenile Iguanodon limps near a muddy path, separated from the herd. Its thumb spikes are small, but sharp enough to matter.\n\nIt watches you carefully.\n\nThis prey knows it has one chance to make you regret getting close.",
		"button_fight": "Take the risk.",
		"sublabel_fight": "Those spikes will find you",
		"button_leave": "Avoid the injury risk.",
		"sublabel_leave": "Find something that can't spike back",
		"prey": { "name": "a wounded juvenile Iguanodon", "fight_power": 0.45, "hunger_value": 0.60, "size": 3 },
	},
	{
		"flavor": "Near the water's edge, a low reptile lies half-hidden in mud. At first, it looks like an easy target.\n\nThen its eye opens.\n\nYou are hunting something that knows how to wait.",
		"button_fight": "Fight on dry ground.",
		"sublabel_fight": "Stay out of the water",
		"button_leave": "Stay away from the water.",
		"sublabel_leave": "This one hunts back",
		"prey": { "name": "a small crocodyliform", "fight_power": 0.58, "hunger_value": 0.55, "size": 3 },
	},
	{
		"flavor": "A long-bodied predator tears at a small animal near the roots. It freezes when it sees you, then turns with a deep hiss.\n\nIt is not prey in the usual sense.\n\nBut it is meat, and it is alone.",
		"button_fight": "Take its meal.",
		"sublabel_fight": "Displace it by force",
		"button_leave": "Let it keep it.",
		"sublabel_leave": "Not worth a predator fight",
		"prey": { "name": "a giant monitor lizard", "fight_power": 0.55, "hunger_value": 0.52, "size": 3 },
	},
	{
		"flavor": "A young hadrosaur feeds near a shallow stream, far enough from the group to tempt you. It is larger than most prey you chase, but still young.\n\nIf you strike well, it could fall.\n\nIf you strike badly, it could trample you.",
		"button_fight": "Strike now.",
		"sublabel_fight": "First hit has to count",
		"button_leave": "Wait for a better opening.",
		"sublabel_leave": "Too much risk for one hit",
		"prey": { "name": "a young hadrosaur", "fight_power": 0.48, "hunger_value": 0.65, "size": 4 },
	},
	{
		"flavor": "A juvenile armored herbivore shuffles through the ferns, low and wide. Its tail club is not fully grown, but it still swings with warning.\n\nIt is slow.\n\nIt is also built like a bad idea.",
		"button_fight": "Test the armor.",
		"sublabel_fight": "Find a gap or give up",
		"button_leave": "Avoid the walking rock.",
		"sublabel_leave": "That tail will find you eventually",
		"prey": { "name": "a juvenile Ankylosaur", "fight_power": 0.62, "hunger_value": 0.65, "size": 4 },
	},
]


func get_encounters() -> Array:
	return ENCOUNTERS


const MIXED_ENCOUNTERS: Array = [
	{
		"flavor": "You creep toward movement in the ferns, body low and sickle claw raised.\n\nThe shape ahead freezes.\n\nThen the entire brushline erupts as a young Dryosaurus bursts straight toward you, panicked and kicking. You were ready to ambush prey — but not to have it crash into you first.",
		"combat_start": "The Dryosaurus slams through the brush and kicks wildly.",
		"button_fight": "Hold and fight.",
		"sublabel_fight": "Brace for the kick",
		"button_leave": "Back away from the rush.",
		"sublabel_leave": "Let it run past you",
		"prey": { "name": "a young Dryosaurus", "fight_power": 0.28, "hunger_value": 0.48, "size": 2 },
	},
	{
		"flavor": "A small Protoceratops backs around a rocky mound, breathing hard. You circle after it, expecting to trap it against stone.\n\nInstead, it was waiting on the other side.\n\nIts beaked head snaps forward as you step too close, turning your ambush into a face-to-face fight.",
		"combat_start": "The Protoceratops bites first.",
		"button_fight": "Fight back.",
		"sublabel_fight": "You are already in its range",
		"button_leave": "Get clear of the beak.",
		"sublabel_leave": "That beak aimed well",
		"prey": { "name": "a cornered Protoceratops", "fight_power": 0.38, "hunger_value": 0.55, "size": 3 },
	},
	{
		"flavor": "You follow a prey trail through trampled grass, certain you are closing in.\n\nA sharp chirp cuts through the air.\n\nAnother Deinonychus steps from the brush with feathers raised and claw lifted. The prey scent is forgotten for one dangerous heartbeat. The rival lunges to claim the hunt before you can.",
		"combat_start": "The rival Deinonychus attacks for dominance.",
		"button_fight": "Hold your ground.",
		"sublabel_fight": "Back down and it wins",
		"button_leave": "Back off.",
		"sublabel_leave": "Not worth a packmate fight",
		"prey": { "name": "a rival Deinonychus", "fight_power": 0.40, "hunger_value": 0.52, "size": 3 },
	},
	{
		"flavor": "You rush a limping ornithopod near the muddy edge of a stream. It stumbles, and you leap for what should be an easy strike.\n\nYour foot sinks.\n\nThe prey wheels around with desperate force, kicking mud into your face before your claws find purchase.",
		"combat_start": "The wounded prey kicks as you slip in the mud.",
		"button_fight": "Fight through the mud.",
		"sublabel_fight": "Find footing fast",
		"button_leave": "Pull back.",
		"sublabel_leave": "Mud makes everything worse",
		"prey": { "name": "an injured ornithopod", "fight_power": 0.25, "hunger_value": 0.50, "size": 2 },
	},
	{
		"flavor": "A fallen pterosaur flutters beside a broken branch, one wing dragging uselessly.\n\nYou close in fast.\n\nToo fast.\n\nThe pterosaur shrieks and throws itself at you, wings beating against your face while its beak jabs for your eyes.",
		"combat_start": "The pterosaur attacks in a panic.",
		"button_fight": "Fight through the wings.",
		"sublabel_fight": "Silence it before it calls",
		"button_leave": "Get away before it calls more.",
		"sublabel_leave": "That screech carries far",
		"prey": { "name": "a fallen pterosaur", "fight_power": 0.34, "hunger_value": 0.50, "size": 2 },
	},
	{
		"flavor": "A thick-tailed lizard crawls over warm stones, slow enough to tempt you. You rush from the side, aiming for its neck.\n\nThe tail whips faster than expected.\n\nIt cracks across your chest before you can bite, and the lizard turns with jaws wide.",
		"combat_start": "The lizard's tail strike starts the fight.",
		"button_fight": "Answer the tail.",
		"sublabel_fight": "Get inside its range",
		"button_leave": "Back out of range.",
		"sublabel_leave": "That tail has reach",
		"prey": { "name": "a thick-tailed lizard", "fight_power": 0.35, "hunger_value": 0.45, "size": 2 },
	},
	{
		"flavor": "You spot a young armored herbivore feeding with its head down. From the brush, it looks like a clean opening.\n\nThen you step closer and see the bony ridges along its back.\n\nIt turns suddenly, forcing its spines toward you and charging before you can reposition.",
		"combat_start": "The thornback juvenile drives into you defensively.",
		"button_fight": "Hold the line.",
		"sublabel_fight": "Find the gap in the spines",
		"button_leave": "Get clear of the spines.",
		"sublabel_leave": "Those ridges were not bluffing",
		"prey": { "name": "a thornback juvenile", "fight_power": 0.48, "hunger_value": 0.58, "size": 3 },
	},
	{
		"flavor": "A young Triceratops calf stands just beyond the safest edge of the herd. You creep closer, hoping to strike before it understands the danger.\n\nIts head snaps up.\n\nThe calf cries out and charges in panic, tiny horns lowered. Somewhere nearby, heavier footsteps begin to move.",
		"combat_start": "The calf charges before the herd arrives.",
		"button_fight": "Fight fast.",
		"sublabel_fight": "End it before the herd answers",
		"button_leave": "Retreat before the herd comes.",
		"sublabel_leave": "Those footsteps are getting louder",
		"prey": { "name": "a stray Triceratops calf", "fight_power": 0.58, "hunger_value": 0.68, "size": 4 },
	},
	{
		"flavor": "A young dome-headed herbivore stands near a fallen tree. It appears distracted, head lowered toward the ground.\n\nYou move in from the side.\n\nIt was not feeding. It was lining up a charge.\n\nThe skull hits before your claws do.",
		"combat_start": "The Pachycephalosaur charges first.",
		"button_fight": "Counter the charge.",
		"sublabel_fight": "Move fast or that skull lands",
		"button_leave": "Get out of the way.",
		"sublabel_leave": "That dome is built for this",
		"prey": { "name": "a young Pachycephalosaur", "fight_power": 0.55, "hunger_value": 0.62, "size": 3 },
	},
	{
		"flavor": "You find a nest beneath dry branches, the smell of eggs thick in the air.\n\nBefore you can reach them, a feathered Oviraptor bursts from cover, arms spread wide and beak snapping.\n\nThis is not a quiet meal anymore.",
		"combat_start": "The Oviraptor attacks to defend the nest.",
		"button_fight": "Drive it back.",
		"sublabel_fight": "Force it away from the nest",
		"button_leave": "Leave the nest.",
		"sublabel_leave": "That beak has reach",
		"prey": { "name": "a nest-guarding Oviraptor", "fight_power": 0.36, "hunger_value": 0.48, "size": 2 },
	},
	{
		"flavor": "A wounded juvenile Iguanodon limps along a muddy trail, separated from the herd.\n\nYou close in, expecting weakness.\n\nThe Iguanodon pivots with sudden strength and drives a thumb spike toward you before you can leap clear.",
		"combat_start": "The Iguanodon jabs with its thumb spike.",
		"button_fight": "Fight through the spike.",
		"sublabel_fight": "Get past it before the next jab",
		"button_leave": "Get clear.",
		"sublabel_leave": "That spike has range",
		"prey": { "name": "a wounded juvenile Iguanodon", "fight_power": 0.45, "hunger_value": 0.60, "size": 3 },
	},
	{
		"flavor": "You stalk movement near the riverbank, expecting a small injured animal.\n\nThe water opens.\n\nA low crocodyliform surges from the mud, jaws snapping inches from your leg. The river was not where prey came to die.\n\nIt was where predators waited.",
		"combat_start": "The crocodyliform ambushes from the water.",
		"button_fight": "Fight on dry ground.",
		"sublabel_fight": "Stay out of the water",
		"button_leave": "Get back from the water.",
		"sublabel_leave": "That ambush almost worked",
		"prey": { "name": "a small crocodyliform", "fight_power": 0.58, "hunger_value": 0.55, "size": 3 },
	},
	{
		"flavor": "You follow the sound of struggling prey beneath the roots.\n\nA giant monitor lizard is already there, tearing at the animal. When it sees you, it does not retreat.\n\nIt turns, hisses, and lunges as if you are the new meal.",
		"combat_start": "The monitor lizard attacks to defend its kill.",
		"button_fight": "Hold and fight.",
		"sublabel_fight": "Displace it or lose the meal",
		"button_leave": "Leave the kill site.",
		"sublabel_leave": "Not worth a predator fight",
		"prey": { "name": "a giant monitor lizard", "fight_power": 0.55, "hunger_value": 0.52, "size": 3 },
	},
	{
		"flavor": "A young hadrosaur feeds near a shallow stream, far enough from its group to tempt you.\n\nYou move one step too soon.\n\nIt spots you, screams, and surges forward in blind panic. Instead of running away, it barrels directly into your hiding place.",
		"combat_start": "The panicked hadrosaur crashes into you.",
		"button_fight": "Stand your ground.",
		"sublabel_fight": "Brace for the body weight",
		"button_leave": "Get clear of the rush.",
		"sublabel_leave": "That panic has momentum",
		"prey": { "name": "a young hadrosaur", "fight_power": 0.48, "hunger_value": 0.65, "size": 4 },
	},
	{
		"flavor": "A juvenile Ankylosaur shuffles through the ferns, low and slow. You circle behind it, looking for a weak angle.\n\nThe tail moves first.\n\nIt swings hard through the grass, forcing you into the open as the armored juvenile turns to face you.",
		"combat_start": "The Ankylosaur's tail swing forces combat.",
		"button_fight": "Get around the tail.",
		"sublabel_fight": "Find the gap while it resets",
		"button_leave": "Back away.",
		"sublabel_leave": "That tail controls the ground",
		"prey": { "name": "a juvenile Ankylosaur", "fight_power": 0.62, "hunger_value": 0.65, "size": 4 },
	},
]


func get_mixed_encounters() -> Array:
	return MIXED_ENCOUNTERS


const COMBAT_FLAVORS: Dictionary = {
	"win":    "You move as a unit — flanking, feinting, striking in sequence. The prey goes down clean. The pack feeds well tonight.",
	"win_inj":"The kill is yours, but someone got clipped mid-strike. It won't stop the hunt — but the pack notices who's limping.",
	"lose":   "The coordination breaks down. You push too hard without backup and take the worst of it. The pack falls back before it gets worse.",
	"escape": "It went bad fast. The prey turned the tables and the pack scattered. You got out — barely — and you're not whole anymore.",
}

func get_combat_flavors() -> Dictionary:
	return COMBAT_FLAVORS


const SCAVENGE_FINDS: Array = [
	{ "flavor": "You find a fresh kill abandoned after a larger predator was disturbed. You tear into the soft meat quickly, keeping your claws planted and your eyes on the brush.", "hunger_value": 0.25 },
	{ "flavor": "A torn haunch lies hidden beneath trampled ferns. It is not enough for a feast, but it is enough to keep hunger from slowing you down.",                             "hunger_value": 0.18 },
	{ "flavor": "You find sinew and bone fragments left behind by another hunter. It takes effort to strip them clean, but you manage a few useful bites.",                          "hunger_value": 0.12 },
]
const SCAVENGE_MISS: String = "The scent trails are old, and every promising mark leads to empty ground."

func get_scavenge_finds() -> Array:
	return SCAVENGE_FINDS

func get_scavenge_miss() -> String:
	return SCAVENGE_MISS
