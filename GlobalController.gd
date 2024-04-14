extends Node

signal spell_changed(name: String)

var health = 3
var spells = [
	false, # Trampoline
	false, # Stone
	false  # Gravity
]

var seq_id = 0
var seq_step = 0
var active_spell = 0

var target_level = null

var fadeout: ColorRect

func can_cast(spell: int) -> bool:
	return spells[spell] and active_spell == spell

func reset_health():
	health = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_target_level(level):
	target_level = level

func set_active_spell(spell):
	active_spell = spell
	if spell == 0:
		emit_signal("spell_changed", "Summon Trampoline")
	elif spell == 1:
		emit_signal("spell_changed", "Summon Stone")
	elif spell == 2:
		emit_signal("spell_changed", "Change Gravity")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("enter_door"):
		if target_level != null:
			# get_tree().change_scene_to_file("res://scenes/" + target_level + ".tscn")
			var tween = get_tree().create_tween()
			tween.tween_property(fadeout, "modulate:a", 1.0, 2.0).set_trans(Tween.TRANS_SINE)
			tween.tween_callback(_do_change_level)
	if Input.is_action_just_pressed("choose_slot_0"):
		if spells[0]:
			active_spell = 0
			emit_signal("spell_changed", "Summon Trampoline")
	if Input.is_action_just_pressed("choose_slot_1"):
		if spells[1]:
			active_spell = 1
			emit_signal("spell_changed", "Summon Stone")
	if Input.is_action_just_pressed("choose_slot_2"):
		if spells[2]:
			active_spell = 2
			emit_signal("spell_changed", "Change Gravity")

func _do_change_level():
	get_tree().change_scene_to_file("res://scenes/" + target_level + ".tscn")
