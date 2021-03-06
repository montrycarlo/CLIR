# Project: RCLI
# 
# Author: Renaud Gaujoux
# Created: Nov 20, 2013
###############################################################################

is_source_package <- function(path){
    !file.exists(file.path(path, 'Meta'))
}

load_package <- function(path){
    if( is_source_package(path) ){
        .silenceF(devtools::load_all)(path)
    }else{
        lib <- normalizePath(dirname(path))
        ol <- .libPaths()
        .libPaths(c(lib, ol))
        on.exit(.libPaths(ol))
        qlibrary(basename(path))
    }
}

isString <- function(x) is.character(x) && length(x) == 1L 
        
packageInfo <- function(file){
    
    res <- read.dcf(file)
    as.list(res[1, ])
}

sstr <- function(x, collapse = "\n"){
    paste0(capture.output(str(x)), collapse = collapse)
}

.silenceF <- function(f, verbose=FALSE){
    
    if( verbose ) f
    else{
        function(...){
            capture.output(suppressPackageStartupMessages(suppressMessages(res <- f(...)))); 
            res
        }
    }
}

qlibrary <- .silenceF(library, verbose = FALSE)


.hasArgument <- function(ARGS){
    function(x) length(ARGS[[x]]) && nzchar(ARGS[[x]])
}
