#!/bin/bash

#SBATCH -A p2013014
#SBATCH -p node
#SBATCH -n 11
#SBATCH -t 6:00:00
#SBATCH -J ipo
#SBATCH -o ipo_batch.out

cd /proj/p2013014/nobackup/nils_xjob/stef_batch/xcms/ipo

module load R/3.3.2
module load openmpi

mpirun -n 1 R --no-save < ipo_pipe.R
