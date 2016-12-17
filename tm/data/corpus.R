# Load in the appropriate corpus

corpus_dir <- function(){
        if (config$testing) {
                corpus_dir <- config$testing_dir
                
                # create sampled files from the training data if they don't 
                # already exist
                set.seed(1234)
                docs <- list.files(config$training_dir)
                for (doc in docs) {
                        if (file.exists(file.path(config$testing_dir, doc))) next()
                        sample <- sample_file(file.path(config$training_dir, doc),
                                              config$testing_pcent)
                        writeLines(sample, file.path(config$testing_dir, doc))
                }
                corpus_dir
                
        } else {
                config$training_dir
        }
}

corpus <- Corpus(DirSource(corpus_dir(), encoding = "UTF-8"))



