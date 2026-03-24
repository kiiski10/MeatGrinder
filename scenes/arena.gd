extends Node2D

var target_area: Area2D
var team_script = preload("res://scenes/team.gd")
var fighter_scene: PackedScene = load("res://scenes/fighter.tscn")
var fighter_count: int = 25
var team_instances: Array = []
var teams: Array = [
	{
		"name": "Red",
		"color": Color(1, 0, 0)
	},
	{
		"name": "Blue",
		"color": Color(0, 0, 1)
	},
	# {
	# 	"name": "Green",
	# 	"color": Color(0, 1, 0)
	# },
]


func create_fighter_to_team(team: Node, pos: Vector2) -> CharacterBody2D:
	var fighter: CharacterBody2D = fighter_scene.instantiate()
	fighter.position = pos
	fighter.color = team.main_color
	fighter.team = team
	team.add_child(fighter)
	return fighter


func _ready() -> void:
	for team in teams:
		var new_team = team_script.new()
		new_team.name = team["name"]
		new_team.main_color = team["color"]
		add_child(new_team)
		team_instances.append(new_team)

	# Set enemy teams for each team
	for team in team_instances:
		for t in team_instances:
			if t["name"] != team["name"]:
				team.enemy_teams.append(t)

	for team in team_instances:
		for i in fighter_count:
			var fighter: CharacterBody2D = create_fighter_to_team(team, position)
			var rng = RandomNumberGenerator.new()
			var x: int = rng.randi_range(20,1200)
			var y: int = rng.randi_range(20,700)
			fighter.position = Vector2(x, y)


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
