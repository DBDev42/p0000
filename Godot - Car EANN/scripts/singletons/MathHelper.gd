extends Node

# Static class for different Math operations and constants.

#func sigmoid_function(x_value : float) -> float :
func sigmoid_function(x_value) :
	if x_value > 10 :
		return 1.0
	elif x_value < -10 :
		return 0.0;
	else :
		return 1.0 / (1.0 + exp(-x_value))

#func tanh_function(x_value : float) -> float :
func tanh_function(x_value) : 
	if x_value > 10 :
		return 1.0
	elif x_value < -10 :
		return -1.0
	else :
		return tanh(x_value)

# The SoftSign function as proposed by Xavier Glorot and Yoshua Bengio (2010): 
# "Understanding the difficulty of training deep feedforward neural networks".
#func soft_sign_function(x_value : float) -> float :
func soft_sign_function(x_value) :
	return x_value / (1 + abs(x_value))