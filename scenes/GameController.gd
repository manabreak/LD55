extends Node2D

const FADE_OUT_TIME = 1.5

@export
var current_level: String

@onready
var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	$GUI.get_node("EndGameUI").visible = false
	var tween = get_tree().create_tween()
	tween.tween_property($GUI/ColorRect, "modulate:a", 0.0, 2.0)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func restart():
	print("Restarting...")
	get_tree().change_scene_to_file("res://scenes/root.tscn")
	# TODO nice fades etc.

func fade_level_out():
	$GUI.get_node("EndGameUI").modulate.a = 0.0
	$GUI.get_node("EndGameUI").visible = true
	
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property($BackgroundTilemap, "modulate:a", 0.0, FADE_OUT_TIME)
	tween.tween_property($Items, "modulate:a", 0.0, FADE_OUT_TIME)
	tween.tween_property($TileMap, "modulate:a", 0.0, FADE_OUT_TIME)
	tween.tween_property($GUI.get_node("InGameUI"), "modulate:a", 0.0, FADE_OUT_TIME)
	
	tween.chain().tween_property($GUI.get_node("EndGameUI"), "modulate:a", 1.0, FADE_OUT_TIME)
