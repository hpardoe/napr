#' read .brainage_upload_file
#' @param file.name The name of a file that is the aseg.stats, lh.aparc and rh.aparc files cat'ed together
#' @return a matrix with the numbers laid out so the predictive model can read them
read.upload.file <- function(file.name) {
	trim.leading <- function (x)  sub("^\\s+", "", x)

	my.text <- readLines(file.name)
	aseg.lines <- c(80:124)

	aseg.text <- my.text[aseg.lines]

	aseg.struct.name <- vector(length = length(aseg.lines))
	aseg.vol <- vector(length = length(aseg.lines))

	for (i in 1:length(aseg.lines)) {

		temp <- strsplit(aseg.text[i],split = " +")
		aseg.struct.name[i] <- temp[[1]][6]
		aseg.vol[i] <- temp[[1]][5]

	}

	# more aseg data
	more.aseg.lines <- c(14:34)
	more.aseg.text <- my.text[more.aseg.lines]

	more.aseg.struct.name <- vector(length = length(more.aseg.lines))
	more.aseg.vol <- vector(length = length(more.aseg.lines))

	for (i in 1:length(more.aseg.lines)) {

		temp <- strsplit(more.aseg.text[i],split = ",")
		more.aseg.struct.name[i] <- trim.leading(temp[[1]][2])
		more.aseg.vol[i] <- as.numeric(temp[[1]][4])

	}

	#aseg.data <- data.frame(struct.names = c(aseg.struct.name,more.aseg.struct.name), struct.vols = c(aseg.vol,more.aseg.vol))

	lh.aparc.lines <- c(178:211)
	lh.aparc.text <- my.text[lh.aparc.lines]

	rh.aparc.lines <- c(265:298)
	rh.aparc.text <- my.text[rh.aparc.lines]

	struct.measures <- strsplit(my.text[177]," ")[[1]]
	measure.order <- c(5,3,4,10,9,8,6)
	measure.names <- c("thickness","area","volume","curvind","foldind","gauscurv","thicknessstd")

	# over all structures
	# lh_structure_thickness
	lh.thickness.struct.name <- vector(length = length(lh.aparc.lines))
	lh.thickness <- vector(length = length(lh.aparc.lines))

	measure <- measure.order[1]
	measure.id <- measure.names[1]
	for (i in 1:length(lh.aparc.lines)) {
		# get measurement value
		temp <- strsplit(lh.aparc.text[i],split = " +")
		lh.thickness[i] <- as.numeric(temp[[1]][measure])
		lh.thickness.struct.name[i] <- paste("lh",temp[[1]][1],measure.id,sep="_")
	}
	# add mean thickness
	lh.thickness <- c(lh.thickness,as.numeric(strsplit(my.text[145],split = ",")[[1]][4]))
	lh.thickness.struct.name <- c(lh.thickness.struct.name,"lh_MeanThickness_thickness")

	# rh_structure_thickness
	rh.thickness.struct.name <- vector(length = length(rh.aparc.lines))
	rh.thickness <- vector(length = length(rh.aparc.lines))
	measure <- measure.order[1]
	measure.id <- measure.names[1]
	for (i in 1:length(rh.aparc.lines)) {
		# get measurement value
		temp <- strsplit(rh.aparc.text[i],split = " +")
		rh.thickness[i] <- as.numeric(temp[[1]][measure])
		rh.thickness.struct.name[i] <- paste("rh",temp[[1]][1],measure.id,sep="_")
	}
	# add mean thickness
	rh.thickness <- c(rh.thickness,as.numeric(strsplit(my.text[232],split = ",")[[1]][4]))
	rh.thickness.struct.name <- c(rh.thickness.struct.name,"rh_MeanThickness_thickness")

	# lh_structure_area
	lh.area.struct.name <- vector(length = length(lh.aparc.lines))
	lh.area <- vector(length = length(lh.aparc.lines))
	measure <- measure.order[2]
	measure.id <- measure.names[2]
	for (i in 1:length(lh.aparc.lines)) {
		# get measurement value
		temp <- strsplit(lh.aparc.text[i],split = " +")
		lh.area[i] <- as.numeric(temp[[1]][measure])
		lh.area.struct.name[i] <- paste("lh",temp[[1]][1],measure.id,sep="_")
	}
	# add whitesurfarea
	lh.area <- c(lh.area,as.numeric(strsplit(my.text[144],split = ",")[[1]][4]))
	lh.area.struct.name <- c(lh.area.struct.name,"lh_WhiteSurfArea_area")

	# rh_structure_area
	rh.area.struct.name <- vector(length = length(rh.aparc.lines))
	rh.area <- vector(length = length(rh.aparc.lines))
	measure <- measure.order[2]
	measure.id <- measure.names[2]
	for (i in 1:length(rh.aparc.lines)) {
		# get measurement value
		temp <- strsplit(rh.aparc.text[i],split = " +")
		rh.area[i] <- as.numeric(temp[[1]][measure])
		rh.area.struct.name[i] <- paste("rh",temp[[1]][1],measure.id,sep="_")
	}
	# add whitesurfarea
	rh.area <- c(rh.area,as.numeric(strsplit(my.text[231],split = ",")[[1]][4]))
	rh.area.struct.name <- c(rh.area.struct.name,"rh_WhiteSurfArea_area")

	# lh_structure_volume
	lh.vol.struct.name <- vector(length = length(lh.aparc.lines))
	lh.vol <- vector(length = length(lh.aparc.lines))
	measure <- measure.order[3]
	measure.id <- measure.names[3]
	for (i in 1:length(lh.aparc.lines)) {
		# get measurement value
		temp <- strsplit(lh.aparc.text[i],split = " +")
		lh.vol[i] <- as.numeric(temp[[1]][measure])
		lh.vol.struct.name[i] <- paste("lh",temp[[1]][1],measure.id,sep="_")
	}

	# rh_structure_volume
	rh.vol.struct.name <- vector(length = length(rh.aparc.lines))
	rh.vol <- vector(length = length(rh.aparc.lines))
	measure <- measure.order[3]
	measure.id <- measure.names[3]
	for (i in 1:length(rh.aparc.lines)) {
		# get measurement value
		temp <- strsplit(rh.aparc.text[i],split = " +")
		rh.vol[i] <- as.numeric(temp[[1]][measure])
		rh.vol.struct.name[i] <- paste("rh",temp[[1]][1],measure.id,sep="_")
	}

	# lh_structure_curvind
	lh.curvind.struct.name <- vector(length = length(lh.aparc.lines))
	lh.curvind <- vector(length = length(lh.aparc.lines))
	measure <- measure.order[4]
	measure.id <- measure.names[4]
	for (i in 1:length(lh.aparc.lines)) {
		# get measurement value
		temp <- strsplit(lh.aparc.text[i],split = " +")
		lh.curvind[i] <- as.numeric(temp[[1]][measure])
		lh.curvind.struct.name[i] <- paste("lh",temp[[1]][1],measure.id,sep="_")
	}

	# rh_structure_curvind
	rh.curvind.struct.name <- vector(length = length(rh.aparc.lines))
	rh.curvind <- vector(length = length(rh.aparc.lines))
	measure <- measure.order[4]
	measure.id <- measure.names[4]
	for (i in 1:length(rh.aparc.lines)) {
		# get measurement value
		temp <- strsplit(rh.aparc.text[i],split = " +")
		rh.curvind[i] <- as.numeric(temp[[1]][measure])
		rh.curvind.struct.name[i] <- paste("rh",temp[[1]][1],measure.id,sep="_")
	}

	# lh_structure_foldind
	lh.foldind.struct.name <- vector(length = length(lh.aparc.lines))
	lh.foldind <- vector(length = length(lh.aparc.lines))
	measure <- measure.order[5]
	measure.id <- measure.names[5]
	for (i in 1:length(lh.aparc.lines)) {
		# get measurement value
		temp <- strsplit(lh.aparc.text[i],split = " +")
		lh.foldind[i] <- as.numeric(temp[[1]][measure])
		lh.foldind.struct.name[i] <- paste("lh",temp[[1]][1],measure.id,sep="_")
	}

	# rh_structure_foldind
	rh.foldind.struct.name <- vector(length = length(rh.aparc.lines))
	rh.foldind <- vector(length = length(rh.aparc.lines))
	measure <- measure.order[5]
	measure.id <- measure.names[5]
	for (i in 1:length(rh.aparc.lines)) {
		# get measurement value
		temp <- strsplit(rh.aparc.text[i],split = " +")
		rh.foldind[i] <- as.numeric(temp[[1]][measure])
		rh.foldind.struct.name[i] <- paste("rh",temp[[1]][1],measure.id,sep="_")
	}

	# lh_structure_gauscurv
	lh.gauscurv.struct.name <- vector(length = length(lh.aparc.lines))
	lh.gauscurv <- vector(length = length(lh.aparc.lines))
	measure <- measure.order[6]
	measure.id <- measure.names[6]
	for (i in 1:length(lh.aparc.lines)) {
		# get measurement value
		temp <- strsplit(lh.aparc.text[i],split = " +")
		lh.gauscurv[i] <- as.numeric(temp[[1]][measure])
		lh.gauscurv.struct.name[i] <- paste("lh",temp[[1]][1],measure.id,sep="_")
	}

	# rh_structure_gauscurv
	rh.gauscurv.struct.name <- vector(length = length(rh.aparc.lines))
	rh.gauscurv <- vector(length = length(rh.aparc.lines))
	measure <- measure.order[6]
	measure.id <- measure.names[6]
	for (i in 1:length(rh.aparc.lines)) {
		# get measurement value
		temp <- strsplit(rh.aparc.text[i],split = " +")
		rh.gauscurv[i] <- as.numeric(temp[[1]][measure])
		rh.gauscurv.struct.name[i] <- paste("rh",temp[[1]][1],measure.id,sep="_")
	}

	# lh_structure_thicknessstd
	lh.thicknessstd.struct.name <- vector(length = length(lh.aparc.lines))
	lh.thicknessstd <- vector(length = length(lh.aparc.lines))
	measure <- measure.order[7]
	measure.id <- measure.names[7]
	for (i in 1:length(lh.aparc.lines)) {
		# get measurement value
		temp <- strsplit(lh.aparc.text[i],split = " +")
		lh.thicknessstd[i] <- as.numeric(temp[[1]][measure])
		lh.thicknessstd.struct.name[i] <- paste("lh",temp[[1]][1],measure.id,sep="_")
	}

	# rh_structure_thicknessstd
	rh.thicknessstd.struct.name <- vector(length = length(rh.aparc.lines))
	rh.thicknessstd <- vector(length = length(rh.aparc.lines))
	measure <- measure.order[7]
	measure.id <- measure.names[7]
	for (i in 1:length(rh.aparc.lines)) {
		# get measurement value
		temp <- strsplit(rh.aparc.text[i],split = " +")
		rh.thicknessstd[i] <- as.numeric(temp[[1]][measure])
		rh.thicknessstd.struct.name[i] <- paste("rh",temp[[1]][1],measure.id,sep="_")
	}

	out.names <- c(aseg.struct.name,more.aseg.struct.name,lh.thickness.struct.name,rh.thickness.struct.name,lh.area.struct.name,rh.area.struct.name,lh.vol.struct.name,rh.vol.struct.name,lh.curvind.struct.name,rh.curvind.struct.name,lh.foldind.struct.name,rh.foldind.struct.name,lh.gauscurv.struct.name,rh.gauscurv.struct.name,lh.thicknessstd.struct.name,rh.thicknessstd.struct.name)
	out.values <- c(aseg.vol,more.aseg.vol,lh.thickness,rh.thickness,lh.area,rh.area,lh.vol,rh.vol,lh.curvind,rh.curvind,lh.foldind,rh.foldind,lh.gauscurv,rh.gauscurv,lh.thicknessstd,rh.thicknessstd)

	out.names[1:62] <- gsub(pattern = "-", replacement=".",out.names[1:62])
	out.names[66] <- "EstimatedTotalIntraCranialVol"

	out.matrix <- as.matrix(t(as.numeric(out.values)))
	colnames(out.matrix) <- out.names
	out.matrix
}
