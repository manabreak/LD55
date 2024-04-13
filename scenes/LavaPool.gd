extends Area2D

@export
var player: CharacterBody2D



func _on_body_entered(body):
	if body == player:
		print("Player stepped into lava!")
		player.do_die()
