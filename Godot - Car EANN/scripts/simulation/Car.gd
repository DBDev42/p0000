extends KinematicBody2D

# Signals
signal rewarded

# Constants
const _SETTINGS_CAR_SECTION = "car"
const _SETTINGS_CAR_MAX_REWARD_DELAY = "max_reward_delay"
const _SETTINGS_CAR_MAX_REWARD_DELAY_DEFAULT = 5
const _SETTINGS_CAR_ACCELERATION = "acceleration"
const _SETTINGS_CAR_ACCELERATION_DEFAULT = 100
const _SETTINGS_CAR_MAX_SPEED = "max_speed"
const _SETTINGS_CAR_MAX_SPEED_DEFAULT = 100
const _SETTINGS_CAR_TURN_SPEED = "max_turn_speed"
const _SETTINGS_CAR_TURN_SPEED_DEFAULT = PI
const _DIRECTION = Vector2(0,1)
const SIGNAL_REWARDED = "rewarded"

# Variables
var _uuid = ""
var _max_reward_delay = _SETTINGS_CAR_MAX_REWARD_DELAY_DEFAULT
var _acceleration = _SETTINGS_CAR_ACCELERATION_DEFAULT
var _max_speed = _SETTINGS_CAR_MAX_SPEED_DEFAULT
var _turn_speed = _SETTINGS_CAR_TURN_SPEED_DEFAULT
var _time_since_last_reward = 0
var _update_gas_turn = funcref(self, "non_autonomous_input")
var _turn = 0
var _gas = 0
var _speed = 0
var _friction = 0 setget set_friction
var _reward = 0 setget , get_reward

# Setters and Getters
func set_friction(p_friction) :
	Logger.debug("Start func Car.set_friction(" + str(p_friction) + ")")
	
	if p_friction > 0 and p_friction < _acceleration :
		_friction = p_friction
	
	Logger.debug("End func Car.set_friction")

func get_reward() :
	Logger.debug("Start func Car.get_reward()")
	
	Logger.debug("End func Car.get_reward")
	return _reward

# Constructors
func _init() :
	Logger.debug("Start func Car._init()")
	
	_uuid = Utils.uuidv4()
	load_settings()
	set_process(true)
	set_physics_process(true)
	
	Logger.debug("End fun Car._init")

# Process functions
func _process(delta) :
	Logger.debug("Start func Car._process(" + str(delta) + ")")
	
	_time_since_last_reward += delta
	if _time_since_last_reward > _max_reward_delay :
		die()
	
	Logger.debug("End func Car._process")

func _physics_process(delta) :
	Logger.debug("Start func Car._physics_process(" + str(delta) + ")")
	
	_update_gas_turn.call_func()
	
	# se actualiza la velocidad y se impide que baje de 0 o sea mayor que la velocidad máxima
	_speed -= _friction * delta
	_speed += _gas * _acceleration * delta
	_speed = min(max(_speed, 0), _max_speed)
	
	set_rotation(get_rotation() + _turn * _turn_speed * delta)
	var collision = move_and_collide(_DIRECTION.rotated(get_rotation()) * _speed * delta)
	if collision != null :
		check_collision(collision)
	
	Logger.debug("End func Car._physics_process")

# Other functions
func load_settings() :
	Logger.debug("Start func Car.load_settings()")
	
	_max_reward_delay = Settings.get_setting(_SETTINGS_CAR_SECTION, _SETTINGS_CAR_MAX_REWARD_DELAY)
	if _max_reward_delay == null :
		Logger.error("Max reward delay not found. Max checkpoint delay: " + str(_max_reward_delay) + ". Setting reward max checkpoint delay")
		_max_reward_delay = _SETTINGS_CAR_MAX_REWARD_DELAY_DEFAULT
		Settings.set_setting(_SETTINGS_CAR_SECTION, _SETTINGS_CAR_MAX_REWARD_DELAY, _SETTINGS_CAR_MAX_REWARD_DELAY_DEFAULT)
	
	_acceleration = Settings.get_setting(_SETTINGS_CAR_SECTION, _SETTINGS_CAR_ACCELERATION)
	if _acceleration == null :
		Logger.error("Acceleration not found. Acceleration: " + str(_acceleration) + ". Setting default acceleration")
		_acceleration = _SETTINGS_CAR_ACCELERATION_DEFAULT
		Settings.set_setting(_SETTINGS_CAR_SECTION, _SETTINGS_CAR_ACCELERATION, _SETTINGS_CAR_ACCELERATION_DEFAULT)
	
	_max_speed = Settings.get_setting(_SETTINGS_CAR_SECTION, _SETTINGS_CAR_MAX_SPEED)
	if _max_speed == null :
		Logger.error("Max speed not found. Max speed: " + str(_max_speed) + ". Setting default max speed")
		_max_speed = _SETTINGS_CAR_MAX_SPEED_DEFAULT
		Settings.set_setting(_SETTINGS_CAR_SECTION, _SETTINGS_CAR_MAX_SPEED, _SETTINGS_CAR_MAX_SPEED_DEFAULT)
	
	_turn_speed = Settings.get_setting(_SETTINGS_CAR_SECTION, _SETTINGS_CAR_TURN_SPEED)
	if _turn_speed == null :
		Logger.error("Turn speed not found. Turn speed: " + str(_turn_speed) + ". Setting default turn speed")
		_turn_speed = _SETTINGS_CAR_TURN_SPEED_DEFAULT
		Settings.set_setting(_SETTINGS_CAR_SECTION, _SETTINGS_CAR_TURN_SPEED, _SETTINGS_CAR_TURN_SPEED_DEFAULT)
	
	Logger.debug("End func Car.load_settings")

func non_autonomous_input():
	Logger.debug("Start func Car.non_autonomous_input()")
	
	_gas = 0
	if Input.is_action_pressed("ui_up") :
		_gas = 1 # El coche acelera
		pass
	
	if Input.is_action_pressed("ui_down") :
		_gas = -1 # El coche frena
		pass
	
	_turn = 0
	if Input.is_action_pressed("ui_right") :
		_turn = 1 # El coche gira a la derecha
		pass
	
	if Input.is_action_pressed("ui_left") :
		_turn = -1 # El coche gira a la izquierda
		pass
	
	Logger.debug("End func Car.non_autonomous_input")

func set_starting_point(p_position, p_rotation) :
	Logger.debug("Start func Car.set_starting_point(" + str(p_position) + ", " + str(p_rotation) + ")")
	
	set_position(p_position)
	set_rotation(p_rotation)
	
	Logger.debug("End func Car.set_starting_point")

func check_collision(p_collision) :
	Logger.debug("Start func Car.check_collision(" + str(p_collision) + ")")
	
	if p_collision.get_collider().is_in_group("border") :
		die()
	
	Logger.debug("End func Car.check_collision")

func die() :
	Logger.debug("Start func Car.die()")
	
	queue_free()
	
	Logger.debug("End func Car.die")

func add_reward(p_reward) :
	Logger.debug("Start func Car.add_reward(" + str(p_reward) + ")")
	
	_reward += p_reward
	_time_since_last_reward = 0
	emit_signal(SIGNAL_REWARDED)
	
	Logger.debug("End func Car.add_reward")