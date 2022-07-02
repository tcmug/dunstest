extends Area
class_name Waypoint

signal pickup

func _ready():
	connect("pickup", get_node("/root/Game/UI/Screen"), "pickup")

func _on_Waypoint_body_entered(body):
	emit_signal("pickup", self)
