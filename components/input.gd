class_name InputComponent extends Node


@export var debug: bool
var exit_game_pressed: bool = false
var mouse_click: bool = false
var mouse_position: Vector2 = Vector2.ZERO


func _process(_delta: float) -> void:
	exit_game_pressed = Input.is_action_just_pressed("exit_game")
	mouse_click = Input.is_action_just_pressed("Click")
		

func _input(event):
	if debug:
		print(event)

	if event is InputEventMouseMotion:
		mouse_position = event.position
