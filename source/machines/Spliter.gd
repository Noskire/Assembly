extends Node2D

var type = "Spliter"
var input_color = Color.transparent
var input_pipes = null
var output_color = [Color.transparent, Color.transparent, Color.transparent]
var output_pipes = [null, null, null]

func update_color():
	output_color = [input_color, input_color, input_color]
	get_node("Polygon2D").set_color(input_color)
	
	for pipe in output_pipes:
		if pipe != null:
			pipe.update_color()

func _on_input_event(_viewport, event, _shape_idx):
	if (event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_RIGHT):
		if input_pipes != null:
			input_pipes.delete_pipe()
		for pipe in output_pipes:
			if pipe != null:
				pipe.delete_pipe()
		get_tree().set_input_as_handled()
		get_parent().clear_from_matriz(position) # Clear spot in matrix
		queue_free()
