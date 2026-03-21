extends Node2D

var fighter_count: int = 50
var fighter_scene: PackedScene = load("res://scenes/fighter.tscn")
var target_area: Area2D


func _ready() -> void:
	target_area = $GlobalTargetArea2D
	var rng = RandomNumberGenerator.new()

	for i in fighter_count:
		var fighter: CharacterBody2D = fighter_scene.instantiate()
		var x: int = rng.randi_range(20,1200)
		var y: int = rng.randi_range(20,700)
		fighter.position = Vector2(x, y)
		add_child(fighter)


func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == 1:
			print("Mouse btn 1 down at: ", event.position)
		elif event.button_index == 2:
			print("Mouse btn 2 down at: ", event.position)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("exit_game"):
		print("Bye!")
		get_tree().quit()
