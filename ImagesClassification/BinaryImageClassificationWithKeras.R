# Load Packages
library(EBImage)
library(keras)
              # class 0: plane, class 1: car
# 12 images : training: 1->5: class 0, 7:11: class 1
              # testing: 6 calss 0, 12 class 1


# To install EBimage package, you can run following 2 lines;
# install.packages("BiocManager") 
# BiocManager::install("EBImage")

# Read images
setwd('/cloud/project/images')
pics <- c('p1.jpg', 'p2.jpg', 'p3.jpg', 'p4.jpg', 'p5.jpg', 'p6.jpg',
          'c1.jpg', 'c2.jpg', 'c3.jpg', 'c4.jpg', 'c5.jpg', 'c6.jpg')
mypic <- list()
for (i in 1:12) {mypic[[i]] <- readImage(pics[i])}


# Explore
print(mypic[[1]])
display(mypic[[8]])
summary(mypic[[1]])
hist(mypic[[2]])
str(mypic)

# Resize to 28*28 : bc pictures comes with diff sizes
for (i in 1:12) {mypic[[i]] <- resize(mypic[[i]], 28, 28)}

# Reshape : convert images to a single dimension: matrix: we will have a single vector of shape 28*28*3
# We need to install numpy: reticulate::py_install("numpy")
for (i in 1:12) {
  mypic[[i]] <- as.vector(mypic[[i]])
}  # -->  we still have 12 diff items in this list, we want to combine it into 1.

# Row Bind : combine the data
trainx <- NULL
for (i in 7:11) {trainx <- rbind(trainx, mypic[[i]])} # trainx accumulates these image data as rows.
str(trainx)
testx <- rbind(mypic[[6]], mypic[[12]])
trainy <- c(0,0,0,0,0,1,1,1,1,1 ) # a binary classification problem, The first 5 images (corresponding to indices 7-11 in mypic) belong to class 0, The last 5 images belong to class 1
testy <- c(0,1) # he image at index 6 in mypic belongs to class 0, while the image at index 12 belongs to class 1.

# install tensorflow
# install.packages("tensorflow")
# tensorflow::install_tensorflow()

library(keras)
# Direct Function from Tensorflow, did not work
# One Hot Encoding
# library(tensorflow)
# trainLabels <- to_categorical(trainy)
# testLabels <- to_categorical(testy)

# we will use manually create a one-hot encoding in R using base R approach.
# Function to perform one-hot encoding in Base R
one_hot_encode <- function(labels, num_classes) {
  one_hot <- matrix(0, nrow = length(labels), ncol = num_classes)
  for (i in seq_along(labels)) {
    one_hot[i, labels[i] + 1] <- 1  # Adjust for 1-based indexing in R
  }
  return(one_hot)
}

# Example usage
trainLabels <- one_hot_encode(trainy, num_classes = length(unique(trainy)))  # Infer num_classes
testLabels <- one_hot_encode(testy, num_classes = 2)  # Explicitly set to 2 classes

# Print results
print(trainLabels)
print(testLabels)

library(tensorflow)
install_tensorflow()

# Model
model <- keras_model_sequential(
  layers = list(
    layer_dense(units = 256, activation = 'relu', input_shape = c(2352)),  # Input layer
    layer_dense(units = 128, activation = 'relu'),  # 1st hidden layer
    layer_dense(units = 2, activation = 'softmax')  # Output layer
  )
)

summary(model)
# Print the model to see the layers and parameters
print(model)

# Inspect each layer in detail
model$layers

use_backend("tensorflow")
install.packages("keras")
keras::install_keras()
library(magrittr)

# Compile
compile(model,
        loss = 'binary_crossentropy',
        optimizer = optimizer_rmsprop(),
        metrics = c('accuracy')
)



# Fit Model
history <- model %>%
  fit(trainx,
      trainLabels,
      epochs = 30,
      batch_size = 32,
      validation_split = 0.2)
plot(history)

# Evaluation & Prediction - train data
model %>% evaluate(trainx,trainLabels)
pred <- model %>% predict_classes(trainx)
table(Predicted = pred, Actual = trainy)
prob <- model %>% predict_proba(trainx)
cbind(prob, Prected = pred, Actual= trainy)

# Evaluation & Prediction - test data
model %>% evaluate(testx,testLabels)
pred <- model %>% predict_classes(testx)
table(Predicted = pred, Actual = testy) # confusion matrix