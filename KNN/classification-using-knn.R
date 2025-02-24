library(caret)
library(pROC)
library(mlbench)

# Example 1: Student Application (Classification)
data <- read.csv('https://raw.githubusercontent.com/bkrai/Statistical-Modeling-and-Graphs-with-R/main/binary.csv')

str(data)
data$admit[data$admit == 0] <- 'No'
data$admit[data$admit == 1] <- 'Yes'
data$admit <- factor(data$admit)

# Data partition
set.seed(1234)
ind <- sample(2, nrow(data), replace = T, prob=c(.7, .3))
training <- data[ind==1, ]
test <- data[ind==2, ]

# K-NN Model
trControl <- trainControl(method = "repeatedcv", #repeated cross-validation
                          number = 10,  # number of resampling iterations
                          repeats = 3,  # sets of folds to for repeated cross-validation
                          classProbs = TRUE, # we will use it to use ROC for selecting optimal k
                          summaryFunction = twoClassSummary)  # classProbs needed for ROC
set.seed(1234)
fit <- train(admit ~ ., 
             data = training,
             tuneGrid   = expand.grid(k = 1:50),
             method = "knn",
             tuneLength = 20,
             metric     = "ROC", 
             trControl = trControl,
             preProc = c("center", "scale"))  # Standardize data

# Model performance
fit
plot(fit)
varImp(fit)  # importance of varioable: gpa: most important


# Convert 'test$admit' to a factor with the appropriate levels
test$admit <- factor(test$admit, levels = c("No", "Yes"))


pred <- predict(fit, newdata = test )

levels(pred)
levels(test$admit)

confusionMatrix(pred, test$admit, positive = 'Yes' )