# Install and load the forecast package
install.packages("forecast")
library(forecast)

# Example data: Monthly sales data with a trend
sales <- c(200, 210, 220, 230, 240, 250)

# Convert to a time series object
sales_ts <- ts(sales, frequency = 12)

# Apply Double Exponential Smoothing (Holt's Linear Trend Method)
holt_model <- holt(sales_ts, alpha = 0.2, beta = 0.1)

# Print the model summary
print(holt_model)

# Forecast the next 3 months
forecast_holt <- forecast(holt_model, h = 3)
print(forecast_holt)

# Plot the forecast
plot(forecast_holt, main = "Double Exponential Smoothing Forecast")