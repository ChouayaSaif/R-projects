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