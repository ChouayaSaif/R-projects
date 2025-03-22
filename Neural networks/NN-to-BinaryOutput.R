data <- read.csv('https://raw.githubusercontent.com/bkrai/R-files-from-YouTube/main/binary.csv')
str(data)

# Min-Max Normalization
data$gre <- (data$gre - min(data$gre))/(max(data$gre) - min(data$gre))
data$gpa <- (data$gpa - min(data$gpa))/(max(data$gpa) - min(data$gpa))
data$rank <- (data$rank - min(data$rank))/(max(data$rank)-min(data$rank))

# Data Partition
set.seed(222)
ind <- sample(2, nrow(data), replace = TRUE, prob = c(0.7, 0.3))
training <- data[ind==1,]
testing <- data[ind==2,]

# Neural Networks with 1 node in the hidden layer 
library(neuralnet)
set.seed(333)
n <- neuralnet(admit~gre+gpa+rank,
               data = training,
               hidden = 1,
               err.fct = "ce",
               linear.output = FALSE)
plot(n)

# Prediction
output <- compute(n, training[,-1])
head(output$net.result)
head(training[1,])

# Node Output Calculations with Sigmoid Activation Function
in4 <- 0.0455 + (0.82344*0.7586206897) + (1.35186*0.8103448276) + (-0.87435*0.6666666667)
out4 <- 1/(1+exp(-in4))
in5 <- -7.06125 +(8.5741*out4)
out5 <- 1/(1+exp(-in5))

# Confusion Matrix & Misclassification Error - training data
output <- compute(n, training[,-1])
p1 <- output$net.result
pred1 <- ifelse(p1>0.5, 1, 0)
tab1 <- table(pred1, training$admit)
tab1
1-sum(diag(tab1))/sum(tab1)

# Confusion Matrix & Misclassification Error - testing data
output <- compute(n, testing[,-1])
p2 <- output$net.result
pred2 <- ifelse(p2>0.5, 1, 0)
tab2 <- table(pred2, testing$admit)
tab2
1-sum(diag(tab2))/sum(tab2)



# NOW a Neural Network with 5 nodes in the hidden layer
library(neuralnet)
set.seed(333)
n5 <- neuralnet(admit~gre+gpa+rank,
               data = training,
               hidden = 5,
               err.fct = "ce",
               linear.output = FALSE,
               lidesign = 'full',
               rep = 5, # run many repititions
               algorithm = 'rprop+', # default algo used
               stepmax = 100000) # default used
#plot(n5)
# first repititions is the best: has less error
plot(n5, rep=1)

output <- compute(n5, training[,-1], rep=1)
p11 <- output$net.result
pred11 <- ifelse(p11>0.5, 1, 0)
tab11 <- table(pred11, training$admit)
tab11
1-sum(diag(tab11))/sum(tab11)


output <- compute(n5, testing[,-1], rep=1)
p22 <- output$net.result
pred22 <- ifelse(p22>0.5, 1, 0)
tab22 <- table(pred22, testing$admit)
tab22
1-sum(diag(tab22))/sum(tab22)


# NOW a Neural Network with 10 nodes in the hidden layer
library(neuralnet)
set.seed(333)
n8 <- neuralnet(admit~gre+gpa+rank,
                data = training,
                hidden = 8,
                err.fct = "ce",
                linear.output = FALSE)
plot(n8)

output <- compute(n8, training[,-1])
p8 <- output$net.result
pred8 <- ifelse(p8>0.5, 1, 0)
tab8 <- table(pred8, training$admit)
tab8
1-sum(diag(tab8))/sum(tab8)


output <- compute(n8, testing[,-1])
p88 <- output$net.result
pred88 <- ifelse(p88>0.5, 1, 0)
tab88 <- table(pred88, testing$admit)
tab88
1-sum(diag(tab88))/sum(tab88)


# Neural Network with 2 hidden layers
n <- neuralnet(admit~gre+gpa+rank,
               data = training,
               hidden = c(2,1),
               err.fct = "ce",
               linear.output = FALSE)
plot(n)

# Confusion Matrix & Misclassification Error - training data
output <- compute(n, training[,-1])
p1 <- output$net.result
pred1 <- ifelse(p1>0.5, 1, 0)
tab1 <- table(pred1, training$admit)
tab1
1-sum(diag(tab1))/sum(tab1)

# Confusion Matrix & Misclassification Error - testing data
output <- compute(n, testing[,-1])
p2 <- output$net.result
pred2 <- ifelse(p2>0.5, 1, 0)
tab2 <- table(pred2, testing$admit)
tab2
1-sum(diag(tab2))/sum(tab2)