extends AnimatedSprite2D

# 0 = intro sequence
var seq_id = 0
var seq_step = 0

@export
var player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	play("idle")
	# do_intro_sequence()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func do_intro_sequence():
	seq_id = 0
	seq_step = 0
	player.controls_enabled = false
	$Bubble.text_visible.connect(_on_text_visible)
	$Bubble.display_text("Full moon, summer solstice, swamp full of delicious flies...", 4.0)
	
func _on_text_visible():
	var timer = get_tree().create_timer(2.0)
	timer.timeout.connect(_do_next_seq_step)

func _do_next_seq_step():
	seq_step += 1
	# seq_id 0 == intro sequence
	if seq_id == 0:
		if seq_step == 1:
			$Bubble.display_text("Everything is ready for the summoning ritual.", 3.0)
		elif seq_step == 2:
			$Bubble.display_text("The ritual...", 1.5)
		elif seq_step == 3:
			$Bubble.display_text("OF RIBBIT!", 1.0)
			player.say_ribbit()
		elif seq_step == 4:
			$Bubble.visible = false
			play("summon")
			# TODO Play summoning music, do effects etc.
			
			var timer = get_tree().create_timer(2.0)
			timer.timeout.connect(_do_next_seq_step)
		elif seq_step == 5:
			# Summoning done!
			$Bubble.display_text("Finally, the Ribbit artefact is mine!", 2.5)
		elif seq_step == 6:
			$Bubble.display_text("Now, I can finally rule the world!", 2.3)
		elif seq_step == 7:
			$Bubble.display_text("Mwahahaa! So long, you fool! Thanks for helping me out!", 3.5)
		elif seq_step == 8:
			$Bubble.visible = false
			# Boss frog away!
			var particles = $StoneSpawnParticles
			particles.reparent(get_parent())
			particles.emitting = true
			visible = false
			var timer = get_tree().create_timer(2.0)
			timer.timeout.connect(_do_next_seq_step)
		elif seq_step == 9:
			player.controls_enabled = true
			queue_free()
