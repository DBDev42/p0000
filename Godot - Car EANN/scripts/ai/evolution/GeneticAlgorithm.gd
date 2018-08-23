extends Node

# Class implementing a modified genetic algorithm

# Default min value of inital population parameters.
const DEF_INIT_PARAM_MIN = -1.0

# Default max value of initial population parameters.
const DEF_INIT_PARAM_MAX = 1.0

# Default probability of a parameter being swapped during crossover.
const DEF_CROSS_SWAP_PROB = 0.6

# Default probability of a parameter being mutated.
const DEF_MUTATUTION_PROB = 0.3

# Default amount by which parameters may be mutated.
const DEF_MUTATION_AMOUNT = 2.0

# Default percent of genotypes in a new population that are mutated.
const DEF_MUTATION_PERC = 1.0

# Method used to initialise the initial population.
var initialise_population = funcref(self, "default_population_initialisation")

# Method used to evaluate (or start the evaluation process of) the current population.
var evaluation = funcref(self, "async_evaluation")

# Method used to calculate the fitness value of each genotype of the current population.
var fitness_calculation_method = funcref(self, "default_fitness_calculation")

# Method used to select genotypes of the current population and create the intermediate population.
var selection = "default_selection_operator"

# Method used to recombine the intermediate population to generate a new population.
var recombination = "default_recombination_operator"

# Method used to mutate the new population.
var mutation = "default_mutation_operator"

# Method used to check whether any termination criterion has been met.
var termination_criterion = null

var current_population = []

# The amount of genotypes in a population.
var population_size setget , get_population_size

func get_population_size() :
	return population_size

# The amount of generations that have already passed.
var generation_count setget , get_generation_count

func get_generation_count() :
	return generation_count

# Whether the current population shall be sorted before calling the termination criterion operator.
var sort_population setget , get_sort_population

func get_sort_population() :
	return sort_population

# Whether the genetic algorithm is currently running.
var running setget , is_running

func is_running() :
	return running

# Event for when the algorithm is eventually terminated.
signal algorithm_terminated
const SIGNAL_ALGORITHM_TERMINATED = "algorithm_terminated"

# Event for when the algorithm has finished fitness calculation. Given parameter is the
# current population sorted by fitness if sorting is enabled (see <see cref="SortPopulation"/>).
signal fitness_calculation_finished
const SIGNAL_FITNESS_CALCULATION_FINISHED = "fitness_calculation_finished"


# Initialises a new genetic algorithm instance, creating a initial population of given size with genotype
# of given parameter count.
# The parameters of the genotypes of the inital population are set to the default float value.
# In order to initialise a population properly, assign a method to <see cref="InitialisePopulation"/>
# and call <see cref="Start"/> to start the genetic algorithm.
func _init(p_genotype_param_count, p_population_size) :
	population_size = p_population_size
	
	# Initialise empty population
	for i in range(population_size) :
		var empty_genotype = []
		empty_genotype.resize(p_genotype_param_count)
		current_population.append(load("res://scripts/ai/evolution/Genotype.gd").new(empty_genotype))
	
	generation_count = 1
	sort_population = true
	running = false

func start() :
	running = true
	initialise_population.call_func(current_population)
	evaluation.call_func(current_population)

func evaluation_finished() :
	# Calculate fitness from evaluation
	fitness_calculation_method.call_func(current_population)
	
	# Fire fitness calculation finished event
	emit_signal(SIGNAL_FITNESS_CALCULATION_FINISHED, current_population)
	
	# Check termination criterion
	if termination_criterion != null && termination_criterion.call_func(current_population) :
		Terminate()
		return
	
	# Apply Selection
	#var intermediate_population = Selection(current_population)
	
	# Apply Recombination
	#var new_population = Recombination(intermediate_population, population_size)
	
	# Apply Mutation
	#Mutation(new_population)
	
	# Set current population to newly generated one and start evaluation again
	#current_population = new_population
	#generation_count += 1
	#Evaluation(current_population)

#
#private void Terminate()
#{
#    Running = false;
#    if (AlgorithmTerminated != null)
#        AlgorithmTerminated(this);
#}
#
# Initialises the population by setting each parameter to a random value in the default range.
func default_population_initialisation(p_population) :
	for p in p_population :
		p.set_random_parameters(DEF_INIT_PARAM_MIN, DEF_INIT_PARAM_MAX)
	pass


func async_evaluation(p_population) :
	pass

