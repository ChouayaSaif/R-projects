# The optimization process involves testing different values of γ (and other parameters like α and β) to find the combination that results in the lowest forecast error.

# This is typically done using algorithms like grid search or maximum likelihood estimation to systematically evaluate different parameter values.
library(forecast)


sales <- ts(c(200, 210, 220, 230, 240, 250, 260, 270, 280, 290, 300, 310,
              220, 230, 240, 250, 260, 270, 280, 290, 300, 310, 320, 330,
              240, 250, 260, 270, 280, 290, 300, 310, 320, 330, 340, 350),
            frequency = 12, start = c(2020, 1))

# Function to calculate forecast error (e.g., MAE)
calculate_mae <- function(gamma) {
  # Fit Holt-Winters model with a specific gamma value
  hw_model <- HoltWinters(sales, gamma = gamma, seasonal = "additive")
  
  # Generate forecasts
  hw_forecast <- forecast(hw_model, h = 12)
  
  # Calculate Mean Absolute Error (MAE)
  mae <- mean(abs(hw_forecast$fitted - sales))
  return(mae)
}

# Define a range of gamma values to test
gamma_values <- seq(0, 1, by = 0.01)

# Calculate MAE for each gamma value
mae_results <- sapply(gamma_values, calculate_mae)

# Find the gamma value that minimizes MAE
optimal_gamma <- gamma_values[which.min(mae_results)]
cat("Optimal gamma value:", optimal_gamma, "\n")

# Fit the final model with the optimal gamma value
final_model <- HoltWinters(sales, gamma = optimal_gamma, seasonal = "additive")

# Print the final model parameters
print(final_model)

# Forecast the next 12 months
final_forecast <- forecast(final_model, h = 12)

plot(final_forecast)