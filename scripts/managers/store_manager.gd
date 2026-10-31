extends Node

const PRODUCT_AD_FREE   = "dinolife_adfree"
const PRODUCT_PRED_PACK = "dinolife_pred_pack"
const PRODUCT_HERB_PACK = "dinolife_herb_pack"

const SAVE_PATH = "user://store.json"

var _ad_free:   bool = false
var _pred_pack: bool = false
var _herb_pack: bool = false

var _store_kit = null

signal purchase_completed(product_id: String)
signal purchase_failed(product_id: String)
signal restore_completed


func _ready() -> void:
	_load()
	if ClassDB.class_exists("GodotStoreKit2"):
		_store_kit = ClassDB.instantiate("GodotStoreKit2")
		_store_kit.transaction_state_changed.connect(_on_transaction_state_changed)
	else:
		push_warning("GodotStoreKit2 not available — purchases disabled.")


# ── Public API ─────────────────────────────────────────────────────────────────

func is_ad_free() -> bool:
	return _ad_free

func has_pred_pack() -> bool:
	return _pred_pack

func has_herb_pack() -> bool:
	return _herb_pack


func purchase(product_id: String) -> void:
	if not _store_kit:
		push_warning("StoreKit not available — cannot purchase %s." % product_id)
		return
	_store_kit.purchase_product(product_id, 1)


func restore_purchases() -> void:
	if not _store_kit:
		return
	await _store_kit.sync()
	restore_completed.emit()


# ── StoreKit callbacks ─────────────────────────────────────────────────────────

func _on_transaction_state_changed(transaction: Dictionary) -> void:
	var error: String = transaction.get("error", "")
	var product_id: String = transaction.get("product_id", "")
	if not error.is_empty():
		purchase_failed.emit(product_id)
		return
	# TransactionState enum: FAILED=0 REFUNDED=1 PENDING=2 DEFERRED=3
	#                        PURCHASED=4 RESTORED=5 EXPIRED=6 CANCELED=7
	var state: int = transaction.get("transaction_state", 0)
	if state == 4 or state == 5:  # PURCHASED or RESTORED
		_apply_purchase(product_id)
		_save()
		purchase_completed.emit(product_id)
	elif state == 0 or state == 7:  # FAILED or CANCELED
		purchase_failed.emit(product_id)


# ── Internal ───────────────────────────────────────────────────────────────────

func _apply_purchase(product_id: String) -> void:
	match product_id:
		PRODUCT_AD_FREE:
			_ad_free = true
		PRODUCT_PRED_PACK:
			_pred_pack = true
			for sid in UnlockManager.V1_PRED_CHAIN:
				UnlockManager.force_unlock(sid as String)
		PRODUCT_HERB_PACK:
			_herb_pack = true
			for sid in UnlockManager.V1_HERB_CHAIN:
				UnlockManager.force_unlock(sid as String)


func _save() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify({
			"ad_free":   _ad_free,
			"pred_pack": _pred_pack,
			"herb_pack": _herb_pack,
		}))
		file.close()


func _load() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	if not data is Dictionary:
		return
	_ad_free   = data.get("ad_free",   false) as bool
	_pred_pack = data.get("pred_pack", false) as bool
	_herb_pack = data.get("herb_pack", false) as bool
	if _pred_pack:
		for sid in UnlockManager.V1_PRED_CHAIN:
			UnlockManager.force_unlock(sid as String)
	if _herb_pack:
		for sid in UnlockManager.V1_HERB_CHAIN:
			UnlockManager.force_unlock(sid as String)
