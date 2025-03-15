############################################################
# Classification using Decision Trees                      #
# Machine Learning with R by Brett Lantz                   #
# a simple credit approval model using C5.0 decision trees #
############################################################

install.packages("C50")
install.packages("gmodels")
install.packages("ISLR")
library(ISLR)
library(C50)
library(gmodels)

# 1) Data Exploration and Preparation
data("Credit")  # Load the Credit dataset from ISLR
credit <- Credit
str(Credit)
table()

# Create a binary target variable `default` based on the `Balance` column
# For example, let's assume that individuals with a balance greater than 1000 are likely to default
credit$default <- as.factor(ifelse(credit$Balance > 1000, "yes", "no"))

# Randomly shuffle the dataset
set.seed(12345)
credit_rand <- credit[order(runif(nrow(credit))), ]

# Split the data into training (90%) and test (10%) sets
train_size <- floor(0.9 * nrow(credit_rand))
credit_train <- credit_rand[1:train_size, ]
credit_test <- credit_rand[(train_size + 1):nrow(credit_rand), ]

# Step 2: Train the model
# Exclude the target variable (default) from the training data
credit_model <- C5.0(credit_train[, -which(names(credit_train) == "default")], credit_train$default)

# Step 3: Evaluate the model
credit_pred <- predict(credit_model, credit_test)
CrossTable(credit_test$default, credit_pred,
           prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
           dnn = c('actual default', 'predicted default'))

# Step 4: Improve model performance using boosting
credit_boost <- C5.0(credit_train[, -which(names(credit_train) == "default")], credit_train$default, trials = 10)
credit_boost_pred <- predict(credit_boost, credit_test)
CrossTable(credit_test$default, credit_boost_pred,
           prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
           dnn = c('actual default', 'predicted default'))