extends Node2D

@onready var rulebook = $rulebook
@onready var popup = $popup
@onready var close = $popup/close
@onready var timer = $timer
@onready var overlay = $overlay
@export var clocks: Array[Texture2D] = [] 

var time = 1

func _ready():
	rulebook.pressed.connect(_on_rulebook_pressed)
	close.pressed.connect(_on_close_pressed)
	run_timer()
	
func _on_rulebook_pressed():
	popup.hide()
	overlay.hide()
	
func _on_close_pressed():
	popup.show()
	overlay.show()
	
func run_timer():
	while(true):
		if time == 12:
			timer.texture = clocks[0]
			break
			
		await get_tree().create_timer(2.0).timeout
		timer.texture = clocks[time]
		time += 1
		
