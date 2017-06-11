function [ std ] = medianStd( X )
%MEDIANSTD Calculates the median std columnwise
%   Algorithm:
%       1. Calculate the median of each column
%       2. Calculate std = sqrt(sum((X-Xmed).^2)./(N-1))
%   Input:
%       X(matrix) - numerical matrix (no 'nan'/'inf' allowed). 
%   Output:
%       std(vector) - the median standard deviation of each column of X.
%
%   Implemented by NA 2017-03-06

X(isnan(X)) = 0;

%Make sure row vectors can be calculated properly
if(size(X,1)==1 && size(X,2)>1)
    X = X';
end

N = size(X,1);
Xmed = ones(N,1)*median(X);
std = sqrt(sum((X-Xmed).^2)./(N-1));
end

