extends Node

# Constants
const _SETTINGS_TRACK_SECTION = "track"
const _SETTINGS_TRACK_FRICTION = "friction"
const _SETTINGS_TRACK_FRICTION_DEFAULT = 40

# Variables
var _friction = _SETTINGS_TRACK_FRICTION_DEFAULT setget , get_friction
func get_friction() :
	return _friction

func _init() :
	Logger.debug("Start func Track._init()")
	
	load_settings()
	
	Logger.debug("End fun Track._init")

func load_settings() :
	Logger.debug("Start func Track.load_settings()")
	
	_friction = Settings.get_setting(_SETTINGS_TRACK_SECTION, _SETTINGS_TRACK_FRICTION)
	if _friction == null :
		Logger.error("Friction not found. Friction: " + str(_friction) + ". Setting default friction")
		_friction = _SETTINGS_TRACK_FRICTION_DEFAULT
		Settings.set_setting(_SETTINGS_TRACK_SECTION, _SETTINGS_TRACK_FRICTION, _SETTINGS_TRACK_FRICTION_DEFAULT)
	
	Logger.debug("End func Track.load_settings")

func get_start_position() :
	Logger.debug("Start func Track.get_start_position()")
	
	return $Start.get_position()
	
	Logger.debug("End func Track.get_start_position")

func get_start_rotation() :
	Logger.debug("Start func Track.get_start_rotation()")
	
	return $Start.get_rotation()
	
	Logger.debug("End func Track.get_start_rotation")