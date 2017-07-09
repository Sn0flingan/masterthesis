function [ Ibatch] = batchRmCOMBAT( dataProc, idxBatches, d )
%BATCHRMPCA_PARAMOPT Removes batch effects using PCA
%   Algorithm:
%   Data assumptions:
%   Input:
%       dataProc(struct) - with atleast I, sMeta
%                       I(matrix) - Intensity values as doubles in matrix
%                       features as rows, samples as columns. Either log
%                       transformed or raw. Does not handle relative
%                       values.
%                       sMeta - Table with names of samples in first column
%       idxBatches(cell array) - cell array with each element containing idx
%                              of one of the batches.
%   Output:
%       Ibatch
%
%   Implemented by NA 2017-03-06

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% OSS-LDA Batch effect removal %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Local variable names
dataProc = cleanData(dataProc,1);
I = dataProc.I;
sMeta = dataProc.sMeta;

%%Check so data looks ok for running OSSLDA
%Check size of batches
sizeBatches = cellfun('length', idxBatches);
sizeSmallestBatch = min(sizeBatches);
%If lower than 1 dimensions don't do OSS-LDA
if(d<1)
    Ibatch = I;
    return
elseif(sizeSmallestBatch<3)
    warning(['Atleast one batch contains less than 3 samples. Aborting batch removal.'])
    Ibatch = I;
    return
end

%Get lowest value to use as lower threshold
Ithresh = min(I(I>0));

cd functions/batchRemoval

%Make sure no old files intercept
delete 'data_batch.csv'
delete 'batch_batch.csv'
delete 'batchCorr_combat.csv'
pause(3)

%Store indecies in COMBAT friendly format
batchId = ones(1,size(I,2));
for i=1:length(idxBatches)
    batchId(idxBatches{i}) = i;
end

%Save data to CSV
csvwrite('data_batch.csv', I)
csvwrite('batch_batch.csv', batchId')
pause(10)

%Run R script
executed = system('R CMD BATCH /media/nils/DC30-A7F1/functions-final/functions/batchRemoval/batchRmCOMBAT.R')

%Load in data
if(executed==0)
    %Load in new data
    Ibatch = csvread('batchCorr_combat.csv', 1);
else
    error('Failed executing R-script when using Combat.')
end

Ibatch(Ibatch<Ithresh) = 0;

cd ../..

end