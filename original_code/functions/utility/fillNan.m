function [ dataFilled] = fillNan( data, dispFlag )
%FILLNAN Fill nan values with median value in replicates
%   Input:
%       data
%   Output:
%       dataFilled
%   Implemented by NA 2017-03-14

fN_tic = tic;

dataFilled = data;
%[rNan, cNan] = find(isnan(data.I)); %get row and columns for nan

%Extract replicate classes
classNames = unique(data.sMeta.class(:)); %extract classes

%For each class
for i=1:length(classNames)
    idx = findSampleIdx(data.sMeta, classNames{i}); %find replocates
    Irep = data.I(:,idx); %extract replicate data
    [rNan, cNan]= find(isnan(Irep)); %find nan values
    %Replace each nan with median replicate, nan if nan in all replicates
    for j=1:length(rNan)
        refI = median(Irep(rNan(j),:)); %get median of replicates (if nan set to nan)
        Irep(rNan(j), cNan(j)) = refI; %replace median with median of replicates 
    end
    dataFilled.I(:,idx) = Irep;
    if(dispFlag>1)
        disp(['Finished filling class ' classNames{i}])
    end
end

fN_toc = toc(fN_tic);

if(dispFlag>0)
    disp(['---'])
    disp(['Finnished filling nan values with replicate means.'])
    disp(['Elapsed time was: ' num2str(fN_toc) 's '])
    disp(['---'])
end
end

