extends Node2D

var arena: Node2D
var teams: Array
var available_machines: Array
var installed_machines: Array
var inputs: Array
var outputs: Array
var conveyor_belt_sections: Array


func _ready() -> void:
	print("Factory ready")


func _process(delta: float) -> void:
	for conveyor in conveyor_belt_sections:
		conveyor.move(delta)
