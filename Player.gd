extends CharacterBody3D

@export var speed = 9.0
@export var mouse_sensitivity = 0.002

@onready var camera = $Camera3D
@onready var raycast = $Camera3D/RayCast3D

const noteUi: PackedScene = preload("res://Tscn/Ui/note_ui.tscn")
const combinationLockUi: PackedScene = preload("res://combination_lock.tscn")
const interactUi: PackedScene = preload("res://Tscn/Ui/interact_popup.tscn")
const bartenderUi: PackedScene = preload("res://Tscn/Ui/bartender_ui.tscn")
var noteUiPresent = false
var lockUiPresent = false
var bartenderUiPresent = false
var interactPopupPresent = false
var currentInteractPopup = null
var heldDrink = "None"
var currentLock = null
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
	if not noteUiPresent and not lockUiPresent and not bartenderUiPresent:
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
	var to = from + camera_transform.basis.z * -5 # Cast 5 meters forward
	
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)
	
	var lookingAtInteractable = false
	
	if result:
		var collider = result.collider
		if collider.is_in_group("Note") or collider.is_in_group("Voice") or collider.is_in_group("CodeLock") or collider.is_in_group("Bartender") or collider.is_in_group("Puzzle_Book"):
			lookingAtInteractable = true
			
			# Show interact popup if not already shown and no other UI is open
			if not interactPopupPresent and not noteUiPresent and not lockUiPresent and not bartenderUiPresent:
				showInteractPopup()
			
			# Handle interactions
			if Input.is_action_just_pressed("Interact"):
				if collider.is_in_group("Note") and not noteUiPresent:
					hideInteractPopup()
					var noteText = collider.get_parent().text
					var note_ui_instance = noteUi.instantiate()
					note_ui_instance.text = noteText
					add_child(note_ui_instance)
					# Connect the signal to reset mouse when note is closed
					note_ui_instance.note_closed.connect(resetMouse)
					noteUiPresent = true
					Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				elif collider.is_in_group("Voice"):
					if heldDrink == "Wine" and collider.get_parent().drinkName == "Wine":
						collider.get_parent().playVoice()
					elif heldDrink == "Martini" and collider.get_parent().drinkName == "Martini":
						collider.get_parent().playVoice()
					elif heldDrink == "Champagne" and collider.get_parent().drinkName == "Champagne":
						collider.get_parent().playVoice()
					else:
						print("Drink")
						collider.get_parent().playDrink()
				elif collider.is_in_group("CodeLock") and not lockUiPresent:
					hideInteractPopup()
					currentLock = collider.get_parent()
					var lock_ui_instance = combinationLockUi.instantiate()
					lock_ui_instance.correct_combination = currentLock.code
					add_child(lock_ui_instance)
					# Connect the signals to handle lock events
					lock_ui_instance.lock_closed.connect(resetMouseFromLock)
					lock_ui_instance.lock_opened.connect(onLockOpened)
					lockUiPresent = true
					Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				elif collider.is_in_group("Bartender") and not bartenderUiPresent:
					if heldDrink == "None":
						hideInteractPopup()
						var bartender_ui_instance = bartenderUi.instantiate()
						add_child(bartender_ui_instance)
						# Connect the signals to handle bartender UI events
						bartender_ui_instance.ui_closed.connect(resetMouseFromBartender)
						bartender_ui_instance.drink_selected.connect(setDrink)
						bartenderUiPresent = true
						Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
					else:
						collider.get_parent().swapVoice()
					collider.get_parent().playVoice()
				elif collider.is_in_group("Puzzle_Book"):
					collider.interact()
	
	# Hide interact popup if not looking at anything interactable
	if not lookingAtInteractable and interactPopupPresent:
		hideInteractPopup()

func showInteractPopup():
	if not interactPopupPresent:
		currentInteractPopup = interactUi.instantiate()
		add_child(currentInteractPopup)
		interactPopupPresent = true

func hideInteractPopup():
	if interactPopupPresent and currentInteractPopup:
		currentInteractPopup.queue_free()
		currentInteractPopup = null
		interactPopupPresent = false
func resetMouse():
	noteUiPresent = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func resetMouseFromLock():
	lockUiPresent = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func onLockOpened():
	lockUiPresent = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Unlock the chest associated with this lock
	if currentLock and currentLock.chest:
		var chest_node = get_node(currentLock.chest)
		if chest_node and chest_node.has_method("unlock"):
			chest_node.unlock()
		# Delete the code lock after unlocking
		currentLock.queue_free()
	currentLock = null
	

func resetMouseFromBartender():
	bartenderUiPresent = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func setDrink(drink_name: String):
	heldDrink = drink_name
	print("Player selected drink: ", heldDrink)
