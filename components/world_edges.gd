@tool

extends StaticBody2D


var left_edge: CollisionShape2D
var right_edge: CollisionShape2D
var top_edge: CollisionShape2D
var bottom_edge: CollisionShape2D

var _right_edge_position: float = 200
var _left_edge_position: float = 1
var _top_edge_position: float = 1
var _bottom_edge_position: float = 200

@export var right_edge_position: float = 200:
	get:
		return _right_edge_position
	set(value):
		_right_edge_position = value
		update_edges()

@export var left_edge_position: float = 1:
	get:
		return _left_edge_position
	set(value):
		_left_edge_position = value
		update_edges()

@export var top_edge_position: float = 1:
	get:
		return _top_edge_position
	set(value):
		_top_edge_position = value
		update_edges()

@export var bottom_edge_position: float = 200:
	get:
		return _bottom_edge_position
	set(value):
		_bottom_edge_position = value
		update_edges()


func update_edges():
	if right_edge and left_edge and top_edge and bottom_edge:
		right_edge.position.x = _right_edge_position
		left_edge.position.x = _left_edge_position
		top_edge.position.y = _top_edge_position
		bottom_edge.position.y = _bottom_edge_position


func _ready():
	left_edge = $LeftEdge
	right_edge = $RightEdge
	top_edge = $TopEdge
	bottom_edge = $BottomEdge
	update_edges()
