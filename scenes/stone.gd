extends RigidBody2D

const LIFE = 5.0
var freeze_time = 0.5
var timer = 0.0

var player = null

func _ready():
	$StoneSpawnParticles.emitting = true
	$StoneSpawnParticles.one_shot = true

func _physics_process(delta):
	if freeze and timer >= freeze_time:
		freeze = false
	timer += delta
	if timer >= LIFE:
		queue_free()


func _on_damage_area_body_entered(body):
	if body == player:
		print("Damaged player!")
