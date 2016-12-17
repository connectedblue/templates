# define new config for each language and comment out unused ones

# configuration for the english corpus
add.config(
        language="english",
        # if testing is TRUE then load.project will load a sample corpus from
        # the testing_dir
        testing=TRUE,          
        training_dir="data/full_corpus",
        testing_dir="data/sample_corpus",
        testing_pcent=0.1
        
)


if(!dir.exists(config$testing_dir)) dir.create(config$testing_dir, recursive = TRUE)