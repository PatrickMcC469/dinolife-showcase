extends "res://scripts/dinos/base_dino_hunt.gd"

const CRITS: Array = [
	{
		"flavor": "A young herbivore feeds near the edge of thick brush, pulling leaves without watching the shadows behind it.\n\nYou lower your body, wait for the wind to shift, then explode forward.\n\nYour jaws hit first.\n\nThe fight ends before it truly begins.",
		"result": "You bring down prey with a perfect ambush.",
		"button": "Teeth before panic.",
		"hunger_gain": 0.60,
	},
	{
		"flavor": "A small herd scatters at the wrong moment. One younger animal breaks away from the others and runs toward open ground.\n\nThat is all you need.\n\nYou angle wide, cut it off, and strike before it can find the herd again.",
		"result": "You isolate prey and win quickly.",
		"button": "Separate it. End it.",
		"hunger_gain": 0.65,
	},
	{
		"flavor": "A prey animal bolts over a fallen log, but its back leg clips the bark. It stumbles hard, scrambling for balance.\n\nYou were already closing in.\n\nOne heavy step, one crushing bite, and the hunt is yours.",
		"result": "You exploit a stumble for an easy kill.",
		"button": "The forest helped.",
		"hunger_gain": 0.62,
	},
	{
		"flavor": "From a low ridge, you spot a young herbivore moving below. It has not seen you. The slope between you is steep, but clear.\n\nYou surge downhill with all your weight behind you.\n\nBy the time it looks up, the ground is already shaking.",
		"result": "You use momentum to overwhelm prey.",
		"button": "Let gravity hunt too.",
		"hunger_gain": 0.65,
	},
	{
		"flavor": "Your prey runs fast, but fear makes it sloppy. It turns too sharply near a patch of loose stones, legs sliding beneath it.\n\nYou do not waste the opening.\n\nYou lunge, clamp down, and the chase ends in dust.",
		"result": "You catch prey after a perfect chase mistake.",
		"button": "Fear turns badly.",
		"hunger_gain": 0.60,
	},
	{
		"flavor": "A mid-sized animal charges from cover, trying to escape past your side.\n\nYou pivot faster than it expects.\n\nYour jaws close around its shoulder, your weight drives it down, and the struggle is over almost immediately.",
		"result": "You overpower prey with a decisive bite.",
		"button": "Hold until it falls.",
		"hunger_gain": 0.62,
	},
	{
		"flavor": "A young prey animal runs along the riverbank, trapped between water and roots.\n\nYou do not chase straight behind it. You cut inland, moving through the trees to reach the bend first.\n\nIt rounds the curve.\n\nYou are waiting there.",
		"result": "You predict the escape path and intercept prey.",
		"button": "Meet it at the bend.",
		"hunger_gain": 0.65,
	},
	{
		"flavor": "A feeding herbivore steps closer and closer to the brushline, unaware of the shape waiting inside it.\n\nYou hold still until it is almost close enough to touch.\n\nThen the brush explodes.\n\nYour first bite decides the hunt.",
		"result": "You launch a flawless close-range ambush.",
		"button": "Burst from the green.",
		"hunger_gain": 0.62,
	},
	{
		"flavor": "A defensive prey animal swings its tail as you approach, trying to keep you away.\n\nYou stop just short.\n\nThe tail cuts through empty air. Before it can recover, you step in from the side and strike.",
		"result": "You punish a missed defense perfectly.",
		"button": "Too slow. Too wide.",
		"hunger_gain": 0.60,
	},
]


func get_crit_event() -> Dictionary:
	return CRITS[randi() % CRITS.size()]


