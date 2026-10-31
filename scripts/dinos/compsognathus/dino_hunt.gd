extends "res://scripts/dinos/base_dino_hunt.gd"

const CRITS: Array = [
	{
		"flavor": "A small lizard basks on a warm stone, completely unaware of you. You freeze, then creep closer with tiny careful steps. By the time it opens one eye, you are already moving.\n\nOne quick snap, one surprised twitch, and the hunt is over.",
		"result": "You catch an easy meal.",
		"button": "Swallow it fast.",
		"hunger_gain": 0.35,
	},
	{
		"flavor": "You hear faint scratching beneath loose tree bark. With a quick tug and a sharper bite, you peel it back and uncover a cluster of fat beetles hiding underneath.\n\nThey scatter too slowly.\n\nToday, being small is an advantage.",
		"result": "You feast on insects.",
		"button": "Crunch while they run.",
		"hunger_gain": 0.38,
	},
	{
		"flavor": "A tiny skink limps through the leaves, dragging one back leg. It is still quick, but not quick enough.\n\nYou rush from the ferns, snap once, and pin it before it can reach the roots.",
		"result": "You catch weakened prey.",
		"button": "Take the lucky meal.",
		"hunger_gain": 0.35,
	},
	{
		"flavor": "Other compies rustle through the ferns nearby, startling a small creature straight toward you. You barely have to chase.\n\nIt bursts from cover, sees you too late, and runs directly into your jaws.",
		"result": "The pack helps you catch prey.",
		"button": "Good pack. Better timing.",
		"hunger_gain": 0.40,
	},
	{
		"flavor": "A small frog springs from the mud beside a puddle. It lands badly, slips, and freezes.\n\nYou pounce before it can jump again.\n\nThe mud almost did the hunting for you.",
		"result": "You catch slippery prey.",
		"button": "Snap it up.",
		"hunger_gain": 0.28,
	},
	{
		"flavor": "A tiny mammal noses through fallen leaves, searching for seeds. The wind hides your scent. The leaves hide your feet. Even your breathing seems quiet.\n\nYou strike from cover with perfect timing.",
		"result": "You complete a flawless ambush.",
		"button": "That was clean.",
		"hunger_gain": 0.40,
	},
	{
		"flavor": "A large dragonfly lands on a reed just above your head, wings glittering in the sunlight. You wait. One blink. One twitch.\n\nThen you leap.\n\nYour jaws close around it before the wings can blur.",
		"result": "You catch a quick airborne snack.",
		"button": "Wings count as food.",
		"hunger_gain": 0.18,
	},
	{
		"flavor": "A tiny hatchling from another nest wanders too far into the open. It chirps softly, confused and alone.\n\nYou do not hesitate. In the wild, hesitation feeds someone else.",
		"result": "You catch vulnerable prey.",
		"button": "The wild wastes nothing.",
		"hunger_gain": 0.42,
	},
	{
		"flavor": "A cracked fruit lies rotting under a tree, buzzing with insects. You nose it open and find pale grubs packed inside the soft pulp.\n\nNot every hunt needs a chase.",
		"result": "You find a rich insect meal.",
		"button": "Dig in.",
		"hunger_gain": 0.38,
	},
	{
		"flavor": "A thin tail flicks from beneath a pile of leaves. The rest of the animal thinks it is hidden.\n\nIt is not.\n\nYou bite down, drag it free, and end the hunt before it begins.",
		"result": "You catch hidden prey.",
		"button": "Never leave the tail out.",
		"hunger_gain": 0.35,
	},
]


func get_crit_event() -> Dictionary:
	return CRITS[randi() % CRITS.size()]


