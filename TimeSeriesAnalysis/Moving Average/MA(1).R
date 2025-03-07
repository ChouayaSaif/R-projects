# Load necessary library
library(forecast)

# Set seed for reproducibility
set.seed(123)

# Parameters
n <- 100  # Number of observations
theta <- -0.9  # MA(1) coefficient
sigma <- 1    # Standard deviation of the white noise

# Generate white noise series
epsilon <- rnorm(n, mean = 0, sd = sigma)

# Initialize the MA(1) series
X <- numeric(n)

# Generate the MA(1) process
for (t in 2:n) {
  X[t] <- epsilon[t] + theta * epsilon[t-1]
}

# Plot the generated MA(1) series
ts.plot(X, main = "Simulated MA(1) Process", ylab = "X(t)")

acf(X, main="ACF of MA(1) process")
pacf(X, main="PACF of MA(1) process")

# Optional: Use the arima.sim function for a more concise approach
ma1_process <- arima.sim(model = list(order = c(0, 0, 1), ma = theta), n = n, mean = mu, sd = sigma)
ts.plot(ma1_process, main = "Simulated MA(1) Process using arima.sim", ylab = "X(t)")