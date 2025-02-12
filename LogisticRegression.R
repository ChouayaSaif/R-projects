# Logistic Regression
# Classifying Student application as 
# Admit (0-no,1-yes) : categorical, factor variable
# Predictors: GRE, GPA, RANK


data <- read.csv('https://raw.githubusercontent.com/bkrai/Statistical-Modeling-and-Graphs-with-R/main/binary.csv')
str(data)

# Note: Admit & rank is int, convert it into factor variable.

data$admit <- as.factor(data$admit)
data$rank <- as.factor(data$rank)
str(data)


# 2-way table of variables, create contingency tables, which show the frequency distribution of the variables.
xtabs(~admit + rank, data = data)


# Partition data - train(80%) test(20%)
set.seed(1234)
ind <- sample(2, nrow(data), replace=T, prob = c(0.8,0.2))

train <- data[ind==1,]
test <- data[ind==2,]

# Logistic Regression Model
# glm(): This function fits generalized linear models (GLMs). The glm() function can handle different types of regression models (e.g., linear, logistic, Poisson). In this case, it is used to fit a logistic regression model.
# admit: The dependent variable (the outcome or target). In this case, it's likely a binary variable (e.g., 1 for admitted, 0 for not admitted).
model <- glm(admit ~ gre + gpa + rank, data = train, family = 'binomial')

summary(model)

# p-value of gpa is 99,7%: significant
# gre is not statiscally significant (1-0.14%=86%)
# -->  drop gre
model <- glm(admit ~ gpa + rank, data = train, family = 'binomial')

summary(model)



# Prediction
p1 <- predict(model, train, type = 'response')
head(p1)
head(train)

# result: applicant 1: get 27.7% chance of being admitted: low --> not admitted (admit = 0)


# Misclassification error - train data
pred1 <- ifelse(p1>0.5, 1, 0) # a vectorized conditional function, checks if each element of p1 is greater than 0.5. If it is, the condition evaluates to TRUE  and retuns 1; otherwise, it evaluates to FALSE and returns 0
pred1
tab1 <- table(Pedicted = pred1, Actual = train$admit) # confusion matrix
tab1
# --->Misclassification: 69 applicant who are actually admitted, but model predicts to eb not addmitted

1 - sum(diag(tab1))/sum(tab1) # sum(204+26) correctly classified
# ---> Misclassifiation error = 24.8%

# Misclassification error - test data
p2 <- predict(model, test, type = 'response')
pred2 <- ifelse(p2>0.5, 1, 0)
tab2 <- table(Pedicted = pred2, Actual = test$admit)
tab2
1 - sum(diag(tab2))/sum(tab2)
# ---> Slightly higher: 34.04%



# Goodness-of-fit test
with(model, pchisq(null.deviance -deviance, df.null-df.residual, lower.tail = F))
# we get a p-value = 4.5e-06
# confidence level high: this model is statiscally significant