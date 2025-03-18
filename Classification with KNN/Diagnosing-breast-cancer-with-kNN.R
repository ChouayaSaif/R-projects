############################################################
# Classification using Decision Trees                      #
# Machine Learning with R by Brett Lantz                   #
# a simple credit approval model using C5.0 decision trees #
############################################################

wbcd <- read.csv("data.csv", stringsAsFactors = FALSE)

str(wbcd)
# Remove the ID column
wbcd <- wbcd[-1]
table(wbcd$diagnosis)

# Step 3: Convert the diagnosis column to a factor with labels
wbcd$diagnosis <- factor(wbcd$diagnosis, levels = c("B", "M"), labels = c("Benign", "Malignant"))

round(prop.table(table(wbcd$diagnosis)) * 100, digits = 1)

# take a look at 3 of the remaining 30 features, which are all numeric
summary(wbcd[c("radius_mean", "area_mean", "smoothness_mean")])

# Step 4 Transformation: Normalize the numeric features
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

wbcd_n <- as.data.frame(lapply(wbcd[2:31], normalize))

# To check if transformation was applied correctly
summary(wbcd_n$area_mean)

# Step 5 Data Preparation: Split the data into training and test sets
wbcd_train <- wbcd_n[1:469, ]
wbcd_test <- wbcd_n[470:569, ]
wbcd_train_labels <- wbcd[1:469, 1]
wbcd_test_labels <- wbcd[470:569, 1]

# Step 6: Train the kNN model and make predictions
install.packages("class")
library(class)
wbcd_test_pred <- knn(train = wbcd_train, test = wbcd_test, cl = wbcd_train_labels, k = 21)

# Step 7: Evaluate the model's performance
library(gmodels)
CrossTable(x = wbcd_test_labels, y = wbcd_test_pred, prop.chisq = FALSE)

# Step 8: Improve model performance 

# Method 1: using z-score standardization
wbcd_z <- as.data.frame(scale(wbcd[-1]))
# confirm that standardization is applied
summary(wbcd_z$area_mean)
# As we had done before, we need to divide the data into training and test sets, then
# classify the test instances using the knn() function. We'll then compare the predicted
# labels to the actual labels using CrossTable():
wbcd_train <- wbcd_z[1:469, ]
wbcd_test <- wbcd_z[470:569, ]
wbcd_train_labels <- wbcd[1:469, 1]
wbcd_test_labels <- wbcd[470:569, 1]
wbcd_test_pred <- knn(train = wbcd_train, test = wbcd_test,
                      cl = wbcd_train_labels, k=21)
CrossTable(x = wbcd_test_labels, y = wbcd_test_pred,
           prop.chisq=FALSE)

# Method 2: Testing alternative values of k
# Define a range of k values to test
k_values <- c(1, 5, 11, 15, 21, 27)


results <- data.frame(
  k = integer(),
  false_negatives = integer(),
  false_positives = integer(),
  percent_incorrect = numeric()
)

# Loop through each k value and evaluate performance
for (k in k_values) {
  # Train the kNN model and make predictions
  wbcd_test_pred <- knn(train = wbcd_train, test = wbcd_test, cl = wbcd_train_labels, k = k)
  
  # Create a confusion matrix
  confusion_matrix <- CrossTable(x = wbcd_test_labels, y = wbcd_test_pred, prop.chisq = FALSE)
  
  # Extract false negatives and false positives
  false_negatives <- confusion_matrix$t[2, 1]  # Actual Malignant, Predicted Benign
  false_positives <- confusion_matrix$t[1, 2]  # Actual Benign, Predicted Malignant
  
  # Calculate the percentage of incorrect classifications
  total_incorrect <- false_negatives + false_positives
  percent_incorrect <- (total_incorrect / length(wbcd_test_labels)) * 100
  
  results <- rbind(results, data.frame(
    k = k,
    false_negatives = false_negatives,
    false_positives = false_positives,
    percent_incorrect = percent_incorrect
  ))
}

print(results)