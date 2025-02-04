### Example Data

N <- 5000
set.seed(4114114)

x1 <- rnorm(N) #  a normal distribution
x2 <- rpois(N, 1) + 0.25 * x1 # Generates N random values from a Poisson distribution with a mean (??) of 1
x3 <- runif(N) + 0.8 * x1 -0.6 * x2 # Generates N random numbers from a uniform distribution between 0 and 1

# 
y <- rnorm(N) - 0.6 * x1 -0.3 * x2 + 0.2 * x3
y_true <- y

# Introducing Missing Values in y
# rbinom: enerates N random Bernoulli (0/1) values
# Sets y to NA (missing) only where the generated Bernoulli variable is 1
# Higher-ranked values (larger x1 + x2 + x3) have a higher chance of getting 1.
y[rbinom(N, 1, rank(x1 + x2 + x3) / N) == 1] <- NA

# Generates N random Bernoulli (0/1) values with probability 0.15
x2[rbinom(N, 1, 0.15) == 1] <- NA

# Creates a data frame containing the variables
# y (partially missing)
# x1 (no missing values)
# x2 (randomly missing ~15% of values)
# x3 (no missing values)
# data <- data.frame(y, x1, x2, x3)
data <- data.frame(y, x1, x2, x3)

# This R command removes all objects from the environment except "data" and "y_true"
rm(list= setdiff(ls(), c("data", "y_true")))


library("ggplot2")

data_true = data.frame(data, y_true)
is_na_check <- is.na(data$x1 * y)
# categorize each observation as either "observed" or "Missing" based on whether the corresponding value in the product of data and y is NA or not.
data_true$missings <- c("observed", "Missing")[is_na_check + 1]

ggplot(data_true,
       aes(x = x1,
           y = y_true,
           color = missings)) +
  geom_point() +
  theme(legend.title = element_blank()) +
  ggtitle("Structure of Missing values")

# calculating mean value of y 
mean(data$y, na.rm = TRUE)
# calculating mean value of y_true
mean(y_true)

#######################################
# 3 Methods to deal with missing values
#######################################

### Mehtod 1: Listwise Detetion
data_listwise <- na.omit(data)

mean(data_listwise$y)
mean(y_true)

### Method 2: Single Imputation
library("mice")
# m=1: This tells mice to generate only one imputed dataset (i.e., Single Imputation).
######  Normally, mice performs Multiple Imputation (generating multiple datasets with different imputed values to account for uncertainty).
######  Here, setting m=1 forces it to create only one completed dataset.
data_single <- complete(mice(data, m=1))

mean(data_single$y)
mean(y_true)
# ---> Very close mean values: closer to true mean value

### Method 3: Multiple Imputation

data_multiple <- complete(mice(data, m=5),
                          action = "broad",
                          include = TRUE)

mean_multiple <- c(mean(data_multiple$y.1),
                   mean(data_multiple$y.2),
                   mean(data_multiple$y.3),
                   mean(data_multiple$y.4),
                   mean(data_multiple$y.5))

mean(mean_multiple)
mean(y_true)
