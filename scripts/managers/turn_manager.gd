extends Node

const LIFE_STORY = preload("res://scripts/systems/life_story.gd")
const COMPANIONS = preload("res://scripts/systems/companions.gd")

signal turn_started
signal turn_ended
signal event_fired(event_data: Dictionary)
signal stat_changed
signal life_stage_changed(new_stage: int)
signal run_ended

const HUNGER_DRAIN_ON_ZERO        := 0.55   # health lost per season while starving
const HUNGER_DECAY_MULT           := 2.5    # global multiplier on species hunger_decay (tune here)
const ELDER_HEALTH_DECAY_PER_SEASON := 0.04  # health ceiling drop per elder season
const CONSISTENCY_THRESHOLD_HIGH := 0.75
const CONSISTENCY_THRESHOLD_LOW := 0.25
const CONSISTENCY_TURNS_REQUIRED := 8
const MAX_BONUSES_PER_STAGE := 1
const ELDER_SEASONS_FALLBACK := 6

var _bonuses_this_stage: int = 0
var _stage_at_last_check: int = -1

# ── BIRTH FLAVOR ──────────────────────────────────────────────────────────────
# One entry per species. Fires once on the very first turn of a run.

const BIRTH_FLAVOR = {
	# Predator Tier 1
	"compsognathus":    "The shell breaks. Cold air. Others press close — you can hear them. The pack forms before any of you can hunt. You are already not alone.",
	"sinosauropteryx":  "You push through alone into the fern canopy. Feathers still damp, light filtering down. The forest does not know you are here yet. That is exactly right.",
	# Predator Tier 2
	"microraptor":      "Four limbs before the first breath. You test each one before the shell is fully open. A branch overhead — reachable. You file that away.",
	"troodon":          "The shell opens in the dark. You don't panic. You wait, listen, build the picture. When it is complete, you step out. The night already makes sense.",
	# Predator Tier 3
	"deinonychus":      "The nest is loud. The others hatched first and are already calling to each other. You add your voice. The pack forms before any of you can walk straight.",
	"dilophosaurus":    "You crack through alone. The crest ridges are soft, folded flat. They will harden. Everything starts soft and gets harder. You already know this somehow.",
	"bambiraptor":      "Fast out of the shell. Running before the others in the clutch have opened their eyes. Whatever this world is, you want to see all of it.",
	"ornitholestes":    "You open the shell and immediately go still. Something moves nearby. You wait until it passes, then emerge. Speed and patience. You have both from the start.",
	# Predator Tier 4
	"velociraptor":     "The clutch calls to each other before any of you break through. You are the last to hatch, but the first to stand. You find your place in the group quickly.",
	"carnotaurus":      "You burst through alone. Horn stubs blunt and soft, but the legs work fine — you cover ground before the light changes. Speed is already who you are.",
	"allosaurus":       "The shell splinters rather than cracks. Large pieces. You were bigger than it expected. You stand and the nest shifts under you. You take up space. This will be true for the rest of your life.",
	"troodon_alpha":    "You hatch at dusk. The others hatched hours before — you could hear them from inside, mapping the sounds, waiting. The timing was deliberate. Night is yours.",
	# Herbivore Tier 1
	"lesothosaurus":    "You burst from the shell and immediately run. Not from anything — just running, testing the legs. The herd moves around you like water. You are already part of it.",
	"microceratus":     "Small shell, smaller creature. But the horn nub is already there, hard against your forehead. You headbutt the last shell away and stand up. That's going to be the approach.",
	# Herbivore Tier 2
	"hypsilophodon":    "You hatch into open country, already oriented to movement. The herd flows and you find your place in it within minutes. Distance is your element. You can feel that already.",
	"fruitadens":       "Impossibly tiny. You test the legs and cover the ground around the nest three times before settling. Speed is the only protection you have. Good thing it works.",
	"othnielia":        "The herd is close when you break through — you can feel the vibration. You are upright before the last of the clutch has hatched. You keep pace from the start.",
	"changchunsaurus":  "The herd pressed close at your hatching. You are nudged, checked, accepted. The bond forms before you are dry. Family is the oldest thing you will ever have.",
	# Herbivore Tier 3
	"iguanodon":        "You hatch into the center of the herd. Larger shapes move carefully around you. The thumb spike is already there — a small hook, promising what it will become.",
	"kentrosaurus":     "The spikes are soft at hatching, folded flat. All there, every one. You shake yourself dry and they spread outward. Warning first. Always warning first.",
	"stegosaurus":      "The plates are skin ridges. The tail is already longer than your body. You flick it once, testing the weight. Slow to start. You have time.",
	"pachycephalosaurus":"The dome is already there, round and hard. The first thing you do after cracking through is lower your head and push against the nest wall. It holds. You push harder.",
	# Flyer Tier 1
	"anurognathus":     "Tiny. The whole clutch hatches in one burst of sound. The colony above shifts — they know. You are passed upward, passed along, and suddenly you are warm inside the mass of them.",
	"jeholopterus":     "You emerge in a crack in the bark, high up the tree. Below is enormous and dark. You grip the wood with both hands and wait. The night will explain everything.",
	# Flyer Tier 2
	"nemicolopterus":   "You hatch among the branches, one of a dozen. The canopy above is all gaps and routes. You are already reading them before you can fly.",
	"yi_qi":            "The bat-membranes are there at hatching — strange, sprawled flat. You spread them experimentally. This will always look strange. It works anyway.",
	"archaeopteryx":    "You crack through in the morning. Half-fall to the ground, pull yourself back up the trunk. Neither fully this nor fully that. You will learn to make it work.",
	"sordes":           "You hatch into the colony — warm, pressed-in, and loud. The fur is there from the start. You are held and fed immediately. You will never be alone if you choose the colony.",
	# Flyer Tier 3
	"pterodactylus":    "You hatch on the cliff ledge. Wind immediately. You watch the others flap and try — first attempt fails. You correct and try again. This is how you'll approach everything.",
	"rhamphorhynchus":  "You hatch at the water's edge. The long tail unfurls behind you. You step forward and your reflection watches from below. Two of you now, wherever there is water.",
	"pteranodon":       "The crest fold is soft but visible. You spread the wings and the thermals above the cliff pull at them. Not yet. But the pull is real.",
	"dsungaripterus":   "The beak tip is curved even now. You test it against the shell, then the rock, then a loose fragment. Built for pressure. You start learning what breaks.",
	# Predator Tier 5-7
	"yutyrannus":       "You break through into cold air. Feathers trap it — you are warm in seconds. The others in the nest crowd in. Something this size should not be this warm. It is.",
	"giganotosaurus":   "The shell gives way in pieces. You are large before you are fully out. The pack is already calling. You add your voice without knowing why. It feels right.",
	"carcharodontosaurus": "You hatch alone. The teeth are already there — small, serrated. You test them on the shell. They work. You file that away and step into the sun.",
	"spinosaurus":      "You hatch at the river's edge. Water nearby — you can smell it before you see it. You walk toward it immediately. This is where you belong.",
	"tarbosaurus":      "The shell opens in the early morning. Cold. You find your feet fast and press close to the nest wall. The cold is something to be solved. You already know this.",
	"trex":             "The egg cracks and then the shell explodes outward. You were not contained — you were patient. You stand and the nest feels immediately small. Everything will.",
	"trex_old_king":    "The egg cracks and then the shell explodes outward. You were not contained — you were patient. You stand and the nest feels immediately small. Everything will.",
	"spinosaurus_river_monster": "You hatch at the river's edge. Water nearby — you can smell it before you see it. You walk toward it immediately. The river already feels like it belongs to you.",
	"giganotosaurus_pack_matriarch": "The shell gives way in pieces. The pack is already calling. You add your voice and somehow, already, it sounds like a command.",
	"carcharodonto_red_maw": "You hatch alone. The teeth are already there. You test them on the shell. They work better than anything has a right to at this age.",
	# Herbivore Tier 4-7
	"triceratops":      "You hatch into the herd circle. Three horn stubs press against your face as you break through. Soft now. The frill is folded. Everything will open in time.",
	"ankylosaurus":     "You crack through slowly. The armor plates are already there — soft, but present. You feel the weight of them immediately. You will spend your life carrying this. It will be worth it.",
	"parasaurolophus":  "You hatch and immediately make a sound. The crest is small, the resonance thin — but it carries. The herd tilts toward it. You make the sound again.",
	"edmontosaurus":    "You hatch into the middle of everything. The herd does not slow. You find your feet inside the first minute and fall into step. This is the only pace you will ever know.",
	"diplodocus":       "The egg is enormous and so are you. The tail is there from the start, longer than seems reasonable. You flick it once. The others in the nest scatter slightly. Good.",
	"apatosaurus":      "You hatch into the herd's slow rhythm. Large shapes move carefully around you. You are already taller than most things you will meet in your first season. The rest will follow.",
	"brachiosaurus":    "The neck is there from hatching — already reaching upward before the rest of you is fully out. You crane it toward the canopy. This is the direction your life will go.",
	"shantungosaurus":  "You hatch loud. The crest is small but the sound it makes carries across the nesting ground. The herd responds. You do not know yet that this is power.",
	"argentinosaurus":  "The shell takes time to break. You are in no rush. When you finally stand, the nest feels small. The land around it feels appropriately large. You will fill it.",
	"dreadnoughtus":    "You hatch slowly, deliberately. The size is there from the start — more than the nest expected. You stand, and the ground registers it. Everything will register you from now on.",
	"patagotitan":      "The egg is the largest in the nesting ground. You are the largest thing to hatch from it. You stand, and the world makes room. It will keep doing that.",
	"supersaurus":      "You hatch into the long light of morning. The tail is already unreasonable in length. You test it against the nest wall. The wall gives. You remember this.",
	# Flyer Tier 4-7
	"cearadactylus":    "You hatch near the river. The teeth interlock when you close the jaw — you test them immediately. Something in the water below catches the light. You note it.",
	"tapejara":         "You hatch on a jungle ledge. The sail crest is folded flat. Warm air hits it and it rises slowly. You spread the wings. The canopy below looks like a map.",
	"anhanguera":       "You hatch on the cliff with others. The drop below is real and you all know it. You shuffle toward the edge immediately. The others do the same. None of you hesitate.",
	"ornithocheirus":   "You hatch on a coastal rock. The ocean is right there — enormous and loud. You spread the wings immediately. The wind off the water takes them. This is it.",
	"tropeognathus":    "You hatch on the cliff face. Wind immediately. The keel crest catches it and you feel the pull. Not yet — but the pull is real and you understand what it means.",
	"hatzegopteryx":    "You hatch on the ground. No cliff, no colony — just flat land and open sky. You stand and look both directions. The air above and the ground below. You will use both.",
	"cryodrakon":       "You hatch in the cold season. Other creatures would struggle. You find your temperature immediately — the feathers are already there. Cold is not a problem. It is a selection.",
	"quetzalcoatlus":   "The egg is enormous. You are larger. When you stand, the wingspan is already wider than three of you laid end to end. The sky above tilts toward you. You feel that.",
	"quetzal_sky_tyrant":    "You hatch enormous. The wingspan settles immediately. The sky above tilts toward you — not a sensation, a fact. This is already yours.",
	"hatzegopteryx_bonebreaker": "You hatch on the ground and look both directions — sky and land. You choose both immediately. Everything that moves is being evaluated.",
	"cryodrakon_frostwing":  "You hatch in the cold. Other things struggle with this. You don't. The cold is not a problem. It is information about what you were built for.",
	"arambourgiania":        "The egg is enormous. When you stand, the wingspan settles to its full width. You turn and face every direction once. All of it is the route. All of it is yours.",
	# Tree fallbacks (used if species has no specific entry)
	"_predator":        "You break from the shell into a world that has no patience. Something moves. You note it. You are already hunting, in your way.",
	"_herbivore":       "You break from the shell and the herd is already moving around you. You find your footing and fall into step. This is how it will go.",
	"_flyer":           "You hatch high up, with wind. The drop below is real. You grip the rock and watch the sky. This is your world now.",
}

# ── STAGE-UP FLAVOR ───────────────────────────────────────────────────────────
# Indexed by life_stage value after the transition (1=Juvenile, 2=Sub-adult, 3=Adult, 4=Elder).
# Per-species entries override tree fallbacks.

