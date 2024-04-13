extends CanvasLayer

@export
var game_controller: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_restart_button_pressed():
	game_controller.restart_level()


func _on_quit_button_pressed():
	get_tree().quit()
