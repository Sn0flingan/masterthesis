function [ dataProc ] = preprocess_grape(data, Tl, Tu, coThresh, minA, span,...
    smParam, bfThresh, doLog, doCorrectRunorder,...
    doCorrectCarryOver, doCyclicSpline, doBlankFilter, doBlankSub,...
    dispFlag)
%PREPROCESS Pipeline to preprocesses data
%   Preprocess functions being applied:
%           *blankfiltering - remove features that is above a threshold in
%                             the median of the blanks
%           *batchfiltering - remove features that are present in X % of 
%                             all samples in one batch but in non of the  
%                             other samples.
%           *logtransformation - replaces all intensity values with
%                                log(intensity). This reduces the effect of
%                                large differences in signal magnitude 
%                                across features.
%           *outlierremoval - remove samples with abnormaly high or low
%                             intensity values, indicating that something 
%                             mayor went wrong in the machine
%           *replicateOutliers - remove replicates that have a maximum
%                                correlation lower than a set threshold.
%           *cyclicSmoothSplines - adjust technical variation in intensity
%                                  between samples.
%       dispFlag - 0 - no output
%                   1- results
%                   2- results and progress
%   Input:
%       data(struct) - with entries; I, sMeta, fMeta.
%                           I(mat)      Intensity data with features as 
%                                       rows and columns as samples. No
%                                       'nan' are allowed (set to 0 before)
%                           sMeta(tbl)  Metadata about samples, with name, 
%                                       class and runorder as variables.
%                                       (batches should be marked "B*")
%                                       (blanks should be marked "BLANK")
%                           fMeta(tbl)  Metadata about features, with m/z
%                                       values for each bin
%   Output:
%       dataProc(struct) - Same structure as "data", but with changed
%       values after preprocessing functions have been applied
%
%   Implemented by NA 2017-03-03

%%%%%%%%%%%%%%%%%%%%-- USER DEFINED PARAMETERS --%%%%%%%%%%%%%%%%%%%%%%%%%
%Parameters
% Tl = 0.01;
% Tu = 0.1;
% coThresh = 12; %log
% minA = 10;
% span = 0.7;
% smParam = 0.001;
% bfThresh = 0.01;
% bafLT = 0.2;
% bafUT = 0.8;
% %booleans
% doLog = 1;
% doCorrectRunorder = 1;
% doCorrectCarryOver = 1;
% doCyclicSpline = 1;
% doBlankFilter = 0;
% doBlankSub = 1;
% doBatchFilter = 0;
%Non optimizable
numStd = 3;
minCorr = 0.8;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%-- PIPELINE -- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Add nessecary path to functions
addpath(genpath('functions')); %Make sure functions are available

data0 = cleanData(data , dispFlag);%make sure data is clean

%Log transform
if(doLog)
    try
        Ilog = logIntensities(data0.I, dispFlag);
        data1 = struct('I', Ilog, 'sMeta',...
            data0.sMeta, 'fMeta', data0.fMeta);
    catch ME
        warning(['Error in log transformation: ' ME.message])
        warning(['Skipping log transformation...'])
        data1 = data0;
    end
else
    data1=data0;
end
data1 = cleanData(data1, dispFlag);

%Correct for runorder variation
if(doCorrectRunorder)
    try
        %Find tissues
        idxClass = cell(3,1);
        classNames = unique(data1.sMeta.class(:));
        for i=1:length(classNames)
            sample_idx = findSampleIdx(data1.sMeta, classNames{i});
            %find out if b, p or s
            type = classNames{i}(end);
            if(type=='b')
                idxClass{1} = [idxClass{1}; sample_idx];
            elseif(type=='p')
                idxClass{2} = [idxClass{2}; sample_idx];
            elseif(type=='s')
                idxClass{3} = [idxClass{3}; sample_idx];
            else
                warning(['No type info found in ' classNames{i} '. Skipping assignment.'])
            end
        end
        Icor = data1.I;
        Icor(:,idxClass{1}) = correctRunorderDecay(Icor(:,idxClass{1}),...
            data1.sMeta.runorder(idxClass{1}), dispFlag); % don't use blanks
        Icor(:,idxClass{2}) = correctRunorderDecay(Icor(:,idxClass{2}),...
            data1.sMeta.runorder(idxClass{2}), dispFlag); % , dispFlagdon't use blanks
        Icor(:,idxClass{3}) = correctRunorderDecay(Icor(:,idxClass{3}),...
            data1.sMeta.runorder(idxClass{3}), dispFlag); %, dispFlagdon't use blanks
        data2 = struct('I', Icor, 'sMeta',...
            data1.sMeta, 'fMeta', data1.fMeta);
    catch ME
        warning(['Error in runorder correction: ' ME.message])
        warning(['Skipping runorder correction...'])
        data2 = data1;
    end
else
    data2=data1;
end
data2 = cleanData(data2, dispFlag);

%Find and adjust for carry over effects
if(doCorrectCarryOver)
    try
        Icorr = correctCarryOver(data2.I, data2.sMeta.runorder, Tl, Tu,...
            coThresh, dispFlag);
        data3 = struct('I', Icorr, 'sMeta',...
            data2.sMeta, 'fMeta', data2.fMeta);
        data3 = fillNan(data3, dispFlag);
    catch ME
        warning(['Error in carry over correction: ' ME.message])
        warning(['Skipping carry over correction...'])
        data3 = data2;
    end
