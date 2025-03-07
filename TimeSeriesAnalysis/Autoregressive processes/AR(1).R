# Load necessary library
library(forecast)

# Set seed for reproducibility
set.seed(123)

# Parameters
n <- 100  # Number of observations
phi <- 0.9  # AR(1) coefficient
sigma <- 1  # Standard deviation of the white noise

# Generate white noise series
epsilon <- rnorm(n, mean = 0, sd = sigma)

# Initialize the AR(1) series
Y <- numeric(n)

# Generate the AR(1) process
Y[1] <- epsilon[1]  # Initial value
for (t in 2:n) {
  Y[t] <- phi * Y[t-1] + epsilon[t]
}

# Plot the generated AR(1) series
ts.plot(Y, main = "Simulated AR(1) Process", ylab = "Y(t)")

# Optional: Use the arima.sim function for a more concise approach
ar1_process <- arima.sim(model = list(order = c(1, 0, 0), ar = phi), n = n, sd = sigma)
ts.plot(ar1_process, main = "Simulated AR(1) Process using arima.sim", ylab = "Y(t)")

# Calculate and plot the ACF and PACF
acf(Y, main = "Autocorrelation Function (ACF) of AR(1) Process")
pacf(Y, main = "Partial Autocorrelation Function (PACF) of AR(1) Process")