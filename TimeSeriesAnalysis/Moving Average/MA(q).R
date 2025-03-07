# Load necessary library
library(forecast)

# Set seed for reproducibility
set.seed(123)

# Parameters
n <- 100  # Number of observations
q <- 4
theta <- runif(q, -1, 1)  # Randomly generate q MA coefficients between -1 and 1
sigma <- 1    # Standard deviation of the white noise

# Generate white noise series
epsilon <- rnorm(n, mean = 0, sd = sigma)

# Initialize the MA(q) series
X <- numeric(n)

# Generate the MA(q) process
for (t in (q+1):n) {
  X[t] <- epsilon[t] + sum(theta * epsilon[(t-1):(t-q)])
}

# Plot the generated MA(q) series
ts.plot(X, main = paste("Simulated MA(", q, ") Process", sep = ""), ylab = "X(t)")

acf(X, main = paste("ACF for MA(", q, ") Process", sep = ""))
pacf(X, main = paste("PACF for MA(", q, ") Process", sep = ""))

# Optional: Use the arima.sim function for a more concise approach
maq_process <- arima.sim(model = list(order = c(0, 0, q), ma = theta), n = n, mean = mu, sd = sigma)
ts.plot(maq_process, main = paste("Simulated MA(", q, ") Process using arima.sim", sep = ""), ylab = "X(t)")