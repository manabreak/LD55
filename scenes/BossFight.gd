extends Area2D

@export var magic_missile_scene: PackedScene

const PHASE_ONE_HEALTH = 1
const PHASE_TWO_HEALTH = 1

var bob_timer = 0.0

var health = PHASE_ONE_HEALTH

# 0 = first fight
# 1 = second fight
# 2 = dead
var phase = 0

# 0 = initial idle
# 1 = fly towards a move target
# 2 = idle at move target
var state = 0

@export
var move_targets: Node2D

@export
var player: CharacterBody2D

@export
var golden_frog: Sprite2D

@export
var gui: CanvasLayer

@onready
var move_target_count = move_targets.get_child_count()

@onready
var move_target_index = randi_range(0, move_target_count - 1)

@onready
var idle_timer = get_tree().create_timer(2.0)

var current_move_target: Vector2

@onready
var tween = get_tree().create_tween()

func _ready():
	$AnimatedSprite2D.play("levitate")
	# get_tree().create_timer(2.0).timeout.connect(_idle_timer_timeout)

func start_fight():
	state = 1
	handle_new_state()

func _idle_timer_timeout():
	state = 1
	handle_new_state()

func _arrived_at_move_target():
	shoot_at_player()
	if phase == 1:
		get_tree().create_timer(0.4).timeout.connect(shoot_at_player)
		get_tree().create_timer(0.8).timeout.connect(shoot_at_player)
	get_tree().create_timer(2.5).timeout.connect(_idle_timer_timeout)
		

func shoot_at_player():
	var direction = (player.position - position).normalized()
	print("Pew: Player at direction " + str(direction))
	
	var missile = magic_missile_scene.instantiate()
	if (direction.x > 0.0):
		missile.position = position + Vector2(1.0, 0.0)
	else:
		missile.position = position + Vector2(-1.0, 0.0)
	missile.set_direction(direction)
	get_parent().add_child(missile)
	
func handle_new_state():
	if phase == 2:
		return
	
	if state == 1:
		move_target_index += 1
		if move_target_index >= move_target_count:
			move_target_index = 0
		current_move_target = move_targets.position + move_targets.get_child(move_target_index).position
		var speed = 2.0
		if phase == 1:
			speed = 1.6
			
		tween = get_tree().create_tween()
		tween.tween_property(self, "position", current_move_target, speed).set_trans(Tween.TRANS_SINE)
		tween.tween_callback(_arrived_at_move_target)

func _physics_process(delta):
	if phase != 2:
		bob_timer += delta
		position = position + Vector2(sin(bob_timer * 3.0) * 0.25, sin(bob_timer * 2.0) * 0.5)

func _on_body_entered(body):
	if body.collision_layer == 1:
		body.damage(1)
	elif body.collision_layer & 0b1000 != 0:
		body.queue_free()
		$HitSound.play()
		health -= 1
		modulate = Color(1.0, 0.25, 0.25, 1.0)
		var tween = get_tree().create_tween().set_parallel(true)
		tween.tween_callback(_set_anim_take_damage)
		tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.35)
		tween.chain().tween_callback(_set_anim_levitate).set_delay(0.5)
		if health <= 0:
			if phase == 0:
				print("Starting second phase!")
				phase = 1
				health = PHASE_TWO_HEALTH
			else:
				start_boss_death()

func start_boss_death():
	print("Boss is dead!")
	tween.stop()
	MusicController.stop_music()
	phase = 2
	var timer = get_tree().create_timer(2.0)
	timer.timeout.connect(_kill_boss)
	
func _kill_boss():
	$PointLight2D.enabled = false
	$AnimatedSprite2D.visible = false
	$StoneSpawnParticles.emitting = true
	collision_layer = 0
	collision_mask = 0
	var timer = get_tree().create_timer(2.0)
	timer.timeout.connect(_show_golden_frog)
	MusicController.play_victory_music()

func _show_golden_frog():
	golden_frog.visible = true
	golden_frog.get_node("StoneSpawnParticles").emitting = true
	golden_frog.get_node("GoldenFrogLight").enabled = true
	gui.show_victory_text()

func _set_anim_take_damage():
	$AnimatedSprite2D.play("hit")

func _set_anim_levitate():
	$AnimatedSprite2D.play("levitate")
