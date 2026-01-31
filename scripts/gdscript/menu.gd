extends Control


var blink: Timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(blink)
	blink.wait_time = 0.5
	blink.one_shot = false
	blink.timeout.connect(_on_timeout)
	blink.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("start"):
		get_tree().change_scene_to_file('res://scenes/main.tscn')
	pass

func _on_timeout():
	$Label.visible = !$Label.visible
