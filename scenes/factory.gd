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
var conveyor_belt_sections: Array = []


func _ready() -> void:
	print("Factory ready")


func update(delta: float) -> void:
	for belt in conveyor_belt_sections:
		belt.move(delta)


func move_fighter_to_arena(fighter: Node) -> void:
	arena.add_child(fighter)


func set_item(scene: PackedScene, dest_position: Vector2) -> void:
	var new_item: Node2D = scene.instantiate()
	new_item.position = dest_position
	new_item.position.x -= position.x		# Adjust position to be relative to the factory
	conveyor_belt_sections.append(new_item)
	add_child(new_item)

func _process(_delta: float) -> void:
	pass
