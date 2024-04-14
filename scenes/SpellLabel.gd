extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalController.spell_changed.connect(spell_changed)

func spell_changed(name: String):
	text = name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
