extends "res://scripts/dinos/base_dino_mate.gd"

# Deinonychus — mating season events (pack_coalition system replaced by new branching events)
#
# ── SUB-MALE EVENT ────────────────────────────────────────────────────────────
# Fires once per mating season when player is male and NOT alpha.
# Choices: Challenge / Stay
#   Stay  → no mate, no hatchling events, pack_bond unchanged
#   Challenge → PackManager.resolve_alpha_fight()
#       Win  → is_alpha = true; alpha_breed_pending = true (breeding fires next turn)
#       Loss → stays in pack, no mate
#
# ── RIVAL CHALLENGE EVENT ─────────────────────────────────────────────────────
# Fires at mating-season start when player IS alpha.
# Challenger probability: 0.50 + alpha_seasons_unchallenged * 0.20, cap 0.90
# Choices: Fight / Yield
#   Fight → PackManager.resolve_defender_fight()
#       Win  → still alpha; alpha_breed_pending = true (breeding fires next turn)
#       Loss → is_alpha = false; no breeding this season
#   Yield → is_alpha = false; no breeding this season
#
# ── ALPHA BREEDING EVENT ─────────────────────────────────────────────────────
# Fires the turn after winning/surviving a challenge (or first turn of mating season
# if already unchallenged alpha). Requires is_alpha == true.
# 4 choices × 4 tiers (strong_success / success / mixed / fail)
# Hunger costs: lead 0.12 / guard 0.07 / offer 0.04 / let 0.0
# Nesting score:   lead (+0.30/+0.20/+0.05/-0.10)
#                  guard (+0.20/+0.15/+0.05/-0.05)
#                  offer (+0.10/+0.08/+0.03/0.0)
#                  let   (+0.05/+0.03/-0.05/-0.15)
#
# ── FEMALE BREEDING EVENT ────────────────────────────────────────────────────
# Always fires for female during mating season. 4 choices × 4 tiers.
# Same hunger costs and nesting score deltas as alpha breeding (by position).
#
# ── FIGHT INJURIES (random pick on injury result) ────────────────────────────
# "Sickle Claw Slash" → speed  -0.08, 2 turns
# "Pack Rake"         → strength -0.08, 2 turns
# "Feather Bite"      → defense  -0.08, 2 turns

# ── Legacy flat data (keep for _load_mate_data() compatibility) ───────────────
const MATE_DATA: Dictionary = {
	"seek_male_alpha":          [],
	"seek_male_sub":            [],
	"seek_female_pack":         [],
	"coalition_alpha":          [],
	"coalition_sub_permitted":  [],
	"coalition_sub_sneak":      [],
	"sub_submitted":            [],
	"sub_left_pack":            [],
	"female_accept_alpha":      [],
	"female_chose_sub_success": [],
	"female_chose_sub_caught":  [],
	"success":                  [],
	"no_mate":                  [],
}

func get_mate_data() -> Dictionary:
	return MATE_DATA


# ── SUB-MALE EVENT ────────────────────────────────────────────────────────────

