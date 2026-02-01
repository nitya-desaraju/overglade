extends Node2D

@onready var start = $start
@onready var label = $start/RichTextLabel
@onready var anim_player = $AnimationPlayer

func _ready():
	anim_player.play_backwards("fade") 
	await anim_player.animation_finished
	start.pressed.connect(_on_start_pressed)
	start.mouse_entered.connect(_on_start_hovered)
	start.mouse_exited.connect(_on_start_unhovered)
	
func _on_start_pressed():
	anim_player.play("fade") 
	await anim_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/opening.tscn")

func _on_start_hovered():
	label.position.y = 52

func _on_start_unhovered():
	label.position.y = 25