const ENCOUNTERS: Array = [
	{
		"flavor": "A young Dryosaurus grazes near a patch of ferns, head lifting every few seconds. Its body is light, its legs are quick, and it is close enough to thick brush that one bad approach could lose it.\n\nYou could rush now.\n\nBut if it bolts cleanly, the chase may cost you.",
		"button_fight": "Rush now.",
		"sublabel_fight": "Commit before it spots you",
		"button_leave": "Wait for better prey.",
		"sublabel_leave": "A chase may not be worth it",
		"prey": { "name": "a young Dryosaurus", "fight_power": 0.22, "hunger_value": 0.58, "size": 3 },
	},
	{
		"flavor": "A juvenile Camptosaurus feeds near the edge of a clearing, tugging leaves from low branches. It is not fully grown, but it is sturdy enough to fight for its life.\n\nWhen it notices you, it stiffens and shifts its weight toward its back legs.\n\nThose kicks could hurt.",
		"button_fight": "Engage before it kicks.",
		"sublabel_fight": "Close fast and hold it",
		"button_leave": "Move on.",
		"sublabel_leave": "Those legs look strong",
		"prey": { "name": "a juvenile Camptosaurus", "fight_power": 0.32, "hunger_value": 0.62, "size": 3 },
	},
	{
		"flavor": "You catch the scent of fresh blood and find a small ornithopod limping through trampled grass. One leg drags, but its eyes are sharp and its body turns before you can fully circle it.\n\nIt is weakened.\n\nNot finished.",
		"button_fight": "Press the advantage.",
		"sublabel_fight": "Wounded still means dangerous",
		"button_leave": "Leave it.",
		"sublabel_leave": "Find something with nothing left to fight with",
		"prey": { "name": "a wounded ornithopod", "fight_power": 0.28, "hunger_value": 0.62, "size": 3 },
	},
	{
		"flavor": "A young Stegosaurus browses near a fallen tree, its plates still small but its tail already dangerous. It turns sideways when you approach, keeping its head low and its tail between you and the meal.\n\nIt is slow.\n\nThat does not make it safe.",
		"button_fight": "Get around the tail.",
		"sublabel_fight": "Time the angle carefully",
		"button_leave": "Avoid the spikes.",
		"sublabel_leave": "That tail will find you",
		"prey": { "name": "a young Stegosaurus", "fight_power": 0.52, "hunger_value": 0.72, "size": 5 },
	},
	{
		"flavor": "A young sauropod has drifted too far from the herd, stretching its neck toward leaves above a rocky slope. It is larger than most prey you hunt, but still young enough to fall.\n\nIf it cries out, the herd may notice.\n\nIf it stomps you, you will notice first.",
		"button_fight": "Strike fast.",
		"sublabel_fight": "Silence it before the herd hears",
		"button_leave": "Retreat.",
		"sublabel_leave": "That herd is too close",
		"prey": { "name": "a stray juvenile sauropod", "fight_power": 0.55, "hunger_value": 0.80, "size": 6 },
	},
	{
		"flavor": "A young spiked herbivore noses through dry plants, its tail twitching behind it. The moment it sees you, it lowers its body and angles its spikes toward your path.\n\nThere is food here.\n\nThere is also a very clear warning.",
		"button_fight": "Fight through the spikes.",
		"sublabel_fight": "Find the opening in the defense",
		"button_leave": "Look for softer prey.",
		"sublabel_leave": "Those spikes know what they are for",
		"prey": { "name": "a juvenile Kentrosaurus", "fight_power": 0.62, "hunger_value": 0.72, "size": 5 },
	},
	{
		"flavor": "Another Allosaurus steps from the trees, jaws parted, eyes fixed on you. Between you both is the scent trail of the same prey animal.\n\nNeither of you has claimed it yet.\n\nBut one of you is about to.",
		"button_fight": "Fight for the ground.",
		"sublabel_fight": "Make it clear whose territory this is",
		"button_leave": "Back down.",
		"sublabel_leave": "A rival Allosaurus is a serious fight",
		"prey": { "name": "a rival Allosaurus", "fight_power": 0.70, "hunger_value": 0.75, "size": 6 },
	},
	{
		"flavor": "A horned predator tears into a small animal near a stream. It lifts its head when it smells you, blood on its jaws and a warning rumble in its throat.\n\nThis is not helpless prey.\n\nThis is another hunter deciding whether you are worth biting.",
		"button_fight": "Take the kill.",
		"sublabel_fight": "Displace it by force",
		"button_leave": "Leave the kill site.",
		"sublabel_leave": "Not worth a predator fight",
		"prey": { "name": "a Ceratosaurus challenger", "fight_power": 0.65, "hunger_value": 0.68, "size": 5 },
	},
	{
		"flavor": "A young, thumb-spiked herbivore feeds near a muddy trail, separated from the others. When it spots you, it turns its shoulder toward you and raises its forelimbs defensively.\n\nIt is scared.\n\nIt is also armed.",
		"button_fight": "Charge through the defense.",
		"sublabel_fight": "Those spikes have range",
		"button_leave": "Let it rejoin the herd.",
		"sublabel_leave": "The herd will close the gap soon",
		"prey": { "name": "a young thumb-spiked herbivore", "fight_power": 0.42, "hunger_value": 0.68, "size": 4 },
	},
	{
		"flavor": "Near the riverbank, a low armored reptile lies half-submerged, watching the shore with still eyes. At first glance, it looks like an easy ambush.\n\nThen the water ripples around its tail.\n\nYou are not the only predator here.",
		"button_fight": "Fight on dry ground.",
		"sublabel_fight": "Stay out of the water",
		"button_leave": "Avoid the water.",
		"sublabel_leave": "This one hunts back",
		"prey": { "name": "a river crocodyliform", "fight_power": 0.62, "hunger_value": 0.60, "size": 4 },
	},
	{
		"flavor": "An adult Dryosaurus freezes beside a stand of ferns. It is smaller than you, but fast, alert, and clearly ready to explode into motion.\n\nIf you commit, you need to end this quickly.\n\nA long chase favors the prey.",
		"button_fight": "Chase it down.",
		"sublabel_fight": "First strike has to land",
		"button_leave": "Save your energy.",
		"sublabel_leave": "A long chase is a wasted season",
		"prey": { "name": "an adult Dryosaurus", "fight_power": 0.40, "hunger_value": 0.65, "size": 4 },
	},
	{
		"flavor": "A Stegosaurus calf limps near the edge of its herd, one back leg stiff with pain. Its tail spikes are small, but they twitch wildly every time you move.\n\nThe meal is tempting.\n\nThe herd is close.",
		"button_fight": "Strike fast.",
		"sublabel_fight": "End it before the adults turn",
		"button_leave": "Retreat before adults notice.",
		"sublabel_leave": "The herd is too close to risk it",
		"prey": { "name": "an injured Stegosaurus calf", "fight_power": 0.50, "hunger_value": 0.70, "size": 5 },
	},
	{
		"flavor": "A large lizard basks across a warm slab of stone, thick skin folded along its sides. It watches you approach without fleeing.\n\nWhen you step closer, it whips its tail and opens its jaws.\n\nThis one has survived other hunters.",
		"button_fight": "Force through the hide.",
		"sublabel_fight": "That skin takes real effort",
		"button_leave": "Move on.",
		"sublabel_leave": "Too tough for the meal it offers",
		"prey": { "name": "a thick-hided lizard", "fight_power": 0.42, "hunger_value": 0.62, "size": 4 },
	},
	{
		"flavor": "A juvenile armored herbivore shuffles through the low plants, plates already hard across its back. Its tail club is not fully grown, but it swings with stubborn confidence.\n\nIt is slow enough to catch.\n\nHard enough to regret.",
		"button_fight": "Find the gap.",
		"sublabel_fight": "That armor has a weak point somewhere",
		"button_leave": "Avoid the walking shield.",
		"sublabel_leave": "That tail will catch you eventually",
		"prey": { "name": "a juvenile Ankylosaur", "fight_power": 0.65, "hunger_value": 0.72, "size": 5 },
	},
	{
		"flavor": "A young hadrosaur feeds near a shallow stream, farther from its group than it should be. It is large enough to feed you well, but its legs are powerful and its panic could turn dangerous.\n\nYou can feel the opening.\n\nYou can also feel the risk.",
		"button_fight": "Commit to the strike.",
		"sublabel_fight": "One good hit decides this",
		"button_leave": "Wait for something smaller.",
		"sublabel_leave": "Panicked hadrosaurs kick hard",
		"prey": { "name": "an isolated young hadrosaur", "fight_power": 0.52, "hunger_value": 0.78, "size": 5 },
	},
]


