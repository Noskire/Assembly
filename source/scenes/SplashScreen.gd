extends Control

func go_to_menu():
	BgMusic.play()
	var err = get_tree().change_scene("res://source/scenes/Menu.tscn")
	if err != OK:
		print("Error in change to menu scene")
