###########################
# Time series clustering  #
###########################

# Data 
# http://kdd.ics.uci.edu/databases/synthetic_control/synthetic_control.html
data <- read.table(file.chogose(), header = F, sep = "")
str(data)
View(data)
plot(data[,60], type = 'l')
j <- c(5, 105, 205, 305, 405, 505)
sample <- t(data[j,])
plot.ts(sample,
        main = "Time-series Plot",
        col = 'blue',
        type = 'b')

# Data preparation
# performing systematic random sampling
n <- 10
s <- sample(1:100, n)
i <- c(s,100+s, 200+s, 300+s, 400+s, 500+s)
d <- data[i,]
str(d)

pattern <- c(rep('Normal', n),
             rep('Cyclic', n),
             rep('Increasing trend', n),
             rep('Decreasing trend', n),
             rep('Upward shift', n),
             rep('Downward shift', n))

# Calculate distances
install.packages("dtw")
library(dtw)
distance <- dist(d, method = "DTW")

# Hierarchical clustering
hc <- hclust(distance, method = 'average')
plot(hc,
     labels = pattern,
     cex = 0.7,
     hang = -1,
     col = 'blue')
rect.hclust(hc, k=4)