#!/usr/bin/env Rscript

report.age <- function(lh_file, rh_file, model_type = "") {
    library("kernlab")
    source("../server/napr/R/load.mgh.R")

    # Load pre-made models
    load(file="../server/napr/data/rvmm.full.20161228.model.RData")
    if (model_type == "all") {
        load(file="../server/napr/data/gausspr.full.20161228.model.RData")
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

report.age(args[1], args[2], args[3])