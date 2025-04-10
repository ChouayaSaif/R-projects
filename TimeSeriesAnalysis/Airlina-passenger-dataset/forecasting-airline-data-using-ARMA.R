#############################################
# Time series Forecasting using ARMA model  #
#############################################


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
# --> Time series appears to be non-stationary


# Install and load the 'tseries' package for the ADF test
install.packages("tseries")
library(tseries)
# Perform the ADF test
adf_test <- adf.test(AirPassengers)
print(adf_test)

# Log Transformation
AP <- log(AP)
plot(AP, main = "Monthly Airline Passengers (1949-1960)",
     xlab = "Time", ylab = "Passengers", col = "blue")



# Decomposition of additive time series
decomp <- decompose(AP)
decomp$figure
plot(decomp$figure,
     type = 'b',
     xlab = 'Month',
     ylab = 'Seasonality Index',
     col = 'blue',
     las = 2)
plot(decomp)


# Difference the data
diff_passengers <- diff(AP)
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


install.packages("forecast")
library(forecast)

# ARIMA - Autoregressive Integrated Moving Average
arima_model <- arima(AP, order = c(1, 1, 2))
print(arima_model)
# or find best arime Model
model <- auto.arima(AP)
print(model)
attributes(model)
model$coef


# ACF and PACF plots
acf(model$residuals, main = 'Correlogram')
pacf(model$residuals, main = 'Partial Correlogram' )

# Ljung-Box test 
Box.test(model$residuals, lag=20, type = 'Ljung-Box')
# --> p-value not significant: little chance that autocorrelation at lag 20 is statistically significant


# Residual plot
hist(model$residuals,
     col = 'red',
     xlab = 'Error',
     main = 'Histogram of Residuals',
     freq = FALSE)
lines(density(model$residuals))


# Forecast
f <- forecast(model, 48)
library(ggplot2)
autoplot(f)
accuracy(f)