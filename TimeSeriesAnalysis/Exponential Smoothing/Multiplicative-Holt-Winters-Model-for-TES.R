# Install and load the forecast package
install.packages("forecast")
library(forecast)

# Create a sample time series with trend and seasonality
set.seed(123)
data <- ts(rnorm(120), frequency = 12, start = c(2010, 1))  # 10 years of monthly data

# Fit the multiplicative Holt-Winters model
hw_multiplicative <- HoltWinters(data, seasonal = "multiplicative")

# Print the model summary
print(hw_multiplicative)

# Forecast future values (e.g., 12 months ahead)
forecast_multiplicative <- forecast(hw_multiplicative, h = 12)

# Plot the forecast
plot(forecast_multiplicative, main = "Multiplicative Holt-Winters Forecast")