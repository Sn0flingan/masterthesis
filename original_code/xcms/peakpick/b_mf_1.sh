#!/bin/bash

#SBATCH -A p2013014
#SBATCH -p devel
#SBATCH -n 1
#SBATCH -t 1:00:00
#SBATCH -J mf_1
#SBATCH -o mf_1.out

cd /proj/p2013014/nobackup/nils_xjob/stef_batch/xcms

module load R/3.3.2
module load openmpi

mpirun -n 1 R --no-save < mf_1.R
