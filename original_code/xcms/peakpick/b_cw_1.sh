#!/bin/bash

#SBATCH -A p2013014
#SBATCH -p node
#SBATCH -n 1
#SBATCH -t 2:00:00
#SBATCH -J cw_1
#SBATCH -o cw_1.out

cd /proj/p2013014/nobackup/nils_xjob/stef_batch/xcms

module load R/3.3.2
module load openmpi

mpirun -n 1 R --no-save < cw_1.R
