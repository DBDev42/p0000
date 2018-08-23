extends Node

# Class representing one member of a population

# The current evaluation of this genotype.
#var evaluation : float
var evaluation

# The current fitness (e.g, the evaluation of this genotype relative 
# to the average evaluation of the whole population) of this genotype.
#var fitness : float
var fitness

# The vector of parameters of this genotype.
#var parameters : float[]
var parameters = []

# The amount of parameters stored in the parameter vector of this genotype.
#var parameter_count : int setget , get_parameter_count
var parameter_count setget , get_parameter_count

func get_parameter_count() :
	if parameters != null :
		return parameters.size()
	return 0

# Methods for convenient parameter access.
func get_parameter(p_index) :
	if parameters != null :
		if p_index >= 0 and p_index < parameter_count :
			return parameters[p_index]
	return null

func set_parameters(p_index, p_parameter) :
	if parameters != null :
		if p_index >= 0 and p_index < parameter_count : 
			parameters[p_index] = p_parameter
			return parameters[p_index]
	return null

# Instance of a new genotype with given parameter vector and initial fitness of 0.
#func _init(parameters : float[]) :
func _init(p_parameters) :
	parameters = p_parameters
	fitness = 0

# Compares this genotype with another genotype depending on their fitness values.
# The result of comparing the two floating point values representing the genotypes fitness in reverse order
# Negative value -> this genotype has less fitness than the other
# 0 value -> this genotype is equal to the other
# Positive value -> this genotyp has more fitness than the other
func comparte_to(p_other) :
	return fitness - p_other.fitness

# Sets the parameters of this genotype to random values in given range.
func set_random_parameters(p_min_value, p_max_value) :
	var diff = p_max_value - p_min_value
	for i in range(parameters.size()) :
		parameters[i] = p_min_value + randf() * diff

# Returns a copy of the parameter vector.
func get_parameters_copy() :
	var copy = []
	for p in parameters :
		copy.append(p)
	return copy

# Saves the parameters of this genotype to a file at given file path.
# This method will override existing files or attempt to create new files, if the file at given file path does not exist.
#public void SaveToFile(string filePath)
#{
#    StringBuilder builder = new StringBuilder();
#    foreach (float param in parameters)
#        builder.Append(param.ToString()).Append(";");
#
#    builder.Remove(builder.Length - 1, 1);
#
#    File.WriteAllText(filePath, builder.ToString());
#}

# Generates a random genotype with parameters in given range.
# return a genotype with random parameter values
func generate_random(p_parameter_count, p_min_value, p_max_value) :
	if p_parameter_count == 0 :
		return new([])
	
	var genotype = new([].resize(p_parameter_count))
	genotype.set_random_parameters(p_min_value, p_max_value)
	return genotype

# Loads a genotype from a file with given file path.
#public static Genotype LoadFromFile(string filePath)
#{
#    string data = File.ReadAllText(filePath);
#
#    List<float> parameters = new List<float>();
#    string[] paramStrings = data.Split(';');
#
#    foreach (string parameter in paramStrings)
#    {
#        float parsed;
#        if (!float.TryParse(parameter, out parsed)) throw new ArgumentException("The file at given file path does not contain a valid genotype serialisation.");
#        parameters.Add(parsed);
#    }
#
#    return new Genotype(parameters.ToArray());
#}