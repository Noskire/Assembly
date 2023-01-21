extends Node2D

var type = "COutput"
var id
var input_color: Color
var input_pipes = null

var color_temperature
var rgb_radiance = [1000, 4000, 13000]
var max_radiance = 18000

func update_color():
	get_node("Polygon2D").set_color(input_color)
	
	# RED 0 > BLUE 240 
#	var hue = input_color.h
#	if hue < 0.666667:
#		color_temperature = 1000 + (17000 * hue / 2 * 3)
#	else:
#		color_temperature = 1000 + (17000 * (1 - hue) * 3)
#
#	var value = (1 - input_color.s)
#	#if value < 0.5: # Dark
#		#color_temperature = color_temperature * value
#	#elif value > 0.5: # White
#		#color_temperature = 9500 + (color_temperature - 9500) * (1 - value) * 2
#	color_temperature = color_temperature + (9500 - color_temperature) * value

func save_color():
	Parameters.output_color[id] = input_color
	Parameters.change_level()
	if Parameters.actual_level == 4:
		# END GAME
		var image = get_viewport().get_texture().get_data()
		image.flip_y()
		Parameters.print_last_level = image
		
		var err = get_tree().change_scene("res://source/scenes/EndLevel.tscn")
		if err != OK:
			print("Error in change to end scene")
	else:
		# Restart level
		var err = get_tree().reload_current_scene()
		if err != OK:
			print("Error in reload scene")
