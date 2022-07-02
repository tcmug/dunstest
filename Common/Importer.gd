tool
extends EditorScenePostImport

var hardpoints = {}
var save_hardpoints := false

const material_override = preload("res://Matty.material")

var model_name_prefixes = [
	"X",
	"A", "AB", "ABC", "ABCD", "AC",
	"AE", "ABE", "ABCE", "ABCDE", "ACE",
	"AF", "ABF", "ABCF", "ABCDF", "ACF",
	"AEF", "ABEF", "ABCEF", "ABCDEF", "ACEF",
	"E", "F", "EF",
	"Decor-",
]

func is_model_name(name: String):
	for prefix in model_name_prefixes:
		if name.find(prefix) == 0:
			return true
			
	return false

func add_hardpoint(parent, type, pos):
	if !parent in hardpoints:
		hardpoints[parent] = { type: [] }
	elif !type in hardpoints[parent]:
		hardpoints[parent][type] = []
	if Engine.is_editor_hint():
		if pos.origin.max_axis() > 5:
			print("Possibly faulty hardpoint ", parent, " type ", type, pos.origin)
		else:
			print("Added hardpoint ", parent, " type ", type, pos.origin)
	hardpoints[parent][type].append(pos)
	
func post_import(scene):
	for child in scene.get_children():
		var name = child.name
		if child is MeshInstance and material_override:
			for i in child.mesh.get_surface_count():
				child.mesh.surface_set_material(i, material_override)
			print("Replaced materials for ", child.name)

		if "_" in name:
			# Name consists of: "BlockName_Type(numbers)"
			var parts = child.name.split("_")
			var parent_name = parts[0]
			var type = parts[1].rstrip("0123456789")
			var parent = scene.get_node(parent_name)
			if not parent:
				print("Parent ", parent_name, " not found")
			else:
				# Solve actual position within the block:
				var trx: Transform = child.transform
				trx.origin = child.translation - parent.translation
				add_hardpoint(parent_name, type, trx)
				scene.remove_child(child)
		elif is_model_name(name):
			print("Added model ", name)
		else:
			scene.remove_child(child)

	if save_hardpoints:
		var file = File.new()
		var filename = "res://Generated/%s-hardpoints.tres" % (scene.name)
		file.open(filename, File.WRITE)
		file.store_var(hardpoints)
		file.close()
		print("Saved ", filename)
	return scene
