extends Node

var input_color = [Color.white, Color.red, Color.green, Color.blue]
var output_color = [Color.transparent, Color.transparent, Color.transparent, Color.transparent]
#var output_color = ["#293b49", "#6d8a8d", "#bfc3c6", "#ffffe4"]
var actual_level = 0

var print_last_level
var game_continue = false
var game_completed = false

var master_vol = 0.0
var music_vol = -12.0
var sfx_vol = -12.0
var voice_vol = -12.0

func new_game():
	actual_level = 0
	output_color = [Color.transparent, Color.transparent, Color.transparent, Color.transparent]

func change_level():
	actual_level += 1
	if actual_level > 0 and actual_level < 4:
		game_continue = true
	else:
		game_continue = false

func update_vol(idx, vol):
	if vol == -25:
		AudioServer.set_bus_mute(idx, true)
	else:
		AudioServer.set_bus_volume_db(idx, vol)
		AudioServer.set_bus_mute(idx, false)
	
	if idx == 0:
		master_vol = vol
	elif idx == 1:
		music_vol = vol
	elif idx == 2:
		sfx_vol = vol
	elif idx == 3:
		voice_vol = vol
