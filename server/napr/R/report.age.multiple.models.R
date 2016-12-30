#' feed freesurfer stats into model to predict age
#' @param file uploaded tar archive
#' @param model.list a list of predictive models generated using kernlab library
#' @return predicted age
report.age.multiple.models <- function(file,model.list = list(rvmm.full.20161228.model,gausspr.full.20161228.model)) {
  
  model.names <- as.character(formals(report.age.multiple.models)$model.list)[-1]
  cat(sprintf("%-30s %13s\n","Model","Predicted age"))

  for (i in 1:length(model.list)) {
    model <- model.list[[i]]
	  pred.age <- kernlab::predict(model,read.upload.file(file))
	  model.id <- model.names[i]
	  package.version <- packageVersion("napr")
	  cat(sprintf("%-30s %13.1f\n",model.id,pred.age))
  }
}