const DEIN_SUB_EVENT: Dictionary = {
	"intro": [
		"Breeding season sharpens the pack's rhythm. The alpha male stands at the center of it, and every other male knows what that means.",
		"The pack remains together, but the season changes the air. The alpha watches the females closely, while the other males keep their distance.",
		"The scent of breeding season moves through the ferns. You are still part of the pack, but not the male who gets to continue his line.",
		"The alpha's calls carry farther this season. His place is clear, and if you want it, you will have to challenge him.",
		"The pack gathers in tense silence. You can feel the pull to mate, but the alpha male stands between you and that chance.",
		"Every movement in the pack feels sharper now. The alpha male notices your attention and waits to see if you will test him.",
		"The hunting rhythm still includes you, but breeding season does not. Not unless you take the alpha's place.",
	],
	"choices": [
		{ "label": "Challenge the alpha", "sublabel": "Take his place or stay behind", "icon": "attack", "action": "challenge" },
		{ "label": "Stay in your place",  "sublabel": "Wait for another season",       "icon": "flee",   "action": "stay"      },
	],
	"outcomes": {
		"stay": [
			"You hold your position and let the alpha keep his place. The season passes without your bloodline moving forward.",
			"You remain with the pack, hunting and surviving, but the breeding season belongs to another male.",
			"The pull to challenge fades into restraint. You stay in the pack, but you do not mate this season.",
			"You lower your posture and avoid the alpha's stare. The pack remains stable, but your chance passes.",
			"You choose survival and pack safety over challenge. The season continues around you without your claim.",
			"You keep your place among the hunters and wait for another season, another weakness, another chance.",
			"The alpha does not need to fight you today. You stay, but you do not rise.",
		],
		"challenge": {
			"win": [
				"You read the alpha's first strike and answer with sharper timing. He gives ground, and the pack's rhythm shifts toward you.",
				"The fight tears through the ferns in a flash of feathers, claws, and warning calls. When it ends, you stand where the alpha stood.",
				"The alpha pushes hard, but your hunger for the place is stronger. You drive him back and claim the center of the pack.",
				"Your sickle claw finds the opening. The alpha retreats, and the pack falls into a new rhythm around you.",
				"You outlast his power and break his control. The pack does not scatter. It watches you now.",
				"The challenge is brutal but brief. The old alpha steps away, and your calls become the ones the pack answers.",
				"You win the right to lead this season. The pack remains tense, but your place is clear.",
			],
			"loss": [
				"The alpha turns your challenge aside and forces you back into your old place.",
				"You strike, but his control is stronger. He holds the center, and you remain only another hunter in the pack.",
				"The fight ends with the alpha still standing over the trail. You lose, but the pack does not drive you out.",
				"Your challenge fails. The alpha's warning call cuts through the ferns, and you fall back into line.",
				"He beats your timing and pushes you away from the center. You remain in the pack, but not as alpha.",
				"The pack watches the fight settle against you. You survive the challenge, but the breeding season is not yours.",
				"You retreat from the clash before it turns worse. The alpha keeps his place, and you keep yours.",
			],
			"loss_injured": [
				"The alpha catches you during the clash and leaves you hurt enough to remember your place.",
				"You survive the challenge, but not cleanly. Pain follows you back to the edge of the pack.",
				"The fight turns against you in a burst of feathers and force. You stay with the pack, wounded but alive.",
				"The alpha drives you down hard before letting you retreat. You keep your place, but carry a minor injury from the challenge.",
				"Your timing slips, and the alpha punishes the mistake. You remain in the pack, sore and defeated.",
				"The challenge ends with you forced back, wounded, and unable to claim the season.",
				"You lose the fight and limp back into the pack's rhythm, still accepted, but clearly beaten.",
			],
		},
	},
}

func get_dein_sub_event() -> Dictionary:
	return DEIN_SUB_EVENT


# ── RIVAL CHALLENGE EVENT ─────────────────────────────────────────────────────