const STAGE_UP_FLAVOR = {
	# ── Per-species overrides ──
	"allosaurus": [
		"Growing fast. You are already bigger than things that considered you prey last season.",
		"Nearly there. The prey animals have started adjusting their routes. Word travels.",
		"Apex. The full weight of what you are settles into every step. The ground remembers you passing.",
		"Slower, but nothing moves through your range without your knowing. The body has been everywhere. It does not forget.",
	],
	"velociraptor": [
		"The pack moves with you now — not around you. That shift happened without a decision.",
		"You have run enough hunts to know the difference between a good plan and a lucky one. The pack is starting to learn that too.",
		"The pack reads you without signals now. Coordination has become instinct. This is what you were building toward.",
		"The young ones watch how you move. Your patterns have become their training. The pack carries what you've taught it.",
	],
	"troodon_alpha": [
		"The dark is easier now. You map it without thinking.",
		"The pack defers to your hunts. They have learned that your routes are better. They don't know why. They don't need to.",
		"The nights belong to you. The pack no longer questions the calls — it reads them. You have become the intelligence that leads.",
		"Slower in the body but not in the mind. You have hunted every hour of every season. You know what moves before it moves.",
	],
	"carnotaurus": [
		"The legs have length now. Something faster than you would have to exist to outrun you, and it doesn't.",
		"You closed on a full-grown prey animal this season and felt, for the first time, that nothing in this world is actually faster than you in a straight line.",
		"The horns are sharp and the stride is full. You are what the species promised you'd be. Everything else is slower.",
		"The sprints are shorter now. But you are still the one thing in this range that closes ground in seconds. That has not changed.",
	],
	"stegosaurus": [
		"The plates have started hardening. Heat moves through them differently on warm days — steadier, more even.",
		"The plates are fully formed. Hot seasons are easier now. The cold cuts less. You are built for the long run.",
		"Full size. The thagomizer has weight behind it now. The last predator that tested it did not test it again.",
		"Slow and enormous and old. The herd moves around you like you are geography. You have earned that.",
	],
	"pachycephalosaurus": [
		"The dome is firming up. You test it on a rock. Promising.",
		"Full dome. You know this because you tested it against a rival and they backed away. You are what you were growing toward.",
		"No hesitation before a charge anymore. The dome and the speed and the decision all arrive at the same time.",
		"The charges are shorter. The rivals don't need a full run anymore — they see you lower your head and they step aside.",
	],
	"kentrosaurus": [
		"The spikes are still growing but they're hard enough to matter. Something tested one. It regretted it.",
		"The spikes have fully hardened. What was warning is now architecture. You carry twenty reasons not to approach, and you know how to use each one.",
		"No predator in this range approaches you without pausing. The pause is the point.",
		"The herd orbits you now. They know that predators don't test the creature covered in spikes. Your presence makes the whole group safer.",
	],
	"pteranodon": [
		"The wingspan is filling out. You feel the thermals taking more of your weight. Less work for the same distance.",
		"The crest is prominent now. The thermals read it differently — catching, pulling. You cover more ground with less effort. This is what you were built for.",
		"Full wingspan. You ride thermals other flyers can't access. The ocean is yours from above.",
		"The long routes are slower now, but you know every thermal on every coast you've ever flown. You go where the young can't follow.",
	],
	"trex": [
		"Growing fast. The legs already carry more weight than anything else in this range.",
		"The bite force is becoming real. Something you tested it on did not recover. You noted that.",
		"Apex. The full weight of what you are has arrived. The land remembers every step now.",
		"Slower. But nothing has ever matched you in a straight confrontation. Nothing will start now.",
	],
	"spinosaurus": [
		"The sail is starting to show. The river is already yours in sections — others move when you approach.",
		"You crossed to the other bank this season without effort. The water is not a barrier. It is a road.",
		"Full size. The river belongs to you completely. What enters it is prey. What exits it was lucky.",
		"The deep channels know you. Every current, every shadow. The river remembers where you have been.",
	],
	"giganotosaurus": [
		"The pack is already deferring to your movements. You did not ask for this. It happened.",
		"You called the hunt direction once and the pack followed without question. It has been like that since.",
		"Full size, full pack. The coordinated hunt is automatic now. Nothing on land survives a committed run.",
		"The pack reads your age now — the way you move, the calls you make. They follow the pattern, not the order.",
	],
	"triceratops": [
		"The horns are hardening. Something that tested them retreated. The frill is fully spread now.",
		"A full charge this season stopped something twice your weight. The horns held. They will hold.",
		"Full-grown. The herd arranges itself around you differently — you are the thing predators see first.",
		"Slower but still dangerous. The charge is shorter now. Rivals see you lower your head and step aside.",
	],
	"ankylosaurus": [
		"The armor is firming up across the back. Something tested it this season. It regretted it.",
		"The tail club is functional now. You used it once. The sound it made settled the question permanently.",
		"Full armor. Nothing can reach you from above or the sides. Only something very large or very patient poses a real threat.",
		"Oldest thing in this range. The armor has not weakened. The club has not lost its weight. You are what you have always been.",
	],
	"quetzalcoatlus": [
		"The wingspan is filling out. You feel thermals take more of your weight. The ocean routes are opening.",
		"You completed the offshore crossing for the first time this season. The distance did not exhaust you. It felt correct.",
		"Full wingspan. The sky belongs to you at this scale. No other flyer challenges your altitude or your range.",
		"Slower, but the routes are all known. Every thermal, every coastal current, every crossing. The sky holds no surprises.",
	],
	"argentinosaurus": [
		"Already the largest thing in this range. The land remembers you passing.",
		"Full growth begins. Predators recalculate at the sight of you. The herd presses close — you are the anchor.",
		"Apex herbivore. The full weight of what you are settles with every step. The ground registers it.",
		"The oldest and largest. Nothing challenges you directly. The herd has orbited you for so long it feels like geography.",
	],
	# ── Predator Tier 1 ──
	"compsognathus": [
		"Faster than most things this size. You've started running wide flanking arcs before closing in. The pack picks up the pattern.",
		"Pack coordination is clicking in. You move through a hunt without signaling — the others read the direction and fill it. The gap between decision and action is gone.",
		"The pack is tight and experienced. You move through terrain that stops larger hunters. The size never mattered. This was always the advantage.",
		"Smaller now in ways the body shows. But the young in the pack watch how you cut off prey before the sprint. They're learning exactly the way you did.",
	],
	"sinosauropteryx": [
		"The feathers have thickened. You vanish into dappled light better than anything this size should. Something walked within reach without seeing you. You let it pass. You were not ready. Next time.",
		"The ambush has become reliable. Three times this season you held position long enough for prey to enter your range. The waiting is the hunt.",
		"Shadow and patience. You have become what the species was building toward — invisible until the moment it is already decided.",
		"The body is slower but the stillness has never been better. You wait longer now than you used to. The prey still walks into the gap.",
	],
	# ── Predator Tier 2 ──
	"microraptor": [
		"The glide is improving. You're dropping from branches onto prey now, not just escaping into them. Four wings is becoming a weapon.",
		"Full gliding range. You scout from above before committing. Nothing on the ground sees you until you've already decided.",
		"The aerial ambush is refined. Drop angle, approach speed, moment of commitment — all automatic. The prey never tracks the approach.",
		"The glides are shorter. You choose lower perches now, less height to manage. The timing is still precise. That part has not changed.",
	],
	"troodon": [
		"The night is getting smaller. Routes you hesitated on before you run in complete darkness. The map in your head has expanded.",
		"You've started running your range at specific hours. The prey patterns are mapped. You hunt at the moment they're least alert.",
		"The dark belongs to you. No competition at this hour, no rivals. Just the routes you've memorized and what moves through them.",
		"Slower body, complete map. You know where things will be before they arrive. The hunts are shorter now because you start in the right place.",
	],
	# ── Predator Tier 3 ──
	"deinonychus": [
		"The pack has started flanking without signals. The coordination is early but the shape of it is already right.",
		"A full pack hunt worked this season exactly as it was supposed to. No prey that size was possible alone. It wasn't alone.",
		"The pack moves as a single thing now. You've stopped thinking about coordination — it just happens. The species was built for this.",
		"The young take the sprint. You direct. The pack has evolved around your age — your pattern shapes the hunt even when your pace doesn't.",
	],
	"dilophosaurus": [
		"The crests are forming properly. You've started reading terrain differently — positioning before the prey moves, cutting exits it hasn't taken yet.",
		"The ambush has become your natural mode. You rarely chase. You position, then wait for prey to come into the place you chose for it.",
		"Full size, full crest. You read terrain better than anything else in this range. The chase is a last resort. The setup is the hunt.",
		"Less in a straight run. But nothing knows this terrain like you do. The young still chase in straight lines. You stopped doing that seasons ago.",
	],
	"bambiraptor": [
		"The speed has clicked. You're closing gaps that seemed unclosable last season. Whatever you're chasing, you arrive.",
		"You covered more ground this season than any predator your size should. Distance is not a factor. The prey runs until it can't, and you don't stop.",
		"The fastest thing in this range at your size. The approach is already complete before prey commits to fleeing.",
		"The sprints are shorter. The approach has gotten quieter. What you've lost in pace you've replaced in patience and starting position.",
	],
	"ornitholestes": [
		"Anything that moves is prey now. You've started reading movement patterns — the way things break cover, which direction they favor when startled.",
		"Efficient. You don't commit until you've read the target. Most failed hunts happen before the sprint. You've eliminated that problem.",
		"Clean, fast, opportunistic. The season's total always adds up because you pick what's catchable and ignore what isn't.",
		"The speed is less but the reading has never been better. You pick targets the young miss — the one already slowing, the one that will break left.",
	],
	# ── Predator Tier 5 ──
	"yutyrannus": [
		"The feathers have grown dense. Cold seasons hit the others harder than they hit you. You've started ranging into weather that drives prey to shelter.",
		"Full feathered coat. You are active in conditions that shut down every other predator. The cold hunts are entirely yours.",
		"Massive and insulated. Nothing competes with you in the cold season. The prey shelters and you are already there.",
		"The size is harder to carry now. The feathers keep the core warm. Cold is still a filter, not a limitation. That has not changed.",
	],
	"carcharodontosaurus": [
		"The teeth are fully serrated. Wounds stay open. Prey that escapes doesn't escape cleanly.",
		"The bite is what defines you. You are not the fastest in this range. You don't need to be. What you bite, you keep.",
		"Apex. The serrated jaw and the weight behind it work together — deep bite, open wound, no clean recovery. The hunt ends on your terms.",
		"Slower but the bite has not changed. Prey that has lived long enough to face an elder Carcharodontosaurus has not yet survived one.",
	],
	"tarbosaurus": [
		"The legs have caught up to the body. You're mapping your range in patterns — where things shelter, when they feed, how they move.",
		"The prey populations here have started adjusting their routes. That means they know you're present. That means you're doing it correctly.",
		"Asia's apex. The other predators in this range have arranged themselves around the space you take up.",
		"Old, slower. Nothing in this range has survived as long, learned as much, or claimed this territory as completely.",
	],
	# ── Predator Tier 7 Legendaries ──
	"trex_old_king": [
		"Already larger than most adults of most species. The pattern is clear early and it doesn't change.",
		"Every prey species in this range has started adjusting movement. The land rearranges itself around what you are becoming.",
		"The full weight of it has arrived. Apex of the apex. The land was always going to end up here.",
		"The Old King. Has survived long enough that the range itself adapted. The adjustments have not stopped and will not.",
	],
	"spinosaurus_river_monster": [
		"The river is longer than it was. You have mapped more of it this season.",
		"Both banks claimed. What enters the water from either side is your concern now.",
		"The river is the domain. What lives in it, crosses it, or drinks from it — all of it passes through your awareness.",
		"The river has changed and you have changed with it. Every route still known. Everything still yours.",
	],
	"giganotosaurus_pack_matriarch": [
		"The pack defers to your movements earlier than others at this age. Something in how you move reads as command.",
		"The hunt calls you make are followed without hesitation. The pack accepted the leadership before you claimed it.",
		"The Matriarch. The pack works because you built it. Every hunt you called worked. They know that and they remember.",
		"The pack has raised young who only know your leadership. The hunt patterns you invented are the only ones they were born into.",
	],
	"carcharodonto_red_maw": [
		"The teeth are serrated and the fights have already started. You don't avoid confrontation. You learn from it.",
		"More fights won this season than most Carcharodontosaurus manage in a lifetime. The jaw is beginning to show the record.",
		"The Red Maw. The jaw carries every fight. The wounds closed but the record stayed. Each fight made the next one easier.",
		"Everything in this range knows the jaw. The young predators route around your territory. The old ones don't challenge.",
	],
	# ── Herbivore Tier 1 ──
	"lesothosaurus": [
		"The herd form is natural now. You are not the fastest but you read the direction of panic before it arrives.",
		"You led a scatter this season and the herd followed you, not the direction it was already going. You noted that.",
		"Full speed, full position. You are one of the fastest things in this landscape. The predators that know this range know your pace.",
		"Slower but still faster than most of what hunts you. The herd has reorganized around your age. You run the center now.",
	],
	"microceratus": [
		"The horn is real. You tested it on a rival twice your size. It backed away. The approach is confirmed.",
		"You've won more confrontations than you've lost this season. The horn, the stance, the refusal to move — it works more often than not.",
		"Full-grown, fully committed to the approach. You don't move when challenged. You lower the head. The horn makes the argument.",
		"Smaller than everything that wants to eat you. Has been the entire time. Still here. The horn still works.",
	],
	# ── Herbivore Tier 2 ──
	"hypsilophodon": [
		"The distance is opening up. You're ranging further than the herd in short sprints, returning, ranging again. Mapping.",
		"You covered more ground this season than any herd member. Distance is comfort. The open country ahead is always more interesting than the space behind.",
		"Built for distance. You run the edges of the range where other herbivores don't go. The herd trusts the routes you've scouted.",
		"Legs are slower. The routes are completely known. Every water source, every cover, every crossing in this range memorized.",
	],
	"fruitadens": [
		"Something large tried to track you this season. It lost you in under a minute. The speed is the only protection needed and it's working.",
		"You've ranged into areas larger herbivores avoid — gaps, tight cover, rocky ground. Your size, which limits them, is your advantage.",
		"The smallest thing alive in this range with this much freedom. Nothing that hunts you can catch you in terrain like this.",
		"Still fast. Not as fast. But the routes are known and the small body still fits everywhere the hunters don't.",
	],
	"othnielia": [
		"The herd pace is easy now. You've started reading the edges of ranges for threat signs before the rest of the herd notices.",
		"Steady and capable. You outlasted a pursuit this season through pace and stamina rather than raw speed. That's the approach confirmed.",
		"The dependable one in the herd. Nothing flashy — just capable, present, and harder to bring down than anything your size should be.",
		"Old and still moving. The herd watched you survive things that took others. They keep you near the center now.",
	],
	"changchunsaurus": [
		"The herd bond is deepening. You recognize individuals, read their signals, anticipate their movements. The family is forming.",
		"You have established real bonds within the herd this season. These are not just herd-mates — they are relationships that function under pressure.",
		"The family network is dense and reliable. What happens to any member reaches you within a season. The bonds you've built are the oldest defense you have.",
		"Kin raised, bonds maintained, a herd that carries the pattern of your relationships. You have built something that will last past you.",
	],
	# ── Herbivore Tier 3 ──
	"iguanodon": [
		"The thumb spike is hardening. You've started moving differently when threatened — more upright, spike leading. The equation is changing.",
		"The spike settled an argument this season. Something larger approached, reconsidered after seeing it extended, and retreated. You held your ground.",
		"Can move on two legs or four depending on what the moment asks. The spike ends most confrontations before they require force.",
		"The body has carried this long enough to know every situation before it develops. The spike is still sharp. The response is still fast.",
	],
	"parasaurolophus": [
		"The crest sound is carrying further. The herd is turning toward it now. Something about the frequency has clarified.",
		"The call ranges across the full territory now. The herd knows your signal in conditions that silence every other communication.",
		"The voice of the herd. Your crest carries warning, direction, and assembly calls across distances nothing else achieves. The herd is organized around your signal.",
		"The call is lower and carries further. The herd has grown up knowing this sound. It means safety. It always has.",
	],
	"edmontosaurus": [
		"The migration routes are mapping themselves in your memory — distances, water sources, patterns. The herd will need this.",
		"You completed a full seasonal migration. The herd moved where you indicated before it consciously decided to. The routes are yours.",
		"Peak condition. The herd is tight, the route established, and you are the largest and most capable thing on it.",
		"The routes are so familiar you run them in the dark season without uncertainty. The herd trusts that. The young have never known another way.",
	],
	# ── Herbivore Tier 5 ──
	"diplodocus": [
		"The tail has length now. Something got too close and learned why that matters. It did not repeat the mistake.",
		"The neck reaches canopy that no other herbivore accesses. The competition for this food is essentially zero.",
		"Full length, full reach. The tail clears ground in a wide arc. The neck browses canopy that belongs to nothing else. You occupy your ecological space completely.",
		"The tail is still long and still functional. The neck still reaches. Time has not diminished the fundamentals.",
	],
	"apatosaurus": [
		"Already the largest thing in the juvenile herd. The others move around you without deciding to.",
		"The predators in this range have started recalculating. You are almost full size and the math is shifting against them.",
		"Massive and nearly impossible to bring down when healthy. The herd presses close to you. You are the anchor.",
		"Old and still standing. The herd organized around your age — the young to the outside, you to the center. The logic is sound.",
	],
	"brachiosaurus": [
		"The neck is already reaching high. You browse above the herd and they do not compete for what you take.",
		"Full neck length is close. You browse canopy that requires another species to climb. The high food is yours.",
		"The neck reaches canopy no other herbivore accesses. Size is your only negotiation and the negotiation always works.",
		"Slower to the canopy but still the only thing that reaches it. The food source is still exclusively yours.",
	],
	"shantungosaurus": [
		"The call is gaining range. Others in the herd are responding to your signals before they understand why.",
		"The herd has started defaulting to your direction in uncertain moments. You have not led formally. You are leading anyway.",
		"Largest duck-bill. The herd you anchor is one of the most organized in the region. Your signals have become its language.",
		"The call is deeper and the herd responds to it reflexively now. Generations of herd-members have grown up knowing only your pattern.",
	],
	# ── Herbivore Tier 6-7 ──
	"dreadnoughtus": [
		"Already larger than most adults of other species. The ground registers you.",
		"The predators in this range have stopped testing. The math has been established and they understood it.",
		"Dreadnoughtus. Fears nothing. The fossil record will confirm this. So will everything that walks through this range.",
		"Has not feared anything in this range for many seasons. Has not needed to. Nothing has changed on that front.",
	],
	"patagotitan": [
		"The size is already remaking the world around you. The herd adjusts its spacing without being asked.",
		"One of the heaviest things moving through this land. The ground records it and the land remembers.",
		"Among the heaviest animals confirmed to have existed. Every step is an event at this weight. The land accommodates.",
		"The weight has not diminished. The pace has. The land still records every step the same way.",
	],
	"supersaurus": [
		"The length is already unreasonable. The tail has more range than the juveniles next to you understand.",
		"The longest thing in this range. The tail sweeps in an arc that no predator has learned to avoid yet. They will.",
		"One of the longest animals ever. The tail alone could clear most threats. The neck alone accesses most food. You occupy both extremes.",
		"Long life, long body. The tail is still longer than most of what hunts in this range. The pattern has not changed.",
	],
	# ── Flyer Tier 1 ──
	"anurognathus": [
		"The colony swarm is tighter. You move within it without collision — reading the mass, fitting into gaps. The swarm is a single organism now.",
		"You've started leading swarm direction on night hunts. The colony turns with you before individuals decide. This is influence without authority.",
		"The colony works because individuals like you make it coherent. The swarm covers more ground, catches more insects, loses fewer members when organized.",
		"The colony has young who were born into your patterns. The swarm direction you set is the only one they were taught.",
	],
	"jeholopterus": [
		"The canopy routes are memorized. You move through them in the dark without hesitation. The forest is no longer unfamiliar.",
		"You have mapped every hollow, every roosting gap, every safe perch in your territory. The night is a known space.",
		"Full colony integration. The forest canopy is yours and the colony's — your routes, your hollows, your prey patterns.",
		"The night is still yours. The body is slower but the canopy routes have not changed and neither has your reading of them.",
	],
	# ── Flyer Tier 2 ──
	"nemicolopterus": [
		"The canopy gaps are becoming routes. You move through angles that stopped you before. The forest is opening.",
		"You cover the canopy in a pattern now, not randomly. The food is where you expect it to be because you've mapped where it is.",
		"The forest acrobat. You reach feeding sites no larger flyer can approach. Competition in your niche is essentially zero.",
		"Smaller routes now — the body needs less. But the canopy still opens where you know it will.",
	],
	"yi_qi": [
		"The bat-membranes are working properly. The glide is real and getting longer season by season.",
		"The night hunts are reliable now. The membranous wings work in darkness where feathered flyers hesitate.",
		"Unusual and entirely functional. The design that looks wrong works in ways conventional wings don't. You hunt hours others can't access.",
		"The membranes are still good. The routes are known. The night hours belong to you as completely as they ever have.",
	],
	"archaeopteryx": [
		"The balance between climbing and gliding has improved. You are losing less height per glide. The air is starting to work for you.",
		"Full gliding range. You cross gaps that stopped you before. The air is not just an escape — it is a route.",
		"Neither purely this nor that — and that turns out to be an advantage. You access what pure climbers can't and escape what ground-dwellers can't evade.",
		"The glides are shorter but the routes are known. You still move between worlds that specialized species can only see from one side.",
	],
	"sordes": [
		"The colony is already your warmth and safety. You've started learning who to stay close to and who to follow when decisions get made.",
		"You raised young this season. The colony supported it immediately and without question. The support was certain.",
		"Deep in the colony network. Warm, fed, and defended by numbers. The colony is the oldest survival strategy that exists. It still works.",
		"The colony surrounds you. Young who were born in seasons you helped defend are adults now. The warmth is the same.",
	],
	# ── Flyer Tier 3 ──
	"pterodactylus": [
		"The wing efficiency is improving. You cover the same distance with less effort. The thermals are making sense.",
		"You completed a range crossing this season that would have turned you back before. Distance is becoming an asset.",
		"Built for range and adaptability. You go where other flyers won't commit to. The territory you claim reflects that.",
		"The range is narrower now but still wider than most. You know every route in this airspace. The air holds no surprises.",
	],
	"rhamphorhynchus": [
		"The dusk hunts are getting reliable. The water surface gives up information at the right light and you've started reading it accurately.",
		"The long tail has become an asset in turns and dives. You cut angles at the water's surface that shorter-tailed flyers miss entirely.",
		"The dusk window belongs to you. The long tail, the needle beak, the water surface — all refined. The fish don't see the approach.",
		"Slower dives now. But the dusk light still tells you what it always has, and the long tail still cuts the right angle.",
	],
	"dsungaripterus": [
		"The curved beak is useful on harder prey than expected. The pressure it generates is already different from anything else at this size.",
		"You've cracked shells this season that other flyers passed over. The beak has opened a food source that is entirely yours.",
		"The niche belongs to you completely. Crustaceans, shellfish, armored prey — all inaccessible to flyers without this beak. You have no competition.",
		"The beak still works. The food source it accesses is still exclusively yours. Age has not changed the fundamentals.",
	],
	# ── Flyer Tier 4 ──
	"cearadactylus": [
		"The interlocking teeth are clicking into position. Fish that entered the open beak once cannot exit.",
		"The dive angle and the bite timing have come together. The fish count per hunt has doubled this season.",
		"The teeth make the method. You enter the water at speed and the interlocking jaw closes on whatever tries to slip past. Nothing slips past.",
		"The dives are less deep. The teeth still work. Fish that surface near you have always made the same mistake.",
	],
	"tapejara": [
		"The sail crest is rising. You've started using thermals in the jungle canopy — different from open air, but learnable.",
		"The crest reads the jungle thermals. You navigate gaps between canopy that most flyers treat as walls.",
		"The jungle air belongs to you. The sail crest catches columns of warm air rising through the canopy. You move through it like current.",
		"The crest is fully familiar to the thermals now. The jungle knows your patterns. You know the jungle's.",
	],
	"anhanguera": [
		"The colony is coordinating on large shoals now. You've started joining the group dives — the timing is early but functional.",
		"The group dive is reliable now. The shoal scatters but the numbers mean something is always caught regardless.",
		"The colonial dive is efficient. You and the colony have developed timing that fills the water with pressure from multiple angles. Nothing has a clean escape direction.",
		"The dives are shorter. But the colony learned the timing from you. The method you perfected still works in their wings.",
	],
	"ornithocheirus": [
		"The open-water stamina is building. You've started staying over the ocean longer before returning to land.",
		"You completed your first sustained offshore crossing this season. The ocean routes are becoming known rather than assumed.",
		"The open ocean is your range. You follow island chains and current edges further than anything else with wings. The distance that stops others is just the start of your route.",
		"The long crossings are slower. The routes are more completely known than any living flyer's. You still go where you always have.",
	],
	# ── Flyer Tier 5 ──
	"tropeognathus": [
		"The keel crest is real now. It catches wind from the cliff faces in ways that feel intentional.",
		"The coastal ownership has begun. You run the same cliff routes daily and drive off smaller flyers on principle.",
		"The coastal domain is yours. The crest, the wingspan, and the dive angle have made the cliff-face hunting yours alone.",
		"Slower along the cliff faces. But the angles are known and the prey patterns are not new. The coast still belongs to you.",
	],
	"hatzegopteryx": [
		"The ground is as natural as the air. You are hunting in both modes — testing what the body can do in each.",
		"You brought down ground prey this season that most flyers would not attempt. The body can do this. You are making it a habit.",
		"Top predator of this island, in the air and on the ground. Nothing here challenges you in either mode.",
		"The flights are shorter. The ground hunts are slower. Nothing on this island has the experience you have in both domains.",
	],
	"cryodrakon": [
		"The cold routes are opening. You range into weather this season that the others avoid.",
		"The northern cold is a filter — it removes competition. You have started using this deliberately and consistently.",
		"Full northern range. Every storm route, every cold-weather crossing, every place the other flyers won't go — yours.",
		"The cold routes are slower now. They are still yours. The storms have not changed and neither has your reading of them.",
	],
	# ── Flyer Tier 7 Legendaries ──
	"quetzal_sky_tyrant": [
		"Already the largest thing in the air in this range. The thermals read the wingspan and respond to it.",
		"The sky has reorganized around your routes. Other flyers adjust their lines when they see you coming.",
		"The Sky Tyrant. Nothing in the air competes at this wingspan. The sky is not a habitat — it is a domain.",
		"Has reached the edge of what a flying creature can be. The sky is still entirely yours.",
	],
	"hatzegopteryx_bonebreaker": [
		"Already hunting in both modes — sky and ground simultaneously. Everything that moves is being evaluated.",
		"The island has accepted you as apex in both dimensions. Nothing challenges you in the air. Nothing challenges you on the ground.",
		"The Bonebreaker. Has killed more on the ground than in the air. Flyer by birth, apex predator by practice.",
		"The island knows no other pattern. You have been sky-lord and ground predator for so long the two are indistinguishable.",
	],
	"cryodrakon_frostwing": [
		"Cold routes already. Others your age avoid the northern weather. You lean into it instead.",
		"The Frostwing has claimed the storm routes as territory. What other flyers avoid is your competitive advantage.",
		"The cold, the storm, the northern crossing — all yours. The filter that eliminates competition is your element.",
		"Every storm survived. Every cold crossing completed. You still fly where nothing else will go.",
	],
	"arambourgiania": [
		"Already ranging further than the colony. The routes feel insufficient. There is more to map.",
		"You crossed into a region none of your colony has seen. The new thermals are different. You learned them.",
		"The Long Shadow. Every flyway mapped, every region crossed. The sky between landmasses belongs to you.",
		"Has flown every route. The shadow still falls across all of it.",
	],
	# ── Per-tree fallbacks ──
	"_predator": [
		"The hunt instinct has sharpened. You are no longer surviving by default — you are choosing. Prey moves differently when you understand what you are.",
		"Your body has caught up to the hunger. The pack watches you differently. You are no longer protected — you are expected.",
		"Full size. You have become what this species was always building toward. The territory is yours to claim or lose.",
		"Your prime is behind you. Your knowledge is not. Every threat you survived is a lesson now. You are the most dangerous thing in any situation you've already seen.",
	],
	"_herbivore": [
		"You have outgrown the need for protection. You move with the herd now, not behind it. That difference matters.",
		"Larger. Predators that passed you over before pause now. You are not nothing anymore. You are something they have to think about.",
		"Full-grown. The herd positions itself differently around you. You are not at the center — you are part of the edge that holds.",
		"Slower. But you have survived long enough to read what the young still miss. Your presence alone steadies the herd.",
	],
	"_flyer": [
		"First real flight — not falling with control, actually flying. The thermals answer back. You are part of the sky now.",
		"The range has doubled. Where the body used to tire it now holds. The coast, the high ridge, the offshore winds. More of the world is reachable.",
		"Full wingspan. You own the air you fly through. Other flyers read your size and adjust their lines.",
		"The long distances feel harder but the fear is gone. You have flown every route that matters. You know which winds kill and which ones carry.",
	],
}