const ENCOUNTERS: Array = [
	{
		"flavor": "A quick skink darts between stones, but you cut off its escape route. It turns suddenly, mouth open, tail whipping through the dust.\n\nIt is smaller than you, but desperate prey does not go quietly.",
		"button_fight": "Snap it.",
		"sublabel_fight": "End the chase",
		"button_leave": "Let it scatter.",
		"sublabel_leave": "Not worth the risk",
		"prey": { "name": "a cornered skink", "fight_power": 0.08, "hunger_value": 0.16, "size": 1 },
	},
	{
		"flavor": "A large beetle crawls across a rotting log, its shell dark and hard like polished stone. When you step closer, it raises its body and clicks its jaws.\n\nThere is meat inside that shell, but cracking it will take effort.",
		"button_fight": "Crack the shell.",
		"sublabel_fight": "Force through the armor",
		"button_leave": "Leave it.",
		"sublabel_leave": "Not worth the effort",
		"prey": { "name": "an armored beetle", "fight_power": 0.12, "hunger_value": 0.10, "size": 1 },
	},
	{
		"flavor": "A squat lizard basks under a patch of sun, tiny spines running down its back. It notices you immediately and puffs itself wider, warning you away.\n\nIt is edible. It is also pointy.",
		"button_fight": "Fight through the spines.",
		"sublabel_fight": "Accept the scratches",
		"button_leave": "Search elsewhere.",
		"sublabel_leave": "Find easier prey",
		"prey": { "name": "a thornback lizard", "fight_power": 0.18, "hunger_value": 0.20, "size": 1 },
	},
	{
		"flavor": "A fat frog sits half-buried in mud beside a puddle. Its throat pulses as you creep closer.\n\nThen it turns toward you, wide-mouthed and ready to snap.",
		"button_fight": "Pin it before it slips.",
		"sublabel_fight": "Move fast",
		"button_leave": "Let it hop away.",
		"sublabel_leave": "Not worth the mud",
		"prey": { "name": "a mud frog", "fight_power": 0.08, "hunger_value": 0.14, "size": 1 },
	},
	{
		"flavor": "You find a young hatchling from another nest stumbling through the leaves. It is alone, but not helpless. When you approach, it squeals and snaps with surprising force.\n\nA soft meal, maybe.\n\nA noisy one, definitely.",
		"button_fight": "Risk the noise.",
		"sublabel_fight": "End it before it cries louder",
		"button_leave": "Back away quietly.",
		"sublabel_leave": "Avoid the attention",
		"prey": { "name": "a lost hatchling", "fight_power": 0.16, "hunger_value": 0.20, "size": 1 },
	},
	{
		"flavor": "A small furry creature limps beneath a root, dragging one back leg. It bares its teeth when you get close, cornered and shaking.\n\nIt is hurt, but fear can make small things dangerous.",
		"button_fight": "End it quickly.",
		"sublabel_fight": "It can still bite",
		"button_leave": "Leave it.",
		"sublabel_leave": "Find something easier",
		"prey": { "name": "a wounded mammal", "fight_power": 0.10, "hunger_value": 0.18, "size": 1 },
	},
	{
		"flavor": "Another young Compsognathus finds the same scrap of meat at the same time you do. Its head lowers. Its tail stiffens. It chirps once, sharp and challenging.\n\nThere is enough food for one of you.\n\nMaybe.",
		"button_fight": "Drive it off.",
		"sublabel_fight": "Contest the meal",
		"button_leave": "Walk away.",
		"sublabel_leave": "Not worth fighting your own kind",
		"prey": { "name": "a rival Compsognathus", "fight_power": 0.20, "hunger_value": 0.22, "size": 1 },
	},
	{
		"flavor": "A long centipede slides from beneath a rotten branch, legs rippling like a living shadow. It pauses, antennae twitching toward you.\n\nIt is small enough to kill.\n\nIt is venomous enough to make that a bad idea.",
		"button_fight": "Risk the venom.",
		"sublabel_fight": "High risk for the meal",
		"button_leave": "Leave this one.",
		"sublabel_leave": "Venom is not worth it",
		"prey": { "name": "a giant centipede", "fight_power": 0.30, "hunger_value": 0.14, "size": 1 },
	},
	{
		"flavor": "You uncover a cluster of pale insect eggs beneath bark — but a large beetle blocks your way. It scrapes its legs against the wood and lowers its head.\n\nThe eggs would be easy food.\n\nThe guard will not be.",
		"button_fight": "Get through the guard.",
		"sublabel_fight": "Fight for the eggs",
		"button_leave": "Abandon the nest.",
		"sublabel_leave": "Not worth the fight",
		"prey": { "name": "a guard beetle", "fight_power": 0.16, "hunger_value": 0.22, "size": 1 },
	},
	{
		"flavor": "A young lizard clings to the side of a fallen log, watching you with one bright eye. When you move closer, it darts upward, then turns as if deciding whether to flee or bite.\n\nYou might catch it before it climbs too high.\n\nOr it might catch your snout first.",
		"button_fight": "Catch it before it climbs.",
		"sublabel_fight": "Move now or lose it",
		"button_leave": "Let it escape upward.",
		"sublabel_leave": "Too risky",
		"prey": { "name": "a young tree lizard", "fight_power": 0.15, "hunger_value": 0.18, "size": 1 },
	},
	{
		"flavor": "A shallow puddle left by last night's rain holds a trapped fish, snapping at insects near the surface. It thrashes when your shadow crosses the water.\n\nIt cannot run.\n\nBut it can bite.",
		"button_fight": "Reach in and grab it.",
		"sublabel_fight": "Mind the teeth",
		"button_leave": "Leave it in the puddle.",
		"sublabel_leave": "Not worth the bite",
		"prey": { "name": "a trapped fish", "fight_power": 0.10, "hunger_value": 0.16, "size": 1 },
	},
	{
		"flavor": "A young pterosaur flutters awkwardly near a fallen branch, one wing still weak from its crash. It hisses when you approach, beak snapping in short warning jabs.\n\nIt looks fragile.\n\nThat beak does not.",
		"button_fight": "Take the risk.",
		"sublabel_fight": "Beak is dangerous",
		"button_leave": "Back off before it calls.",
		"sublabel_leave": "Avoid the attention",
		"prey": { "name": "a fallen pterosaur chick", "fight_power": 0.24, "hunger_value": 0.24, "size": 1 },
	},
	{
		"flavor": "Near a muddy bank, a small crab-like creature backs away with both claws raised. Its shell is broad, its legs skitter sideways, and it clearly wants no part of you.\n\nUnfortunately, it also smells like food.",
		"button_fight": "Get past the claws.",
		"sublabel_fight": "Force the opening",
		"button_leave": "Move on.",
		"sublabel_leave": "Not worth the pinch",
		"prey": { "name": "a shell-cracker crab", "fight_power": 0.18, "hunger_value": 0.18, "size": 1 },
	},
	{
		"flavor": "The grass moves without wind. A thin snake slides into view, tongue flicking as it coils near a warm stone.\n\nIt is not large.\n\nBut it is ready.",
		"button_fight": "Strike first.",
		"sublabel_fight": "Fast or don't bother",
		"button_leave": "Back away slowly.",
		"sublabel_leave": "Venom changes the odds",
		"prey": { "name": "a grass snake", "fight_power": 0.28, "hunger_value": 0.14, "size": 1 },
	},
	{
		"flavor": "A small feathered hatchling limps near the roots, separated from its nest. It is younger than you, but still built with claws, teeth, and panic.\n\nThis could be a valuable meal.\n\nOr the start of a noisy mistake.",
		"button_fight": "Take the meal.",
		"sublabel_fight": "Silence it fast",
		"button_leave": "Leave before it calls.",
		"sublabel_leave": "Not worth what hears it",
		"prey": { "name": "an injured raptor hatchling", "fight_power": 0.26, "hunger_value": 0.22, "size": 1 },
	},
]


