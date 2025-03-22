install.packages("forecast")
library(forecast)

data("AirPassengers")
print(AirPassengers)

AP <- AirPassengers
str(AP)
head(AP)
ts(AP, frequency = 12, start=c(1949,1))
attributes(AP)


# Plot the time series
plot(AP, main = "Monthly Airline Passengers (1949-1960)",
     xlab = "Time", ylab = "Passengers", col = "blue")

# Fit the specific SARIMA model
# ARIMA(1, 0, 1)(2, 1, 0)[12]
sarima_model <- Arima(AP, order = c(1, 0, 1), seasonal = c(2, 1, 0))

summary(sarima_model)

forecast_result <- forecast(sarima_model, h = 12)  # h is the number of periods to forecast

plot(forecast_result)