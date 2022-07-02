extends Node
tool

class TreeNode:
	var children
	var center: Vector3
	var extents: Vector3
	var random: RandomNumberGenerator

	func _init(init_center, init_extents, init_random):
		center = init_center
		extents = init_extents
		random = init_random
	
	func split(depth: int):
		return recursive_split(depth)
	
	func position_as_room():
		var a = center - extents
		var b = center + extents
		center = Vector3(
			random.randi_range(a.x, b.x - 2),
			random.randi_range(a.y, b.y),
			random.randi_range(a.z, b.z - 2)
		)
		extents = floor_v((b - center) * 0.5) - Vector3.ONE

#		a = Vector3(
#			random.randi_range(a.x, b.x - 2),
#			random.randi_range(a.y, b.y),
#			random.randi_range(a.z, b.z - 2)
#		)
#		b = Vector3(
#			max(2, random.randi_range(a.x, b.x)),
#			max(1, random.randi_range(a.y, b.y)),
#			max(2, random.randi_range(a.z, b.z))
#		)
#		center = (a + b) * 0.5
#		extents = (b - center)
#		extents.y = 0
#		center = Vector3(floor(center.x), floor(center.y), floor(center.z))
#		extents = Vector3(floor(extents.x), floor(extents.y), floor(extents.z))

	func floor_v(v: Vector3) -> Vector3:
		return Vector3(floor(v.x), floor(v.y), floor(v.z))
		
	func recursive_split(depth: int):
		var final = []
		var axis = random.randi_range(0, 2)
		if axis == 1:
			axis = 2
		if extents[extents.max_axis()] > 10:
			axis = extents.max_axis()
		var child_extents = extents
		child_extents[axis] = floor(child_extents[axis] / 2)
		var offset = Vector3.ZERO
		for i in range(2):
			offset[axis] = child_extents[axis] * (1 if (i % 2) == 1 else -1)
			var child = TreeNode.new(center + offset, child_extents, random)
			if depth > 0:
				final.append_array(child.split(depth - 1))
			else:
				child.position_as_room()
				final.push_back(child)
		return final