const ELDER_FINAL_EVENTS = {
	"compsognathus": {
		"flavor": "Three seasons as Elder. The pack has been yours since before most of them hatched. A younger rival group has been testing the boundary — not hunting, just watching. Learning the rhythm. Yesterday one of them took a kill mid-pursuit. Not by accident.",
		"choices": [
			{ "label": "Lead them into the ravine", "icon": "stalk", "sublabel": "Your ground. They don't know it.", "action": "a" },
			{ "label": "Challenge their leader directly", "icon": "attack", "sublabel": "End it before the pack splits.", "action": "b" },
		],
	},
	"deinonychus": {
		"flavor": "The young male who challenged you last breeding season hasn't left — he's been building something instead. Sitting closer to kills you called, holding eye contact longer, redirecting sub-adults on hunts you didn't initiate. Two pack members responded to his signal yesterday before yours.",
		"choices": [
			{ "label": "Find him alone at the boundary", "icon": "stalk", "sublabel": "You pick the moment, away from the pack.", "action": "a" },
			{ "label": "Call a hunt that needs both of you", "icon": "attack", "sublabel": "Show the pack what the two of you can do together.", "action": "b" },
		],
	},
	"velociraptor": {
		"flavor": "The great migration has run through your range for four days. Every normal hunt corridor is occupied or disrupted. The pack hasn't eaten in two days. The junior has been talking about abandoning the territory. Tonight is the last chance to resolve this before the season ends.",
		"choices": [
			{ "label": "Strike the migration edge at dusk", "icon": "attack", "sublabel": "High risk. The pack eats tonight, or worse.", "action": "a" },
			{ "label": "Lead the pack to secondary ground", "icon": "flee", "sublabel": "Yield the range for now. Eat safely.", "action": "b" },
		],
	},
	"allosaurus": {
		"flavor": "Something has been marking the northern section of your range for four days. The marks are fresh and enormous — a rival of comparable size. Your range has been yours for eleven seasons. Whatever is making these marks doesn't know that yet.",
		"choices": [
			{ "label": "Meet it on the killing ground", "icon": "attack", "sublabel": "The flat center where you've brought down everything worth remembering.", "action": "a" },
			{ "label": "Set the ambush at the canyon crossing", "icon": "stalk", "sublabel": "You know every angle of it. It doesn't.", "action": "b" },
		],
	},
	"trex": {
		"flavor": "Something has been leaving marks on the southern boundary for three days. Enormous marks. Whatever made them is still here — you can smell it now. You haven't encountered one of your own in three winters. The last time settled the question for both parties for several seasons.",
		"choices": [
			{ "label": "Move to the southern boundary at first light", "icon": "attack", "sublabel": "Find it before it finds you.", "action": "a" },
			{ "label": "Drive it north through its own boundary markers", "icon": "stalk", "sublabel": "Use the territory itself.", "action": "b" },
		],
	},
	"lesothosaurus": {
		"flavor": "Two consecutive seasons, the predators in this range have shifted tactics. Not chasing the herd's edge — circling the center, watching the rhythm, waiting for the one that holds the pace back. They've identified you. The herd has noticed too. There are small adjustments in how they move around you.",
		"choices": [
			{ "label": "Break from the herd to draw them off", "icon": "flee", "sublabel": "Give the herd time to scatter. You take the risk.", "action": "a" },
			{ "label": "Bury yourself in the center of the herd", "icon": "stalk", "sublabel": "The numbers have to count for something.", "action": "b" },
		],
	},
	"iguanodon": {
		"flavor": "The river has stopped. Not slowed — stopped. The herd is looking to you. Every route out of this basin requires committing to something uncomfortable: the known route runs through a predator corridor that has been active all season, and the shortcut crosses open ground with no cover and unreliable footing.",
		"choices": [
			{ "label": "Take the known route", "icon": "stalk", "sublabel": "Familiar ground, known risk.", "action": "a" },
			{ "label": "Cross the open ground", "icon": "flee", "sublabel": "Two days faster. No cover.", "action": "b" },
		],
	},
	"triceratops": {
		"flavor": "Three seasons this predator has been targeting the herd. Always at dusk, always from the northeast — until tonight, when it came from two directions. Something taught it something. You are at the outer edge. The rest of the herd is tightening behind you.",
		"choices": [
			{ "label": "Lower the horns and charge", "icon": "attack", "sublabel": "Full commitment. Stop it in its tracks.", "action": "a" },
			{ "label": "Form up with the nearest herd members", "icon": "stalk", "sublabel": "Coordinated defense — strength in numbers.", "action": "b" },
		],
	},
	"ankylosaurus": {
		"flavor": "You crossed the lowland three days ago when the ground was firm. Overnight the rains came — sudden and heavy. The ground under you has shifted from clay to something that doesn't hold weight anymore. You are in to your knees. Something has been circling the bog's edge for the last hour.",
		"choices": [
			{ "label": "Work to free yourself now", "icon": "attack", "sublabel": "Active, exhausting, immediate.", "action": "a" },
			{ "label": "Go still and wait for the ground to firm", "icon": "stalk", "sublabel": "Patience — let the conditions change.", "action": "b" },
		],
	},
	"argentinosaurus": {
		"flavor": "The herd has begun the great northern migration — the one you have completed twenty-three times. On the first day, you already know. The joints that carried the long crossings are carrying them differently now. The pace the herd sets is the pace the terrain requires. You are slower than that pace for the first time.",
		"choices": [
			{ "label": "Push through with the herd", "icon": "flee", "sublabel": "Every crossing, every time. This one too.", "action": "a" },
			{ "label": "Find your own path — slower, more sustainable", "icon": "stalk", "sublabel": "Separate route, same destination.", "action": "b" },
		],
	},
}


