function [ dataClean ] = cleanData( data, dispFlag )
%CLEANINTMAT Cleans up 0 features and thresholds intensities
%   Algorithm:
%       1. Replace nan with 0 for I
%       2. Replace <thresh(0) with 0
%       3. Remove features(rows) with sum=0, 
%   Input:
%       data - structure with intensity, feature and sample info
%   Output:
%       dataClean - intensity matrix cleaned

cD_Tic = tic;

%parameter
thresh = 0; %Can be changed depending on data

dataClean = data;

I = data.I; %load intensity data
I(isnan(I)) = 0; %replace nan with 0
I(I<thresh) = 0; %don't allow value below thresh /set to 0
dataClean.I = I;
%Find all 0 features
featSum = sum(I'); %sum intensity for features across all samples
zeroFeat = find(featSum==0); %find all 0 features
if(not(isempty(zeroFeat)))
    dataClean = removeIdx(data, zeroFeat, 'feature', dispFlag); %remove them
end

cD_Toc = toc(cD_Tic);

if(dispFlag>0)
    disp(['---'])
    disp(['Cleaning data completed'])
    disp(['Elapsed time was: ' num2str(cD_Toc) 's'])
    disp(['Removed: ' num2str(numel(zeroFeat)) ' redundant features.'])
    disp(['---'])
end

end

