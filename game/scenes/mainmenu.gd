extends Node2D

@onready var start = $start
@onready var anim_player = $AnimationPlayer

func _ready():
	start.pressed.connect(_on_start_pressed)
	
func _on_start_pressed():
	anim_player.play("fade") 
	await anim_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/opening.tscn")