func get_encounters() -> Array:
	return ENCOUNTERS


const MIXED_ENCOUNTERS: Array = [
	{
		"flavor": "You creep through the leaves after a thin lizard tail flicking beneath the brush.\n\nOne more step.\n\nThe leaves explode.\n\nYou did not find the lizard's hiding spot — you stepped directly on it. It twists around with a sharp hiss and snaps at your leg.",
		"combat_start": "The lizard strikes first.",
		"button_fight": "Fight back.",
		"sublabel_fight": "Take the hit and counter",
		"button_leave": "Break away.",
		"sublabel_leave": "Get distance before it bites again",
		"prey": { "name": "a grass lizard", "fight_power": 0.08, "hunger_value": 0.14, "size": 1 },
	},
	{
		"flavor": "Scratching sounds come from behind a rotting log. You lower your head, expecting beetles, grubs, or something soft enough to swallow.\n\nInstead, a large beetle bursts from the bark and clamps its jaws toward your snout.\n\nYou found food.\n\nFood disagrees.",
		"combat_start": "The beetle lunges from the rotten wood.",
		"button_fight": "Snap at it.",
		"sublabel_fight": "Crack the shell before it bites again",
		"button_leave": "Pull back.",
		"sublabel_leave": "Not worth those jaws",
		"prey": { "name": "an armored beetle", "fight_power": 0.12, "hunger_value": 0.10, "size": 1 },
	},
	{
		"flavor": "A muddy puddle ripples near your feet. You lean closer, watching for insects trapped on the surface.\n\nThe mud suddenly opens into a wide mouth.\n\nA frog launches straight at your face, all legs, slime, and panic.",
		"combat_start": "The frog springs at you before you can back away.",
		"button_fight": "Fight through the slime.",
		"sublabel_fight": "Pin it before it jumps again",
		"button_leave": "Back away.",
		"sublabel_leave": "Too slippery to be worth it",
		"prey": { "name": "a mud frog", "fight_power": 0.08, "hunger_value": 0.14, "size": 1 },
	},
	{
		"flavor": "You nose through a pile of soft leaves and find tiny eggs tucked beneath them.\n\nBefore you can bite down, something shrieks beside you.\n\nA small nest guardian rushes from cover, wings flapping and beak snapping.",
		"combat_start": "The nest guardian attacks to protect its eggs.",
		"button_fight": "Drive it off.",
		"sublabel_fight": "Silence it before it draws attention",
		"button_leave": "Retreat from the nest.",
		"sublabel_leave": "Not worth the noise",
		"prey": { "name": "a nest-guarding small creature", "fight_power": 0.14, "hunger_value": 0.16, "size": 1 },
	},
	{
		"flavor": "You follow the scent of fresh meat into the ferns. A scrap lies ahead, dark and tempting.\n\nYou dart forward.\n\nSo does another Compsognathus.\n\nYour heads nearly collide over the same prize. The rival chirps sharply, bares its teeth, and lunges before you can decide what to do.",
		"combat_start": "The rival compi attacks for the scrap.",
		"button_fight": "Snap back.",
		"sublabel_fight": "Contest the meal",
		"button_leave": "Let it have the scrap.",
		"sublabel_leave": "Not worth fighting your own kind",
		"prey": { "name": "a rival Compsognathus", "fight_power": 0.20, "hunger_value": 0.22, "size": 1 },
	},
	{
		"flavor": "A tiny mammal limps beneath a root, looking weak enough to catch.\n\nYou rush in.\n\nIt was not trapped. It was waiting.\n\nThe creature whips around and sinks its teeth toward your face with desperate speed.",
		"combat_start": "The cornered mammal bites first.",
		"button_fight": "Push through the bite.",
		"sublabel_fight": "It only has one move",
		"button_leave": "Back off fast.",
		"sublabel_leave": "Cornered animals bite hard",
		"prey": { "name": "a cornered tiny mammal", "fight_power": 0.12, "hunger_value": 0.18, "size": 1 },
	},
	{
		"flavor": "You peel back loose bark with your snout, chasing the smell of soft insects.\n\nToo many legs spill out.\n\nA long centipede erupts from the wood, antennae twitching, jaws already open.",
		"combat_start": "The centipede surges out of the bark.",
		"button_fight": "Pin it before it stings.",
		"sublabel_fight": "Fast or it finds your face",
		"button_leave": "Get away from it.",
		"sublabel_leave": "Venom is not worth the meal",
		"prey": { "name": "a giant centipede", "fight_power": 0.30, "hunger_value": 0.14, "size": 1 },
	},
	{
		"flavor": "A trapped fish thrashes in a shallow rain puddle. It looks helpless, flashing silver just beneath the water.\n\nYou step closer.\n\nThe fish snaps upward with surprising force, catching you before you can strike.",
		"combat_start": "The fish lashes out from the puddle.",
		"button_fight": "Fight through the bite.",
		"sublabel_fight": "Keep your head above the water",
		"button_leave": "Back out of the puddle.",
		"sublabel_leave": "Not worth wet feet and a bite",
		"prey": { "name": "a sharp-jawed fish", "fight_power": 0.10, "hunger_value": 0.16, "size": 1 },
	},
	{
		"flavor": "A small hatchling stumbles alone near the roots, chirping softly.\n\nEasy prey.\n\nYou rush toward it — and it wheels around faster than expected, kicking and snapping in wild panic.\n\nIt may be young, but it does not plan to die quietly.",
		"combat_start": "The hatchling panics and attacks.",
		"button_fight": "End the panic fast.",
		"sublabel_fight": "Silence it before something hears",
		"button_leave": "Back away.",
		"sublabel_leave": "That noise will carry",
		"prey": { "name": "a lost hatchling", "fight_power": 0.15, "hunger_value": 0.20, "size": 1 },
	},
	{
		"flavor": "The grass shifts ahead of you.\n\nYou freeze, watching for a lizard or beetle.\n\nThen the grass rises.\n\nA thin snake coils directly in your path, head already pulled back to strike. You are too close.",
		"combat_start": "The snake strikes from the grass.",
		"button_fight": "Strike before the second bite.",
		"sublabel_fight": "Speed is the only answer",
		"button_leave": "Back away slowly.",
		"sublabel_leave": "Venom changes everything",
		"prey": { "name": "a grass snake", "fight_power": 0.28, "hunger_value": 0.14, "size": 1 },
	},
	{
		"flavor": "You spot a young lizard clinging to a low branch. It looks down at you, still and bright-eyed.\n\nYou crouch to leap.\n\nThe lizard jumps first.\n\nIt lands on your back in a blur of claws and teeth.",
		"combat_start": "The tree lizard drops onto you.",
		"button_fight": "Shake it off and fight.",
		"sublabel_fight": "Get it off before it digs in",
		"button_leave": "Throw it and run.",
		"sublabel_leave": "Too close for comfort",
		"prey": { "name": "a young tree lizard", "fight_power": 0.16, "hunger_value": 0.18, "size": 1 },
	},
	{
		"flavor": "Something small skitters near the muddy bank. You rush toward it, expecting an easy bite.\n\nThe creature turns sideways and raises two hard claws.\n\nBefore you can stop, one claw snaps shut near your snout.",
		"combat_start": "The crab snaps as you rush in.",
		"button_fight": "Pin the claws.",
		"sublabel_fight": "Get past the arms fast",
		"button_leave": "Back away.",
		"sublabel_leave": "Those claws are at snout level",
		"prey": { "name": "a shell-cracker crab", "fight_power": 0.18, "hunger_value": 0.18, "size": 1 },
	},
	{
		"flavor": "A young pterosaur flutters weakly near a fallen branch. You move in, ready to finish the hunt quickly.\n\nIt sees you too soon.\n\nWith a piercing screech, it throws itself at you, beak jabbing wildly.",
		"combat_start": "The pterosaur chick attacks in panic.",
		"button_fight": "Fight through the screech.",
		"sublabel_fight": "End it before something hears",
		"button_leave": "Get away before it calls more.",
		"sublabel_leave": "That sound will bring trouble",
		"prey": { "name": "a fallen pterosaur chick", "fight_power": 0.22, "hunger_value": 0.24, "size": 1 },
	},
	{
		"flavor": "A squat lizard rests in a patch of sun, its spiny back rising and falling with each breath.\n\nYou creep closer.\n\nIts eye opens.\n\nThe lizard spins toward you, body puffed wide and jaws snapping before you can escape the open ground.",
		"combat_start": "The thornback lizard counterattacks.",
		"button_fight": "Fight through the spines.",
		"sublabel_fight": "Get past the display",
		"button_leave": "Back out of range.",
		"sublabel_leave": "Those spines are not bluffing",
		"prey": { "name": "a thornback lizard", "fight_power": 0.18, "hunger_value": 0.20, "size": 1 },
	},
	{
		"flavor": "A rich smell leads you beneath a tangle of roots. You push your head inside, expecting eggs, insects, or scraps.\n\nSomething growls in the dark.\n\nA small predator bursts from the root hollow and slams into you before you can pull back.",
		"combat_start": "The hidden predator ambushes you.",
		"button_fight": "Hold your ground.",
		"sublabel_fight": "You are already in the fight",
		"button_leave": "Pull back fast.",
		"sublabel_leave": "Get out of its territory",
		"prey": { "name": "a root-hollow predator", "fight_power": 0.24, "hunger_value": 0.20, "size": 1 },
	},
]


