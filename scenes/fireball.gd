extends RigidBody2D

var player: CharacterBody2D

var life_timer = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = get_tree().create_timer(1.0)
	timer.timeout.connect(_stop_emitting)


func _stop_emitting():
	$GPUParticles2D.emitting = false


func _process(delta):
	life_timer -= delta
	if life_timer < 0.0:
		queue_free() 


func _on_damage_sensor_body_entered(body):
	print("Hit something: " + body.name)
	if body.collision_layer & 0b10000 != 0:
		print("Hit an enemy!")
		body.damage(1)
