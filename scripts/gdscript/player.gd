extends CharacterBody2D

@export var gravity: float = 4000
@export var player_speed: float = 100
@export var player_acc: float = 0.25
@export var player_fric: float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Inputs
	var dir = Input.get_axis("left", "right")

	if dir != 0:
		velocity.x = lerp(velocity.x, dir * player_speed, player_acc)
	else:
		velocity.x = lerp(velocity.x, 0.0, player_fric)

	move_and_slide()

	# Gravity
	if not self.is_on_floor():
		self.velocity.y += gravity * delta

	return
