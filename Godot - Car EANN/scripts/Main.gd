extends Node

# Signals

# Constants
const _APP_SECTION = "app"
const _APP_TRACK = "starting_track"
const _APP_TRACK_DEFAULT = "TrackOval"

# Variables

#var prev_best : CarController
var prev_best

#var prev_second_best : CarController
var prev_second_best

func _ready() :
	Logger.debug("Start func Main._init()")
	
	Logger.info("Starting randomize process")
	randomize()
	
	Logger.info("Loading track")
	var track_name = Settings.get_setting(_APP_SECTION, _APP_TRACK)
	if track_name == null :
		Logger.error("Track not found. Track name: " + str(track_name) + ". Loading default starting track")
		track_name = _APP_TRACK_DEFAULT
		Settings.set_setting(_APP_SECTION, _APP_TRACK, _APP_TRACK_DEFAULT)
	var track = Factory.build(track_name)
	#track.connect(track.SIGNAL_BEST_CAR_CHANGED, self, "on_best_car_changed")
	add_child(track)
	
	Logger.info("Creating cars")
	var car = Factory.build_car()
	car.set_starting_point(track.get_start_position(), track.get_start_rotation())
	car.set_friction(track.get_friction())
	add_child(car)
	
	Logger.info("Setting car for UI info")
	$UI.set_car(car)
	
	#EvolutionManager.start_evolution()
	Logger.debug("End fun Main._init")

#func on_best_car_changed(best_car : CarController) -> void :
func on_best_car_changed(p_best_car) :
	if p_best_car != null :
		$CameraMovement.set_target(p_best_car)
		$CameraMovement/UIController.set_display_target(p_best_car)