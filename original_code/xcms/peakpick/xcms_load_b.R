
#Load packages
if(require("xcms")) {
    print("xcms loaded correctly")
} else {
    source("https://bioconductor.org/biocLite.R")
    biocLite("xcms")
    #install.packages("xcms")
    if(require("xcms")) {
        print("xcms installed and loaded")
    } else {
        stop("could not install xcms")
    }
}
if(require("BiocParallel")) {
} else {
    source("https://bioconductor.org/biocLite.R")
    biocLite("BiocParallel")
    #install.packages("xcms")
    if(require("BiocParallel")) {
        print("BiocParallel installed and loaded")
    } else {
        stop("could not install BiocParallel")
    }
}
if(require("Rmpi")) {
    print("Rmpi loaded correctly")
} else {
    install.packages("Rmpi", repos="https://cloud.r-project.org/")
    if(require("Rmpi")) {
        print("Rmpi installed and loaded")
    } else {
        stop("could not install Rmpi")
    }
}


setwd('/proj/p2013014/nobackup/nils_xjob/stef_batch/Obaid_mzml')
cdfpath <-"/proj/p2013014/nobackup/nils_xjob/stef_batch/Obaid_mzml"
cdffiles <- list.files(cdfpath)
cdffiles <- grep("BLANK|Borte", cdffiles, perl=TRUE, value=TRUE)
print(paste('Found the file',cdffiles, sep=" "))


p_param <- SnowParam(mpi.universe.size()-1, type="MPI");
ptm <- proc.time()
sclasses <- c(array("BLANK", 25), array("Bortezomib", 3))
xset_b <- xcmsSet(cdffiles, sclass=sclasses, method="matchedFilter", BPPARAM=p_param)
time <- proc.time()-ptm
print(paste('Took', time[3] , 'to scan samples', sep= " "))
save("xset_b",file="xset_b.RData" )
