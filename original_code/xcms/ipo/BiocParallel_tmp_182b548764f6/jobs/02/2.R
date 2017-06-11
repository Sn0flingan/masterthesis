Sys.sleep(0.000000)
options(BatchJobs.on.slave = TRUE, BatchJobs.resources.path = '/pica/w1/p2013014_nobackup/nils_xjob/stef_batch/xcms/ipo//BiocParallel_tmp_182b548764f6/resources/resources_1487075541.RData')
library(checkmate)
library(BatchJobs)
res = BatchJobs:::doJob(
	reg = loadRegistry('/pica/w1/p2013014_nobackup/nils_xjob/stef_batch/xcms/ipo//BiocParallel_tmp_182b548764f6'),
	ids = c(2L),
	multiple.result.files = FALSE,
	disable.mail = FALSE,
	first = 8L,
	last = 4L,
	array.id = NA)
BatchJobs:::setOnSlave(FALSE)