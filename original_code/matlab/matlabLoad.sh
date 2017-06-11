#!/bin/bash

#SBATCH -A p2013014
#SBATCH -p core
#SBATCH -n 6
#SBATCH -t 1:00:00
#SBATCH -J Vinblastine


cd /proj/p2013014/nobackup/nils_xjob/stef_batch

module load matlab/R2016a

matlab -nodisplay -nosplash -nodesktop -r "loadMzxml3('Vinblastine');"
