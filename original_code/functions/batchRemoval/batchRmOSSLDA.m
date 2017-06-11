function [ Ibatch] = batchRmOSSLDA( dataProc, idxBatches, d )
%BATCHRMOSSLDA_PARAMOPT Removes batch effects using OSS-LDA
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
%       d(int) - number of latent dimension in OSSLDA
%   Output
%       Iorg
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

%Store indecies in OSS-LDA friendly format
batchId = ones(1,size(I,2));
for i=1:length(idxBatches)
    batchId(idxBatches{i}) = i;
end


%reduce dimensionality with PCA to prevent singularity of within/between
%matrix
[loadings, ~, ~, ~, varPerc, ~] = pca(I','Centered','off');
noSamp = size(I,2);
Imean = mean(I')';

%Parameters for OSSLDA
displayFlag=0;

%OSS-LDA + PCA reduction
s = warning('error', 'MATLAB:nearlySingularMatrix'); %Convert singularity warning to error to be able to catch it
ignoreDim=-1; %Start by ignoring no dimensio (-1 due to order of code in try)
cond=true;
while(cond)
    %Remove 1 dim at a time until singularity no longer thrown.
    try
        ignoreDim = ignoreDim +1;
        %Since different num of loading vectors are used, X will change dim
        clear X 
        for i=1:noSamp
            X(:,i)=loadings(:,1:noSamp-ignoreDim)'*(I(:,i)-Imean);
        end
        [BasisVectorsAsColumns,ScoreValuesAsColumns] = osslda(X,batchId,d,displayFlag);
        cond=false;
    end
end

try
percVarLost = sum(varPerc((noSamp-ignoreDim+1):noSamp)); %calculate variance lost
disp(['Reduced space using PCA with ' num2str(noSamp-ignoreDim)...
    ' dimensions, which means last ' num2str(ignoreDim) ' dimensions '...
    'are ignored.'])
disp(['This means ' num2str(percVarLost) '% variance was lost.'])
catch
end

Xred = X-(BasisVectorsAsColumns*ScoreValuesAsColumns);

%Restore to original space
for i=1:noSamp
    Ihat(:,i)= Imean + loadings(:,1:noSamp-ignoreDim)*Xred(:,i);
end
Ihat(Ihat<Ithresh) = 0;
Ibatch = Ihat;

end
