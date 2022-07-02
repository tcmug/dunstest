extends Spatial

const MOUSE_SPEED := 10.0
onready var controlled: Controllable = get_parent()
var mouse_movement: Vector2

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Movement
	var movement: Vector3 = Vector3.ZERO
	if Input.is_action_pressed("forward"):
		movement.z += -1
	if Input.is_action_pressed("backward"):
		movement.z += 1
	if Input.is_action_pressed("strafe_left"):
		movement.x += -1
	if Input.is_action_pressed("strafe_right"):
		movement.x += 1
	movement = movement.normalized()
	if Input.is_action_pressed("run"):
		movement *= 100 * delta
	else:
		movement *= 20 * delta

	if Input.is_action_just_pressed("jump") and controlled.can_jump:
		movement.y += 20

	if movement.length() > 0:
		controlled.move(movement)

	# Look
	if mouse_movement.length() > 0:
		controlled.turn(mouse_movement * delta * MOUSE_SPEED)
		mouse_movement = Vector2(0, 0)

	# Quit
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit() 

func _input(event):
	if event is InputEventMouseMotion:
		mouse_movement += event.relative
	
