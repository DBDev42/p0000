extends Node

# Singleton class managing the current track and all cars racing on it, evaluating each individual.

# Sprites for visualising best and second best cars. To be set in editor.
#export(Texture) var best_car_sprite
export(Texture) var best_car_texture = load("res://sprites/best.png")
#export(Texture) var second_best_car_sprite
export(Texture) var second_best_car_texture = load("res://sprites/second_best.png")
#export(Texture) var normal_car_sprite
export(Texture) var normal_car_texture = load("res://sprites/car.png")

#var checkpoints : Checkpoint[]
var checkpoints = []

# Start position for cars
#var start_position : Vector2
var start_position
#var start_rotation : int
var start_rotation

# Class for storing the current cars and their position on the track.
class RaceCar :
	var car
	var checkpoint_index
	
	func _init(p_car = null, p_checkpoint_index = 1) :
		car = p_car
		checkpoint_index = p_checkpoint_index

#var cars : RaceCar[] = []
var cars = []

# The amount of cars currently on the track.
#var car_count : int setget , 
var car_count setget , get_car_count

func get_car_count() :
	return cars.size()

# Best and Second best
# Event for when the best car has changed.
signal best_car_changed(p_best_car)
const SIGNAL_BEST_CAR_CHANGED = "best_car_changed"

#var best_car : CarController = null setget set_best_car, get_best_car
var best_car = null setget set_best_car, get_best_car

func set_best_car(p_best_car) :
	if best_car != p_best_car :
		
		#Update appearance
		if best_car != null :
			best_car.get_node("Sprite").set_texture(normal_car_texture)
		if (p_best_car != null) :
			p_best_car.get_node("Sprite").set_texture(best_car_texture)
		
		var previous_best = best_car
		best_car = p_best_car
		emit_signal("best_car_changed")
		second_best_car = previous_best

func get_best_car() :
	return best_car

#var second_best_car : CarController = null setget set_second_best_car, get_second_best_car
var second_best_car = null setget set_second_best_car, get_second_best_car

func set_second_best_car(p_second_best_car) :
	if second_best_car != p_second_best_car :
		
		#Update appearance
		if second_best_car != null :
			second_best_car.get_node("Sprite").set_texture(normal_car_texture)
		if (p_second_best_car != null) :
			p_second_best_car.get_node("Sprite").set_texture(second_best_car_texture)
		
		second_best_car = p_second_best_car
		emit_signal("second_best_car_changed")

func get_second_best_car() :
	return second_best_car

# Event for when the best car has changed.
signal second_best_car_changed

# The length of the current track in Unity units (accumulated distance between successive checkpoints).
#var track_length : float setget , get_track_length
var track_length setget , get_track_length

func get_track_length() :
	return track_length

func _ready() :
	EvolutionManager.track_manager = self
	
	start_position = $Start.get_position()
	start_rotation = $Start.get_rotation()
	
	calculate_checkpoints_percentage()
	
	set_process(true)

func _process(delta) :
	# Update reward for each enabled car on the track
	for i in range(cars.size()) :
		var race_car = cars[i]
		if best_car == null or race_car.car.get_current_completion_reward() >= best_car.get_current_completion_reward() :
			best_car = race_car.car
		elif second_best_car == null or race_car.car.get_current_completion_reward() >= second_best_car.get_current_completion_reward() :
			second_best_car = race_car.car

#func set_car_amount(p_amount : int) -> void :
func set_car_amount(p_amount) :
	if p_amount > cars.size() :
		var car = load("res://scenes/CarController.tscn")
		for i in range(p_amount - cars.size()) :
			var car_copy = car.instance()
			car_copy.set_position(start_position)
			car_copy.set_rotation(start_rotation)
			cars.append(RaceCar.new(car_copy, 1))
			get_tree().get_root().call_deferred("add_child", car_copy)
	elif p_amount < cars.size() :
		for i in range(cars.size() - p_amount) :
			cars[cars.size() - 1].car.queue_free()
			cars.remove(cars.size() - 1)
	else :
		if p_amount < 0 :
			print("Amount may not be less than zero.")

# Restarts all cars and puts them at the track start.
#func restart() -> void :
func restart() :
	for race_car in cars :
		race_car.car.set_position(start_position)
		race_car.car.set_rotation(start_rotation)
		race_car.car.restart()
		race_car.checkpoint_index = 1
	pass
	
	best_car = null
	second_best_car = null

# Calculates the percentage of the complete track a checkpoint accounts for. This method will
# also refresh the <see cref="TrackLength"/> property.
#func calculate_checkpoints_percentage() -> void :
func calculate_checkpoints_percentage() :
	var previous_point = start_position
	var accumulated_distance = 0
	for t in $Checkpoints.get_children() :
		var checkpoint = t.get_node("Checkpoint")
		var distance = previous_point.distance_to(checkpoint.get_position())
		checkpoint.distance_to_previous = distance
		checkpoint.accumulated_distance = accumulated_distance + distance
		previous_point = checkpoint.get_position()
		accumulated_distance += distance
	
	track_length = accumulated_distance
	
	var previous_reward = 0
	var accumulated_reward = 0
	for t in $Checkpoints.get_children() :
		var checkpoint = t.get_node("Checkpoint")
		var reward = (checkpoint.accumulated_distance / track_length) - accumulated_reward
		checkpoint.reward_value = reward
		checkpoint.accumulated_reward = accumulated_reward + reward
		accumulated_reward += reward
