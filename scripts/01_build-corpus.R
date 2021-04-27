# Header ------------------------------------------------------------------

#---- Name: 01_build-corpus.R

#---- Purpose : Build corpus in preparation to word prediction

#---- Author: Moses Otieno

#---- Date : 27 Apr 2021


# Body --------------------------------------------------------------------


#---- Libraries ----

library(tidyverse)  # Data manipulation and visualization
library(tm)         # Text mining
library(RWeka)      # Machine learning algorithms
library(NLP)        # Natural Language Procession
library(stringi)    # Strings manipulation
library(stringr)    # String manipulation
library(kableExtra) # Nice tables
library(tidytext)   # Text mining using tidyverse principles

#---- For reproducibility set the seed

set.seed(2021)

#---- Sampling
sample_perc <- 0.01


# Data Preparation --------------------------------------------------------

#---- Import the datasets

data_source = "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"

if (!file.exists("data/Coursera-SwiftKey.zip")){

  download.file(url = data_source, destfile = "data/Coursera-SwiftKey.zip")
  unzip("Coursera-SwiftKey.zip")
}


#---- Blogs
blogs_filename <- "data/final/en_US/en_US.blogs.txt"
blogs <- readLines(blogs_filename, encoding = "UTF-8", skipNul = TRUE, warn = FALSE)


#---- News
news_filename <- "data/final/en_US/en_US.news.txt"
news <- readLines(news_filename, encoding = "UTF-8", skipNul = TRUE, warn = FALSE)


#---- Twitter
twitter_filename <- "data/final/en_US/en_US.twitter.txt"
twitter <- readLines(twitter_filename, encoding = "UTF-8", skipNul = TRUE, warn = FALSE)


#---- Take a sample of each dataset

sample_blog <- sample(blogs, ceiling(length(blogs) * sample_perc), replace = FALSE)
sample_news <- sample(news, ceiling(length(news) * sample_perc), replace = FALSE)
sample_twitter <- sample(twitter, ceiling(length(twitter) * sample_perc), replace = FALSE)


#---- Combine the samples

sample_combined <- c(sample_blog, sample_news, sample_twitter)


#---- Free up the memory by removing objects that are not needed

rm(blogs)
rm(news)
rm(twitter)
rm(sample_blog)
rm(sample_news)
rm(sample_twitter)

#---- Remove non-english characters

sample_combined <- iconv(sample_combined, "latin1", "ASCII", sub = "")
sample_combined <-VCorpus(VectorSource(sample_combined))

#---- Remove white spaces

to_space <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
sample_combined <- tm_map(sample_combined, stripWhitespace)


#---- Remove URLs and email addresses

sample_combined <- tm_map(sample_combined, to_space, "^https?://.*[\r\n]*")
sample_combined <- tm_map(sample_combined, to_space, "\\b[A-Z a-z 0-9._ - ]*[@](.*?)[.]{1,3} \\b")


#---- Convert all words to lowercase
sample_combined <- tm_map(sample_combined, content_transformer(tolower))


#---- Remove punctuation marks
sample_combined <- tm_map(sample_combined, removePunctuation)


#---- Remove numbers
sample_combined <- tm_map(sample_combined, removeNumbers)


#---- Remove common english stop words
sample_combined <- tm_map(sample_combined, removeWords, stopwords("english"))


