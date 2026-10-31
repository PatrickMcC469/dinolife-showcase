extends Node

# App IDs are configured in the iOS plugin plist and Android manifest.
const INTERSTITIAL_ANDROID := "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX"
const INTERSTITIAL_IOS := "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX"
const REWARDED_ANDROID := "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX"
const REWARDED_IOS := "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX"
const TEST_INTERSTITIAL_ANDROID := "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX"
const TEST_INTERSTITIAL_IOS := "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX"
const TEST_REWARDED_ANDROID := "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX"
const TEST_REWARDED_IOS := "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX"
const AD_REQUEST := {"extras": {}, "mediation_extras": {}, "google_request_agent": "Godot-DinoLife"}

# Release builds force this off; debug builds always request test ads.
var use_test_ads := false
var _admob_plugin: Object = null
var _interstitial_plugin: Object = null
var _rewarded_plugin: Object = null
var _interstitial_uid := -1
var _rewarded_uid := -1
var _is_interstitial_loaded := false
var _is_rewarded_loaded := false
var _showing_interstitial := false
var _showing_rewarded := false
var _reward_callback := Callable()
var _reward_finished := Callable()
var _reward_was_earned := false

signal interstitial_closed
signal rewarded_earned
signal rewarded_closed


func _ready() -> void:
	use_test_ads = OS.is_debug_build()
	if OS.get_name() not in ["iOS", "Android"]:
		return
	for singleton in ["PoingGodotAdMob", "PoingGodotAdMobInterstitialAd", "PoingGodotAdMobRewardedAd"]:
		if not Engine.has_singleton(singleton):
			push_error("AdMob native singleton missing: %s" % singleton)
			return
	_admob_plugin = Engine.get_singleton("PoingGodotAdMob")
	_interstitial_plugin = Engine.get_singleton("PoingGodotAdMobInterstitialAd")
	_rewarded_plugin = Engine.get_singleton("PoingGodotAdMobRewardedAd")
	_connect_plugin(_admob_plugin, "on_initialization_complete", _on_initialized)
	_connect_plugin(_interstitial_plugin, "on_interstitial_ad_loaded", _on_interstitial_loaded)
	_connect_plugin(_interstitial_plugin, "on_interstitial_ad_failed_to_load", _on_interstitial_failed_to_load)
	_connect_plugin(_interstitial_plugin, "on_interstitial_ad_dismissed_full_screen_content", _on_interstitial_closed)
	_connect_plugin(_interstitial_plugin, "on_interstitial_ad_failed_to_show_full_screen_content", _on_interstitial_failed_to_show)
	_connect_plugin(_rewarded_plugin, "on_rewarded_ad_loaded", _on_rewarded_loaded)
	_connect_plugin(_rewarded_plugin, "on_rewarded_ad_failed_to_load", _on_rewarded_failed_to_load)
	_connect_plugin(_rewarded_plugin, "on_rewarded_ad_dismissed_full_screen_content", _on_rewarded_closed)
	_connect_plugin(_rewarded_plugin, "on_rewarded_ad_failed_to_show_full_screen_content", _on_rewarded_failed_to_show)
	_connect_plugin(_rewarded_plugin, "on_rewarded_ad_user_earned_reward", _on_rewarded_earned_reward)
	_admob_plugin.initialize()


func _connect_plugin(plugin: Object, signal_name: String, callback: Callable) -> void:
	# Native plugin signals must be connected directly, without has_signal().
	var error := plugin.connect(signal_name, callback, CONNECT_DEFERRED)
	if error != OK:
		push_error("AdMob could not connect %s: %s" % [signal_name, error_string(error)])


func _on_initialized(_status: Dictionary) -> void:
	load_interstitial()
	load_rewarded()


func load_interstitial() -> void:
	if not _interstitial_plugin or _showing_interstitial:
		return
	_is_interstitial_loaded = false
	if _interstitial_uid >= 0:
		_interstitial_plugin.destroy(_interstitial_uid)
	_interstitial_uid = _interstitial_plugin.create()
	_interstitial_plugin.load(_get_interstitial_id(), AD_REQUEST, PackedStringArray(), _interstitial_uid)


