class_name MovementComponent extends Node

@export var speed: float = 100
@export var turn_speed: float = 5.0
var body: CharacterBody2D


func _ready() -> void:
	body = get_parent() as CharacterBody2D
	pass # Replace with function body.


func update(delta: float) -> void:
	if body == null:
		return

	# Face in direction of target
	if body.target != null:
		var desired_angle: float = (body.target.position - body.global_position).angle()
		body.rotation = lerp_angle(body.rotation, desired_angle, clamp(turn_speed * delta, 0, 1))
	
	# Do the actual movement
	body.move_and_slide()
