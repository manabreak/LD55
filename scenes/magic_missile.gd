extends Area2D

const SPEED = 240.0

var direction: Vector2

func set_direction(dir: Vector2):
	direction = dir

# Called when the node enters the scene tree for the first time.
func _ready():
	$SpawnSound.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += direction * delta * SPEED


func _on_area_entered(area):
	print("Missile: area entered")


func _on_body_entered(body):
	print("Missile: body entered")
	if body is TileMap == true:
		collision_layer = 0
		collision_mask = 0
		$GPUParticles2D.emitting = false
		var timer = get_tree().create_timer(1.0)
		timer.timeout.connect(queue_free)
	elif body is CharacterBody2D and body.collision_layer & 1 != 0:
		body.damage(1)
