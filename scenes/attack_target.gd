extends Area2D
var arena: Node

func _input(event):
	if event is InputEventMouseMotion:
		position = event.position
	elif Input.is_action_just_pressed("Click"):
		print("Clicked at: ", position)
		var random_team = arena.team_instances[1]
		arena.create_fighter_to_team(
			random_team,
			event.position

		)

func _ready() -> void:
	arena = get_parent()
