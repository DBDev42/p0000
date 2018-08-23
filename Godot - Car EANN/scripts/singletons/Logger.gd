extends Node

# Signals


# Constants

# ES
# Ruta completa al fichero de registro.
# EN
# Full path of the log's file.
const _FILE_FULL_PATH = "user://Godot - Car EANN.log"
const ERROR = 3
const WARN = 2
const INFO = 1
const DEBUG = 0
const LEVELS = ["DEBUG", "INFO", "WARN", "ERROR"]
const _SETTINGS_SECTION = "logger"
const _SETTINGS_LEVEL = "level"


# Variables
var _level = WARN setget set_level
func set_level(p_level) :
	debug("Start func Logger.set_level(" + str(p_level) + ")")
	if p_level in [ERROR, WARN, DEBUG, INFO] :
		info("Setting logger level to " + str(LEVELS[p_level]))
		_level = p_level
	else :
		error("Trying to set an invalid level: " + str(p_level) + ". Setting up default level WARN")
		_level = WARN
		Settings.set_setting(_SETTINGS_SECTION, _SETTINGS_LEVEL, WARN)
	debug("End func Logger.set_level")

var _file

var _console_out = true

func _init() :
	_level = INFO
	_file = File.new()
	info("Start logging")
	set_level(Settings.get_setting(_SETTINGS_SECTION, _SETTINGS_LEVEL))

func _write(p_message) :
	var datetime = OS.get_datetime()
	if _file != null :
		_file.open(_FILE_FULL_PATH, File.READ_WRITE)
		_file.seek_end()
		_file.store_line("%04d-%02d-%02d %02d:%02d:%02d - " % [datetime["year"], datetime["month"], datetime["day"], datetime["hour"], datetime["minute"], datetime["second"]] + str(p_message))
		_file.close()
	
	if _console_out :
		print("%04d-%02d-%02d %02d:%02d:%02d - " % [datetime["year"], datetime["month"], datetime["day"], datetime["hour"], datetime["minute"], datetime["second"]] + str(p_message))

func error(p_message) :
	if _level <= ERROR :
		_write("ERROR - " + str(p_message))

func warn(p_message) :
	if _level <= WARN :
		_write("wARN - " + str(p_message))

func debug(p_message) :
	if _level <= DEBUG :
		_write("DEBUG - " + str(p_message))

func info(p_message) :
	if _level <= INFO :
		_write("INFO - " + str(p_message))