extends Node

var arena: Node
var main_color: Color
var enemy_teams: Array = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	arena = get_parent()
