extends CharacterBody2D

@export var gravity: float = 4000
@export var player_speed: float = 100
@export var player_acc: float = 0.75
@export var player_fric: float = 0.3

@export var pointer: Sprite2D = null
@export var pointer_speed: float = 0.05

@export var jump_low: float = 0.0
@export var jump_medium: float = 0.0
@export var jump_high: float = 0.0

@export var anim_sprite: AnimatedSprite2D = null


enum States {WALKING, JUMPING, IN_AIR}

var state: States = States.WALKING

var pointer_angle = 13 * PI/12
var pointer_rev: bool = false
var locked_jump: bool = false
var jump_power: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pointer.visible = true
	pass # Replace with function body.


# Animation in process because I'm lazy
func _process(delta: float) -> void:
	if self.state == States.WALKING:
		if Input.is_action_pressed("right"):
			self.anim_sprite.flip_h = false
			self.anim_sprite.play("walk")
		elif Input.is_action_pressed("left"):
			self.anim_sprite.flip_h = true
			self.anim_sprite.play("walk")
		else:
			self.anim_sprite.play("default")

	if self.state == States.JUMPING:
		if self.pointer_angle > 3 * PI / 2:
			self.anim_sprite.flip_h = false
		else:
			self.anim_sprite.flip_h = true
		pass
	return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:

	# State machine
	match state:
		States.WALKING:
			# Change to jumping action if walking
			if Input.is_action_pressed("jump"):
				state = States.JUMPING
			handle_walking()
		States.JUMPING:
			# Change to walking if  wv wl
			if Input.is_action_pressed("right") or Input.is_action_pressed("left"):
				state = States.WALKING
				locked_jump = false
			handle_jumping()
		States.IN_AIR:
			handle_air(delta)

	move_and_slide()

	# Move the pointer if the jump angle isn't locked in
	if not locked_jump:
		move_pointer()


	# Changing states if in the air
	if not self.is_on_floor():
		state = States.IN_AIR
	elif state != States.JUMPING:
		state = States.WALKING
	
	if self.state != States.IN_AIR:
		velocity.x = lerp(velocity.x, 0.0, player_fric)
	return

func handle_walking() -> void:
	# Right and left movement
	if not locked_jump:
		var dir = Input.get_axis("left", "right")
		if dir != 0 and self.is_on_floor():
			velocity.x = lerp(velocity.x, dir * player_speed, player_acc)
		# Switching to jumping when hitting the jump button
	return

func handle_jumping() -> void:
	
	# Charge up jump
	if Input.is_action_pressed("jump"):
		locked_jump = true
		jump_power += 0.02
		# Change color of pointer for how fast (temp)
		var tier = snappedi(jump_power, 1)
		if tier == 0:
			self.pointer.modulate = Color(0, 0, 1)
			self.anim_sprite.play("charge")
			self.anim_sprite.stop()
			self.anim_sprite.frame = 0
		elif tier == 1:
			self.pointer.modulate = Color(0, 1, 0)
			self.anim_sprite.play("charge")
			self.anim_sprite.stop()
			self.anim_sprite.frame = 1
		elif tier >= 2:
			self.pointer.modulate = Color(1, 0, 0)
			self.anim_sprite.play("charge")
			self.anim_sprite.stop()
			self.anim_sprite.frame = 2


	# Actually jumping
	if Input.is_action_just_released("jump") and locked_jump:
		var tier = snappedi(jump_power, 1)
		if tier == 0:
			self.velocity = Vector2.from_angle(pointer_angle) * jump_low
		elif tier == 1:
			self.velocity = Vector2.from_angle(pointer_angle) * jump_medium
		elif tier >= 2:
			self.velocity = Vector2.from_angle(pointer_angle) * jump_high
		self.locked_jump = false
		jump_power = 0.0
		self.state = States.WALKING
		self.pointer.modulate = Color(1, 1, 1)
	return

# Gravity
func handle_air(delta: float) -> void:
	self.velocity.y += gravity * delta
	return

# Move pointer between the two max angles of jumping
func move_pointer():
	if pointer_angle > 23 * PI / 12:
		pointer_rev = true
	elif pointer_angle < 13 * PI / 12:
		pointer_rev = false

	if pointer_rev:
		pointer_angle -= pointer_speed
	else:
		pointer_angle += pointer_speed

	self.pointer.position = Vector2(cos(pointer_angle) * 55, sin(pointer_angle) * 55)
	self.pointer.rotation = pointer_angle + PI/2
	return
