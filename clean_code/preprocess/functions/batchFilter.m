function [ idxCont ] = batchFilter( I, idxBatches, lowerThresh, upperThresh )
%BATCHFILTER Removes contaminants(based on batches) from the dataset
%   Algorithm:
%       1. Convert intensity matrix to a binary matrix. (all signals is 1,
%           no signal is 0).
%       2. For each batch
%           for each feature
%               a) calculate the fraction of samples in batch and non batch
%                  by taking the mean(mean of binary is fraction).
%               b) Mark contaminant if above minfrac in batch and 0 in non
%                  batch.
%   Input:
%       I(matrix) - Intensity values as doubles in matrix
%                   features as rows, samples as columns. Either log
%                   transformed or raw. Does not handle relative
%                   values.
%       minfrac(double) - atleast this fraction of samples in one batch
%                         contain this feature while no other samples 
%                         contain this feature.
%       idxBatches(cell array) - a cell array with lists of indicies. Each 
%                                list represents the indicies of one batch.
%   Output:
%       idxCont(list) - a list of indicies for features that are
%                       contaminants based on batches.
%
%   Implemented by NA 2017-03-03

%Convert intensity matrix to a binary matrix
I(I>0) = 1; 
I(I<=0) = 0;

%Find batch specific contaminants
idxCont = []; %Initalize
%For each batch
for i=1:length(idxBatches)
    idxBatch = idxBatches{i}; %get indicies for batch
    idxNonBatch = setdiff([1:size(I,2)], idxBatch); % all other samples
    %make sure there is atleast 3 samples in each class
    if(length(idxBatch)>2 && length(idxNonBatch)>2)
        numSampBatch = length(idxBatch);
        %Check features specific to batch
        for j=1:size(I,1)
            fracBatch = mean(I(j, idxBatch)); %mean of binary = frac available
            fracNonBatch = mean(I(j, idxNonBatch));
            if(fracBatch>upperThresh && fracNonBatch<lowerThresh)
                idxCont = [j, idxCont]; %Add them as contaminants
            end
        end
    end
end

end

