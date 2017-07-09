function [ Icor ] = correctRunorderDecay_rl( I, runorder )
%CORRECTRUNORDERDECAY Corrects decay by runorder using robust loess
%   Algorithm:
%       1. for each feature:
%           a) get reference I for feature as median of 50% first values
%           b) fit a curve to intensity values/runorder using smoothing 
%              splines
%           c) set I corrected to reference I + residuals to curve
%   Input:
%       I(matrix) - samples as columns, features as rows. 
%       runorder   - runorder for each sample in I. Must match up with
%                    sample order of I.
%   Output:
%       Icor(matrix) - Intensity values corrected for runorder decay. Same
%                      order of samples as input. Samples as columns, 
%                      features as rows.
%   
%   Implemented by NA 2017-03-13

%Parameters
span = 0.70; %Span to be used in fitting with smoothing splines

numFeat = size(I,1);
numSamp = size(I,2);
tic
for i=1:numFeat
    refSampIdx = 1:int8(numSamp/2); %get first 50% of data
    Iref = median(I(i,refSampIdx));
    xdata = runorder;
    ydata = I(i,:)';
    %real fit
    tic
    yy = smooth(xdata, ydata, span, 'rloess');
    toc
    residuals = ydata - yy;
    fdata = Iref + residuals; %correct non outliers
    Icor(i,:) = fdata;
end
toc

end

