############################################################
# Classification using KNN                                 #
# Machine Learning with R by Brett Lantz                   #
# Diagnosing breast cancer with the kNN algorithm          #
############################################################

# 1: Load dataset
wbcd <- read.csv("data.csv", stringsAsFactors = FALSE)

# 2: Explore and prepare dataset

str(wbcd)
# Remove the ID column
wbcd <- wbcd[-1]
table(wbcd$diagnosis)


# Step 3: Convert the diagnosis column to a factor with labels
wbcd$diagnosis <- factor(wbcd$diagnosis, levels = c("B", "M"), labels = c("Benign", "Malignant"))

# Step 4: Normalize the numeric features
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

wbcd_n <- as.data.frame(lapply(wbcd[2:31], normalize))

# Step 5: Split the data into training and test sets
wbcd_train <- wbcd_n[1:469, ]
wbcd_test <- wbcd_n[470:569, ]
wbcd_train_labels <- wbcd[1:469, 1]
wbcd_test_labels <- wbcd[470:569, 1]

# Step 6: Train the kNN model and make predictions
library(class)
wbcd_test_pred <- knn(train = wbcd_train, test = wbcd_test, cl = wbcd_train_labels, k = 21)

# Step 7: Evaluate the model's performance
library(gmodels)
CrossTable(x = wbcd_test_labels, y = wbcd_test_pred, prop.chisq = FALSE)

# Step 8: Improve model performance using z-score standardization
wbcd_z <- as.data.frame(scale(wbcd[-1]))

# Step 9: Split the standardized data into training and test sets
wbcd_train <- wbcd_z[1:469, ]
wbcd_test <- wbcd_z[470:569, ]

# Step 10: Train the kNN model on standardized data and make predictions
wbcd_test_pred <- knn(train = wbcd_train, test = wbcd_test, cl = wbcd_train_labels, k = 21)

# Step 11: Evaluate the improved model's performance
CrossTable(x = wbcd_test_labels, y = wbcd_test_pred, prop.chisq = FALSE)