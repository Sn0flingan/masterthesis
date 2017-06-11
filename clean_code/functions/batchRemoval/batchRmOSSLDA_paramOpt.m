function [ Ibatch] = batchRmOSSLDA_paramOpt( dataProc, idxBatches )
%BATCHRMOSSLDA_PARAMOPT Removes batch effects using OSS-LDA, optimized
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
maxD = 50;
displayFlag=0;
d=maxD; % <----- set d PARAMETER

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
percVarLost = sum(varPerc((noSamp-ignoreDim+1):noSamp)); %calculate variance lost
disp(['Reduced space using PCA with ' num2str(noSamp-ignoreDim)...
    ' dimensions, which means last ' num2str(ignoreDim) ' dimensions '...
    'are ignored.'])
disp(['This means ' num2str(percVarLost) '% variance was lost.'])
%Parameter tune d

%Get QC info
qcIdxMebe = findSampleIdx(sMeta, 'Mebendazole'); %find Mebe idx
qcIdxCont = findSampleIdx(sMeta, 'Control'); %find Control idx
%Divide into batch info
for i=1:length(idxBatches)
    qcIdxm{i} = intersect(idxBatches{i}, qcIdxMebe);
    qcIdxc{i} = intersect(idxBatches{i}, qcIdxCont);
end

%Calculate score based on different latent dimensions (d)
scores = zeros(1,maxD); %Initalize
for j=1:maxD
    d=j;
    Xred = X-(BasisVectorsAsColumns(:,1:d)*ScoreValuesAsColumns(1:d,:));
    %Restore to original space
    for i=1:noSamp
        Xnew(:,i)= Imean + loadings(:,1:noSamp-ignoreDim)*Xred(:,i);
    end
    Xnew(Xnew<10) = 0;
    %Score calculations
    between_variance(j) = (bVariance(Xred, qcIdxm) + bVariance(Xred, qcIdxc))/2;
    scores(j) = (sepScore(Xred, qcIdxm)+sepScore(Xred, qcIdxc))/2;
end
% %Plot results of opt., both score and between variance
% figure
% plot(cumsum(ones(1,maxD)),scores); 
% ylabel('score')
% figure
% plot(cumsum(ones(1,maxD)),between_variance);
% ylabel('b')
% xlabel('d')

% Find optimal parameter d
for (i=1:maxD)
    t = between_variance(i)-between_variance(i+1); %Org:abs(scores(i+1)-scores(i)) Modified due to poor results 
    gain = t/between_variance(i);
    if (gain < 0.01)
        d=i;
        fprintf('Dimensionality for OOS-DA modeling: %d \n',i)
        break
    end
end
Xred = X-(BasisVectorsAsColumns(:,1:d)*ScoreValuesAsColumns(1:d,:));

%Restore to original space
for i=1:noSamp
    Ihat(:,i)= Imean + loadings(:,1:noSamp-ignoreDim)*Xred(:,i);
end
%Visualize split
% plotPCA(Ihat, splitId)
Ibatch = Ihat;

end