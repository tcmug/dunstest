extends Control

signal timeout

var time_left: float = 0.0
var timeout := false
var total_time := 0.0

func _ready():
	set_process(false)

func _process(delta):
	time_left -= delta
	total_time += delta
	if time_left <= 0:
		total_time -= time_left
		emit_signal('timeout')
		set_process(false)
		timeout = true
	$Label.text = State.format_time(time_left)

func pickup(item):
	if timeout: return
	if not is_processing():
		get_node("/root/Level/Music").play()
		visible = true
		set_process(true)
	$SfxPickup.play()
	time_left += 10
	item.queue_free()


