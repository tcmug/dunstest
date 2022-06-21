extends VBoxContainer

onready var proto_entry := load("res://UI/LogEntry.tscn")

func add_text(text):
	var entry = proto_entry.instance()
	entry.text = text
	add_child(entry)