func start_turn() -> void:
	GameState.roll_daily_luck()
	_check_life_stage_advance()
	if _check_natural_end():
		return
	GameState.tick_temp_buffs()
	GameState.tick_injuries_untreated()
	preload("res://scripts/systems/world_conditions.gd").tick()
	preload("res://scripts/systems/living_world.gd").tick()
	_drain_hunger()
	if GameState.health <= 0.0:
		return
	_apply_elder_decay()
	_check_consistency_bonus()
	if GameState.territory_bonus_turns > 0:
		GameState.territory_bonus_turns -= 1
	# Promote pending territory claim — marked last season, active this season
	GameState.territory_claim         = GameState.pending_territory_claim
	GameState.pending_territory_claim = ""
	COMPANIONS.ensure_cast()
	_emit_stat_changes()
	emit_signal("turn_started")
	if GameState.life_stage == 0:
		return
	if _check_nesting_outcome():
		return
	if _check_maternal_bond_outcome():
		return
	if _check_juvenile_lesson_outcome():
		return
	if _check_juvenile_parent_event():
		return
	if _check_maternal_bond_event():
		return
	if _check_hatchling_event():
		return
	var reunion := LIFE_STORY.next_reunion()
	if not reunion.is_empty():
		emit_signal("event_fired", reunion)
		_emit_stat_changes()
		return
	if _check_dein_alpha_breed_pending():
		return
	if _check_alpha_mating_season():
		return
	if _check_dein_sub_mating():
		return
	if _check_pack_sub_mating():
		return
	if _check_breed_effort_pending():
		return
	if _check_pattern_a_male_mating():
		return
	if _check_pattern_a_female_mating():
		return
	if _check_pattern_b_tournament():
		return
	if _check_pattern_b_female_mating():
		return
	if _check_female_nesting_prep():
		return
	if not _check_pending_egg():
		if GameState.seasons_elapsed == 0:
			emit_signal("event_fired", _build_birth_event())
		elif _check_elder_final_event():
			pass
		else:
			var journey_event := preload("res://scripts/systems/journeys.gd").next_event()
			if not journey_event.is_empty():
				GameState.save_run()
				emit_signal("event_fired", journey_event)
				return
			var companion_event := preload("res://scripts/systems/pack_story_events.gd").next_event()
			if companion_event.is_empty(): companion_event = COMPANIONS.next_event()
			if companion_event.is_empty():
				companion_event = preload("res://scripts/systems/discoveries.gd").next_event()
			if companion_event.is_empty():
				companion_event = preload("res://scripts/systems/living_world.gd").next_event()
			if not companion_event.is_empty():
				GameState.save_run()
				emit_signal("event_fired", companion_event)
			else:
				EventManager.roll_world_event()


func end_turn() -> void:
	GameState.advance_season()
	if GameState.seasons_elapsed % 4 == 0 and GameState.seasons_elapsed > 0:
		AdManager.show_interstitial()
	emit_signal("turn_ended")
	_emit_stat_changes()
	start_turn()


