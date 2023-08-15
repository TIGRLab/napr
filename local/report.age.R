#!/usr/bin/env Rscript

get_exec_dir <- function() {
    args <- commandArgs()
    m <- regexpr("(?<=^--file=).+", args, perl=TRUE)
    return(dirname(regmatches(args, m)))
}

report.age <- function(lh_file, rh_file, model_type = "") {
    library("kernlab")
    src_dir <- get_exec_dir()
    source(file.path(src_dir, "../server/napr/R/load.mgh.R"))

    # Load pre-made models
    load(file=file.path(src_dir, "../server/napr/data/rvmm.full.20161228.model.RData"))
    if (model_type == "all") {
        load(file=file.path(src_dir, "../server/napr/data/gausspr.full.20161228.model.RData"))
        model.list = list(
            rvmm.full.20161228=rvmm.full.20161228.model,
            gausspr.full.20161228=gausspr.full.20161228.model
        )
    } else {
        model.list = list(
            rvmm.full.20161228=rvmm.full.20161228.model
        )
    }

    lh <- load.mgh(lh_file)
    rh <- load.mgh(rh_file)

	thick.vals <- c(lh$x,rh$x)
	thick.matrix <- matrix(data = thick.vals, nrow = 1, ncol = (lh$ndim1 + rh$ndim1))

    cat(sprintf("%-30s %13s\n","Model","Predicted age"))
    for (i in 1:length(model.list)) {
        model <- model.list[[i]]
        pred.age <- kernlab::predict(model, thick.matrix)
        model.id <- names(model.list)[i]
        cat(sprintf("%-30s %13.1f\n",model.id,pred.age))
    }
}

args = commandArgs(trailingOnly=TRUE)

if (length(args) == 3) {
  model = args[3]
} else if (length(args) < 2) {
   print("Must provide lh and rh thickness fsaverage4 files.")
   quit()
} else {
  model = ""
}

report.age(args[1], args[2], model)
