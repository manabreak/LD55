extends Area2D

@export
var player: CharacterBody2D

var camera = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if camera != null:
		camera.position = lerp(camera.position, Vector2(0, 0), delta * 3.0)
		camera.zoom = lerp(camera.zoom, Vector2(2.0, 2.0), delta * 2.0)


func _on_body_entered(body):
	if camera == null and body == player:
		camera = player.get_node("Camera2D")
		camera.reparent(self)
		camera.position_smoothing_enabled = false
		
