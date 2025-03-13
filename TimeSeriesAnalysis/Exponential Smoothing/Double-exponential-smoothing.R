install.packages("forecast")
library(forecast)

# Create a sample time series data
google_data <- ts(rnorm(100), start = c(2000, 1), frequency = 12)

# Apply the holt function with specified alpha and beta, and forecast 100 steps
holt_model <- holt(google_data, alpha = 0.9967, beta = 0.0001, h = 100)

# Plot the forecast
plot(holt_model)