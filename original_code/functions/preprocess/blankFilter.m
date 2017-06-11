function [idxCont] = blankFilter(data, thresh, dispFlag)
%BLANKFILTER Removes contaminants(based on blanks) from the dataset
%   Algorithm:
%       1. Calculate median of each feature using only blanks
%       2. Calculate max intensity of each features using all samples
%       3. Find features where medianBlanks/maxIntensity is larger than
%          thresh. Consider these to be contaminants.
%   Data assumptions:
%       -Assumes that blank samples are named "*BLANK*" in the sMeta info of
%       input data.
%       -If mean maximum intensity is lower then 100 the data is assumed to 
%       have been log transformed (which means that a slightly different 
%       formula will be used). A warning will also be sent.
%   Input:
%       data(struct) - with atleast I, sMeta
%                       I(matrix) - Intensity values as doubles in matrix
%                       features as rows, samples as columns. Either log
%                       transformed or raw. Does not handle relative
%                       values.
%                       sMeta - Table with names of samples in first column
%       thresh(double) - threshold in fraction of max intensity to consider
%   Output
%       idxCont(list) - a list of indicies(int) that represent the indicies
%                       of features that are contaminants.
%
%   Implemented by NA 2017-03-03

bF_tic = tic;

%Find blank sampels
idxBlanks = findSampleIdx(data.sMeta, 'BLANK'); %find blanks
if(isempty(idxBlanks))
    error(['Found no blanks in the given input. Check sMeta to make sure'...
         ' there are samples named BLANK.'])
end
idxNonBlanks = setdiff([1:size(data.I,2)], idxBlanks);

%Get intensity values
I = data.I;

%Extract maxI
maxI = max(I(:,idxNonBlanks)');
if(mean(maxI)>100)
    warning(['Assuming data has not been log transformed, filter will be based'...
        ' on log signals instead.']);
    maxI = log(maxI);
end

%Get idx of contaminated samples
blankMed = median(I(:,idxBlanks)')'; 
idxCont = []; %initalize
for i=1:length(blankMed)
    if(blankMed(i)/maxI(i)>thresh)
        idxCont = [idxCont, i];
    end
end

bF_toc = toc(bF_tic);
if(dispFlag>0)
    disp(['---'])
    disp(['Finnished running blank filter.'])
    disp(['Elapsed time was %0.3f secs\n', bF_toc'])
    disp(['Number of contaminants found: ' num2str(length(idxCont))])
    disp(['---'])
end

end

