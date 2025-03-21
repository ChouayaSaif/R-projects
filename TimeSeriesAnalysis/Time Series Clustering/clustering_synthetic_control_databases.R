###########################
# Time series clustering  #
###########################

# Data 
# http://kdd.ics.uci.edu/databases/synthetic_control/synthetic_control.html
data <- read.table(file.choose(), header = F, sep = "")
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