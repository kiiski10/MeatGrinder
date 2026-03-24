extends Node2D

var target_area: Area2D
var team_script = preload("res://scenes/team.gd")
var teams: Array = [
	{
		"name": "Red",
		"color": Color(1, 0, 0)
	},
	{
		"name": "Blue",
		"color": Color(0, 0, 1)
	}
]


func _ready() -> void:
	target_area = $GlobalTargetArea2D
	for team in teams:
		var new_team = team_script.new()
		new_team.name = team["name"]
		new_team.main_color = team["color"]
		add_child(new_team)


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
