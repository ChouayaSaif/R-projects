library(caret)
library(pROC)
library(mlbench)



# Example-2 Regression
data(BostonHousing)
data <- BostonHousing
str(data)

# Data partition
set.seed(1234)
ind <- sample(2, nrow(data), replace = T, prob=c(.7, .3))
training <- data[ind==1, ]
test <- data[ind==2, ]

# K-NN
trControl <- trainControl(method = "repeatedcv", #repeated cross-validation
                          number = 10,  # number of resampling iterations
                          repeats = 3)  # classProbs needed for ROC
set.seed(1234)
fit <- train(medv ~ ., 
             data = training,
             tuneGrid   = expand.grid(k = 1:50),
             method = "knn",
             tuneLength = 10,
             metric = "RMSE",
             trControl = trControl,
             preProc = c("center", "scale"))

# Model performance
fit
plot(fit)
varImp(fit)
pred <- predict(fit, newdata = test )
RMSE(pred, test$medv)