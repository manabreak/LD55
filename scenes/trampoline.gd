extends RigidBody2D

var player: CharacterBody2D

var life_timer = 3.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$TrampolineSpawnParticles.emitting = true
	$TrampolineSpawnParticles.one_shot = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	life_timer -= delta
	if life_timer <= 0.0:
		destroy()
	pass


func _on_area_2d_body_entered(body):
	if body == player:
		print("Player stepped on trampoline!")
		player.launch_with_trampoline()
		# TODO Animate trampoline before freeing it
		destroy()

func destroy():
	queue_free()
