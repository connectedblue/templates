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

        docs <- tm_map(docs, stripWhitespace) 
        docs <- tm_map(docs, PlainTextDocument) 
        docs
})

# Create a document term matrix for the clean corpus
cache("dtm", depends="cleancorpus", CODE={
        DocumentTermMatrix(cleancorpus)
})
