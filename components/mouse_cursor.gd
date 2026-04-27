class_name MouseCursor extends Area2D


@onready var input: InputComponent = $InputComponent
var context_menu: PopupMenu
var arena: Arena
var grid_size: int = 16
var factory_item_rotation: int = 0
var selected_item: PackedScene = null
var menu_closed_frames_ago: int = -1


func _process(_delta: float) -> void:
	var mouse_on_arena: bool = input.mouse_position.x < arena.factory.position.x
	var mouse_on_factory: bool = not mouse_on_arena

	# The delay is needed to avoid clicks from registering to arena or factory
	# when closing the context menu by left clicking outside of it.
	if menu_closed_frames_ago >= 0:
		menu_closed_frames_ago += 1
		if menu_closed_frames_ago >= 2:
			menu_closed_frames_ago = -1
		return

	context_menu.position = input.mouse_position
	if input.mouse_second_click:
		context_menu.visible = not context_menu.visible

	if mouse_on_arena and not context_menu.visible:
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

	elif mouse_on_factory and not context_menu.visible:
		# Cursor movement on factory snaps to grid
		var grid_position: Vector2 = (input.mouse_position - arena.factory.position) / grid_size
		position = arena.factory.position + round(grid_position) * grid_size
		rotation_degrees = factory_item_rotation
		selected_item = arena.factory.conveyor_belt_scene

		if input.mouse_click:
			var factory_grid_position = arena.factory.tilemap_layer.local_to_map(position - arena.factory.position)
			print("Factory click at: ", input.mouse_position, factory_grid_position)

			if factory_grid_position in arena.factory.conveyor_belt_sections:
				print("Item already at position: ", factory_grid_position)
			else:
				arena.factory.set_item(
					selected_item,
					factory_grid_position,
					rotation_degrees
				)

		elif input.mouse_wheel_up:
			factory_item_rotation += 90

		elif input.mouse_wheel_down:
			factory_item_rotation -= 90

		if factory_item_rotation != rotation_degrees:
			if factory_item_rotation >= 360:
				factory_item_rotation = 0
			elif factory_item_rotation < 0:
				factory_item_rotation = 270
			print("Cursor rotation: ", factory_item_rotation)
			rotation_degrees = factory_item_rotation


func _ready() -> void:
	context_menu = %PopupMenu
	context_menu.visible = false
	context_menu.popup_hide.connect(_on_context_menu_closed)
	context_menu.index_pressed.connect(_on_context_menu_item_selected)


func _on_context_menu_closed() -> void:
	menu_closed_frames_ago = 0


func _on_context_menu_item_selected(index: int) -> void:
	var item_id = context_menu.get_item_id(index)
	menu_closed_frames_ago = 0
	print("Selected item id: ", item_id)
