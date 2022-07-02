extends Spatial

var reload_timer: Timer

func get_next_level():
	return load("res://Levels/Level1.tscn").instance()
	
func _ready():
	add_child(get_next_level());
	State.print_help()
	reload_timer = Timer.new()
	reload_timer.wait_time = 5.0
	add_child(reload_timer)
	reload_timer.connect("timeout", self, "restart")

func _on_Screen_timeout():
	$Music.stop()
	$SfxTimeout.play()
	reload_timer.start()

func restart():
	get_tree().reload_current_scene() 

func _on_Screen_victory():
	var time = $UI/Screen/Timer.total_time 
	if time < State.record:
		$SfxVictory.play()
		$UI/Screen/Victory/Label.text = "A NEW RECORD!\n\n\nTIME\n\n%s\n\nPREVIOUS\n\n%s" % [State.format_time(time), State.format_time(State.record)]
		State.record = time
		State.add_message($UI/Screen/Victory/Label.text)
	else:
		$SfxVictoryNoRecord.play()
		$UI/Screen/Victory/Label.text = "YOU GOT IT!\n\n\nTIME\n\n%s\n\nRECORD\n\n%s" % [State.format_time(time), State.format_time(State.record)]
		State.add_message($UI/Screen/Victory/Label.text)
	yield(get_tree(), "idle_frame") 

	$Music.stop()
	reload_timer.start()