func _drain_hunger() -> void:
	if GameState.life_stage == 0:
		return
	var species = SpeciesDB.get_species(GameState.species_id)
	if species.is_empty():
		return
	# Catch combat/wound deaths that accumulated before this turn
	if GameState.health <= 0.0 and GameState.death_cause == "":
		GameState.death_cause = "wounds"
		emit_signal("run_ended")
		return
	GameState.hunger = maxf(0.0, GameState.hunger - species["hunger_decay"] * HUNGER_DECAY_MULT - preload("res://scripts/systems/world_conditions.gd").extra_hunger())
	if GameState.hunger <= 0.0:
		GameState.health = maxf(0.0, GameState.health - HUNGER_DRAIN_ON_ZERO)
		if GameState.health <= 0.0 and GameState.death_cause == "":
			GameState.death_cause  = "starvation"
			GameState.death_detail = "%s, Year %d" % [GameState.SEASON_NAMES[GameState.current_season], GameState.current_year]
	_emit_stat_changes()
	if GameState.health <= 0.0:
		emit_signal("run_ended")


func _check_life_stage_advance() -> void:
	var species = SpeciesDB.get_species(GameState.species_id)
	if species.is_empty():
		return
	var stages: Array = species["life_stages"]
	var threshold := 0
	for i in range(min(GameState.life_stage + 1, stages.size())):
		threshold += stages[i]
	if GameState.seasons_elapsed >= threshold and GameState.life_stage < 4:
		GameState.life_stage += 1
		LIFE_STORY.remember("stage_%d" % GameState.life_stage, "Grew into the %s stage." % GameState.get_stage_name(), 3)
		if GameState.life_stage != _stage_at_last_check:
			_bonuses_this_stage = 0
			_stage_at_last_check = GameState.life_stage
			_update_size_for_stage(species)
			emit_signal("life_stage_changed", GameState.life_stage)
			SoundManager.play("age_up")
			_fire_stage_up_event()
			# Queue juvenile lesson outcome to fire next turn (separate from stage-up event)
			if GameState.life_stage == 2 and not GameState.juvenile_lesson_done:
				if not _load_juvenile_data().is_empty():
					GameState.juvenile_outcome_pending = true


func _check_natural_end() -> bool:
	if GameState.life_stage < 4:
		return false
	var species = SpeciesDB.get_species(GameState.species_id)
	if species.is_empty():
		return false
	var stages: Array = species["life_stages"]
	# stages[0..3] advance the four stage transitions; stages[4] = elder lifespan
	var total_to_elder: int = stages[0] + stages[1] + stages[2] + stages[3]
	var elder_seasons: int  = stages[4] if stages.size() >= 5 else ELDER_SEASONS_FALLBACK
	var max_lifespan: int   = total_to_elder + elder_seasons - GameState.lifespan_reduction
	if GameState.seasons_elapsed >= max_lifespan:
		GameState.death_cause = "natural"
		emit_signal("run_ended")
		return true
	return false


func _check_elder_final_event() -> bool:
	if GameState.life_stage < 4:
		return false
	if GameState.elder_final_event_triggered:
		return false
	if GameState.species_id not in ELDER_FINAL_EVENTS:
		return false
	var species = SpeciesDB.get_species(GameState.species_id)
	if species.is_empty():
		return false
	var stages: Array = species["life_stages"]
	var total_to_elder := 0
	for i in range(min(4, stages.size())):
		total_to_elder += stages[i]
	if GameState.seasons_elapsed - total_to_elder < 3:
		return false
	GameState.elder_final_event_triggered = true
	var tpl: Dictionary = ELDER_FINAL_EVENTS[GameState.species_id]
	emit_signal("event_fired", {
		"type":        "elder_final",
		"title":       "The Elder's Last Trial",
		"resolve_key": "elder_final_" + GameState.species_id,
		"flavor":      tpl["flavor"],
		"choices":     tpl["choices"],
	})
	return true


func _apply_elder_decay() -> void:
	if GameState.life_stage < 4:
		return
	var species = SpeciesDB.get_species(GameState.species_id)
	if species.is_empty():
		return
	var stages: Array = species["life_stages"]
	var total_to_elder := 0
	for i in range(min(4, stages.size())):
		total_to_elder += stages[i]
	var elder_seasons: int = maxi(0, GameState.seasons_elapsed - total_to_elder)
	var health_cap := maxf(0.15, 1.0 - elder_seasons * ELDER_HEALTH_DECAY_PER_SEASON)
	if GameState.health > health_cap:
		GameState.health = health_cap
		_emit_stat_changes()


func _update_size_for_stage(species: Dictionary) -> void:
	var base_sz: int = species.get("base_size", 1)
	var max_sz: int  = species.get("max_size", base_sz)
	GameState.size = base_sz + int(round(float(max_sz - base_sz) * GameState.life_stage / 4.0))


func _build_birth_event() -> Dictionary:
	var species = SpeciesDB.get_species(GameState.species_id)
	var tree    = species.get("tree", "predator")
	var flavor  = BIRTH_FLAVOR.get(GameState.species_id,
		BIRTH_FLAVOR.get("_" + tree, "The shell breaks. The world is larger than you expected."))
	return { "type": "birth", "flavor": flavor, "choices": [] }


func _fire_stage_up_event() -> void:
	var stage   := GameState.life_stage  # already incremented (1–4)
	var idx     := stage - 1             # 0-based index into the flavor array
	var flavors: Array = STAGE_UP_FLAVOR.get(GameState.species_id, [])
	if flavors.is_empty():
		var species = SpeciesDB.get_species(GameState.species_id)
		var tree    = species.get("tree", "predator")
		flavors = STAGE_UP_FLAVOR.get("_" + tree, [])
	var flavor: String = flavors[idx] if idx < flavors.size() else \
		"You have grown into a %s." % GameState.get_stage_name()
	emit_signal("event_fired", { "type": "stage_up", "flavor": flavor, "choices": [] })


func _check_consistency_bonus() -> void:
	if _bonuses_this_stage >= MAX_BONUSES_PER_STAGE:
		return
	if GameState.hunger_history.size() < CONSISTENCY_TURNS_REQUIRED:
		return
	var r_hunger := GameState.hunger_history.slice(-CONSISTENCY_TURNS_REQUIRED)
	var r_health := GameState.health_history.slice(-CONSISTENCY_TURNS_REQUIRED)
	var r_type   := GameState.type_stat_history.slice(-CONSISTENCY_TURNS_REQUIRED)
	var hunger_high := true
	var hunger_low  := true
	var health_high := true
	var type_high   := true
	for i in r_hunger.size():
		if r_hunger[i] < CONSISTENCY_THRESHOLD_HIGH: hunger_high = false
		if r_hunger[i] > CONSISTENCY_THRESHOLD_LOW:  hunger_low  = false
		if r_health[i] < CONSISTENCY_THRESHOLD_HIGH: health_high = false
		if r_type[i]   < CONSISTENCY_THRESHOLD_HIGH: type_high   = false
	if hunger_high:
		_apply_consistency_change("hunger_high")
	elif hunger_low:
		_apply_consistency_change("hunger_low")
	elif health_high:
		_apply_consistency_change("health_high")
	elif type_high:
		_apply_consistency_change("type_stat_high")


func _check_pending_egg() -> bool:
	if not GameState.pending_egg:
		return false
	GameState.pending_egg = false
	GameState.kin_created += 1
	GameState.offspring_name = ""
	GameState.has_young = true
	GameState.has_young_turns = 0
	emit_signal("event_fired", _build_egg_event())
	_emit_stat_changes()
	return true


func _build_egg_event() -> Dictionary:
	var species = SpeciesDB.get_species(GameState.species_id)
	var tree = species.get("tree", "predator")
	var has_pack = GameState.pack_bond > 0.0
	var is_female = GameState.sex == "female"

	# Alpha suspects infidelity — overrides normal egg event
	if is_female and has_pack and not GameState.mate_was_alpha:
		GameState.alpha_suspects = true
		var susp_flavor: String
		match tree:
			"herbivore":
				susp_flavor = "The young are here. The alpha bull has been circling the nest site all day — not protective. Counting seasons back. The way he looks at you now is different from how he looked at you before."
			"flyer":
				susp_flavor = "The eggs are in the hollow. The alpha has been landing near it more than he should, watching you leave and return. He is counting the timing. The colony feels it."
			_:
				susp_flavor = "The young are here. The alpha has been circling the nest all day — not to guard it. He is counting back. The looks he gives you now carry something that wasn't there before."
		return {
			"type": "egg",
			"resolve_key": "alpha_suspicion_confrontation",
			"flavor": susp_flavor,
			"choices": [
				{ "label": "Stay — act as if nothing is wrong", "icon": "stalk",  "sublabel": "Maybe he lets it pass",           "action": "stay_hope" },
				{ "label": "Leave before he acts",              "icon": "flee",   "sublabel": "Take your young and go",          "action": "leave" },
				{ "label": "Name it before he does",            "icon": "attack", "sublabel": "Force the confrontation now",     "action": "confront" },
			],
		}

	var flavor: String
	match tree:
		"herbivore":
			if has_pack and is_female:
				flavor = "The clutch is laid in the herd's resting ground. The others have started moving in a tighter circle around you without being asked."
			elif has_pack:
				flavor = "She nested near the center of the herd. You've started running longer loops at the outer edge without deciding to."
			else:
				flavor = "The eggs are laid. You find yourself grazing closer to the nest now. Not a decision — just what the body does."
		"flyer":
			if has_pack and is_female:
				flavor = "The clutch is in the cliff hollow. The colony has shifted its patrol pattern around that section of rock without discussion."
			elif has_pack:
				flavor = "She nested in the cliff hollow. You run the same patrol loop every dawn now without deciding to."
			else:
				flavor = "The eggs are in the hollow. You run the same patrol loop every dawn. Safe from below. You watch the sky."
		_:  # predator
			if has_pack and is_female:
				flavor = "The nest is hidden in the center of your range. The pack has tightened its perimeter. They know without being told."
			elif has_pack:
				flavor = "She chose the nest site. You've been running a wider patrol without thinking about it. The pack holds tight around her."
			else:
				flavor = "The nest is hidden. Close. You find yourself hunting a wider ring around it — nothing comes near without you knowing first."
	return { "type": "egg", "flavor": flavor, "choices": [] }


func _load_nest_data() -> Dictionary:
	var path := "res://scripts/dinos/%s/dino_nest.gd" % GameState.species_id
	if ResourceLoader.exists(path):
		var script = load(path)
		var node := Node.new()
		node.set_script(script)
		var data: Dictionary = node.get_nest_data() as Dictionary
		node.free()
		return data
	return {}


func _load_mate_data() -> Dictionary:
	var path := "res://scripts/dinos/%s/dino_mate.gd" % GameState.species_id
	if ResourceLoader.exists(path):
		var script = load(path)
		var node := Node.new()
		node.set_script(script)
		var data: Dictionary = node.get_mate_data() as Dictionary
		node.free()
		return data
	return {}


func _check_alpha_mating_season() -> bool:
	if not GameState.is_mating_season():
		return false
	if not GameState.is_alpha:
		return false
	if GameState.pack_bond == 0.0:
		return false
	if GameState.has_mate:
		return false
	if GameState.alpha_display_done:
		return false
	var species  := SpeciesDB.get_species(GameState.species_id)
	var mstyle   : String = species.get("mating_style", "") as String
	if mstyle not in ["pack_alpha", "pack_coalition"]:
		return false

	GameState.alpha_display_done = true

	# ── Pack bond dip — other males disperse at season start ──────────────────
	if GameState.pack_bond > 0.05:
		PackManager.modify_bond(-0.05)

	# ── DEINONYCHUS: higher rival probability, species-specific events ────────
	if GameState.species_id == "deinonychus":
		return _check_dein_alpha_mating()

	var data := _load_mate_data()

	# ── Rival challenge roll — chance rises each unchallenged season ──────────
	var rival_chance: float = minf(0.15 + GameState.alpha_seasons_unchallenged * 0.12, 0.75)
	if randf() < rival_chance:
		GameState.alpha_seasons_unchallenged = 0
		var intro_pool: Array = data.get("rival_challenge_intro", []) as Array
		var flavor: String
		if intro_pool.is_empty():
			flavor = "A male you don't recognize has entered your range. He's testing the edges, watching you. This is a challenge."
		else:
			flavor = intro_pool[randi() % intro_pool.size()]
		emit_signal("event_fired", {
			"type":        "rival_challenge",
			"resolve_key": "rival_challenge",
			"flavor":      flavor,
			"choices": [
				{ "label": "Fight to keep your place", "icon": "attack", "sublabel": "You are the alpha. Prove it.",       "action": "fight" },
				{ "label": "Leave the territory",      "icon": "flee",   "sublabel": "Walk away on your own terms.",       "action": "leave" },
			],
		})
		return true

	# ── No rival — breeding-season display event ──────────────────────────────
	GameState.alpha_seasons_unchallenged += 1
	var intro_pool: Array = data.get("seek_male_alpha", []) as Array
	var flavor: String
	if intro_pool.is_empty():
		flavor = "Breeding season has arrived. You are the alpha. The pack watches what you will do next."
	else:
		flavor = intro_pool[randi() % intro_pool.size()]
	var show_label: String = data.get("alpha_display_show_label", "Display to the pack") as String
	emit_signal("event_fired", {
		"type":        "alpha_display",
		"resolve_key": "alpha_display",
		"flavor":      flavor,
		"choices": [
			{ "label": show_label,               "icon": "attack", "sublabel": "Costs hunger. Builds toward a strong season.", "action": "display_show"   },
			{ "label": "Guard the nest area",    "icon": "stalk",  "sublabel": "Hold the territory. Neutral outcome.",         "action": "display_guard"  },
			{ "label": "Ignore breeding season", "icon": "flee",   "sublabel": "Save your strength.",                         "action": "display_ignore" },
		],
	})
	return true


