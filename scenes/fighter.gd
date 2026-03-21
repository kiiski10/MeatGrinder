extends CharacterBody2D

var health: int = 100
var base_speed: int = 100
var target: Area2D
var target_reached: bool = false
var direction: Vector2
var nav_agent: NavigationAgent2D
var next_path_position: Vector2
var new_velocity: Vector2 = Vector2.ZERO
var debug_label: Label
var debug_lines: Array = []


func _ready() -> void:
	target = $"../GlobalTargetArea2D"
	nav_agent = $NavigationAgent2D
	nav_agent.velocity_computed.connect(self._on_navigation_agent_2d_velocity_computed)
	debug_label = $Label


func _physics_process(_delta: float) -> void:
	update_debug_label()
	navigate()
	look_at(next_path_position)
	move_and_slide()


func update_debug_label() -> void:
	#debug_lines.append("Target reached: " + str(target_reached))
	#debug_lines.append("Next path: " + str(next_path_position))
	debug_lines.append("Navigation finished: " + str(nav_agent.is_navigation_finished()))
	debug_label.text = ""
	for line in debug_lines:
		debug_label.text += str(line) + "\n"
	debug_lines = []


func navigate() -> void:
	nav_agent.target_position = target.position
	if not nav_agent.is_navigation_finished():
		next_path_position = nav_agent.get_next_path_position()
		new_velocity = global_position.direction_to(next_path_position) * base_speed
		nav_agent.set_velocity(new_velocity)


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	#debug_lines.append("Safe velocity: " + str(safe_velocity))
	velocity = safe_velocity
