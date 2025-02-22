install.packages("torch") # for deep learning
install.packages("luz")
install.packages("Rtsne")  # For embedding visualization

library(torch)
library(luz)
library(Rtsne)

# Download and extract MNIST dataset from the URL
download_mnist_data <- function(url, dest_dir = "./data") {
  # Create the directory if it doesn't exist
  if (!dir.exists(dest_dir)) {
    dir.create(dest_dir)
  }
  
  dest_file <- paste0(dest_dir, "/mnist_png.tar.gz")
  download.file(url, dest_file, mode = "wb")
  
  # Extract the tar.gz file
  untar(dest_file, exdir = dest_dir)
  cat("Dataset extracted to", dest_dir, "\n")
}


# Define transformations for the MNIST images
transform_fn <- function(x) {
  x <- torch_tensor(as.array(x), dtype = torch_float()) / 255  # Normalize to [0, 1]
  x <- x$unsqueeze(1)  # Add channel dimension, shape [1, 28, 28]
  
  # Apply augmentations
  if (runif(1) > 0.5) x <- torch_flip(x, dims = 3)  # Random flip
  if (runif(1) > 0.5) x <- x + torch_randn_like(x) * 0.1  # Add noise
  
  return(x)
}

# Load the dataset manually
load_mnist_data <- function() {
  # Download and extract the dataset
  url <- "https://raw.githubusercontent.com/myleott/mnist_png/master/mnist_png.tar.gz"
  download_mnist_data(url)
  
  # Load the images manually (you'll need to specify the correct path)
  # Here we assume that after extraction, images are under "./data/mnist_png/training"
  image_dir <- "./data/mnist_png/training"
  
  # Load images as a list (manually or using an image reading library)
  # For simplicity, we will just use an empty list here for now.
  # You should load actual images and labels from the extracted directory.
  train_images <- list() 
  train_labels <- list()  
  
  return(list(images = train_images, labels = train_labels))
}

# Load dataset and apply  transformations
train_ds <- load_mnist_data()



# DataLoader setup
train_dl <- dataloader(train_ds, batch_size = 128, shuffle = TRUE)

batch <- train_dl$.iter()$.next()
print(dim(batch[[1]]))  # Should be [128, 1, 28, 28]
print(dim(batch[[2]]))

batch <- train_dl$.iter()$.next()
print(batch)
str(batch)

# Encoder Model
encoder <- nn_module(
  initialize = function() {
    # CNN Feature  Extractor
    self$conv <- nn_sequential(
      nn_conv2d(1, 32, kernel_size = 3, stride = 1, padding = 1),
      nn_relu(),
      nn_max_pool2d(kernel_size = 2),
      nn_conv2d(32, 64, kernel_size = 3, stride = 1, padding = 1),
      nn_relu(),
      nn_max_pool2d(kernel_size = 2)
    )
    
    self$fc <- nn_linear(64 * 7 * 7, 128)  # Flattened output
    
    # Projection Head
    self$projector <- nn_sequential(
      nn_linear(128, 64),
      nn_relu(),
      nn_linear(64, 32)
    )
  },
  
  forward = function(x) {
    x <- self$conv(x)
    x <- x$view(c(x$size(1), -1))  # Flatten
    h <- self$fc(x)  # Feature vector
    z <- self$projector(h)  # Projected embedding
    return(z)  # No normalization here
  }
)

# Define contrastive loss function
contrastive_loss <- function(z1, z2, temperature = 0.5) {
  # Normalize embeddings
  z1 <- torch$nn$functional$normalize(z1, p = 2, dim = 1)
  z2 <- torch$nn$functional$normalize(z2, p = 2, dim = 1)
  
  # Compute cosine similarity
  sim_matrix <- torch_mm(z1, z2$t()) / temperature
  
  # Contrastive loss
  loss <- -torch_mean(torch_log_softmax(sim_matrix, dim = -1))
  return(loss)
}

# Define optimizer explicitly using `torch$optim`
optimizer <- torch$optim$Adam(encoder$parameters, lr = 1e-3)

# Set up and train the model using the custom loss function and optimizer
model <- encoder %>%
  setup(
    loss = contrastive_loss, 
    optimizer = optimizer
  ) %>%
  fit(train_dl, epochs = 10)

# Save the trained model
save_model <- function(model, file_path = "mnist_model.pt") {
  torch_save(model, file_path)
  cat("Model saved to", file_path, "\n")
}



# Load the trained model
load_model <- function(file_path = "mnist_model.pt") {
  model <- encoder
  model <- torch_load(file_path)
  return(model)
}

# Save the model after training
save_model(model)



# Function to predict using the trained model
predict_mnist <- function(model, image) {
  # Apply the same transformation to the image as done during training
  image_transformed <- transform_fn(image)
  
  # Pass the image through the encoder
  model_output <- model(image_transformed)
  
  # Get the predicted class (highest score)
  prediction <- torch$argmax(model_output, dim = 1)
  return(prediction)
}

# Example usage
image <- train_ds$images[[1]]  # Replace with actual image from the dataset
prediction <- predict_mnist(model, image)
cat("Predicted class:", prediction$item(), "\n")



# Function to extract embeddings from the encoder
get_embeddings <- function(model, data_loader) {
  embeddings <- list()
  labels <- list()
  
  # Iterate over the data_loader and extract embeddings
  for (batch in data_loader$.iter()) {
    images <- batch[[1]]
    labels_batch <- batch[[2]]
    
    # Get embeddings from the encoder
    emb <- model(images)
    embeddings <- append(embeddings, list(emb))
    labels <- append(labels, list(labels_batch))
  }
  
  embeddings <- torch_cat(embeddings, dim = 1)
  labels <- torch_cat(labels, dim = 1)
  
  return(list(embeddings = embeddings, labels = labels))
}

# Extract embeddings from the trained model
embedding_data <- get_embeddings(model, train_dl)

# Use t-SNE for dimensionality reduction
tsne_result <- Rtsne(embedding_data$embeddings$to_array(), dims = 2)

# Plot the t-SNE result
plot(tsne_result$Y, col = as.factor(embedding_data$labels$item()), pch = 19,
     main = "t-SNE of Learned Embeddings", xlab = "t-SNE1", ylab = "t-SNE2")


