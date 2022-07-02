extends Camera

export var follow: NodePath
var target: Vector3
export var delay: float = 25.0

var previous_translation = Vector3()
var previous_rotation = Vector3()
var velocity_delta = Vector3()
var rotation_delta = Vector3()

var blur = Vector3()

func _ready():
	set_as_toplevel(true)
	var trx = get_node(follow).get_global_transform()
	target = trx.basis.z
	look_at_from_position(trx.origin, trx.origin - target, Vector3.UP)
	update_movement()

func update_movement():
	var trx = get_global_transform()
	var current_translation = trx.origin
	trx.origin = Vector3.ZERO
	velocity_delta = trx.xform_inv(current_translation - previous_translation)
	previous_translation = current_translation
	
	var current_rotation = trx.basis.z
	rotation_delta = trx.xform_inv(current_rotation - previous_rotation)
	previous_rotation = current_rotation

func a(s, e, v):
	return sign(v) * smoothstep(-s, -e, v) + smoothstep(s, e, v)

func _process(delta):

	var trx = get_node(follow).get_global_transform()
	target = target.linear_interpolate(trx.basis.z, delta * delay)
	look_at_from_position(trx.origin, trx.origin - target, Vector3.UP)

	update_movement()
	var postprocess = get_node("/root/Game/Postprocess")
	
	# Target blur
	var target = Vector3(0, 0, 0)
	
	# Camera rotation
	var s = 0.04
	var e = 0.2
	
	target.x = a(s, e, rotation_delta.x)
	target.y = a(s, e, rotation_delta.y)

	target *= 0.002

	blur = target
	#blur = target.linear_interpolate(target, delta)
	postprocess.material.set_shader_param("blur", blur)
	


