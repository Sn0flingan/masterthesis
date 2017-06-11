function [ data ] = loadBinned(datafile)
%LOADBINNED loads in Binned data into common struct format
%   Assumes data is available in subfolder "data"
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

%Add nessecary subfolders are in path
addpath(genpath('data'))

%Load in data
load(datafile) %data is now in struct, RawData

%%% Extract to common format
I = [RawData.Spectra]; %Get intensities
sampleClass = {RawData.Name}; %Name without replicate info is class info
sampleRunOrder = [RawData.Run];  %Get runorder

%Restore full name
sampleBatch = {RawData.Batch}; 
sampleRep = {RawData.Rep};
divider = cell(1,199);
divider(:) = {'_'};
sampleName = cellfun(@strcat, sampleClass, divider, sampleBatch, divider...
    ,sampleRep, 'UniformOutput', 0);

%Compile all sample info into one table
sampleMeta = table(sampleName', sampleClass', sampleRunOrder',...
    'VariableNames', {'name', 'class', 'runorder'});

%create feature space
featMeta = table([1:size(I,1)]', 'VariableNames', {'featIdx'});

%Wrap into final structure
data = struct('I', I, 'sMeta', sampleMeta, 'fMeta', featMeta);



end