func get_mixed_encounters() -> Array:
	return MIXED_ENCOUNTERS


const COMBAT_FLAVORS: Dictionary = {
	"win": "Your feet found the angle before your mind finished deciding.\n\nOne dart in, a single clean snap, and the fight was already over — the prey's weight dropping before it could turn to face you properly.\n\nFast. Precise. The meal is yours.",

	"win_inj": "You got inside, but so did it.\n\nSomething caught you mid-lunge — a kick, a tail swipe, a desperate snap that found skin before you could pull clear. You finished the fight anyway, one side burning, still faster than the thing that tried to stop you.\n\nThe meal is yours. The pain came with it.",

	"lose": "The angle closed wrong and you felt it a heartbeat before it happened.\n\nThe impact was harder than your body could absorb cleanly. Your legs were already moving — breaking left into the ferns before your mind gave the order. Small things that stay too long get finished.\n\nYou got out. The meal stayed behind.",

	"escape": "It went wrong faster than you could understand it.\n\nThe hit landed deep, something along your side screaming as your legs kept moving beneath you anyway. No thought, no plan — just speed and leaves and the desperate hope that the sounds behind you would stop.\n\nThey did. Eventually.\n\nYou do not remember stopping.",
}


func get_combat_flavors() -> Dictionary:
	return COMBAT_FLAVORS


