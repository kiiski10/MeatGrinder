extends Sprite2D

var next_sections: Array [Sprite2D]
var fighter_inside: Fighter
var product: Sprite2D
var processing_time: float = 20


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	# Adds new instance of product to fighter_inside.items
	pass


func move(delta: float) -> void:
	# Puts fighter_inside to random belt section from next_sections
	print("belt moves")
