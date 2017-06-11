function [ Ibatch] = batchRmPCA_paramOpt( dataProc, idxBatches )
%BATCHRMPCA_PARAMOPT Removes batch effects using PCA, optimized
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

%PCA
maxD = 50;
[XL, XS, latent] = pca(I');

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
    Xred = I-(XL(:,1:d)*XS(:,1:d)');
    Xred(Xred<10) = 0;
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
        fprintf('Dimensionality for PLS-DA modeling: %d \n',i)
        break
    end
end
Xred = I-(XL(:,1:d)*XS(:,1:d)');
Xred(Xred<10) = 0;

Ibatch = Xred;

end