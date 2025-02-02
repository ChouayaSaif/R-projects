# Importing libraries
library(datasets) 
library(caret)

data(dhfr)
sum(is.na(dhfr))


# To achieve reproducible model; set the random seed number
set.seed(100)

# Performs stratified random split of the data set
TrainingIndex <- createDataPartition(dhfr$Y, p=0.8, list = FALSE)
TrainingSet <- dhfr[TrainingIndex,] # Training Set
TestingSet <- dhfr[-TrainingIndex,] # Test Set



###############################
# Build the Model: Random forest


# Run normally without parallel processing
start.time <- proc.time()
start.time  # "capture current system time"
# User time is the time the CPU spends executing the user's code.
# System time is the time the CPU spends executing system (OS) code on behalf of the user's code.
# Elapsed time is the real-world time that has passed since the function was called, including time the program spends waiting for external resources, like disk or network access.
Model <- train(Y ~ ., 
               data = TrainingSet, # Build model using training set
               method = "rf" # Learning algorithm
)
stop.time <- proc.time()
run.time <- stop.time - start.time
print(run.time)



# Use doParallel
# https://topepo.github.io/caret/parallel-processing.html
library(doParallel)

cl <- makePSOCKcluster(5)
registerDoParallel(cl)
# makePSOCKcluster(5): This creates a parallel cluster with 5 worker nodes (or cores). The PSOCK cluster type allows the workers to run on multiple machines if needed.
# registerDoParallel(cl): This registers the cluster to use it in parallel computations with functions that support parallel execution, such as train in this case.

start.time <- proc.time()
Model <- train(Y ~ ., 
               data = TrainingSet, # Build model using training set
               method = "rf" # Learning algorithm
)
stop.time <- proc.time()
run.time <- stop.time - start.time
print(run.time)

stopCluster(cl)
# This shuts down the parallel cluster that was created at the beginning, releasing the resources and stopping the worker nodes.



##########################

# Run without parallel processing and with hyperparameer tuning
# mtry is a hyperparameter for the random forest algorithm that controls the number of variables randomly sampled at each split. A higher value could lead to overfitting, while a lower value could reduce model variance.
#  The train function will train separate models for each value of mtry and select the best one based on model performance.
start.time <- proc.time()
Model <- train(Y ~ ., 
               data = TrainingSet, # Build model using training set
               method = "rf", # Learning algorithm
               tuneGrid = data.frame(mtry = seq(5,15, by=5))
)
stop.time <- proc.time()
run.time <- stop.time - start.time
print(run.time)

# Using doParallel with hyperparamter tuning

library(doParallel)

cl <- makePSOCKcluster(5)
registerDoParallel(cl)

start.time <- proc.time()
Model <- train(Y ~ ., 
               data = TrainingSet, # Build model using training set
               method = "rf", # Learning algorithm
               tuneGrid = data.frame(mtry = seq(5,15, by=5))
)
stop.time <- proc.time()
run.time <- stop.time - start.time
print(run.time)

stopCluster(cl)



##########################
# Apply model for prediction
Model.training <-predict(Model, TrainingSet) # Apply model to make prediction on Training set

# Model performance (Displays confusion matrix and statistics)
Model.training.confusion <-confusionMatrix(Model.training, TrainingSet$Y)

print(Model.training.confusion)

# Feature importance
Importance <- varImp(Model)
plot(Importance, top = 25)
plot(Importance, col = "red")