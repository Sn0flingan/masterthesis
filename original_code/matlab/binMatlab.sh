#!/bin/bash

#SBATCH -A p2013014
#SBATCH -p devel
#SBATCH -n 1
#SBATCH -t 1:00:00
#SBATCH -J binMatlab
#SBATCH -o bin_1.out

cd /proj/p2013014/nobackup/nils_xjob/stef_batch/matlab

module load matlab/R2016a

matlab -nodisplay -nosplash -nodesktop -r "binMatlab();"
