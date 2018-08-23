extends Node

# Signals


# Constants

# ES
# Ruta completa al fichero de configuración.
# EN
# Full path of the configuration's file
const _FILE_FULL_PATH = "user://Godot - Car EANN.ini"


# Variables

# ES
# Array bidimensional para almacenar los ajustes de la aplicación
# EN
# Bidimensional array to store the appllication's settings
var _settings = {} setget set_setting, get_setting

# ES
# Función para establecer un ajuste de la aplicación
# p_section -> sección del ajuste
# p_name -> nombre del ajuste
# p_value -> valor del ajuste
# EN
# Function to set an application's setting
# p_section -> setting's section
# p_name -> setting's name
# p_value -> setting's value
func set_setting(p_section, p_name, p_value) :
	if _settings.has(p_section) :
		_settings[p_section][p_name] = p_value
		_save_setting(p_section, p_name, p_value)
	else :
		_settings[p_section] = {}
		set_setting(p_section, p_name, p_value)

# ES
# Función para obtener un ajuste de la aplicación
# p_section -> sección del ajuste
# p_name -> nombre del ajuste
# EN
# Function to get an application's setting
# p_section -> setting's section
# p_name -> setting's name
func get_setting(p_section, p_name) :
	if _settings.has(p_section) :
		if _settings[p_section].has(p_name) :
				return _settings[p_section][p_name]
	return null

var _file

func _init() :
	_file = ConfigFile.new()
	_load_settings()

# ES
# Función para cargar la configuración desde el fichero especificado como parámetro
# EN
# Function to load the configuration from the file passed as parameter
func _load_settings() :
	var file_status = _file.load(_FILE_FULL_PATH)
	if file_status == OK :
		for section in _file.get_sections() :
			_settings[section] = {}
			for name in _file.get_section_keys(section) :
				_settings[section][name] = _file.get_value(section, name)
		_file.save(_FILE_FULL_PATH)
	else :
		_create_settings()

func _create_settings() :
	if _file == null :
		_file = ConfigFile.new()
	for section in _settings.keys() :
		for name in _settings[section].keys() :
			_file.set_value(section, name, _settings[section][name])
	_file.save(_FILE_FULL_PATH)

func _save_setting(p_section, p_name, p_vale) :
	if _file == null :
		_file = ConfigFile.new()
		_file.load(_FILE_FULL_PATH)
	_file.set_value(p_section, p_name, p_vale)
	_file.save(_FILE_FULL_PATH)