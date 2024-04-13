extends CharacterBody2D

@export var stone_scene: PackedScene

const STONE_CAST_TIME = 1.0
const SPEED_MAX = 140.0
const JUMP_VELOCITY_INITIAL = -200.0
const JUMP_APPLY_TIME = 1.0
const JUMP_APPLY_FORCE = -12.0

var jump_timer = 0.0

var stone_spawn_timer = 0.0
var facing_right = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$MainSprite.play("idle")

func _physics_process(delta):
	if Input.is_action_just_pressed("action") and stone_spawn_timer <= 0.0:
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
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY_INITIAL
		jump_timer = JUMP_APPLY_TIME
	elif Input.is_action_pressed("jump") and jump_timer > 0:
		velocity.y += JUMP_APPLY_FORCE * jump_timer
		jump_timer -= delta
	else:
		jump_timer = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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
	
	if is_on_floor():
		if abs(velocity.x) > 1.0:
			$MainSprite.play("walk")
		else:
			$MainSprite.play("idle")
	else:
		$MainSprite.play("jump")
