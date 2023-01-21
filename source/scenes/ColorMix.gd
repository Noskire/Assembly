extends Node2D

onready var tilemap: TileMap = get_node("TileMap")
onready var level_text: Label = get_node("HUD/Control/Level")
onready var err_display: Label = get_node("HUD/Control/ErrorDisplay")
onready var err_timer: Timer = get_node("HUD/Control/ErrorTimer")
onready var hbox: HBoxContainer = get_node("HUD/Control/HBox")
onready var audio_select: AudioStreamPlayer = get_node("AudioSelect")
onready var audio_place: AudioStreamPlayer = get_node("AudioPlace")
onready var audio_button: AudioStreamPlayer = get_node("AudioButton")
onready var audio_error: AudioStreamPlayer = get_node("AudioError")

onready var pipe_path = preload("res://source/machines/Pipe.tscn")
onready var mixer_path = preload("res://source/machines/Mixer.tscn")
onready var spliter_path = preload("res://source/machines/Spliter.tscn")
onready var cinput_path = preload("res://source/machines/CInput.tscn")
onready var coutput_path = preload("res://source/machines/COutput.tscn")

enum options {Pipe, Mixer, Spliter, CInput, COutput}
var option = -1
var selected = false
var wait_sec_click = false
var err_message = ""

var machines = []
var offset
var p1
var p1_idx # -1 if not array
var p2
var p2_idx # -1 if not array
var connecting_first_pipe = false
var connecting_second_pipe = false

func _ready():
	var used_rect = tilemap.get_used_rect()
	offset = used_rect.position
	var tile_size = used_rect.size
	for i in tile_size.x:
		machines.push_back([])
		for j in tile_size.y:
			machines[i].push_back(0)
	
	var input_color = Parameters.input_color
	for i in input_color.size():
		var cin = cinput_path.instance()
		add_child(cin)
		cin.id = i
		cin.output_color = input_color[i]
		cin.position = Vector2(32, (i * 64 + 32))
		cin.update_color()
		machines[0][i * 2] = cin
	
	var cout = coutput_path.instance()
	add_child(cout)
	cout.id = Parameters.actual_level
	if cout.id == 0:
		level_text.set_text("First Color")
	elif cout.id == 1:
		level_text.set_text("Second Color")
	elif cout.id == 2:
		level_text.set_text("Third Color")
	elif cout.id == 3:
		level_text.set_text("Fourth Color")
	cout.input_color = Parameters.output_color[cout.id]
	cout.position = Vector2(320, 128)
	cout.update_color()
	machines[9][3] = cout

func click_in_option(id):
	option = id
	selected = true
	audio_select.play()

func _unhandled_input(event):
	if (event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT):
		if selected:
			var local_pos = tilemap.to_local(event.position)
			var cell_pos = tilemap.world_to_map(local_pos)
			var cell_id = tilemap.get_cellv(cell_pos)
			
			if cell_id == TileMap.INVALID_CELL: # Click outside of tilemap
				pass
			elif cell_id == 0: # Livre
				if option == options.Pipe:
					err_message = "Can't connect a pipe in a empty spot, click in a machine."
					display_error_message()
				else:
					tilemap.set_cellv(cell_pos, option)
					if option == options.Mixer:
						var mixer = mixer_path.instance()
						add_child(mixer)
						mixer.position = cell_pos * 32
						machines[cell_pos.x - offset.x][cell_pos.y - offset.y] = mixer
						audio_place.play()
					elif option == options.Spliter:
						var spliter = spliter_path.instance()
						add_child(spliter)
						spliter.position = cell_pos * 32
						machines[cell_pos.x - offset.x][cell_pos.y - offset.y] = spliter
						audio_place.play()
			elif cell_id != 0 and option == options.Pipe: # Occupied
				if cell_id != 4: # If not clicked in coutput
					connecting_first_pipe = true
					p1 = machines[cell_pos.x - offset.x][cell_pos.y - offset.y]
					update_hbox(cell_id)
					hbox.set_position(cell_pos * 32)
					audio_place.play()
				else:
					err_message = "The input of the pipe must connect in a machine output."
					display_error_message()
			else:
				err_message = "Tile ocuppied, choose a empty spot."
				display_error_message()
			selected = false
			get_node("Options" + str(option)).deselect()
		elif wait_sec_click:
			var local_pos = tilemap.to_local(event.position)
			var cell_pos = tilemap.world_to_map(local_pos)
			var cell_id = tilemap.get_cellv(cell_pos)
			
			if cell_id == TileMap.INVALID_CELL: # Click outside of tilemap
				pass
			elif cell_id == 0: # Livre
				err_message = "Can't connect a pipe in a empty spot, click in a machine."
				display_error_message()
			elif cell_id != 0: # Occupied
				if cell_id != 3: # If not clicked in cinput
					connecting_second_pipe = true
					p2 = machines[cell_pos.x - offset.x][cell_pos.y - offset.y]
					update_hbox(cell_id)
					hbox.set_position(cell_pos * 32)
					audio_place.play()
				else:
					err_message = "The output of the pipe must connect in a machine input."
					display_error_message()
			else:
				err_message = "Tile Ocuppied"
				display_error_message()
			wait_sec_click = false

