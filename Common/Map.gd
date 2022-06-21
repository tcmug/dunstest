extends GridMap
tool

export var use_variations := true
export var click_to_smooth = false setget run_smooth_map

var block_logic = null
var cell_specs = {}

func run_smooth_map(a):
	smooth_map()

func get_model(models):
	if !use_variations:
		return models[0]
	if models.size() == 0:
		return null 
	return models[randi() % models.size()]

class CellSpec:
	
	var name: String
	var group: String
	var id: int

	func _init(mesh_library, item_id):
		if item_id >= 0:
			name = mesh_library.get_item_name(item_id)
		else:
			name = "EMPTY"
		group = name.split("-")[0]
		id = item_id

func _get_spec_by_id(id: int) -> CellSpec:
	if id in cell_specs:
		return cell_specs[id]
	return null

func _precalculate():
	
	print("GENE: precalculating")
	block_logic = []
	cell_specs = {}
	
	var groups = {
		"X": [],
		 
		"A": [],
		"AB": [],
		"AC": [],
		"ABC": [],
		"ABCD": [],

		"AE": [],
		"ABE": [],
		"ACE": [],
		"ABCE": [],
		"ABCDE": [],
		
		"AF": [],
		"ABF": [],
		"ACF": [],
		"ABCF": [],
		"ABCDF": [],
		
		"AEF": [],
		"ABEF": [],
		"ACEF": [],
		"ABCEF": [],
		"ABCDEF": [],
		
		"E": [],
		"F": [],
		"EF": [],
	}
	
	# Group model ids by their name under models
	for id in mesh_library.get_item_list():
		var spec = CellSpec.new(mesh_library, id)
		if spec.group in groups:
			groups[spec.group].append(spec)
		cell_specs[id] = spec

	# Mapping is done like this:
	#   E (upper)
	#   A
	# D X B
	#   C
	#   F (lower)
	print("GENE: done!")
	block_logic = {
		"": { "models": groups.X },
		
		"A": { "models": groups.A },
		"B": { "models": groups.A },
		"C": { "models": groups.A },
		"D": { "models": groups.A },

		"AC": { "models": groups.AC },
		"BD": { "models": groups.AC },

		"AB": { "models": groups.AB },
		"BC": { "models": groups.AB },
		"CD": { "models": groups.AB },
		"AD": { "models": groups.AB },

		"ABD": { "models": groups.ABC },
		"BCD": { "models": groups.ABC },
		"ABC": { "models": groups.ABC },
		"ACD": { "models": groups.ABC },

		"ABCD": { "models": groups.ABCD },

		# OO

		"AE": { "models": groups.AE },
		"BE": { "models": groups.AE }, 
		"CE": { "models": groups.AE },
		"DE": { "models": groups.AE },

		"ACE": { "models": groups.ACE },
		"BDE": { "models": groups.ACE },

		"ABE": { "models": groups.ABE },
		"BCE": { "models": groups.ABE },
		"CDE": { "models": groups.ABE },
		"ADE": { "models": groups.ABE },

		"ABDE": { "models": groups.ABCE },
		"BCDE": { "models": groups.ABCE },
		"ABCE": { "models": groups.ABCE },
		"ACDE": { "models": groups.ABCE },

		"ABCDE": { "models": groups.ABCDE },

		# OO

		"AF": { "models": groups.AF }, 
		"BF": { "models": groups.AF }, 
		"CF": { "models": groups.AF },
		"DF": { "models": groups.AF },

		"ACF": { "models": groups.ACF },
		"BDF": { "models": groups.ACF },

		"ABF": { "models": groups.ABF },
		"BCF": { "models": groups.ABF },
		"CDF": { "models": groups.ABF },
		"ADF": {  "models": groups.ABF },
		
		"ABDF": { "models": groups.ABCF },
		"BCDF": { "models": groups.ABCF },
		"ABCF": { "models": groups.ABCF },
		"ACDF": { "models": groups.ABCF },

		"ABCDF": { "models": groups.ABCDF },

		# OO
		
		"AEF": { "models": groups.AEF }, 
		"BEF": { "models": groups.AEF }, 
		"CEF": { "models": groups.AEF },
		"DEF": { "models": groups.AEF },

		"ACEF": { "models": groups.ACEF },
		"BDEF": { "models": groups.ACEF },

		"ABEF": { "models": groups.ABEF },
		"BCEF": { "models": groups.ABEF },
		"CDEF": { "models": groups.ABEF },
		"ADEF": { "models": groups.ABEF },
		
		"ABDEF": { "models": groups.ABCEF },
		"BCDEF": { "models": groups.ABCEF },
		"ABCEF": { "models": groups.ABCEF },
		"ACDEF": { "models": groups.ABCEF },

		"ABCDEF": { "models": groups.ABCDEF },
		
		"E": { "models": groups.E },
		"F": { "models": groups.F },
		"EF": { "models": groups.EF },
	}
	

