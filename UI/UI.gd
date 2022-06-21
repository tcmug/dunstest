extends Control

signal victory
signal timeout

var num_waypoints = 0

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
