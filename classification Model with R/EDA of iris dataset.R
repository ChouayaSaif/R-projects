# Importing libraries
library(datasets)
# Method 1: using datasets library has iris already in
library(caret) # caret stands Classification and Regression Training. It is a powerful and widely used package for machine learning and statistical modeling

# Phase 1: loading the library

# iris dataset
data("iris")
iris <- datasets::iris #access a specific object from a package without loading the entire package.


# Method 2: installing 
library(RCurl)
iris <-read.csv(text=getURL("https://raw.githubusercontent.com/dataprofessor/data/master/iris.csv"))

View(iris)

# Phase 2:display statistics






sum(is.na(iris))



