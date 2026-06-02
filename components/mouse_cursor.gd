class_name MouseCursor extends Area2D


@onready var input: InputComponent = $InputComponent
@onready var pointer_sprite: Sprite2D = $Sprite2D
@onready var default_pointer: Sprite2D = $DefaultPointer
var context_menu: PopupMenu
var arena: Arena
var grid_size: int = 16
var factory_item_rotation: int = 0
var selected_item: Dictionary = {}
var menu_closed_frames_ago: int = -1
var available_menu_items: Array[Dictionary] = [
	{
		"label": "Small gun",
		"attributes": {
			"scene": load("res://scenes/small_gun.tscn"),
			"type": "gun",
			"damage": 10,
			"range": 100,
			"fire_rate": 1,
		},
	},
	{
		"label": "Big gun",
		"attributes": {
			"scene": load("res://scenes/big_gun.tscn"),
			"type": "gun",
			"damage": 20,
			"range": 150,
			"fire_rate": 1.5,
		},
	},
	{
		"label": "Conveyor belt",
		"attributes": {
			"scene": load("res://scenes/belt.tscn"),
			"type": "factory_part",
		},
	},
	{
		"label": "Armor",
		"attributes": {
			"scene": load("res://scenes/armor.tscn"),
			"type": "stat_modifier",
			"damage_receive_multiplier": 0.8,
		}
	},
	{
		"label": "Speed boost",
		"attributes": {
			"scene": load("res://scenes/speed_boost.tscn"),
			"type": "stat_modifier",
			"speed_multiplier": 1.5,
		}
	},
]


func add_menu_item(label: String, item: Dictionary) -> void:
	var item_name = label
	var item_attributes = item["attributes"]
	var temp_scene_instance: Node2D = item_attributes["scene"].instantiate()
	var item_icon = temp_scene_instance.find_child("Sprite2D").texture
	var item_metadata = {
		"id": context_menu.get_item_count(),
		"name": item_name,
		"icon": item_icon,
		"attributes": item_attributes,
	}
	context_menu.add_icon_item(item_icon, item_name, item_metadata["id"])
	context_menu.set_item_metadata(item_metadata["id"], item_metadata)
	temp_scene_instance.queue_free()


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

	# Show mouse pointer if context menu is open, hide it otherwise
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if context_menu.visible else Input.MOUSE_MODE_HIDDEN

	context_menu.position = input.mouse_position
	if input.mouse_second_click:
		context_menu.visible = not context_menu.visible

	if mouse_on_arena and not context_menu.visible:
		position = input.mouse_position

		# Show default mouse pointer on arena
		default_pointer.visible = true
		pointer_sprite.visible = false
		pointer_sprite.texture = default_pointer.texture
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

		default_pointer.visible = false
		pointer_sprite.visible = true

		if selected_item:
			# Change mouse pointer if item is selected
			pointer_sprite.texture = selected_item["icon"]

		if input.mouse_click:
			var factory_grid_position = arena.factory.tilemap_layer.local_to_map(position - arena.factory.position)
			print("Factory click at: ", input.mouse_position, factory_grid_position)

			if arena.factory.is_position_occupied(factory_grid_position):
				print("Position is already occupied, removing item at ", factory_grid_position)
				arena.factory.remove_item(factory_grid_position)
			elif selected_item == {}:
				print("No item selected to place on factory")
			else:
				arena.factory.set_item(
					selected_item["attributes"]["scene"],
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
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	context_menu = %PopupMenu
	context_menu.visible = false
	context_menu.popup_hide.connect(_on_context_menu_closed)
	context_menu.index_pressed.connect(_on_context_menu_item_selected)
	for item in available_menu_items:
		add_menu_item(item["label"], item)


func _on_context_menu_closed() -> void:
	menu_closed_frames_ago = 0


func _on_context_menu_item_selected(index: int) -> void:
	var item_id = context_menu.get_item_id(index)
	menu_closed_frames_ago = 0
	var item_metadata = context_menu.get_item_metadata(item_id)
	print("Selected item: ", item_metadata["name"], " ", item_metadata["attributes"])
	selected_item = item_metadata
