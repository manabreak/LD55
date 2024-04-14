extends Area2D

@export
var move_time = 4.0

@export
var move_distance = 64.0

@onready
var path = $Path2D

var initial_position: Vector2
var forward = true
var timer = 0.0

var damaging = false
var damage_timer = 0.0

var player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_position = position
	$AnimatedSprite2D.play("default")
	
	var target_pos = $Path2D.curve.get_point_position(1)
	target_pos.x = move_distance
	$Path2D.curve.set_point_position(1, target_pos)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if forward:
		timer += delta
		if (timer > move_time):
			timer = move_time
			forward = false
	else:
		timer -= delta
		if (timer < 0.0):
			timer = 0.0
			forward = true
	
	var pos = path.curve.sample(0, timer / move_time)
	position = initial_position + pos
	
	damage_timer -= delta
	if damaging:
		if damage_timer <= 0.0:
			player.damage(1)
			damage_timer = 1.0


func _on_body_entered(body):
	if body.collision_layer == 1:
		player = body
		damaging = true

func _on_body_exited(body):
	if body.collision_layer == 1:
		player = null
		damaging = false