func _check_dein_alpha_mating() -> bool:
	# Higher rival probability for Deinonychus: 0.50 + unchallenged * 0.20, cap 0.90
	var rival_chance: float = minf(0.50 + GameState.alpha_seasons_unchallenged * 0.20, 0.90)
	var event: Dictionary = _load_dein_mate_event("rival")
	if randf() < rival_chance:
		GameState.alpha_seasons_unchallenged = 0
		var intro_pool: Array = event.get("intro", []) as Array
		var flavor: String
		if intro_pool.is_empty():
			flavor = "A rival male steps toward the center of the pack. He wants your place."
		else:
			flavor = intro_pool[randi() % intro_pool.size()]
		emit_signal("event_fired", {
			"type":        "dein_rival_challenge",
			"resolve_key": "dein_rival_challenge",
			"flavor":      flavor,
			"choices":     event.get("choices", []),
		})
		return true

	# ── No rival — fire breeding event directly ───────────────────────────────
	GameState.alpha_seasons_unchallenged += 1
	return _fire_dein_alpha_breeding()


func _fire_dein_alpha_breeding() -> bool:
	if not GameState.is_alpha:
		return false
	GameState.alpha_breed_pending = false
	var event: Dictionary = _load_dein_mate_event("alpha")
	var intro_pool: Array = event.get("intro", []) as Array
	var flavor: String
	if intro_pool.is_empty():
		flavor = "The pack's rhythm bends around you. Breeding season demands something from you now."
	else:
		flavor = intro_pool[randi() % intro_pool.size()]
	emit_signal("event_fired", {
		"type":        "dein_alpha_breeding",
		"resolve_key": "dein_alpha_breeding",
		"flavor":      flavor,
		"choices":     event.get("choices", []),
	})
	return true


func _load_dein_mate_event(event_type: String) -> Dictionary:
	var path := "res://scripts/dinos/deinonychus/dino_mate.gd"
	if not ResourceLoader.exists(path):
		return {}
	var script = load(path)
	var node := Node.new()
	node.set_script(script)
	var data: Dictionary
	match event_type:
		"sub":    data = node.get_dein_sub_event()
		"rival":  data = node.get_dein_rival_event()
		"alpha":  data = node.get_dein_alpha_breeding_event()
		"female": data = node.get_dein_female_breeding_event()
		_:        data = {}
	node.free()
	return data


func _check_dein_alpha_breed_pending() -> bool:
	# Fires the alpha breeding event the turn after winning a rival challenge
	if not GameState.alpha_breed_pending:
		return false
	if GameState.species_id != "deinonychus":
		return false
	if not GameState.is_alpha:
		# Lost alpha between turns — clear flag silently
		GameState.alpha_breed_pending = false
		return false
	if not GameState.is_mating_season():
		GameState.alpha_breed_pending = false
		return false
	return _fire_dein_alpha_breeding()


func _check_pack_sub_mating() -> bool:
	# Generic sub-male challenge for all pack_alpha species (except deinonychus,
	# which has its own dedicated handler in _check_dein_sub_mating).
	if not GameState.is_mating_season():
		return false
	if GameState.species_id == "deinonychus":
		return false
	if GameState.sex != "male":
		return false
	if GameState.is_alpha:
		return false
	if GameState.pack_bond == 0.0:
		return false
	if GameState.sub_mating_done:
		return false
	var species := SpeciesDB.get_species(GameState.species_id)
	if species.get("mating_style", "") != "pack_alpha":
		return false
	var min_stage: int = GameState.get_min_mate_stage()
	if GameState.life_stage < min_stage:
		return false

	GameState.sub_mating_done = true
	var data := _load_mate_data()
	var intro_pool: Array = data.get("seek_male_sub", []) as Array
	var flavor: String
	if intro_pool.is_empty():
		flavor = "Breeding season stirs through the pack. The alpha male watches every step you take. You have to decide what you are going to do about that."
	else:
		flavor = intro_pool[randi() % intro_pool.size()]
	emit_signal("event_fired", {
		"type":        "pack_sub_mating",
		"resolve_key": "mate_pack_alpha_male_sub",
		"flavor":      flavor,
		"choices": [
			{ "label": "Challenge him",             "sublabel": "Fight for the alpha position",  "action": "alpha_fight" },
			{ "label": "Hold your place",           "sublabel": "Stay in the pack, miss your chance", "action": "submit"     },
			{ "label": "Leave the pack",            "sublabel": "Walk away from all of it",      "action": "leave_pack" },
		],
	})
	return true


func _check_dein_sub_mating() -> bool:
	if not GameState.is_mating_season():
		return false
	if GameState.species_id != "deinonychus":
		return false
	if GameState.sex != "male":
		return false
	if GameState.is_alpha:
		return false
	if GameState.pack_bond == 0.0:
		return false
	if GameState.sub_mating_done:
		return false

	var event: Dictionary = _load_dein_mate_event("sub")
	var intro_pool: Array = event.get("intro", []) as Array
	var flavor: String
	if intro_pool.is_empty():
		flavor = "Breeding season sharpens the pack's rhythm. The alpha male stands at the center of it."
	else:
		flavor = intro_pool[randi() % intro_pool.size()]
	emit_signal("event_fired", {
		"type":        "dein_sub_mating",
		"resolve_key": "dein_sub_mating",
		"flavor":      flavor,
		"choices":     event.get("choices", []),
	})
	return true


func _check_allo_male_mating() -> bool:
	if not GameState.is_mating_season():
		return false
	if GameState.species_id != "allosaurus":
		return false
	if GameState.sex != "male":
		return false
	if GameState.has_mate:
		return false
	if GameState.species_mating_done:
		return false
	var min_stage: int = GameState.get_min_mate_stage()
	if GameState.life_stage < min_stage:
		return false

	var event: Dictionary  = _load_species_mate_event("allosaurus", "male")
	var intro_pool: Array  = event.get("intro", []) as Array
	var flavor: String
	if intro_pool.is_empty():
		flavor = "Breeding season moves through the forest. A rival male stands between you and your chance."
	else:
		flavor = intro_pool[randi() % intro_pool.size()]
	emit_signal("event_fired", {
		"type":        "allo_male_mating",
		"resolve_key": "allo_male_mating",
		"flavor":      flavor,
		"choices":     event.get("choices", []),
	})
	return true


func _check_allo_female_mating() -> bool:
	if not GameState.is_mating_season():
		return false
	if GameState.species_id != "allosaurus":
		return false
	if GameState.sex != "female":
		return false
	if GameState.has_mate:
		return false
	if GameState.has_young:
		return false
	if GameState.species_mating_done:
		return false
	var min_stage: int = GameState.get_min_mate_stage()
	if GameState.life_stage < min_stage:
		return false

	GameState.nesting_score = 0.0  # fresh start for this breeding cycle

	var event: Dictionary  = _load_species_mate_event("allosaurus", "female")
	var intro_pool: Array  = event.get("intro", []) as Array
	var flavor: String
	if intro_pool.is_empty():
		flavor = "Breeding season fills the forest with male calls. Your choice may shape the clutch that follows."
	else:
		flavor = intro_pool[randi() % intro_pool.size()]
	emit_signal("event_fired", {
		"type":        "allo_female_mating",
		"resolve_key": "allo_female_mating",
		"flavor":      flavor,
		"choices":     event.get("choices", []),
	})
	return true


func _load_species_mate_event(species_id: String, event_type: String) -> Dictionary:
	var path := "res://scripts/dinos/%s/dino_mate.gd" % species_id
	if not ResourceLoader.exists(path):
		return {}
	var script = load(path)
	var node := Node.new()
	node.set_script(script)
	var data: Dictionary
	match event_type:
		"male":       data = node.get_male_event()
		"female":     data = node.get_female_event()
		"tournament": data = node.get_tournament_event()
		"effort":     data = node.get_effort_event()
		_:            data = {}
	node.free()
	return data


# ── GENERIC PATTERN A — challenge/leave (allosaurus, trex, ankylosaurus) ──────

func _check_pattern_a_male_mating() -> bool:
	if not GameState.is_mating_season():
		return false
	if GameState.sex != "male":
		return false
	if not GameState.species_id in ["allosaurus", "trex", "ankylosaurus"]:
		return false
	if GameState.has_mate:
		return false
	if GameState.species_mating_done:
		return false
	var min_stage: int = GameState.get_min_mate_stage()
	if GameState.life_stage < min_stage or GameState.life_stage >= 4:
		return false

	var event: Dictionary = _load_species_mate_event(GameState.species_id, "male")
	var intro_pool: Array = event.get("intro", []) as Array
	var flavor: String = intro_pool[randi() % intro_pool.size()] if not intro_pool.is_empty() else \
		"Breeding season arrives. A rival male stands between you and the chance to mate."
	emit_signal("event_fired", {
		"type":        "pattern_a_male_mating",
		"resolve_key": "pattern_a_male_mating",
		"flavor":      flavor,
		"choices":     event.get("choices", []),
	})
	return true


func _check_pattern_a_female_mating() -> bool:
	if not GameState.is_mating_season():
		return false
	if GameState.sex != "female":
		return false
	if not GameState.species_id in ["allosaurus", "trex", "ankylosaurus"]:
		return false
	if GameState.has_mate:
		return false
	if GameState.has_young:
		return false
	if GameState.species_mating_done:
		return false
	var min_stage: int = GameState.get_min_mate_stage()
	if GameState.life_stage < min_stage or GameState.life_stage >= 4:
		return false

	GameState.nesting_score = 0.0

	var event: Dictionary = _load_species_mate_event(GameState.species_id, "female")
	var intro_pool: Array = event.get("intro", []) as Array
	var flavor: String = intro_pool[randi() % intro_pool.size()] if not intro_pool.is_empty() else \
		"Breeding season fills the territory with male calls. Your choice may shape the clutch that follows."
	emit_signal("event_fired", {
		"type":        "pattern_a_female_mating",
		"resolve_key": "pattern_a_female_mating",
		"flavor":      flavor,
		"choices":     event.get("choices", []),
	})
	return true


# ── GENERIC PATTERN B — tournament + effort chain ─────────────────────────────
# (lesothosaurus, iguanodon, triceratops, argentinosaurus)

func _check_breed_effort_pending() -> bool:
	if not GameState.breed_effort_pending:
		return false
	if GameState.life_stage >= 4:
		GameState.breed_effort_pending = false
		return false
	var event: Dictionary = _load_species_mate_event(GameState.species_id, "effort")
	var intro_pool: Array = event.get("intro", []) as Array
	var flavor: String = intro_pool[randi() % intro_pool.size()] if not intro_pool.is_empty() else \
		"You won the contest. Now your choices may shape the clutch's beginning."
	emit_signal("event_fired", {
		"type":        "pattern_b_effort",
		"resolve_key": "pattern_b_effort",
		"flavor":      flavor,
		"choices":     event.get("choices", []),
	})
	return true


