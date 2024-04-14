extends CharacterBody2D

@export var fireball_scene: PackedScene
@export var stone_scene: PackedScene
@export var trampoline_scene: PackedScene
@export var game_controller: Node2D
@export var gui: CanvasLayer

const STONE_CAST_TIME = 1.0
const TRAMPOLINE_CAST_TIME = 1.0
const SPEED_MAX = 140.0
const JUMP_VELOCITY_INITIAL = -200.0
const JUMP_APPLY_TIME = 1.0
const JUMP_APPLY_FORCE = -12.0
const JUMP_VELOCITY_TRAMPOLINE = -500.0

var jump_timer = 0.0

var stone_spawn_timer = 0.0
var trampoline_spawn_timer = 0.0
var facing_right = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var controls_enabled = true

var seq_id = 0
var seq_step = 0

# spell 0 = fireball
var spell_0_collected = false

# spell 1 = trampoline
var spell_1_collected = false

# spell 2 = summon a stone
var spell_2_collected = false

var active_spell = 0
var active_trampoline = null

var health = 3

var anim_override_timer = 0.0

func damage(amount: int):
	if health == 0:
		return
	
	print("Player damaged for " + str(amount))
	health -= amount
	if health < 0:
		health = 0
	
	gui.set_health(health)
	
	if health == 0:
		print("Player died!")
		do_die()
	else:
		controls_enabled = false
		$MainSprite.play("take_hit")
		velocity.x = 0.0
		var tween = get_tree().create_tween()
		tween.tween_property(self, "controls_enabled", true, 0.5)

func heal(amount: int):
	health += amount
	if health > 3:
		health = 3
	
	gui.set_health(health)
	
	print("Player healed for " + str(amount) + ", health now: " + str(health))

func kill():
	health = 0
	do_die()

func do_die():
	print("Handling dying logic")
	controls_enabled = false
	$MainSprite.play("take_hit")
	velocity.x = 0.0
	var timer = get_tree().create_timer(2.5)
	timer.timeout.connect(set_dead_sprite)
	game_controller.fade_level_out()

func set_dead_sprite():
	$MainSprite.play("dead")

func collect_spell(spell: int):
	if spell == 0:
		print("Fireball collected")
		spell_0_collected = true
	elif spell == 1:
		print("Trampoline collected")
		spell_1_collected = true
	elif spell == 2:
		print("Stone collected")
		spell_2_collected = true

func _ready():
	$MainSprite.play("idle")
	$Bubble.get_node("ColorRect").color = Color("474418")
	$Bubble.text_visible.connect(_on_text_visible)

func _process(delta):
	if Input.is_action_just_pressed("debug_damage"):
		damage(1)
	if Input.is_action_just_pressed("debug_heal"):
		heal(1)
	
	if Input.is_action_just_pressed("choose_slot_0"):
		if spell_0_collected:
			active_spell = 0
	if Input.is_action_just_pressed("choose_slot_1"):
		if spell_1_collected:
			active_spell = 1
	if Input.is_action_just_pressed("choose_slot_2"):
		if spell_2_collected:
			active_spell = 2

func _physics_process(delta):
	
	if anim_override_timer > 0.0:
		anim_override_timer -= delta
	
	# Spellcasting
	if controls_enabled and Input.is_action_just_pressed("action"):
		print("Pressed action; active spell = " + str(active_spell))
		if active_spell == 0 and spell_0_collected:
			# Fireball casting spell
			var fireball = fireball_scene.instantiate()
			fireball.player = self
			if facing_right:
				fireball.position = position + Vector2(16.0, 5.0)
				fireball.linear_velocity = Vector2(400.0, 0.0)
			else:
				fireball.position = position + Vector2(-16.0, 5.0)
				fireball.linear_velocity = Vector2(-400.0, 0.0)
			
			get_parent().get_node("Items").add_child(fireball)
			$MainSprite.play("summon")
			anim_override_timer = 0.25
		elif active_spell == 1 and spell_1_collected:
			print("Trying to spawn a trampoline...")
			# Trampoline
			if trampoline_spawn_timer <= 0:
				print("Can spawn a trampoline")
				
				if active_trampoline != null:
					active_trampoline.destroy()
				
				var trampoline = trampoline_scene.instantiate()
				trampoline.player = self
				if facing_right:
					trampoline.position = position + $TrampolineSpawnPoint.position
				else:
					trampoline.position = position - $TrampolineSpawnPoint.position
				get_parent().get_node("Items").add_child(trampoline)
				trampoline_spawn_timer = TRAMPOLINE_CAST_TIME
				active_trampoline = trampoline
				
				$MainSprite.play("summon")
			anim_override_timer = 0.25
		elif active_spell == 2 and spell_2_collected:
			if stone_spawn_timer <= 0:
				var stone = stone_scene.instantiate()
				stone.player = self
				if facing_right:
					stone.position = position + $StoneSpawnArea.position
				else:
					stone.position = position - $StoneSpawnArea.position
				get_parent().get_node("Items").add_child(stone)
				stone_spawn_timer = STONE_CAST_TIME
				
				$MainSprite.play("summon")
				anim_override_timer = 0.25
	
	if stone_spawn_timer > 0.0:
		stone_spawn_timer -= delta
	if trampoline_spawn_timer > 0.0:
		trampoline_spawn_timer -= delta
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if controls_enabled and Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY_INITIAL
		jump_timer = JUMP_APPLY_TIME
	elif controls_enabled and Input.is_action_pressed("jump") and jump_timer > 0:
		velocity.y += JUMP_APPLY_FORCE * jump_timer
		jump_timer -= delta
	else:
		jump_timer = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if controls_enabled:
		var direction = Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * SPEED_MAX
			if velocity.x > 0:
				$MainSprite.flip_h = false
				facing_right = true
			else:
				$MainSprite.flip_h = true
				facing_right = false
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED_MAX)

	move_and_slide()
	
	if controls_enabled and anim_override_timer <= 0.0:
		if is_on_floor():
			if abs(velocity.x) > 1.0:
				$MainSprite.play("walk")
			else:
				$MainSprite.play("idle")
		else:
			$MainSprite.play("jump")

func launch_with_trampoline():
	velocity.y = JUMP_VELOCITY_TRAMPOLINE
	jump_timer = 0

func say_ribbit():
	var timer = get_tree().create_timer(1.0)
	timer.timeout.connect(say_ribbit_after_delay)
	

func say_ribbit_after_delay():
	$Bubble.display_text("*Ribbit*", 0.4)

func _on_text_visible():
	var timer = get_tree().create_timer(2.0)
	timer.timeout.connect(_do_next_seq_step)

func _do_next_seq_step():
	seq_step += 1
	if seq_id == 0:
		if seq_step == 1:
			$Bubble.visible = false
			$MainSprite.play("summon")
