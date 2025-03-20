####################################
# Multiple Linear Regression Model #
####################################


vehicle <- read.csv("https://raw.githubusercontent.com/bkrai/Statistical-Modeling-and-Graphs-with-R/main/vehicle.csv", header = TRUE)
head(vehicle)
# Pairwise Scatter Plots: Extracts columns 3 to 5 from the dataset &  Creates a matrix of scatter plots between the selected columns to isualize relationships between numerical variables.
pairs(vehicle[3:5])


# Multiple Linear Regression
model <- lm(lc~Mileage+lh, vehicle)
model
summary(model)
plot(lc~Mileage+lh, vehicle)
abline(model, col = "blue")


# Multiple Linear Regression after removing unsignificant variable
optimal_model <- lm(lc~lh, vehicle)
optimal_model
summary(optimal_model)
plot(lc~lh, vehicle)
abline(optimal_model, col = "blue")


# Reduced VS FULL Model using ANOVA: analysis of variance
full <- lm(lc~Mileage+lh, vehicle)
reduced <- lm(lc~lh, vehicle)
anova(reduced, full)
# --> p-value very large: adding Milleage variable is not contribting to the model


# Model Diagnostics
par(mfrow=c(2,2))
plot(model)
vehicle[1620,]

# Prediction
pred <- predict(model, testing)
predict(model, data.frame(lh=10))