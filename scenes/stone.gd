extends RigidBody2D

const LIFE = 5.0
var freeze_time = 0.5
var timer = 0.0

var player = null
var disappearing = false

var sound_played = false

func _ready():
	$StoneSpawnParticles.emitting = true
	$StoneSpawnParticles.one_shot = true
	$SummonSound.play()

func _physics_process(delta):
	if freeze and timer >= freeze_time:
		freeze = false
	timer += delta
	if timer >= LIFE and not disappearing:
		disappearing = true
		collision_layer = 0
		collision_mask = 0
		$Sprite2D.visible = false
		$StoneSpawnParticles.emitting = true
		$StoneSpawnParticles.one_shot = true
		$StoneSpawnParticles.finished.connect(destroy_stone)

func destroy_stone():
	queue_free()

func _on_damage_area_body_entered(body):
	if not sound_played:
		sound_played = true
		$ThumpSound.play()

func _on_damage_area_area_entered(area):
	if not sound_played:
		sound_played = true
		$ThumpSound.play()
