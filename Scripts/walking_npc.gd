extends CharacterBody3D
class_name WalkingNPC

# Export variables for easy configuration in editor
@export var speed: float = 2.0
@export var path_progress_speed: float = 1.0
@export var loop_path: bool = true
@export var auto_start: bool = true

# REFERENCE TO EXTERNAL PATH - Set this in the Inspector!
@export var path_to_follow: Path3D

# External path references
var path_3d: Path3D
var path_follow_3d: PathFollow3D

# Movement state
var is_moving: bool = false
var current_progress: float = 0.0

func _ready():
	$Man.playWalking()
	path_3d = path_to_follow
	
	path_follow_3d = PathFollow3D.new()
	path_3d.add_child(path_follow_3d)
	if path_3d.curve and path_3d.curve.point_count > 1:
		if auto_start:
			start_movement()

func _physics_process(delta):
	if not is_moving or not path_3d or not path_follow_3d:
		return
	
	current_progress += path_progress_speed * delta
	
	if current_progress >= 1.0:
		if loop_path:
			current_progress = 0.0
		else:
			current_progress = 1.0
			stop_movement()
			return
	
	path_follow_3d.progress_ratio = current_progress
	
	var new_position = path_follow_3d.global_position
	var movement_direction = (new_position - global_position).normalized()
	
	global_position = new_position
	
	if movement_direction.length() > 0.1:
		var target_rotation = atan2(movement_direction.x, movement_direction.z)
		rotation.y = lerp_angle(rotation.y, target_rotation, 3.0 * delta)

func start_movement():
	is_moving = true

func stop_movement():
	is_moving = false
	velocity = Vector3.ZERO
