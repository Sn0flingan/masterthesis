function [ b ] = bVariance( X, idx_classes )
%BVARIANCE Calculates the between variance of classes
%   Algorithm:
%       1. Extract data to be used (only the defined classes are used)
%       2. Calculate between variance
%   Input
%       idx_classes(cell array) - each cell contains indecies for one class
%   Output:
%       b(double) - between variance value as defined by algorithm.
%
%   Implemented by NA 2017-03-07

%Construct global data
Xglob = [];
for i=1:length(idx_classes)
    Xglob = [Xglob, X(:, idx_classes{i})];
end

%Calculate between variance
m = mean(Xglob'); %global mean
b = 0; %initalize
for i=1:length(idx_classes)
    mClass = mean(X(:,idx_classes{i})');
    b = b + norm(mClass-m);
end
b = b/length(idx_classes);

end

