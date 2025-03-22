data <- read.csv('https://raw.githubusercontent.com/bkrai/R-files-from-YouTube/main/binary.csv')
str(data)
tail(data)

hist(data$gre)

# Min-Max Normalization
data$gre <- (data$gre - min(data$gre))/(max(data$gre) - min(data$gre))
data$gpa <- (data$gpa - min(data$gpa))/(max(data$gpa) - min(data$gpa))
data$rank <- (data$rank - min(data$rank))/(max(data$rank)-min(data$rank))

hist(data$gre)

# Data Partition
set.seed(222)
ind <- sample(2, nrow(data), replace = TRUE, prob = c(0.7, 0.3))
training <- data[ind==1,]
testing <- data[ind==2,]

# Neural Networks
library(neuralnet)
set.seed(333)
n <- neuralnet(admit~gre+gpa+rank,
               data = training,
               hidden = 5,
               err.fct = "ce",
               linear.output = FALSE)
plot(n)
