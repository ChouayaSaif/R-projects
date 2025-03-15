install.packages("C50")
install.packages("gmodels")
install.packages("ISLR")
library(ISLR)
library(C50)
library(gmodels)

# Step 1: Load and prepare the data
data("Credit")  # Load the Credit dataset from ISLR
credit <- Credit  # Rename the dataset for consistency

# Convert the target variable to a factor (if necessary)
credit$default <- as.factor(credit$default)

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