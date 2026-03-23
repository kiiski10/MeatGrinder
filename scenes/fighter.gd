extends CharacterBody2D

var health: int = 100
var base_speed: int = 100
var target: Area2D
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


func _ready() -> void:
	target = $"../GlobalTargetArea2D"
	nav_agent = $NavigationAgent2D
	nav_agent.velocity_computed.connect(self._on_navigation_agent_2d_velocity_computed)
	debug_label = $Label
	blood_particles = $BloodGPUParticles2D
	# Pick a name for the fighter
	name = name_db.first_names.pick_random() + " " + name_db.last_names.pick_random()
	status = "IDLE"


func fight(delta: float) -> void:
	# Turn towards the target
	var desired_angle: float = (target.position - global_position).angle()
	rotation = lerp_angle(rotation, desired_angle, clamp(turn_speed * delta, 0, 1))

	# Hit the target
	# Spawn gpu particles for blood and play hit sound here


func _on_hit() -> void:
	blood_particles.emitting = true
	health -= 10
	if health <= 0:
		queue_free()


func _physics_process(delta: float) -> void:
	update_debug_label()
	navigate()
	if status == "NAVIGATING":
		var desired_angle: float = (next_path_position - global_position).angle()
		rotation = lerp_angle(rotation, desired_angle, clamp(turn_speed * delta, 0, 1))
		move_and_slide()
	elif status == "FIGHTING":
		fight(delta)

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
	nav_agent.target_position = target.position
	if not nav_agent.is_navigation_finished():
		status = "NAVIGATING"
		next_path_position = nav_agent.get_next_path_position()
		new_velocity = global_position.direction_to(next_path_position) * base_speed
		nav_agent.set_velocity(new_velocity)
	else:
		status = "FIGHTING"


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
