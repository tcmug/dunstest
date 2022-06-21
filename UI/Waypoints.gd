extends VBoxContainer

var num_waypoints = 0 setget set_num_waypoints

func set_num_waypoints(wps):
	num_waypoints = wps
	$Label.text = "%s LEFT" % [num_waypoints]

