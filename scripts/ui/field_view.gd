extends Control

signal closed
const ART = preload("res://scripts/ui/adventure_theme.gd")
const UI = preload("res://scripts/ui/perks_panel.gd")
var panel: PanelContainer
var title: Label
var subtitle: Label
var scroll: ScrollContainer
var content: VBoxContainer
var back: Button


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	z_index = 150
	preload("res://scripts/ui/front_end_style.gd").apply_theme(self)
	var backdrop := ColorRect.new()
	backdrop.color = Color(0.035, 0.065, 0.045)
	add_child(backdrop)
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	panel = PanelContainer.new()
	panel.mouse_filter = Control.MOUSE_FILTER_PASS
	panel.add_theme_stylebox_override("panel", ART.frame())
	add_child(panel)
	panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	panel.offset_left = 12
	panel.offset_right = -12
	panel.offset_top = 36
	panel.offset_bottom = -32
	if OS.get_name() == "iOS":
		var safe := DisplayServer.get_display_safe_area()
		var window := DisplayServer.window_get_size()
		var scale := get_viewport_rect().size.y / maxf(1, window.y)
		panel.offset_top = maxf(36, safe.position.y * scale + 8)
		panel.offset_bottom = -maxf(32, (window.y - safe.end.y) * scale + 8)
	var column := VBoxContainer.new()
	column.mouse_filter = Control.MOUSE_FILTER_PASS
	column.add_theme_constant_override("separation", 10)
	panel.add_child(column)
	title = UI.label("", 23, ART.CREAM)
	column.add_child(title)
	subtitle = UI.label("", 13)
	column.add_child(subtitle)
	scroll = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.follow_focus = true
	column.add_child(scroll)
	content = VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.mouse_filter = Control.MOUSE_FILTER_PASS
	content.add_theme_constant_override("separation", 10)
	scroll.add_child(content)
	back = Button.new()
	back.text = "Back to your life"
	back.custom_minimum_size.y = 48
	ART.button(back, true)
	back.pressed.connect(_close)
	column.add_child(back)
	hide()


func clear_content() -> void:
	for child in content.get_children():
		content.remove_child(child)
		child.queue_free()


func _close() -> void:
	hide()
	closed.emit()


func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		_close()
		get_viewport().set_input_as_handled()
