# Importing libraries
library(datasets)
# Method 1: using datasets library has iris already in
install.packages("caret")
install.packages("ggplot2")
library(caret) # caret stands Classification and Regression Training. It is a powerful and widely used package for machine learning and statistical modeling

###############################
# Phase 1: loading the data
##############################

# dhfr dataset
data("dhfr")
dhfr <- datasets::dhfr #access a specific object from a package without loading the entire package.

View(dhfr)


#############################
# Phase 2: Display statistics
#############################
head(dhfr,4)
tail(dhfr,5)


summary(dhfr)
summary(dhfr$Y)
# active inactive 
#  203      122 ---> imbalanced dataset

# check if dataset contain missing data (na: (Not Available))?
sum(is.na(iris))

# skimr() : explands no summary()
install.packages("skimr")
library(skimr)
skim(dhfr) 


# Group data by Y (biological activity)
dhfr %>%    #  pipe operator (%>%), allows you to chain commands together
  dplyr::group_by(Y) %>%   # The group_by() function from dplyr creates a grouped data frame.
  skim() 



#############################
# Phase 3: Data Visualization
#############################

# Panelplots
plot(dhfr)
plot(dhfr, col="red")

# Scatter plots
plot(dhfr$moe2D_zagreb, dhfr$moe2D_weinerPath)

plot(dhfr$moe2D_zagreb, dhfr$moe2D_weinerPath, col="red")

plot(dhfr$moe2D_zagreb, dhfr$moe2D_weinerPath, col=dhfr$Y)  # color by Y


plot(dhfr$moe2D_zagreb, dhfr$moe2D_weinerPath, col="red",
     xlab = "moe2D_zagreb", ylab = "moe2D_weinerPath") # x and y labels


# Histogram
hist(dhfr$moe2D_zagreb)
hist(dhfr$moe2D_zagreb, col="red")


# Feature plots
# a function from the caret package used to create various types of visualizations to understand the relationship between predictor variables (features) and the target variable (response).
# in this case: boxplot
featurePlot(x = dhfr[,2:5], # predictors
            y = dhfr$Y, # dependent (response) variable
            plot = "box",
            strip = strip.custom(par.strip.text=list(cex=.7)),
            scales = list(x=list(relation="free"),
                          y=list(relation="free")))


##############################################################
#Phase 4: Building a Classification Model (CVM model (polynomial kernel function))
##############################################################

# To achieve reproducible model: set a fixed seed number
set.seed(100)

# Perform stratified random split of the data set
TrainingIndex <- createDataPartition(dhfr$Y, p=0.8, list = FALSE) # It generates indices for a stratified random split of the data.
TrainingSet <- dhfr[TrainingIndex,]
TestingSet <- dhfr[-TrainingIndex,] # The negative indexing (-TrainingIndex) selects the data that was not included in the training set (the remaining 20%).



# Build SVM Model: 
Model <- train(Y ~ ., data = TrainingSet, # It predicts the Species variable using all other variables in the TrainingSet.
               method = "svmPoly", # Specifies that a Support Vector Machine (SVM) model with a polynomial kernel (svmPoly) should be used.
               na.action = na.omit, # Tells the model to remove any rows with missing values in the dataset.
               preProcess = c("scale","center"), # Specifies preprocessing steps. The data will be scaled (standardized) and centered (subtract the mean) before training.
               trControl = trainControl(method='cv', number=10), # Defines the cross-validation method. It performs 10-fold cross-validation (cv), where the data is split into 10 subsets for training and validation.
               yuneGrid = data.frame(degree = 1, scale = 1, C = 1)) # Sets the hyperparameter grid for the SVM model. degree is the degree of the polynomial kernel, scale is the scaling factor, and C is the penalty parameter for misclassification. This grid specifies that all hyperparameters should be set to 1.



# Save the Model to  RDS file 
saveRDS(Model, "Model.rds")
# Read the model from  RDS file
Model <- readRDS("Model.rds")



# Build Cross-Validation Model (10-fold CV)
Model.cv <- train(Y ~ ., data = TrainingSet,
                  method = "svmPoly",
                  na.action = na.omit,
                  preProcess = c("scale", "center"),
                  trControl = trainControl(method = "cv", number = 10),  # 10-fold CV
                  tuneGrid = data.frame(degree = 1, scale = 1, C = 1))

# Apply Model for Prediction
Model.training <- predict(Model, TrainingSet)  # Predictions on training set
Model.testing <- predict(Model, TestingSet)    # Predictions on testing set
Model.cv.pred <- predict(Model.cv, TestingSet) # Cross-validation predictions

# Compute Confusion Matrices
Model.training.confusion <- confusionMatrix(Model.training, TrainingSet$Y)
Model.testing.confusion <- confusionMatrix(Model.testing, TestingSet$Y)
Model.cv.confusion <- confusionMatrix(Model.cv.pred, TestingSet$Y)

# Print Confusion Matrices
print(Model.training.confusion)
print(Model.testing.confusion)
print(Model.cv.confusion)

#Feature importance:
# Determines how much each feature (e.g., Sepal.Length, Sepal.Width, etc.) contributes to predicting Species.
Importance<- varImp(Model) # Compute feature importance
plot(Importance, top = 25) # Visualize feature importance


