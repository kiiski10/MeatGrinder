extends CharacterBody2D

var health: float = 100
var base_speed: int = 100
var target: CharacterBody2D
var color: Color
var direction: Vector2
var turn_speed: float = 5.0
var nav_agent: NavigationAgent2D
var next_path_position: Vector2
var new_velocity: Vector2 = Vector2.ZERO
var debug_label: Label
var debug_lines: Array = []
@export var name_db: NameDatabase
var status: String # IDLE, NAVIGATING, FIGHTING
var blood_particles: GPUParticles2D
var team: Node
var search_range: float = 200.0
var increase_search_range_timer: Timer


func _ready() -> void:
	target = find_new_target(search_range)
	nav_agent = $NavigationAgent2D
	nav_agent.velocity_computed.connect(self._on_navigation_agent_2d_velocity_computed)
	debug_label = $Label
	debug_label.self_modulate = color
	blood_particles = $BloodGPUParticles2D
	# Pick a name for the fighter
	name = name_db.first_names.pick_random() + " " + name_db.last_names.pick_random()

	increase_search_range_timer = Timer.new()
	increase_search_range_timer.wait_time = 0.5
	increase_search_range_timer.timeout.connect(_on_increase_search_range_timer_timeout)
	add_child(increase_search_range_timer)

	set_status("IDLE")


func fight(delta: float) -> void:	
	var desired_angle: float = (target.position - global_position).angle()
	rotation = lerp_angle(rotation, desired_angle, clamp(turn_speed * delta, 0, 1)) # Turn towards the target
	var damage: float = 5.0 # TODO: This should be adjusted based on the fighter's stats and weapon
	target.take_hit(damage)


func find_new_target(radius: float) -> Node2D:
	var enemy_team = team.enemy_teams.pick_random()
	var enemies_in_range = enemy_team.get_children().filter(func(e):
		return e.global_position.distance_to(global_position) < radius
	)
	return enemies_in_range.pick_random()


func take_hit(damage: float) -> void:
	blood_particles.emitting = true
	var damage_received: float = damage # TODO: This should be adjusted based on the fighter's stats and armor
	health -= damage_received
	if health <= 0:
		queue_free()


func _on_increase_search_range_timer_timeout():
	search_range += 50
	if search_range > 1200:
		search_range = 1200


func set_status(new_status: String) -> void:
	if status != new_status:
		status = new_status
		if new_status == "IDLE":
			increase_search_range_timer.start()
		else:
			increase_search_range_timer.stop()


func _physics_process(delta: float) -> void:
	update_debug_label()
	navigate()
	if status == "NAVIGATING":
		if not target:
			set_status("IDLE")
		var desired_angle: float = (next_path_position - global_position).angle()
		rotation = lerp_angle(rotation, desired_angle, clamp(turn_speed * delta, 0, 1))
		move_and_slide()
	elif status == "FIGHTING":
		if not target:
			set_status("IDLE")
		else:
			fight(delta)
	elif status == "IDLE":
		target = find_new_target(search_range)

	# Keep label on top of the fighter and rotate it right side up
	debug_label.rotation = -rotation
	debug_label.global_position = global_position + Vector2(-15, -32)


func update_debug_label() -> void:
	debug_lines.append(status)
	debug_label.text = name + "\n"
	for line in debug_lines:
		debug_label.text += str(line) + "\n"
	debug_lines = []


func navigate() -> void:
	if not target:
		set_status("IDLE")
		return
	debug_lines.append("TRGT: " + target.name)
	nav_agent.target_position = target.position
	if not nav_agent.is_navigation_finished():
		set_status("NAVIGATING")
		next_path_position = nav_agent.get_next_path_position()
		new_velocity = global_position.direction_to(next_path_position) * base_speed
		nav_agent.set_velocity(new_velocity)
	else:
		set_status("FIGHTING")


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
