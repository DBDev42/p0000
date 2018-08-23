extends KinematicBody2D

# Class representing a controlling container for a 2D physical simulation
# of a car with 5 front facing sensors, detecting the distance to obstacles.

# Maximum delay in seconds between the collection of two checkpoints until this car dies.
#const MAX_CHECKPOINT_DELAY : float = 7
const MAX_CHECKPOINT_DELAY = 7

# The underlying AI agent of this car.
#var agent : Agent
var agent

#var current_completion_reward : float
var current_completion_reward setget set_current_completion_reward, get_current_completion_reward

#func set_current_completion_reward(value : float) -> void :
func set_current_completion_reward(p_current_completion_reward) :
	agent.genotype.evaluation = p_current_completion_reward

#func get_current_completion_reward() -> float :
func get_current_completion_reward() :
	return agent.genotype.evaluation

# Whether this car is controllable by user input (keyboard).
#var use_user_input : bool = false
var use_user_input =  false

# The movement component of this car.
#var movement : CarMovement
var movement

# The current inputs for controlling the CarMovement component.
#var current_control_inputs : float[]
var current_control_inputs setget ,get_current_control_inputs

func get_current_control_inputs() :
	return self.movement.current_inputs

#var time_since_last_checkpoint : float
var time_since_last_checkpoint = 0

#func awake() -> void :
func _ready() :
	name = "Car (" + str(Utils.next_id()) + ")"
	movement = load("res://scripts/simulation/CarMovement.gd").new(self)
	movement.connect(movement.SIGNAL_HIT_WALL, self, "die")
	set_process(true)
	set_physics_process(true)

# Restarts this car, making it movable again.
#func restart() -> void :
func restart() :
	time_since_last_checkpoint = 0
	
	for sensor in $Sensors.get_children() :
		sensor.show()
	
	agent.reset()
	self.show()

# Godot method for normal update
func _process(delta) :
	time_since_last_checkpoint += delta

func _physics_process(delta):
	# Get control inputs from Agent
	if not use_user_input :
		# Get readings from sensors
		var sensor_output = []
		for s in $Sensors.get_children() :
			sensor_output.append(s.output)
		pass
		
		if agent != null :
			var control_inputs = agent.fnn.process_inputs(sensor_output)
			movement.set_inputs(control_inputs)
			movement.update(delta)
	
	if time_since_last_checkpoint > MAX_CHECKPOINT_DELAY :
		die()

# Makes this car die (making it unmovable and stops the Agent from calculating the controls for the car).
#func die() -> void :
func die() :
	for s in $Sensors.get_children() :
		s.hide()
	
	if movement != null :
		movement.stop()
	
	if agent != null :
		agent.kill()
	
	self.hide()

#func checkpoint_captured() -> void :
func checkpoint_captured() :
	time_since_last_checkpoint = 0
