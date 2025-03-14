install.packages("arules")
install.packages("arulesViz")
library(arules)
library(arulesViz)

# Load the Groceries dataset
data("Groceries")

# Convert the Groceries dataset to a data frame
groceries_df <- as(Groceries, "data.frame")

# Save the data frame to a CSV file
write.csv(groceries_df, file = "groceries.csv", row.names = FALSE)

# Read the CSV file into a sparse matrix
Groceries <- read.transactions("groceries.csv", format = "basket", sep = ",", cols = 2)


# Inspect the dataset
summary(Groceries)
inspect(Groceries[1:5])

itemFrequency(groceries[, 1:3])


# Convert sparse matrix to a dense matrix
dense_matrix <- as(groceries, "matrix")

# Output the dense matrix
print(dense_matrix)



# Perform market basket analysis using the Apriori algorithm
# Set minimum support and confidence thresholds
rules <- apriori(Groceries, parameter = list(support = 0.01, confidence = 0.5, minlen = 2))

# Inspect the generated rules
summary(rules)
inspect(head(sort(rules, by = "lift"), 10))

# Visualize the rules
plot(rules, method = "graph", engine = "htmlwidget")

# Filter rules for specific items (e.g., whole milk and yogurt)
milk_yogurt_rules <- subset(rules, subset = items %in% c("whole milk", "yogurt"))
inspect(milk_yogurt_rules)

# Save the rules to a CSV file for further analysis
write(rules, file = "association_rules.csv", sep = ",", quote = TRUE, row.names = FALSE)