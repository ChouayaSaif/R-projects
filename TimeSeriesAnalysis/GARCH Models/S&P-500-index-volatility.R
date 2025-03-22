install.packages("rugarch")
install.packages("quantmod")
#rugarch: A package for fitting and analyzing GARCH models.
#quantmod: A package for downloading and analyzing financial data.

library(rugarch)
library(quantmod)

# Load financial data (S&P 500 index)
getSymbols("^GSPC", from="2010-01-01", to="2023-01-01")
returns <- na.omit(diff(log(Cl(GSPC))))  # Calculate log returns

# Plot the returns
plot(returns, main="S&P 500 Daily Log Returns", col="blue")

# Define the GARCH(1,1) model:  a standard GARCH model
garch_spec <- ugarchspec(
  variance.model = list(model="sGARCH", garchOrder=c(1,1)),  # GARCH(1,1) model
  mean.model = list(armaOrder=c(0,0)),  # No ARMA component in the mean
  distribution.model = "std"  # the residuals follow a Student's t-distribution,
)

garch_spec

# Fit the GARCH model
garch_fit <- ugarchfit(spec=garch_spec, data=returns)

summary(garch_fit)

# Plot the conditional volatility
plot(garch_fit, which=3)

# Forecast future volatility
garch_forecast <- ugarchforecast(garch_fit, n.ahead=10)
print(garch_forecast)

plot(garch_forecast)