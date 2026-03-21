extends CharacterBody2D

var health: int = 100
var base_speed: int = 5000
var target: Area2D
var target_reached: bool = false
var direction: Vector2
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D


func _ready() -> void:
	target = $"../GlobalTargetArea2D"
	

func _physics_process(delta: float) -> void:
	nav_agent.target_position = target.position
	navigate(delta)


func navigate(delta: float) -> void:
	if nav_agent.is_navigation_finished():
		return
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	var new_velocity: Vector2 = (
		global_position.direction_to(next_path_position)
	)
	nav_agent.velocity = new_velocity * delta
	look_at(next_path_position)
	move_and_slide()


func _on_global_target_area_2d_body_entered(body: Node2D) -> void:
	if body == self:
		target_reached = true


func _on_global_target_area_2d_body_exited(body: Node2D) -> void:
	if body == self:
		target_reached = false


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	position += safe_velocity * get_physics_process_delta_time()
	#rotation = safe_velocity.angle()
