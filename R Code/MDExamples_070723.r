library(maptools)
library(lattice)
source("C:\\00NMML\\StreamNetworks\\StreamNetworksCourse\\R Code\\sglm.stream_functions070723.r")

setwd("C:\\00NMML\\StreamNetworks\\StreamNetworksCourse\\datasets\\statdata")

data1 <- read.table("md_obs.csv", header = TRUE, sep = ",")
data1 <- as.data.frame(data1)
N.all <- length(data1[,1])
data1[,"Xcov"] <- data1[,"outletdist_m"]/1000

dist.junc <- read.table("md_puredist.txt", 
		header = TRUE, sep = ",")
dist.junc <- as.matrix(dist.junc[1:N.all,1:N.all])
dist.junc <- dist.junc/1000
dist.hydro <- dist.junc + t(dist.junc)
		
flow.matrix <- read.table("md_incidence.txt", 
		header = TRUE, sep = ",")
flow.matrix <- as.matrix(flow.matrix[1:N.all,1:N.all])

setwd("C:\\00NMML\\StreamNetworks\\StreamNetworksCourse\\datasets\\gisdata")

shape.path.filename <- "md_predictions.shp"
pred.rshape <- read.shape(shape.path.filename)
ord <- order(pred.rshape$att.data$OBJECTID_1)
pxy <- shape.prj.coords(pred.rshape)
names(pxy) <- c("x", "y")
pxy <- pxy[ord,]
plot(pxy, pch = 19, col = "blue")
pred.data <- cbind(pred.rshape$att.data,pxy)
shape.path.filename <- "md_observed.shp"
obs.rshape <- read.shape(shape.path.filename)
xy <- shape.prj.coords(obs.rshape)
names(xy) <- c("x", "y")
points(xy, col = "green", pch = 19)

setwd("C:\\00NMML\\StreamNetworks\\StreamNetworksCourse\\datasets\\statdata")

# -------------------------------------------------------------
#            MODEL COMPARISONS
# -------------------------------------------------------------

SO4.out1 <- slm.stream(SO4_LAB ~ 1, data = data1, dist.junc = dist.junc,
  flow.matrix = flow.matrix,
  CorModel1 = "LinearSill.tailup", CorModel2 = NULL, EstMeth = "ML")
SO4.out2 <- slm.stream(SO4_LAB ~ 1, data = data1, dist.junc = dist.junc,
  flow.matrix = flow.matrix,
  CorModel1 = "Spherical.tailup", CorModel2 = NULL, EstMeth = "ML")
SO4.out3 <- slm.stream(SO4_LAB ~ 1, data = data1, dist.junc = dist.junc,
  flow.matrix = flow.matrix,
  CorModel1 = "Mariah.tailup", CorModel2 = NULL, EstMeth = "ML")
SO4.out4 <- slm.stream(SO4_LAB ~ 1, data = data1, dist.junc = dist.junc,
  flow.matrix = flow.matrix,
  CorModel1 = "Exponential.tailup", CorModel2 = NULL, EstMeth = "ML")
SO4.out5 <- slm.stream(SO4_LAB ~ 1, data = data1, dist.junc = dist.junc,
  flow.matrix = flow.matrix,
  CorModel1 = "Exponential.tailup", CorModel2 = "LinearSill.taildown",
  EstMeth = "ML")
SO4.out6 <- slm.stream(SO4_LAB ~ 1, data = data1, dist.junc = dist.junc,
  flow.matrix = flow.matrix,
  CorModel1 = "Exponential.taildown", CorModel2 = NULL, EstMeth = "ML")
SO4.out7 <- slm.stream(SO4_LAB ~ 1, data = data1, dist.junc = dist.junc,
  flow.matrix = flow.matrix,
  CorModel1 = "Mariah.taildown", CorModel2 = NULL, EstMeth = "ML")
SO4.out8 <- slm.stream(SO4_LAB ~ 1, data = data1, dist.junc = dist.junc,
  flow.matrix = flow.matrix,
  CorModel1 = "Spherical.taildown", CorModel2 = NULL, EstMeth = "ML")
SO4.out9 <- slm.stream(SO4_LAB ~ 1, data = data1, dist.junc = dist.junc,
  flow.matrix = flow.matrix,
  CorModel1 = "LinearSill.taildown", CorModel2 = NULL, EstMeth = "ML")
SO4.out10 <- slm.stream(SO4_LAB ~ Xcov, data = data1, dist.junc = dist.junc,
  flow.matrix = flow.matrix,
  CorModel1 = "LinearSill.tailup", CorModel2 = NULL, EstMeth = "ML")
SO4.out11 <- slm.stream(SO4_LAB ~ Xcov, data = data1, dist.junc = dist.junc,
  flow.matrix = flow.matrix,
  CorModel1 = "Spherical.tailup", CorModel2 = NULL, EstMeth = "ML")
SO4.out12 <- slm.stream(SO4_LAB ~ Xcov, data = data1, dist.junc = dist.junc,
  flow.matrix = flow.matrix,
  CorModel1 = "Mariah.tailup", CorModel2 = NULL, EstMeth = "ML")
