library(tm)

# Read the text file
text_data <- readLines("textFile/doc1.txt")

# Create a corpus from the file content
docs <- VCorpus(VectorSource(text_data))

# Inspect the corpus
inspect(docs)

# Inspect a particular document
writeLines(as.character(docs[[5]]))


# Start Preprocessing
# Important step

# Define a function to replace specific characters with space
toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))

docs <- tm_map(docs, toSpace, "-")
docs <- tm_map(docs, toSpace, ":")
docs <- tm_map(docs, toSpace, "'")
docs <- tm_map(docs, toSpace, " -")

# check after each step
writeLines(as.character(docs[[5]]))


# Remove punctuation
docs <- tm_map(docs, removePunctuation)

# Transform to lower case
docs <- tm_map(docs, content_transformer(tolower))

# Strip digits
docs <- tm_map(docs, removeNumbers)


# check after each step
writeLines(as.character(docs[[5]]))

# Remove stopwords using standard stopword list
docs <- tm_map(docs, removeWords, stopwords("english"))
# strip whitespace
docs <- tm_map(docs, stripWhitespace)


# check after each step
writeLines(as.character(docs[[5]]))


# Need SnowballC library for Stemming
library(SnowballC)

# Stem document : Stemming has limitations
docs <- tm_map(docs, stemDocument)

writeLines(as.character(docs[[5]]))
# Some clean up
docs <- tm_map(docs, content_transformer (gsub), pattern = "organiz", replacement = "organ")
docs <- tm_map(docs, content_transformer (gsub), pattern = "organiz", replacement = "organ")
docs <- tm_map(docs, content_transformer (gsub), pattern = "organiz", replacement = "organ")
docs <- tm_map(docs, content_transformer (gsub), pattern = "organiz", replacement = "organ")
docs <- tm_map(docs, content_transformer (gsub), pattern = "organiz", replacement = "organ")

writeLines(as.character(docs[[5]]))


# Create DTM: document Term Matrix
dtm <- DocumentTermMatrix(docs)
#inspect segment of DTM
inspect(dtm[1:2,50:57])

# get word frequency: colapse matrix by summing over columns
freq <- colSums(as.matrix(dtm))
# freq: displays the frequency of each term in the corpus.
# length should be total nb of terms
length(freq)
freq



# create sort order (asc): This simply outputs the ordered indices stored in the variable ord.
ord <- order(freq, decreasing=TRUE)
ord
# inspect Most Frequently occuring terms
freq[head(ord)]

# inspect least Frequently occuring terms
freq[tail(ord)]


# Remove very frequent and very rare words
# creates a Document-Term Matrix (DTM) from docs and  removes very rare and very frequent words.
# wordLengths=c(4, 20): This keeps only words whose lengths are between 4 and 20 characters. Very short words (like "a", "is") and very long words are removed.
# bounds = list(global = c(3,27)): This filters words based on their document frequency:
#   --> Words appearing in fewer than 3 documents are removed (very rare words).
#   --> Words appearing in more than 27 documents are removed (very frequent words).
dtmr <- DocumentTermMatrix(docs, control=list(wordLengths=c(4, 20), bounds = list(global = c(3,27))))

freqr <- colSums(as.matrix(dtmr))
freqr
length(freqr)

ord <- order(freqr, decreasing=TRUE)
ord
freqr[head(ord)]
freqr[tail(ord)]
# list most frequent terms, lower bound: second arg
findFreqTerms(dtmr, lowfreq = 4)


# Correlations btw words
findAssocs(dtmr, "analysi", 0.6) # numeric(0): no other word has a correlation of 60% with analysi
findAssocs(dtmr, "mine", 0.3)
findAssocs(dtmr, "text", 0.6)

# Histogram : know which term appears more frequently
wf = data.frame(term=names(freqr), occurences=freqr)
library(ggplot2)
p <- ggplot(subset(wf, freqr<100), aes(term, occurences))
p <- p + geom_bar(stat="identity")
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))
p

# WordCloud
library(wordcloud)
library(RColorBrewer)
set.seed(42)
# limit words by specifying min freq
wordcloud(names(freqr),freqr, min.freq=70)
# add color
wordcloud(names(freqr), freqr, min.freq=70, colors=brewer.pal(8, "Dark2"))