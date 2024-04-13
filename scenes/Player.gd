extends CharacterBody2D

@export var stone_scene: PackedScene
@export var trampoline_scene: PackedScene

const STONE_CAST_TIME = 1.0
const TRAMPOLINE_CAST_TIME = 3.0
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
var spell_0_collected = true

# spell 1 = trampoline
var spell_1_collected = true

# spell 2 = summon a stone
var spell_2_collected = false

var active_spell = 0

func collect_spell(spell: int):
	if spell == 0:
		spell_0_collected = true
	elif spell == 1:
		spell_1_collected = true
	elif spell == 2:
		spell_2_collected = true

func _ready():
	$MainSprite.play("idle")
	$Bubble.get_node("ColorRect").color = Color("474418")
	$Bubble.text_visible.connect(_on_text_visible)

func _process(delta):
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
	
	# Spellcasting
	if controls_enabled and Input.is_action_just_pressed("action"):
		print("Pressed action; active spell = " + str(active_spell))
		if active_spell == 0 and spell_0_collected:
			# TODO Fireball casting spell
			pass
		elif active_spell == 1 and spell_1_collected:
			print("Trying to spawn a trampoline...")
			# Trampoline
			if trampoline_spawn_timer <= 0:
				print("Can spawn a trampoline")
				var trampoline = trampoline_scene.instantiate()
				trampoline.player = self
				if facing_right:
					trampoline.position = position + $TrampolineSpawnPoint.position
				else:
					trampoline.position = position - $TrampolineSpawnPoint.position
				get_parent().get_node("Items").add_child(trampoline)
				trampoline_spawn_timer = TRAMPOLINE_CAST_TIME
				
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
	
	if controls_enabled:
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
