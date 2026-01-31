extends Node2D

@onready var help = $help
@onready var start = $start
@onready var popup = $popup
@onready var overlay = $overlay
@onready var anim_player = $AnimationPlayer

func _ready():
	help.pressed.connect(_on_help_pressed)
	start.pressed.connect(_on_start_pressed)
	
func _input(event):
	if event is InputEventMouseButton and overlay.visible:
		popup.hide()
		overlay.hide()

func _on_help_pressed():
	popup.show()
	overlay.show()
	
func _on_start_pressed():
	anim_player.play("fade") 
	await anim_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/opening.tscn")
