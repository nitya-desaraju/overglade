extends Node2D

@onready var dialogue_label = $UI/dialogueBox/dialogue
@onready var dialogue_box = $UI/dialogueBox
@onready var anim_player = $AnimationPlayer

var lines: Array[String] = [
	"Welcome! If you can't tell, I'm the Grim Reaper. I have hired you to be my assistant!",
	"I will send you souls, and you have to decide whether to send them to heaven or hell based on their life.",
	"If you're good at your job, there will be more details you have to check for...",
	"So, make sure to check your rulebook often for new rules!",
	"Ready for your first day?"
]

var current_line_index: int = 0
var is_typing: bool = false

func _ready():
	dialogue_label.visible_ratio = 0 
	anim_player.play_backwards("fade") 
	await anim_player.animation_finished
	update_dialogue()

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not is_typing:
			advance_dialogue()

func update_dialogue():
	if current_line_index < lines.size():
		display_text(lines[current_line_index])
	else:
		finish_dialogue()

func display_text(text_to_show: String):
	is_typing = true
	dialogue_label.text = text_to_show
	dialogue_label.visible_ratio = 0
	
	var tween = create_tween()
	tween.tween_property(dialogue_label, "visible_ratio", 1.0, 1.0)
	
	await tween.finished
	is_typing = false

func advance_dialogue():
	current_line_index += 1
	update_dialogue()

func finish_dialogue():
	anim_player.play("fade") 
	await anim_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/passport.tscn")
