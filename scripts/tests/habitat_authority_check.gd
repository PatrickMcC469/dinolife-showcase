extends RefCounted

const GROUP = preload("res://scripts/systems/group_habitat.gd")
const HOME = preload("res://scripts/systems/living_world.gd")
const C = preload("res://scripts/systems/companions.gd")
const PAIRS = preload("res://scripts/systems/pack_relationships.gd")
var driver = preload("res://scripts/tests/large_scope_check.gd").new()


func run(harness: Node) -> void:
	driver._start("iguanodon", 4)
	GameState.is_alpha = false
	GameState.pack_alpha_name = "Brook"
	C._find("Brook")["trait"] = "cautious"
	var before := [GameState.hunger, GameState.action_uses.duplicate(), GameState.living_state.duplicate(true)]
	for action in ["home_river", "home_prepare", "home_rest", "home_scout"]:
		ActionResolver.resolve("home", action)
	harness._check(not GROUP.can_manage() and before == [GameState.hunger, GameState.action_uses, GameState.living_state], "A non-alpha must not settle, move, improve, rest or scout the group's home, even through direct stale actions.")
	harness._check(HOME.home_menu()["choices"].all(func(option): return option["action"] == "back") and GROUP.control_text().contains("Brook"), "Followers must see the actual alpha and no home-management choices.")
	var trust: Array = C.active_cast().map(func(member): return member["trust"])
	GROUP.tick()
	var site: String = GameState.living_state["site"]
	var event := HOME.next_event()
	harness._check(site == "ridge" and event.get("resolve_key") == "living" and event.get("flavor", "").contains("Brook"), "The actual cautious alpha must settle a home and supply a saved movement notice.")
	harness._check(trust == C.active_cast().map(func(member): return member["trust"]) and GameState.hunger == before[0] and GameState.action_uses == before[1], "NPC home decisions must not consume the player's food/actions or alter player trust for someone else's decision.")
	harness._check(PAIRS.pair_for("Fern", "Brook")["score"] > 0, "Companions must react to the alpha's home choice through their real peer bond.")
	harness._check(preload("res://scripts/ui/living_journal.gd").recorded_memories().any(func(memory): return memory["key"].begins_with("alpha_home_") and memory["category"] == "Home"), "Real alpha home decisions must appear under Home in the living journal.")
	GameState.companion_event = {"kind": "intro", "name": "Fern"}
	harness._check(GROUP.pending_event().is_empty(), "An alpha notice must not replace an unanswered companion decision on resume.")
	GameState.companion_event = {}
	GameState.living_state["site"] = "river"
	harness._check(GROUP.pending_event().is_empty(), "A notice about a superseded home must not claim that it is the current home.")
	GameState.living_state["site"] = site
	var state := GameState.living_state.duplicate(true)
	GROUP.tick()
	GROUP.control_text()
	harness._check(GameState.living_state == state, "A repeated seasonal hook or status read must never repeat an alpha decision.")
	GameState.save_run()
	harness._check(GameState.load_run() and HOME.pending_event() == event, "An unanswered alpha movement notice must survive an actual JSON save and resume.")
	HOME.resolve("alpha_home_ack")
	HOME.resolve("alpha_home_ack")
	harness._check(GROUP.pending_event().is_empty() and GameState.hunger == before[0], "Acknowledging a movement notice twice must not cause a second move, charge or reward.")
	GameState.seasons_elapsed += 1
	GameState.living_state.merge({"site": "river", "shelter": 0, "wear": 4}, true)
	GameState.world_state = {"kind": "flood", "until": GameState.seasons_elapsed + 4}
	GROUP.tick()
	harness._check(GameState.living_state["site"] == "river", "NPC leaders must respect their three-season home-action pacing.")
	GameState.seasons_elapsed += 2
	GROUP.tick()
	harness._check(GameState.living_state["site"] != "river" and GROUP.pending_event()["flavor"].contains("old shelter stays behind"), "An eligible alpha must lead followers out of a flooded river home and explain the real shelter loss.")
	HOME.resolve("alpha_home_ack")
	GameState.is_alpha = true
	GameState.action_uses = {}
	var food := GameState.hunger
	ActionResolver.resolve("home", "home_river")
	harness._check(GROUP.can_manage() and GameState.living_state["site"] == "river" and is_equal_approx(food - GameState.hunger, 0.08), "A player alpha must retain the real eight-percent move cost and authority.")
	harness._check(GameState.living_state["group_home"]["last_action"] == GameState.seasons_elapsed, "Player alpha decisions must also update the group's real last home decision.")
	GameState.action_uses = {}
	GameState.is_alpha = false
	var home := GameState.living_state.duplicate(true)
	food = GameState.hunger
	ActionResolver.resolve("home", "home_grove")
	harness._check(GameState.living_state == home and GameState.hunger == food, "Losing leadership must invalidate a previously available home choice without charging food.")
	driver._start("iguanodon", 4)
	GameState.living_state = {"site": "grove", "shelter": 2, "wear": 3}
	GROUP.tick()
	harness._check(GameState.living_state["site"] == "grove" and GameState.living_state["shelter"] == 2 and GROUP.pending_event().is_empty(), "Older saves must adopt their existing group home without replacing it or losing investments immediately.")
	driver._start("iguanodon", 4)
	GameState.pack_alpha_name = "Brook"
	C._find("Brook")["trait"] = "protective"
	GROUP.tick()
	HOME.resolve("alpha_home_ack")
	GameState.seasons_elapsed += 3
	GameState.current_season = 3
	GROUP.tick()
	harness._check(GameState.living_state["shelter"] == 1 and GROUP.pending_event()["title"] == "A safer resting place", "A settled NPC alpha must prepare real shelter when cold reaches the group.")
	HOME.resolve("alpha_home_ack")
	GameState.seasons_elapsed += 4
	GROUP.tick()
	harness._check(GameState.living_state["shelter"] == 2 and preload("res://scripts/systems/perks.gd").progress("sheltercraft") == 0, "NPC-built shelter must protect the player without granting an unearned personal crafting perk.")
	GameState.save_run()
	harness._check(GameState.load_run() and GameState.living_state["shelter_author"] == "npc" and preload("res://scripts/systems/perks.gd").progress("sheltercraft") == 0, "Shelter authorship and personal perk eligibility must survive JSON resume.")
	GameState.is_alpha = true
	GameState.living_state["shelter"] = 1
	ActionResolver.resolve("home", "home_prepare")
	harness._check(preload("res://scripts/systems/perks.gd").progress("sheltercraft") == 2, "A player who completes shelter preparation must qualify for the crafting milestone.")
	GameState.living_state = HOME.restore({"site": "grove", "shelter": 2, "shelter_author": "unknown"})
	harness._check(preload("res://scripts/systems/perks.gd").progress("sheltercraft") == 0, "Invalid shelter authorship must not manufacture personal crafting evidence.")
	var restored := GROUP.restore({"group_id": INF, "last_tick": "bad", "notice": 12, "pending": true, "site": "unknown"})
	harness._check(restored["group_id"] == -1 and restored["last_tick"] == -1 and not restored["pending"], "Malformed group-home metadata must not invent a leader, date or movement notice.")
	for sid in ["trex", "allosaurus", "ankylosaurus"]:
		driver._start(sid, 0)
		ActionResolver.resolve("home", "home_grove")
		harness._check(GROUP.can_manage() and GameState.living_state["site"] == "grove" and not GameState.living_state.has("group_home"), "Solitary dinosaurs must keep independent home decisions without NPC alpha behavior.")
	GameState.start_run("iguanodon")
	GameState.life_stage = 1
	GameState.seasons_elapsed = 4
	GROUP.tick()
	harness._check(not C.active_cast().is_empty() and GameState.living_state["group_home"]["group_id"] == GameState.companion_group_id and not GROUP.pending_event().is_empty(), "The first real group-home tick must initialize a roster before recording its group identity and named notice.")
	print("Habitat authority checked: player/alpha rules, real NPC homes and shelter, notices, save/resume, peer reactions, pacing, old homes, stale authority and solitary species.")
