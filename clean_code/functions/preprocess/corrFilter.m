function [ idxRm ] = corrFilter( I, idxRep, minCorr )
%CORRFILTER Removes outliers(based on replicate simmilarity) from the dataset
%   Algorithm:
%       1. Calculate the median of all replicates to use as reference
%       2. Calculate pearsson correlation rho between replicates and
%       reference. Exclude if rho<minCorr.
%   Input:
%       I(matrix) - Intensity values as doubles in matrix
%                   features as rows, samples as columns. Either log
%                   transformed or raw. Does not handle relative
%                   values.
%       minCorr(double) - threshold value for pearssons correlation rho
%                         between replicate and median replicate.
%       idxRep(list) - a list of indicies for replicates within one class.
%   Output:
%       idxCont(list) - a list of indicies for features that are
%                       outliers based on replicate simmilarity.
%
%   Implemented by NA 2017-03-03

%Don't remove anything if there are no replicates
if(length(idxRep)<2)
    idxRm = [];
    return
end

Imed = median(I(:,idxRep)')'; %construct median, copy 
rho = corr(I(:,idxRep), Imed); %compare each replicate with median
idxRm = idxRep(find(rho<minCorr)); %find which ones to remove

end

