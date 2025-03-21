data("AirPassengers")
print(AirPassengers)
# Plot the time series
plot(AirPassengers, main = "Monthly Airline Passengers (1949-1960)",
     xlab = "Time", ylab = "Passengers", col = "blue")

str(AirPassengers)


# Install and load the 'tseries' package for the ADF test
install.packages("tseries")
library(tseries)
# Perform the ADF test
adf_test <- adf.test(AirPassengers)
print(adf_test)

# Difference the data
diff_passengers <- diff(AirPassengers)
# Plot the differenced data
plot(diff_passengers, main = "Differenced Airline Passengers",
     xlab = "Time", ylab = "Differenced Passengers", col = "red")
# Perform the ADF test again to confirm stationarity
adf_test_diff <- adf.test(diff_passengers)
print

# Perform the KPSS test
kpss_test_result <- kpss.test(diff_passengers)

# Print the result
print(kpss_test_result)



# Plot ACF
acf(diff_passengers, main = "ACF of Differenced Passengers")

# Plot PACF
pacf(diff_passengers, main = "PACF of Differenced Passengers")


arima_model <- arima(AirPassengers, order = c(1, 1, 2))
print(arima_model)



# Install and load the 'forecast' package
install.packages("forecast")
library(forecast)
# Apply exponential smoothing to the differenced data
ets_model_diff <- ets(diff_passengers)
# View the model summary
print(ets_model_diff)