else
    data3 = data2;
end
data3 = cleanData(data3, dispFlag);

%Normalize remaining systematic technical variation between samples
if(doCyclicSpline)
    try
        %Find tissues
        idxClass = cell(3,1);
        classNames = unique(data3.sMeta.class(:));
        for i=1:length(classNames)
            sample_idx = findSampleIdx(data3.sMeta, classNames{i});
            %find out if b, p or s
            type = classNames{i}(end);
            if(type=='b')
                idxClass{1} = [idxClass{1}; sample_idx];
            elseif(type=='p')
                idxClass{2} = [idxClass{2}; sample_idx];
            elseif(type=='s')
                idxClass{3} = [idxClass{3}; sample_idx];
            else
                warning(['No type info found in ' classNames{i} '. Skipping assignment.'])
            end
        end
        %Correct for each tissue individually
        Icor = data3.I;
        Icor(:,idxClass{1}) = cyclicSmoothSpline_2(data3.I(:,idxClass{1}), minA, smParam, dispFlag);
        Icor(:,idxClass{2}) = cyclicSmoothSpline_2(data3.I(:,idxClass{2}), minA, smParam, dispFlag);
        Icor(:,idxClass{3}) = cyclicSmoothSpline_2(data3.I(:,idxClass{3}), minA, smParam, dispFlag);
        data4 = struct('I', Icor, 'sMeta', data3.sMeta,...
            'fMeta', data3.fMeta);
    catch ME
        warning(['Error in cyclic spline normalization: ' ME.message])
        warning(['Skipping cyclic spline normalization...'])
        data4 = data3;
    end
else
    data4 = data3;
end
data4 = cleanData(data4, dispFlag);

%Remove features used in blanks
if(doBlankFilter)
    try
        idxCont = blankFilter(data4, bfThresh, dispFlag);
        data5 = removeIdx(data4, idxCont, 'feature', dispFlag);
    catch ME
        warning(['Error in blank filtering: ' ME.message])
        warning(['Skipping blank filtering...'])
        data5 = data4;
    end
else
    data5 = data4;
end
data5 = cleanData(data5, dispFlag);

%Subtract blank background from all features
if(doBlankSub)
    try
        Iclean = data5.I;
        idxBlanks = [findSampleIdx(data5.sMeta, 'BLANK');...
            findSampleIdx(data5.sMeta, 'STDMIX')];
        idxSamples = setdiff([1:size(Iclean,2)], idxBlanks);
        Iclean(:,idxSamples) = blankSubtraction_2(data5.I(:,idxSamples),...
            data5.I(:,idxBlanks), dispFlag);
        data6 = struct('I', Iclean, 'sMeta', data5.sMeta,...
            'fMeta', data5.fMeta);
    catch ME
        warning(['Error in blank subtraction on line ' num2str(ME.stack.line)...
            ': ' ME.message...
            char(10) 'Skipping blank subtraction...'])
        data6 = data5;
    end
else
    data6 = data5;
end
data6 = cleanData(data6, dispFlag);

data7 = data6;
data7 = cleanData(data7, dispFlag);

%------- Do not optimize the following!---------

%Remove outliers by total ion count(TIC)
try
    %Find tissues
    idxClass = cell(3,1);
    classNames = unique(data3.sMeta.class(:));
    for i=1:length(classNames)
        sample_idx = findSampleIdx(data3.sMeta, classNames{i});
        %find out if b, p or s
        type = classNames{i}(end);
        if(type=='b')
            idxClass{1} = [idxClass{1}; sample_idx];
        elseif(type=='p')
            idxClass{2} = [idxClass{2}; sample_idx];
        elseif(type=='s')
            idxClass{3} = [idxClass{3}; sample_idx];
        else
            warning(['No type info found in ' classNames{i} '. Skipping assignment.'])
        end
    end
    idxOutlier = [];
    for i=1:3
        tIC = sum(data7.I(:,idxClass{i}))'; %Sum all intensities/sample
        idxOutlier_t = find(abs(tIC-median(tIC))>medianStd(tIC)*numStd); %find samples outside x std
        idxOutlier = [idxOutlier; idxClass{i}(idxOutlier_t)];
    end
    disp(['Outlier TIC: Removing ' num2str(length(idxOutlier)) ' samples.'])
    data8 = removeIdx(data7, idxOutlier, 'sample', dispFlag);
catch ME
   warning(['Error in outlier by TIC: ' ME.message])
   warning(['Skipping outlier by TIC...'])
   data8 = data7;
end
data8 = cleanData(data8, dispFlag);

%Replicate check
try
    %Extract replicate classes
    classNames = unique(data8.sMeta.class(:)); %extract classes
    %Check correlation
    idxRm = [];
    for i=1:length(classNames)
        idx = findSampleIdx(data8.sMeta, classNames{i});
        idxRm = [idxRm; corrFilter(data8.I, idx, minCorr)];
    end
    data9 = removeIdx(data8, idxRm, 'sample', dispFlag);
catch ME
    warning(['Error in replicate similarity: ' ME.message])
    warning(['Skipping replicate similarity...'])
    data9 = data8;
end
data9 = cleanData(data9, dispFlag);

%Finnished, save to output
dataProc = data9;
end
