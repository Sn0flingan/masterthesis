function [ Ibatch] = batchRmPLSDA( dataProc, idxBatches, d )
%BATCHRMPLSDA_PARAMOPT Removes batch effects using PLSDA, optimized
%parameters
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
%   Output
%       Ibatch
%
%   Implemented by NA 2017-03-06

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% OSS-LDA Batch effect removal %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Local variable names
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

%PLS-DA
Y = zeros(size(I,2),length(idxBatches));
for i=1:length(idxBatches)
    Y(idxBatches{i}, i) = 1;
end
[XL, ~, XS, ~] = plsregress(I',Y, d);

Xred = I-(XL*XS');
Xred(Xred<Ithresh) = 0;

Ibatch = Xred;

end