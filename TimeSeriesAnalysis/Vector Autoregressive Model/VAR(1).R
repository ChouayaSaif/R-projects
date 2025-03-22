install.packages("vars")
install.packages("ggplot2")

library(vars)
library(ggplot2)

# Generate or load a bivariate time series dataset
# Example: Simulate a bivariate VAR(1) process
set.seed(123)
n <- 100
alpha0 <- c(0.1, 0.2)
alpha1 <- matrix(c(0.5, 0.2, 0.3, 0.4), nrow=2, byrow=TRUE)
e <- matrix(rnorm(2 * n), nrow=2)

Y <- matrix(0, nrow=2, ncol=n)
Y[, 1] <- alpha0 + alpha1 %*% c(0, 0) + e[, 1]

for (t in 2:n) {
  Y[, t] <- alpha0 + alpha1 %*% Y[, t-1] + e[, t]
}

# Convert to a data frame for easier handling
ts_data <- data.frame(t(Y))
colnames(ts_data) <- c("Y1", "Y2")

# Plot the data
ggplot(ts_data, aes(x=1:n)) +
  geom_line(aes(y=Y1, color="Y1")) +
  geom_line(aes(y=Y2, color="Y2")) +
  labs(title="Bivariate Time Series Data", x="Time", y="Value", color="Variable") +
  theme_minimal()

# Fit a VAR model
var_model <- VAR(ts_data, p=1, type="const")

summary(var_model)

# Plot impulse response functions (IRF)
# IRF: IRFs show how each variable responds over time to a shock in one of the variables.
# n.ahaed: nb of step to forecast
irf <- irf(var_model, n.ahead=10)
plot(irf)

# Forecast future values
forecast <- predict(var_model, n.ahead=10)
print(forecast)

plot(forecast)
