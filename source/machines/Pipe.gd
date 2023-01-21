extends Node2D

onready var poly: Polygon2D = get_node("Polygon2D")
onready var coll: CollisionPolygon2D = get_node("Area2D/CollisionPolygon2D")

var pipe_in
var pin_idx # -1 if not array
var pipe_out
var pout_idx # -1 if not array
var incolor

func update_color():
	if pin_idx == -1:
		incolor = pipe_in.output_color
	else:
		incolor = pipe_in.output_color[pin_idx]
	
	var poly_vert: PoolVector2Array = []
	if pipe_in.type == "Spliter":
		if pin_idx == 0:
			poly_vert.push_back(pipe_in.position + Vector2(14, 2))
			poly_vert.push_back(pipe_in.position + Vector2(18, 2))
		elif pin_idx == 1:
			poly_vert.push_back(pipe_in.position + Vector2(30, 14))
			poly_vert.push_back(pipe_in.position + Vector2(30, 18))
		else:
			poly_vert.push_back(pipe_in.position + Vector2(18, 30))
			poly_vert.push_back(pipe_in.position + Vector2(14, 30))
	else: # Mixer or CInput
		poly_vert.push_back(pipe_in.position + Vector2(30, 14))
		poly_vert.push_back(pipe_in.position + Vector2(30, 18))

	if pipe_out.type == "Mixer":
		if pout_idx == 0:
			if pin_idx == 0:
				poly_vert.push_back(pipe_out.position + Vector2(2, 11))
				poly_vert.push_back(pipe_out.position + Vector2(2, 15))
			else:
				poly_vert.push_back(pipe_out.position + Vector2(2, 15))
				poly_vert.push_back(pipe_out.position + Vector2(2, 11))
		else:
			if pin_idx == 2:
				poly_vert.push_back(pipe_out.position + Vector2(2, 17))
				poly_vert.push_back(pipe_out.position + Vector2(2, 21))
			else:
				poly_vert.push_back(pipe_out.position + Vector2(2, 21))
				poly_vert.push_back(pipe_out.position + Vector2(2, 17))
	else: # Spliter or COutput
		poly_vert.push_back(pipe_out.position + Vector2(2, 18))
		poly_vert.push_back(pipe_out.position + Vector2(2, 14))
	
	poly.set_polygon(poly_vert)
	poly.set_color(incolor)
	coll.set_polygon(poly_vert)
	
	if pin_idx == -1:
		pipe_in.output_pipes = self
	else:
		pipe_in.output_pipes[pin_idx] = self
	if pout_idx == -1:
		pipe_out.input_pipes = self
	else:
		pipe_out.input_pipes[pout_idx] = self
	
	if pout_idx == -1:
		pipe_out.input_color = incolor
	else:
		pipe_out.input_color[pout_idx] = incolor
	pipe_out.update_color()

func delete_pipe():
	if pin_idx == -1:
		pipe_in.output_pipes = null
	else:
		pipe_in.output_pipes[pin_idx] = null
	if pout_idx == -1:
		pipe_out.input_pipes = null
	else:
		pipe_out.input_pipes[pout_idx] = null
	
	get_tree().set_input_as_handled()
	queue_free()

func _on_poly_input_event(_viewport, event, _shape_idx):
	if (event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_RIGHT):
		delete_pipe()
