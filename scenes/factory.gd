extends Node2D

var conveyor_belt_scene: PackedScene = load("res://scenes/belt.tscn")
@onready var input: InputComponent = %InputComponent
var team: Node
@export var arena: Node2D
var fighter_inputs: Array = []
var fighter_outputs: Array = []
var installed_factory_items: Dictionary[Vector2, Array] = {}
var tilemap_layer: TileMapLayer


func _ready() -> void:
	print("Factory ready")
	tilemap_layer = $TileMapLayer


func update(delta: float) -> void:
	for machine_array in installed_factory_items.values():
		for machine in machine_array:
			if machine.has_method("move"):
				machine.move(delta)


func move_fighter_to_arena(fighter: Node) -> void:
	arena.add_child(fighter)


func is_position_occupied(pos: Vector2) -> bool:
	var pos_has_array: bool = pos in installed_factory_items
	var pos_array_has_items: bool = pos_has_array and installed_factory_items[pos].size() > 0
	if pos_has_array and pos_array_has_items:
		return true
	else:
		return false


func set_item(scene: PackedScene, target_position: Vector2, cursor_rotation: float) -> void:
	var target_position_is_occupied: bool = is_position_occupied(target_position)
	if not target_position_is_occupied:
		installed_factory_items[target_position] = []
	else:
		var existing_items: Array = installed_factory_items[target_position]
		if existing_items.size() == 1:
			var existing_item: Node2D = installed_factory_items[target_position][0]
			var existing_item_name: String = existing_item.get_meta("name")
			if existing_item_name == "conveyor_belt":
				print("Place item on top of conveyor belt at ", target_position)
			else:
				print(target_position, " is already occupied by ", existing_item_name)
				return
		else:
			print(target_position, " is already occupied by multiple items")
			return
	var new_item: Node2D = scene.instantiate()
	new_item.position = target_position * 16
	new_item.rotation_degrees = cursor_rotation
	installed_factory_items[target_position].append(new_item)
	add_child(new_item)


func _process(_delta: float) -> void:
	pass