func _on_interstitial_loaded(uid: int) -> void:
	if uid == _interstitial_uid:
		_is_interstitial_loaded = true


func _on_interstitial_closed(uid: int) -> void:
	if uid != _interstitial_uid or not _showing_interstitial:
		return
	_showing_interstitial = false
	interstitial_closed.emit()
	load_interstitial()


func _on_interstitial_failed_to_load(uid: int, error: Dictionary) -> void:
	if uid == _interstitial_uid:
		_is_interstitial_loaded = false
		push_warning("AdMob interstitial load failed: %s" % error)


func _on_interstitial_failed_to_show(uid: int, error: Dictionary) -> void:
	if uid == _interstitial_uid:
		push_warning("AdMob interstitial show failed: %s" % error)
		# Unblock screens waiting for interstitial_closed even when presentation fails.
		_on_interstitial_closed(uid)


func show_interstitial() -> bool:
	if StoreManager.is_ad_free() or _showing_interstitial or _showing_rewarded:
		return false
	if not _interstitial_plugin or not _is_interstitial_loaded:
		return false
	_is_interstitial_loaded = false
	_showing_interstitial = true
	_interstitial_plugin.show(_interstitial_uid)
	return true


func _get_interstitial_id() -> String:
	if OS.is_debug_build():
		return TEST_INTERSTITIAL_ANDROID if OS.get_name() == "Android" else TEST_INTERSTITIAL_IOS
	return INTERSTITIAL_ANDROID if OS.get_name() == "Android" else INTERSTITIAL_IOS


func load_rewarded() -> void:
	if not _rewarded_plugin or _showing_rewarded:
		return
	_is_rewarded_loaded = false
	if _rewarded_uid >= 0:
		_rewarded_plugin.destroy(_rewarded_uid)
	_rewarded_uid = _rewarded_plugin.create()
	_rewarded_plugin.load(_get_rewarded_id(), AD_REQUEST, PackedStringArray(), _rewarded_uid)


func _on_rewarded_loaded(uid: int) -> void:
	if uid == _rewarded_uid:
		_is_rewarded_loaded = true


func _on_rewarded_earned_reward(uid: int, _reward: Dictionary) -> void:
	if uid != _rewarded_uid or not _showing_rewarded or not _reward_callback.is_valid():
		return
	var callback := _reward_callback
	_reward_callback = Callable()
	_reward_was_earned = true
	callback.call()
	rewarded_earned.emit()


func _on_rewarded_closed(uid: int, status: String = "incomplete") -> void:
	if uid != _rewarded_uid or not _showing_rewarded:
		return
	_showing_rewarded = false
	_reward_callback = Callable()
	var finished := _reward_finished
	var outcome := "earned" if _reward_was_earned else status
	_reward_finished = Callable()
	_reward_was_earned = false
	rewarded_closed.emit()
	load_rewarded()
	if finished.is_valid(): finished.call(outcome)


func _on_rewarded_failed_to_load(uid: int, error: Dictionary) -> void:
	if uid == _rewarded_uid:
		_is_rewarded_loaded = false
		push_warning("AdMob rewarded load failed: %s" % error)


func _on_rewarded_failed_to_show(uid: int, error: Dictionary) -> void:
	if uid == _rewarded_uid:
		push_warning("AdMob rewarded show failed: %s" % error)
		_on_rewarded_closed(uid, "failed")


func show_rewarded(callback: Callable, finished: Callable = Callable()) -> bool:
	if not is_rewarded_ready() or not callback.is_valid():
		return false
	_reward_callback = callback
	_reward_finished = finished
	_reward_was_earned = false
	_is_rewarded_loaded = false
	_showing_rewarded = true
	_rewarded_plugin.show(_rewarded_uid)
	return true


func is_rewarded_ready() -> bool:
	return SettingsManager.reward_videos_enabled and _rewarded_plugin != null and _is_rewarded_loaded and not _showing_rewarded and not _showing_interstitial


func _get_rewarded_id() -> String:
	if OS.is_debug_build():
		return TEST_REWARDED_ANDROID if OS.get_name() == "Android" else TEST_REWARDED_IOS
	return REWARDED_ANDROID if OS.get_name() == "Android" else REWARDED_IOS
