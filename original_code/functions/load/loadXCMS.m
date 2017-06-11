function [ data ] = loadXCMS(type)
%LOADXCMS loads in XCMS data into common struct format
%   Assumes data is available in subfolder "data" with names
%       "xcms-groupidx.csv"
%       "xcms-groups.csv"
%       "xcms-meta.csv"
%       "xcms-peaks.csv"
%   Also needs runorder information!
%   Output:
%       data(struct) - with entries; I, sMeta, fMeta.
%                           I(mat)      Intensity data with features as 
%                                       rows and columns as samples.
%                           sMeta(tbl)  Metadata about samples, with name, 
%                                       class and runorder as variables.
%                           fMeta(tbl)  Metadata about features, with m/z
%                                       values for each bin
%
%   Implemented by NA 2017-03-03

%add nessecary subfolders to path
if(strcmp(type,'grapes'))
    addpath('data/grapes')
else
    addpath('data/drugs')
end
    

%Load in csv files
groupidx = readtable('xcms-groupidx.csv','TreatAsEmpty', {'NA'}, 'ReadRowNames', true);
groups = readtable('xcms-groups.csv','TreatAsEmpty', {'NA'}, 'ReadRowNames', true);
peaks = readtable('xcms-peaks.csv','TreatAsEmpty', {'NA'}, 'ReadRowNames', true);
meta = readtable('xcms-meta.csv', 'ReadRowNames', false);
meta.Properties.VariableNames{'Var1'} = 'name';

%Extract runorder
runorder = [1:size(meta,1)];
%Add it to meta table
meta = [meta table(runorder', 'VariableNames', {'runorder'})];

%fix classname problems
for i=1:size(meta,1)
    className =meta.class{i};
    classNameContainsReplicateInfo = ...
        all(ismember(className(end),'0123456789'));
    if(classNameContainsReplicateInfo)
        meta.class{i} = className(1:(end-1));
    end
end

%Extract intensity values into I
numGroups = size(groupidx,1);
numSamples = size(meta,1);
I = zeros(numGroups,numSamples);
for i=1:numGroups
    groupidxAsMat = table2array(groupidx(i,:));
    groupidxAsMat(isnan(groupidxAsMat)) = []; %Trix for stupid formating from R
    if(strcmp(type,'grapes'))
        I_group = peaks.into(groupidxAsMat);
    else
        I_group = peaks.intf(groupidxAsMat); %Apperently into is more common but results are bad when using into
    end
    I_sample = peaks.sample(groupidxAsMat);
    for j=1:length(I_sample)
        if(~isnan(I_group(j)))
            I(i,I_sample(j)) = I(i,I_sample(j)) + I_group(j);
        end
    end
end

%Wrap data into struct for output
data = struct('I', I, 'sMeta', meta, 'fMeta', groups);


end

