extends Spatial

var reload_timer: Timer

func _ready():
	State.print_help()
	reload_timer = Timer.new()
	reload_timer.wait_time = 5.0
	add_child(reload_timer)
	reload_timer.connect("timeout", self, "restart")
	
	var num_waypoints = 0
	for child in get_children():
		if child is Waypoint:
			num_waypoints += 1
	$UI.num_waypoints = num_waypoints

func _on_UI_timeout():
	$Music.stop()
	$SfxTimeout.play()
	reload_timer.start()

func restart():
	get_tree().reload_current_scene() 

func _on_UI_victory():
	var time = $UI/Timer.total_time 
	if time < State.record:
		$SfxVictory.play()
		$UI/Victory/Label.text = "A NEW RECORD!\n\n\nTIME\n\n%s\n\nPREVIOUS\n\n%s" % [State.format_time(time), State.format_time(State.record)]
		State.record = time
	else:
		$SfxVictoryNoRecord.play()
		$UI/Victory/Label.text = "YOU GOT IT!\n\n\nTIME\n\n%s\n\nRECORD\n\n%s" % [State.format_time(time), State.format_time(State.record)]
	yield(get_tree(), "idle_frame") 

	$Music.stop()
	reload_timer.start()
