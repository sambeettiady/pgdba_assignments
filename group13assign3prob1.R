rm(list=ls())
library("text2vec")
library("tree")
library(tidytext)
library(dplyr)

# CREATING DATAFRAME
smsdata = read.table(file='http://www.souravsengupta.com/cds2017/evaluation/smsdata.txt', header = FALSE, sep = '\t', quote = "")
smsdata$V2 = as.character(smsdata$V2)

#Generate tokens with pre-processing steps
tokens = itoken(smsdata$V2, preprocessor = tolower, 
                tokenizer = word_tokenizer, 
                progressbar = FALSE)

#Create vocab
vocab = create_vocabulary(tokens)
vectorizer = vocab_vectorizer(vocab)
#Create document term matrix
dtm = create_dtm(tokens, vectorizer)

#Create tfidf model - tf/(No. of words in document)*log(N/n)
tfidf = TfIdf$new()
tfidf$fit(dtm)
z = as.data.frame(as.matrix(tfidf$transform(dtm)))

#TRANSFORMING
names(smsdata) = c('label','sms')
smsdata = cbind(smsdata,z)

#Remove non-alphanumeric words
for(f in names(smsdata)){
  if(grepl("[^a-zA-Z]", f)){
    drops <- c(f)
    smsdata = smsdata[ , !(names(smsdata) %in% drops)]
  }
}

smsdata$num_words_msg = sapply(gregexpr("[A-z]\\W+", smsdata$sms), length) + 1L
smsdata$num_chars = nchar(smsdata$spam)

for(i in 1:5574){
  s = itoken(smsdata$sms[i], tokenizer = word_tokenizer, preprocessor = tolower, progressbar = FALSE)
  temp = create_vocabulary(s)
  smsdata$num_words_tokenized[i] = length(temp$vocab$terms)
}

#Difference in the number of words before and after tokenising
smsdata$diff1 = smsdata$num_words_msg - smsdata$num_words_tokenized

#Calculate number of special characters in each sms
smsdata$num_punct = sapply(gregexpr("[[:punct:]]", smsdata$sms), length)
smsdata$num_digits = sapply(gregexpr("[[:digit:]]", smsdata$sms), length)
smsdata$num_lower = sapply(gregexpr("[[:lower:]]", smsdata$sms), length)
smsdata$num_upper = sapply(gregexpr("[[:upper:]]", smsdata$sms), length)
smsdata$num_cntrl = sapply(gregexpr("[[:cntrl:]]", smsdata$sms), length)
smsdata$num_blank = sapply(gregexpr("[[:blank:]]", smsdata$sms), length)
smsdata$num_space = sapply(gregexpr("[[:space:]]", smsdata$sms), length)
smsdata$num_alnum = sapply(gregexpr("[[:alnum:]]", smsdata$sms), length)
smsdata$num_alpha = sapply(gregexpr("[[:alpha:]]", smsdata$sms), length)

#Relative Frequency
smsdata$num_punct_rf = sapply(gregexpr("[[:punct:]]", smsdata$sms), length) / smsdata$num_chars
smsdata$num_digits_rf = sapply(gregexpr("[[:digit:]]", smsdata$sms), length) / smsdata$num_chars
smsdata$num_lower_rf = sapply(gregexpr("[[:lower:]]", smsdata$sms), length) / smsdata$num_chars
smsdata$num_upper_rf = sapply(gregexpr("[[:upper:]]", smsdata$sms), length) / smsdata$num_chars
smsdata$num_cntrl_rf = sapply(gregexpr("[[:cntrl:]]", smsdata$sms), length) / smsdata$num_chars
smsdata$num_blank_rf = sapply(gregexpr("[[:blank:]]", smsdata$sms), length) / smsdata$num_chars
smsdata$num_space_rf = sapply(gregexpr("[[:space:]]", smsdata$sms), length) / smsdata$num_chars
smsdata$num_alnum_rf = sapply(gregexpr("[[:alnum:]]", smsdata$sms), length) / smsdata$num_chars
smsdata$num_alpha_rf = sapply(gregexpr("[[:alpha:]]", smsdata$sms), length) / smsdata$num_chars

# SAVING
write.csv(smsdata, '/home/sambeet/data/cds assignments/smsdata_transformed_new.csv')
