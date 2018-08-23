extends Area2D


# Signals


# Constants
const _SETTINGS_CHECKPOINT_SECTION = "checkpoint"
const _SETTINGS_CHECKPOINT_REWARD = "reward"
const _SETTINGS_CHECKPOINT_REWARD_DEFAULT = 10


# Variables
var _reward = _SETTINGS_CHECKPOINT_REWARD_DEFAULT

# Setters and Getters


# Constructors
func _init() :
	Logger.debug("Start func Checkpoint._init()")
	
	load_settings()
	
	Logger.debug("End func Checkpoint._init")


# Process functions


# Other functions
func load_settings() :
	Logger.debug("Start func Checkpoint.load_settings()")
	
	_reward = Settings.get_setting(_SETTINGS_CHECKPOINT_SECTION, _SETTINGS_CHECKPOINT_REWARD)
	if _reward == null :
		Logger.error("Reward not found. Reward: " + str(_reward) + ". Setting default reward")
		_reward = _SETTINGS_CHECKPOINT_REWARD_DEFAULT
		Settings.set_setting(_SETTINGS_CHECKPOINT_SECTION, _SETTINGS_CHECKPOINT_REWARD, _SETTINGS_CHECKPOINT_REWARD_DEFAULT)
	
	Logger.debug("End func Checkpoint.load_settings")

func _on_Checkpoint_body_entered(body) :
	Logger.debug("Start func Checkpoint._on_Checkpoint_body_entered(" + str(body) + ")")
	
	body.add_reward(_reward)
	queue_free()
	
	Logger.debug("Start func Checkpoint._on_Checkpoint_body_entered")