const DEIN_RIVAL_EVENT: Dictionary = {
	"intro": [
		"A younger male has begun matching your steps too closely. Breeding season has made him bold enough to test your place.",
		"The pack's rhythm tightens as another male steps toward the center. His feathers lift, and his eyes stay locked on you.",
		"You hear the challenge call before you see him. Another male wants the season that currently belongs to you.",
		"The pack falls into uneasy silence as a rival male cuts across your path.",
		"Your alpha place draws a challenger from within the pack. He does not want to leave. He wants to replace you.",
	],
	"choices": [
		{ "label": "Fight to stay alpha", "sublabel": "Defend your place", "icon": "attack", "action": "fight" },
		{ "label": "Yield your place",    "sublabel": "Let him take it",   "icon": "flee",   "action": "yield" },
	],
	"outcomes": {
		"yield": [
			"You read the challenger's intent and step aside before the pack tears itself open.",
			"You yield the center without a fight. The pack remains whole, but the breeding season is no longer yours.",
			"You let the rival take alpha and keep your place among the hunters.",
			"You lower your posture and avoid the clash, surrendering the season but staying with the pack.",
			"You choose pack stability over blood. The challenger becomes alpha, and you remain one of the hunters.",
		],
		"fight": {
			"win": [
				"You meet the challenge with clean timing and drive him back into his old place.",
				"The rival tests your rank and fails. The pack's rhythm returns to you.",
				"You strike hard enough to end the question. He stays in the pack, but not at the center.",
				"The challenger breaks away first, and your place remains secure.",
				"You hold alpha through strength, control, and the pack's watching silence.",
			],
			"loss": [
				"The challenger beats your timing and takes the center of the pack. You remain with them, but no longer as alpha.",
				"You lose the clash, and the pack's breeding rhythm shifts away from you.",
				"The rival claims your place without driving you out. You are still pack, but not the male this season.",
				"The fight ends with you forced aside while the challenger stands where you stood.",
				"Your alpha claim breaks, and another male takes the season.",
			],
			"loss_injured": [
				"The challenger lands a punishing strike before taking your place. You stay with the pack, wounded and dethroned.",
				"The fight turns against you, and pain follows you back to the edge of the group.",
				"You lose alpha and carry a minor injury from the challenge.",
				"The rival's final strike forces you aside, hurt but still part of the pack.",
				"You survive the challenge, but the center of the pack no longer belongs to you.",
			],
		},
	},
}

func get_dein_rival_event() -> Dictionary:
	return DEIN_RIVAL_EVENT


# ── ALPHA BREEDING EVENT ─────────────────────────────────────────────────────

