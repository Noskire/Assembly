extends Node

onready var ocarina: AudioStreamPlayer = get_node("Ocarina")
onready var piano: AudioStreamPlayer = get_node("Piano")
onready var bass: AudioStreamPlayer = get_node("Bass")
onready var drum: AudioStreamPlayer = get_node("Drum")

func play():
	ocarina.play()

func _on_Ocarina_finished():
	ocarina.play()
	if Parameters.actual_level >= 1:
		piano.play()
	if Parameters.actual_level >= 2:
		bass.play()
	if Parameters.actual_level >= 3:
		drum.play()
