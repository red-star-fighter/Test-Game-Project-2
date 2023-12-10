extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Gets the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var doublej = false

@onready var anim = get_node("AnimationPlayer")

func _physics_process(delta):
	# Adds the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Resets double jump.
	if is_on_floor():
		doublej = false

	# Handles jump input and player jump animation.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")
	elif Input.is_action_just_pressed("ui_accept") and not is_on_floor() and doublej == false:
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")
		doublej = true

	# Gets the input direction and handles the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	# Flips sprite sheet based on direction.
	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	elif direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
	
	# Plays animations for player movement.
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			anim.play("Run")
		if velocity.y > 0:
			anim.play("Fall")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			anim.play("Idle")
		if velocity.y > 0:
			anim.play("Fall")

	move_and_slide()
