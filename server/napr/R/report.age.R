#' feed freesurfer stats into model to predict age
#' @param file uploaded tar archive
#' @param model a predictive model generated using kernlab library
#' @return predicted age
report.age <- function(file,model = rvmm.full.20161228.model) {
  #require("kernlab")
	pred.age <- kernlab::predict(model,read.upload.file(file))
	model.id <- deparse(substitute(model))
	#package.version <- "napr.0.1.2"
	package.version <- packageVersion("napr")
#	cat("Predicted age: ",pred.age,"\n")
#	cat("Model version: ",model.id,"\n")
#	cat("Package version: ",as.character(package.version),"\n")
#	cat(sprintf("%-30s %13s\n","Model","Predicted age"))
#	cat(sprintf("%-30s %13.1f\n",model.id,pred.age))
	cat(sprintf("%-30s %13s\n","Model","Predicted age"))
	cat(sprintf("%-30s %13.1f\n",model.id,pred.age))
}