extends Node

var record = 60
var messages = [
	"DUNSTEST - A movement test",
	"MOUSE = Look",
	"WASD = Move",
	"SHIFT = Run",
	"SPACE = Jump",
	"SPACE REPEATEDLY = Climb",
	"@tcmug"
]

var message_timer
var help_printed = false

func print_help():
	if !is_instance_valid(message_timer):
		message_timer = Timer.new()
	get_node("/root/Game").add_child(message_timer)
	message_timer.wait_time = 0.2
	message_timer.one_shot = false
	message_timer.connect("timeout", self, "pop_message")
	message_timer.start()

func pop_message():
	var msg = messages.pop_front()
	if msg:
		get_node("/root/Game/UI/Screen/Log").add_text(msg)
	else:
		message_timer.stop()

func add_message(text: String):
	for line in text.split("\n"):
		messages.append(line)
	if message_timer.is_stopped():
		pop_message()
		message_timer.start()

func format_time(time: float):
	var minutes = floor(time / 60.0)
	var seconds = floor(time - (minutes * 60))
	var millis = floor((time - seconds - minutes * 60) * 1000)
	return "%d:%02d:%03d" % [minutes, seconds, millis]
