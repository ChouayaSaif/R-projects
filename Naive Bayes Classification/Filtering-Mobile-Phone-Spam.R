##############################################################
# Classification using Naive Bayes                           #
# Machine Learning with R by Brett Lantz                     #
# SMS Spam: Filtering mobile phone spam with the naive Bayes algorithm #
##############################################################

# Note: understand. We will transform our data into a representation known as bag-of-words, which ignores the order that words appear in

install.packages("tm")
install.packages("wordcloud")
install.packages("e1071")
install.packages("gmodels")

library(tm)
library(wordcloud)
library(e1071)
library(gmodels)

print(vignette("tm")) # learn more about the text mining package
sms_raw <- read.csv("spam.csv", stringsAsFactors = FALSE)

# step 1: exploring and preparing the data

str(sms_raw)
# Rename columns for clarity
colnames(sms_raw) <- c("type", "message", "X", "X.1", "X.2")
# Remove empty columns
sms_raw <- sms_raw[, 1:2]  # Keep only 'type' and 'message' columns
# Convert 'type' to a factor
sms_raw$type <- factor(sms_raw$type)
# Check the structure again
str(sms_raw)
str(sms_raw$type)
table(sms_raw$type)



# Step 2: Data preparation – processing text data for analysis

# Create a corpus
sms_corpus <- Corpus(VectorSource(sms_raw$text))
print(sms_corpus)
# SMS messages before cleaning
inspect(sms_corpus[1:3])


# Step 3: Preprocess the text data
corpus_clean <- tm_map(sms_corpus, tolower)
corpus_clean <- tm_map(sms_corpus, content_transformer(tolower))
corpus_clean <- tm_map(corpus_clean, removeNumbers)
corpus_clean <- tm_map(corpus_clean, removeWords, stopwords())
corpus_clean <- tm_map(corpus_clean, removePunctuation)
corpus_clean <- tm_map(corpus_clean, stripWhitespace)

# SMS messages after cleaning
inspect(corpus_clean[1:3])


# Tokenize the SMS corpus
# Step 4: Create a Document-Term Matrix
sms_dtm <- DocumentTermMatrix(corpus_clean)

# Step 5 Data Preparation: Split the data into training and test sets
set.seed(123)  # For reproducibility
train_index <- sample(1:nrow(sms_raw), 0.75 * nrow(sms_raw))
sms_raw_train <- sms_raw[train_index, ]
sms_raw_test <- sms_raw[-train_index, ]
sms_dtm_train <- sms_dtm[train_index, ]
sms_dtm_test <- sms_dtm[-train_index, ]
sms_corpus_train <- corpus_clean[train_index]
sms_corpus_test <- corpus_ clean[-train_index]

# Step 6: Visualize the data with word clouds
wordcloud(sms_corpus_train, min.freq = 40, random.order = FALSE)

# create subsets
spam <- subset(sms_raw_train, type == "spam")
ham <- subset(sms_raw_train, type == "ham")

wordcloud(spam$text, max.words = 40, scale = c(3, 0.5))
wordcloud(ham$text, max.words = 40, scale = c(3, 0.5))


# reduce DTM and return a dictionary of words that appear at least 5 times
sms_dict <- Dictionary(findFreqTerms(sms_dtm_train, 5))

sms_train <- DocumentTermMatrix(sms_corpus_train,
                                list(dictionary = sms_dict))
sms_test <- DocumentTermMatrix(sms_corpus_test,
                                 list(dictionary = sms_dict))

# Step 7: Convert counts to factors
# The naive Bayes classifier is typically trained on data with categorical features. This
# poses a problem since the cells in the sparse matrix indicate a count of the times a
# word appears in a message. We should change this to a factor variable that simply
#indicates yes or no depending on whether the word appears at all.
convert_counts <- function(x) {
  x <- ifelse(x > 0, 1, 0)
  x <- factor(x, levels = c(0, 1), labels = c(""No"", ""Yes""))
  return(x)
}


sms_train <- apply(sms_train, MARGIN = 2, convert_counts)
sms_test <- apply(sms_test, MARGIN = 2, convert_counts)

# Step 8: Train the Naive Bayes classifier
sms_classifier <- naiveBayes(sms_train, sms_raw_train$type)

# Step 9: Make predictions on the test set
sms_test_pred <- predict(sms_classifier, sms_test)

# Step 10: Evaluate the classifier
CrossTable(sms_test_pred, sms_raw_test$type, prop.chisq = FALSE, prop.t = FALSE, dnn = c('predicted', 'actual'))