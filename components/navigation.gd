class_name NavigationComponent extends NavigationAgent2D

var body: CharacterBody2D
var new_velocity: Vector2


func _ready() -> void:
	body = get_parent() as CharacterBody2D
	velocity_computed.connect(_on_navigation_agent_2d_velocity_computed)


func update() -> void:
	if not body.target:
		return

	target_position = body.target.global_position
	if is_target_reached():
		body.set_status("FIGHTING")
		return

	new_velocity = body.global_position.direction_to(get_next_path_position()) * body.base_speed
	set_velocity(new_velocity)


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	body.velocity = safe_velocity
