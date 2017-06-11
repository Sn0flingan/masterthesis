#!/bin/bash

#SBATCH -A p2013014
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 0:20:00
#SBATCH -J Binner


cd /proj/p2013014/nobackup/nils_xjob/stef_batch

module load matlab/R2016a

matlab -nodisplay -nosplash -nodesktop -r "binner('PoolBatch4/2');"
