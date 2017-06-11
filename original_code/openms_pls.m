%Grid calculations
clear all
close all

%Add paths
addpath(genpath('functions'))

%Fixed Parameters (that could be optimized)
Tl = 0.01;
Tu = 0.1;
coThresh = 12; %log
minA = 10;
span = 0.7;
smParam = 1e-6;
bfThresh = 0.01;
bafLT = 0.2;
bafUT = 0.8;
%booleans
doLog = 1;
doCorrectRunorder = 1;
doCorrectCarryOver = 0;
doCyclicSpline = 0;
doBlankFilter = 1;
doBlankSub = 0;
doBatchFilter = 0;
dispFlag = 1;

%Load in data
global data
data = loadOpenMS('OpenMS-intensities.csv', 'OpenMS-runorder.csv');
%data = loadBinned('structBinData.mat');
%data = loadXCMS();
%Preprocess
[ dataProc ] = preprocess(data, Tl, Tu, coThresh, minA, span,...
    smParam, bfThresh, bafLT, bafUT, doLog, doCorrectRunorder,...
    doCorrectCarryOver, doCyclicSpline, doBlankFilter, doBlankSub,...
    doBatchFilter, dispFlag);

%Remove blanks and pools before split and batch removal
idxRm = [findSampleIdx(dataProc.sMeta, 'Pool');...
    findSampleIdx(dataProc.sMeta, 'BLANK')];
dataSamp = removeIdx(dataProc, idxRm, 'sample', dispFlag);

%Prepare for split and batch removal
idxB1 = find(dataSamp.sMeta.runorder<95);
idxB2 = find(dataSamp.sMeta.runorder>94);
idxSplit = {idxB1, idxB2};
idxB1 = findSampleIdx(dataSamp.sMeta, 'B1');
idxB2 = findSampleIdx(dataSamp.sMeta, 'B2');
idxB3 = findSampleIdx(dataSamp.sMeta, 'B3');
idxB4 = findSampleIdx(dataSamp.sMeta, 'B4');
idxBatches = {idxB1, idxB2, idxB3, idxB4};

%Perform batch/split removal in grid and calculate score
scoreSep = zeros(51);
tic
for i=0:10
    dBatch = i;
    %Try to do batch removal, catch if there are errors and print warning
    %instead
    try
        Ibatch = batchRmPLSDA(dataSamp, idxBatches, dBatch);
        dataBatch = struct('I', Ibatch, 'sMeta', dataSamp.sMeta, 'fMeta',...
                dataSamp.fMeta);
    catch ME
        warning(['Error in batchremoval: ' ME.message ...
            'Skipping batchremoval...']);
        dataBatch = dataSamp;
    end
    for j=0:50
        dSplit = j;
        %Try to do split removal, catch if there are errors and print warning
        %instead
        try
            Isplit = batchRmPLSDA(dataBatch, idxSplit, dSplit);
        catch ME
            warning(['Error in splitremoval: ' ME.message ...
                'Skipping splitremoval...'])
            Isplit = dataBatch.I;
        end
        
        %Calculate score
        try
            I = Isplit;
            %Get index of classes to compare
            idxC = findSampleIdx(dataBatch.sMeta, 'Control');
            idxO = findSampleIdx(dataBatch.sMeta, 'Mebendazole');
            %Make sure each class has more than 3 samples
            if(or(length(idxC)<=3,length(idxO)<=3))
                warning(['Too small control or other samples, setting sepscore to nan'])
                scoreSep(i+1,j+1) = nan;
            else
                %Iterate score for stability
                for k=1:10
                    % Balance classes with weights
                    weights = getWeights(size(I,2), idxC, idxO);
                    Ib = I*weights; %create balanced I
                    % Set up class info
                    classSize = size(weights,2)/2;
                    idxClasses = {[1:classSize], [(classSize+1):classSize*2]};
                    % Calculate score
                    scoreSepPerm(k) = sepScoreRobust_norm(Ib, idxClasses);
                end
                scoreSep(i+1,j+1) = mean(scoreSepPerm);
                stdScore(i+1,j+1) = std(scoreSepPerm);
                disp(['Seperation score is ' num2str(scoreSep(i+1,j+1)) '+-' num2str(stdScore(i+1,j+1))]);
            end
        catch ME
            warning(['Error in score calc: ' ME.message ... 
                '. Setting score to nan'])
            scoreSep(i+1,j+1) = nan;
        end
    end
end
toc

%Plot results
%figure()
%imagesc(scoreSep)
%colorbar()
%title('Seperation Score')


%save results
sepScore_o_pls = scoreSep;
save('../results/sepScore_norm_o_pls.mat','sepScore_o_pls');