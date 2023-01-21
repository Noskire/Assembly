extends Node2D

onready var color_rect: ColorRect = get_node("CanvasLayer/ColorRect")
onready var tr_window: TextureRect = get_node("CanvasLayer/TRWindow")
onready var tr_robot: TextureRect = get_node("CanvasLayer/TRRobot")
onready var audio_button: AudioStreamPlayer = get_node("AudioButton")

var image: Image 
var image_colors = [Color.black, Color.red, Color.green, Color.blue]

func _ready():
	Parameters.game_completed = true
	
	var path = str("res://assets/img/Robot_Mirror_rgbv.png")
	var texture = load(path)
	image = texture.get_data()
	
	image.lock()
	var size = image.get_size()
	for x in size.x:
		for y in size.y:
			for i in image_colors.size():
				if image.get_pixel(x, y).is_equal_approx(image_colors[i]):
					image.set_pixel(x, y, Parameters.output_color[i])
					break
	image.unlock()
	
	var new_text = ImageTexture.new()
	new_text.create_from_image(image)
	tr_robot.set_texture(new_text)
	
	#color_rect.set_frame_color(Parameters.output_color[0])
	
	var new_img = ImageTexture.new()
	if Parameters.print_last_level != null:
		new_img.create_from_image(Parameters.print_last_level)
	tr_window.set_texture(new_img)
	
	get_node("AnimationPlayer").play("MoveWindow")

func _on_button_down():
	audio_button.play()
	yield(get_tree().create_timer(.2), "timeout")
	var err = get_tree().change_scene("res://source/scenes/Menu.tscn")
	if err != OK:
		print("Error in change to menu scene")
