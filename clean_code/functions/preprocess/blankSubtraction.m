function [ Iclean ] = blankSubtraction( Isamples, Iblanks, dispFlag)
%BLANKSUBTRACTION Removes background in blanks from samples
%   Algorithm:
%       1. Calculate median of blanks
%       2. Subtract (1) from all samples
%       ASSUMES ALL INTENSITIES ARE NATURAL LOGARITHM OF INTENSITIES!!!! features as rows. Make sure blanks
%                          are not present in this data
%       Iblanks(matrix)  - matrix with all blanks to be used for cleaning. 
%                          Samples as columns, features as rows.
%   Output:
%       Iclean(matrix)   - matrix with Isamples cleaned. Samples as columns
%                          features as rows.
%
%   Implemented by NA 2017-03-13

if(max(max(Iblanks))>1000 || max(max(Isamples))>1000)
    warning('Intensity signals high, assuming that values are NOT logarithm intensities. Output will be logarithmed')
else
    Iblanks = exp(Iblanks);
    Isamples = exp(Isamples);
end

tic_bs = tic; %Start watch
Iblanks(isnan(Iblanks)) = 0;
Isamples(isnan(Isamples)) = 0;
thresh = min(Isamples(Isamples>1));

IblanksMedian = median(Iblanks')';
Iclean = Isamples - IblanksMedian*ones(1,size(Isamples,2));
Iclean(Iclean<thresh) = 1; %make sure no values below thresh exists

toc_bs = toc(tic_bs);

%Report results
numFeatCleaned = numel(find(IblanksMedian>0));
if(dispFlag>0)
    disp(['---'])
    disp(['Blank Subtraction finnished.'])
    disp(['Time to complete: ', num2str(toc_bs) 's .'])
    disp(['Number of features cleaned: ' num2str(numFeatCleaned)...
        '(' num2str(numFeatCleaned/size(Iclean,1)*100) '% of features)'])
    medianCleaned = median(IblanksMedian(IblanksMedian>0));
    medianSamples = median(median(Isamples(Isamples>0)));
    disp(['Median feature I cleaned: ' num2str(medianCleaned)...
        '(' num2str(medianCleaned/medianSamples*100) ' % of sample median)'])
    disp(['Maximum feature I cleaned: ' num2str(max(IblanksMedian))...
        '(' num2str(max(IblanksMedian)/max(max(Isamples))*100) '% of sample max)'])
    disp(['---'])
    if(dispFlag>1)
        maxLim = max(max([Isamples Iclean]));
        minLim = min(min([Isamples Iclean]));
        cLim = [minLim maxLim];
        figure();
        subplot(1,2,1)
        imagesc(Isamples, cLim)
        colorbar()
        title('Intensities of samples before blank subtraction')
        subplot(1,2,2)
        imagesc(Iclean, cLim)
        colorbar()
        title('Intensities of samples after blank subtraction')
    end
end

Iclean = log(Iclean); %Restore to logarithm

end

