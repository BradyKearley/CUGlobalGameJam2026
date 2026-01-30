extends CharacterBody3D

@export var speed = 5.0
@export var mouse_sensitivity = 0.002

@onready var camera = $Camera3D
@onready var raycast = $Camera3D/RayCast3D

const noteUi: PackedScene = preload("res://Tscn/Ui/note_ui.tscn");
var noteUiPresent = false
func _ready():
	# Capture the mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# Handle mouse look
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Rotate player horizontally
		rotate_y(-event.relative.x * mouse_sensitivity)
		# Rotate camera vertically
		if camera:
			camera.rotate_x(-event.relative.y * mouse_sensitivity)
			# Clamp vertical rotation to prevent over-rotation
			camera.rotation.x = clampf(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta):
	# Handle WASD movement
	var input_dir = Vector3.ZERO
	if Input.is_action_pressed("D"): # D key
		input_dir.x += 1
	if Input.is_action_pressed("A"): # A key
		input_dir.x -= 1
	if Input.is_action_pressed("S"): # S key
		input_dir.z += 1
	if Input.is_action_pressed("W"): # W key
		input_dir.z -= 1
	
	# Transform movement relative to player's rotation (where you're looking)
	if input_dir != Vector3.ZERO:
		input_dir = input_dir.normalized()
		# Transform the input direction based on the player's Y rotation
		input_dir = transform.basis * input_dir
		velocity.x = input_dir.x * speed
		velocity.z = input_dir.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
func _process(delta: float) -> void:
	# Cast a ray from the center of the camera view
	var space_state = get_world_3d().direct_space_state
	var camera_transform = camera.global_transform
	var from = camera_transform.origin
	var to = from + camera_transform.basis.z * -100  # Cast 100 units forward
	
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)
	
	if result:
		var collider = result.collider
		if collider.is_in_group("Note") and Input.is_action_just_pressed("Interact") and not noteUiPresent:
			var noteText = collider.get_parent().text
			var note_ui_instance = noteUi.instantiate()
			note_ui_instance.text = noteText
			add_child(note_ui_instance)
			# Connect the signal to reset mouse when note is closed
			note_ui_instance.note_closed.connect(resetMouse)
			noteUiPresent = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if collider.is_in_group("Voice") and Input.is_action_just_pressed("Interact"):
			collider.get_parent().playVoice()
func resetMouse():
	noteUiPresent = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