const DEIN_ALPHA_BREEDING_EVENT: Dictionary = {
	"intro": [
		"The pack's rhythm bends around you now. Breeding season has given you the center, but what you give this season still matters.",
		"You are the alpha male now. The females watch your movement, and the pack waits to see how strongly you will lead.",
		"The old challenge is settled. Your calls carry farther than before, but the season still demands effort.",
		"Breeding season sharpens the pack's hunger and tension. You can spend yourself fully, offer steady support, give what little you can, or let the season pass.",
		"The pack follows your rhythm this season. Every call, every guarded path, and every shared meal may shape what comes next.",
	],
	"choices": [
		{ "label": "Lead with full strength and fresh kills", "sublabel": "Costs 12% food · best chance · biggest boost", "icon": "attack", "action": "lead"  },
		{ "label": "Keep the pack steady and guarded",        "sublabel": "Costs 7% food · good chance · solid boost",    "icon": "stalk",  "action": "guard" },
		{ "label": "Offer what support you can",              "sublabel": "Costs 4% food · small boost",                  "icon": "bond",   "action": "offer" },
		{ "label": "Let the season carry itself",             "sublabel": "No cost · risk of penalty",              "icon": "flee",   "action": "let"   },
	],
	"outcomes": {
		"lead": {
			"strong_success": [
				"You spend yourself on food, calls, and clean movement until the pack's rhythm locks around you. The season begins with powerful promise.",
				"You lead the pack through coordinated hunts and return with enough food to quiet the tension. The females stay close, and the pack follows your signals.",
				"Your effort is costly, but undeniable. The pack gathers around your strength, and breeding season turns strongly in your favor.",
				"Fresh kills, sharp calls, and controlled movement prove your place beyond question. The future clutch gains a strong beginning.",
				"You give everything the season asks for, and the pack answers with trust, closeness, and steady rhythm.",
			],
			"success": [
				"Your effort steadies the pack and gives the breeding season a strong chance.",
				"You provide enough food and leadership to keep the pack focused around you.",
				"The pack follows your calls well, and the season moves forward with confidence.",
				"Your full effort pays off, even if the pack still carries some tension.",
				"You prove your alpha place through action, and the season begins well.",
			],
			"mixed": [
				"You bring food and lead hard, but the effort leaves you hungry and the pack still restless in places.",
				"Your display impresses some of the pack, but scattered timing keeps the season from feeling perfect.",
				"The pack benefits from your effort, though the cost to your own strength is clear.",
				"You push hard enough to help the season, but not every hunter falls fully into rhythm.",
				"Your leadership works, but the pack's tension does not disappear completely.",
			],
			"fail": [
				"You spend too much energy trying to prove yourself, and the pack's rhythm never fully settles.",
				"The hunts cost more than they return, leaving the season weaker than your effort deserved.",
				"Your calls come sharp and strong, but the pack remains uncertain around them.",
				"You give heavily, but poor timing and hunger dull the season's promise.",
				"The effort drains you without giving the breeding season the momentum you needed.",
			],
		},
		"guard": {
			"strong_success": [
				"You guard the nesting ground and keep the pack moving in a calm, controlled rhythm. The season starts with steady strength.",
				"Your patrols keep danger away while your calls keep the pack close. The future feels well protected.",
				"You do not dazzle the pack with excess, but your steady control gives the season a strong foundation.",
				"The pack settles under your watch, tense but united. Breeding season begins cleanly.",
				"You hold the center with patience and strength, giving the coming clutch a safer start.",
			],
			"success": [
				"Your guarding keeps the pack stable enough for the season to move forward.",
				"You protect the best nesting paths and help the pack stay close.",
				"The season begins with solid support and little trouble.",
				"Your steady presence gives the pack enough confidence to continue.",
				"You keep danger away and give the future clutch a fair beginning.",
			],
			"mixed": [
				"Your defense helps, but some hunters stay restless near the edge of the pack.",
				"The nesting ground feels safer, though the pack's bond remains uneven.",
				"You guard well in places, but your attention cannot settle every tension.",
				"The season gains some safety, but not enough to feel fully secure.",
				"Your patrols matter, though the pack still carries unease beneath the feathers.",
			],
			"fail": [
				"You guard the area, but the pack never fully relaxes around your lead.",
				"Your warning calls grow too sharp, making the group cautious instead of confident.",
				"The nesting ground stays watched, but the season feels thin and uncertain.",
				"Your effort keeps threats away, but does little to bring the pack closer.",
				"You defend the ground, yet the breeding season struggles to take hold.",
			],
		},
		"offer": {
			"strong_success": [
				"Even with little to give, you choose the right moments. A shared trail, a useful call, and a small meal help the season more than expected.",
				"Your limited support lands cleanly. The pack responds, and the breeding season gains surprising strength.",
				"You conserve your hunger but still guide the pack well enough to make the season feel promising.",
				"A few careful choices carry farther than expected, giving the future clutch a better start.",
				"You offer little, but wisely. The pack stays close enough for the season to begin well.",
			],
			"success": [
				"Your support is modest, but it helps the pack settle.",
				"You give enough attention to keep the season from slipping away.",
				"The pack remains near your rhythm, though not strongly.",
				"Your effort gives the breeding season a small but real chance.",
				"You help where you can, and the pack accepts it.",
			],
			"mixed": [
				"Your support helps some, but the season still feels fragile.",
				"You save your strength, and the pack feels the difference.",
				"A few hunters respond to your lead, while others drift.",
				"The future gains a little, but the season remains uncertain.",
				"Your small effort keeps the chance alive, but only barely.",
			],
			"fail": [
				"You give too little, and the pack's attention begins to slip away from you.",
				"The season needs more than you offer, and the future clutch gains little.",
				"Your limited support fails to steady the pack.",
				"The pack remains tense, and breeding season weakens around you.",
				"You save hunger, but the chance for a strong start fades.",
			],
		},
		"let": {
			"strong_success": [
				"You give little effort, but your alpha place still carries enough weight for the season to continue.",
				"Somehow, the pack remains close despite your distance, and the breeding season keeps a small promise.",
				"Luck carries what effort does not. The pack holds just enough rhythm around you.",
				"You save your strength, and the season still finds a narrow path forward.",
				"The pack stays near without much help from you, giving the future a faint but real chance.",
			],
			"success": [
				"The season continues, but weakly, carried more by your rank than your effort.",
				"Your alpha position alone keeps the chance alive.",
				"The pack stays close enough for breeding season to move forward, though not strongly.",
				"You give little, but the season does not fully fail.",
				"The future remains possible, even without much support from you.",
			],
			"mixed": [
				"Your lack of effort leaves the pack restless, and the season begins weaker than it should.",
				"The females drift from your signals while the pack grows less centered around you.",
				"The season continues around you, but the future clutch gains little from your leadership.",
				"You save hunger, but the pack's rhythm thins.",
				"The breeding season remains possible, but the start feels fragile.",
			],
			"fail": [
				"You ignore the season too long, and the opportunity fades.",
				"The pack's attention cools around you, weakening the chance for a future clutch.",
				"You remain alpha, but this season slips away from your control.",
				"The females move with the pack, but not toward your lead.",
				"You save your strength, and the breeding season pays the price.",
			],
		},
	},
}

