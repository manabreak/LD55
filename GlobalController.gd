extends Node

var health = 3
var spells = [
	true, # Trampoline
	true, # Stone
	true  # Gravity
]

var seq_id = 0
var seq_step = 0
var active_spell = 0

var target_level = null

func can_cast(spell: int) -> bool:
	return spells[spell] and active_spell == spell

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_target_level(level):
	target_level = level

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("enter_door"):
		if target_level != null:
			get_tree().change_scene_to_file("res://scenes/" + target_level + ".tscn")
	if Input.is_action_just_pressed("choose_slot_0"):
		if spells[0]:
			active_spell = 0
	if Input.is_action_just_pressed("choose_slot_1"):
		if spells[1]:
			active_spell = 1
	if Input.is_action_just_pressed("choose_slot_2"):
		if spells[2]:
			active_spell = 2
