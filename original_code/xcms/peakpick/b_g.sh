#!/bin/bash

#SBATCH -A p2013014
#SBATCH -p node
#SBATCH -n 16
#SBATCH -t 1:00:00
#SBATCH -J g
#SBATCH -o g.out

cd /proj/p2013014/nobackup/nils_xjob/stef_batch/xcms

module load R/3.3.2
module load openmpi

mpirun -n 1 R --no-save < xcms_load_g.R
