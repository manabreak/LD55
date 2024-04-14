extends CanvasLayer

var lost_heart_color = Color(0.45, 0.45, 0.45, 1.0)

@export
var game_controller: Node2D

@onready
var hearts = $InGameUI/MarginContainer/Hearts

var health = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_restart_button_pressed():
	game_controller.restart()


func _on_quit_button_pressed():
	get_tree().quit()

func set_health(amount: int):
	var old_health = health
	health = amount
	
	var tween = get_tree().create_tween()
	
	if health == 0:
		# Player died
		for heart in hearts.get_children():
			tween.tween_property(heart, "modulate", lost_heart_color, 0.25).set_trans(Tween.TRANS_BACK)
	elif health > 0 and health < old_health:
		# Player got damaged
			for i in range(health, 3):
				var heart = hearts.get_child(i)
				tween.tween_property(heart, "modulate", lost_heart_color, 0.25).set_trans(Tween.TRANS_BACK)
	elif health > old_health:
		# Player got healed
		for i in range(0, health):
			var heart = hearts.get_child(i)
			tween.tween_property(heart, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.25).set_trans(Tween.TRANS_BACK)
	
	pass
