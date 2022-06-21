extends Node
tool

func block_orientation_to_orthogonal_index(orientation: String) -> int: 
	return block_orientations[orientation]

func orthogonal_index_to_basis(index: int) -> Basis:
	return ortho_bases[index]

func normal_to_orthogonal_index(normal: Vector3) -> int:
	for i in ortho_bases.size():
		var basis = ortho_bases[i]
		if basis.z.dot(normal) <- 0.9 and basis.y.dot(Vector3.UP) > 0.9:
			return i
	print("normal_to_orthogonal_index not found for ", normal)
	return 0

var block_orientations = {
	"": Basis(Vector3(0, PI, 0)).get_orthogonal_index(),
	
	"A": Basis(Vector3(0, 0, 0)).get_orthogonal_index(),
	"B": Basis(Vector3(0, -PI/2, 0)).get_orthogonal_index(),
	"C": Basis(Vector3(0, PI, 0)).get_orthogonal_index(),
	"D": Basis(Vector3(0,  PI/2, 0)).get_orthogonal_index(),

	"AC": Basis(Vector3(0, PI, 0)).get_orthogonal_index(),
	"BD": Basis(Vector3(0, PI/2, 0)).get_orthogonal_index(),

	"AB": Basis(Vector3(0, 0, 0)).get_orthogonal_index(),
	"BC": Basis(Vector3(0, -PI/2, 0)).get_orthogonal_index(),
	"CD": Basis(Vector3(0, PI, 0)).get_orthogonal_index(),
	"AD": Basis(Vector3(0, PI/2, 0)).get_orthogonal_index(),

	"ABD": Basis(Vector3(0, PI/2, 0)).get_orthogonal_index(),
	"BCD": Basis(Vector3(0, -PI/2, 0)).get_orthogonal_index(),
	"ABC": Basis(Vector3(0, 0, 0)).get_orthogonal_index(),
	"ACD": Basis(Vector3(0, PI, 0)).get_orthogonal_index(),

	"ABCD": Basis(Vector3(0, PI, 0)).get_orthogonal_index(),

	# OO

	"AE": Basis(Vector3(0, 0, 0)).get_orthogonal_index(),
	"BE": Basis(Vector3(0, -PI/2, 0)).get_orthogonal_index(),
	"CE": Basis(Vector3(0, PI, 0)).get_orthogonal_index(),
	"DE": Basis(Vector3(0, PI/2, 0)).get_orthogonal_index(),

	"ACE": Basis(Vector3(0, PI, 0)).get_orthogonal_index(),
	"BDE": Basis(Vector3(0, PI/2, 0)).get_orthogonal_index(),

	"ABE": Basis(Vector3(0, 0, 0)).get_orthogonal_index(),
	"BCE": Basis(Vector3(0, -PI/2, 0)).get_orthogonal_index(),
	"CDE": Basis(Vector3(0, PI, 0)).get_orthogonal_index(),
	"ADE": Basis(Vector3(0, PI/2, 0)).get_orthogonal_index(),

	"ABDE": Basis(Vector3(0, PI/2, 0)).get_orthogonal_index(),
	"BCDE": Basis(Vector3(0, -PI/2, 0)).get_orthogonal_index(),
	"ABCE": Basis(Vector3(0, 0, 0)).get_orthogonal_index(),
	"ACDE": Basis(Vector3(0, PI, 0)).get_orthogonal_index(),

	"ABCDE": Basis(Vector3(0, PI, 0)).get_orthogonal_index(),

	# OO

	"AF": Basis(Vector3(0, 0, 0)).get_orthogonal_index(),
	"BF": Basis(Vector3(0, -PI/2, 0)).get_orthogonal_index(),
	"CF": Basis(Vector3(0, PI, 0)).get_orthogonal_index(),
	"DF": Basis(Vector3(0, PI/2, 0)).get_orthogonal_index(),

	"ACF": Basis(Vector3(0, PI, 0)).get_orthogonal_index(),
	"BDF": Basis(Vector3(0, PI/2, 0)).get_orthogonal_index(),

	"ABF": Basis(Vector3(0, 0, 0)).get_orthogonal_index(),
	"BCF": Basis(Vector3(0, -PI/2, 0)).get_orthogonal_index(),
	"CDF": Basis(Vector3(0, PI, 0)).get_orthogonal_index(),
	"ADF": Basis(Vector3(0, PI/2, 0)).get_orthogonal_index(),
	
	"ABDF": Basis(Vector3(0, PI/2, 0)).get_orthogonal_index(),
	"BCDF": Basis(Vector3(0, -PI/2, 0)).get_orthogonal_index(),
	"ABCF": Basis(Vector3(0, 0, 0)).get_orthogonal_index(), 
	"ACDF": Basis(Vector3(0, PI, 0)).get_orthogonal_index(),

	"ABCDF": Basis(Vector3(0, PI, 0)).get_orthogonal_index(),

	# OO
	
	"AEF": Basis(Vector3(0, 0, 0)).get_orthogonal_index(),
	"BEF": Basis(Vector3(0, -PI/2, 0)).get_orthogonal_index(),
	"CEF": Basis(Vector3(0, PI, 0)).get_orthogonal_index(),
	"DEF": Basis(Vector3(0, PI/2, 0)).get_orthogonal_index(),

	"ACEF": Basis(Vector3(0, PI, 0)).get_orthogonal_index(),
	"BDEF": Basis(Vector3(0, PI/2, 0)).get_orthogonal_index(),

	"ABEF": Basis(Vector3(0, 0, 0)).get_orthogonal_index(),
	"BCEF": Basis(Vector3(0, -PI/2, 0)).get_orthogonal_index(),
	"CDEF": Basis(Vector3(0, PI, 0)).get_orthogonal_index(),
	"ADEF": Basis(Vector3(0, PI/2, 0)).get_orthogonal_index(),
	
	"ABDEF": Basis(Vector3(0, PI/2, 0)).get_orthogonal_index(),
	"BCDEF": Basis(Vector3(0, -PI/2, 0)).get_orthogonal_index(),
	"ABCEF": Basis(Vector3(0, 0, 0)).get_orthogonal_index(),
	"ACDEF": Basis(Vector3(0, PI, 0)).get_orthogonal_index(),

	"ABCDEF": Basis(Vector3(0, PI, 0)).get_orthogonal_index(),
	
	"E": Basis(Vector3(0, PI, 0)).get_orthogonal_index(),
	"EF": Basis(Vector3(0, PI, 0)).get_orthogonal_index(),
	"F": Basis(Vector3(0, PI, 0)).get_orthogonal_index(),
}

