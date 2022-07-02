extends KinematicBody
class_name Controllable

var linear_velocity: Vector3
var previous_linear_velocity: Vector3
var previous_translation: Vector3
var can_jump: bool = false
var on_wall: bool = false
var step_sfx_trigger := 0.0

var walljumps := 0

const MAX_WALL_JUMPS = 3
const MAX_SPEED = 100.0

# Gravity is multiplied because "fun factor"
const GRAVITY = Vector3(0, -9.8, 0) * 5.5

onready var puff = preload("res://Entities/Puff/Puff.tscn")

func turn(amount: Vector2):
	rotate_y(deg2rad(-amount.x))
	var new_angle = rad2deg($Head.rotation.x) - amount.y
	if new_angle < 80 and new_angle > -80:
		$Head.rotate_x(deg2rad(-amount.y))

func move(amount: Vector3):
	if can_jump:
		var trx = global_transform
		trx.origin = Vector3.ZERO
		linear_velocity += trx.xform(amount)

func get_gravity(delta) -> Vector3:
	if is_on_wall():
		return GRAVITY * delta * 0.7
	return GRAVITY * delta
	
func _physics_process(delta):
	var planar_vel = Vector2(linear_velocity.x, linear_velocity.z)
	if planar_vel.length() > MAX_SPEED:
		planar_vel = planar_vel.normalized() * MAX_SPEED
	linear_velocity.x = planar_vel.x
	linear_velocity.z = planar_vel.y
	linear_velocity += get_gravity(delta)
	emit_sounds()

	linear_velocity = move_and_slide(linear_velocity, Vector3.UP)
	if is_on_floor() or is_on_wall():
		# SLOW down when in contact
		can_jump = true
		linear_velocity = linear_velocity.linear_interpolate(Vector3(0, 0, 0), delta * 5)
	else:
		can_jump = false

func emit_sounds():
	var difference = linear_velocity - previous_linear_velocity
	if difference.y > 10:
		var p = puff.instance()
		p.translation = translation
		p.emitting = true
		if linear_velocity.y < 10:
			$SfxLand.play()
			get_node("/root/Game/Helmet").flicker(0.5)
			p.scale = Vector3(2, 2, 2)
		else:
			p.scale = Vector3(1, 1, 1)
			$SfxJump.play()
		get_parent().add_child(p)
		
		
	if is_on_floor() || is_on_wall():
		var tnow = global_transform.origin
		var distance_traveled = tnow - previous_translation
		previous_translation = tnow
		distance_traveled.y = 0
		step_sfx_trigger += distance_traveled.length()
		if step_sfx_trigger > 3:
			$SfxStep.play()
			var p = puff.instance()
			p.scale = Vector3(0.8, 0.8, 0.8)
			p.translation = translation
			p.emitting = true
			get_parent().add_child(p)
			step_sfx_trigger -= 3
	else:
		step_sfx_trigger = 0
		previous_translation = global_transform.origin
	previous_linear_velocity = linear_velocity


