# Install and load the forecast package
install.packages("forecast")
library(forecast)

# Example data: Monthly sales data
sales <- c(200, 210, 220, 230, 240, 250)

# Convert to a time series object
sales_ts <- ts(sales, frequency = 12)

# Apply Simple Exponential Smoothing
ses_model <- ses(sales_ts, alpha = 0.2)

# Print the model summary
print(ses_model)

# Forecast the next 3 months
forecast_ses <- forecast(ses_model, h = 3)
print(forecast_ses)

# Plot the forecast
plot(forecast_ses, main = "Simple Exponential Smoothing Forecast")