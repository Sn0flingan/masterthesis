%%% Pipeline for batch removal
%General parameters
dispFlag = 1;
maxDimensions = 30; 
idxScoreClasses = {['list of indecies for 1st class'],...
    ['list of indecies for 2st class'], ['list of indecies for Nst class']};

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

%Calculate score for different dimensions
scoreSep = zeros(maxDimensions+1,1);
for i=0:maxDimensions
    dBatch = i;
    %Try to do batch removal, catch if there are errors and print warning
    %instead
    Ibatch = batchRmCOMBAT(data, idxBatches, dBatch);
    dataBatch = struct('I', Ibatch, 'sMeta', data.sMeta, 'fMeta',...
        data.fMeta);
    dataBatch = cleanData(dataBatch, 0);
    %Calculate score
    scoreSep(i+1) = sepScoreRobust_norm(dataBatch.I, idxScoreClasses);
    disp(['Seperation score is ' num2str(scoreSep(i+1))]);
end

%Display results
[valMax, idxMax] = max(scoreSep);
disp(['Highest seperation score found was ' num2str(valMax) '.' ...
    'This value was found at dimension ' num2str(idxMax-1) '.'])