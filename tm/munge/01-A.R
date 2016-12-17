# First the corpus is cleaned

cache("cleancorpus",  depends="corpus", CODE={
        #start with raw corpus
        docs <- corpus
        
        # Strip out troublesome non UTF-8 characters
        docs<-tm_map(docs, content_transformer(function(x) iconv(enc2utf8(x), sub = "byte"))) 
        
        # perform some standard cleanup operations
        docs <- tm_map(docs, removePunctuation)  
        docs <- tm_map(docs, removeNumbers) 
        docs <- tm_map(docs, content_transformer(tolower)) 
        docs <- tm_map(docs, removeWords, stopwords(config$language))

        
        # remove profanity from the corpus
        docs <- tm_map(docs, removeWords, profanity)
        
        docs <- tm_map(docs, stripWhitespace) 
        docs <- tm_map(docs, PlainTextDocument) 
        docs
})

if(exists("docs")) rm(docs)
rm(profanity)


# Create a document term matrix for the clean corpus
cache("dtm", depends="cleancorpus", CODE={
        DocumentTermMatrix(cleancorpus)
})

# single word frequencies

w_freq <- colSums(as.matrix(dtm))
w_ord <- order(w_freq)


# reduce the clean corpus further by removing words which occur less than 8 times

cache("cleancorpus2",  depends="cleancorpus", CODE={
        #start with cleancorpus
        docs <- cleancorpus
        
        # remove words with frequency less than 8
        words_to_remove <- names(w_freq[w_freq<16])
        # split into manageable chunks for removeWords
        word_chunks<-split(words_to_remove, ceiling(seq_along(words_to_remove)/1000))
        for (chunk in word_chunks) {
                message("         Removing chunk of infrequent words")
                docs <- tm_map(docs, removeWords, chunk)
        }
        
        docs
})

if(exists("docs")) rm(docs, word_chunks)

words_to_keep <- names(w_freq[w_freq>=8])

# Compute uni-grams from the reduced clean corpus


cache("unigram_dtm", depends="cleancorpus2", CODE={
        DocumentTermMatrix(cleancorpus2)   
}) 

# unigram word frequencies

uni_freq <- colSums(as.matrix(unigram_dtm))
uni_ord <- order(uni_freq)


# Compute bi-grams from the reduced clean corpus

BigramTokenizer <-
        function(x)
                unlist(lapply(ngrams(words(x), 2), paste, collapse = " "), use.names = FALSE)

cache("bigram_dtm", depends="cleancorpus2", CODE={
        DocumentTermMatrix(cleancorpus2, control = list(tokenize = BigramTokenizer))   
}) 

# bigram word frequencies

bi_freq <- colSums(as.matrix(bigram_dtm))
bi_ord <- order(bi_freq)


# Compute tri-grams from the clean corpus

TrigramTokenizer <-
        function(x)
                unlist(lapply(ngrams(words(x), 3), paste, collapse = " "), use.names = FALSE)


cache("trigram_dtm", depends="cleancorpus2", CODE={
        DocumentTermMatrix(cleancorpus2, control = list(tokenize = TrigramTokenizer))   
}) 

# Trigram word frequencies

tri_freq <- colSums(as.matrix(trigram_dtm))
tri_ord <- order(tri_freq)


# Compute four-grams from the clean corpus

FourgramTokenizer <-
        function(x)
                unlist(lapply(ngrams(words(x), 4), paste, collapse = " "), use.names = FALSE)


cache("fourgram_dtm", depends="cleancorpus2", CODE={
        DocumentTermMatrix(cleancorpus2, control = list(tokenize = FourgramTokenizer))   
}) 

# Fourgram word frequencies

four_freq <- colSums(as.matrix(fourgram_dtm))
four_ord <- order(four_freq)


# Create a fourgram tree

cache("fourgram_tree", depends="four_freq", CODE={
        NgramTree(four_freq)
        
})

# Trigram word frequencies

tri_freq <- colSums(as.matrix(trigram_dtm))
tri_ord <- order(tri_freq)


# Create a trigram tree

cache("trigram_tree", depends="tri_freq", CODE={
        NgramTree(tri_freq)
        
})


# Create a bigram tree

cache("bigram_tree", depends="bi_freq", CODE={
        NgramTree(bi_freq)
        
})

# Create a unigram tree

cache("unigram_tree", depends="uni_freq", CODE={
        NgramTree(uni_freq)
})
