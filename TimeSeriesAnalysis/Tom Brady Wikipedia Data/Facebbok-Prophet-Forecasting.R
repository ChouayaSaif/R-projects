
# Getting Wikipedia Trend Data
install.packages("remotes")
remotes::install_github("petermeissner/wikipediatrend")
library(wikipediatrend)

data <- wp_trend(page = "Tom_Brady",
                 from = "2013-01-01",
                 to = "2015-12-31")

# wp_cache_reset() : to empty cache before re-loading other data with different range

# Plot
install.packages("ggplot2")
library(ggplot2)
qplot(date, views, data = data)
summary(data)


# Handling missing data
data$views[data$views == 0] <- NA  # Convert zeros to NA
ds <- data$date # ds: datastamp
y <- log(data$views) # log transformation
y
df <- data.frame(ds,y)
df
qplot(ds, y, data=df)


# Forecasting with Facebook's Prophet
install.packages("prophet")
library(prophet)
m <- prophet(df)
m

# Prediction
future <- make_future_dataframe(m, periods = 365)
tail(future)
forecast <- predict(m, future)
tail(forecast[c('ds', 'yhat','yhat_lower',"yhat_upper")])
exp(8.334196) # taking expo of predicted yhat values to cancel out log effect

# Plot forecast
plot(m, forecast)
prophet_plot_components(m, forecast)