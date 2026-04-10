extends Node2D

var conveyor_belt_scene: PackedScene = load("res://scenes/belt.tscn")
var machine_scene: PackedScene = load("res://scenes/machine.tscn")
@onready var input: InputComponent = %InputComponent
var team: Node
@export var arena: Node2D
var available_machines: Array = []
var installed_machines: Array = []
var fighter_inputs: Array = []
var fighter_outputs: Array = []
var conveyor_belt_sections: Dictionary[Vector2, Sprite2D] = {}
var tilemap_layer: TileMapLayer


func _ready() -> void:
	print("Factory ready")
	tilemap_layer = $TileMapLayer


func update(delta: float) -> void:
	for belt in conveyor_belt_sections.values():
		belt.move(delta)


func move_fighter_to_arena(fighter: Node) -> void:
	arena.add_child(fighter)


func set_item(scene: PackedScene, dest_position: Vector2, cursor_rotation: float) -> void:
	var new_item: Node2D = scene.instantiate()
	new_item.position = dest_position * 16
	new_item.rotation_degrees = cursor_rotation
	conveyor_belt_sections[dest_position] = new_item
	add_child(new_item)

func _process(_delta: float) -> void:
	pass
