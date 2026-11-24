extends RigidBody3D

@export var tilt_sensitivity: float=1.5
@export var deadzone: float=0.1
var is_flipped: bool=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	var accel=Input.get_accelerometer()
	var tilt_x: float=0.0
	
	#Axis inversion when flipping the phone
	if accel.y > 2:
		is_flipped = true
	elif accel.y < -2:
		is_flipped = false
		
	var sensor_x: float=-accel.x if is_flipped else accel.x
	
	if abs(sensor_x) > deadzone:
		
		var adjusted_x:float = sensor_x-(sign(sensor_x)*deadzone)
		var max_range: float = 9.8 - deadzone
		tilt_x = clamp(adjusted_x / max_range, -1.0, 1.0)
	else:
		tilt_x = Input.get_axis("ui_left", "ui_right")
	
	#Gravity's direction	
	var tilt_direction := Vector3(tilt_x * tilt_sensitivity, 0.0, 0.0)
	
	#Applying gravity to the sphere
	apply_central_force(tilt_direction * 9.8 * mass)
	
	
