class_name StateComponent extends Node


var body: CharacterBody2D
var status: String # IDLE, NAVIGATING, FIGHTING, SEARCHING
var previous_status: String


func _ready() -> void:
	body = get_parent() as CharacterBody2D
	status = "IDLE"


func update() -> void:
	var status_changed: bool = status != previous_status
	if status_changed:
		if status == "IDLE":
			body.increase_search_range_timer.start()
		elif previous_status == "IDLE":
			body.increase_search_range_timer.stop()	

	if status == "NAVIGATING":
		if not body.target:
			status = "IDLE"
		elif body.navigation.is_target_reached():
			status = "FIGHTING"

	elif status == "FIGHTING":
		if not body.target:
			status = "IDLE"
		elif body.target.global_position.distance_to(body.target.global_position) > body.weapon_range:
			body.target = null
			status = "IDLE"

	elif status == "IDLE":
		status = "SEARCHING"

	elif status == "SEARCHING":
		body.target = body.find_new_target(body.search_range)
		if body.target:
			status = "NAVIGATING"
