extends CanvasLayer


# Signals


# Constants


# Variables
var _car = null setget set_car


# Setters and Getters
func set_car(p_car) :
	if p_car != null :
		if _car != null :
			disconnect(_car.SIGNAL_REWARDED, self, "reward_update")
		_car = p_car
		_car.connect(_car.SIGNAL_REWARDED, self, "reward_update")
		reward_update()


# Constructors


# Process functions


# Other functions
func reward_update() :
	$Header/Car/Reward/Value.text = str(_car.get_reward())
