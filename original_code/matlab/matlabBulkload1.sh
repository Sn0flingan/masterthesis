#!/bin/bash

#SBATCH -A p2013014
#SBATCH -p core
#SBATCH -n 16
#SBATCH -t 1:00:00
#SBATCH -J matlab_Bulkload1


cd /proj/p2013014/nobackup/nils_xjob/stef_batch

matlab -nodisplay -nosplash -nodesktop -r "run simpleLoadMatlab.m;"
