extends Area2D

@export
var player: CharacterBody2D

@export
var target_level: String

var arrow_initial_y = 0.0
var arrow_bob_timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.modulate.a = 0.0
	arrow_initial_y = $Sprite2D.position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	arrow_bob_timer += delta
	$Sprite2D.position.y = arrow_initial_y + sin(arrow_bob_timer * 3.0) * 4.0


func _on_body_entered(body):
	if body == player:
		var tween = get_tree().create_tween()
		tween.tween_property($Sprite2D, "modulate", Color(1.0, 1.0, 1., 1.0), 1.0).set_trans(Tween.TRANS_SINE)
		GlobalController.set_target_level(target_level)

func _on_body_exited(body):
	if body == player:
		var tween = get_tree().create_tween()
		tween.tween_property($Sprite2D, "modulate", Color(1.0, 1.0, 1., 0.0), 1.0).set_trans(Tween.TRANS_SINE)
		GlobalController.set_target_level(null)
