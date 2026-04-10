class_name InputComponent extends Node


@export var debug: bool
var exit_game_pressed: bool = false
var mouse_click: bool = false
var mouse_position: Vector2 = Vector2.ZERO
var mouse_wheel_up: bool = false
var mouse_wheel_down: bool = false
var item_menu_toggle_pressed: bool = false


func _process(_delta: float) -> void:
	exit_game_pressed = Input.is_action_just_pressed("exit_game")
	mouse_click = Input.is_action_just_pressed("Click")
	mouse_wheel_up = Input.is_action_just_pressed("mouse_wheel_up")
	mouse_wheel_down = Input.is_action_just_pressed("mouse_wheel_down")
	item_menu_toggle_pressed = Input.is_action_just_pressed("item_menu_toggle_pressed")


func _input(event):
	if debug:
		print(event)

	if event is InputEventMouseMotion:
		mouse_position = event.position
