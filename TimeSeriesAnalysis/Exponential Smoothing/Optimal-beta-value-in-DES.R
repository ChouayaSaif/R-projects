# Install and load the forecast package
install.packages("forecast")
library(forecast)

# Create a sample time series data (replace this with your actual data)
set.seed(123)
google_data <- ts(rnorm(100), start = c(2000, 1), frequency = 12)

# Check the end date of the time series
end_date <- end(google_data)
print(end_date)  # This will show the end date of the time series

# Split the data into training and test sets
train <- window(google_data, end = c(2007, 12))  # Training set (first 8 years)
test <- window(google_data, start = c(2008, 1))  # Test set (last 2 years)

# Define a range of beta values to test
beta_values <- seq(0.0001, 0.5, by = 0.01)

# Initialize a vector to store RMSE values
rmse_values <- numeric(length(beta_values))

# Loop through beta values and calculate RMSE for each
for (i in seq_along(beta_values)) {
  beta <- beta_values[i]
  
  # Fit the Holt model with fixed alpha and current beta
  holt_model <- holt(train, alpha = 0.9967, beta = beta, h = length(test))
  
  # Calculate RMSE on the test set
  rmse_values[i] <- sqrt(mean((test - holt_model$mean)^2))
}

# Find the beta value that minimizes RMSE
optimal_beta <- beta_values[which.min(rmse_values)]
cat("Optimal beta:", optimal_beta, "\n")

# Plot RMSE vs beta values
plot(beta_values, rmse_values, type = "l", xlab = "Beta", ylab = "RMSE", main = "RMSE vs Beta")
abline(v = optimal_beta, col = "red", lty = 2)