extends Node2D

onready var tilemap: TileMap = get_parent().get_node("TileMap")
onready var outline: Polygon2D = get_node("Outline")

enum options {Pipe, Mixer, Spliter}

export var option = options.Pipe

var selected = false
var wait_sec_click = false

func _ready():
	get_node("Sprite").set_frame(option)

func deselect():
	outline.set_color(Color.black)

func _on_input_event(_viewport, event, _shape_idx):
	if (event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT):
		outline.set_color(Color.white)
		get_parent().click_in_option(option)
		get_tree().set_input_as_handled()
