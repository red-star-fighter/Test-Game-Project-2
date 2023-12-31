extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Gets the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var doublej = false
var canDash = true
var storedDash = false
var pos = str(int(self.global_transform.origin.y))

@onready var anim = get_node("AnimationPlayer")

func _physics_process(delta):
	
	var direction = Input.get_axis("moveLeft", "moveRight")
	
	#tracks Y position as score.
	if self.global_transform.origin.y > int(pos):
		pos = str(int(self.global_transform.origin.y))
		$Camera2D/Score.text = "SCORE: " + pos
	
	# Adds the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Resets double jump and Dash.
	if is_on_floor():
		doublej = false
		if storedDash == true:
			canDash = true
			storedDash = false
		if $DashTimer.is_stopped():
			$DashTimer.start()
	
	# Dash cooldown visual.
	if canDash == true:
		$Camera2D/DashCooldown.text = "Dash Ready"
	else:
		$Camera2D/DashCooldown.text = "Waiting  " + str(snapped($DashTimer.time_left,.01))
	
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
	
	# Flips sprite sheet based on direction.
	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	elif direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
	
	# Plays animations for player movement.
	if Input.is_action_just_pressed("shift") and canDash == true:
		velocity.x = direction * SPEED * 3.5
		canDash = false
		$DashTimer.start()
	
	# Handles left/right movement.
	if Input.is_action_pressed("moveLeft") or Input.is_action_pressed("moveRight") and (sign(velocity.x) == direction or velocity.x == 0):
		velocity.x = move_toward(velocity.x, direction*SPEED, delta*SPEED*4)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED*delta*4)
	
	move_and_slide()

func _on_dash_timer_timeout():
	if is_on_floor():
		canDash = true
	else:
		storedDash = true
