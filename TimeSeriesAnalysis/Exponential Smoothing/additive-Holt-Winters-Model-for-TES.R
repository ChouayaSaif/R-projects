# Install and load the forecast package
install.packages("forecast")
library(forecast)

# Create a sample time series with trend and seasonality
set.seed(123)
data <- ts(rnorm(120), frequency = 12, start = c(2010, 1))  # 10 years of monthly data

# Fit the additive Holt-Winters model
hw_additive <- HoltWinters(data, seasonal = "additive")

# Print the model summary
print(hw_additive)

# Forecast future values (e.g., 12 months ahead)
forecast_additive <- forecast(hw_additive, h = 12)

# Plot the forecast
plot(forecast_additive, main = "Additive Holt-Winters Forecast")