This ProjectTemplate structure is configured to assist with text mining projects.

There are some specific things set up:

 - a .gitignore that will ignore the corpus data sets and some cache files so you don't clog up your git
 - libraries set to load and tm and other useful text mining libraries attached
 - data directory contains a corpus.R file which allows a generic data source to be attached
 - lib/globals.R contains some specific configuration that allow sampling of the data sets
 - munge directory contains a script to load the raw corpus and produce a cleaned version
 - a document term matrix is created against the clean corpus
 - when a clear() is issued, the global env will be cleared except for the corpus variables which makes for faster reloading of projects (to clear those too, use clear(force=TRUE))
 
 
 You might want, for example, to develop your models using only 5% of the corpus for training purposes.
 
 To use the structure:
 
  - drop your main corpus in data/full_corpus directory
  - goto lib/globals.R and configure the desired data loading behaviour
  - load.project()