func _check_pattern_b_tournament() -> bool:
	if not GameState.is_mating_season():
		return false
	if GameState.sex != "male":
		return false
	if not GameState.species_id in ["lesothosaurus", "iguanodon", "triceratops", "argentinosaurus"]:
		return false
	if GameState.has_mate:
		return false
	if GameState.species_mating_done:
		return false
	var min_stage: int = GameState.get_min_mate_stage()
	if GameState.life_stage < min_stage or GameState.life_stage >= 4:
		return false

	GameState.nesting_score = 0.0

	var event: Dictionary = _load_species_mate_event(GameState.species_id, "tournament")
	var intro_pool: Array = event.get("intro", []) as Array
	var flavor: String = intro_pool[randi() % intro_pool.size()] if not intro_pool.is_empty() else \
		"Breeding season arrives. The contest is underway."
	emit_signal("event_fired", {
		"type":        "pattern_b_tournament",
		"resolve_key": "pattern_b_tournament",
		"flavor":      flavor,
		"choices":     event.get("choices", []),
	})
	return true


func _check_pattern_b_female_mating() -> bool:
	if not GameState.is_mating_season():
		return false
	if GameState.sex != "female":
		return false
	if not GameState.species_id in ["lesothosaurus", "iguanodon", "triceratops", "argentinosaurus"]:
		return false
	if GameState.has_mate:
		return false
	if GameState.has_young:
		return false
	if GameState.species_mating_done:
		return false
	var min_stage: int = GameState.get_min_mate_stage()
	if GameState.life_stage < min_stage or GameState.life_stage >= 4:
		return false

	GameState.nesting_score = 0.0

	var event: Dictionary = _load_species_mate_event(GameState.species_id, "female")
	var intro_pool: Array = event.get("intro", []) as Array
	var flavor: String = intro_pool[randi() % intro_pool.size()] if not intro_pool.is_empty() else \
		"Breeding season opens. Your choice may shape the clutch that follows."
	emit_signal("event_fired", {
		"type":        "pattern_b_female_mating",
		"resolve_key": "pattern_b_female_mating",
		"flavor":      flavor,
		"choices":     event.get("choices", []),
	})
	return true


func _check_female_nesting_prep() -> bool:
	if not GameState.is_mating_season():
		return false
	if GameState.sex != "female":
		return false
	if GameState.has_mate:
		return false
	if GameState.has_young:
		return false   # active nesting period — don't overwrite nesting_score
	if GameState.female_prep_done:
		return false
	var species := SpeciesDB.get_species(GameState.species_id)
	var mstyle  : String = species.get("mating_style", "") as String
	if mstyle not in ["pack_alpha", "pack_coalition"]:
		return false
	if GameState.pack_bond == 0.0:
		return false

	GameState.female_prep_done = true
	GameState.nesting_score    = 0.0  # fresh start for this breeding cycle

	# ── Deinonychus female uses the new breeding event system ─────────────────
	if GameState.species_id == "deinonychus":
		var ev: Dictionary  = _load_dein_mate_event("female")
		var ipool: Array    = ev.get("intro", []) as Array
		var flav: String    = ipool[randi() % ipool.size()] if not ipool.is_empty() else \
			"Breeding season settles over the pack. The future clutch has not arrived yet, but this is where its strength begins."
		emit_signal("event_fired", {
			"type":        "dein_female_breeding",
			"resolve_key": "dein_female_breeding",
			"flavor":      flav,
			"choices":     ev.get("choices", []),
		})
		return true

	var data := _load_mate_data()
	var intro_pool : Array = data.get("female_season_intro", []) as Array
	var flavor : String
	if intro_pool.is_empty():
		flavor = "Breeding season has arrived. The pack moves close, and the pull to prepare grows difficult to ignore."
	else:
		flavor = intro_pool[randi() % intro_pool.size()]

	var nest_label  : String = data.get("female_prep_nest_label",  "Prepare a hidden nest")   as String
	var food_label  : String = data.get("female_prep_food_label",  "Search for extra food")   as String
	var group_label : String = data.get("female_prep_group_label", "Stay close to the group") as String

	emit_signal("event_fired", {
		"type":        "female_nesting_prep",
		"resolve_key": "female_nesting_prep",
		"flavor":      flavor,
		"choices": [
			{ "label": nest_label,            "icon": "stalk",  "sublabel": "Costs hunger. Strong start to the season.", "action": "prepare_nest"  },
			{ "label": food_label,            "icon": "attack", "sublabel": "Costs hunger. Moderate start.",             "action": "seek_food"     },
			{ "label": group_label,           "icon": "bond",   "sublabel": "No cost. Neutral start.",                   "action": "stay_close"    },
			{ "label": "Ignore the season",   "icon": "flee",   "sublabel": "No cost. Weak start.",                      "action": "ignore_season" },
		],
	})
	return true


func _load_hatchling_data() -> Array:
	var path := "res://scripts/dinos/%s/dino_hatchling.gd" % GameState.species_id
	if ResourceLoader.exists(path):
		var script = load(path)
		var node := Node.new()
		node.set_script(script)
		var events: Array = node.get_hatchling_events() as Array
		node.free()
		return events
	return []


func _load_juvenile_data() -> Array:
	var path := "res://scripts/dinos/%s/dino_juvenile.gd" % GameState.species_id
	if ResourceLoader.exists(path):
		var script = load(path)
		var node := Node.new()
		node.set_script(script)
		var events: Array = node.get_juvenile_events() as Array
		node.free()
		return events
	return []


const MOTHER_BOND_SPECIES := ["trex", "allosaurus", "ankylosaurus"]

func _check_juvenile_parent_event() -> bool:
	if GameState.life_stage != 1:
		return false
	if GameState.juvenile_lesson_done:
		return false
	var events := _load_juvenile_data()
	if events.is_empty():
		return false

	var event: Dictionary = events[randi() % events.size()] as Dictionary
	var uses_mother_bond := GameState.species_id in MOTHER_BOND_SPECIES

	if uses_mother_bond:
		GameState.active_mother_bond_outcomes = event.get("outcomes", {}) as Dictionary
	else:
		GameState.active_juvenile_outcomes = event.get("outcomes", {}) as Dictionary

	var intro_pool: Array = event.get("intro", []) as Array
	var flavor: String = intro_pool[randi() % intro_pool.size()] if not intro_pool.is_empty() else \
		"Your parent is here. The season asks something of you."

	var resolve_key: String = "mother_bond_event" if uses_mother_bond else "juvenile_parent_event"
	emit_signal("event_fired", {
		"type":        resolve_key,
		"resolve_key": resolve_key,
		"flavor":      flavor,
		"choices":     event.get("choices", []),
	})
	return true


func _check_juvenile_lesson_outcome() -> bool:
	if not GameState.juvenile_outcome_pending:
		return false
	GameState.juvenile_outcome_pending = false
	GameState.juvenile_lesson_done     = true

	var flavor: String

	if GameState.species_id in MOTHER_BOND_SPECIES:
		# ── Mother-bond departure (T-Rex / Allosaurus) ──────────────────────────
		var bond := GameState.mother_bond
		GameState.mother_bond = 0.0

		if bond >= 1.0:
			# Great Bond — all 4 stats +0.04
			GameState.permanent_health_mod   += 0.04
			GameState.permanent_strength_mod += 0.04
			GameState.permanent_speed_mod    += 0.04
			GameState.permanent_defense_mod  += 0.04
			GameState.health   = minf(1.0, GameState.health   + 0.04)
			GameState.strength = minf(1.0, GameState.strength + 0.04)
			GameState.speed    = minf(1.0, GameState.speed    + 0.04)
			GameState.defense  = minf(1.0, GameState.defense  + 0.04)
			GameState.bonuses_earned.append("Great Bond")
			flavor = "She is gone from the hillside, but everything she taught is still in the body. You move differently now. You always will."
		elif bond >= 0.5:
			# Good Bond — all 4 stats +0.025
			GameState.permanent_health_mod   += 0.025
			GameState.permanent_strength_mod += 0.025
			GameState.permanent_speed_mod    += 0.025
			GameState.permanent_defense_mod  += 0.025
			GameState.health   = minf(1.0, GameState.health   + 0.025)
			GameState.strength = minf(1.0, GameState.strength + 0.025)
			GameState.speed    = minf(1.0, GameState.speed    + 0.025)
			GameState.defense  = minf(1.0, GameState.defense  + 0.025)
			GameState.bonuses_earned.append("Strong Bond")
			flavor = "She leaves you at the edge of her territory without turning back. The seasons between you were not perfect. But they left something real."
		elif bond >= 0.1:
			# Neutral — no stat change
			flavor = "The juvenile seasons are behind you now. You carry what stuck and leave behind what didn't. She is already gone."
		elif bond >= -0.2:
			# Weak Bond — all 4 stats -0.02
			GameState.permanent_health_mod   -= 0.02
			GameState.permanent_strength_mod -= 0.02
			GameState.permanent_speed_mod    -= 0.02
			GameState.permanent_defense_mod  -= 0.02
			GameState.health   = maxf(0.0, GameState.health   - 0.02)
			GameState.strength = maxf(0.0, GameState.strength - 0.02)
			GameState.speed    = maxf(0.0, GameState.speed    - 0.02)
			GameState.defense  = maxf(0.0, GameState.defense  - 0.02)
			flavor = "She is gone before you were ready. The bond between you never had the time to hold. You feel the gap where the lessons should have been."
		else:
			# Broken Bond — all 4 stats -0.04
			GameState.permanent_health_mod   -= 0.04
			GameState.permanent_strength_mod -= 0.04
			GameState.permanent_speed_mod    -= 0.04
			GameState.permanent_defense_mod  -= 0.04
			GameState.health   = maxf(0.0, GameState.health   - 0.04)
			GameState.strength = maxf(0.0, GameState.strength - 0.04)
			GameState.speed    = maxf(0.0, GameState.speed    - 0.04)
			GameState.defense  = maxf(0.0, GameState.defense  - 0.04)
			flavor = "She is gone. The seasons between you were cold and distant. You step into sub-adult life carrying the weight of lessons that never came."
	else:
		# ── Generic juvenile lesson score (other species) ────────────────────────
		var score := GameState.juvenile_lesson_score
		GameState.juvenile_lesson_score = 0.0

		if score >= 0.5:
			GameState.permanent_strength_mod += 0.08
			GameState.strength = minf(1.0, GameState.strength + 0.08)
			GameState.bonuses_earned.append("Raised Well")
			flavor = "The juvenile seasons with your parent left something permanent. Your body carries what they taught."
		elif score >= 0.3:
			GameState.permanent_strength_mod += 0.05
			GameState.strength = minf(1.0, GameState.strength + 0.05)
			GameState.bonuses_earned.append("Well Raised")
			flavor = "Your parent's guidance left a mark. Not everything they taught took — but enough did."
		elif score >= 0.1:
			GameState.permanent_speed_mod += 0.04
			GameState.speed = minf(1.0, GameState.speed + 0.04)
			GameState.bonuses_earned.append("Fair Start")
			flavor = "You learned enough in those seasons to move a little faster and smarter than before."
		else:
			flavor = "The time with your parent is behind you now. You step into the sub-adult season alone."

	emit_signal("event_fired", { "type": "juvenile_lesson_outcome", "flavor": flavor, "choices": [] })
	_emit_stat_changes()
	return true


# ── MATERNAL BOND SYSTEM ───────────────────────────────────────────────────────
# Female player raising her own juvenile offspring (parent's perspective).
# Parallel to the child-side mother_bond system — same species, opposite view.

const MATERNAL_JUVENILE_SEASONS := 4  # how many seasons the juvenile phase lasts

func _load_maternal_data() -> Array:
	var path := "res://scripts/dinos/%s/dino_maternal.gd" % GameState.species_id
	if ResourceLoader.exists(path):
		var script = load(path)
		var node := Node.new()
		node.set_script(script)
		var events: Array = node.get_maternal_events() as Array
		node.free()
		return events
	return []


func _check_maternal_bond_event() -> bool:
	if not GameState.has_juvenile:
		return false
	if GameState.maternal_bond_done:
		return false
	if GameState.sex != "female":
		return false
	if not (GameState.species_id in MOTHER_BOND_SPECIES):
		return false

	# Phase expiry — juvenile is leaving this season; queue departure for next turn
	if GameState.juvenile_bond_turns > MATERNAL_JUVENILE_SEASONS:
		GameState.has_juvenile             = false
		GameState.maternal_outcome_pending = true
		return false  # does not consume the turn; outcome resolves next season

	var events := _load_maternal_data()
	if events.is_empty():
		return false

	var event: Dictionary = events[randi() % events.size()] as Dictionary
	GameState.active_maternal_outcomes = event.get("outcomes", {}) as Dictionary

	var intro_pool: Array = event.get("intro", []) as Array
	var flavor: String = intro_pool[randi() % intro_pool.size()] if not intro_pool.is_empty() else \
		"Your offspring is watching everything you do."
	if GameState.juvenile_name.is_empty():
		GameState.juvenile_name = LIFE_STORY.young_name()
	flavor = "%s is growing more independent.\n\n%s" % [GameState.juvenile_name, flavor]

	emit_signal("event_fired", {
		"type":        "maternal_bond_event",
		"resolve_key": "maternal_bond_event",
		"flavor":      flavor,
		"choices":     event.get("choices", []),
	})
	return true


