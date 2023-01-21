extends Node2D

var type = "CInput"
var id
var output_color
var output_pipes = null

func update_color():
	get_node("Polygon2D").set_color(output_color)
