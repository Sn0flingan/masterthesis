#### Runfile to correct for batcheffects
#Install
#source("https://bioconductor.org/biocLite.R")
#biocLite("sva")

#Load libraries
library(sva)

rm(list=ls())
setwd("/media/nils/DC30-A7F1/functions-final/functions/batchRemoval")

#Load in data
edata = read.csv("data_batch.csv", header=FALSE)
batch = read.csv("batch_batch.csv", header=FALSE)
batch = as.matrix(batch)
batch = as.double(batch)
edata = as.matrix(edata)

#Create model for Combat, using only intercept as adjustment variables
d <- data.frame(x=array(1,c(length(batch),1)))
modcombat = model.matrix(~1,data=d)
rm(d)

#Perform Combat batch removal
combat_edata = ComBat(dat=edata, batch=batch, mod=modcombat, par.prior=TRUE, prior.plots=FALSE)

#Save output
write.csv(combat_edata, file = "batchCorr_combat.csv", row.names=FALSE, col.names = FALSE)
