extends Control

signal victory
signal timeout

var num_waypoints = 0

func _ready():
	yield(get_tree(), "idle_frame") 
	num_waypoints = len(get_tree().get_nodes_in_group('waypoints'))
	print("WAYPOINTS: %s" % [num_waypoints])

func pickup(item):
	num_waypoints -= 1
	if not $OutOfTime.visible:
		if num_waypoints > 1:
			State.add_message("%d LEFT" % num_waypoints)
		if num_waypoints == 1:
			State.add_message("LAST ONE!")
		if num_waypoints == 0:
			$Victory.visible = true
			$Timer.visible = false
			emit_signal("victory")
		$Timer.pickup(item)

func _on_Timer_timeout():
	$OutOfTime.visible = true
	$Timer.visible = false
	emit_signal("timeout")
