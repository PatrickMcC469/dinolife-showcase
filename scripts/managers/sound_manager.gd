extends Node

var _sfx:   AudioStreamPlayer
var _music: AudioStreamPlayer
var _loop:  AudioStreamPlayer

var _sounds: Dictionary = {}
var _health_was_low: bool = false
var _combat_active := false
var _paused := false
var _last_haptic := -1000


func _ready() -> void:
	_sfx   = AudioStreamPlayer.new()
	_music = AudioStreamPlayer.new()
	_loop  = AudioStreamPlayer.new()
	add_child(_sfx)
	add_child(_music)
	add_child(_loop)
	_preload()
	_loop.volume_db = -18.0
	SettingsManager.tension_audio_changed.connect(_on_tension_setting)
	play_music()


func _preload() -> void:
	_load("button_tap",     "res://assets/audio/button_tap.ogg")
	_load("tab_switch",     "res://assets/audio/tab_switch.ogg")
	_load("combat_hit",     "res://assets/audio/combat_hit.ogg")
	_load("combat_win",     "res://assets/audio/combat_win.ogg")
	_load("event_trigger",  "res://assets/audio/event_trigger.ogg")
	_load("age_up",         "res://assets/audio/age_up.ogg")
	_load("low_health",     "res://assets/audio/low_health.ogg")
	_load("game_over",      "res://assets/audio/game_over.ogg")
	_load("unlock",         "res://assets/audio/unlock.ogg")
	_load("combat_loop",    "res://assets/audio/combat_loop.ogg")
	_load("trex_encounter", "res://assets/audio/trex_encounter.ogg")
	_load("large_herb_roar","res://assets/audio/large_herb_roar.ogg")
	_load("raptor_roar",    "res://assets/audio/raptor_roar.ogg")
	_load("small_raptor",   "res://assets/audio/small_raptor.ogg")


func _load(key: String, path: String) -> void:
	if ResourceLoader.exists(path):
		_sounds[key] = ResourceLoader.load(path)


func play(sound: String) -> void:
	if not _sounds.has(sound):
		return
	_sfx.stream = _sounds[sound] as AudioStream
	_sfx.play()


func play_win_roar() -> void:
	var sp: Dictionary = SpeciesDB.get_species(GameState.species_id)
	var diet: String = sp.get("diet", "carnivore") as String
	if diet == "herbivore":
		play("large_herb_roar")
	else:
		play("raptor_roar")


func start_combat_loop() -> void:
	_combat_active = true
	if not SettingsManager.tension_audio_enabled or _paused or not _sounds.has("combat_loop") or _loop.playing:
		return
	_loop.stream = _sounds["combat_loop"] as AudioStream
	_loop.play()


func stop_combat_loop() -> void:
	_combat_active = false
	_loop.stop()


func _on_tension_setting(enabled: bool) -> void:
	if enabled and _combat_active: start_combat_loop()
	else: _loop.stop()


func pulse_haptic() -> bool:
	if not SettingsManager.vibration_enabled or _paused or OS.get_name() != "iOS" or Time.get_ticks_msec() < _last_haptic + 1000: return false
	_last_haptic = Time.get_ticks_msec()
	Input.vibrate_handheld(50)
	return true


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_PAUSED:
		_paused = true
		if is_instance_valid(_loop): _loop.stop()
	elif what == NOTIFICATION_APPLICATION_RESUMED:
		_paused = false
		if _combat_active: start_combat_loop()


func check_low_health() -> void:
	var is_low: bool = GameState.health < 0.25
	if is_low and not _health_was_low:
		play("low_health")
	_health_was_low = is_low


func reset_health_flag() -> void:
	_health_was_low = false


func play_music() -> void:
	var path: String = "res://assets/audio/ambient_jungle.ogg"
	if not ResourceLoader.exists(path):
		return
	var stream := ResourceLoader.load(path) as AudioStream
	if _music.playing and _music.stream == stream:
		return
	_music.stream = stream
	if _music.stream is AudioStreamOggVorbis:
		(_music.stream as AudioStreamOggVorbis).loop = true
	_music.volume_db = -8.0
	_music.play()
