class_name MouseCursor extends Area2D


@onready var input: InputComponent = $InputComponent
@export var arena: Arena
var grid_size: int = 16
var factory_item_rotation: int = 0


func _process(_delta: float) -> void:
	var mouse_on_arena: bool = input.mouse_position.x < arena.factory.position.x
	var mouse_on_factory: bool = not mouse_on_arena

	if mouse_on_arena:
		position = input.mouse_position
		rotation_degrees = 0

		if input.mouse_click:
			if mouse_on_arena:
				print("Arena click at: ", input.mouse_position)
				var random_team = arena.team_instances[1] # Not actually random for now, just pick the second team
				arena.create_fighter_to_team(
					random_team,
					position
				)

	elif mouse_on_factory:
		# Cursor movement on factory snaps to grid
		var grid_position: Vector2 = (input.mouse_position - arena.factory.position) / grid_size
		position = arena.factory.position + round(grid_position) * grid_size
		rotation_degrees = factory_item_rotation

		if input.mouse_click:
			var factory_grid_position = arena.factory.tilemap_layer.local_to_map(position - arena.factory.position)
			print("Factory click at: ", input.mouse_position, factory_grid_position)

			if factory_grid_position in arena.factory.conveyor_belt_sections:
				print("Item already at position: ", factory_grid_position)
			else:
				arena.factory.set_item(
					arena.factory.conveyor_belt_scene,
					factory_grid_position,
					rotation_degrees
				)

		elif input.mouse_wheel_up:
			factory_item_rotation += 45

		elif input.mouse_wheel_down:
			factory_item_rotation -= 45

		if factory_item_rotation != rotation_degrees:
			factory_item_rotation = clamp(0, 360, factory_item_rotation)
			rotation_degrees = factory_item_rotation


func _ready() -> void:
	pass
