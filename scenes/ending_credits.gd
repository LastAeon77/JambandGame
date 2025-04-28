extends Control

@onready var confirm : ConfirmationDialog = $ConfirmationDialog
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")
	$Credits_Song.play()
	confirm.confirmed.connect(_on_confirm_dialog_confirm)
	confirm.canceled.connect(_on_confirm_dialog_cancel)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_confirm_dialog_confirm():
	#print("Confirmed")
	SignalBus.beat_moon = false
	SignalBus.beat_flower = false
	SignalBus.beat_redecorate = false
	SignalBus.save_game()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func _on_confirm_dialog_cancel():
	#print("Cancelled")
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func _on_animated_sprite_2d_animation_finished():
	confirm.popup_centered()
