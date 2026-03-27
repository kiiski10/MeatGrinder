class_name HealthComponent extends Node


@export var max_health: float = 100
@export var body: CharacterBody2D
var current_health: float = max_health


func update(change_amount: float) -> void:
	current_health += change_amount
	if current_health <= 0:
		body.queue_free()
