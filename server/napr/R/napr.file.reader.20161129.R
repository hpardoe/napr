#' read .brainage_upload_file
#' @param input a tar archive containing lh.thickness.fwhm0.fsaverage4.mgh and rh.thickness.fwhm0.fsaverage4.mgh for a subject
#' @return a matrix with the numbers laid out so the predictive model can read them
read.upload.file <- function(input) {
	# untar
	my.tar <- untar(input, list=T)
	untar(input,list=F)
	# load mgh files
	lh <- load.mgh(my.tar[1])
	rh <- load.mgh(my.tar[2])
	thick.vals <- c(lh$x,rh$x)
	thick.matrix <- matrix(data = thick.vals, nrow = 1, ncol = (lh$ndim1 + rh$ndim1))
	# turn into matrix
	thick.matrix
}
