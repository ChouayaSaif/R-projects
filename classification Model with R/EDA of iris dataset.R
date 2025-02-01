# Importing libraries
library(datasets)
# Method 1: using datasets library has iris already in
install.packages("caret")
install.packages("ggplot2")
library(caret) # caret stands Classification and Regression Training. It is a powerful and widely used package for machine learning and statistical modeling

###############################
# Phase 1: loading the data
##############################

# iris dataset
data("iris")
iris <- datasets::iris #access a specific object from a package without loading the entire package.


# Method 2: installing 
library(RCurl)
iris <-read.csv(text=getURL("https://github.com/ChouayaSaif/R-projects/blob/26f2567c48d0c99ad39e1c1664347b501a824511/classification%20Model%20with%20R/iris.csv"))

View(iris)

species <- iris$Species
species

#############################
# Phase 2: Display statistics
#############################
head(iris,4)
tail(iris,5)


summary(iris)
summary(iris$Sepal.Length)

# check if dataset contain missing data (na: (Not Available))?
sum(is.na(iris))

# skimr() : explands no summary()
install.packages("skimr")
library(skimr)
skim(iris) 


# Group data by species and then perform skimr
iris %>%    #  pipe operator (%>%), allows you to chain commands together
  dplyr::group_by(Species) %>%   # The group_by() function from dplyr creates a grouped data frame.
  skim() 



#############################
# Phase 3: Data Visualization
#############################

# Panelplots
plot(iris)
plot(iris, col="red")

# Scatter plots
plot(iris$Sepal.Width, iris$Sepal.Length)

plot(iris$Sepal.Width, iris$Sepal.Length, col="red")

plot(iris$Sepal.Width, iris$Sepal.Length, col="red",
     xlab = "Sepal Width", ylab = "Sepal Length") # x and y labels


# Histogram
hist(iris$Sepal.Width)
hist(iris$Sepal.Width, col="red")


# Feature plots
# a function from the caret package used to create various types of visualizations to understand the relationship between predictor variables (features) and the target variable (response).
# in this case: boxplot
featurePlot(x = iris[,1:4], # predictors
            y = iris$Species, # dependent (response) variable
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
TrainingIndex <- createDataPartition(iris$Species, p=0.8, list = FALSE) # It generates indices for a stratified random split of the data.
TrainingSet <- iris[TrainingIndex,]
TestingSet <- iris[-TrainingIndex,] # The negative indexing (-TrainingIndex) selects the data that was not included in the training set (the remaining 20%).



# Build SVM Model: 
Model <- train(Species ~ ., data = TrainingSet, # It predicts the Species variable using all other variables in the TrainingSet.
               method = "svmPloy", # Specifies that a Support Vector Machine (SVM) model with a polynomial kernel (svmPoly) should be used.
               na.action = na.omit, # Tells the model to remove any rows with missing values in the dataset.
               preProcess = c("scale","center"), # Specifies preprocessing steps. The data will be scaled (standardized) and centered (subtract the mean) before training.
               trControl = trainControl(method='cv', number=10), # Defines the cross-validation method. It performs 10-fold cross-validation (cv), where the data is split into 10 subsets for training and validation.
               yuneGrid = data.frame(degree = 1, scale = 1, C = 1)) # Sets the hyperparameter grid for the SVM model. degree is the degree of the polynomial kernel, scale is the scaling factor, and C is the penalty parameter for misclassification. This grid specifies that all hyperparameters should be set to 1.


# Build Cross-Validation Model (10-fold CV)
Model.cv <- train(Species ~ ., data = TrainingSet,
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
Model.training.confusion <- confusionMatrix(Model.training, TrainingSet$Species)
Model.testing.confusion <- confusionMatrix(Model.testing, TestingSet$Species)
Model.cv.confusion <- confusionMatrix(Model.cv.pred, TestingSet$Species)

# Print Confusion Matrices
print(Model.training.confusion)
print(Model.testing.confusion)
print(Model.cv.confusion)
#Feature importance:

Importance<- varImp(Model)
plot(Importance)
plot(Importance, col="red")


