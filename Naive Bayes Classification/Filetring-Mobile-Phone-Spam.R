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


sms_raw <- read.csv("spam.csv", stringsAsFactors = FALSE)

# step 1: exploring and preparing the data

str(sms_raw)
# Convert the 'type' column to a factor
sms_raw$type <- factor(sms_raw$type)

# Step 2: Create a corpus
sms_corpus <- Corpus(VectorSource(sms_raw$text))

# Step 3: Preprocess the text data
corpus_clean <- tm_map(sms_corpus, content_transformer(tolower))
corpus_clean <- tm_map(corpus_clean, removeNumbers)
corpus_clean <- tm_map(corpus_clean, removeWords, stopwords())
corpus_clean <- tm_map(corpus_clean, removePunctuation)
corpus_clean <- tm_map(corpus_clean, stripWhitespace)

# Step 4: Create a Document-Term Matrix
sms_dtm <- DocumentTermMatrix(corpus_clean)

# Step 5: Split the data into training and test sets
set.seed(123)  # For reproducibility
train_index <- sample(1:nrow(sms_raw), 0.75 * nrow(sms_raw))
sms_raw_train <- sms_raw[train_index, ]
sms_raw_test <- sms_raw[-train_index, ]
sms_dtm_train <- sms_dtm[train_index, ]
sms_dtm_test <- sms_dtm[-train_index, ]
sms_corpus_train <- corpus_clean[train_index]
sms_corpus_test <- corpus_clean[-train_index]

# Step 6: Visualize the data with word clouds
wordcloud(sms_corpus_train, min.freq = 40, random.order = FALSE)

# Step 7: Convert the Document-Term Matrix to a data frame
convert_counts <- function(x) {
  x <- ifelse(x > 0, "Yes", "No")
}

sms_train <- apply(sms_dtm_train, MARGIN = 2, convert_counts)
sms_test <- apply(sms_dtm_test, MARGIN = 2, convert_counts)

# Step 8: Train the Naive Bayes classifier
sms_classifier <- naiveBayes(sms_train, sms_raw_train$type)

# Step 9: Make predictions on the test set
sms_test_pred <- predict(sms_classifier, sms_test)

# Step 10: Evaluate the classifier
CrossTable(sms_test_pred, sms_raw_test$type, prop.chisq = FALSE, prop.t = FALSE, dnn = c('predicted', 'actual'))