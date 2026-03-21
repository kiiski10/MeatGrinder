extends Area2D
#if body.collision_layer == 1

func _input(event):
	if event is InputEventMouseMotion:
		position = event.position
