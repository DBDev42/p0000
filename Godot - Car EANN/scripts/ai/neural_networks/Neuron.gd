extends Node
# Class representing a single artificial neuron of a neural network.


# Signals


# Constants
const _NEURON_SECTION = "neuron"
const _NEURON_TRANSFER_FUNCTION = "transfer_function"
const _NEURON_TRANSFER_FUNCTION_DEFAULT = "activation_hyperbolic_tangent_function"
const _GENOTYPE_WEIGHT_PREFIX = "weight_"


# Variables
var _weights = []
var _transfer_function = _NEURON_TRANSFER_FUNCTION_DEFAULT
var _transfer_function_funcref = null


# Setters and Getters


# Constructors
func _init() :
	Logger.debug("Start func Neuron._init()")
	
	load_settings()
	_transfer_function_funcref = funcref(self, _NEURON_TRANSFER_FUNCTION_DEFAULT)
	
	Logger.debug("End func Neuron._init")


# Process functions


# Other functions
func load_settings() :
	Logger.debug("Start func Neuron.load_settings()")
	
	_transfer_function = Settings.get_setting(_NEURON_SECTION, _NEURON_TRANSFER_FUNCTION)
	if _transfer_function == null :
		Logger.error("Transfer function not found. Loading default transfer function")
		_transfer_function = _NEURON_TRANSFER_FUNCTION_DEFAULT
		Settings.set_setting(_NEURON_SECTION, _NEURON_TRANSFER_FUNCTION, _NEURON_TRANSFER_FUNCTION_DEFAULT)
	
	Logger.debug("End func Neuron.load_settings")

func random(p_inputs_count) :
	Logger.debug("Start func Neuron.initialize(" + str(p_inputs_count) + ")")
	var result = null
	
	# creamos el array que contendrá los pesos de la neurona
	_weights = []
	_weights.append(Utils.random_float()) # este primero es para el bias.
	for i in range(p_inputs_count) :
		_weights.append(Utils.random_float())
	
	result = self
	
	Logger.debug("End func Neuron.initialize return: " + str(result))
	return result

func process(p_inputs) :
	Logger.debug("Start func Neuron.process(" + str(p_inputs) + ")")
	var result = null
	
	if p_inputs.size() == _weights.size() - 1 :
		result = 0
		for i in range(p_inputs.size()) :
			result += p_inputs[i] * _weights[i]
		result += _weights[_weights.size() - 1] # por último se suma el bias
		
		if _transfer_function_funcref != null :
			result = _transfer_function_funcref.call_func(result)
	else :
		Logger.error("Inputs' array size doesn't match weights' array size")
	
	Logger.debug("End func Neuron.process return: " + str(result) + "")
	return result

func activation_logistic_function(p_value) :
	Logger.debug("Start func Neuron.activation_logistic_function(" + str(p_value) + ")")
	var result = null
	
	result = 1.0 / (1.0 + exp(-p_value))
	
	Logger.debug("Start func Neuron.activation_logistic_function(" + str(result) + ")")
	return result

func activation_hyperbolic_tangent_function(p_value) :
	Logger.debug("Start func Neuron.activation_hyperbolic_tangent_function(" + str(p_value) + ")")
	var result = null
	
	result = tanh(p_value)
	
	Logger.debug("Start func Neuron.activation_hyperbolic_tangent_function(" + str(result) + ")")
	return result

func get_genotypes() :
	var result = {}
	for i in range(_weights.size()) :
		var genotype = Factory.build(Factory.GENOTYPE)
		result[genotype.get_id()] = Factory.build(Factory.GENOTYPE).initialize(_GENOTYPE_WEIGHT_PREFIX + str(i), _weights[i], genotype.CONTINOUS_TYPE , null)
	return result