# simulating random walk process
# cumsum = cumulative sum
ts_data <- cumsum(rnorm(200))
plot.ts(ts_data, col='red', main="Time Series Plot")

# plot acf
acf(ts_data, main="ACF for Random Walk Process")

# plot pacf
pacf(ts_data, main="PACF for Random Walk Process")