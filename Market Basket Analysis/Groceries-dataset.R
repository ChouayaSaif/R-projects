# ##########################################################
# Reference Book: Machine Learning with R by Brett Lantz ###
############################################################

install.packages("arules")
install.packages("arulesViz")
library(arules)
library(arulesViz)

data("Groceries")

# Convert the Groceries dataset to a data frame
groceries_df <- as(Groceries, "data.frame")
write.csv(groceries_df, file = "groceries.csv", row.names = FALSE)

# Read the CSV file into a sparse matrix
Groceries <- read.transactions("groceries.csv", format = "basket", sep = ",", cols = 2)

# Inspect the dataset
summary(Groceries)
inspect(Groceries[1:5])

itemFrequency(Groceries[, 1:3])

# Visualizing item support – item frequency plots
itemFrequencyPlot(Groceries, topN = 10)
# itemFrequencyPlot(groceries, support = 0.01)


# Visualizing transaction data – plotting the sparse matrix
image(Groceries[1:10])
image(sample(groceries, 100)) # sampling 100 transactions


# Note: u can convert from/to sparse matrix from/to a dense matrix
dense_matrix <- as(groceries, "matrix")
print(dense_matrix)


# Training a model with the data
# Perform market basket analysis using the Apriori algorithm
# Set minimum support and confidence thresholds
rules <- apriori(Groceries, parameter = list(support = 0.01, confidence = 0.5, minlen = 2))

# Inspect the association rules
summary(rules)
inspect(rules)
inspect(rules[1:3]) # inspect specific rules
 
# Visualize the rules
plot(rules, method = "graph", engine = "htmlwidget")



# Improving Model performance

# Method 1: sort rules according to different criterias
inspect(sort(groceryrules, by = "lift", decreasing = FALSE)[1:5]) # Best 5 rules by lift measure
# Method 2: Taking subsets of association rules
berryrules <- subset(groceryrules, items %in% "berries")
inspect(berryrules)

# To share the results of your market basket analysis,
# Save the association rules to a CSV file or data frame for further analysis
write(rules, file = "association_rules.csv", sep = ",", quote = TRUE, row.names = FALSE)
groceryrules_df <- as(groceryrules, "data.frame") # using as() function to convert rules into a dataframe
str(groceryrules_df)



