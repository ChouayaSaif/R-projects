# simulating white noise process
ts.data <- rnorm(200)

plot.ts(ts.data, col='blue')

acf(ts.data, main="ACF for White Noise Process")

pacf(ts.data, main="PACF for White Noise Process")