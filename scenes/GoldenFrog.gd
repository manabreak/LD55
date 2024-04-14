extends Sprite2D

var bob_timer = 0.0
var orig_pos_y = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	orig_pos_y = position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bob_timer += delta
	position.y = orig_pos_y + sin(bob_timer) * 4.0
