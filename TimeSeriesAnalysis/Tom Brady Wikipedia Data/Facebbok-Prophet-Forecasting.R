
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




