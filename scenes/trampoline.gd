extends RigidBody2D

var player: CharacterBody2D

var life_timer = 3.0
var bounce = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$TrampolineSpawnParticles.emitting = true
	$TrampolineSpawnParticles.one_shot = true
	$SummonSound.play()

func _on_area_2d_body_entered(body):
	if body == player:
		print("Player stepped on trampoline!")
		$BoingSound.play()
		player.launch_with_trampoline()
		destroy()

func _physics_process(delta):
	if bounce:
		apply_impulse(Vector2(randf_range(-50.0, 50.0), -200.0))
		bounce = false

func destroy():
	$CollisionShape2D.disabled = true
	collision_layer = 0
	collision_mask = 0
	$Area2D.queue_free()
	bounce = true
	player.active_trampoline = null
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
