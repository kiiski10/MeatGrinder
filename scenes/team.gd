extends Node

var fighter_scene: PackedScene = load("res://scenes/fighter.tscn")
var main_color: Color
var fighter_count: int = 25


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	for i in fighter_count:
		var fighter: CharacterBody2D = fighter_scene.instantiate()
		var x: int = rng.randi_range(20,1200)
		var y: int = rng.randi_range(20,700)
		fighter.position = Vector2(x, y)
		fighter.color = main_color
		add_child(fighter)