func _check_maternal_bond_outcome() -> bool:
	if not GameState.maternal_outcome_pending:
		return false
	GameState.maternal_outcome_pending = false
	GameState.maternal_bond_done       = true

	var bond := GameState.offspring_bond
	GameState.offspring_bond = 0.0

	# Choose a random stat to receive the permanent bonus or penalty
	var stat_pool := ["health", "strength", "speed", "defense"]
	var chosen_stat: String = stat_pool[randi() % stat_pool.size()]
	var perm_key    := "permanent_" + chosen_stat + "_mod"

	var flavor: String
	if bond >= 1.0:
		# Great Maternal Bond — chosen stat +0.04; experienced-parent carry-over increases
		GameState.set(chosen_stat, minf(1.0, GameState.get(chosen_stat) + 0.04))
		GameState.set(perm_key,    GameState.get(perm_key)    + 0.04)
		GameState.offspring_bond_start = minf(0.60, GameState.offspring_bond_start + 0.20)
		GameState.bonuses_earned.append("Great Mother")
		preload("res://scripts/systems/perks.gd").record_grant("Great Mother", chosen_stat, 0.04)
		flavor = "They leave your territory without looking back — which is exactly what you prepared them for. The seasons you gave them are in how they move. Something in you is sharper for having raised them well."
	elif bond >= 0.5:
		# Strong Maternal Bond — chosen stat +0.025; carry-over increases
		GameState.set(chosen_stat, minf(1.0, GameState.get(chosen_stat) + 0.025))
		GameState.set(perm_key,    GameState.get(perm_key)    + 0.025)
		GameState.offspring_bond_start = minf(0.60, GameState.offspring_bond_start + 0.10)
		GameState.bonuses_earned.append("Good Mother")
		preload("res://scripts/systems/perks.gd").record_grant("Good Mother", chosen_stat, 0.025)
		flavor = "They are ready. You are not certain of everything you gave them, but you gave enough. They move off at the edge of your territory to find their own range. The bond between you left something real."
	elif bond >= 0.1:
		# Neutral — no stat change, no carry-over
		flavor = "The juvenile seasons are done. They move off into the wider range and you do not follow. Whatever took and whatever didn't — it is theirs now."
	elif bond >= -0.2:
		# Weak Bond — chosen stat -0.02
		GameState.set(chosen_stat, maxf(0.0, GameState.get(chosen_stat) - 0.02))
		GameState.set(perm_key,    GameState.get(perm_key)    - 0.02)
		flavor = "They leave before you were finished with them. The bond between you never held the way it should have. The cost of that is in you now."
	else:
		# Broken Bond — chosen stat -0.04; carry-over decreases (next offspring harder to reach)
		GameState.set(chosen_stat, maxf(0.0, GameState.get(chosen_stat) - 0.04))
		GameState.set(perm_key,    GameState.get(perm_key)    - 0.04)
		GameState.offspring_bond_start = maxf(-0.10, GameState.offspring_bond_start - 0.05)
		flavor = "They are gone from your territory and the seasons between you were not good ones. The gap where the bond should have been is something you will carry."

	var child_name := GameState.juvenile_name
	if child_name.is_empty():
		child_name = LIFE_STORY.young_name()
	LIFE_STORY.finish_parenting(child_name, "strong" if bond >= 0.5 else ("distant" if bond < 0.1 else "steady"))
	flavor = "%s is leaving your range.\n\n%s" % [child_name, flavor]
	GameState.juvenile_name = ""
	emit_signal("event_fired", { "type": "maternal_bond_outcome", "flavor": flavor, "choices": [] })
	_emit_stat_changes()
	return true


func _check_hatchling_event() -> bool:
	if not GameState.has_young:
		return false
	var species   := SpeciesDB.get_species(GameState.species_id)
	var max_turns: int = species.get("nesting_seasons", 3)
	if GameState.has_young_turns > max_turns:
		return false  # outcome should have already fired

	var events := _load_hatchling_data()
	if events.is_empty():
		return false  # no content yet — fall through to world event

	var event: Dictionary = events[randi() % events.size()] as Dictionary
	GameState.active_hatchling_outcomes = event.get("outcomes", {}) as Dictionary

	var intro_pool: Array = event.get("intro", []) as Array
	var flavor: String
	if intro_pool.is_empty():
		flavor = "The young are here. The season asks something of you."
	else:
		flavor = intro_pool[randi() % intro_pool.size()]
	flavor = "%s, your hatchling, stays close.\n\n%s" % [LIFE_STORY.young_name(), flavor]

	emit_signal("event_fired", {
		"type":            "hatchling_event",
		"resolve_key":     "hatchling_event",
		"flavor":          flavor,
		"choices":         event.get("choices", []),
		"hatchling_season": GameState.has_young_turns + 1,
		"hatchling_max":    max_turns,
	})
	return true


func _check_nesting_outcome() -> bool:
	if not GameState.has_young:
		return false
	var species   := SpeciesDB.get_species(GameState.species_id)
	var max_turns: int = species.get("nesting_seasons", 3)
	if GameState.has_young_turns <= max_turns:
		return false  # still in hatchling period — outcome fires after nesting_seasons seasons

	# Nesting period ends — resolve outcome
	GameState.has_young    = false
	GameState.has_young_turns = 0

	var score := GameState.nesting_score
	GameState.nesting_score = 0.0

	# Scale outcome thresholds to nesting cycle length so that shorter cycles (Comps = 2,
	# Raptor/Dein = 3) have the same full tier range available as longer ones (T-Rex = 5).
	# T-Rex (5 seasons) is the baseline — its thresholds are unchanged at 0.75 / 0.50 / 0.25.
	var scale := max_turns / 5.0
	var tier: String
	var bond_delta: float
	if score >= 0.75 * scale:
		tier = "outcome_exceptional";  bond_delta =  0.25
	elif score >= 0.50 * scale:
		tier = "outcome_good";         bond_delta =  0.15
	elif score >= 0.25 * scale:
		tier = "outcome_okay";         bond_delta =  0.05
	elif score >= 0.0:
		tier = "outcome_neutral";      bond_delta =  0.0
	elif score >= -0.25 * scale:
		tier = "outcome_poor";         bond_delta = -0.10
	else:
		tier = "outcome_failed";       bond_delta = -0.20

	var is_pack_species: bool = species.get("pack_species", false) as bool
	if is_pack_species and GameState.pack_bond > 0.0:
		PackManager.modify_bond(bond_delta)

	# ── Good parent boost ─────────────────────────────────────────────────────
	const MAX_GOOD_PARENT_BOOSTS := 2
	const MAX_SOLO_RAISE_BOOSTS  := 2
	var good_parent_note := ""
	var max_turns_for_boost: int = species.get("nesting_seasons", 3)
	if GameState.good_parent_seasons >= max_turns_for_boost \
			and GameState.good_parent_boosts < MAX_GOOD_PARENT_BOOSTS:
		GameState.permanent_health_mod += 0.05
		GameState.health = minf(1.0, GameState.health + 0.05)
		GameState.good_parent_boosts += 1
		GameState.bonuses_earned.append("Good Parent")
		good_parent_note = " Your consistency left something permanent in the body."
	GameState.good_parent_seasons = 0

	# ── Solo raise boost (non-pack species) ──────────────────────────────────
	var solo_note := ""
	if (not is_pack_species or GameState.pack_bond == 0.0) \
			and tier in ["outcome_exceptional", "outcome_good"]:
		# Always grant the 4-season strength temp buff regardless of cap
		GameState.apply_temp_buff("strength", 0.12, 4, "solo_raise_strength")
		if GameState.solo_raise_boosts < MAX_SOLO_RAISE_BOOSTS:
			GameState.permanent_health_mod += 0.05
			GameState.health = minf(1.0, GameState.health + 0.05)
			GameState.solo_raise_boosts += 1
			GameState.bonuses_earned.append("Successful Solo Raise")
			solo_note = " Raising them alone left you stronger for it. Something in you is sharper now."
		else:
			solo_note = " Raising them alone left you with an edge. It won't last — but it's real for now."

	var data  := _load_nest_data()
	var pool: Array = data.get(tier, []) as Array
	var flavor: String
	if pool.is_empty():
		match tier:
			"outcome_exceptional": flavor = "The young are strong and settled. The season gave more than you could have asked for."
			"outcome_good":        flavor = "The young grew well. A good season for them."
			"outcome_okay":        flavor = "The young survived. Not easy — but they made it through."
			"outcome_neutral":     flavor = "The young moved on. A quiet end to a quiet season of raising them."
			"outcome_poor":        flavor = "It was harder than it should have been. The young are gone now. The pack feels the gap."
			_:                     flavor = "The nesting season was difficult. The young are gone and the group feels thinner for it."
	else:
		flavor = pool[randi() % pool.size()]

	flavor += good_parent_note + solo_note
	var child_name := LIFE_STORY.young_name()
	flavor = "The nesting seasons with %s are over.\n\n%s" % [child_name, flavor]

	# ── Maternal bond: begin juvenile phase if applicable ────────────────────────
	# Fires for female Pattern A species whose male leaves after mating — she raises alone.
	if GameState.sex == "female" and GameState.species_id in MOTHER_BOND_SPECIES \
			and tier != "outcome_failed":
		# A new clutch can finish while an older juvenile is still with its parent.
		if not GameState.juvenile_name.is_empty() and not GameState.maternal_bond_done:
			LIFE_STORY.finish_parenting(GameState.juvenile_name, "strong" if GameState.offspring_bond >= 0.5 else ("distant" if GameState.offspring_bond < 0.1 else "steady"))
		GameState.juvenile_name = child_name
		GameState.has_juvenile             = true
		GameState.juvenile_bond_turns      = 0
		GameState.offspring_bond           = GameState.offspring_bond_start
		GameState.maternal_bond_done       = false
		GameState.maternal_outcome_pending = false
	else:
		var bond := "steady"
		if tier in ["outcome_exceptional", "outcome_good"]:
			bond = "strong"
		elif tier == "outcome_poor":
			bond = "distant"
		elif tier == "outcome_failed":
			bond = "lost"
		LIFE_STORY.finish_parenting(child_name, bond)

	emit_signal("event_fired", { "type": "nesting_outcome", "flavor": flavor, "choices": [] })
	_emit_stat_changes()
	return true


func _apply_consistency_change(bonus_type: String) -> void:
	_bonuses_this_stage += 1
	var stage_name := GameState.get_stage_name()
	var event_data: Dictionary
	match bonus_type:
		"hunger_high":
			GameState.permanent_defense_mod += 0.05
			GameState.defense = minf(1.0, GameState.defense + 0.05)
			GameState.bonuses_earned.append("Well Fed %s" % stage_name)
			event_data = {
				"type": "consistency_bonus",
				"flavor": "Seasons of steady feeding have settled into the body. It feels more durable somehow.",
				"choices": []
			}
		"hunger_low":
			GameState.permanent_health_mod -= 0.05
			GameState.health = maxf(0.0, GameState.health - 0.05)
			event_data = {
				"type": "consistency_penalty",
				"flavor": "The hunger has run too long. Something in the body has quietly given a little.",
				"choices": []
			}
		"health_high":
			GameState.permanent_speed_mod += 0.04
			GameState.speed = minf(1.0, GameState.speed + 0.04)
			GameState.bonuses_earned.append("Thriving %s" % stage_name)
			event_data = {
				"type": "consistency_bonus",
				"flavor": "Seasons of full health have sharpened everything. Movement feels faster, more certain.",
				"choices": []
			}
		"type_stat_high":
			GameState.type_stat = minf(1.0, GameState.type_stat + 0.04)
			GameState.bonuses_earned.append("Keen %s" % stage_name)
			event_data = {
				"type": "consistency_bonus",
				"flavor": "Long practice has made the instinct sharper. Some things come without thinking now.",
				"choices": []
			}
		_:
			return
	emit_signal("event_fired", event_data)
	_emit_stat_changes()


func _emit_stat_changes() -> void:
	var new_perks := preload("res://scripts/systems/perks.gd").award()
	if not new_perks.is_empty():
		GameState.save_run()
	emit_signal("stat_changed")
