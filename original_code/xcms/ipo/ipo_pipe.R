
#Functions
loadPackage <- function(name, packSource){
    if(require(name)) {
        return(paste("loaded ", name, " SUCCESS", sep=""))
    } else {
        if(packSource=="biocLite") {
            source("https://bioconductor.org/biocLite.R")
            biocLite(name)
            require(name)
        } else if(packSource=="rietho") {
            loadPackage("devtools", "r-cran")
            library(devtools)
            install_github(paste("rietho", name, sep="/"))
            require(name) #might need to be replaced with library instead
        } else {
            install.packages(name, repos="https://cloud.r-project.org/")
            require(name)
        }
    }
}

#Load packages
loadPackage("xcms", "biocLite")
loadPackage("BiocParallel", "biocLite")
loadPackage("Rmpi", "r-cran")
loadPackage("CAMERA", "biocLite")
loadPackage("rsm", "r-cran")
loadPackage("devtools", "r-cran")
loadPackage("IPO", "rietho")
loadPackage("BatchJobs", "r-cran")

library("IPO")
library("BiocParallel")
library("Rmpi")
library("xcms")
library("rsm")
library("BatchJobs")

#Set up parallelization
#p_param <- SnowParam(mpi.universe.size()-1, type="MPI");
#register(p_param) #Is this needed?
register(BatchJobsParam(10))


#Set-up
slaves = 1 #Manually set number of slaves
setwd('/proj/p2013014/nobackup/nils_xjob/stef_batch/Obaid_mzml')
datapath <-"/proj/p2013014/nobackup/nils_xjob/stef_batch/Obaid_mzml"
datafiles <- list.files(datapath)
datafiles <- grep("Albenda|All_4_Pools", datafiles, perl=TRUE, value=TRUE)
print(paste('Found the file',datafiles, sep=" "))
optfiles <- datafiles[4:13] #Manually set which files are for optimization

ptm <- proc.time() #start clock

#Parameter optimization
peakp_params <- getDefaultXcmsSetStartingParams("matchedFilter")
print(peakp_params)
peakp_params$ppm <- 5 #according to Orbitrap Exacto spec.
peakp_params$nSlaves <- 1 
res_peakp <- optimizeXcmsSet(files=optfiles,
                             params=peakp_params,
                             nSlaves = slaves,
                             subdir = "optRes")
#opt_Xset <- res_peakp$best_settings$xset

time <- proc.time()-ptm
print(paste('Took', time[3] , 'to optimize samples', sep= " "))
save("res_peakp",file="peakpOpt1.RData" )
