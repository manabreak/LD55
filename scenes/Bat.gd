extends CharacterBody2D

const SPEED = 80.0
const SPEED_RETREAT = 50.0

@export
var player: CharacterBody2D

var awake = false
var chasing = false
var nesting_target = Vector2()
var attacking = false
var attack_timer = 0.0

var health = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.play("idle")

var flutter_timer = 0.0

func damage(amount: int):
	if health == 0:
		return
	
	health -= amount
	if health < 0:
		health = 0
	
	if health == 0:
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not awake:
		return
	
	if attacking:
		if attack_timer <= 0.0:
			player.damage(1)
			attack_timer = 1.0
	
	attack_timer -= delta
	flutter_timer += delta
	
	if chasing:
		if (player.position - position).length_squared() > 160 * 160:
			print("Player got away!")
			chasing = false
			var space_state = get_world_2d().direct_space_state
			var query = PhysicsRayQueryParameters2D.create(position, Vector2(0.0, -640.0))
			var result = space_state.intersect_ray(query)
			if result:
				print("Should nest at " + str(result.position))
				nesting_target = result.position
			else:
				print("No nesting target found; keep chasing player")
				chasing = true
		
		var player_pos = player.position + Vector2(0.0, sin(flutter_timer * 8.0) * 16.0)
		var dir_to_player = (player_pos - position).normalized()
		if attack_timer <= 0.0:
			velocity = dir_to_player * (SPEED + sin(flutter_timer * 10.0))
		else:
			velocity = dir_to_player * -(SPEED_RETREAT + sin(flutter_timer * 14.0))
		move_and_slide()
	
	else:
		var distance_to_nest = (position - nesting_target).length()
		print("Distance to nest: " + str(distance_to_nest))
		if distance_to_nest < 12.0:
			print("Ready to nest!")
			position.y = roundf(position.y / 16.0) * 16.0
			if distance_to_nest < 8.0:
				position.y += 16.0
			else:
				position.y -= 16.0
				
			awake = false
			$Sprite2D.play("idle")
		else:
			var nesting_pos = nesting_target + Vector2(0.0, sin(flutter_timer * 8.0) * 16.0)
			var dir_to_nest = (nesting_pos - position).normalized()
			velocity = dir_to_nest * (SPEED_RETREAT + sin(flutter_timer * 10.0))
			move_and_slide()


func _on_wakeup_zone_body_entered(body):
	if body == player:
		print("Bat woke up!")
		awake = true
		chasing = true
		$Sprite2D.play("fly")


func _on_attack_zone_body_entered(body):
	if body == player:
		print("Bat attacked player")
		attacking = true
		attack_timer = 0.0


func _on_attack_zone_body_exited(body):
	if body == player:
		print("Bat stopped attacking player")
		attacking = false
