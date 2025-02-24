library(caret)
library(pROC)
library(mlbench)

# Example 1: Student Application (Classification)
data <- read.csv('https://raw.githubusercontent.com/bkrai/Statistical-Modeling-and-Graphs-with-R/main/binary.csv')

str(data)
data$admit[data$admit == 0] <- 'No'
data$admit[data$admit == 1] <- 'Yes'
