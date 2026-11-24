extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ColorRect/VBoxContainer2.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	var tutorial_scene = preload("res://level.tscn")
	get_tree().change_scene_to_packed(tutorial_scene)
	


func _on_button_2_pressed() -> void:
	$ColorRect/VBoxContainer.hide()
	$ColorRect/VBoxContainer2.show()


func _on_back_pressed() -> void:
	$ColorRect/VBoxContainer2.hide()
	$ColorRect/VBoxContainer.show()