const SCAVENGE_FINDS: Array = [
	{ "flavor": "A cracked nest lies half-buried in soft soil, split open and abandoned. The eggs inside are small and cold but still whole.\n\nYou eat fast, one eye on the treeline, and are gone before anything larger follows the smell.", "hunger_value": 0.25 },
	{ "flavor": "Something larger made a kill here and left without finishing it. A half-eaten lizard rests in the shadow of a warm stone, still fresh enough to matter.\n\nYou tear off what you can carry and swallow it in three quick bites.", "hunger_value": 0.18 },
	{ "flavor": "A strip of dried meat clings to the underside of an old bone, half-hidden beneath leaf litter. It takes real effort to pull free and it is barely a mouthful once you do.\n\nBut hunger does not wait for better options.", "hunger_value": 0.12 },
	{ "flavor": "You track a faint blood smell through the roots until you find the source — a small carcass, mostly picked clean. What remains is gristle and scraps, but you work at it carefully.\n\nNot nothing. Not enough. But closer to both than before.", "hunger_value": 0.15 },
	{ "flavor": "A cluster of beetle larvae clings to the underside of rotting bark, pale and soft and completely undefended. You eat them all before the bark finishes falling.\n\nSmall meals add up.", "hunger_value": 0.10 },
]
const SCAVENGE_MISS: String = "You follow old smells and faint tracks through the undergrowth for longer than it should take.\n\nNothing. The ground here has already been picked over. You come back with empty jaws and less time than you started with."

func get_scavenge_finds() -> Array:
	return SCAVENGE_FINDS

func get_scavenge_miss() -> String:
	return SCAVENGE_MISS
