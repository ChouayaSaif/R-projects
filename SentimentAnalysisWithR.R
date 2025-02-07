# Read fiel
apple <- read.csv("data.csv")


# Build corpus: a colection of documents
library(tm) # text mining
corpus <- iconv(apple$text, to="utf-8")
corpus <- Corpus(VectorSource(corpus))
inspect(corpus[1:5])

# Clean text
corpus <- tm_map(corpus, content_transformer(tolower)) # converts all text in the corpus to lowercase.
inspect(corpus[1:5])

corpus <- tm_map(corpus, removePunctuation)
inspect(corpus[1:5])

corpus <- tm_map(corpus, removeNumbers)
inspect(corpus[1:5])

cleanset <- tm_map(corpus, removeWords, stopwords('english'))
inspect(cleanset[1:5])

# Define the function to remove URLs
removeURL <- function(x) gsub('http[[:alnum:]]*', '', x)
cleanset <- tm_map(cleanset, content_transformer(removeURL))
inspect(cleanset[1:5])

cleanset <- tm_map(cleanset, stripWhitespace)
inspect(cleanset[1:5])

cleanset <- tm_map(corpus, removeWords, c('aapl','apple'))
cleanset <- tm_map(corpus, gsub, patterns='stocks', replacement='stock')


# Term Document matrix
# Note: text data like tweets (unstructured data): to make analysis, we need to transform into a structured data.
# by using : Term Document matrix

tdm <- TermDocumentMatrix(cleanset)
tdm
tdm <- as.matrix(tdm)
tdm[1:10, 1:20]  # sparsity= 99%: 99% of times we will see 0s in the matrix


# Bar Plot
# Know how much each word appears in this dataset
w <- rowSums(tdm)
w <- subset(w, w>=25)
barplot(w,
        las=2,
        col = rainbow(50))

# Word Cloud
library(wordcloud)
w <- sort(rowSums(tdm), decreasing = TRUE)
set.seed(222)
wordcloud(words = names(w),
          freq = w,
          max.words = 150,
          random.order = FALSE,
          min.frq = 5,
          colors = brewer.pal(8, 'Dark2'),
          #scale = c(5,0.3),
          rot.per = 0.3)


# Word Cloud 2
library(wordcloud2)
w <- data.frame(word = names(w), freq = w)  # Words in the dataset
colnames(w) <- c('word','freq')
wordcloud2(w,
           size = 0.8,
           shape = 'circle')


letterCloud(w,
            word = "A",
            size = 1)

# Sentiment Analysis of Tweets
library(syuzhet)
library(lubridate)
library(ggplot2)
library(scales)
library(reshape2)
library(dplyr)

# Read file
apple <- read.csv("data.csv")
tweets <- iconv(apple$text, to = 'utf-8')

# Obtain sentiment scores
s <- get_nrc_sentiment(tweets)
head(s)
tweets[4]
get_nrc_sentiment('ugly') # check what the word ugly will return as sentiments
get_nrc_sentiment('delay')

# Bar plot
barplot(colSums(s),
        las = 2,
        col = rainbow(10),
        ylab = 'Count',
        main = 'Sentiment Scores for Apple Tweets')