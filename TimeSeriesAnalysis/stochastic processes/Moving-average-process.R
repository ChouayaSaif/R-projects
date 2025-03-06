
# simulating Moving Average(MA) process
set.seed(123)

# Simulate random time series data (like white noise)
random_data <- rnorm(200)

# Compute a Simple Moving Average (SMA) of order 2
sma_process <- filter(random_data, rep(1/2, 2), sides = 1)

# Remove the NA values caused by the filter function
sma_process <- sma_process[!is.na(sma_process)]

# Plot the time series (original and SMA)
plot.ts(random_data, col = 'blue', main = "Simple Moving Average (SMA) of Order 2")
lines(sma_process, col = 'red', lwd = 2)  # Add SMA to the plot

# ACF and PACF of SMA process
acf(sma_process, main = "ACF of SMA(2)")
pacf(sma_process, main = "PACF of SMA(2)")