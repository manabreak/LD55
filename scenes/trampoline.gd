extends RigidBody2D

var player: CharacterBody2D

var life_timer = 3.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$TrampolineSpawnParticles.emitting = true
	$TrampolineSpawnParticles.one_shot = true

func _on_area_2d_body_entered(body):
	if body == player:
		print("Player stepped on trampoline!")
		player.launch_with_trampoline()
		# TODO Animate trampoline before freeing it
		destroy()

func destroy():
	$CollisionShape2D.disabled = true
	collision_layer = 0
	collision_mask = 0
	player.active_trampoline = null
	apply_impulse(Vector2(randf_range(-50.0, 50.0), -200.0))
	var tween = get_tree().create_tween()
	var rotation_amount = randf_range(-60.0, 60.0)
	var rotation_time = abs(rotation_amount / 5.0)
	tween.set_parallel(true)
	tween.tween_property($Sprite2D, "rotation", rotation_amount, rotation_time)
	tween.tween_property($Sprite2D, "modulate", Color(1.0, 1.0, 1.0, 0.0), 1.0)
	
	tween.chain().tween_callback(_destroy_final)

func _destroy_final():
	print("Finally destroying trampoline")
	queue_free()
