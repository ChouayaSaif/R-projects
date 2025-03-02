set.seed(20)
whitenoise = ts(rnorm(273,mean=0.18)) # generates 273 random numbers from a normal distribution
plot(whitenoise, main='white noise') # ts(...): Converts the generated random numbers into a time series object.
abline(h=0.18) #  adds a horizontal line at y = 0.18 to visualize the mean value of the white noise.

data = read.csv("portal_timeseries.csv")
NDVI.ts = ts(data$NDVI, start=c(1992,3), end=c(2014,11), frequency=12)
# frequency=12: Since NDVI is likely measured monthly, this means 12 observations per year.

plot(NDVI.ts, xlab="Year", ylab="greenness", main='NDVI')
abline(h=0.18) # Adds a horizontal reference line at NDVI = 0.18 to visualize the threshold.


lag.plot(NDVI.ts, lags=12, do.line=FALSE)
lag.plot(whitenoise, lags=12, do.line=FALSE)
# A lag plot is a scatter plot where each point represents the relationship between a time series 
# value and its lagged (previous) value. It helps us detect patterns, trends, and autocorrelation in the data.


acf(NDVI.ts)
acf_result <- acf(NDVI.ts, plot = FALSE)
acf(whitenoise)


rain.ts = ts(data$rain, start=c(1992,3), end=c(2014,11), frequency=12)
lag.plot(rain.ts, lags=12, do.lines=FALSE)
acf(rain.ts)

rats.ts = ts(data$rodents, start=c(1992,3), end=c(2014,11), frequency=12)
lag.plot(rats.ts, lags=12, do.lines=FALSE)
acf(rats.ts)