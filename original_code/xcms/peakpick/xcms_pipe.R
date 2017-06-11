
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
    install.packages("Rmpi")
    if(require("Rmpi")) {
        print("Rmpi installed and loaded")
    } else {
        stop("could not install Rmpi")
    }
}


setwd('/proj/p2013014/nobackup/nils_xjob/stef_batch/Obaid/All_4_Pools/All_4_Pools')
cdfpath <-"/proj/p2013014/nobackup/nils_xjob/stef_batch/Obaid/All_4_Pools/All_4_Pools"
cdffiles <- list.files(cdfpath)
print(paste('Found the file',cdffiles, sep=" "))


p_param <- SnowParam(mpi.universe.size()-1, type="MPI");
register(p_param) #Is this needed?
ptm <- proc.time()
xset <- xcmsSet(cdffiles, BPPARAM=p_param)
time <- proc.time()-ptm
print(paste('Took', time[3] , 'to scan samples', sep= " "))
save("xset",file="all4pools.RData" )
