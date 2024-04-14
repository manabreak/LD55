extends RigidBody2D

var player: CharacterBody2D

var flip_timer = 0.0
var life_timer = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = get_tree().create_timer(1.0)
	timer.timeout.connect(_stop_emitting)


func _stop_emitting():
	$GPUParticles2D.emitting = false


func _process(delta):
	flip_timer += delta
	if flip_timer >= 0.1:
		$Sprite2D.flip_v = not $Sprite2D.flip_v
		flip_timer = 0.0
	
	life_timer -= delta
	if life_timer < 0.0:
		queue_free() 


func _on_damage_sensor_body_entered(body):
	print("Hit something: " + body.name)
	if body.collision_layer & 0b10000 != 0:
		print("Hit an enemy!")
		body.damage(1)


func _on_damage_sensor_area_entered(area):
	queue_free()
