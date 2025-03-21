###############################
# Time series classification  #
###############################

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
pattern100 <- c(rep('Normal', 100),
                rep('Cyclic', 100),
                rep('Increasing trend', 100),
                rep('Decreasing trend', 100),
                rep('Upward shift', 100),
                rep('Downward shift', 100))
newdata <- data.frame(data, pattern100)
str(newdata)

# Classification with decision tree
install.packages("party")
library(party)
newdata[] <- lapply(newdata, function(x) if (is.character(x)) as.factor(x) else x)

tree <- ctree(pattern100~., newdata) # ctree: classification tree

# Classification performance
tab <- table(Predicted = predict(tree, newdata), Actual = newdata$pattern100)
sum(diag(tab))/sum(tab) # calculate accuracy of classification
# --> this classification is 95% accurate