extends Node2D

var type = "Mixer"
var input_color = [Color.transparent, Color.transparent]
var input_pipes = [null, null]
var output_color = Color.transparent
var output_pipes = null

func update_color():
	output_color = (input_color[0] + input_color[1]) / 2
	get_node("PolyIn1").set_color(input_color[0])
	get_node("PolyIn2").set_color(input_color[1])
	get_node("PolyOut").set_color(output_color)
	
	if output_pipes != null:
		output_pipes.update_color()

func _on_input_event(_viewport, event, _shape_idx):
	if (event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_RIGHT):
		for pipe in input_pipes:
			if pipe != null:
				pipe.delete_pipe()
		if output_pipes != null:
			output_pipes.delete_pipe()
		get_tree().set_input_as_handled()
		get_parent().clear_from_matriz(position) # Clear spot in matrix
		queue_free()
