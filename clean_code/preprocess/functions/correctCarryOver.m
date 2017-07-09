function [ Iclean ] = correctCarryOver( I, runorder, Tl, Tu, thresh, dispFlag)
%CORRECTCARRYOVER Corrects carry over effect from subsequent samples
%   Parameters, how far back? (1 samples enough?)
%   Algorithm:
%       1. For each sample (i)
%           a) for each feature (j)
%               i) Potential carry over is I(j,(i-1)) = Iparent
%               ii) if Iparent*Tl<I(j,i)<Iparent*Tu
%                       set value to NA
%
%   Input:
%       I
%       Tl - lower threshold of fraction of size that carry over must be
%       over. (0.01)
%       Tu - upper threshold of fraction of size that carry over must be
%       under to be carry over (instead of actual true signal). (0.1)
%       runorder - runorder of samples
%       thresh - threshold of intensity that needs to be considered for a
%       feature to produce carry over effects.
%   Output:
%       Iclean
%   Implemented by NA 2017-03-13

cCO_tic = tic;

%Make sure data is logged
if(max(max(I))>100)
    warning(['Data is probably not log transformed. Algorithm can only'...
        ' be applied on log transformed data.'])
end

Iclean = I;

numSamp = size(I,2);
numFeat = size(I,1);
numCarryOver = 0;
for i=1:numSamp
    idxParent = find(runorder==runorder(i)-1); %Find parent sample, idxParent
    if(not(isempty(idxParent)))
        for j=1:numFeat
            Iparent = I(j, idxParent);
            if(Iparent+log(Tl)<I(j,i)<Iparent+log(Tu) && Iparent>thresh)
                Iclean(j,i) = nan; %carry over
                numCarryOver =  numCarryOver +1;
            end
        end
    else
        if(runorder(i)~=1)
            warning(['Found no parent for sample ' num2str(i)])
        end
    end
end

cCO_toc = toc(cCO_tic);

if(dispFlag>0)
    disp(['---'])
    disp(['Carry over correction finnished.'])
    disp(['Elapsed time was %0.3f secs\n', cCO_toc'])
    disp(['Found ' num2str(numCarryOver) ' carry over effects.'])
    disp(['---'])
end
end