func plot(x: int, y: int, z: int, id = 0, axis = null):
	if axis:
		set_cell_item(x, y, z, id, Basis(axis).get_orthogonal_index())
	else:
		set_cell_item(x, y, z, id)

func minmax_range(a: int, b: int):
	return range(min(a, b), max(a, b))

func fill_room(a: Vector3, b: Vector3):
	var id = 0
	for y in minmax_range(a.y, b.y):
		for z in minmax_range(a.z, b.z):
			for x in minmax_range(a.x, b.x):
				set_cell_item(x, y, z, id)
				print(x, ' ', y, ' ', z)
	smooth_map()

func get_cell(x: int, y: int, z: int):
	return get_cell_item(x, y, z)
	
func _is_smoothable(x, y, z):
	var cell = get_cell_item(x, y, z)
	if cell == -1:
		return false
	return true
	#_get_spec_by_id(cell).auto

func pattern_remap(pattern: PoolStringArray) -> String:
	# Get this kind of logic in blender ?
	# - above MUST have pattern to use this pattern
	# - below MUST have pattern to use this pattern
#	if pattern.join("") == "ABCDE":
#		return "ABCDE"
#	while pattern[pattern.size() - 1] in ["E", "F"]:
#		pattern.remove(pattern.size() - 1)
	return pattern.join("")

func _get_surrounding_block_pattern(x, y, z) -> String:
	# This needs to have TYPE of the block as well somehow.
	var pattern = PoolStringArray()
	if _is_smoothable(x, y, z - 1):
		pattern.append("A")
	if _is_smoothable(x + 1, y, z):
		pattern.append("B")
	if _is_smoothable(x, y, z + 1):
		pattern.append("C")
	if _is_smoothable(x - 1, y, z):
		pattern.append("D")
	if _is_smoothable(x, y + 1, z):
		pattern.append("E")
	if _is_smoothable(x, y - 1, z):
		pattern.append("F")
	return pattern_remap(pattern)

func _smoothen(x: int, y: int, z: int):
	var cell = get_cell_item(x, y, z)
	var surrounding_blocks = _get_surrounding_block_pattern(x, y, z)
	var block_specs = _get_spec_by_id(cell)
	if block_specs:
		if surrounding_blocks in block_logic:
			var logic = block_logic[surrounding_blocks]
			var orientation = LevelCommon.block_orientation_to_orthogonal_index(surrounding_blocks)
			var block_spec = get_model(logic.models)
			if block_spec:
				if block_spec.id == -1:
					print(block_spec)
				set_cell_item(x, y, z, block_spec.id, orientation)
			else:
				print("NO model ", surrounding_blocks)
		else:
			print(surrounding_blocks, " not designated - ignored")
			set_cell_item(x, y, z, -1)

func smooth_map():
	_precalculate()
	print("GENE: architecturing")
	for y in range(-5, 5):
		for z in range(-50, 50):
			for x in range(-50, 50):
				_smoothen(x, y, z)
	print("GENE: done!")

func clear_map():
	clear()