const ortho_bases = [
	Basis(Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1)),
	Basis(Vector3(0, 1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 1)),
	Basis(Vector3(-1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, 1)),
	Basis(Vector3(0, -1, 0), Vector3(1, 0, 0), Vector3(0, 0, 1)),
	Basis(Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, -1, 0)),
	Basis(Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(1, 0, 0)),
	Basis(Vector3(-1, 0, 0), Vector3(0, 0, 1), Vector3(0, 1, 0)),
	Basis(Vector3(0, -1, 0), Vector3(0, 0, 1), Vector3(-1, 0, 0)),
	Basis(Vector3(1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, -1)),
	Basis(Vector3(0, 1, 0), Vector3(1, 0, 0), Vector3(0, 0, -1)),
	Basis(Vector3(-1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, -1)),
	Basis(Vector3(0, -1, 0), Vector3(-1, 0, 0), Vector3(0, 0, -1)),
	Basis(Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, 1, 0)),
	Basis(Vector3(0, 1, 0), Vector3(0, 0, -1), Vector3(-1, 0, 0)),
	Basis(Vector3(-1, 0, 0), Vector3(0, 0, -1), Vector3(0, -1, 0)),
	Basis(Vector3(0, -1, 0), Vector3(0, 0, -1), Vector3(1, 0, 0)),
	Basis(Vector3(0, 0, -1), Vector3(0, 1, -0), Vector3(1, 0, -0)),
	Basis(Vector3(0, 0, -1), Vector3(-1, 0, -0), Vector3(0, 1, -0)),
	Basis(Vector3(0, 0, -1), Vector3(0, -1, -0), Vector3(-1, 0, -0)),
	Basis(Vector3(0, 0, -1), Vector3(1, 0, -0), Vector3(0, -1, -0)),
	Basis(Vector3(0, 0, 1), Vector3(0, -1, 0), Vector3(1, 0, 0)),
	Basis(Vector3(0, 0, 1), Vector3(1, 0, 0), Vector3(0, 1, 0)),
	Basis(Vector3(0, 0, 1), Vector3(0, 1, 0), Vector3(-1, 0, 0)),
	Basis(Vector3(0, 0, 1), Vector3(-1, 0, 0), Vector3(0, -1, 0)),
]
