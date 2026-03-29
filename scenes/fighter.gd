class_name Fighter extends CharacterBody2D

@onready var health: HealthComponent = %HealthComponent
@onready var movement: MovementComponent = %MovementComponent
@onready var label: LabelComponent = %LabelComponent
@onready var navigation: NavigationComponent = $NavigationComponent

var base_speed: int = 100
var target: CharacterBody2D
var color: Color
@export var name_db: NameDatabase
var status: String # IDLE, NAVIGATING, FIGHTING
var blood_particles: GPUParticles2D
var team: Node
var search_range: float = 200.0
var increase_search_range_timer: Timer


func _ready() -> void:
	target = find_new_target(search_range)
	blood_particles = $BloodGPUParticles2D
	# Pick a name for the fighter
	name = name_db.first_names.pick_random() + " " + name_db.last_names.pick_random()
	label.set_color(team.main_color)
	increase_search_range_timer = Timer.new()
	increase_search_range_timer.wait_time = 0.5
	increase_search_range_timer.timeout.connect(_on_increase_search_range_timer_timeout)
	add_child(increase_search_range_timer)
	set_status("IDLE")


func fight(_delta: float) -> void:
	var damage: float = 5.0 # TODO: This should be adjusted based on the fighter's stats and weapon
	target.take_hit(damage)


func find_new_target(radius: float) -> Node2D:
	var enemy_team = team.enemy_teams.pick_random()
	var enemies_in_range = enemy_team.get_children().filter(func(e):
		return e.global_position.distance_to(global_position) < radius
	)
	if enemies_in_range.size() == 0:
		return null
	return enemies_in_range.pick_random()


func take_hit(damage: float) -> void:
	blood_particles.emitting = true
	var damage_received: float = damage # TODO: This should be adjusted based on the fighter's stats and armor
	health.update(-damage_received)


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
	navigation.update()
	navigate()
	if status == "NAVIGATING":
		if not target:
			set_status("IDLE")
		movement.update(delta)
	elif status == "FIGHTING":
		if not target:
			set_status("IDLE")
		else:
			fight(delta)
	elif status == "IDLE":
		target = find_new_target(search_range)
	label.update()


func update_debug_label() -> void:
	label.add_row("Status: " + status)


func navigate() -> void:
	if not target:
		set_status("IDLE")
		return
	else:
		label.add_row("TRGT: " + target.name)

	if not navigation.is_target_reached():
		set_status("NAVIGATING")
	else:
		set_status("FIGHTING")
