extends Control

const WORLD = preload("res://scripts/systems/world_conditions.gd")
const PROFILES = {
	"wet": {"wash": Color(0.30, 0.48, 0.60, 0.035), "rain": -29.0, "wind": -42.0, "pitch": 1.0},
	"dry": {"wash": Color(0.85, 0.56, 0.20, 0.055), "rain": -80.0, "wind": -30.0, "pitch": 1.0},
	"mating": {"wash": Color(0.65, 0.72, 0.30, 0.035), "rain": -80.0, "wind": -37.0, "pitch": 1.05},
	"cold": {"wash": Color(0.32, 0.52, 0.78, 0.065), "rain": -80.0, "wind": -25.0, "pitch": 0.85},
	"flood": {"wash": Color(0.30, 0.43, 0.62, 0.065), "rain": -22.0, "wind": -34.0, "pitch": 0.95},
	"drought": {"wash": Color(0.9, 0.51, 0.17, 0.08), "rain": -80.0, "wind": -26.0, "pitch": 0.95},
}

@onready var rain: AudioStreamPlayer = $Rain
@onready var wind: AudioStreamPlayer = $Wind
var profile: String = ""
var _clock: float = 0.0
var _specks: Array[Vector3] = []
var _fade: Tween
var _paused: bool = false


func _ready() -> void:
	# Visual randomness is isolated from survival rolls and never modifies run state.
	var rng := RandomNumberGenerator.new()
	rng.seed = 8642
	for index in 32:
		_specks.append(Vector3(rng.randf(), rng.randf(), rng.randf_range(0.6, 1.4)))
	for player in [rain, wind]:
		var stream := player.stream as AudioStreamWAV
		stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
		stream.loop_end = int(stream.get_length() * stream.mix_rate)
	TurnManager.turn_started.connect(refresh)
	TurnManager.stat_changed.connect(refresh)
	SettingsManager.atmosphere_changed.connect(_on_setting)
	refresh()


func _on_setting(_enabled: bool) -> void:
	refresh()


func refresh() -> void:
	var condition := WORLD.kind()
	var next: String = condition if condition in ["flood", "drought"] else ["wet", "dry", "mating", "cold"][GameState.current_season]
	visible = SettingsManager.atmosphere_enabled and not _paused
	set_process(visible)
	if not visible:
		if _fade != null: _fade.kill()
		rain.stop()
		wind.stop()
		return
	if profile == next and rain.playing and wind.playing:
		return
	profile = next
	if _fade != null: _fade.kill()
	var mix: Dictionary = PROFILES[profile]
	for player in [rain, wind]:
		if not player.playing:
			player.volume_db = -80.0
			player.play()
	_fade = create_tween().set_parallel(true)
	_fade.tween_property(rain, "volume_db", mix["rain"], 0.8)
	_fade.tween_property(wind, "volume_db", mix["wind"], 0.8)
	_fade.tween_property(wind, "pitch_scale", mix["pitch"], 0.8)
	queue_redraw()


func _process(delta: float) -> void:
	_clock = fmod(_clock + delta, 1000.0)
	queue_redraw()


func _draw() -> void:
	if profile not in PROFILES or not visible:
		return
	draw_rect(Rect2(Vector2.ZERO, size), PROFILES[profile]["wash"])
	var rainy := profile in ["wet", "flood"]
	var count := 30 if profile == "flood" else (18 if rainy else 9)
	for index in count:
		var speck: Vector3 = _specks[index]
		if rainy:
			var x := fposmod(speck.x * size.x - _clock * 13.0 * speck.z, size.x + 16.0) - 8.0
			var y := fposmod(speck.y * size.y + _clock * 105.0 * speck.z, size.y + 24.0) - 12.0
			draw_line(Vector2(x, y), Vector2(x - 3.0, y + 10.0), Color(0.8, 0.9, 1.0, 0.17), 1.0, true)
		else:
			var x := fposmod(speck.x * size.x + _clock * 12.0 * speck.z, size.x + 20.0) - 10.0
			var y := speck.y * size.y + sin(_clock * 0.5 + speck.x * 10.0) * 4.0
			if profile == "cold":
				draw_line(Vector2(x, y), Vector2(x + 16.0, y - 1.0), Color(0.84, 0.91, 1.0, 0.1), 1.0, true)
			else:
				draw_circle(Vector2(x, y), 1.3 * speck.z, Color(0.97, 0.84, 0.48, 0.12))


func _notification(what: int) -> void:
	if not is_node_ready():
		return
	if what == NOTIFICATION_APPLICATION_PAUSED:
		_paused = true
		refresh()
	elif what == NOTIFICATION_APPLICATION_RESUMED:
		_paused = false
		refresh()
