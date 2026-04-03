class_name MouseCursor extends Area2D


@onready var input: InputComponent = $InputComponent
@export var arena: Arena
var grid_size: int = 16


func _process(_delta: float) -> void:
	var mouse_on_arena: bool = input.mouse_position.x < arena.factory.position.x
	if mouse_on_arena:
		position = input.mouse_position
	else:
		# Cursor movement on factory snaps to grid
		var grid_position: Vector2 = (input.mouse_position - arena.factory.position) / grid_size
		position = arena.factory.position + round(grid_position) * grid_size

	if input.mouse_click:
		if mouse_on_arena:
			print("Arena click at: ", input.mouse_position)
			var random_team = arena.team_instances[1]
			arena.create_fighter_to_team(
				random_team,
				position
			)
		else:
			var factory_grid_position = arena.factory.tilemap_layer.local_to_map(position - arena.factory.position)
			print("Factory click at: ", input.mouse_position, factory_grid_position)

			if factory_grid_position in arena.factory.conveyor_belt_sections:
				print("Item already at position: ", factory_grid_position)
			else:
				arena.factory.set_item(arena.factory.conveyor_belt_scene, factory_grid_position)				


func _ready() -> void:
	pass
