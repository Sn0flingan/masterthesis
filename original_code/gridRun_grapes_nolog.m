%Grid calculations
clear all
close all

% %Add paths
addpath(genpath('functions'))
% 
% %Fixed Parameters (that could be optimized)
Tl = 0.01;
Tu = 0.1;
coThresh = 12; %log
minA = 0;
span = 0.7;
smParam = 1e-6;
bfThresh = 0.01;
bafLT = 0.2;
bafUT = 0.8;
%booleans
doLog = 1;
doCorrectRunorder = 0;
doCorrectCarryOver = 0;
doCyclicSpline = 1;
doBlankFilter = 0;
doBlankSub = 1;
doBatchFilter = 0;
dispFlag = 1;

% %Load in data
global data
data = loadXCMS('grapes');
% 
% %Preprocess
[ dataProc ] = preprocess_grape(data, Tl, Tu, coThresh, minA, span,...
    smParam, bfThresh, doLog, doCorrectRunorder,...
    doCorrectCarryOver, doCyclicSpline, doBlankFilter, doBlankSub,...
    dispFlag);

%Remove blanks and pools before split and batch removal
idxRm = [findSampleIdx(dataProc.sMeta, 'QC');...
    findSampleIdx(dataProc.sMeta, 'BLANK');...
    findSampleIdx(dataProc.sMeta, 'STDMIX')];
dataSamp = removeIdx(dataProc, idxRm, 'sample', dispFlag);

%Prepare for split and batch removal
%Find tissues
idxTissues = cell(3,1);
classNames = unique(dataSamp.sMeta.class(:));
for i=1:length(classNames)
    sample_idx = findSampleIdx(dataSamp.sMeta, classNames{i});
    %find out if b, p or s
    type = classNames{i}(end);
    origins{i} = classNames{i}(1:(end-1));
    if(type=='b')
        idxTissues{1} = [idxTissues{1}; sample_idx];
    elseif(type=='p')
        idxTissues{2} = [idxTissues{2}; sample_idx];
    elseif(type=='s')
        idxTissues{3} = [idxTissues{3}; sample_idx];
    else
        warning(['No type info found in ' classNames{i} '. Skipping assignment.'])
    end
end
origins = unique(origins);
for i=1:length(origins)
    idxOrigins{i} = findSampleIdx(dataSamp.sMeta, origins{i});
end

%%% Remove logarithm!!!
dataSampO = dataSamp;
dataSamp.I = exp(dataSamp.I);

%Perform batch/split removal in grid and calculate score
scoreSep = zeros(101,1);
tic
for i=0:100
    dBatch = i;
    %Try to do batch removal, catch if there are errors and print warning
    %instead
    try
        Ibatch = batchRmPLSDA(dataSamp, idxTissues, dBatch);
        %%%% RESTORE LOGARITHM
        %Ibatch(Ibatch<1) = 1;
        %Ibatch = log(Ibatch);
        dataBatch = struct('I', Ibatch, 'sMeta', dataSamp.sMeta, 'fMeta',...
                dataSamp.fMeta);
    catch ME
        warning(['Error in batchremoval: ' ME.message ...
            'Skipping batchremoval...']);
        dataBatch = dataSamp;
    end     
    %Calculate score
    try
        I = dataBatch.I;
        % Calculate score
        scoreSep(i+1) = sepScoreRobust_norm(I, idxOrigins);
        disp(['Seperation score is ' num2str(scoreSep(i+1))]);
    catch ME
        warning(['Error in score calc: ' ME.message ...
            '. Setting score to nan'])
        scoreSep(i+1) = nan;
    end
end
toc

%Plot results
figure()
plot(scoreSep)
title('Seperation Score')

%save results
save('sepScore_grape_pca_grid.mat','scoreSep');
