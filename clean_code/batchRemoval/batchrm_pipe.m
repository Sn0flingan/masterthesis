%%% Pipeline for batch removal
%General parameters
dispFlag = 1;
dimBatch = 1;

%Add path to functions
addpath(genpath('functions'));

%Load in the preprocessed data
load('preprocessedData.mat') %Make sure it is saved as data

%Remove samples that might affect results(blanks, pools, qc)
idxRm = [findSampleIdx(data.sMeta, 'Pool');...
    findSampleIdx(data.sMeta, 'BLANK')];
data = removeIdx(data, idxRm, 'sample', dispFlag);

%Identify the batches
idxB1 = findSampleIdx(data.sMeta, 'B1');
idxB2 = findSampleIdx(data.sMeta, 'B2');
idxB3 = findSampleIdx(data.sMeta, 'B3');
idxB4 = findSampleIdx(data.sMeta, 'B4');
idxBatches = {idxB1, idxB2, idxB3, idxB4};

%Perform batchremoval
Ibatch = batchRmPLSDA(data, idxBatches, dimBatch);
data = struct('I', Ibatch, 'sMeta', data.sMeta, 'fMeta',...
    data.fMeta);