func display_error_message():
	err_display.set_text(err_message)
	err_display.set_visible(true)
	err_timer.start(3.0)
	audio_error.play()

func _on_ErrorTimer_timeout():
	err_message = ""
	err_display.set_text(err_message)
	err_display.set_visible(false)

func update_hbox(opt):
	if connecting_first_pipe:
		if opt == options.CInput:
			button_down(-1)
		elif opt == options.Mixer:
			button_down(-1)
		elif opt == options.Spliter:
			hbox.get_node("VBoxInput/Input1").set_visible(false)
			hbox.get_node("VBoxInput/Input2").set_visible(false)
			hbox.get_node("VBoxOutput/Output1").set_visible(true)
			hbox.get_node("VBoxOutput/Output2").set_visible(true)
			hbox.get_node("VBoxOutput/Output3").set_visible(true)
			hbox.set_visible(true)
	elif connecting_second_pipe:
		if opt == options.COutput:
			button_down(-1)
		elif opt == options.Mixer:
			hbox.get_node("VBoxInput/Input1").set_visible(true)
			hbox.get_node("VBoxInput/Input2").set_visible(true)
			hbox.get_node("VBoxOutput/Output1").set_visible(false)
			hbox.get_node("VBoxOutput/Output2").set_visible(false)
			hbox.get_node("VBoxOutput/Output3").set_visible(false)
			hbox.set_visible(true)
		elif opt == options.Spliter:
			button_down(-1)

func _on_Input1_button_down():
	button_down(0)

func _on_Input2_button_down():
	button_down(1)

func _on_Output1_button_down():
	button_down(0)

func _on_Output2_button_down():
	button_down(1)

func _on_Output3_button_down():
	button_down(2)

func button_down(idx):
	var inout_free
	if connecting_first_pipe:
		err_message = "This output already has a pipe."
		if idx == -1:
			if p1.output_pipes == null:
				inout_free = true
			else:
				inout_free = false
		else:
			if p1.output_pipes[idx] == null:
				inout_free = true
			else:
				inout_free = false
	else:
		err_message = "This input already has a pipe."
		if idx == -1:
			if p2.input_pipes == null:
				inout_free = true
			else:
				inout_free = false
		else:
			if p2.input_pipes[idx] == null:
				inout_free = true
			else:
				inout_free = false

	if not inout_free:
		display_error_message()
	else:
		if connecting_first_pipe:
			p1_idx = idx
			wait_sec_click = true
		elif connecting_second_pipe:
			p2_idx = idx
			create_pipe()
	connecting_first_pipe = false
	connecting_second_pipe = false
	hbox.set_visible(false)

func create_pipe():
	var pipe = pipe_path.instance()
	add_child(pipe)
	#pipe.position = cell_pos * 32
	pipe.pipe_in = p1
	pipe.pin_idx = p1_idx
	pipe.pipe_out = p2
	pipe.pout_idx = p2_idx
	pipe.update_color()

func clear_from_matriz(pos):
	var cell_pos = pos / 32
	machines[cell_pos.x - offset.x][cell_pos.y - offset.y] = 0
	tilemap.set_cellv(cell_pos, 0)

func _on_Reset_button_down():
	audio_button.play()
	yield(get_tree().create_timer(.2), "timeout")
	var err = get_tree().reload_current_scene()
	if err != OK:
		print("Error in reload scene")

func _on_Save_button_down():
	audio_button.play()
	yield(get_tree().create_timer(.2), "timeout")
	var cout = machines[9][3]
	if cout.input_color.is_equal_approx(Color.transparent):
		err_message = "The Output has no color"
		display_error_message()
	else:
		cout.save_color()

func _on_BackToMenu_button_down():
	audio_button.play()
	yield(get_tree().create_timer(.2), "timeout")
	var err = get_tree().change_scene("res://source/scenes/Menu.tscn")
	if err != OK:
		print("Error in change to menu scene")
