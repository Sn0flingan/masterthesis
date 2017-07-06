# masterthesis
Files and code for my masterthesis project. The code is supplied both in the raw format, as used in the actual project, and in an user friendly format to make reproducing the project or re-using the code easier. Below follows instructions and guidelines for using the user friendly code.

## User friendly code
The processing is done in 3 steps: feature extraction, preprocessing and batch removal. Each step must be executed seperatly.

### Feature extraction
Path to files: functions/featext

There are 2 options, using "binning" in Matlab or XCMS in R

#### Binning in Matlab
File: binningMZ.m

This is setup as an Matlab function that process one sample file at the time. Hence if you want to bin several samples you will have to setup a sample piece of code to do this.

### XCMS in R
File: xcms_pipe.R or xcms_pipe_parallellized.R

This is a simple runfile. However make sure to go into the file and adjust paths and parameters where it is needed. Then just run the file. For large dataset use the parallellized version. 

### Preprocessing


### Batch removal

