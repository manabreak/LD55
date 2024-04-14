extends Control

var texts = [
	"Sleep deprivation presents",
	"In cooperation with\ncaffeine over-consumption",
	"A game by manabreak"
]

var text_index = 0
var bob_timer = 0.0

@onready
var label = $CenterContainer/Label

@onready
var logo = $CenterContainer/LogoContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	label.modulate.a = 0.0
	logo.modulate.a = 0.0
	start_text()
	

func start_text():
	label.text = texts[text_index]
	var tween = get_tree().create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 2.0).set_trans(Tween.TRANS_SINE)
	tween.tween_property(label, "modulate:a", 0.0, 2.0).set_trans(Tween.TRANS_SINE).set_delay(2.0)
	tween.tween_callback(next_text)

func next_text():
	text_index += 1
	if text_index < len(texts):
		start_text()
	else:
		print("Done with texts")
		start_logo_animation()

func start_logo_animation():
	var tween = get_tree().create_tween()
	tween.tween_property(logo, "modulate:a", 1.0, 4.5).set_trans(Tween.TRANS_SINE).set_delay(0.5)
	tween.tween_property(logo, "modulate:a", 0.0, 5.0).set_trans(Tween.TRANS_SINE).set_delay(7.0)
	tween.tween_callback(logo_anim_done)

func logo_anim_done():
	get_tree().change_scene_to_file("res://scenes/root.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bob_timer += delta
	logo.add_theme_constant_override("separation", sin(bob_timer) * 10 - 5)
