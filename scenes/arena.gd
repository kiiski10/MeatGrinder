class_name Arena extends Node2D
@onready var input: InputComponent = %InputComponent
@onready var factory: Node2D = $Factory


var team_script = preload("res://scenes/team.gd")
var fighter_scene: PackedScene = load("res://scenes/fighter.tscn")
var fighter_count: int = 25
var team_instances: Array = []
var fighter_spawn_timer: Timer
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
	fighter_spawn_timer = Timer.new()
	add_child(fighter_spawn_timer)
	fighter_spawn_timer.wait_time = 1.0
	fighter_spawn_timer.timeout.connect(_on_fighter_spawn_timer_timeout)
	fighter_spawn_timer.one_shot = false
	fighter_spawn_timer.start()


func _on_fighter_spawn_timer_timeout():
	create_fighter_to_team(
		team_instances[0],
		Vector2(
			randf_range(20,100),
			randf_range(20,700)
		)
	)


func _process(delta: float) -> void:
	if input.exit_game_pressed:
		print("Bye!")
		get_tree().quit()
	factory.update(delta)