# Calculates the fitness of each genotype by the formula: fitness = evaluation / averageEvaluation.
#func default_fitness_calculation(p_population : Genotype[]) -> void :
func default_fitness_calculation(p_population) :
	# First calculate average evaluation of whole population
	var overall_evaluation = 0
	for p in p_population :
		overall_evaluation += p.evaluation
	
	var average_evaluation = overall_evaluation / p_population.size()
	
	# Now assign fitness with formula fitness = evaluation / averageEvaluation
	if average_evaluation > 0 :
		for p in p_population :
			p.fitness = p.evaluation / average_evaluation

#/// <summary>
#/// Only selects the best three genotypes of the current population and copies them to the intermediate population.
#/// </summary>
#/// <param name="currentPopulation">The current population.</param>
#/// <returns>The intermediate population.</returns>
#public static List<Genotype> DefaultSelectionOperator(List<Genotype> currentPopulation)
#{
#    List<Genotype> intermediatePopulation = new List<Genotype>();
#    intermediatePopulation.Add(currentPopulation[0]);
#    intermediatePopulation.Add(currentPopulation[1]);
#    intermediatePopulation.Add(currentPopulation[2]);
#
#    return intermediatePopulation;
#}
#
#/// <summary>
#/// Simply crosses the first with the second genotype of the intermediate population until the new 
#/// population is of desired size.
#/// </summary>
#/// <param name="intermediatePopulation">The intermediate population that was created from the selection process.</param>
#/// <returns>The new population.</returns>
#public static List<Genotype> DefaultRecombinationOperator(List<Genotype> intermediatePopulation, uint newPopulationSize)
#{
#    if (intermediatePopulation.Count < 2) throw new ArgumentException("Intermediate population size must be greater than 2 for this operator.");
#
#    List<Genotype> newPopulation = new List<Genotype>();
#    while (newPopulation.Count < newPopulationSize)
#    {
#        Genotype offspring1, offspring2;
#        CompleteCrossover(intermediatePopulation[0], intermediatePopulation[1], DefCrossSwapProb, out offspring1, out offspring2);
#
#        newPopulation.Add(offspring1);
#        if (newPopulation.Count < newPopulationSize)
#            newPopulation.Add(offspring2);
#    }
#
#    return newPopulation;
#}
#
#/// <summary>
#/// Simply mutates each genotype with the default mutation probability and amount.
#/// </summary>
#/// <param name="newPopulation">The mutated new population.</param>
#public static void DefaultMutationOperator(List<Genotype> newPopulation)
#{
#    foreach (Genotype genotype in newPopulation)
#    {
#        if (randomizer.NextDouble() < DefMutationPerc)
#            MutateGenotype(genotype, DefMutationProb, DefMutationAmount);
#    }
#}
##endregion
#
##region Recombination Operators
#public static void CompleteCrossover(Genotype parent1, Genotype parent2, float swapChance, out Genotype offspring1, out Genotype offspring2)
#{
#    //Initialise new parameter vectors
#    int parameterCount = parent1.ParameterCount;
#    float[] off1Parameters = new float[parameterCount], off2Parameters = new float[parameterCount];
#
#    //Iterate over all parameters randomly swapping
#    for (int i = 0; i < parameterCount; i++)
#    {
#        if (randomizer.Next() < swapChance)
#        {
#            //Swap parameters
#            off1Parameters[i] = parent2[i];
#            off2Parameters[i] = parent1[i];
#        }
#        else
#        {
#            //Don't swap parameters
#            off1Parameters[i] = parent1[i];
#            off2Parameters[i] = parent2[i];
#        }
#    }
#
#    offspring1 = new Genotype(off1Parameters);
#    offspring2 = new Genotype(off2Parameters);
#}
##endregion
#
##region Mutation Operators
#/// <summary>
#/// Mutates the given genotype by adding a random value in range [-mutationAmount, mutationAmount] to each parameter with a probability of mutationProb.
#/// </summary>
#/// <param name="genotype">The genotype to be mutated.</param>
#/// <param name="mutationProb">The probability of a parameter being mutated.</param>
#/// <param name="mutationAmount">A parameter may be mutated by an amount in range [-mutationAmount, mutationAmount].</param>
#public static void MutateGenotype(Genotype genotype, float mutationProb, float mutationAmount)
#{
#    for (int i = 0; i < genotype.ParameterCount; i++)
#    {
#        if (randomizer.NextDouble() < mutationProb)
#        {
#            //Mutate by random amount in range [-mutationAmount, mutationAmoun]
#            genotype[i] += (float)(randomizer.NextDouble() * (mutationAmount * 2) - mutationAmount);
#        }    
#    } 
#}
##endregion
##endregion
##endregion
#
#}