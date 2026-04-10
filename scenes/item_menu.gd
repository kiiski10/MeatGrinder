class_name ItemMenu extends Control

var menu_button: MenuButton
var arena: Node2D
var selected_item: int = -1


func _ready() -> void:
	print(get_parent().name)
	arena = get_parent() as Node2D
	menu_button = $MenuButton
	menu_button.get_popup().index_pressed.connect(_on_item_selected)


func hide_menu():
	visible = false
	print("Item menu hidden")


func show_menu():
	visible = true
	menu_button.show_popup()
	print("Item menu shown")


func _on_item_selected(index: int) -> void:
	var popup = menu_button.get_popup()
	var item_text = popup.get_item_text(index)
	print("Selecting item: ", item_text, " (index: ", index, ")")
