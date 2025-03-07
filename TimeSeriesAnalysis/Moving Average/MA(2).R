# Load necessary library
library(forecast)

# Set seed for reproducibility
set.seed(123)

# Parameters
n <- 100  # Number of observations
theta1 <- 0.9 # MA(1) coefficient
theta2 <- -0.7  # MA(2) coefficient
sigma <- 1    # Standard deviation of the white noise

# Generate white noise series
epsilon <- rnorm(n, mean = 0, sd = sigma)

# Initialize the MA(2) series
X <- numeric(n)

# Generate the MA(2) process
for (t in 3:n) {
  X[t] <- epsilon[t] + theta1 * epsilon[t-1] + theta2 * epsilon[t-2]
}

# Plot the generated MA(2) series
ts.plot(X, main = "Simulated MA(2) Process", ylab = "X(t)")

acf(X, main="ACF of MA(2) process")
pacf(X, main="PACF of MA(2) process")



# Optional: Use the arima.sim function for a more concise approach
ma2_process <- arima.sim(model = list(order = c(0, 0, 2), ma = c(theta1, theta2)), n = n, mean = mu, sd = sigma)
ts.plot(ma2_process, main = "Simulated MA(2) Process using arima.sim", ylab = "X(t)")