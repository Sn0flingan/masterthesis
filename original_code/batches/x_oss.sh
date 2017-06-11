#!/bin/bash

#SBATCH -A p2013014
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 20:00:00
#SBATCH -J xOSS

module load matlab/R2016a

cd /proj/p2013014/nobackup/nils_xjob/stef_batch/functions-final

matlab -nodisplay -nosplash -nodesktop -r "try xcms_oss; catch ME; disp(ME.message); end; quit;"