func get_encounters() -> Array:
	return ENCOUNTERS


const MIXED_ENCOUNTERS: Array = [
	{
		"flavor": "You push through the ferns toward a young Dryosaurus, expecting it to bolt away from you.\n\nInstead, it bursts straight out of cover in panic.\n\nIts back legs lash wildly as it crashes into your path, turning your clean ambush into a sudden scramble of teeth, claws, and kicking feet.",
		"combat_start": "The Dryosaurus kicks as it panics through the ferns.",
		"button_fight": "Hold your ground.",
		"sublabel_fight": "Catch it before it rights itself",
		"button_leave": "Let it crash past.",
		"sublabel_leave": "Those legs are everywhere",
		"prey": { "name": "a young Dryosaurus", "fight_power": 0.22, "hunger_value": 0.58, "size": 3 },
	},
	{
		"flavor": "A juvenile Camptosaurus feeds near the clearing edge. You rush before it can reach the trees.\n\nIt sees you just in time.\n\nInstead of running cleanly, it throws its weight sideways and slams into you, forcing the hunt into a close fight.",
		"combat_start": "The Camptosaurus shoves into you before fleeing.",
		"button_fight": "Stay on it.",
		"sublabel_fight": "Don't lose the angle",
		"button_leave": "Let it go.",
		"sublabel_leave": "It bought itself enough time",
		"prey": { "name": "a juvenile Camptosaurus", "fight_power": 0.35, "hunger_value": 0.65, "size": 4 },
	},
	{
		"flavor": "The scent of blood pulls you toward a wounded ornithopod limping through trampled grass.\n\nYou close in too confidently.\n\nThe injured prey wheels around with desperate strength, kicking hard before your jaws can find the weak side.",
		"combat_start": "The wounded ornithopod fights back in panic.",
		"button_fight": "Power through the defense.",
		"sublabel_fight": "Desperate prey hits hardest",
		"button_leave": "Back off and regroup.",
		"sublabel_leave": "That kick had real force behind it",
		"prey": { "name": "a wounded ornithopod", "fight_power": 0.40, "hunger_value": 0.72, "size": 4 },
	},
	{
		"flavor": "A young Stegosaurus browses near a fallen tree, slow and tempting.\n\nYou step closer, aiming for its flank.\n\nThe tail moves before the body does.\n\nSpikes cut through the air as the Stegosaurus swings hard, forcing you into combat before you can choose your angle.",
		"combat_start": "The Stegosaurus tail lashes toward you.",
		"button_fight": "Get past the tail.",
		"sublabel_fight": "Time the swing before you commit",
		"button_leave": "Back out of reach.",
		"sublabel_leave": "Those spikes reset fast",
		"prey": { "name": "a young Stegosaurus", "fight_power": 0.55, "hunger_value": 0.72, "size": 5 },
	},
	{
		"flavor": "A stray juvenile sauropod stretches toward low branches, far from the herd's safest center.\n\nYou charge.\n\nIt cries out and stumbles backward, but its huge foot comes down directly in your path. The ground shakes, and the hunt becomes a dangerous close-quarters fight.",
		"combat_start": "The sauropod stomps in panic.",
		"button_fight": "Stay inside the stomp.",
		"sublabel_fight": "Too close for its feet to land cleanly",
		"button_leave": "Get clear of the legs.",
		"sublabel_leave": "One stomp ends the fight your way",
		"prey": { "name": "a stray juvenile sauropod", "fight_power": 0.50, "hunger_value": 0.82, "size": 6 },
	},
	{
		"flavor": "You spot a juvenile Kentrosaurus moving through dry plants and circle for what looks like an open side.\n\nThen it turns.\n\nThe spikes are suddenly exactly where you planned to bite, and the animal drives toward you before you can back off.",
		"combat_start": "The Kentrosaurus forces its spikes toward you.",
		"button_fight": "Redirect and find the gap.",
		"sublabel_fight": "The angle you wanted is gone",
		"button_leave": "Clear the spikes.",
		"sublabel_leave": "It won this position",
		"prey": { "name": "a juvenile Kentrosaurus", "fight_power": 0.60, "hunger_value": 0.68, "size": 5 },
	},
	{
		"flavor": "You follow a strong prey scent through the forest, certain the meal is close.\n\nA low growl stops you.\n\nAnother Allosaurus steps from the trees, jaws parted, eyes locked on yours. The prey trail no longer matters. The rival lunges first.",
		"combat_start": "The rival Allosaurus attacks to claim the hunting ground.",
		"button_fight": "Stand your ground.",
		"sublabel_fight": "Give nothing or lose everything",
		"button_leave": "Retreat from the territory.",
		"sublabel_leave": "Two Allosaurus fights leave two injured",
		"prey": { "name": "a rival Allosaurus", "fight_power": 0.70, "hunger_value": 0.65, "size": 6 },
	},
	{
		"flavor": "You approach the sound of struggling prey near a stream.\n\nA Ceratosaurus is already there.\n\nIt lifts its bloodied head, gives one warning growl, then charges before you can decide whether the meal is worth sharing.",
		"combat_start": "The Ceratosaurus charges to defend its kill.",
		"button_fight": "Take the fight.",
		"sublabel_fight": "The kill and the ground both go to the winner",
		"button_leave": "Back away from the kill.",
		"sublabel_leave": "Not your meal yet",
		"prey": { "name": "a Ceratosaurus challenger", "fight_power": 0.62, "hunger_value": 0.70, "size": 5 },
	},
	{
		"flavor": "A young thumb-spiked herbivore limps near a muddy trail, separated from safety.\n\nYou rush in from the side.\n\nIt pivots faster than expected, driving a sharp thumb spike toward your chest and turning weakness into a trap.",
		"combat_start": "The herbivore jabs with its thumb spike.",
		"button_fight": "Push past the spike.",
		"sublabel_fight": "Force it before it can reset",
		"button_leave": "Pull back.",
		"sublabel_leave": "That thing moved faster than it looked",
		"prey": { "name": "a young thumb-spiked herbivore", "fight_power": 0.45, "hunger_value": 0.68, "size": 4 },
	},
	{
		"flavor": "A low armored shape lies near the riverbank. You mistake it for slow prey and step too close.\n\nThe water erupts.\n\nA crocodyliform surges from the mud, jaws snapping toward your leg. The river was waiting for you.",
		"combat_start": "The crocodyliform ambushes from the waterline.",
		"button_fight": "Drag it onto dry ground.",
		"sublabel_fight": "Get it away from the water",
		"button_leave": "Lunge back from the bank.",
		"sublabel_leave": "The water is its weapon",
		"prey": { "name": "a river crocodyliform", "fight_power": 0.58, "hunger_value": 0.55, "size": 4 },
	},
	{
		"flavor": "An adult Dryosaurus bolts from the ferns. You chase hard, expecting it to run straight for open ground.\n\nIt does not.\n\nIt cuts sharply across your path, kicking up dirt and slamming into your legs as you overcommit.",
		"combat_start": "The Dryosaurus cuts back and kicks wildly.",
		"button_fight": "Correct and close.",
		"sublabel_fight": "Recover the angle fast",
		"button_leave": "Let the cutback carry it clear.",
		"sublabel_leave": "You overcommitted already",
		"prey": { "name": "an adult Dryosaurus", "fight_power": 0.32, "hunger_value": 0.68, "size": 4 },
	},
	{
		"flavor": "An injured Stegosaurus calf limps near the edge of its herd.\n\nYou move in quickly.\n\nToo quickly.\n\nThe calf shrieks and swings its small tail spikes in every direction. Larger shapes begin shifting nearby, but the fight has already started.",
		"combat_start": "The calf attacks in panic as the herd begins to notice.",
		"button_fight": "End it fast.",
		"sublabel_fight": "Finish before the herd responds",
		"button_leave": "Break off now.",
		"sublabel_leave": "The herd is already moving",
		"prey": { "name": "an injured Stegosaurus calf", "fight_power": 0.38, "hunger_value": 0.60, "size": 4 },
	},
	{
		"flavor": "A thick-hided lizard basks on a warm slab of stone. It looks slow enough to take with one bite.\n\nYou lunge.\n\nIts tail cracks against your jaw before your teeth land, and it whips around with its mouth open wide.",
		"combat_start": "The lizard's tail strike starts the fight.",
		"button_fight": "Get past the tail and finish.",
		"sublabel_fight": "That tail swings again fast",
		"button_leave": "Back off the slab.",
		"sublabel_leave": "Not worth another hit to the jaw",
		"prey": { "name": "a thick-hided lizard", "fight_power": 0.28, "hunger_value": 0.40, "size": 3 },
	},
	{
		"flavor": "A juvenile Ankylosaur shuffles through low plants, slow and heavy.\n\nYou circle behind it.\n\nThe tail swings first.\n\nEven unfinished, the club carries enough force to make you stumble. The armored juvenile turns to face you, low and stubborn.",
		"combat_start": "The Ankylosaur's tail club forces you back.",
		"button_fight": "Find the gap before it resets.",
		"sublabel_fight": "Get low and get past the tail",
		"button_leave": "Back out of club range.",
		"sublabel_leave": "That swing answers every approach",
		"prey": { "name": "a juvenile Ankylosaur", "fight_power": 0.55, "hunger_value": 0.65, "size": 5 },
	},
	{
		"flavor": "An isolated young hadrosaur feeds near a shallow stream. You step from cover, expecting it to flee away from you.\n\nIt panics in the wrong direction.\n\nThe hadrosaur barrels straight toward you, shoulder lowered, water and mud flying beneath its feet.",
		"combat_start": "The hadrosaur slams forward in panic.",
		"button_fight": "Brace and redirect.",
		"sublabel_fight": "Meet the body weight or get run over",
		"button_leave": "Throw yourself clear.",
		"sublabel_leave": "That bulk will carry it right through you",
		"prey": { "name": "an isolated young hadrosaur", "fight_power": 0.52, "hunger_value": 0.78, "size": 5 },
	},
]


