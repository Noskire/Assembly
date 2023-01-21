extends Control

onready var cont_button: Button = get_node("VBox/Continue")
onready var cc_button: Button = get_node("VBox/ChooseColors")
onready var cc_menu: Control = get_node("ChooseColorsMenu")
onready var op_menu: Control = get_node("OptionsMenu")
onready var ctr_menu: Control = get_node("ControlsMenu")
onready var color_picker: ColorPicker = get_node("ChooseColorsMenu/VBox/ColorPicker")
onready var audio_button: AudioStreamPlayer = get_node("AudioButton")

onready var masterValue: Label = get_node("OptionsMenu/Grid/HBox1/VolValue")
onready var masterSlider: HSlider = get_node("OptionsMenu/Grid/HBox1/VolSlider")
onready var musicValue: Label = get_node("OptionsMenu/Grid/HBox2/VolValue")
onready var musicSlider: HSlider = get_node("OptionsMenu/Grid/HBox2/VolSlider")
onready var sfxValue: Label = get_node("OptionsMenu/Grid/HBox3/VolValue")
onready var sfxSlider: HSlider = get_node("OptionsMenu/Grid/HBox3/VolSlider")
onready var voiceValue: Label = get_node("OptionsMenu/Grid/HBox4/VolValue")
onready var voiceSlider: HSlider = get_node("OptionsMenu/Grid/HBox4/VolSlider")

var idx = 0

func _ready():
	if Parameters.game_continue:
		cont_button.set_disabled(false)
	if Parameters.game_completed:
		cc_button.set_disabled(false)
	color_picker.get_child(4).get_child(4).hide()
	
	var value = Parameters.master_vol
	masterSlider.value = value
	masterValue.text = str(int((25 + value) * 4))
	value = Parameters.music_vol
	musicSlider.value = value
	musicValue.text = str(int((25 + value) * 4))
	value = Parameters.sfx_vol
	sfxSlider.value = value
	sfxValue.text = str(int((25 + value) * 4))
	value = Parameters.voice_vol
	voiceSlider.value = value
	voiceValue.text = str(int((25 + value) * 4))

func _on_master_value_changed(value):
	Parameters.update_vol(0, value)
	masterValue.text = str(int((25 + value) * 4))

func _on_music_value_changed(value):
	Parameters.update_vol(1, value)
	musicValue.text = str(int((25 + value) * 4))

func _on_sfx_value_changed(value):
	Parameters.update_vol(2, value)
	sfxValue.text = str(int((25 + value) * 4))

func _on_voice_value_changed(value):
	Parameters.update_vol(3, value)
	voiceValue.text = str(int((25 + value) * 4))

func _on_Play_button_down():
	audio_button.play()
	yield(get_tree().create_timer(.2), "timeout")
	Parameters.new_game()
	var err = get_tree().change_scene("res://source/scenes/ColorMix.tscn")
	if err != OK:
		print("Error in change to level scene")

func _on_Continue_button_down():
	audio_button.play()
	yield(get_tree().create_timer(.2), "timeout")
	var err = get_tree().change_scene("res://source/scenes/ColorMix.tscn")
	if err != OK:
		print("Error in change to level scene")

func _on_ChooseColors_button_down():
	audio_button.play()
	cc_menu.set_visible(not cc_menu.is_visible())
	op_menu.set_visible(false)
	ctr_menu.set_visible(false)

func _on_Options_button_down():
	audio_button.play()
	cc_menu.set_visible(false)
	op_menu.set_visible(not op_menu.is_visible())
	ctr_menu.set_visible(false)

func _on_Controls_button_down():
	audio_button.play()
	cc_menu.set_visible(false)
	op_menu.set_visible(false)
	ctr_menu.set_visible(not ctr_menu.is_visible())

func _on_OptionButton_item_selected(index):
	idx = index
	color_picker.set_pick_color(Parameters.input_color[idx])

func _on_ColorPicker_color_changed(color):
	Parameters.input_color[idx] = color
