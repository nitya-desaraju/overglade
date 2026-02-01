extends Node2D

@onready var rulebook = $rulebook
@onready var timer = $clock
@onready var clock_hand = $clockHand
@onready var overlay = $overlay
@export var clock_hands: Array[Texture2D] = [] 
@export var char_textures: Array[Texture2D] = []
@export var suitcases: Array[Texture2D] = []
@onready var human = $human
@onready var passport = $passport
@onready var passport_popup = $overlay/passportPopup
@onready var rulebook_popup = $overlay/rulebookPopup
@onready var good = $overlay/passportPopup/good
@onready var bad = $overlay/passportPopup/bad
@onready var effects = $effects
@onready var end_popup = $overlay/endPopup
@onready var right_score = $overlay/endPopup/rightScore
@onready var wrong_score = $overlay/endPopup/wrongScore
@onready var accuracy = $overlay/endPopup/accuracy
@onready var notif = $overlay/endPopup/notif
@onready var next = $overlay/endPopup/next
@onready var baggage = $baggage
@onready var scanner = $scanner
@onready var close = $overlay/close

var scene_correct: int = 0
var scene_incorrect: int = 0
var current_good_count: int = 0
var current_bad_count: int = 0
var is_day_over: bool = false

var good_deeds = ["Saved a kitten", "Donated blood", "Recycled", "Honest person", "Kind to elders", "Baby-talked to dogs", "Murdered a murderer", "Laughed when a baby falls", "Told the boyfriend that the bestfriend is cheating", "Told people there's something in their teeth", "Pretended to be interested in someone else's passion", "Stopped being friends with someone that hurt their friends"]
var bad_deeds = ["Littered", "Stole", "Double parked", "Lied to parents", "Cut in line", "Chewed with their mouth open", "Murderer", "Hypocrite", "Ungrateful", "Baby-talked to babies", "Hated on other generations", "Abbreviated everything", "Ate on a wooden cutting board", "Recorded everything", "Always 'forgot' their wallet", "Stole their friends' coins"]

var time = 1

func _ready():
	rulebook.pressed.connect(_on_rulebook_pressed)
	passport.pressed.connect(_on_passport_pressed)
	$heaven.pressed.connect(func(): _process_decision(true))
	$hell.pressed.connect(func(): _process_decision(false))
	next.pressed.connect(_on_next_day_pressed)
	close.pressed.connect(_on_background_clicked)
	
	baggage.texture = suitcases[randi_range(0,4)]
	
	spawn_new_character()
	run_timer()
	
func _input(event):
	if event is InputEventMouseButton and event.pressed and overlay.visible:
		if not end_popup.visible:
			close_all_popups()
		
func _on_passport_pressed():
	overlay.show()
	passport_popup.show()

func _on_rulebook_pressed():
	overlay.show()
	rulebook_popup.show()
	
func _on_background_clicked():
	if not end_popup.visible:
		close_all_popups()
		
func close_all_popups():
	overlay.hide()
	passport_popup.hide()
	rulebook_popup.hide()
	
func spawn_new_character():
	if is_day_over: return
	human.texture = char_textures.pick_random()
	generate_passport_data()
	human.position = Vector2(-300, 300)
	passport.position = Vector2(-60, 450)
	baggage.position = Vector2(-200, 67)
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(human, "position", Vector2(400, 300), 1.0).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(passport, "position", Vector2(450, 450), 3.0).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(baggage, "position", Vector2(600, 67), 5.0).set_trans(Tween.TRANS_QUAD)
	
func generate_passport_data():
	good.text = ""
	bad.text = ""
	
	current_good_count = randi_range(0, 5)
	current_bad_count = randi_range(0, 5)
	
	while current_good_count == current_bad_count:
		current_bad_count = randi_range(0, 5)
	
	var selected_deeds = []
	var goods_pool = good_deeds.duplicate()
	var bads_pool = bad_deeds.duplicate()
	goods_pool.shuffle()
	bads_pool.shuffle()
	
	for i in range(current_good_count):
		selected_deeds.append("- " + goods_pool[i])
	for i in range(current_bad_count):
		selected_deeds.append("- " + bads_pool[i])
	
	selected_deeds.shuffle()
	
	for i in range(selected_deeds.size()):
		if i < 5:
			good.text += selected_deeds[i] + "\n"
		else:
			bad.text += selected_deeds[i] + "\n"

	
func _process_decision(sent_to_heaven: bool):
	if is_day_over: return
	
	var is_actually_good = current_good_count > current_bad_count
	if (sent_to_heaven == is_actually_good):
		scene_correct += 1
		global.total_correct += 1
		#effects.texture = light_tex
	else:
		scene_incorrect += 1
		global.total_incorrect += 1
		#effects.texture = fire_tex
	
	var tween = create_tween()
	tween.tween_property(human, "position:x", 1200, 0.8)
	tween.tween_property(passport, "position:x", 1200, 0.8)
	tween.tween_property(baggage, "position:x", 1200, 0.8)
	effects.show()
	
	await get_tree().create_timer(1.0).timeout
	effects.hide()
	await get_tree().create_timer(5.0).timeout
	spawn_new_character()
	
func run_timer():
	while(true):
		if time == 12:
			clock_hand.texture = clock_hands[0]
			break
			
		await get_tree().create_timer(10.0).timeout
		clock_hand.texture = clock_hands[time]
		time += 1
	
	show_end_day_summary()

func show_end_day_summary():
	is_day_over = true
	overlay.show()
	end_popup.show()
	
	var total = float(scene_correct + scene_incorrect)
	var percent = int(scene_correct / total * 100.0) if total > 0 else 0.0
	
	if (scene_correct / total * 100.0) if total > 0 else 0.0 >= 50.0 and scene_correct >= 5:
		notif.show()
		
	right_score.text = str(scene_correct)
	wrong_score.text = str(scene_incorrect)
	accuracy.text = str(percent) + "%"

func _on_next_day_pressed():
	var total = float(scene_correct + scene_incorrect)
	var percent = (scene_correct / total * 100.0) if total > 0 else 0.0
	
	if percent >= 50.0 and scene_correct >= 5:
		get_tree().change_scene_to_file("res://scenes/baggage.tscn")
	else:
		get_tree().reload_current_scene()
