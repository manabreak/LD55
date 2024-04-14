extends Area2D

var damaging = false
var damage_timer = 0.0
var player: CharacterBody2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if damage_timer > 0.0:
		damage_timer -= delta
	if damaging:
		if damage_timer <= 0.0:
			player.damage(1)
			damage_timer = 2.0
		


func _on_body_entered(body):
	if body.collision_layer == 1:
		print("Player hit spikes!")
		player = body
		damaging = true

func _on_body_exited(body):
	if body.collision_layer == 1:
		print("Player exited spikes")
		player = null
		damaging = false
