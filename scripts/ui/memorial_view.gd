extends Control

@onready var card = $Margin/Content/Scroll/Memorial
@onready var close_button: Button = $Margin/Content/CloseButton


func _ready() -> void:
	close_button.pressed.connect(queue_free)
	if OS.get_name() == "iOS":
		var safe := DisplayServer.get_display_safe_area()
		var height := float(DisplayServer.window_get_size().y)
		if height > 0.0:
			var scale := get_viewport_rect().size.y / height
			$Margin.add_theme_constant_override("margin_top", maxi(48, int(safe.position.y * scale) + 8))
			$Margin.add_theme_constant_override("margin_bottom", maxi(40, int((height - safe.end.y) * scale) + 8))


func show_record(record: Dictionary) -> void:
	card.show_record(record)
