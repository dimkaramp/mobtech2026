extends Node3D

#Annotation for having these variables stored right before the _ready() is called
@onready var score :int=1000
@onready var level_timer :Timer=$LevelTimer

var lowest_point: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/Control/ColorRect.hide()
	$CanvasLayer/Success.hide()
	$CanvasLayer/Failure.hide()
	lowest_point=calc_lowest_y()-10
	
	$CanvasLayer/Control/UIVBoxContainer/ScoreLabel.text="Score: "+str(score)
	$CanvasLayer/Control/UIVBoxContainer/TimerLabel.text="Timer: "+str($LevelTimer.wait_time)


# Called every frame. '_delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$CanvasLayer/Control/UIVBoxContainer/ScoreLabel.text="Score: "+str(score)
	$CanvasLayer/Control/UIVBoxContainer/TimerLabel.text="Timer: "+str($LevelTimer.time_left).pad_decimals(1)
	
	#Debugging
	var accel: Vector3 = Input.get_accelerometer()
	$CanvasLayer/Control/DebuggingLabel.text = "Accel X: %.2f | Y: %.2f | Z: %.2f" % [accel.x, accel.y, accel.z]
	

	if($RigidBody3D.position.y<lowest_point):
		$CanvasLayer/Failure.show()
		$LevelTimer.stop()
		get_tree().paused=true


func _on_button_pressed() -> void:
	$CanvasLayer/Control/ColorRect.show()
	get_tree().paused=true
	$LevelTimer.paused=true



func _on_resume_button_pressed() -> void:
	$CanvasLayer/Control/ColorRect.hide()
	get_tree().paused=false
	$LevelTimer.paused=false



func _on_quit_button_pressed() -> void:
	get_tree().paused=false
	get_tree().change_scene_to_file("res://main.tscn")
	

#Function that assists in lowest point calculation
func calc_lowest_y() -> float:
	var platforms=get_tree().get_nodes_in_group("Platforms")
	
	var min_y=INF #Infinite
	
	for platform in platforms:
		var current_y=platform.position.y
		if current_y<=min_y:
			min_y=current_y
	
	return min_y


func _on_rigid_body_3d_body_entered(body: Node) -> void:
	if body.is_in_group("Start"):
		$LevelTimer.start()
	
	if body.is_in_group("Finish"):
		$FinishLineTimer.start()
		await $FinishLineTimer.timeout
		
		$CanvasLayer/Control.hide()
		$CanvasLayer/Success.show()
		get_tree().paused=true
		level_timer.stop()
		
	if body.is_in_group("Green_nodes"):
		score+=20
	if body is StaticBody3D and body.is_in_group("Red_nodes"):
		score-=20
	pass # Replace with function body.


func _on_return_to_menu_button_pressed() -> void:
	get_tree().paused=false
	get_tree().change_scene_to_file("res://main.tscn")
	


func _on_level_timer_timeout() -> void:
	$CanvasLayer/Failure.show()