SO4.out13 <- slm.stream(SO4_LAB ~ Xcov, data = data1, dist.junc = dist.junc,
  flow.matrix = flow.matrix,
  CorModel1 = "Exponential.tailup", CorModel2 = NULL, EstMeth = "ML")
SO4.out14 <- slm.stream(SO4_LAB ~ Xcov, data = data1, dist.junc = dist.junc,
  flow.matrix = flow.matrix,
  CorModel1 = "Exponential.tailup", CorModel2 = "LinearSill.taildown",
  EstMeth = "ML")
SO4.out15 <- slm.stream(SO4_LAB ~ Xcov, data = data1, dist.junc = dist.junc,
  flow.matrix = flow.matrix,
  CorModel1 = "Exponential.taildown", CorModel2 = NULL, EstMeth = "ML")
SO4.out16 <- slm.stream(SO4_LAB ~ Xcov, data = data1, dist.junc = dist.junc,
  flow.matrix = flow.matrix,
  CorModel1 = "Mariah.taildown", CorModel2 = NULL, EstMeth = "ML")
SO4.out17 <- slm.stream(SO4_LAB ~ Xcov, data = data1, dist.junc = dist.junc,
  flow.matrix = flow.matrix,
  CorModel1 = "Spherical.taildown", CorModel2 = NULL, EstMeth = "ML")
SO4.out18 <- slm.stream(SO4_LAB ~ Xcov, data = data1, dist.junc = dist.junc,
  flow.matrix = flow.matrix,
  CorModel1 = "LinearSill.taildown", CorModel2 = NULL, EstMeth = "ML")

# compare model-fitting criteria
SO4.IC.out <- Info.crit.compare(
  list(
    SO4.out1, SO4.out2, SO4.out3, SO4.out4, SO4.out5, SO4.out6,
    SO4.out7, SO4.out8, SO4.out9, SO4.out10, SO4.out11, SO4.out12,
    SO4.out13, SO4.out14, SO4.out15, SO4.out16, SO4.out17, SO4.out18
  )
)

# look at variance components
parsil.up <- SO4.out14$Covariance.Parameters1[["parsil"]]
parsil.dn <- SO4.out14$Covariance.Parameters2[["parsil"]]
nugget <- SO4.out14$nugget
v.comp <- c(parsil.up, parsil.dn, nugget)/(parsil.up + parsil.dn + nugget)
names(v.comp) <- c("tail up", "tail down", "nugget")
barplot(v.comp, main = "Variance Components", col = "blue", cex.axis = 2,
  cex = 2, cex.main = 2)

# fixed effects table, use REML after selecting model
SO4.out10 <- slm.stream(SO4_LAB ~ Xcov, data = data1, dist.junc = dist.junc,
  flow.matrix = flow.matrix,
  CorModel1 = "LinearSill.tailup", CorModel2 = NULL, EstMeth = "REML")
SO4.out10$fixed.effects.estimates
SO4.out14 <- slm.stream(SO4_LAB ~ Xcov, data = data1, dist.junc = dist.junc,
  flow.matrix = flow.matrix,
  CorModel1 = "Exponential.tailup", CorModel2 = "LinearSill.taildown",
  EstMeth = "REML")
SO4.out14$fixed.effects.estimates

  
# model diagnostics
resids <- SO4.out14$fit
boxplot(resids[,"resid.student"], col = "blue",
  main = "Studentized Residuals", cex.main = 2, cex.axis = 2)
qqnorm(resids[,"cv.stndr"], col = "blue",
  main = "Standardized Cross-validation Residuals", cex.main = 1.5,
  pch = 19, cex = 3,
  cex.axis = 1.2, cex.lab = 1.5)

# predictions
preds <- SO4.out14$data
pred.graph.data <- preds[!is.na(preds[,"predictions"]),
  c("predictions", "pred.std.err")]
pred.graph.data <- cbind(pxy, pred.graph.data)
obs.graph.data <- preds[is.na(preds[,"predictions"]),
  "SO4_LAB"]
xy
win.graph()
plot(pred.graph.data[,c("x","y")], pch = 1,
  cex = pred.graph.data[,"predictions"]/4)
points(xy, pch = 19, cex = obs.graph.data/4)
win.graph()
plot(pred.graph.data[,c("x","y")], pch = 1,
  cex = pred.graph.data[,"pred.std.err"]/1)
points(xy, pch = 19, cex = obs.graph.data/4)

# block kriging predictions
segmentE <- c(30,155:164,187,197)
segmentF <- c(165:168,174:183)

slm.stream(SO4_LAB ~ Xcov, data = data1, dist.junc = dist.junc,
  flow.matrix = flow.matrix,
  CorModel1 = "Exponential.tailup", CorModel2 = "LinearSill.taildown",
  EstMeth = "REML", prediction.indices = segmentE)$block.krige
slm.stream(SO4_LAB ~ Xcov, data = data1, dist.junc = dist.junc,
  flow.matrix = flow.matrix,
  CorModel1 = "Exponential.tailup", CorModel2 = "LinearSill.taildown",
  EstMeth = "REML", prediction.indices = segmentF)$block.krige

