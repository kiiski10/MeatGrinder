class_name MouseCursor extends Area2D


@onready var input: InputComponent = $InputComponent
@export var arena: Arena


func _process(_delta: float) -> void:
	position = input.mouse_position
	if input.mouse_click:
		var mouse_click_on_arena: bool = input.mouse_position.x < arena.factory.position.x
		if mouse_click_on_arena:
			print("Arena click at: ", input.mouse_position)
			var random_team = arena.team_instances[1]
			arena.create_fighter_to_team(
				random_team,
				input.mouse_position
			)


func _ready() -> void:
	pass
