
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
cdffiles <- grep("xset", cdffiles, perl=TRUE, value=TRUE)
print(paste('Found the file',cdffiles, sep=" "))

for(i in 1:length(cdffiles)) load(cdffiles[[i]]) 

xset <- c(xset_a, xset_b, xset_c, xset_d, xset_e, xset_f, xset_g, xset_h) #paste full dataset together 
p_param <- SnowParam(mpi.universe.size()-1, type="MPI");
register(p_param)
ptm <- proc.time()
xset <- group(xset, bw=30)
time <- proc.time()-ptm
print(paste('Took', time[3] , 'to group samples', sep= " "))
ptm <- proc.time()
xset <- retcor(xset)
time <- proc.time()-ptm
print(paste('Took', time[3] , 'to retcor samples', sep= " "))
ptm <- proc.time()
xset <- group(xset, bw=10)
time <- proc.time()-ptm
print(paste('Took', time[3] , 'to group samples', sep= " "))
ptm <- proc.time()
xset <- fillPeaks(xset)
ptm <- proc.time()
time <- proc.time()-ptm
print(paste('Took', time[3] , 'to fillpeaks of samples', sep= " "))
save("xset",file="xset_proccessed.RData" )