func get_mixed_encounters() -> Array:
	return MIXED_ENCOUNTERS


const COMBAT_FLAVORS: Dictionary = {
	"win":    "You hit hard and you hit first. The prey doesn't get a second chance. A clean, powerful kill — the kind that comes easy when size and timing align.",
	"win_inj":"The kill lands, but the prey fought back harder than you wanted. You walk away victorious and bleeding. Worth it — for now.",
	"lose":   "Too much resistance, not enough opening. You absorb punishment you didn't plan for and back off before the damage compounds.",
	"escape": "This was a disaster. You're moving heavy and hurting, and the thing that did this to you is still out there. Get distance. Now.",
}

func get_combat_flavors() -> Dictionary:
	return COMBAT_FLAVORS


const SCAVENGE_FINDS: Array = [
	{ "flavor": "You find a large carcass recently abandoned near the treeline. There is still enough meat on it to make the search feel worth every step.", "hunger_value": 0.25 },
	{ "flavor": "A torn piece of prey lies beside a muddy trail, likely dropped during a chase. You gulp it down before rivals catch the scent.",           "hunger_value": 0.18 },
	{ "flavor": "You find old bones with a little meat clinging between them. It is not satisfying, but it is better than an empty gut.",                   "hunger_value": 0.12 },
]
const SCAVENGE_MISS: String = "You search the brush and dry streambeds, but every scent is too old to follow."

func get_scavenge_finds() -> Array:
	return SCAVENGE_FINDS

func get_scavenge_miss() -> String:
	return SCAVENGE_MISS
