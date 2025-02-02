# Importing libraries
library(datasets)
# Method 1: using datasets library has iris already in
install.packages("caret")
install.packages("ggplot2")
library(caret) # caret stands Classification and Regression Training. It is a powerful and widely used package for machine learning and statistical modeling

###############################
# Phase 1: loading the data
###############################

# dhfr dataset
library(RCurl)
dhfr <- read.csv(text=getURL("https://raw.githubusercontent.com/dataprofessor/data/master/dhfr.csv"))

View(dhfr)


########################################################
# Phase 2: Preprocessign data (Handling missing values)
########################################################


# 2. check for missing data
sum(is.na(dhfr))

# 3. if data is clean, randomly introduce NA
na.gen <- function(data, n){
  i <- 1
  while (i<n+1){
    index1 <- sample(1:nrow(data), 1)
    index2 <- sample(2:ncol(data), 1)
    data[index1, index2] <- NA
    i = i+1
  }
  return(data)
}

dhfr <- dhfr[,-1]
dhfr <- na.gen(dhfr,100)


# 4. check again for missing values
sum(is.na(dhfr))
colSums(is.na(dhfr)) #retrieve columns with NA
str(dhfr)


# Lists rows with missing data
#complete.cases() checks each row of dhfr and returns TRUE if the row has no missing values and FALSE if it contains any missing value.
missingdata <- dhfr[!complete.cases(dhfr),]
sum(is.na(missingdata))



# 5. Handling missing data
# 5.1 delete all entries with missing values
clean.data <- na.omit(dhfr)
sum(is.na(clean.data))

# 5.2 Imputation: Replace missing values with the column's

# MEAN
dhfr.impute <- dhfr

# Loop through all numeric columns
for (i in which(sapply(dhfr.impute, is.numeric))) {
  # Replace NA values with the mean of the column
  dhfr.impute[is.na(dhfr.impute[, i]), i] <- mean(dhfr.impute[, i], na.rm = TRUE)
}

sum(is.na(dhfr.impute))

# MEDIAN
dhfr.impute <- dhfr

# sapply(dhfr.impute, is.numeric): This checks each column of dhfr.impute and returns TRUE if it's numeric, FALSE otherwise.
# which(...): Extracts the indices (column positions) of numeric columns.
# is.na(dhfr.impute[, i]): Identifies missing (NA) values in column i.
# median(dhfr.impute[, i], na.rm = TRUE): Computes the median of column i, ignoring NAs (na.rm = TRUE).

for (i in which(sapply(dhfr.impute, is.numeric))){
  dhfr.impute[is.na(dhfr.impute[, i]), i] <- median(dhfr.impute[, i], na.rm = TRUE)
}
sum(is.na(dhfr.impute))








