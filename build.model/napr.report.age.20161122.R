# input subject id, get age estimate
# take lh mgh and rh mgh, read into matrix

report.age <- function(input_file,model = ) {
	require("kernlab")
	temp.files <- untar(input_file, list = T)
	# check that file names are as expected
	untar(input_file)
	#
	lh.thick <- load.mgh(temp.files[1])
	rh.thick <- load.mgh(temp.files[2])
	thick.vals <- c(lh.thick$x,rh.thick$x)
	thick.matrix <- matrix(data = thick.vals, nrow = 1, ncol = (lh.thick$ndim1 + rh.thick$ndim1))
	out <- predict(model, thick.matrix)
	return(out)
}
