extends Node


# Signals


# Constants
const _FACTORY_SECTION = "factory"
const _FACTORY_AUTONOMOUS_CAR = "autonomous_car"
const _FACTORY_AUTONOMOUS_CAR_DEFAULT = true
const _FACTORY_CAMERA_ZOOM = "camera_zoom"
const _FACTORY_CAMERA_ZOOM_DEFAULT = 0.60

# Variables
var _autonomous_car = _FACTORY_AUTONOMOUS_CAR_DEFAULT
var _camera_zoom = _FACTORY_CAMERA_ZOOM_DEFAULT


# Setters and Getters


# Constructors
func _init() :
	Logger.debug("Start func Factory._init()")
	
	load_settings()
	
	Logger.debug("End fun Factory._init")


# Process functions


# Other functions
func load_settings() :
	Logger.debug("Start func Checkpoint.load_settings()")
	
	_autonomous_car = Settings.get_setting(_FACTORY_SECTION, _FACTORY_AUTONOMOUS_CAR)
	if _autonomous_car == null :
		Logger.error("Autonomous car flag not found. Loading default autonomous car flag")
		_autonomous_car = _FACTORY_AUTONOMOUS_CAR_DEFAULT
		Settings.set_setting(_FACTORY_SECTION, _FACTORY_AUTONOMOUS_CAR, _FACTORY_AUTONOMOUS_CAR_DEFAULT)
	
	_camera_zoom = Settings.get_setting(_FACTORY_SECTION, _FACTORY_CAMERA_ZOOM)
	if _camera_zoom == null :
		Logger.error("Camera zoom not found. Loading default camera zoom")
		_camera_zoom = _FACTORY_CAMERA_ZOOM_DEFAULT
		Settings.set_setting(_FACTORY_SECTION, _FACTORY_CAMERA_ZOOM, _FACTORY_CAMERA_ZOOM_DEFAULT)

func build(p_name) :
	Logger.debug("Start func Factory.get(" + str(p_name) + ")")
	var result = null
	
	var obj = load("res://scenes/" + p_name + ".tscn")
	if obj != null :
		 result = obj.instance()
	else :
		obj = load("res://scripts/" + p_name + ".gd")
		if obj != null :
			result = obj.new()
	
	Logger.debug("Start func Factory.get return: " + str(result))
	return result

func build_car() :
	Logger.debug("Start func Factory.get_car()")
	var result = null
	
	result = load("res://scenes/Car.tscn").instance()
	result.add_child(_build_camera())
	if _autonomous_car :
		# all the logic to generate de ia
		OS.alert("TIENES QUE HACER LA PARTE DE LA IA!")
		pass
	
	Logger.debug("Start func Factory.get_car return: " + str(result))
	return result

func _build_camera() :
	Logger.debug("Start func Factory.build_camera()")
	var result = null
	
	result = Camera2D.new()
	result.set_zoom(Vector2(_camera_zoom, _camera_zoom))
	result._set_current(true)
	
	Logger.debug("Start func Factory.build_camera return: " + str(result))
	return result