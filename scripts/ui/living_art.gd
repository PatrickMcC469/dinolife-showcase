extends Control

# Only independent scenery moves. The dinosaur texture is never transformed.
@export var portrait_mode: bool = false
@onready var left: TextureRect = $LeftFern
@onready var right: TextureRect = $RightFern
@onready var mist: TextureRect = $Mist
var _clock: float = 0.0
var _paused: bool = false
var _mist_origin := Vector2.ZERO


func _ready() -> void:
	SettingsManager.atmosphere_changed.connect(_on_setting)
	SettingsManager.interface_animations_changed.connect(_on_setting)
	TurnManager.turn_started.connect(_refresh)
	visibility_changed.connect(_refresh)
	resized.connect(_layout)
	_layout()
	_refresh()


func _layout() -> void:
	var edge := minf(size.x * 0.24, size.y * 0.24) if portrait_mode else minf(size.x * 0.42, 230.0)
	for plant in [left, right]:
		plant.size = Vector2(edge, edge)
		plant.pivot_offset = Vector2(edge * 0.5, edge)
		plant.modulate = Color(0.45, 0.56, 0.35, 0.65) if portrait_mode else Color(0.35, 0.48, 0.30, 0.9)
	left.position = Vector2(-edge * 0.16, size.y - edge * 0.85)
	right.position = Vector2(size.x - edge * 0.84, size.y - edge * 0.85)
	mist.size = Vector2(size.x * 1.15, size.y * (0.20 if portrait_mode else 0.14))
	_mist_origin = Vector2(-size.x * 0.08, size.y * (0.77 if portrait_mode else 0.78))
	mist.modulate.a = 0.30 if portrait_mode else 0.55
	_apply_motion()


func _on_setting(_enabled: bool) -> void:
	_refresh()


func _refresh() -> void:
	if not is_node_ready(): return
	visible = SettingsManager.atmosphere_enabled and not _paused
	set_process(is_visible_in_tree() and SettingsManager.interface_animations_enabled)
	if not SettingsManager.interface_animations_enabled:
		_clock = 0.0
	_apply_motion()
	queue_redraw()


func _process(delta: float) -> void:
	_clock = fmod(_clock + delta, 1000.0)
	_apply_motion()
	queue_redraw()


func _apply_motion() -> void:
	left.rotation = sin(_clock * 0.55) * 0.018
	right.rotation = sin(_clock * 0.47 + 0.8) * 0.015
	mist.position = _mist_origin + Vector2(sin(_clock * 0.16) * size.x * 0.025, 0)


func _draw() -> void:
	if not SettingsManager.interface_animations_enabled or (portrait_mode and (GameState.current_season != 2 or not GameState.world_state.get("kind", "").is_empty())):
		return
	# Fixed decorative positions do not consume survival randomness.
	for i in 3:
		var x := (0.10 if i == 0 else 0.89) * size.x + sin(_clock * 0.32 + i * 2.0) * 4.0
		var y := size.y * (0.57 + i * 0.10) + sin(_clock * 0.43 + i) * 5.0
		var strength := 0.10 + (sin(_clock * 0.75 + i * 2.1) + 1.0) * 0.07
		draw_circle(Vector2(x, y), 3.0, Color(0.86, 0.88, 0.46, strength * 0.20))
		draw_circle(Vector2(x, y), 1.1, Color(0.96, 0.94, 0.59, strength))


func _notification(what: int) -> void:
	if not is_node_ready(): return
	if what == NOTIFICATION_APPLICATION_PAUSED:
		_paused = true
		_refresh()
	elif what == NOTIFICATION_APPLICATION_RESUMED:
		_paused = false
		_refresh()
