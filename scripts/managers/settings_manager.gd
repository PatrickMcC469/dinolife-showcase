extends Node

signal atmosphere_changed(enabled: bool)
signal interface_animations_changed(enabled: bool)
signal tension_audio_changed(enabled: bool)

const SAVE_PATH = "user://settings.json"

var master_volume: float = 1.0
var reward_videos_enabled: bool = true
var atmosphere_enabled: bool = true
var interface_animations_enabled: bool = true
var vibration_enabled: bool = false
var tension_audio_enabled: bool = true


func _ready() -> void:
	load_settings()
	_apply_volume()


func set_master_volume(vol: float) -> void:
	master_volume = clampf(vol, 0.0, 1.0)
	_apply_volume()
	save()


func set_reward_videos_enabled(enabled: bool) -> void:
	reward_videos_enabled = enabled
	save()


func set_atmosphere_enabled(enabled: bool) -> void:
	atmosphere_enabled = enabled
	atmosphere_changed.emit(enabled)
	save()


func _apply_volume() -> void:
	var db = -80.0 if master_volume <= 0.0 else linear_to_db(master_volume)
	AudioServer.set_bus_volume_db(0, db)


func set_interface_animations_enabled(enabled: bool) -> void:
	interface_animations_enabled = enabled
	interface_animations_changed.emit(enabled)
	save()


func set_vibration_enabled(enabled: bool) -> void:
	vibration_enabled = enabled
	save()


func set_tension_audio_enabled(enabled: bool) -> void:
	tension_audio_enabled = enabled
	tension_audio_changed.emit(enabled)
	save()


func save() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify({
			"master_volume":          master_volume,
			"reward_videos_enabled":  reward_videos_enabled,
			"atmosphere_enabled": atmosphere_enabled,
			"interface_animations_enabled": interface_animations_enabled,
			"vibration_enabled": vibration_enabled,
			"tension_audio_enabled": tension_audio_enabled,
		}))
		file.close()


func load_settings() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	if data is Dictionary:
		master_volume         = data.get("master_volume",         1.0)  as float
		reward_videos_enabled = data.get("reward_videos_enabled", true) as bool
		atmosphere_enabled = data.get("atmosphere_enabled", true) if data.get("atmosphere_enabled", true) is bool else true
		interface_animations_enabled = data.get("interface_animations_enabled", true) if data.get("interface_animations_enabled", true) is bool else true
		vibration_enabled = data.get("vibration_enabled", false) if data.get("vibration_enabled", false) is bool else false
		tension_audio_enabled = data.get("tension_audio_enabled", true) if data.get("tension_audio_enabled", true) is bool else true
