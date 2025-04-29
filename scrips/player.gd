extends CharacterBody3D


var SPEED = 8.0
var run = 8.0
var walk = 3.0
var running = true

const JUMP_VELOCITY = 4.5

var sence_horizontal = 0.3
var sence_vertical = 0.1

@onready var cameramount: Node3D = $cameramount
@onready var animation_player: AnimationPlayer = $visuals/mixamo_base/AnimationPlayer
@onready var visuals: Node3D = $visuals


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x*sence_horizontal))
		visuals.rotate_y(deg_to_rad(event.relative.x*sence_horizontal))
		cameramount.rotate_x(deg_to_rad(-event.relative.y*sence_vertical))



func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("walk"):
		SPEED = walk
		running = false

	else:
		SPEED = run
		running = true
		
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.w
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if running:
			if animation_player.current_animation != "running":
				animation_player.play("running")
		else: 
			if animation_player.current_animation != "walking":
				animation_player.play("walking")
			
		visuals.look_at(position + direction)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if animation_player.current_animation != "idle":
			animation_player.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
