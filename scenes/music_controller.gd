extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play_summoning_music():
	$SummoningMusic.play()

func play_main_music():
	$MainMusic.play()

func play_boss_music():
	$BossMusic.play()

func play_victory_music():
	$VictoryMusic.play()

func stop_music():
	$SummoningMusic.stop()
	$MainMusic.stop()
	$BossMusic.stop()
	$VictoryMusic.stop()
