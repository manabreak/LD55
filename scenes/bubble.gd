extends Control

signal text_visible


@onready
var label = $MarginContainer/Text

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func display_text(text: String, speed: float):
	visible = true
	label.text = text
	label.visible_ratio = 0.0
	
	var tween = get_tree().create_tween()
	tween.tween_property(label, "visible_ratio", 1.0, speed)
	tween.tween_callback(text_done)

func text_done():
	emit_signal("text_visible")
