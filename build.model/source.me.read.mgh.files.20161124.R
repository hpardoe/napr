library("kernlab")
source("load.mgh.R")
load("napr.demo.df.RData") # this is copied from ../napr.build.model.20160803
rockland <- read.table("rockland_participants.tsv", sep = "\t",h=T, stringsAsFactors = F)

lh.mgh.files <- read.csv("mgh.lh.file.list", h=F, stringsAsFactors = F)
rh.mgh.files <- read.csv("mgh.rh.file.list", h=F, stringsAsFactors = F)

names(lh.mgh.files)[1] <- "lh.mgh"
names(rh.mgh.files)[1] <- "rh.mgh"

for (i in 1:dim(lh.mgh.files)[1]) {
	lh.mgh.files$id[i] <- strsplit(lh.mgh.files$lh.mgh[i], split = "/")[[1]][3]
}

for (i in 1:dim(rh.mgh.files)[1]) {
	rh.mgh.files$id[i] <- strsplit(rh.mgh.files$rh.mgh[i], split = "/")[[1]][3]
}

mgh.files <- merge(lh.mgh.files, rh.mgh.files, by = "id")

# match up demographic data
napr.demo.new.df <- napr.demo.df[,1:6]
rm(napr.demo.df)

# add rockland demographic info to main demographic df
rockland$sex <- tolower(rockland$sex)
rockland$diagnosis <- "control"
rockland$study <- "rockland"
rockland$site <- "rockland"
rockland$handedness <- NULL
names(rockland)[1] <- "id"

demo.df <- rbind(napr.demo.new.df, rockland, stringsAsFactors=F)
demo.df$age <- as.numeric(demo.df$age)
demo.df <- demo.df[-which(is.na(demo.df$age)),]

for (i in 1:dim(demo.df)[1]) {
	if (length(grep(demo.df$id[i], mgh.files$id)) > 0) {
		demo.df$file.id[i] <- mgh.files$id[ (grep(demo.df$id[i], mgh.files$id)[1]) ]
	} else demo.df$file.id[i] <- NA
	if (demo.df$study[i] == "abideII") {
		temp.id <- substring(demo.df$id[i],3, last = 7)
		demo.df$file.id[i] <- mgh.files$id[ (grep(temp.id,mgh.files$id)[1]) ]
	}
}

# hose NAs
demo.df <- demo.df[ -which(is.na(demo.df$file.id)),]

# make uniform age distribution
set.seed(42)
group.size <- 70
sample.age.5.to.10 <- sample(which((demo.df$age > 5) & (demo.df$age < 10)), size = group.size)
sample.age.10.to.15 <- sample(which((demo.df$age >= 10) & (demo.df$age < 15)), size = group.size)
sample.age.15.to.20 <- sample(which((demo.df$age >= 15) & (demo.df$age < 20)), size = group.size)
sample.age.20.to.25 <- sample(which((demo.df$age >= 20) & (demo.df$age < 25)), size = group.size)
sample.age.25.to.30 <- sample(which((demo.df$age >= 25) & (demo.df$age < 30)), size = group.size)
sample.age.30.to.35 <- sample(which((demo.df$age >= 30) & (demo.df$age < 35)), size = group.size)
sample.age.35.and.up <- which(demo.df$age >= 35)

even.age.lookup <- c(sample.age.5.to.10,sample.age.10.to.15, sample.age.15.to.20, sample.age.20.to.25, sample.age.25.to.30, sample.age.30.to.35, sample.age.35.and.up)

demo.reduced.df <- demo.df[even.age.lookup,]

# build data matrix
thick.matrix <- matrix(nrow = dim(demo.reduced.df)[1], ncol = 5124)

for (i in 1:dim(demo.reduced.df)[1]) {
	index <- grep(demo.reduced.df$file.id[i],mgh.files$id)
	lh.thick <- load.mgh(mgh.files$lh.mgh[index])
	rh.thick <- load.mgh(mgh.files$rh.mgh[index])
	thick.vals <- c(lh.thick$x,rh.thick$x)
	thick.matrix[i,] <- thick.vals
}

# train model
test.index <- sample(1:dim(demo.reduced.df)[1],200)

test.age <- demo.reduced.df$age[test.index]
test.matrix <-thick.matrix[test.index,]

train.age <- demo.reduced.df$age[-test.index]
train.matrix <- thick.matrix[-test.index,]

# train model
# relevance vector machine
rvmm <- rvm(train.matrix, train.age, type = "regression", kernel = "rbfdot", kpar = "automatic")

#plot(test.age, predict(rvmm, test.matrix), xlim = c(0,90), ylim = c(0,90))
mae <- mean(abs(predict(rvmm, test.matrix) - test.age))

