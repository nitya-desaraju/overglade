extends Node2D

@onready var dialogue_label = $UI/dialogueBox/dialogue
@onready var dialogue_box = $UI/dialogueBox
@onready var anim_player = $AnimationPlayer
@onready var popup = $UI/popup
@onready var overlay = $UI/overlay
@onready var menu = $UI/popup/menu
@onready var label = $UI/popup/RichTextLabel
@onready var right = $UI/popup/right
@onready var wrong = $UI/popup/wrong
@onready var accuracy = $UI/popup/accuracy

var lines: Array[String] = [
	"Good job on your first week as my assistant!",
	"I appreciate all your efforts, but unfortunately, I can't pay you...",
	"So you have to go with the rest of the souls. I'll send to you to heaven as thanks!",
]

var current_line_index: int = 0
var is_typing: bool = false

func _ready():
	menu.pressed.connect(_on_menu_pressed)
	menu.mouse_entered.connect(_on_menu_hovered)
	menu.mouse_exited.connect(_on_menu_unhovered)

	dialogue_label.visible_ratio = 0 

	right.text = str(global.total_correct)
	wrong.text = str(global.total_incorrect)
	accuracy.text = str(int(global.total_correct / (global.total_correct + global.total_incorrect) * 100) if (global.total_correct + global.total_incorrect) > 0 else 0) + "%"
	
	anim_player.play_backwards("fade") 
	await anim_player.animation_finished
	update_dialogue()


func _on_menu_hovered():
	label.position.y = 44

func _on_menu_unhovered():
	label.position.y = 28


func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and popup.visible == false:
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
	dialogue_label.hide()
	popup.show()
	overlay.show()
	
func _on_menu_pressed():
	anim_player.play("fade") 
	await anim_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/mainmenu.tscn")
