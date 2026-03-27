class_name LabelComponent extends Node

var body: CharacterBody2D
var rows: Array = []
var label: Label
var settings: LabelSettings
@export var font_size: int = 8
@export var line_spacing: int = -2


func _ready() -> void:
	body = get_parent() as CharacterBody2D
	label = Label.new()
	settings = LabelSettings.new()
	settings.font_size = font_size
	settings.line_spacing = line_spacing
	label.set_label_settings(settings)
	label.text = body.name
	add_child(label)


func set_color(color: Color) -> void:
	label.self_modulate = color


func update() -> void:
	label.global_position = body.global_position + Vector2(0, -20)

	# Keep label on top of the fighter and rotate it right side up
	label.rotation = 0
	label.global_position = body.global_position + Vector2(-15, -32)

	label.text = body.name + "\n"
	for line in rows:
		label.text += str(line) + "\n"
	rows = []


func add_row(text: String) -> void:
	rows.append(text)
