extends Area2D

var timer = 0.0
var start_y = 0.0

# Spell types:
# 0 = fireball (already acquired at start)
# 1 = summon a stone

@export
var spell_type = 1

@export
var player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	start_y = position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	position.y = start_y + sin(timer) * 4.0


func _on_body_entered(body):
	if body == player:
		print("Book collected by the player! Granting spell " + str(spell_type))
		player.collect_spell(spell_type)
		queue_free()
