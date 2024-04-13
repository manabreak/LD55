extends Control

signal text_visible

var text: Label

# Called when the node enters the scene tree for the first time.
func _ready():
	text = get_node("MarginContainer/Text")
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func display_text(text: String, speed: float):
	visible = true
	self.text.text = text
	self.text.visible_ratio = 0.0
	
	var tween = get_tree().create_tween()
	tween.tween_property(self.text, "visible_ratio", 1.0, speed)
	tween.tween_callback(text_done)

func text_done():
	emit_signal("text_visible")
