extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Gets the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var doublej = false
var pos = str(int(self.global_transform.origin.y))

@onready var anim = get_node("AnimationPlayer")


func _physics_process(delta):
	#tracks Y position as score
	if self.global_transform.origin.y > int(pos):
		pos = str(int(self.global_transform.origin.y))
		$Score.text = "SCORE: " + pos
		
	# Adds the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Resets double jump.
	if is_on_floor():
		doublej = false
	
	
	# Handles jump input.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed("jump") and not is_on_floor() and doublej == false:
		velocity.y = JUMP_VELOCITY
		doublej = true
		
	# Handles movement animations.
	if is_on_floor():
		if velocity.x or Input.is_action_just_pressed("moveLeft") or Input.is_action_just_pressed("moveRight"):
			anim.play("Run")
		else:
			anim.play("Idle")
	elif velocity.y >= 0 or Input.is_action_just_pressed("jump"):
		anim.play("Jump")
	else:
		anim.play("Fall")
		
	# Gets the input direction and handles the movement/deceleration.
	var direction = Input.get_axis("moveLeft", "moveRight")
	
	# Flips sprite sheet based on direction.
	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	elif direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
	
	# Handles dashes.
	if Input.is_action_just_pressed("shift"):
		velocity.x = direction * SPEED * 5
	# Handles left/right movement.
	if Input.is_action_pressed("moveLeft") or Input.is_action_pressed("moveRight") and (sign(velocity.x) == direction or velocity.x == 0):
		velocity.x = move_toward(velocity.x, direction*SPEED, delta*SPEED*4)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED*delta*4)

	move_and_slide()
