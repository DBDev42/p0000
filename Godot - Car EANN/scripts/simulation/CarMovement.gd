extends Node

# Component for car movement and collision detection
signal hit_wall
const SIGNAL_HIT_WALL = "hit_wall"

# Movement constants
const MAX_VEL = 100.0;
const ACCELERATION = 50.0;
const VEL_FRICT = 2.0;
const TURN_SPEED = PI/4;

#var controller : CarController
var controller

# The current rotation of the car.
#var rotation : float
var rotation = 0

# The current direction of the car.
#var direction : Vector2
var direction = Vector2(0,1)

# The current velocity of the car.
#var velocity : float
var velocity = 0

# Horizontal = engine force, Vertical = turning force
#var horizontal_input : float
var horizontal_input
#var vertical_input : float
var vertical_input

# The current inputs for turning and engine force in this order.
#var current_inputs : float[] setget , get_current_inputs
var current_inputs setget , get_current_inputs

#func get_current_inputs() : float []
func get_current_inputs() :
	return [horizontal_input, vertical_input]

func _init(p_controller) :
	controller = p_controller
	rotation = controller.get_rotation()
	direction = Vector2(0,1).rotated(rotation)
	velocity = 0
	set_process(true)

# Godot method for physics updates
func update(delta) :
	# Get user input if controller tells us to
	if controller != null and controller.use_user_input :
		check_input()
	
	apply_input(delta)
	apply_velocity(delta)
	apply_friction(delta)

# Checks for user input
#func check_input() -> void :
func check_input() :
	horizontal_input = Input.GetAxis("Horizontal")
	vertical_input = Input.GetAxis("Vertical")

# Applies the currently set input
#func apply_input() -> void :
func apply_input(delta) :
	if vertical_input > 1 :
		vertical_input = 1
	elif vertical_input < -1 :
		vertical_input = -1
	
	if horizontal_input > 1 :
		horizontal_input = 1
	elif horizontal_input < -1 :
		horizontal_input = -1
	
	# Car can only accelerate further if velocity is lower than engineForce * MAX_VEL
	var can_accelerate = false
	if vertical_input < 0 :
		can_accelerate = velocity > vertical_input * MAX_VEL
	elif vertical_input > 0 :
		can_accelerate = velocity < vertical_input * MAX_VEL
	
	# Set velocity
	if can_accelerate :
		velocity += vertical_input * ACCELERATION * delta
		# Cap velocity
		if velocity > MAX_VEL :
			velocity = MAX_VEL
		elif velocity < 0 :
			velocity = 0
	
	# Set rotation
	rotation += horizontal_input * TURN_SPEED * delta
	direction = Vector2(0,1).rotated(rotation)

# Sets the engine and turning input according to the given values.
#func set_inputs(inputs : []) -> void :
func set_inputs(p_inputs) :
	horizontal_input = p_inputs[0]
	vertical_input = p_inputs[1]

# Applies the current velocity to the position of the car.
#func apply_velocity() -> void :
func apply_velocity(delta) :
	controller.set_rotation(rotation)
#	controller.set_position(controller.get_position() + controller.direction * velocity * delta)
#	controller.set_position(controller.get_position() + direction * velocity * delta)
	var collision = controller.move_and_collide(direction * velocity * delta)
	if collision != null :
		check_collision(collision)

# Applies some friction to velocity
#func apply_friction(delta : float) -> void :
func apply_friction(delta) :
	if vertical_input == 0 :
		if velocity > 0 :
			velocity -= VEL_FRICT * delta
			if velocity < 0 :
				velocity = 0
		elif velocity < 0 :
			velocity += VEL_FRICT * delta
			if velocity > 0 :
				velocity = 0

func check_collision(collision) :
	if collision.get_collider().is_in_group("border") :
		emit_signal(SIGNAL_HIT_WALL)
	elif collision.get_collider().is_in_group("checkpoint") :
		print("checkpoint")

# Stops all current movement of the car.
#func stop() -> void :
func stop() :
	velocity = 0
