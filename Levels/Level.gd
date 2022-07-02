extends Spatial
tool

export(int) var level_seed = 33 setget set_level_seed

onready var randomizer: RandomNumberGenerator

func _ready():
	init_randomizer(level_seed)

func set_level_seed(new_seed):
	init_randomizer(new_seed)
	generate()

func init_randomizer(the_seed):
	level_seed = the_seed
	randomizer = RandomNumberGenerator.new()
	randomizer.seed = the_seed

func generate():
	if $Map:
		var o = Vector3.ZERO
		var e = Vector3(16, 0, 16)
		var foo = LevelTypes.TreeNode.new(o, e, randomizer)
		var rooms = foo.split(1)
		$Map.clear_map()
		for room in rooms:
			$Map.fill_room(
				room.center - room.extents,
				room.center + room.extents
			)
		$Map.smooth_map()
