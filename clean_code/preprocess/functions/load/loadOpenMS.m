function [ data ] = loadOpenMS( intensityFile, runorderFile)
%LOADOPENMS loads in OpenMS data into common struct format
%   Assumes data is available in subfolder "data"
%       intensityFile should have sample in columns, with name in header
%       runorderFile should have name in column 2 and the rownum should
%       correspond to the runorder of that sample
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

%Add paths
addpath(genpath('data'))

%Load in intensities
intensities = readtable(intensityFile ,'TreatAsEmpty', {'NA'},'ReadRowNames',true);
I = intensities{:,:};
I(isnan(I))=0; %Don't use this if reproducing steffis pipeline

%Extract name info
names = intensities.Properties.VariableNames; %extract samplenames
%Remove "intensity_" part of names
for i=1:length(names)
    nameCmp = strsplit(names{i}, '_');
    names{i} = strjoin(nameCmp(2:length(nameCmp)),'_');
end

%Get runorder and class information
%Get runorder info and fix inconsistencies
sMeta = readtable(runorderFile); %parse file
%Fix inconsistency with Diuron sample name
for i=1:size(sMeta,1)
    sMeta{i,2} = strrep(sMeta{i,2},'.','_');
end

%Prepare sample meta table and add info
sampleMeta  = cell2table(cell(0,3), 'VariableNames', {'name', 'class', 'runorder'}); %create table to be filled
for i=1:length(names)
    runOrder = find(strcmp(sMeta{:,2},names{i})); %runorder=idx of sample
    nameCmp = strsplit(names{i},'_'); %split name to get class info
    class = nameCmp(1); %get class
    entry = {names{i}, class, runOrder};
    sampleMeta = [sampleMeta; entry];
end

%get featuredata
fMeta = table(intensities.Properties.RowNames, 'VariableNames', {'featIdx'}); %No other info than index available

data = struct('I', I, 'sMeta', sampleMeta, 'fMeta', fMeta);

end

