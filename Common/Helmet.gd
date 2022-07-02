extends Spatial

export var follow: NodePath
export var delay: float = 25.0

var flicker := 1.0
var target: Vector3

func _ready():
	set_as_toplevel(true)
	var trx = get_node(follow).get_global_transform()
	target = trx.basis.z
	look_at_from_position(trx.origin, trx.origin - target, Vector3.UP)
	
func _process(delta):
	var trx = get_node(follow).get_global_transform()
	target = target.linear_interpolate(trx.basis.z, delta * delay)
	look_at_from_position(trx.origin, trx.origin - target, Vector3.UP)
	rotation_degrees.x = max(-45, rotation_degrees.x)
	rotation_degrees.x = min(45, rotation_degrees.x)
	$MeshInstance.material_override.set_shader_param("flicker", flicker)
	if flicker > 0:
		flicker -= delta
	else:
		flicker = 0.0
	
func flicker(amount):
	flicker = amount;
	
