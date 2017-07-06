## Load required packages (make sure you have them all pre-installed)
require("xcms")

pathToMzmlFiles <- 'string/with/path/to/sample/files'
sampleClassMeta <- c('ClassNameOfSample1','ClassNameOfSample2', 'ClassNameOfSampleN') #Must be same order as files are listed in the path

## Peak identification
#xcmsSet will take time for large datasets, consider parallizing it using xcms_pipe_parallelized.R if that is the case
peakPickedSamp <- xcmsSet(pathToMzmlFiles, sclass = sampleClassMeta, method="matchedFilter") #Adjust method(matchedFilter for profile mode, centWave for centroid mode) and parameters to your liking

## Group and correct for retention time shifts
groupedSamp <- group(peakPickedSamp, bw=30) #Adjust parameters to your liking
groupedSamp <- retcor(groupedSamp)
groupedSamp <- group(groupedSamp, bw=10) #Make sure bw is lower here than in the initial grouping

## Fill in missing peak areas according to raw data
#This takes time for large datasets
featExtSamp <- fillPeaks(groupedSamp)

## Save result for later use in preprocessing
nameOfOutputFile = "path/and/nameOfOutputFile.RData"
save("featExtSamp",file=nameOfOutputFile )
