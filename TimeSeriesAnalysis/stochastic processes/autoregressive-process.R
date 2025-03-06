# Simulating autoregressive process of order 1
# Set seed for reproducibility
set.seed(123)

# Define the AR(1) coefficient
phi <- 0.75  # AR(1) coefficient

# Simulate the AR(1) process
ar_process <- arima.sim(n = 200, model = list(ar = phi))

# Plot the time series
plot.ts(ar_process, col = 'blue', main = "Autoregressive Process AR(1)")

# ACF and PACF of AR process
acf(ar_process, main = "ACF of AR(1)")
pacf(ar_process, main = "PACF of AR(1)")