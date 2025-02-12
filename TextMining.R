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