func get_dein_alpha_breeding_event() -> Dictionary:
	return DEIN_ALPHA_BREEDING_EVENT


# ── FEMALE BREEDING EVENT ─────────────────────────────────────────────────────

const DEIN_FEMALE_BREEDING_EVENT: Dictionary = {
	"intro": [
		"Breeding season sharpens the pack's rhythm. The alpha male holds the center, but your choices can still shape how strong the future clutch begins.",
		"The pack moves close through the ferns, tense and watchful. Breeding season has arrived, and the nest's future depends on more than the alpha alone.",
		"The alpha's calls carry through the brush, but you feel the deeper pull of the season in your own body. Food, safety, and pack closeness all matter now.",
		"The pack gathers around familiar nesting paths. You can give heavily, support steadily, offer what little you can, or let the season move without you.",
		"Breeding season settles over the pack like a silent command. The future clutch has not arrived yet, but this is where its strength begins.",
	],
	"choices": [
		{ "label": "Give everything to the nesting season", "sublabel": "Costs 12% food · best chance · biggest boost", "icon": "attack", "action": "give"  },
		{ "label": "Stay close and support the pack",        "sublabel": "Costs 7% food · good chance · solid boost",    "icon": "stalk",  "action": "stay"  },
		{ "label": "Offer what care you can",                "sublabel": "Costs 4% food · small boost",                  "icon": "bond",   "action": "offer" },
		{ "label": "Let the season carry itself",            "sublabel": "No cost · risk of penalty",              "icon": "flee",   "action": "let"   },
	],
	"outcomes": {
		"give": {
			"strong_success": [
				"You spend yourself on food, nest safety, and steady pack signals. The season begins with powerful promise.",
				"You keep close to the alpha, the pack, and the safest nesting paths. The future clutch gains a strong beginning.",
				"Your effort settles the pack around the season. Hunger costs you, but the nest's future brightens.",
				"You give more than comfort. You help hold food, safety, and rhythm together before the eggs ever arrive.",
				"The pack moves around your effort with sharper trust, and the coming clutch feels stronger for it.",
			],
			"success": [
				"Your full effort gives the breeding season a strong and steady start.",
				"You help keep the pack close, fed, and focused around the nesting ground.",
				"The future clutch benefits from your care and attention.",
				"You spend real energy, and the season answers with a solid beginning.",
				"The pack's rhythm holds around you, giving the eggs a better chance before they are laid.",
			],
			"mixed": [
				"Your effort helps, but the cost leaves you hungry and the pack still tense in places.",
				"You give heavily, though not every part of the pack settles cleanly.",
				"The future improves, but the season remains rough around the edges.",
				"Your care reaches the nest, but scattered pack tension keeps the start from feeling secure.",
				"You help the clutch's future, but your own strength feels thinner afterward.",
			],
			"fail": [
				"You spend too much trying to steady everything, and the pack's rhythm still refuses to settle.",
				"Your effort drains you without giving the season the strong beginning you hoped for.",
				"Food, signals, and nest safety all pull in different directions, weakening your result.",
				"You give heavily, but poor timing leaves the future clutch less supported than it should be.",
				"The season takes from you, but gives little back.",
			],
		},
		"stay": {
			"strong_success": [
				"You stay close to the pack's center, answering calls and helping the nesting ground feel secure.",
				"Your steady support keeps the pack calm enough for the season to begin well.",
				"You move with the alpha's rhythm and strengthen the pack's trust around the nesting paths.",
				"Your presence settles the group, giving the future clutch a strong foundation.",
				"You support the season with patience, food, and closeness, and the pack responds well.",
			],
			"success": [
				"Your support gives the breeding season a solid start.",
				"You stay close enough to help the pack remain focused and steady.",
				"The future clutch gains from your careful presence.",
				"The season moves forward with useful support and little trouble.",
				"You help the pack hold together around the nesting ground.",
			],
			"mixed": [
				"You support the pack, but some hunters remain restless at the edges.",
				"Your effort helps, though the season still feels uneven.",
				"The nesting paths feel safer, but the pack's rhythm is not fully settled.",
				"You stay close, but hunger and tension keep the future uncertain.",
				"The season gains some strength, but not as much as you hoped.",
			],
			"fail": [
				"Your support is not enough to settle the pack's breeding-season tension.",
				"You stay close, but the group remains restless and distracted.",
				"The nesting ground feels watched, but not truly secure.",
				"Your effort fades into the pack's unease.",
				"The season continues, but the future clutch gains little from your support.",
			],
		},
		"offer": {
			"strong_success": [
				"You offer little, but choose the right moments. A careful call, a shared path, and a small meal help more than expected.",
				"Your limited care lands perfectly, giving the season a surprising lift.",
				"You conserve your hunger while still keeping close enough to matter.",
				"The pack responds well to your small efforts, and the future clutch gains a modest but meaningful start.",
				"You give only what you can spare, but your timing makes it count.",
			],
			"success": [
				"Your small effort helps the season stay on track.",
				"You give enough care to support the future clutch.",
				"The pack remains close enough for your effort to matter.",
				"Your support is modest, but useful.",
				"The breeding season gains a little strength from your care.",
			],
			"mixed": [
				"Your care helps some, but the season remains fragile.",
				"You save your hunger, and the pack feels the difference.",
				"A few moments go well, while others slip past without support.",
				"The future gains a little, but not enough to feel secure.",
				"Your small effort keeps the chance alive, but only barely.",
			],
			"fail": [
				"You give too little, and the season weakens around you.",
				"Your limited care fails to steady the pack or nesting ground.",
				"The future clutch gains almost nothing from this choice.",
				"You save hunger, but the season pays for it.",
				"The pack keeps moving, but the breeding season feels thin.",
			],
		},
		"let": {
			"strong_success": [
				"You give little effort, but the pack's rhythm holds well enough for the season to continue.",
				"Somehow, the nesting paths remain stable without much help from you.",
				"Luck carries what effort does not, and the future clutch keeps a faint promise.",
				"The alpha's leadership and the pack's closeness carry the season farther than expected.",
				"You save your strength, and the season still finds a narrow path forward.",
			],
			"success": [
				"The season continues weakly, carried mostly by the pack around you.",
				"You give little, but the future remains possible.",
				"The pack stays close enough for the breeding season to move forward.",
				"Your lack of effort does not ruin the season, though it does not strengthen it either.",
				"The future clutch remains possible, but only barely improved.",
			],
			"mixed": [
				"Your distance leaves the pack restless, and the clutch's beginning feels weaker than it should.",
				"The season continues, but the nesting ground feels less secure.",
				"You save hunger, but the future clutch gains little from your presence.",
				"The pack's rhythm thins around the season.",
				"The breeding season remains possible, but fragile.",
			],
			"fail": [
				"You ignore the season too long, and the opportunity weakens badly.",
				"The pack's attention drifts while the future clutch loses its strongest chance.",
				"You save your strength, but the season fades around you.",
				"The nesting paths feel uncertain, and the clutch's beginning suffers.",
				"The pack continues, but this season gives the future very little.",
			],
		},
	},
}

func get_dein_female_breeding_event() -> Dictionary:
	return DEIN_FEMALE_BREEDING_EVENT
